package com.instacollab.chat;

import java.io.IOException;

import javax.servlet.Filter;
import javax.servlet.FilterChain;
import javax.servlet.FilterConfig;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.annotation.WebFilter;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
 
//import com.google.inject.Singleton;
 
//@Singleton
@WebFilter(filterName="filter1", urlPatterns={"/index.jsp","/canvas.jsp","/login"})
public class BrowserFilter implements Filter
{
    private static final String[] DEFAULT_BROWSERS =
    	 { "Firefox" };
  //  { "Chrome", "Firefox", "Safari", "Opera", "MSIE 8", "MSIE 7", "MSIE 6" };
 
    // Filter param keys
    //public static final String KEY_BROWSER_IDS = "browserIds";
    //public static final String KEY_BAD_BROWSER_URL = "badBrowserUrl";
 
    // Configured params
    private String[] browserIds;
    private String badBrowserUrl;
 
    
    @Override
    public void init(FilterConfig cfg) throws ServletException
    {
        //String ids = cfg.getInitParameter(KEY_BROWSER_IDS);
    	String ids = null;
        this.browserIds = (ids != null)?ids.split(","):DEFAULT_BROWSERS;
 
        //badBrowserUrl = cfg.getInitParameter(KEY_BAD_BROWSER_URL);
        badBrowserUrl = "badbrowser.html";
        if (badBrowserUrl == null)
        {
            throw new IllegalArgumentException("BrowserFilter requires param badBrowserUrl");
        }
    }
    
 
    @Override
    public void doFilter(ServletRequest req, ServletResponse resp, FilterChain chain)
        throws IOException, ServletException
    {
        String userAgent = ((HttpServletRequest) req).getHeader("User-Agent");
        for (String browser_id : browserIds)
        {
            if (userAgent.contains(browser_id))
            {
                chain.doFilter(req, resp);
                return;
            }
        }
        // Unsupported browser
        ((HttpServletResponse) resp).sendRedirect(this.badBrowserUrl);
    }
 
    @Override
    public void destroy()
    {
        this.browserIds = null;
    }
}
