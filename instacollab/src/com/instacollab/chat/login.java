package com.instacollab.chat;

import java.io.IOException;
import java.io.InputStream;
import java.util.HashMap;

import javax.mail.MessagingException;
import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.Part;

import com.google.gson.Gson;
import com.instacollab.mail.sendMail;

/**
 * Servlet implementation class login
 */
@WebServlet("/login")
@MultipartConfig(maxFileSize = 16177215)
public class login extends HttpServlet {
	private static final long serialVersionUID = 1L;
	//private static HashMap<String, meetingRoomData> meetingRooms;

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse
	 *      response)
	 */
	protected void doGet(HttpServletRequest request,
			HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		// doGet(request,response);
	}

	protected void doPost(HttpServletRequest request,
			HttpServletResponse response) throws ServletException, IOException {

		if(varifyCaptcha(request, response)){
		
			createRoom(request, response);
		
		}
		
		

	}
	
	boolean createRoom(HttpServletRequest request,
			HttpServletResponse response) throws ServletException, IOException {
		
		String topic = request.getParameter("topic");
		Part filePart = null;
		//String fileName = null;
		InputStream fileContent = null;
		String isPresentationTest = request.getParameter("isPresentation");
		boolean isPresentation = false;
		if (isPresentationTest.contains("true")) {
			isPresentation = true;
			filePart = request.getPart("presentationFile");
			//fileName = getFileName(filePart);
			fileContent = filePart.getInputStream();
		}
		String functName = request.getParameter("functName");
		String meetingHostIP = request.getRemoteAddr();
		String name = request.getParameter("name");
		String email = request.getParameter("email");
		String meetingStartDate = request.getParameter("meetingStartDate");
		String startTime = request.getParameter("startTime");
		String endTime = request.getParameter("endTime");

		Gson gson = new Gson();

		meetingRoomData MeetingRoomData = new meetingRoomData(functName,
				isPresentation, name, topic, "NotAvailable", null,
				meetingHostIP,email,meetingStartDate,startTime,endTime);

		DBconnection dBconnection = new DBconnection();
		String roomNumber = null;
		do {
			roomNumber = createMeetingRoom();
		} while (dBconnection.isRoomNumberAlreadyActive(roomNumber));
		
		MeetingRoomData.setMeetingRoomNumber(roomNumber);
		//meetingRooms.put(roomNumber, MeetingRoomData);

		
		dBconnection.saveToDb(MeetingRoomData, fileContent);
		
		sendEmailConfirmation(MeetingRoomData);
		
		MeetingRoomData.setFunction("RoomCreateSuccess");

		response.setContentType("application/json");
		response.getWriter().write(
				gson.toJson(MeetingRoomData, meetingRoomData.class));
		
		return true;
	}

	private void sendEmailConfirmation(meetingRoomData meetingRoomData) {

		
		String messageBody = "<html><body><br><p>"
				+ "Dear Customer!" + "</p><br><p>"
				+ "Thank you for using insacollaboration.com." + "\n"
				+ "Your meeting room is ready. \n"
				+ "Your meeting room number is "
				+ meetingRoomData.getMeetingRoomNumber()
				+ "<br> Please join the meeting by clicking <br>"
				+ "http://localhost:8080/instacollab/canvas.jsp?room=" 
				+ meetingRoomData.getMeetingRoomNumber() +"\n"
				+ "<p><br>-www.instacollaboration.com</body><html>";
		
		sendMail SendMail = new sendMail();
		try {
			SendMail.SendingEmail(meetingRoomData.getEmail(), messageBody);
		} catch (MessagingException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}

	}

	//@SuppressWarnings("unchecked")
	@Override
	public void init() {
		//meetingRooms = new HashMap<String, meetingRoomData>();
		//getServletConfig().getServletContext().setAttribute("meetingRoomList",
		//		meetingRooms);
		//meetingRooms = (HashMap<String, meetingRoomData>) getServletConfig().getServletContext().getAttribute("meetingRoomList");
		//if(meetingRooms == null){
		//	meetingRooms = new HashMap<String,meetingRoomData>();
		//	getServletConfig().getServletContext().setAttribute("meetingRoomList", meetingRooms);
		//}
	}

	public String createMeetingRoom() {

		int meetingRoomNumberlength = 4;
		RandomString randomString = new RandomString(meetingRoomNumberlength);
		return randomString.nextString();
	}

	private static String getFileName(Part part) {
		for (String cd : part.getHeader("content-disposition").split(";")) {
			if (cd.trim().startsWith("filename")) {
				String fileName = cd.substring(cd.indexOf('=') + 1).trim()
						.replace("\"", "");
				return fileName.substring(fileName.lastIndexOf('/') + 1)
						.substring(fileName.lastIndexOf('\\') + 1); // MSIE fix.
			}
		}
		return null;
	}
	
	private boolean varifyCaptcha(HttpServletRequest request,
			HttpServletResponse response) throws ServletException, IOException {

		String captcha = (String) request.getSession().getAttribute("captcha");
		String code = request.getParameter("code");

		if (captcha != null && code != null) {

			if (captcha.equals(code)) {
				return true;
			} else {
				
				Gson gson = new Gson();
				meetingRoomData MeetingRoomData = new meetingRoomData();
				MeetingRoomData.setFunction("CodeVarificationFail");
				response.setContentType("application/json");
				response.getWriter().write(
						gson.toJson(MeetingRoomData, meetingRoomData.class));
				
				return false;
			}
		} else {
			return false;
		}
	}

}
