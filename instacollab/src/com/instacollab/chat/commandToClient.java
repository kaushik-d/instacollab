package com.instacollab.chat;

public class commandToClient {
	
	private String command;
	private String room;
	private String canvasID;
	private boolean isPresentation = false;
	private String presentationURI = "NotAPresentation";
	private String email;
	private String topic;
	private String name;
	
	public commandToClient(){
		
		
	}

	public commandToClient(String command, String room, String nickname,
			boolean isPresentation, String presentationURI, String email, String topic, String name){
		this.command = command;
		this.room = room;
		this.canvasID = nickname;
		this.isPresentation = isPresentation;
		this.presentationURI = presentationURI;
		this.email = email;
		this.topic = topic;
		this.name = name;
	}
	
	String getRoomNumber(){
		return room;
	}
}
