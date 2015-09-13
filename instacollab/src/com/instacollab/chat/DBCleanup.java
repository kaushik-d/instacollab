package com.instacollab.chat;

import javax.servlet.ServletContext;

public class DBCleanup implements Runnable {
    private ServletContext context;
    public DBCleanup(ServletContext context) {
    	this.context = context;
    }
	@Override
	public void run() {
		DBconnection dBconnection = new DBconnection(context);
		dBconnection.doDBCleanup();
	}

}