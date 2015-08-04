package com.instacollab.chat;

import java.sql.Connection;
import java.io.IOException;
import java.io.InputStream;
import java.sql.Blob;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Types;

import javax.servlet.ServletContext;

public class DBconnection {

	private static String dbName = "rooms";
	private static String dbURL = "jdbc:mysql://localhost:3306/"+dbName;
	private static String dbUser = "root";
	private static String dbPass = "1234";
	private static String dbTable = "roomdata";

	public DBconnection() {

	}

	public void saveToDb(meetingRoomData roomData, InputStream fileContent) {
		Connection conn = null; // connection to the database
		String message = null; // message will be sent back to client

		try {
			// connects to the database
			DriverManager.registerDriver(new com.mysql.jdbc.Driver());
			conn = DriverManager.getConnection(dbURL, dbUser, dbPass);

			// constructs SQL statement
			String sql = "INSERT INTO " + dbTable
					+ " (isPresentation, host_name, meeting_topic, presentationURI,"
					+ " roomNumber, fileContent, create_datetime, start_datetime,"
					+ " end_datetime, IPaddress, email) values (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
			PreparedStatement statement = conn.prepareStatement(sql);
			
			statement.setBoolean(1, roomData.getisPresentation());
			statement.setString(2, roomData.getName());
			statement.setString(3, roomData.getTopic());
			statement.setString(4, roomData.getPresentationURI());
			statement.setString(5, roomData.getMeetingRoomNumber());
			statement.setTimestamp(7, new java.sql.Timestamp(System.currentTimeMillis()));
			statement.setNull(8, Types.TIMESTAMP);
			statement.setNull(9, Types.TIMESTAMP);
			statement.setString(10, roomData.getMeetingHostIP());
			statement.setString(11, roomData.getEmail());

			if (fileContent != null) {
				// fetches input stream of the upload file for the blob column
				statement.setBlob(6, fileContent);
			} else {
				statement.setNull(6, Types.BLOB);
			}

			// sends the statement to the database server
			int row = statement.executeUpdate();
			if (row > 0) {
				message = "File uploaded and saved into database";
			}
		} catch (SQLException ex) {
			message = "ERROR: " + ex.getMessage();
			ex.printStackTrace();
		} finally {
			if (conn != null) {
				// closes the database connection
				try {
					conn.close();
				} catch (SQLException ex) {
					ex.printStackTrace();
				}
			}

		}
	}
	
	Blob getFileFromDb(commandToClient CommandToClient){
		
		Blob blob = null;
		String meetingRoomNum = CommandToClient.getRoomNumber();
        
        Connection conn = null; // connection to the database
         
        try {
            // connects to the database
            DriverManager.registerDriver(new com.mysql.jdbc.Driver());
            conn = DriverManager.getConnection(dbURL, dbUser, dbPass);
 
            // queries the database
            String sql = "SELECT * FROM " + dbTable
            		+ " files_upload WHERE roomNumber = ?";
            PreparedStatement statement = conn.prepareStatement(sql);
            statement.setString(1, meetingRoomNum);
 
            ResultSet result = statement.executeQuery();
            if (result.next()) {
                blob = result.getBlob("fileContent");         
            }
        } catch (SQLException ex) {
            ex.printStackTrace();
           // response.getWriter().print("SQL Error: " + ex.getMessage());
        } finally {
            if (conn != null) {
                // closes the database connection
                try {
                    conn.close();
                } catch (SQLException ex) {
                    ex.printStackTrace();
                }
            }          
        }
        
        return blob;
		
	}

}
