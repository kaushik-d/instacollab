package com.instacollab.chat;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.google.gson.Gson;

/**
 * Servlet implementation class saveFeedback
 */
@WebServlet("/saveFeedback")
public class saveFeedback extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
	}

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		if(varifyCaptcha(request, response)){
			
			String name = request.getParameter("name");
			String email = request.getParameter("email");
			String comments = request.getParameter("comments");
			
			response.setContentType("application/json");
			response.getWriter().write("CommentsSaved");
		
		}
	}
	
	private boolean varifyCaptcha(HttpServletRequest request,
			HttpServletResponse response) throws ServletException, IOException {

		String captcha = (String) request.getSession().getAttribute("captcha");
		String code = request.getParameter("code");

		if (captcha != null && code != null) {

			if (captcha.equals(code)) {
				return true;
			} else {
				
				response.setContentType("application/json");
				response.getWriter().write("CaptchaError");
				
				return false;
			}
		} else {
			return false;
		}
	}

}
