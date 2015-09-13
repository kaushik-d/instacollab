package com.instacollab.mail;

import java.util.Properties;

import javax.mail.Message;
import javax.mail.MessagingException;
import javax.mail.PasswordAuthentication;
import javax.mail.Session;
import javax.mail.Transport;
import javax.mail.internet.AddressException;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeMessage;
import javax.servlet.ServletContext;

public class sendMail {
	
	private String host = null;
	private String from = null;
	private String pass = null;
	private String port = null;
	
	public sendMail(ServletContext context){

		host = context.getInitParameter("emailhost");
		from = context.getInitParameter("emailfrom");
		pass = context.getInitParameter("emailpasswd");
		port = context.getInitParameter("emailport");
		
	}
	public void SendingEmail(String Email, String Body)
			throws AddressException, MessagingException {

		//String host = "smtp.gmail.com";
		//final String from = "instacollabdotcom@gmail.com";
		//final String pass = "serampore1";
		
		Properties props = System.getProperties();
		props.put("mail.smtp.starttls.enable", "true");
		//props.put("mail.smtp.starttls.enable", "false");
		
		props.put("mail.smtp.host", host);
		props.put("mail.smtp.user", from);
		props.put("mail.smtp.password", pass);
		
		props.put("mail.smtp.port", port);
		//props.put("mail.smtp.port", "2525");
		//props.put("mail.smtp.port", "465");
		
		props.put("mail.smtp.auth", "true");
		String[] to = { Email }; // To Email addressR
		
		//Session session = Session.getDefaultInstance(props, null);
		
		Session session = Session.getDefaultInstance(props,
				new javax.mail.Authenticator() {
					protected PasswordAuthentication getPasswordAuthentication() {
						return new PasswordAuthentication(from,pass);
					}
				});
		
		MimeMessage message = new MimeMessage(session);
		message.setFrom(new InternetAddress(from));
		
		InternetAddress[] toAddress = new InternetAddress[to.length];
		// To get the array of addresses
		for (int i = 0; i < to.length; i++) { // changed from a while loop
			toAddress[i] = new InternetAddress(to[i]);
		}
		//System.out.println(Message.RecipientType.TO);
		for (int j = 0; j < toAddress.length; j++) { // changed from a while
														// loop
			message.addRecipient(Message.RecipientType.TO, toAddress[j]);
		}
		
		message.setSubject("Email from www.InstaCollaboration.com");

		message.setContent(Body, "text/html");
		
		Transport transport = session.getTransport("smtp");
		transport.connect(host, from, pass);
		transport.sendMessage(message, message.getAllRecipients());
		transport.close();
	}
}
