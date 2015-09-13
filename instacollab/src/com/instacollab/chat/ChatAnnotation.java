/*
 *  Licensed to the Apache Software Foundation (ASF) under one or more
 *  contributor license agreements.  See the NOTICE file distributed with
 *  this work for additional information regarding copyright ownership.
 *  The ASF licenses this file to You under the Apache License, Version 2.0
 *  (the "License"); you may not use this file except in compliance with
 *  the License.  You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 *  Unless required by applicable law or agreed to in writing, software
 *  distributed under the License is distributed on an "AS IS" BASIS,
 *  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 *  See the License for the specific language governing permissions and
 *  limitations under the License.
 */
package com.instacollab.chat;

import java.io.IOException;
import java.util.HashMap;
import java.util.Locale;
import java.util.Set;
import java.util.concurrent.ConcurrentHashMap;
import java.util.concurrent.CopyOnWriteArraySet;
import java.util.concurrent.atomic.AtomicInteger;

import javax.servlet.ServletContext;
import javax.servlet.http.HttpSession;
import javax.websocket.EndpointConfig;
import javax.websocket.OnClose;
import javax.websocket.OnError;
import javax.websocket.OnMessage;
import javax.websocket.OnOpen;
import javax.websocket.Session;
import javax.websocket.server.PathParam;
import javax.websocket.server.ServerEndpoint;

//import util.HTMLFilter;









import com.google.gson.Gson;

import java.util.logging.Level;
import java.util.logging.Logger;

@ServerEndpoint(value = "/websocket/chat/{room}", configurator = ServletAwareConfig.class)
public class ChatAnnotation {

	private static final Logger log = Logger.getLogger(ChatAnnotation.class
			.getName());
	private EndpointConfig config;
	private static final String GUEST_PREFIX = "S";
	private static final AtomicInteger connectionIds = new AtomicInteger(0);
	private static final ConcurrentHashMap<String, CopyOnWriteArraySet<ChatAnnotation>> roomToConnections = new ConcurrentHashMap<String, CopyOnWriteArraySet<ChatAnnotation>>();
	private static final ConcurrentHashMap<String, Integer> roomToCurrentPage = new ConcurrentHashMap<String, Integer>();

	private Set<String> receivedDrawMessages = new CopyOnWriteArraySet<String>();

	private final String nickname;
	private Session session;
	private meetingRoomData MeetingRoomData = null;

	public ChatAnnotation() {
		nickname = GUEST_PREFIX + connectionIds.getAndIncrement();
		MeetingRoomData = new meetingRoomData();
	}

	@OnOpen
	public void start(Session session, @PathParam("room") final String room,
			EndpointConfig config) {
		this.session = session;
		this.config = config;

		session.setMaxIdleTimeout(0);
		String roomUpper = room.toUpperCase(Locale.ROOT);
		
		ServletContext servletContext = (ServletContext) config
				.getUserProperties().get("servletContext");
		//@SuppressWarnings("unchecked")
		//HashMap<String, meetingRoomData> meetingRooms = (HashMap<String, meetingRoomData>) servletContext
		//		.getAttribute("meetingRoomList");

		//MeetingRoomData = null; 
		
		//if (meetingRooms.containsKey(room)) {
		//	MeetingRoomData = meetingRooms.get(room);
		DBconnection dBconnection = new DBconnection(servletContext);
		boolean roomFound = dBconnection.getRoomData(roomUpper, MeetingRoomData);
		if(!roomFound) {
			try {
				session.close();
			} catch (IOException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
			return; // Meeting room not found
		}

		session.getUserProperties().put("room", roomUpper);

		if (!roomToConnections.containsKey(roomUpper)) {
			CopyOnWriteArraySet<ChatAnnotation> connections = new CopyOnWriteArraySet<ChatAnnotation>();
			connections.add(this);
			roomToConnections.put(roomUpper, connections);
		} else {
			roomToConnections.get(roomUpper).add(this);
		}

		commandToClient CommandToClient = new commandToClient(
				"initCanvasSlave", roomUpper.trim(), nickname,
				MeetingRoomData.getisPresentation(),
				MeetingRoomData.getPresentationURI(),
				MeetingRoomData.getEmail(),
				MeetingRoomData.getTopic(),
				MeetingRoomData.getName(),
				MeetingRoomData.getCurrentPage());
		
		Gson gson = new Gson();
		String message = gson.toJson(CommandToClient, commandToClient.class);
		
		broadcast(session, message, nickname, true, MeetingRoomData);
		firstMessageToOwn(this, session, nickname, MeetingRoomData);
	}

	@OnClose
	public void end(final Session session) {
		String room = (String) session.getUserProperties().get("room");

		roomToConnections.get(room).remove(this);
		
		commandToClient CommandToClient = new commandToClient(
				"finalizeCanvasSlave", room.trim(), nickname,
				MeetingRoomData.getisPresentation(),
				MeetingRoomData.getPresentationURI(),
				MeetingRoomData.getEmail(),
				MeetingRoomData.getTopic(),
				MeetingRoomData.getName(),
				MeetingRoomData.getCurrentPage());
		
		Gson gson = new Gson();
		String message = gson.toJson(CommandToClient, commandToClient.class);
		
		broadcast(session, message, nickname, false, MeetingRoomData);
	}

	@OnMessage
	public void incoming(final Session session, String message) {
		//
		// HttpSession httpSession = (HttpSession)
		// config.getUserProperties().get("httpSession");
		// ServletContext servletContext = httpSession.getServletContext();
		//
		String filteredMessage = message.toString();
		boolean toAllButMe = true;
		if (filteredMessage.contains("drawLinesSlave")) {
			receivedDrawMessages.add(filteredMessage);
		} else if (filteredMessage.contains("textMessage")) {
			toAllButMe = false;
		} else if (filteredMessage.contains("changePage")) {
			Gson gson = new Gson();
			commandToClient receivedMsg = gson.fromJson(message, commandToClient.class);
			MeetingRoomData.setCurrentPage(receivedMsg.getCurrentPage());
			roomToCurrentPage.put(MeetingRoomData.getMeetingRoomNumber(), receivedMsg.getCurrentPage());
		}
		broadcast(session, filteredMessage, nickname, toAllButMe, MeetingRoomData);
	}

	@OnError
	public void onError(Throwable t) throws Throwable {
		log.log(Level.WARNING, "Chat Error: " + t.toString(), t);
	}

	private static void broadcast(Session session, String msg, String nickname,
			boolean toAllButMe, meetingRoomData MeetingRoomData) {
		String room = (String) session.getUserProperties().get("room");
		CopyOnWriteArraySet<ChatAnnotation> connections = roomToConnections
				.get(room);

		for (ChatAnnotation client : connections) {

			if (toAllButMe && nickname == client.nickname) {
				continue;
			}
			sendMessage(session, msg, nickname, room, client, MeetingRoomData);
		}
	}

	private static void sendMessage(Session session, String msg,
			String nickname, String room, ChatAnnotation client, meetingRoomData MeetingRoomData) {

		try {
			synchronized (client) {
				client.session.getBasicRemote().sendText(msg);
			}
		} catch (IOException e) {
			log.log(Level.WARNING,
					"Chat Error: Failed to send message to client", e);
			CopyOnWriteArraySet<ChatAnnotation> connections = roomToConnections
					.get(room);
			connections.remove(client);
			try {
				client.session.close();
			} catch (IOException e1) {
				// Ignore
			}

			commandToClient CommandToClient = new commandToClient(
					"finalizeCanvasSlave", room.trim(), nickname,
					MeetingRoomData.getisPresentation(),
					MeetingRoomData.getPresentationURI(),
					MeetingRoomData.getEmail(),
					MeetingRoomData.getTopic(),
					MeetingRoomData.getName(),
					MeetingRoomData.getCurrentPage());
			
			Gson gson = new Gson();
			String message = gson.toJson(CommandToClient, commandToClient.class);
			broadcast(session, message, nickname, false, MeetingRoomData);
		}
	}

	private static void firstMessageToOwn(ChatAnnotation client,
			Session session, String nickname, meetingRoomData MeetingRoomData) {
		// String room = (String)
		// client.session.getUserProperties().get("room");
		String room = (String) session.getUserProperties().get("room");
		CopyOnWriteArraySet<ChatAnnotation> connections = roomToConnections
				.get(room);
		
		int currentPage = 0;
		if(roomToCurrentPage.containsKey(room.trim())){
			currentPage = roomToCurrentPage.get(room.trim());
			MeetingRoomData.setCurrentPage(currentPage);
		
		} else {
			MeetingRoomData.setCurrentPage(currentPage);
		}
		
		commandToClient CommandToClient = new commandToClient(
				"setMySlaveID", room.trim(), client.nickname,
				MeetingRoomData.getisPresentation(),
				MeetingRoomData.getPresentationURI(),
				MeetingRoomData.getEmail(),
				MeetingRoomData.getTopic(),
				MeetingRoomData.getName(),
				currentPage);
		
		Gson gson = new Gson();
		String message = gson.toJson(CommandToClient, commandToClient.class);

		sendMessage(session, message, client.nickname, room, client, MeetingRoomData);

		for (ChatAnnotation otherclient : connections) {
			if (otherclient.nickname != client.nickname) {
				// Send the other client's canvas to this new client
				
				commandToClient CommandToClient1 = new commandToClient(
						"initCanvasSlave", room.trim(), otherclient.nickname,
						MeetingRoomData.getisPresentation(),
						MeetingRoomData.getPresentationURI(),
						MeetingRoomData.getEmail(),
						MeetingRoomData.getTopic(),
						MeetingRoomData.getName(),
						MeetingRoomData.getCurrentPage());
				
				//Gson gson = new Gson();
				String messageOther = gson.toJson(CommandToClient1, commandToClient.class);

				sendMessage(session, messageOther, nickname, room, client, MeetingRoomData);

				// Send the other client's draw commands to this new client
				for (String command : otherclient.receivedDrawMessages) {
					sendMessage(session, command, nickname, room, client, MeetingRoomData);
				}
			}
		}

	}

}
