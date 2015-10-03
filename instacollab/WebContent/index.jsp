<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<!-- <meta charset="UTF-8">  -->
<meta name="viewport" content="width=device-width, initial-scale=1">

<meta name="description"
	content="Collaborate instantly from any device from anywhere." />
<meta name="keywords"
	content="Instant Collaboration, Web Conferencing, Online Meetings, Sharing" />
<meta name="rating" content="general" />
<meta name="copyright" content="2015, Instacollaboration.com " />
<meta name="revisit-after" content="31 Days" />
<meta name="expires" content="never">
<meta name="distribution" content="global" />
<meta name="robots" content="index" />

<title>Start Collaboration Now</title>


<!-- 
<link href="//netdna.bootstrapcdn.com/twitter-bootstrap/2.3.2/css/bootstrap-combined.no-icons.min.css" rel="stylesheet">

<link
	href="//netdna.bootstrapcdn.com/font-awesome/4.0.3/css/font-awesome.css"
	rel="stylesheet">

<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/font-awesome/4.4.0/css/font-awesome.min.css">
 -->
<link rel="stylesheet"
	href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.5/css/bootstrap.min.css">
<link rel="stylesheet"
	href="https://maxcdn.bootstrapcdn.com/font-awesome/4.4.0/css/font-awesome.min.css">

<link href="base.css?v=1.0" rel="stylesheet">
<link rel="stylesheet" type="text/css" href="index.css?v=1.0">

<script
	src="https://ajax.googleapis.com/ajax/libs/jquery/1.11.3/jquery.min.js"></script>
<script src="htmlDatePicker.js" type="text/javascript"></script>
<link href="htmlDatePicker.css" rel="stylesheet">
<script>
  (function(i,s,o,g,r,a,m){i['GoogleAnalyticsObject']=r;i[r]=i[r]||function(){
  (i[r].q=i[r].q||[]).push(arguments)},i[r].l=1*new Date();a=s.createElement(o),
  m=s.getElementsByTagName(o)[0];a.async=1;a.src=g;m.parentNode.insertBefore(a,m)
  })(window,document,'script','//www.google-analytics.com/analytics.js','ga');

  ga('create', 'UA-67926906-1', 'auto');
  ga('send', 'pageview');

</script>
<script>
	var startClicked = false;
	var whiteboardClicked = false;
	var presentationClicked = false;

	var meetingRoomData = {};
	var isRoomCreated = false;
	var start_MessageActive = false;

	$(document).ready(
			function() {
				$("#Start_Button").click(function() {
					if(!start_MessageActive){
					if (!startClicked) {
						startClicked = true;
						$("#ShareMeetingRoomNumInput").val("");
						$("#Share_Action_Area").slideUp("slow");
						$("#JoinMeetingRoomNumInput").val("");
						$("#Join_Action_Area").slideUp("slow");
						$("#Start_Presentation").slideDown("slow");
					} else {
						startClicked = false;
						$("#Start_Presentation").slideUp("slow");
					}
					}
				});
				var delay=1000, setTimeoutConst;
				/*
				$("#Start_Button").hover(
						function(){
						setTimeoutConst = setTimeout(
						function() {
							$("#Start_Message_Area").removeClass(
									"Message_Area_Start_Clear").addClass(
									"Message_Area_Start_Focus").text(
									"Start a meeting");
						},delay);},
						function() {
							clearTimeout(setTimeoutConst );
							$("#Start_Message_Area").removeClass(
									"Message_Area_Start_Focus").addClass(
									"Message_Area_Start_Clear").text("");
						});
				*/

				$("#whiteboard").click(function() {
					whiteboardClicked = true;
					$("#Start_Action_Area").slideUp("slow", function() {
					//	var ImgAdd = window.location.protocol + "//"
					//		+ window.location.host + "/instacollab/CaptchaServlet?img=" + new Date().getTime();
						var ImgAdd = "CaptchaServlet?img=" + new Date().getTime();
						$("#WCaptchaImg").attr("src", ImgAdd);
						$("#Start_WhiteBoard").slideDown("slow");
					});
				});
				$("#presentation").click(function() {
					presentationClicked = true;
					$("#Start_Action_Area").slideUp("slow", function() {
					//	var ImgAdd = window.location.protocol + "//"
					//		+ window.location.host + "/instacollab/CaptchaServlet?img=" + new Date().getTime();
						var ImgAdd = "CaptchaServlet?img=" + new Date().getTime();
						$("#PCaptchaImg").attr("src", ImgAdd);
						$("#Start_Presentation").slideDown("slow");
					});
				});
				
				var d = new Date();
				var today = d.getMonth() +"/"+ d.getDay() + "/" + d.getFullYear();
				//$("#Wdatepicker").placeholder=today;
				//$("#Pdatepicker").placeholder=today;
				//var endTime = d.getHours() + 1;
					
				var startOptions = {};
				var endOptions = {};
				for(var i = 1; i <= 23; i++) {
					if(i< 11) {
						startOptions["Option " + i] = i + " AM";
						endOptions["Option " + i] = (i+1) + " AM";
					} 
					else if(i==11) {
						startOptions["Option " + i] = i + " AM";
						endOptions["Option " + i] = "Noon";
					}
					else if(i==12) {
						startOptions["Option " + i] = " Noon";
						endOptions["Option " + i] = (i+1) + " AM";
					}
					else {
						startOptions["Option " + i] = (i-12) + " PM";
						endOptions["Option " + i] = (i-11) + " PM";
					}
				}
				/*
				var $el = $("#WstartTime");
				$el.empty(); // remove old options
				$.each(startOptions, function(value,key) {
					$el.append($("<option></option>")
					.attr("value", value).text(key));
				});
				*/
				var $el = $("#WendTime");
				$el.empty(); // remove old options
				$.each(endOptions, function(value,key) {
					$el.append($("<option></option>")
					.attr("value", value).text(key));
				});
				/*
				var $el = $("#PstartTime");
				$el.empty(); // remove old options
				$.each(startOptions, function(value,key) {
					$el.append($("<option></option>")
					.attr("value", value).text(key));
				});
				*/
				var $el = $("#PendTime");
				$el.empty(); // remove old options
				$.each(endOptions, function(value,key) {
					$el.append($("<option></option>")
					.attr("value", value).text(key));
				});

				/*
				$("Whiteboard_Cancel").click(function() {
					whiteboardClicked = false;
					$(this).closest('form').find("input[type=text], textarea, input[type=email]").val("");
					$("#Start_WhiteBoard").slideUp("slow", function() {
						$("#Start_Action_Area").slideDown("slow");
					});
				});
				
				$("Presentation_Cancel").click(function() {
					whiteboardClicked = false;
					$(this).closest('form').find("input[type=text], textarea, input[type=email]").val("");
					$("#Start_WhiteBoard").slideUp("slow", function() {
						$("#Start_Action_Area").slideDown("slow");
					});
				});
				 */
				$("#PresentationForm").submit(StartPresentation);
				$("#WhiteboardForm").submit(StartWhiteboard);

				$("#Share_Button").click(function() {
					//presentationClicked = true;
					$("#Share_Action_Area").slideToggle("slow", function() {
					});
				});

				$("#Share_Button").hover(
						function() {
							setTimeoutConst = setTimeout(function() {
								$("#Share_Message_Area").removeClass(
										"Message_Area_Start_Clear").addClass(
										"Message_Area_Start_Focus").text(
										"Share your meeting room");
							}, delay);
						},
						function() {
							clearTimeout(setTimeoutConst);
							$("#Share_Message_Area").removeClass(
									"Message_Area_Start_Focus").addClass(
									"Message_Area_Start_Clear").text("");
						});

				$("#Join_Button").hover(
						function() {
							setTimeoutConst = setTimeout(function() {
								$("#Join_Message_Area").removeClass(
										"Message_Area_Start_Clear").addClass(
										"Message_Area_Start_Focus").text(
										"Join a meeting room");
							}, delay);
						},
						function() {
							clearTimeout(setTimeoutConst);
							$("#Join_Message_Area").removeClass(
									"Message_Area_Start_Focus").addClass(
									"Message_Area_Start_Clear").text("");
						});

				$("#Join_Button").click(function() {
					//presentationClicked = true;
					$("#Join_Action_Area").slideToggle("slow");
				});

				$(document).ajaxStart(
						function() {
							$("#Start_Action_Area_holder").addClass(
									"holder_ajax_load");
							$("#Share_Action_Area_holder").addClass(
									"holder_ajax_load");
							$("#Join_Action_Area_holder").addClass(
									"holder_ajax_load");
						}).ajaxStop(
						function() {
							$("#Start_Action_Area_holder").removeClass(
									"holder_ajax_load");
							$("#Share_Action_Area_holder").removeClass(
									"holder_ajax_load");
							$("#Join_Action_Area_holder").removeClass(
									"holder_ajax_load");
						});
				
				$("#Start_ReturnBoard_ok").click(function(){
					$("#Start_ReturnBoard").slideUp("slow");
					start_MessageActive = false;
				})

			});  // $(document).ready ends

			facebook_a = function(){
				var roomNum = $("#ShareMeetingRoomNumInput").val();
				if(roomNum==""){
					return false;
				}
				//var canvasurl = window.location.protocol + '//'+ window.location.host + "/instacollab/canvas.jsp?room=" + roomNum;
				var canvasurl = "http://www.instacollaboration.com/canvas.jsp?room=" + roomNum;
				var url = "https://www.facebook.com/sharer/sharer.php?url=" + canvasurl + "&amp;appId=XXX_YOUR_FACEBOOK_APP_ID";
				$("#facebook_a").attr("href",url);
				popupCenter(url,'Facebook Share', '540', '400');
				return false;
			}
			
			twitter_a = function(){
				var roomNum = $("#ShareMeetingRoomNumInput").val();
				if(roomNum==""){
					return false;
				}
				//var canvasurl = window.location.protocol + '//'+ window.location.host + "/instacollab/canvas.jsp?room=" + roomNum;
				var canvasurl = "http://www.instacollaboration.com/canvas.jsp?room=" + roomNum;
				var url = "https://twitter.com/share?&amp;url=" + canvasurl + "&amp;text=Join%20my%20meeting%20room";
				$("twitter_a").attr("href",url);
				popupCenter(url,'Tweet', '540', '400');
				return false;						
			}
			
			google_a = function(){
				var roomNum = $("#ShareMeetingRoomNumInput").val();
				if(roomNum==""){
					return false;
				}
				//var canvasurl = window.location.protocol + '//'+ window.location.host + "/instacollab/canvas.jsp?room=" + roomNum;
				var canvasurl = "http://www.instacollaboration.com/canvas.jsp?room=" + roomNum;
				var url = "https://plus.google.com/share?url=" + canvasurl;
				$("google_a").attr("href",url);
				popupCenter(url,'Share on Google+', '600', '600');
				return false;						
			}
			
			linkedin_a = function(){
				var roomNum = $("#ShareMeetingRoomNumInput").val();
				if(roomNum==""){
					return false;
				}
				//var canvasurl = window.location.protocol + '//'+ window.location.host + "/instacollab/canvas.jsp?room=" + roomNum;
				var canvasurl = "http://www.instacollaboration.com/canvas.jsp?room=" + roomNum;
				var url = "http://www.linkedin.com/shareArticle?mini=true&amp;url=" + canvasurl + "&amp;title=Join%20my%20meeting%20room&amp;source=UrlSource";
				$("linkedin_a").attr("href",url);
				popupCenter(url,'Share on Google+', '600', '600');
				return false;						
			}		
			
	StartPresentation = function(evt) {
		var formElement = document.getElementById("PresentationForm");
		var data = new FormData(formElement);
		data.append("isPresentation", "true");
		data.append("presentationURI", "NotAvailable");
		data.append("functName", "createRoom");
		presentationClicked = false;
		$("#Start_Presentation").slideUp("slow");
		StartSubmit(evt, data);
	}

	StartWhiteboard = function(evt) {
		var formElement = document.getElementById("WhiteboardForm");
		var data = new FormData(formElement);
		data.append("isPresentation", "false");
		data.append("presentationURI", "NotAPresentation");
		data.append("functName", "createRoom");
		whiteboardClicked = false;
		$("#Start_WhiteBoard").slideUp("slow");
		StartSubmit(evt, data);
	}

	StartSubmit = function(evt, data) {
		var url = "login";
		$.ajax({
			type : "POST",
			url : url,
			data : data,
			cache : false,
			contentType : false,
			processData : false,
			success : function(data) {
				processStartReturn(data);
				startClicked = false;
			}
		});

		evt.preventDefault();
		return false; // avoid to execute the actual submit of the form.
	}
	

	function processStartReturn(data) {
		meetingRoomData = data;

		if (meetingRoomData.functName == "RoomCreateSuccess") {

			start_MessageActive = true;
			$("#Start_ReturnBoard").slideDown("slow");
			
			$("#Start_ReturnMessage").html("Your meeting room# <strong>" +
					meetingRoomData.roomNumber +
					"</strong> is ready.<br>" + 
					"You can share and join the meeting room.<br>" +
					"A confirmation e-mail has been sent to<br>" +
					meetingRoomData.email);
			isRoomCreated = true;
			$("#ShareMeetingRoomNumInput").val(meetingRoomData.roomNumber);
			$("#Share_Action_Area").slideDown("slow");
			$("#JoinMeetingRoomNumInput").val(meetingRoomData.roomNumber);
			$("#Join_Action_Area").slideDown("slow");
			
		} else if (meetingRoomData.functName == "CodeVarificationFail") {
			start_MessageActive = true;
			$("#Start_ReturnBoard").slideDown("slow");
			$("#Start_ReturnMessage").html("Captcha code didn't match. Please try again.");
		}

	}

	function Join(joinButton) { // Not in use
		if (isRoomCreated) {
			xmlhttp = new XMLHttpRequest();
			xmlhttp.onreadystatechange = function() {
				if (xmlhttp.readyState == 4 && xmlhttp.status == 200) {
					window.location = xmlhttp.responseText;
					isRoomCreated = false;
					startClicked = true;
				}
			}
			xmlhttp.open("POST", "joinMeeting", true);
			var params = "data=" + encodeURIComponent(JSON.stringify({
				functName : "joinMeeting",
				isPresentation : false,
				name : meetingRoomData.name,
				topic : meetingRoomData.topic,
				roomNumber : meetingRoomData.roomNumber
			}));
			xmlhttp.setRequestHeader("Content-type",
					"application/x-www-form-urlencoded");
			xmlhttp.send(params);
		}
	}

	var popupCenter = function(url, title, w, h) {
		// Fixes dual-screen position                         Most browsers      Firefox
		var dualScreenLeft = window.screenLeft !== undefined ? window.screenLeft
				: screen.left;
		var dualScreenTop = window.screenTop !== undefined ? window.screenTop
				: screen.top;

		var width = window.innerWidth ? window.innerWidth
				: document.documentElement.clientWidth ? document.documentElement.clientWidth
						: screen.width;
		var height = window.innerHeight ? window.innerHeight
				: document.documentElement.clientHeight ? document.documentElement.clientHeight
						: screen.height;

		var left = ((width / 2) - (w / 2)) + dualScreenLeft;
		var top = ((height / 3) - (h / 3)) + dualScreenTop;

		var newWindow = window.open(url, title, 'scrollbars=yes, width=' + w
				+ ', height=' + h + ', top=' + top + ', left=' + left);

		// Puts focus on the newWindow
		if (window.focus) {
			newWindow.focus();
		}
		return false;
	};

	//  =======================================

	window
			.addEventListener(
					'load',
					function(e) {
						window.applicationCache
								.addEventListener(
										'updateready',
										function(e) {
											if (window.applicationCache.status == window.applicationCache.UPDATEREADY) {
												// Browser downloaded a new app cache.
												// Swap it in and reload the page to get the new hotness.
												window.applicationCache
														.swapCache();
												// if (confirm('A new version of this site is available. Load it?')) {
												window.location.reload();
												// }
											} else {
												// Manifest didn't changed. Nothing new to server.
											}
										}, false);

					}, false);
</script>

</head>
<body>

	<div id="background">

		<div class="btn-group-lg">
			<a class="btn btn-default color" href="index.jsp"><i class="fa fa-home fa-2x"></i></a>
			<a class="btn btn-default color" href="feedback.html"><i class="fa fa-medkit fa-2x"></i></a> 
			<a class="btn btn-default color" href="feedback.html"><i class="fa fa-comment fa-2x"></i></a> 
			<a class="btn btn-default color" href="termsandconditions.html"><i class="fa fa-info fa-2x"></i></a> 
		</div>
 
		<div id=button_holder>

			<div class="botton_div">
				<a id="Start_Button" class="btn btn-default color btn-wt" href="#"><i
					class="fa fa-play"></i> Start a meeting</a>
			</div>
			<div id="Start_Presentation" class="Start_Action">
				<form action="login" method="post" enctype="multipart/form-data"
					id="PresentationForm">

					<div class="input-group">
						<span class="input-group-addon"><i class="fa fa-th-list"></i></span>
						<input type="text" name="topic" class="form-control"
							placeholder="Meeting topic" required maxlength="100" />
					</div>

					<div class="input-group">
						<span class="input-group-addon"><i class="fa fa-user"></i></span>
					<input type="text" name="name" class="form-control"
						placeholder="First name and last name" required maxlength="32" />
					</div>
					
					<div class="input-group">
						<span class="input-group-addon"><i class="fa fa-envelope-o"></i></span>
					<input type="email" class="form-control"
						name="email" placeholder="e-mail@domain.com" required
						maxlength="100" /> 
					</div>	
						
					<!-- <input type="file" name="presentationFile" accept="application/vnd.openxmlformats-officedocument.presentationml.presentation,application/pdf"/> -->
					
					<div class="input-group">
						<span class="input-group-addon"><i class="fa fa-upload"></i></span>
    					<input type="text" class="form-control" placeholder="Upload presentation" readonly style="width:200px"/>
						<span class="btn btn-default btn-file">
        					Browse <input type="file" name="presentationFile" accept="application/pdf" /> 
    					</span>
					</div>
					
					<div class="input-group">
						<span class="input-group-addon"><i class="fa fa-key"></i></span>
						<input type="text" class="form-control" name="code"  maxlength="5" required
						placeholder="Code from right" style="width:200px">
						<img style="vertical-align: bottom" alt="Image Code" id="PCaptchaImg" src="CaptchaServlet">
					</div>
					<div class="btn-group">
						<input type="submit" class="form-control" value="Submit" />
						<input type="reset" class="form-control" value="Reset" />
					</div>
				</form>
			</div>
			<div id="Start_ReturnBoard" class="Start_Action"
				style="height: 172px">
				<div id="PresentationFormHolder" class="holder">
					<table style="text-align: center; width: 100%">
						<tr>
							<td>
								<p id="Start_ReturnMessage"></p>
							</td>
						</tr>
						<tr>
							<td>
								<button id="Start_ReturnBoard_ok">OK</button>
							</td>
						</tr>
					</table>
				</div>
			</div>

			<div class="botton_div">
				<a id="Share_Button" class="btn btn-default color btn-wt" href="#"><i
					class="fa fa-share-alt"></i> Share a meeting room</a>
			</div>

			<div id="Share_Action_Area" class="Start_Action">

				<div class="input-group">
					<span class="input-group-addon"><i class="fa fa-desktop"></i></span>
					<input id="ShareMeetingRoomNumInput" class="form-control"
						type="text" placeholder="Meeting Room Number" maxlength="5">
				</div>
				<div>
					<ul class="social-icons">
						<!-- Facebook Button-->
						<li class="social-icon facebook"><a id="facebook_a"
							onclick="javascript:facebook_a(); return false;" href=""
							target="blank"><i class="fa fa-facebook"></i> Share </a></li>
						<!-- Twitter Button -->
						<li class="social-icon twitter"><a id="twitter_a"
							onclick="javascript:twitter_a(); return false;" href=""
							target="blank"><i class="fa fa-twitter"></i> Tweet </a></li>
						<!-- Google + Button-->
						<li class="social-icon google-plus"><a id="google_a"
							onclick="javascript:google_a(); return false;" href=""
							target="blank"><i class="fa fa-google-plus"></i> Google+</a></li>
						<!-- LinkedIn Button -->
						<li class="social-icon linkedin"><a id="linkedin_a"
							onclick="javascript:linkedin_a(); return false;" href=""
							target="blank"><i class="fa fa-linkedin"></i> LinkedIn </a></li>
					</ul>
				</div>
			</div>

			<div class="botton_div">
				<a id="Join_Button" class="btn btn-default color btn-wt" href="#"><i
					class="fa fa-sign-in"></i> Join a meeting room</a>
			</div>

			<div id="Join_Action_Area" class="Start_Action">
				<div class="input-group">
					<span class="input-group-addon"><i class="fa fa-desktop"></i></span>
					<input id="JoinMeetingRoomNumInput" class="form-control"
						type="text" placeholder="Meeting Room Number" maxlength="5">
				</div>
				<div>
					<a id="Join_Submit" class="btn btn-default btn-sm" href="#"><i
						class="fa"></i>Submit</a>
				</div>
			</div>
		</div>
		
		<div class="btn-group-lg">
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
			<span class="footer2">© InstaCollaboration, all rights
				reserved</span>
		</div>
		<!-- <video autoplay loop poster="polina.jpg" id="bgvid"> -->
		<!--  
		<video autoplay loop id="bgvid">
			<source src="images/EarthSpin.mov" type="video/mp4">
		</video>
		-->

	</div>
</body>


</html>