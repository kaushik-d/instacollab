<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<link rel="stylesheet" type="text/css" href="canvas.css">
<title>Insert title here</title>
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
//window.onbeforeunload = function (e) {
//    e = e || window.event;
//
//    // For IE and Firefox prior to version 4
//    if (e) {
//        e.returnValue = 'Sure?';
//    }

    // For Safari
//    return 'Sure?';
//};
</script>
</head>
<body>
    <div id="HeaderDiv">
			<a>Demo</a> |
			<a>Help</a> |
    		<a>Feedback</a> |
    		<a>Terms and conditions</a>
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
</body>
</html>