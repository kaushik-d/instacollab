package com.instacollab.chat;

import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.sql.Blob;
import java.sql.SQLException;

import javax.servlet.ServletContext;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.google.gson.Gson;

/**
 * Servlet implementation class downloadFile
 */
@WebServlet("/downloadFile")
public class downloadFile extends HttpServlet {
	private static final long serialVersionUID = 1L;
	private static final int BUFFER_SIZE = 4096; 
       
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		
		String json = request.getParameter("data");
		
		Gson gson = new Gson();
		
		commandToClient MeetingRoomData = gson.fromJson(json, commandToClient.class);
		
		ServletContext context = getServletContext();

		DBconnection dBconnection = new DBconnection();
		Blob blob = dBconnection.getFileFromDb(MeetingRoomData);
		
		
		InputStream inputStream = null;
		int fileLength = 0;
		
		try {
			inputStream = blob.getBinaryStream();
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
        
        if(inputStream!=null) {
        	fileLength = inputStream.available();
        }
        
        String mimeType = "application/octet-stream";
         
        response.setContentType(mimeType);
        response.setContentLength(fileLength);
        
        OutputStream outStream = response.getOutputStream();
        
        byte[] buffer = new byte[BUFFER_SIZE];
        int bytesRead = -1;
         
        while ((bytesRead = inputStream.read(buffer)) != -1) {
            outStream.write(buffer, 0, bytesRead);
        }
         
        inputStream.close();
        outStream.close();
		
	}

}
