package com.instacollab.chat;

import com.google.gson.stream.JsonWriter;

import java.sql.Connection;
import java.io.IOException;
//import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStreamWriter;
import java.sql.Blob;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
import java.sql.SQLException;
import java.sql.Types;

import javax.servlet.ServletContext;
import javax.servlet.http.HttpServletResponse;

import com.google.gson.stream.JsonWriter;

//import javax.servlet.ServletContext;

public class DBconnection {

	private String dbName  = "rooms";
	private String dbTable = "roomdata";
	private String feedbackDbTable = "feedbacks";
	
	private String dbURL   = null;
	private String dbUser  = null;
	private String dbPass  = null;
	
	//private static String dbURL   = "jdbc:mysql://localhost:3306/" + dbName;
	//private static String dbURL   = "jdbc:mysql://my-db-instance.cqkmpcckfpyh.us-east-1.rds.amazonaws.com:3306/" + dbName;
	//private static String dbUser  = "root";
	//private static String dbUser  = "db_user";
	//private static String dbPass  = "1234";
	//private static String dbPass  = "serampore";
	
	public DBconnection(ServletContext context) {
		
		dbURL  = "jdbc:mysql://" + context.getInitParameter("dbURL") + "/" + dbName;
		dbUser = context.getInitParameter("dbUser");
		dbPass = context.getInitParameter("dbPasswd");

	}
	
	public boolean getFeedbackFromDb(String days, HttpServletResponse response){
		
		Connection conn = null;
		ResultSet result = null;
		boolean success = true;
		try {
			
			DriverManager.registerDriver(new com.mysql.jdbc.Driver());
			conn = DriverManager.getConnection(dbURL, dbUser, dbPass);

			String sql = "SELECT * FROM "
					+ feedbackDbTable
					+ " WHERE (create_datetime >= ?)";
			
			PreparedStatement statement = conn.prepareStatement(sql);
			
			long daysInMS = 365*24*60*60*1000;
			
			if(days.contains("1")) {
				daysInMS = 1*24*60*60*1000;
			} else if (days.contains("7")) {
				daysInMS = 7*24*60*60*1000;
			} else if (days.contains("30")) {
				daysInMS = 30*24*60*60*1000;
			} else {
				daysInMS = 365*24*60*60*1000;
			}
			
			statement.setTimestamp(1, new java.sql.Timestamp(System.currentTimeMillis()-daysInMS));

			result  = statement.executeQuery();
			
			response.setContentType("application/json; charset=UTF-8");
			response.setCharacterEncoding("UTF-8");
			JsonWriter writer = new JsonWriter(new OutputStreamWriter(
					response.getOutputStream(), "UTF-8"));
			writer.setLenient( true );
			writer.beginArray();
			while (result.next()) {
				writer.beginObject();
				ResultSetMetaData rsmd = result.getMetaData();

				for (int idx = 1; idx <= rsmd.getColumnCount(); idx++) {
					writer.name(rsmd.getColumnLabel(idx));
					writer.value(result.getString(idx));
				}
				writer.endObject();
			}
			writer.endArray();
			
			writer.close();
			response.getOutputStream().flush();
			
		} catch (SQLException | IOException ex) {
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
		
		return success;
		
	}
	
	public boolean saveFeedbackToDb(String name, String email, String comments, String IP) {
		
		Connection conn = null;
		boolean isSaveSuccess = true;
		try {
			
			DriverManager.registerDriver(new com.mysql.jdbc.Driver());
			conn = DriverManager.getConnection(dbURL, dbUser, dbPass);

			String sql = "INSERT INTO "
					+ feedbackDbTable
					+ " (name, email, comments,"
					+ " create_datetime, IPaddress) values (?, ?, ?, ?, ?)";
			PreparedStatement statement = conn.prepareStatement(sql);

			statement.setString(1, name);
			statement.setString(2, email);
			statement.setString(3, comments);
			statement.setTimestamp(4,
					new java.sql.Timestamp(System.currentTimeMillis()));
			statement.setString(5, IP);

			int row = statement.executeUpdate();
			if (row > 0) {
			}
		} catch (SQLException ex) {
			ex.printStackTrace();
			isSaveSuccess = false;
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
		
		return isSaveSuccess;
	}

	public void saveToDb(meetingRoomData roomData, InputStream fileContent) {
		Connection conn = null; // connection to the database
		try {
			// connects to the database
			DriverManager.registerDriver(new com.mysql.jdbc.Driver());
			conn = DriverManager.getConnection(dbURL, dbUser, dbPass);
			//String urlWithIDpassWd = dbURL + "?user=" + dbUser +"&password=" + dbPass;
			//conn = DriverManager.getConnection(urlWithIDpassWd);

			// constructs SQL statement
			String sql = "INSERT INTO "
					+ dbTable
					+ " (isPresentation, host_name, meeting_topic, presentationURI,"
					+ " roomNumber, fileContent, create_datetime, start_datetime,"
					+ " end_datetime, IPaddress, email) values (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
			PreparedStatement statement = conn.prepareStatement(sql);

			statement.setBoolean(1, roomData.getisPresentation());
			statement.setString(2, roomData.getName());
			statement.setString(3, roomData.getTopic());
			statement.setString(4, roomData.getPresentationURI());
			statement.setString(5, roomData.getMeetingRoomNumber());
			statement.setTimestamp(7,
					new java.sql.Timestamp(System.currentTimeMillis()));
			statement.setNull(8, Types.TIMESTAMP);
			statement.setNull(9, Types.TIMESTAMP);
			
			
			
			//statement.setTimestamp(7,
			//		new java.sql.Timestamp(year, month, date, hour, minute, second, nano));
			
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
			}
		} catch (SQLException ex) {
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

	Blob getFileFromDb(commandToClient CommandToClient) {

		Blob blob = null;
		String meetingRoomNum = CommandToClient.getRoomNumber();

		Connection conn = null; // connection to the database

		try {
			// connects to the database
			DriverManager.registerDriver(new com.mysql.jdbc.Driver());
			conn = DriverManager.getConnection(dbURL, dbUser, dbPass);

			// queries the database
			String sql = "SELECT * FROM " + dbTable
					+ " WHERE roomNumber = ?";
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

	boolean getRoomData(String meetingRoomNum, meetingRoomData MeetingRoomData) {

		Connection conn = null; // connection to the database
		boolean roomFound = false;

		try {
			// connects to the database
			DriverManager.registerDriver(new com.mysql.jdbc.Driver());
			conn = DriverManager.getConnection(dbURL, dbUser, dbPass);

			// queries the database
			String sql = "SELECT * FROM " + dbTable
					+ " WHERE roomNumber = ?";
			PreparedStatement statement = conn.prepareStatement(sql);
			statement.setString(1, meetingRoomNum);

			ResultSet result = statement.executeQuery();
			if (result.next()) {

				String functName = null;
				boolean isPresentation = result.getBoolean("isPresentation");
				String name = result.getString("host_name");
				String topic = result.getString("meeting_topic");
				String presentationURI = result.getString("presentationURI");
				String roomNumber = result.getString("roomNumber");
				String meetingHostIP = result.getString("IPaddress");
				String email = result.getString("email");

				MeetingRoomData.fillUp(functName, isPresentation, name,
						topic, presentationURI, roomNumber, meetingHostIP,
						email);
				
				roomFound = true;

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

		return roomFound;

	}

	
	boolean isRoomNumberAlreadyActive(String meetingRoomNum) {

		Connection conn = null; // connection to the database
		boolean isExisists = false;

		try {
			// connects to the database
			DriverManager.registerDriver(new com.mysql.jdbc.Driver());
			conn = DriverManager.getConnection(dbURL, dbUser, dbPass);

			// queries the database
			String sql = "SELECT * FROM " + dbTable
					+ " WHERE (roomNumber = ?) AND (create_datetime >= ?)";
			PreparedStatement statement = conn.prepareStatement(sql);
			statement.setString(1, meetingRoomNum);
			statement.setTimestamp(2, new java.sql.Timestamp(System.currentTimeMillis()-24*60*60*1000));

			ResultSet result = statement.executeQuery();
			if (result.next()) {
				isExisists = true;
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

		return isExisists;
	}
	
	boolean doDBCleanup() {

		Connection conn = null; // connection to the database
		boolean done = false;

		try {
			// connects to the database
			DriverManager.registerDriver(new com.mysql.jdbc.Driver());
			conn = DriverManager.getConnection(dbURL, dbUser, dbPass);

			// queries the database
			String sql = "UPDATE " + dbTable + " SET "
					+ " fileContent ='' WHERE create_datetime <= ?";
			PreparedStatement statement = conn.prepareStatement(sql);
			
			statement.setTimestamp(1, new java.sql.Timestamp(System.currentTimeMillis()-24*60*60*1000));

			int result = statement.executeUpdate();
			
			if (result >0 ) {
				done = true;
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

		return done;

	}
	
}
