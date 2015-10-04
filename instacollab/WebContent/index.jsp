<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<!-- <meta charset="UTF-8">  -->
<meta name="viewport" content="width=device-width, initial-scale=1">
<meta name="description" content="Collaborate instantly from any device from anywhere." />
<meta name="keywords" content="Instant Collaboration, Web Conferencing, Online Meetings, Sharing" />
<meta name="rating" content="general" />
<meta name="copyright" content="2015, Instacollaboration.com " />
<meta name="revisit-after" content="31 Days" />
<meta name="expires" content="never">
<meta name="distribution" content="global" />
<meta name="robots" content="index" />

<title>Start Collaboration Now</title>

<link rel="stylesheet"
	href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.5/css/bootstrap.min.css">
<link rel="stylesheet"
	href="https://maxcdn.bootstrapcdn.com/font-awesome/4.4.0/css/font-awesome.min.css">

<link href="base.css?v=1.0" rel="stylesheet">
<link rel="stylesheet" type="text/css" href="index.css?v=1.0">

<script src="https://ajax.googleapis.com/ajax/libs/jquery/1.11.3/jquery.min.js"></script>

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

	var meetingRoomData = {};
	var isRoomCreated = false;
	var start_MessageActive = false;

	$(document).ready(
			function() {
				$("#Start_Button").click(function() {
					if(!start_MessageActive){
					if (!startClicked) {
						startClicked = true;
						var ImgAdd = "CaptchaServlet?img=" + new Date().getTime();
						$("#PCaptchaImg").attr("src", ImgAdd);
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
				
				$("#PresentationForm").submit(StartPresentation);

				$("#Share_Button").click(function() {
					$("#Start_Presentation").slideUp("slow");
					$("#Join_Action_Area").slideUp("slow");
					$("#Share_Action_Area").slideToggle("slow");
				});

				$("#Join_Button").click(function() {
					$("#Start_Presentation").slideUp("slow");
					$("#Share_Action_Area").slideUp("slow");
					$("#Join_Action_Area").slideToggle("slow");
				});
				
				$("input[name=isPresentation]:radio").change(function () {
			        if ($("#SelectedPresentation").is(':checked')) {
			            $('#fileSelector').removeAttr('disabled');
			            $('#fileSelector').attr('required', 'required');
			        }
			        else {
			            $('#fileSelector').attr('disabled', 'disabled');
			            $('#fileSelector').removeAttr('required');
			        }
			    })

				$(document).ajaxStart(
						function() {
							$("#ajax_loadong").slideDown("slow");
						}).ajaxStop(
						function() {
							$("#ajax_loadong").slideUp("slow");
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
		//data.append("isPresentation", "true");
		data.append("presentationURI", "NotAvailable");
		data.append("functName", "createRoom");
		presentationClicked = false;
		$("#Start_Presentation").slideUp("slow");
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

		<div class="btn-group-lg top-gap">
			<a class="btn btn-default color" href="index.jsp"><i class="fa fa-home fa-2x"></i></a>
			<a class="btn btn-default color" href="feedback.html"><i class="fa fa-medkit fa-2x"></i></a> 
			<a class="btn btn-default color" href="feedback.html"><i class="fa fa-comment fa-2x"></i></a> 
			<a class="btn btn-default color" href="termsandconditions.html"><i class="fa fa-info fa-2x"></i></a> 
		</div>
 
		<div id=button_holder class="button_holder">

			<div class="botton_div">
				<a id="Start_Button" class="btn btn-default color btn-wt" href="#">
				<i class="fa fa-play"></i> Start a meeting</a>
			</div>
			
			<div id="Start_Presentation" class="Start_Action">
				<form action="login" method="post" enctype="multipart/form-data" id="PresentationForm">

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
					
					<input type="radio" name="isPresentation" value="true" id="SelectedPresentation" checked="checked"/>        
        				Presentation
        			<input type="radio" name="isPresentation" value="false" id="SelectedWhiteboard" />     
        				Whiteboard
						
					<!-- <input type="file" name="presentationFile" accept="application/vnd.openxmlformats-officedocument.presentationml.presentation,application/pdf"/> -->
					
					<div class="input-group">
						<span class="input-group-addon"><i class="fa fa-upload"></i></span>
    					<!-- <input type="text" class="form-control" placeholder="Upload presentation" readonly/>
						<span class="input-group-btn">
        					<i class="fa fa-upload"></i>  -->
        				<input type="file" class="btn btn-default" name="presentationFile" id="fileSelector" accept="application/pdf" /> 
    					</span> 
					</div>
					
					<div class="input-group">
						<span class="input-group-addon"><i class="fa fa-key"></i></span>
						<input type="text" class="form-control" name="code"  maxlength="5" required
						placeholder="Code from right" style="width:150px">
						<img style="vertical-align: bottom" alt="Image Code" id="PCaptchaImg" src="CaptchaServlet">
					</div>
					<div class="btn-group" role="group">
						<input type="submit" class="btn btn-default" value="Submit" />
						<input type="reset" class="btn btn-default" value="Reset" />
					</div>
				</form>
			</div>
			<div id="ajax_loadong" class="Start_Action">
				<i class="fa fa-spinner fa-pulse fa-2x"></i>
			</div>
			<div id="Start_ReturnBoard" class="Start_Action">
				<table style="text-align: center; width: 100%">
					<tr>
						<td>
							<p id="Start_ReturnMessage"></p>
						</td>
					</tr>
					<tr>
						<td>
							<button id="Start_ReturnBoard_ok" class="btn btn-default">OK</button>
						</td>
					</tr>
				</table>
			</div>

			<div class="botton_div">
				<a id="Share_Button" class="btn btn-default color btn-wt" href="#">
				<i class="fa fa-share-alt"></i> Share a meeting room</a>
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
			<form action="canvas.jsp" method="get" id="JoinForm">
				<div class="input-group">
					<span class="input-group-addon"><i class="fa fa-desktop"></i></span>
					<input id="JoinMeetingRoomNumInput" class="form-control" name=room required="required"
						type="text" placeholder="Meeting Room Number" maxlength="5">
				</div>
				<div>
					<input type="submit" class="btn btn-default" value="Submit" />
				</div>
				</form>
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