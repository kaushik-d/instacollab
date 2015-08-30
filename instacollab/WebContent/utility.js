/**
 * 
 */
function writeMessage(message) {
	//document.getElementById('message').innerHTML = message;
}

function getMousePos(canvas, evt) {
	var rect = canvas.getBoundingClientRect();
	
	var eventType = String(evt.type);
	
	//var message = 'Client position2:' + eventType;
	//writeMessage(message);
	
	if(eventType == "mouseup" || 
			eventType == "mousedown" || 
			eventType == "mousemove" ||
			eventType == "mouseout") {
		return {
			x : (evt.clientX - rect.left)/CURRENTCANVASWIDTH,
			y : (evt.clientY - rect.top)/CURRENTCANVASHEIGHT
		};
	}
	else if (eventType == "touchup" || 
			eventType == "touchout" || 
			eventType == "touchleave" ||
			eventType == "touchout" ||
			eventType == "touchstart" ||
				eventType == "touchmove") {
		
		//writeMessage("hello");
		
		var touchEvent = evt.changedTouches[0];
		
		//var message = 'touch:' + touchEvent.clientX;
		//writeMessage(message);
		
		return {
			x : (touchEvent.clientX - rect.left)/CURRENTCANVASWIDTH,
			y : (touchEvent.clientY - rect.top)/CURRENTCANVASHEIGHT
		};
	}
	else {
		return {
			x : null,
			y : null
		};
	}

	// offset = getOffset( canvas );
	// return {
	// x : evt.pageX - offset.x,
	// y : evt.pageY - offset.y
	// };
}

function updateMousePosition(evt) {
	var mousePos = getMousePos(this, evt);
	var message = 'Mouse position: ' + this.id + ':' + mousePos.x + ','
			+ mousePos.y;
	//writeMessage(message);
}

function getOffset(elem) {
	var offsetLeft = 0;
	var offsetTop = 0;
	do {
		if (!isNaN(elem.offsetLeft)) {
			offsetLeft += elem.offsetLeft;
		}
		if (!isNaN(elem.offsetRight)) {
			offsetTop += elem.offsetTop;
		}
	} while (elem = elem.offsetParent);
	return {
		x : offsetTop,
		y : offsetLeft
	};
}

function addFullScreenListners() {
	document.addEventListener('webkitfullscreenchange', function(e) {
		restore();
	}, false);

	document.addEventListener('mozfullscreenchange', function(e) {
		restore();
	}, false);

	document.addEventListener('fullscreenchange', function(e) {
		restore();
	}, false);
}

function goFullScreen() {
	var parentDiv = document.getElementById("canvasDiv");
	if (parentDiv.requestFullScreen) {
		parentDiv.requestFullscreen();
	} else if (parentDiv.webkitRequestFullScreen) {
		parentDiv.webkitRequestFullscreen();
	} else if (parentDiv.mozRequestFullScreen) {
		parentDiv.mozRequestFullScreen();
	}

}

function restore() {

	//if (!window.screenTop && !window.screenY) {
	if(!isCurrentlyFullscreen){
		console.log('not fullscreen');
		
		if(screen.width > screen.height) {
			CURRENTCANVASWIDTH = screen.width;
			CURRENTCANVASHEIGHT = screen.height;
		} else {
			CURRENTCANVASWIDTH = screen.height;
			CURRENTCANVASHEIGHT = CURRENTCANVASWIDTH*INITICANVASHEIGHT/INITICANVASWIDTH;
		}

		
		$("#canvasDiv").attr({
			"width" : CURRENTCANVASWIDTH,
			"height" : CURRENTCANVASHEIGHT
		});
		$("#canvasDiv").css({
			"width" : CURRENTCANVASWIDTH,
			"height" : CURRENTCANVASHEIGHT
		});
		$("canvas").attr({
			"width" : CURRENTCANVASWIDTH,
			"height" : CURRENTCANVASHEIGHT
		});
		$("#menuDiv").css({
			"top" : CURRENTCANVASHEIGHT - MENUBARHEIGHT,
		 "buttom":CURRENTCANVASHEIGHT-MENUBARHEIGHT
		});
		
		var message = 'CURRENTCANVASWIDTH: ' + CURRENTCANVASWIDTH + '\nCURRENTCANVASHEIGHT:' + CURRENTCANVASHEIGHT;
		writeMessage(message);

		redrawCurrentPageContents();
		
		isCurrentlyFullscreen = true;

	} else {
		CURRENTCANVASWIDTH = INITICANVASWIDTH;
		CURRENTCANVASHEIGHT = INITICANVASHEIGHT;
		$("#canvasDiv").attr({
			"width" : CURRENTCANVASWIDTH,
			"height" : CURRENTCANVASHEIGHT
		});
		$("#canvasDiv").css({
			"width" : CURRENTCANVASWIDTH,
			"height" : CURRENTCANVASHEIGHT
		});
		$("canvas").attr({
			"width" : CURRENTCANVASWIDTH,
			"height" : CURRENTCANVASHEIGHT
		});
		$("#menuDiv").css({
			"top" : CURRENTCANVASHEIGHT - MENUBARHEIGHT,
		 "buttom":CURRENTCANVASHEIGHT-MENUBARHEIGHT
		});

		redrawCurrentPageContents();
		var message = 'CURRENTCANVASWIDTH: ' + CURRENTCANVASWIDTH + '\nCURRENTCANVASHEIGHT:' + CURRENTCANVASHEIGHT;
		writeMessage(message);
		console.log('fullscreen');
		isCurrentlyFullscreen = false;
	}
}

redrawCurrentPageContents = function() {
	var arrayLength = contextListMaster.length;
	for (var i = 0; i < arrayLength; i++) {
		if (contextListMaster[i] != null && contextListMaster[i] != undefined
				&& typeof contextListMaster[i] != 'undefined') {
			contextListMaster[i].clearRect(0, 0, CURRENTCANVASWIDTH,
					CURRENTCANVASHEIGHT);
		}
	}
	arrayLength = contextListSlave.length;
	for (var i = 0; i < arrayLength; i++) {
		if (contextListSlave[i] != null && contextListSlave[i] != undefined
				&& typeof contextListSlave[i] != 'undefined') {
			contextListSlave[i].clearRect(0, 0, CURRENTCANVASWIDTH,
					CURRENTCANVASHEIGHT);
		}
	}
	
	if (typeof savedDrawCommands[currentPage.toString()] != 'undefined') {

		saveDrawCommandsForCurrentPage = savedDrawCommands[currentPage
				.toString()];

		for (i = 0; i < saveDrawCommandsForCurrentPage.length; i++) {
			
			var drawCommand = saveDrawCommandsForCurrentPage[i];
			drawLinesSlave(drawCommand.slaveID, drawCommand.type,
					drawCommand.x, drawCommand.y);
		}

	}

	if (typeof savedDrawCommandsMaster[currentPage.toString()] != 'undefined') {

		saveDrawCommandsForCurrentPage = savedDrawCommandsMaster[currentPage
				.toString()];

		for (i = 0; i < saveDrawCommandsForCurrentPage.length; i++) {
			
			var drawCommand = saveDrawCommandsForCurrentPage[i];
			drawLinesMaster(0, drawCommand.type,
					drawCommand.x, drawCommand.y);
		}

	}
	
	renderPresentationPage(presentationPdf);

}