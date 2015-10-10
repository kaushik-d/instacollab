/**
 * 
 */

var canvasListMaster = new Array();
var contextListMaster = new Array();
var lineStartedListMaster = new Array();
var oldxListMaster = new Array();
var oldyListMaster = new Array();

function drawLinesMaster(ID, type, x, y, color, penstyle) {
	//
	// Check drawLinesSlave
	//

	if (contextListMaster[ID] != null
			&& typeof contextListMaster[ID] != 'undefined'
			&& contextListMaster[ID] != undefined) {
		
		x = x * CURRENTCANVASWIDTH;
		y = y * CURRENTCANVASHEIGHT;

		contextListMaster[ID].beginPath();
		if (type === "lineStart") {
			oldxListMaster[ID] = x;
			oldyListMaster[ID] = y;
			lineStartedListMaster[ID] = true;
		} else if (type === "lineUpdate" && lineStartedListMaster[ID]) {
			contextListMaster[ID]
					.moveTo(oldxListMaster[ID], oldyListMaster[ID]);
			contextListMaster[ID].lineTo(x, y);
			oldxListMaster[ID] = x;
			oldyListMaster[ID] = y;
			//contextListMaster[ID].strokeStyle = '#ff0000';
			contextListMaster[ID].strokeStyle = color;
			contextListMaster[ID].lineWidth = 5;
			
			if(penstyle === 'E') {
				contextListMaster[ID].globalCompositeOperation = "destination-out";
				contextListMaster[ID].strokeStyle = "rgba(0,0,0,1)";
				contextListMaster[ID].lineWidth = 15;
			} else { // (currentPenstyle === 'P')
				contextListMaster[ID].globalCompositeOperation = "source-over";
			}
			
			contextListMaster[ID].stroke();
		} else {
			lineStartedListMaster[ID] = false;
		}
	}
}

function updateLine(evt) {
	evt.preventDefault();
	var ID = parseInt((this.id)[1]);
	var mousePos = getMousePos(canvasListMaster[ID], evt);

	var mes = {
		command : "drawLinesSlave",
		type : "lineUpdate",
		x : mousePos.x,
		y : mousePos.y,
		slaveID : mySlaveID,
		pageNum : currentPage,
		color: currentColor,
		penStyle: currentPenstyle
	};

	saveDrawLinesMaster(mes);

	Chat.sendMessage(JSON.stringify(mes));

	drawLinesMaster(ID, "lineUpdate", mousePos.x, mousePos.y, currentColor, currentPenstyle);
}

function startLine(evt) {
	evt.preventDefault();
	var ID = parseInt((this.id)[1]);
	var mousePos = getMousePos(canvasListMaster[ID], evt);

	var mes = {
		command : "drawLinesSlave",
		type : "lineStart",
		x : mousePos.x,
		y : mousePos.y,
		slaveID : mySlaveID,
		pageNum : currentPage,
		color: currentColor,
		penStyle: currentPenstyle
	};

	saveDrawLinesMaster(mes);

	//Chat.socket.send(JSON.stringify(mes));
	Chat.sendMessage(JSON.stringify(mes));

	drawLinesMaster(ID, "lineStart", mousePos.x, mousePos.y, currentColor, currentPenstyle);
	
	canvasListMaster[ID].addEventListener('mousemove', updateLine, false);
	canvasListMaster[ID].addEventListener('mousemove', updateMousePosition,
			false);
	canvasListMaster[ID].addEventListener('touchmove', updateLine, false);
	canvasListMaster[ID].addEventListener('touchmove', updateMousePosition,
			false);
}

function endLine(evt) {
	evt.preventDefault();
	var ID = parseInt((this.id)[1]);
	var mousePos = getMousePos(canvasListMaster[ID], evt);

	var mes = {
		command : "drawLinesSlave",
		type : "lineEnd",
		x : mousePos.x,
		y : mousePos.y,
		slaveID : mySlaveID,
		pageNum : currentPage,
		color: currentColor,
		penStyle: currentPenstyle
	};

	saveDrawLinesMaster(mes);

	//Chat.socket.send(JSON.stringify(mes));
	Chat.sendMessage(JSON.stringify(mes));

	drawLinesMaster(ID, "lineEnd", mousePos.x, mousePos.y, currentColor, currentPenstyle);
	canvasListMaster[ID].removeEventListener('mousemove', updateLine, false);
	canvasListMaster[ID].removeEventListener('mousemove', updateMousePosition,
			false);
	canvasListMaster[ID].removeEventListener('touchmove', updateLine, false);
	canvasListMaster[ID].removeEventListener('touchmove', updateMousePosition,
			false);
}

function initCanvasMaster(canvasName) {
	var ID = parseInt(canvasName.substring(1, canvasName.length));
	var canvasDiv = window.document.getElementById('canvasDiv');
	canvasListMaster[ID] = document.createElement('canvas');
	canvasListMaster[ID].id = canvasName;
	canvasListMaster[ID].width = INITICANVASWIDTH;
	canvasListMaster[ID].height = INITICANVASHEIGHT;
	canvasListMaster[ID].left = 0;
	canvasListMaster[ID].right = 0;
	canvasListMaster[ID].style.zIndex = 0;
	canvasDiv.appendChild(canvasListMaster[ID]);
	contextListMaster[ID] = canvasListMaster[ID].getContext('2d');
	lineStartedListMaster[ID] = false;
	oldxListMaster[ID] = 0;
	oldyListMaster[ID] = 0;
	canvasListMaster[ID].addEventListener('mousedown', startLine, false);
	canvasListMaster[ID].addEventListener('mouseup', endLine, false);
	canvasListMaster[ID].addEventListener('mouseout', endLine, false);
	canvasListMaster[ID].addEventListener('touchstart', startLine, false);
	canvasListMaster[ID].addEventListener('touchleave', endLine, false);
	canvasListMaster[ID].addEventListener('touchend', endLine, false);
}

saveDrawLinesMaster = function(mes) {
	if (typeof savedDrawCommandsMaster[currentPage.toString()] == 'undefined') {
		savedDrawCommandsMaster[currentPage.toString()] = new Array();
	}
	savedDrawCommandsMaster[currentPage.toString()].push(mes);
}