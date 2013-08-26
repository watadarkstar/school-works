
function createXmlHttpRequestObject(){
	var xmlTemp;
/*	
	if(window.ActiveXObject){
		try{
			xmlHttp = new ActiveXObject("Microsoft.XMLHTTP");
		}catch(e){
			xmlHttp = false;
		}
	}else {
		try{
			xmlHttp = new XMLHttpRequest();	
		}catch(e){
			xmlHttp = false;
		}
	}
*/
	if(window.XMLHttpRequest){
		xmlTemp = new XMLHttpRequest();
	}else {
		xmlTemp = new ActiveXObject("Microsoft.XMLHTTP");
	}	
	if(!xmlTemp){
		console.log("Failed in creating XMLHttpRequest");
	}else{
		return xmlTemp;
	}
}


var xmlHttp = createXmlHttpRequestObject();
var xmlHttp1 = createXmlHttpRequestObject();


function process(){
	// if object is ready and free to communicate with the server
	if(xmlHttp.readyState==0 || xmlHttp.readyState==4){
		var bookingfrom = 'bookingsearchfrom='+document.getElementById("from").innerHTML;
		var bookingto = 'bookingsearchto='+document.getElementById("to").innerHTML;
		var bookingradio = 'bookingselectradio='+document.getElementById("inputradio").value;
		var bookingdate = 'bookingsearchdeparture='+document.getElementById("departure").innerHTML;
		xmlHttp.open("POST","./server/formGenerator.php", true);
		xmlHttp.setRequestHeader("Content-type","application/x-www-form-urlencoded");
		xmlHttp.onreadystatechange = handleServerResponse;
		xmlHttp.send(bookingfrom+"&"+bookingto+"&"+bookingradio+"&"+bookingdate);
	}else {
		console.log("something wrong with process()");
//		setTimeout('process()', 2000);
	}
	setTimeout('process()', 2000);
}

function handleServerResponse(){
	// if done communicating && if communication is OKAY  && xmlHttp.status==200
	if(xmlHttp.readyState==4 && xmlHttp.status==200){
			document.getElementById("ajaxForm").innerHTML = xmlHttp.responseText;
//			console.log("something right");
//			setTimeout('process()', 2000);
	}else {
			//console.log("something wrong with handleServerResponse()");
		
	}
//	setTimeout('process()', 2000);
	
}

function process1(){
	// if object is ready and free to communicate with the server
	if(xmlHttp1.readyState==0 || xmlHttp1.readyState==4){
		var bookingfrom = 'bookingsearchfrom='+document.getElementById("from").innerHTML;
		var bookingto = 'bookingsearchto='+document.getElementById("to").innerHTML;
		var bookingradio = 'bookingselectreturnradio='+document.getElementById("inputreturnradio").value;
		var bookingsearchtype = 'bookingsearchtype='+document.getElementById("type").innerHTML;
		var bookingdate = 'bookingreturndate='+document.getElementById("returnd").innerHTML;
		xmlHttp1.open("POST","./server/returnFormGenerator.php", true);
		xmlHttp1.setRequestHeader("Content-type","application/x-www-form-urlencoded");
		xmlHttp1.onreadystatechange = handleServerResponse1;
		xmlHttp1.send(bookingfrom+"&"+bookingto+"&"+bookingradio+"&"+bookingsearchtype+"&"+bookingdate);
	}else {
		console.log("something wrong with process1()");
//		setTimeout('process1()', 2000);
	}
	setTimeout('process1()', 2000);
}

function handleServerResponse1(){
	// if done communicating && if communication is OKAY  && xmlHttp.status==200
	if(xmlHttp1.readyState==4 && xmlHttp1.status==200){
			document.getElementById("ajaxReturnForm").innerHTML = xmlHttp1.responseText;
//			setTimeout('process1()', 2000);
	}else {
			//console.log("something wrong with handleServerResponse1()");
		
	}
	
}
