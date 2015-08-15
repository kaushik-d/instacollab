package com.instacollab.chat;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import java.awt.Color;
import java.awt.Font;
import java.awt.GradientPaint;
import java.awt.Graphics2D;
import java.awt.RenderingHints;
import java.awt.image.BufferedImage;
import java.io.*;
import java.util.Random;

import javax.imageio.ImageIO;

@WebServlet("/CaptchaServlet")
public class CaptchaServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;

	public CaptchaServlet() {
		super();
		// TODO Auto-generated constructor stub
	}

	protected void processRequest(HttpServletRequest request,
			HttpServletResponse response) throws ServletException, IOException {

		int width = 100;
		int height = 30;

		char data[][] = { { 'z', 'e', 't', 'c', 'o', 'd', 'e' },
				{ 'l', 'i', 'n', 'u', 'x' },
				{ 'f', 'r', 'e', 'e', 'b', 's', 'd' },
				{ 'u', 'b', 'u', 'n', 't', 'u' }, { 'j', 'e', 'e' } };

		BufferedImage bufferedImage = new BufferedImage(width, height,
				BufferedImage.TYPE_INT_RGB);

		Graphics2D g2d = bufferedImage.createGraphics();

		Font font = new Font("Georgia", Font.BOLD, 18);
		g2d.setFont(font);

		RenderingHints rh = new RenderingHints(RenderingHints.KEY_ANTIALIASING,
				RenderingHints.VALUE_ANTIALIAS_ON);

		rh.put(RenderingHints.KEY_RENDERING,
				RenderingHints.VALUE_RENDER_QUALITY);

		g2d.setRenderingHints(rh);

		GradientPaint gp = new GradientPaint(0, 0, Color.red, 0, height / 2,
				Color.black, true);

		g2d.setPaint(gp);
		g2d.fillRect(0, 0, width, height);

		g2d.setColor(new Color(255, 153, 0));

		Random r = new Random();
		int index = Math.abs(r.nextInt()) % 5;

		//String captcha = String.copyValueOf(data[index]);
		
		
		int meetingRoomNumberlength = 5;
		RandomString randomString = new RandomString(meetingRoomNumberlength);
		String captcha = randomString.nextString();
		request.getSession().setAttribute("captcha", captcha);

		int x = 5;
		int y = 0;

		char[] catchaArray = captcha.toCharArray();
		
		for (int i = 0; i < captcha.length(); i++) {
			y = 15 + Math.abs(r.nextInt()) % 15;
			char[] catchaArray1 = {'a'};
			catchaArray1[0] = catchaArray[i];
			g2d.drawChars(catchaArray1, 0, 1, x, y);
			x += 10 + (Math.abs(r.nextInt()) % 15);
		}

		g2d.dispose();

		response.setContentType("image/png");
		OutputStream os = response.getOutputStream();
		ImageIO.write(bufferedImage, "png", os);
		os.close();
	}

	protected void doGet(HttpServletRequest request,
			HttpServletResponse response) throws ServletException, IOException {
		processRequest(request, response);
	}

	protected void doPost(HttpServletRequest request,
			HttpServletResponse response) throws ServletException, IOException {
		processRequest(request, response);
	}

}
