package com.instacollab.chat;

import java.io.IOException;
import java.io.InputStream;
import java.util.HashMap;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.Part;

import com.google.gson.Gson;

@WebServlet("/joinMeeting")
public class joinMeeting extends HttpServlet {
	private static final long serialVersionUID = 1L;
	private static HashMap<String,meetingRoomData> meetingRooms;

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

		String json = request.getParameter("data");
		
		Gson gson = new Gson();
		
		meetingRoomData MeetingRoomData = gson.fromJson(json, meetingRoomData.class);
		
		if(MeetingRoomData.getFunction().contains("joinMeeting")) {
			if(meetingRooms.containsKey(MeetingRoomData.getMeetingRoomNumber())){
				//request.getRequestDispatcher("/canvas.jsp").forward(request, response);
				response.getWriter().write("/instacollab/canvas.jsp?room="+MeetingRoomData.getMeetingRoomNumber());
			} 
			else {
				MeetingRoomData.setFunction("MeetingRoomNotFound");
				response.getWriter().write(gson.toJson(MeetingRoomData,meetingRoomData.class));
			}
		}
	}
	
	@SuppressWarnings("unchecked")
	@Override
	public void init(){
		meetingRooms = (HashMap<String, meetingRoomData>) getServletConfig().getServletContext().getAttribute("meetingRoomList");
		if(meetingRooms == null){
			meetingRooms = new HashMap<String,meetingRoomData>();
			getServletConfig().getServletContext().setAttribute("meetingRoomList", meetingRooms);
		}
	}

}
