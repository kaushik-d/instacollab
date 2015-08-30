/**
 * 
 */
var Chat = {};
Chat.socket = null;

Chat.connect = (function(host) {
	
	if ('WebSocket' in window) {
		Chat.socket = new WebSocket(host);
	} else if ('MozWebSocket' in window) {
		Chat.socket = new MozWebSocket(host);
	} else {
		Console.log('Error: WebSocket is not supported by this browser.');
		return;
	}

	Chat.socket.onopen = function() {
		Console.log('Info: WebSocket connection opened. Meeting Room#' + myMeeringRoomNum);
		document.getElementById('chat').onkeydown = function(event) {
			if (event.keyCode == 13) {
				Chat.sendMessage();
			}
		};
	};

	Chat.socket.onclose = function() {
		document.getElementById('chat').onkeydown = null;
		Console.log('Info: WebSocket closed.');
	};

	Chat.socket.onmessage = function(message) {
		// Console.log(message.data);
		processCommands(message.data);
	};
});

Chat.initialize = function() {
	var url = 'ws://';
	
	if(window.location.host.indexOf("localhost") > -1) {
		url = window.location.host
		+ '/instacollab/websocket/chat/';
	} else {
		url = 'www.' + window.location.host
		+ '/websocket/chat/';
	}
	
	if (window.location.protocol == 'http:') {
		Chat.connect('ws://' + url + myMeeringRoomNum);
	} else {
		Chat.connect('wss://' + url + myMeeringRoomNum);
	}
};

Chat.sendMessage = (function() {
	var message = document.getElementById('chat').value;
	if (message != '') {
		Chat.socket.send(JSON.stringify({
			command : "textMessage",
			text : message
		}));
		document.getElementById('chat').value = '';
	}
});

var Console = {};

Console.log = (function(message) {
	var console = document.getElementById('console');
	var p = document.createElement('p');
	p.style.wordWrap = 'break-word';
	p.innerHTML = message;
	console.appendChild(p);
	while (console.childNodes.length > 25) {
		console.removeChild(console.firstChild);
	}
	console.scrollTop = console.scrollHeight;
});

processCommands = function(message) {
	var mes = JSON.parse(message);
	if (mes.command === "initCanvasSlave") {
		initCanvasSlave(mes.canvasID.trim());
	} else if (mes.command === "drawLinesSlave") {
		if(mes.pageNum === currentPage) {
			drawLinesSlave(mes.slaveID, mes.type, mes.x, mes.y);
		}
		saveDrawLinesSlave(mes);
	} else if (mes.command === "setMySlaveID") {
		setMySlaveID(mes);
	} else if (mes.command === "finalizeCanvasSlave") {
		finalizeCanvasSlave(mes.canvasID.trim());
	} else if (mes.command === "textMessage") {
		Console.log(mes.text);
	} else if (mes.command === "changePage") {
		changePage(mes.currentPage);
	}
}

setMySlaveID = function(mes){
	canvasName = mes.canvasID.trim();
	mySlaveID = parseInt(canvasName.substring(1, canvasName.length));
	isPresentation = mes.isPresentation;
	presentationURI = mes.presentationURI;
	currentPage = mes.currentPage;
	
	if(isPresentation == true){
		getPresentationFile(mes);
	}
	
	if(!isPresentation) {
		currentPage = 0;
		initBlankCanvasPresentation();
	}
	
	email = mes.email;
	name = mes.name;
	topic = mes.topic;
	
	$("#MeetingRoom").html('<span class=\"infolabel\">Meeting room#:</span> <span class=\"info\">'+ myMeeringRoomNum+'</span>');
	$("#MeetingTopic").html('<span class=\"infolabel\">Meeting topic: </span><span class=\"info\">' + topic+'</span>');
	$("#MeetingHost").html('<span class=\"infolabel\">Meeting host: </span><span class=\"info\">' + name+'</span>');
	$("#MeetingHostEmail").html('<span class=\"infolabel\">Host e-mail: </span><span class=\"info\">' + email +'</span>');
}


getPresentationFile = function(mes) {
	var blob = null;
	xmlhttp = new XMLHttpRequest();
	xmlhttp.onreadystatechange = function() {
		if (xmlhttp.readyState == 4 && xmlhttp.status == 200) {
			blob = xmlhttp.response;
			presentationURI = URL.createObjectURL(blob);
			//currentPage = 0;
			initCanvasPresentation();
		}
	}
	xmlhttp.open("POST", "downloadFile", true);
	var params = "data=" + encodeURIComponent(JSON.stringify(mes));
	xmlhttp.setRequestHeader("Content-type","application/x-www-form-urlencoded");
	xmlhttp.responseType = "blob";
	xmlhttp.send(params);
}

saveDrawLinesSlave = function(mes){
	//if( typeof savedDrawCommands[currentPage.toString()] == 'undefined' ){
	//	savedDrawCommands[currentPage.toString()] = new Array();
	//}
	//savedDrawCommands[currentPage.toString()].push(mes);
	if( typeof savedDrawCommands[mes.pageNum.toString()] == 'undefined' ){
		savedDrawCommands[mes.pageNum.toString()] = new Array();
	}
	savedDrawCommands[mes.pageNum.toString()].push(mes);
}