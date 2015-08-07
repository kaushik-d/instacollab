package com.instacollab.chat;

public class DBCleanup implements Runnable {

	@Override
	public void run() {
		DBconnection dBconnection = new DBconnection();
		dBconnection.doDBCleanup();
	}

}