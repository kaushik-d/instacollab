package com.instacollab.chat;

import com.google.gson.stream.JsonWriter;

import java.io.IOException;
import java.io.OutputStreamWriter;
import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
import java.sql.SQLException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/displayfeedback")
public class displayFeedback extends HttpServlet {
	private static final long serialVersionUID = 1L;

	public displayFeedback() {
		super();
	}

	protected void doGet(HttpServletRequest request,
			HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
	}

	protected void doPost(HttpServletRequest request,
			HttpServletResponse response) throws ServletException, IOException {
		DBconnection dBconnection = new DBconnection(
				request.getServletContext());
		String days = request.getParameter("days");
		boolean result = dBconnection.getFeedbackFromDb(days, response);
		

	}

}
