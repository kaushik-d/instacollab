<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<!-- <meta charset="UTF-8">  -->
<meta name="viewport" content="width=device-width, initial-scale=1">

<meta name="description" content="Collabote during meetings online from any device from anywhere." />
<meta name="keywords" content="Instant Collaboration, Web Conferencing, Online Meetings, Sharing" />
<meta name="rating" content="general" />
<meta name="copyright" content="2015, Instacollaboration.com " />
<meta name="revisit-after" content="31 Days" />
<meta name="expires" content="never"> 
<meta name="distribution" content="global" /> 
<meta name="robots" content="index" />

<title>Start Collaboration Now</title>
<link href="base.css?v=1.0" rel="stylesheet">
<link rel="stylesheet" type="text/css" href="index.css?v=1.0">
<link
	href="//netdna.bootstrapcdn.com/font-awesome/4.0.3/css/font-awesome.css"
	rel="stylesheet">
<script
	src="https://ajax.googleapis.com/ajax/libs/jquery/1.11.3/jquery.min.js"></script>
<script src="htmlDatePicker.js" type="text/javascript"></script>
<link href="htmlDatePicker.css" rel="stylesheet">
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
						$("#Start_Action_Area").slideDown("slow");
					} else if (whiteboardClicked) {
						whiteboardClicked = false;
						$("#Start_WhiteBoard").slideUp("slow", function() {
							$("#Start_Action_Area").slideDown("slow");
						});
					} else if (presentationClicked) {
						presentationClicked = false;
						$("#Start_Presentation").slideUp("slow", function() {
							$("#Start_Action_Area").slideDown("slow");
						});
					} else {
						startClicked = false;
						$("#Start_Action_Area").slideUp("slow");
					}
					}
				});
				var delay=1000, setTimeoutConst;
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

				$("#whiteboard").click(function() {
					whiteboardClicked = true;
					$("#Start_Action_Area").slideUp("slow", function() {
						var ImgAdd = window.location.protocol + "//"
							+ window.location.host + "/instacollab/CaptchaServlet?img=" + new Date().getTime();
						$("#WCaptchaImg").attr("src", ImgAdd);
						$("#Start_WhiteBoard").slideDown("slow");
					});
				});
				$("#presentation").click(function() {
					presentationClicked = true;
					$("#Start_Action_Area").slideUp("slow", function() {
						var ImgAdd = window.location.protocol + "//"
							+ window.location.host + "/instacollab/CaptchaServlet?img=" + new Date().getTime();
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
				var canvasurl = window.location.protocol + '//'+ window.location.host + "/instacollab/canvas.jsp?room=" + roomNum;
				var url = "https://www.facebook.com/sharer/sharer.php?u=" + canvasurl + "&amp;appId=XXX_YOUR_FACEBOOK_APP_ID";
				$("#facebook_a").attr("href",url);
				popupCenter(url,'Facebook Share', '540', '400');
				return false;
			}
			
			twitter_a = function(){
				var roomNum = $("#ShareMeetingRoomNumInput").val();
				if(roomNum==""){
					return false;
				}
				var canvasurl = window.location.protocol + '//'+ window.location.host + "/instacollab/canvas.jsp?room=" + roomNum;
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
				var canvasurl = window.location.protocol + '//'+ window.location.host + "/instacollab/canvas.jsp?room=" + roomNum;
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
				var canvasurl = window.location.protocol + '//'+ window.location.host + "/instacollab/canvas.jsp?room=" + roomNum;
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
			
			$("#Start_ReturnMessage").html("Your meeting room #<strong>" +
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

	function Join(joinButton) {
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
		<div id="HeaderDiv" class="header">
			<a href="index.jsp">Home</a> |
			<a>Demo</a> |
			<a>Help</a> |
    		<a href="feedback.html">Feedback</a> |
    		<a href="termsandconditions.html">Terms and conditions</a>
    	</div>
		<div id=button_holder>
			<div id="Start_Message_Area" class="Message_Area_Start_Clear"></div>
			<div id="Start_div">
				<button id="Start_Button">Start</button>
			</div>
			<div id="Start_Action_Area_holder" class="Action_Area_holder">
				<div id="Start_Action_Area" class="Start_Action">
					<button id="whiteboard" style="width : 100px" >Whiteboard</button>
					<button id="presentation" style="width : 100px">Presentation</button>
				</div>
				<div id="Start_WhiteBoard" class="Start_Action">
					<form action="login" method="post" enctype="multipart/form-data"
						id="WhiteboardForm">
						<div id="WhiteboardFormHolder" class="holder">
							<table>
								<tr>
									<td><label for="topic">Meeting topic:</label></td>
									<td><input type="text" name="topic"
										placeholder="Meeting topic" required maxlength="100"/></td>
								</tr>
								<tr>
									<td><label for="name">Your name:</label></td>
									<td><input type="text" name="name"
										placeholder="First name and last name" required maxlength="32"/></td>
								</tr>
								<tr>
									<td><label for="email">Email address:</label></td>
									<td><input type="email" name="email"
										placeholder="e-mail@domain.com" required maxlength="100"/></td>
								</tr>
								<!--  
								<tr>
									<td><label for="meetingStartDate">Meeting time:</label></td>
									<td>
									<input type="text" name="meetingStartDate" required
										 id="Wdatepicker" readonly onClick="GetDate(this);" style="width:60px"/>
									 <label for="WstartTime">Start:</label>
									<select id="WstartTime" name=startTime required
										 style="width:57px" required></select> 
									<label for="WendTime">Meeting ends:</label>
									<select id="WendTime" name=endTime required
										 style="width:57px" required></select></td>
								</tr>
								-->
								<tr>
									<td><img  id="WCaptchaImg" src="CaptchaServlet"></td>
									<td>
									<input type="text" name="code" style="width:60px" maxlength="5" required placeholder="Code">
									<input type="submit" value="Submit" />
									<input type="reset" value="Reset" />
								</tr>
							</table>
						</div>
					</form>
				</div>
				<div id="Start_Presentation" class="Start_Action" style="height:172px">
					<form action="login" method="post" enctype="multipart/form-data"
						id="PresentationForm">
						<div id="PresentationFormHolder" class="holder">
							<table>
								<tr>
									<td><label for="topic">Meeting topic:</label></td>
									<td><input type="text" name="topic"
										placeholder="Meeting topic" required maxlength="100"/></td>
								</tr>
								<tr>
									<td><label for="name">Your name:</label></td>
									<td><input type="text" name="name"
										placeholder="First name and last name" required maxlength="32"/></td>
								</tr>
								<tr>
									<td><label for="email">Email address:</label></td>
									<td><input type="email" name="email"
										placeholder="e-mail@domain.com" required maxlength="100"/></td>
								</tr>
								<tr>
									<td><label for="presentationFile">Presentation
											slides:</label></td>
									<td>
									<!-- <input type="file" name="presentationFile" accept="application/vnd.openxmlformats-officedocument.presentationml.presentation,application/pdf"/> -->
									<span style="font-size:12px">(PDFs only)</span>
									<input type="file" name="presentationFile" accept="application/pdf"/>
									</td>
								</tr>
								<!-- 
								<tr>
									<td><label for="meetingStartDate">Meeting time:</label></td>
									<td>
									<input type="text" name="meetingStartDate" required
										 id="Pdatepicker" readonly onClick="GetDate(this);" style="width:60px"/>
									<!-- <label for="PstartTime">Start:</label>
									<select id="PstartTime" name=startTime required
										 style="width:57px" required></select>  
									<label for="PendTime">Meeting ends:</label>
									<select id="PendTime" name=endTime required
										 style="width:57px" required></select></td>
								</tr>
								-->
								<tr>
									<td><img id="PCaptchaImg" src="CaptchaServlet"></td>
									<td>
									<input type="text" name="code" style="width:60px" maxlength="5" required placeholder="Code">
									<input type="submit" value="Submit" />
									<input type="reset" value="Reset" />
								</tr>
							</table>
						</div>
					</form>
				</div>
				<div id="Start_ReturnBoard" class="Start_Action" style="height:172px">
					<div id="PresentationFormHolder" class="holder">
						<table style="text-align: center; width:100%">
						<tr><td>
							<p id="Start_ReturnMessage"></p>
						</td></tr>
						<tr><td>
							<button id="Start_ReturnBoard_ok">OK</button>
						</td></tr>
						</table>
					</div>
				</div>
			</div>

			<div id="Share_Message_Area" class="Message_Area_Start_Clear"></div>
			<div id="Share_div">
				<button id="Share_Button">Share</button>
			</div>

			<div id="Share_Action_Area_holder" class="Action_Area_holder"  style="height:70px">
				<div id="Share_Action_Area" class="Start_Action" style="height:70px">
					<div id="Join_Holder" style="text-align: center;" class="holder">
						<table>
							<tr>
								<td><label for="ShareMeetingRoomNumInput">Meeting room#:</label>
									<input type="text" name="MeetingRoom" id="ShareMeetingRoomNumInput" maxlength="5"/></td>
							</tr>
							<tr>
								<td>
									<ul class="social-icons">
										<!-- Facebook Button-->
										<li class="social-icon facebook"><a id="facebook_a" onclick="javascript:facebook_a(); return false;"
											href=""
											target="blank"><i class="fa fa-facebook"></i> Share </a></li>
										<!-- Twitter Button -->
										<li class="social-icon twitter"><a id="twitter_a" onclick="javascript:twitter_a(); return false;"
											href=""
											target="blank"><i class="fa fa-twitter"></i> Tweet </a></li>
										<!-- Google + Button-->
										<li class="social-icon google-plus"><a id="google_a" onclick="javascript:google_a(); return false;"
											href=""
											target="blank"><i class="fa fa-google-plus"></i> Google+</a></li>
										<!-- LinkedIn Button -->
										<li class="social-icon linkedin"><a id="linkedin_a" onclick="javascript:linkedin_a(); return false;"
											href=""
											target="blank"><i class="fa fa-linkedin"></i> LinkedIn </a></li>
									</ul>
								<td>
							</tr>
						</table>
					</div>
				</div>
			</div>


			<div id="Join_Message_Area" class="Message_Area_Start_Clear"></div>
			<div id="Join_div">
				<button id="Join_Button">Join</button>
			</div>
			<div id="Join_Action_Area_holder" class="Action_Area_holder" style="height:70px">
				<div id="Join_Action_Area" class="Start_Action" style="height:70px">
					<div id="Join_Holder" style="text-align: center;" class="holder">
						<form action="canvas.jsp" method="get" id="JoinForm">
							<table>
								<tr>
									<td><label for="JoinMeetingRoomNumInput">Meeting
											room#:</label> <input type="text" name="room"
										id="JoinMeetingRoomNumInput" required/></td>
								</tr>
								<tr style="float: left">
									<td><input type="submit" value="Submit" /></td>
									<td><input type="reset" value="Reset" /></td>
								</tr>
							</table>
						</form>
					</div>
				</div>
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
					onclick="javascript:popupCenter('https://twitter.com/share?&amp;url=www.instacollabotation.com&amp;text=Start Collaboration Now','Tweet', '540', '400');return false;"
					href="https://twitter.com/share?&amp;url=www.instacollabotation.com&amp;text=Start Collaboration Now"
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
			<span class="footer2">© InstaCollaboration, all rights reserved</span>
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