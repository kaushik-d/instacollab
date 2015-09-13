<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">

<meta name="description" content="Collaborate during meetings online from any device from anywhere." />
<meta name="keywords" content="Instant Collaboration, Web Conferencing, Online Meetings, Sharing" />
<meta name="rating" content="general" />
<meta name="copyright" content="2015, Instacollaboration.com " />
<meta name="revisit-after" content="31 Days" />
<meta name="expires" content="never"> 
<meta name="distribution" content="global" /> 
<meta name="robots" content="index" />

<link rel="stylesheet" type="text/css" href="canvas.css">
<link href="base.css?v=1.0" rel="stylesheet">
<title>Start collaboration now</title>
<script
	src="https://ajax.googleapis.com/ajax/libs/jquery/1.11.3/jquery.min.js"></script>
<script src="utility.js"></script>
<script src="masterCanvas.js"></script>
<script src="slaveCanvas.js"></script>
<script src="presentationCanvas.js"></script>
<script src="chat.js"></script>
<script src="pdf.js"></script>
<script src="compatibility.js"></script>
<script>
    PDFJS.workerSrc = 'pdf.worker.js';
  </script>
<script>
	"use strict";
	var INITICANVASWIDTH = 512;
	var INITICANVASHEIGHT = 288;
	var CURRENTCANVASWIDTH = INITICANVASWIDTH;
	var CURRENTCANVASHEIGHT = INITICANVASHEIGHT;
	var MENUBARHEIGHT = 20;
	var mySlaveID = -1;
	var myMeeringRoomNum ="<%=(String) request.getParameter("room")%>";
	var savedDrawCommands = {};
	var savedDrawCommandsMaster = {};
	var isPresentation = false;
	var presentationURI = "NotAPresentation";
	var currentPage = 0;
	var canvasPresentation = null;
	var contextPresentation = null;
	var numPresentationPages = 1;
	var presentationPdf = null;
	var name = null;
	var email = null;
	var topic = null;
	var isCurrentlyFullscreen = false;
</script>
<script>
	$(document).ready(function() {

		initCanvasMaster("M0");

		Chat.initialize();
		
		addFullScreenListners()

		$("#canvasDiv").append("<div id=\"menuDiv\"></div>");
		$("#menuDiv").css(
				{"height":MENUBARHEIGHT,
					"top":CURRENTCANVASHEIGHT-MENUBARHEIGHT,
		//			"top": "2px",
					//"buttom":CURRENTCANVASHEIGHT-MENUBARHEIGHT,
					"width":"100%"});
		$("#menuDiv").append("<button id=\"fullScreenButton\">Fullscreen</button>");
		$("#fullScreenButton").css({"height":"100%"});
		$("#fullScreenButton").click(goFullScreen);
	});
</script>
<script>
window.onbeforeunload = function (e) {
    e = e || window.event;

    // For IE and Firefox prior to version 4
    if (e) {
        e.returnValue = 'Sure?';
    }

    // For Safari
    return 'Sure?';
};
</script>
</head>
<body>
   <div id="HeaderDiv" class="header">
			<a href="index.jsp">Home</a> |
			<a>Demo</a> |
			<a>Help</a> |
    		<a href="feedback.html">Feedback</a> |
    		<a href="termsandconditions.html">Terms and conditions</a>
    </div>
	<div id="canvasDiv"></div>
	<div id="messageDiv_holder">
	<div id="messageDiv">
		<p id="MeetingRoom">Meeting room#:</p>
		<p id="MeetingTopic">Meeting topic:</p>
		<p id="MeetingHost">Meeting host:</p>
		<p id="MeetingHostEmail">Host e-mail:</p>
	</div>
	</div>
	<div id="chatArea">
		<div  id="inputDiv">
			<input type="text" placeholder="type and press enter to chat"
				id="chat" />
		</div>
		<div id="console-container">
			<div id="console"></div>
		</div>
	</div>
	<div id="FooterDiv" class="footer">
			<ul class="social-icons">
				<!-- Facebook Button-->
				<li class="social-icon facebook"><a
					onclick="javascript:popupCenter('https://www.facebook.com/sharer/sharer.php?u=www.instacollabotation.com&amp;appId=XXX_YOUR_FACEBOOK_APP_ID','Facebook Share', '540', '400');return false;"
					href="https://www.facebook.com/sharer/sharer.php?u=www.instacollabotation.com&amp;appId=XXX_YOUR_FACEBOOK_APP_ID"
					target="blank"><i class="fa fa-facebook"></i> Share </a></li>
				<!-- Twitter Button -->
				<li class="social-icon twitter"><a
					onclick="javascript:popupCenter('https://twitter.com/share?&amp;url=www.instacollabotation.com&amp;text=Start Collaboration Now. http://www.instacollaboration.com','Tweet', '540', '400');return false;"
					href="https://twitter.com/share?&amp;url=www.instacollabotation.com&amp;text=Start Collaboration Now. http://www.instacollaboration.com"
					target="blank"><i class="fa fa-twitter"></i> Tweet </a></li>
				<!-- Google + Button-->
				<li class="social-icon google-plus"><a
					onclick="javascript:popupCenter('https://plus.google.com/share?url=www.instacollabotation.com','Share on Google+', '600', '600');return false;"
					href="https://plus.google.com/share?url=www.instacollabotation.com"
					target="blank"><i class="fa fa-google-plus"></i> Google+</a></li>
				<!-- LinkedIn Button -->
				<li class="social-icon linkedin"><a
					onclick="javascript:popupCenter('http://www.linkedin.com/shareArticle?mini=true&amp;url=www.instacollabotation.com&amp;title=Start Collaboration Now&amp;source=StieURl','Share on LinkedIn', '520', '570');return false;"
					href="http://www.linkedin.com/shareArticle?mini=true&amp;url=www.instacollabotation.com&amp;title=Start Collaboration Now&amp;source=UrlSource"
					target="blank"><i class="fa fa-linkedin"></i> LinkedIn </a></li>
			</ul>
		</div>
		<div id="FooterDiv1" class="footer">
			<span class="footer2">© InstaCollaboration: all rights reserved</span>
    	</div>
</body>
</html>