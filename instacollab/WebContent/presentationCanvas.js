/**
 * 
 */

function initCanvasPresentation() {

	var canvasDiv = window.document.getElementById('canvasDiv');
	canvasPresentation = document.createElement('canvas');
	canvasPresentation.id = "presentationCanvas";
	canvasPresentation.width = INITICANVASWIDTH;
	canvasPresentation.height = INITICANVASHEIGHT;
	canvasPresentation.left = 0;
	canvasPresentation.right = 0;
	canvasPresentation.style.zIndex = -10000;
	canvasDiv.appendChild(canvasPresentation);
	contextPresentation = canvasPresentation.getContext('2d');

	PDFJS.getDocument(presentationURI).then(function(pdf) {

		setUpPresentationFirst(pdf);
		//window.currentPage = 0;
		renderPresentationPage(pdf);

	});

}

function initBlankCanvasPresentation() {

	var canvasDiv = window.document.getElementById('canvasDiv');
	canvasPresentation = document.createElement('canvas');
	canvasPresentation.id = "presentationCanvas";
	canvasPresentation.width = INITICANVASWIDTH;
	canvasPresentation.height = INITICANVASHEIGHT;
	canvasPresentation.left = 0;
	canvasPresentation.right = 0;
	canvasPresentation.style.zIndex = -10000;
	canvasDiv.appendChild(canvasPresentation);
	contextPresentation = canvasPresentation.getContext('2d');
	contextPresentation.fillStyle="#FFFFFF";
	contextPresentation.fillRect(0,0,INITICANVASWIDTH,INITICANVASHEIGHT); 

}

setUpPresentationFirst = function(pdf) { 
	window.numPresentationPages = pdf.numPages;
	window.presentationPdf = pdf;
	
	$("#previousPage").removeClass('disabled');
	$("#previousPage").click(goPreviousPage);
	//$("#TotalPage").append("");
	//$("#TotalPage").children("*").remove();
	var TotalPage = window.document.getElementById('TotalPage');
	TotalPage.innerHTML="";
	$("#TotalPage").append(window.numPresentationPages.toString());
	$("#nextPage").removeClass('disabled');
	$("#nextPage").click(goNextPage);
	
	var pageNum1 = window.currentPage + 1;
	var Page = window.document.getElementById('currentPage');
	Page.innerHTML="";
	$("#currentPage").append(pageNum1.toString());
}

renderPresentationPage = function(pdf) {

	if (pdf != null && typeof pdf != 'undefined' && pdf != undefined) {
		
		pdf.getPage(currentPage + 1).then(function(page) {

			var viewport = page.getViewport(1);
			
			var scale = 1;
			var scale1 = 1;
			var scale2 = 1;
			
			if( CURRENTCANVASWIDTH > viewport.width ) {
				scale1 = CURRENTCANVASWIDTH / viewport.width;
			}
			
			if( CURRENTCANVASHEIGHT > viewport.height ) {
				scale2 = CURRENTCANVASHEIGHT / viewport.height;
			}
			
			if(scale1 > scale2) {
				scale = scale2;
			} else {
				scale = scale1;
			}
			
			var scaledViewport = page.getViewport(scale);

			var renderContext = {
				canvasContext : contextPresentation,
				viewport : scaledViewport
			};
			page.render(renderContext);
		});
	} else {
		contextPresentation.fillStyle="#FFFFFF";
		contextPresentation.fillRect(0,0,CURRENTCANVASWIDTH,CURRENTCANVASHEIGHT); 
	}
	
}

goPreviousPage = function() {
	if(currentPage > 0){
		//currentPage--;
		//redrawCurrentPageContents();
		var crr = currentPage - 1;
		changePage(crr);
		
		var mes = {
				command : "changePage",
				currentPage : currentPage
			};
		//Chat.socket.send(JSON.stringify(mes));
		Chat.sendMessage(JSON.stringify(mes));
	}
}

goNextPage = function() {
	if(currentPage < numPresentationPages-1){
		var crr = currentPage + 1;
		changePage(crr);
		//redrawCurrentPageContents();
		var mes = {
				command : "changePage",
				currentPage : currentPage,
				room : myMeeringRoomNum
			};
		//Chat.socket.send(JSON.stringify(mes));
		Chat.sendMessage(JSON.stringify(mes));
	}
}

changePage = function(pageNum) {
	if(pageNum < numPresentationPages && pageNum >= 0){
		currentPage = pageNum;
		redrawCurrentPageContents();
		
		var pageNum1 = pageNum + 1;
		var Page = window.document.getElementById('currentPage');
		Page.innerHTML="";
		$("#currentPage").append(pageNum1.toString());
		
		if(pageNum1 == numPresentationPages){
			$("#nextPage").addClass('disabled');
			$("#previousPage").removeClass('disabled');
		}
		if(pageNum1 == 1){
			$("#previousPage").addClass('disabled');
			$("#nextPage").removeClass('disabled');
		}
		if(pageNum1 != 1 && pageNum1 != numPresentationPages){
			$("#previousPage").removeClass('disabled');
			$("#nextPage").removeClass('disabled');
		}
	}
}

