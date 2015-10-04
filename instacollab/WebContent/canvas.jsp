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


<link rel="stylesheet"
	href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.5/css/bootstrap.min.css">
<link rel="stylesheet"
	href="https://maxcdn.bootstrapcdn.com/font-awesome/4.4.0/css/font-awesome.min.css">

<link href="base.css?v=1.0" rel="stylesheet">
<link rel="stylesheet" type="text/css" href="canvas.css">

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

		$("#canvasDiv").append("<div class=\"btn-group menuDiv\" id=\"menuDiv\"></div>");
		$("#menuDiv").append("<a id=\"fullScreenButton\" class=\"btn btn-default btnc\" href=\"#\"><i class=\"fa fa-expand\"></i></a>");
		$("#menuDiv").append("<a id=\"previousPage\" class=\"btn btn-default btnc\" href=\"#\"><i class=\"fa fa-arrow-left\"></i></a>");
		$("#menuDiv").append("<a id=\"nextPage\" class=\"btn btn-default btnc\" href=\"#\"><i class=\"fa fa-arrow-right\"></i></a>");
		$("#menuDiv").append("<a id=\"hideMenu\" class=\"btn btn-default btnc\" href=\"#\"><i class=\"fa fa-times\"></i></a>");
		$("#menuDiv").append("<a id=\"showMenu\" class=\"btn btn-default btnc\" href=\"#\"><i class=\"fa fa-bars\"></i></a>");
		
		$("#showMenu").hide();
		
		$("#hideMenu").click(function(){
			$(".btn.btnc").hide();
			$("#showMenu").show();
		});
		
		$("#showMenu").click(function(){
			$(".btn.btnc").show();
			$("#showMenu").hide();
		});
		
		
		/*$("#menuDiv").css(
				{"height":MENUBARHEIGHT,
					"top":CURRENTCANVASHEIGHT-MENUBARHEIGHT,
		//			"top": "2px",
					//"buttom":CURRENTCANVASHEIGHT-MENUBARHEIGHT,
					"width":"100%"});
		
		$("#menuDiv").append("<button id=\"fullScreenButton\">Fullscreen</button>");
		
		//$("#fullScreenButton")
		$("#fullScreenButton").css({"height":"100%"});*/
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

    <div class="btn-group-lg top-gap" style="text-align: center;">
			<a class="btn btn-default color" href="index.jsp"><i class="fa fa-home fa-2x"></i></a>
			<a class="btn btn-default color" href="feedback.html"><i class="fa fa-medkit fa-2x"></i></a> 
			<a class="btn btn-default color" href="feedback.html"><i class="fa fa-comment fa-2x"></i></a> 
			<a class="btn btn-default color" href="termsandconditions.html"><i class="fa fa-info fa-2x"></i></a> 
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
	
	    <div class="btn-group-lg" style="text-align: center;">
			<a class="btn btn-default color" onclick="javascript:popupCenter('https://www.facebook.com/sharer/sharer.php?u=www.instacollaboration.com&amp;appId=XXX_YOUR_FACEBOOK_APP_ID','Facebook Share', '540', '400');return false;"
					href="https://www.facebook.com/sharer/sharer.php?u=www.instacollaboration.com&amp;appId=XXX_YOUR_FACEBOOK_APP_ID"
					target="blank"><i class="fa fa-facebook fa-2x"></i></a>
			<a class="btn btn-default color" onclick="javascript:popupCenter('https://twitter.com/share?&amp;url=www.instacollaboration.com&amp;text=Start Collaboration Now. http://www.instacollaboration.com','Tweet', '540', '400');return false;"
					href="https://twitter.com/share?&amp;url=www.instacollaboration.com&amp;text=Start Collaboration Now. http://www.instacollaboration.com"
					target="blank"><i class="fa fa-twitter fa-2x"></i></a> 
			<a class="btn btn-default color" onclick="javascript:popupCenter('https://plus.google.com/share?url=www.instacollaboration.com','Share on Google+', '600', '600');return false;"
					href="https://plus.google.com/share?url=www.instacollaboration.com"
					target="blank"><i class="fa fa-google-plus fa-2x"></i></a> 
			<a class="btn btn-default color" onclick="javascript:popupCenter('http://www.linkedin.com/shareArticle?mini=true&amp;url=www.instacollaboration.com&amp;title=Start Collaboration Now&amp;source=StieURl','Share on LinkedIn', '520', '570');return false;"
					href="http://www.linkedin.com/shareArticle?mini=true&amp;url=www.instacollaboration.com&amp;title=Start Collaboration Now&amp;source=UrlSource"
					target="blank"><i class="fa fa-linkedin fa-2x"></i></a> 
		</div>
		
		<div id="FooterDiv1" class="footer">
			<span class="footer2">© InstaCollaboration: all rights reserved</span>
    	</div>
</body>
</html>