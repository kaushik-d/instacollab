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

public class sendMail {

	public sendMail(){
		
	}
	public void SendingEmail(String Email, String Body)
			throws AddressException, MessagingException {

		//String host = "smtp.gmail.com";
		//String from = "instacollabdotcom@gmail.com"; // Your mail id
		//String pass = "Serampore1"; // Your Password
		
		String host = "mail.instacollaboration.com";
		//String host = "mocha6005.mochahost.com";
		
		String from = "webmaster@instacollaboration.com"; // Your mail id
		String pass = "serampore"; // Your Password
		
		Properties props = System.getProperties();
		//props.put("mail.smtp.starttls.enable", "true"); // added this line
		props.put("mail.smtp.starttls.enable", "false");
		props.put("mail.smtp.host", host);
		props.put("mail.smtp.user", from);
		props.put("mail.smtp.password", pass);
		
		//props.put("mail.smtp.port", "587");
		props.put("mail.smtp.port", "2525");
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
		
		message.setSubject("Email from InstaCollab");

		message.setContent(Body, "text/html");
		
		Transport transport = session.getTransport("smtp");
		transport.connect(host, from, pass);
		transport.sendMessage(message, message.getAllRecipients());
		transport.close();
	}
}
