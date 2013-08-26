// run codes when load (setting today's date)
$(document).ready( function() {
    var now = new Date();
    var month = (now.getMonth() + 1);               
    var day = now.getDate();
    if(month < 10) 
        month = "0" + month;
    if(day < 10) 
        day = "0" + day;
    //var today = now.getFullYear() + '-' + month + '-' + day;
	var today = now.getFullYear() + '-' + month + '-' + day;
    $('#bookingsearchdeparture').val(today);
	$('#bookingsearchrounddeparture').val(today);
	$('#bookingsearchroundreturn').val(today);
});

// BOOKINGSEARCH namespace
var bookingsearch = new function(){
	var labelto = 0;
	var labelfrom = 0;
	var labelroundto = 0;
	var labelroundfrom = 0;
	
	// clean the value within the tag
	var clean = function(x){
	  document.getElementById(x).value = "";
	};
	
	// check cities in "ONE WAY"
	this.checkfrom = function(){
	  var from = document.getElementById("bookingsearchfrom").value;
	  var element = document.getElementById("labelfrom");
	  if(from.length == 0){
		  element.innerHTML = " Please select Departure City";
		  element.style.color = "red";
		  element.style.fontSize = "12px";
		  return false;
	  }else {
		  element.innerHTML = "";
		  return true;
	  }
	};
	
	// same
	this.checkto = function(){
	  var to = document.getElementById("bookingsearchto").value;
	  var element = document.getElementById("labelto");
	  if(to.length == 0){
		  element.innerHTML = " Please select Destination City";
		  element.style.color = "red";
		  element.style.fontSize = "12px";
		  return false;
	  }else {
		  element.innerHTML = "";
		  return true;
	  }
	};
	
	// check cities in "ROUND TRIP"
	this.checkroundfrom = function(){
	  var from = document.getElementById("bookingsearchroundfrom").value;
	  var element = document.getElementById("labelroundfrom");
	  if(from.length == 0){
		  element.innerHTML = " Invalid Departure City";
		  element.style.color = "red";
		  element.style.fontSize = "12px";
		  return false;
	  }else {
		  element.innerHTML = "";
		  return true;
	  }
	};
	
	// same
	this.checkroundto = function(){
	  var to = document.getElementById("bookingsearchroundto").value;
	  var element = document.getElementById("labelroundto");
	  if(to.length == 0){
		  element.innerHTML = " Invalid Destination City";
		  element.style.color = "red";
		  element.style.fontSize = "12px";
		  return false;
	  }else {
		  element.innerHTML = "";
		  return true;
	  }
	};

	// regular expression to validate date
	var regex =  /^\d{4}[./-]\d{2}[./-]\d{2}$/;
	
	// validate our form
	this.validateform = function(){
		// validate form if type is "one way"
		if(document.getElementById("single").checked){
			var checked = true;
			if(this.checkto() == false) checked = false;
			if(this.checkfrom() == false) checked = false;
			
			var a = document.getElementById("bookingsearchfrom").value;
			var b = document.getElementById("bookingsearchto").value;
			
			
			var x = document.getElementById("bookingsearchdeparture").value;
			var element = document.getElementById("errorlabel");
			
			if(checked == false){
				element.innerHTML = " Please check your departure/destination city."
				element.style.color = "red";
				element.style.fontSize = "14px";
				return false;
			}else if(a == b){
				element.innerHTML = " Departure and Destination cities cannot be the same."
				element.style.color = "red";
				element.style.fontSize = "14px";
				return false;
			}else if(x==null || x=="" || !regex.test(x)){
				element.innerHTML = " Please check your departure date."
				element.style.color = "red";
				element.style.fontSize = "14px";
				return false;
			}else {
				element.innerHTML = "";
				return true;
			}
			
		// validate form if type is "round trip"
		}else if(document.getElementById("round").checked){
			var checked = true;
			if(this.checkroundfrom() == false) checked = false;
			if(this.checkroundto() == false) checked = false;
			
			var element = document.getElementById("errorroundlabel");
			
			var a = document.getElementById("bookingsearchroundfrom").value;
			var b = document.getElementById("bookingsearchroundto").value;
			
			var x = document.getElementById("bookingsearchrounddeparture").value;
			var y = document.getElementById("bookingsearchroundreturn").value;
			
			
			
			if(checked == false){
				element.innerHTML = " Please check your departure/destination city."
				element.style.color = "red";
				element.style.fontSize = "14px";
				return false;
			}else if(a == b){
				element.innerHTML = " Departure and Destination cities cannot be the same."
				element.style.color = "red";
				element.style.fontSize = "14px";
				return false;
			}else if(x==null || x=="" || !regex.test(x)){
				element.innerHTML = " Please check your departure date."	
				element.style.color = "red";
				element.style.fontSize = "14px";
				return false;
			}else if(y==null || y=="" || !regex.test(y)){
				element.innerHTML = " Please check your return date."
				element.style.color = "red";
				element.style.fontSize = "14px";
				return false;
			}else if(x>y){
				element.innerHTML = " Departure Date cannot be after Return Date."
				element.style.color = "red";
				element.style.fontSize = "14px";
				return false;
			}else {
				element.innerHTML = "";
				return true;
			}
			
		}
	};
	
	// create dynamic form base on it is either "one way" or "round trip"
	this.commitSave = function(){
		if(document.getElementById("single").checked){
			document.getElementById("no1").style.display = "";
			document.getElementById("no2").style.display = "none";
			document.getElementById("no3").style.display = "";
			document.getElementById("no4").style.display = "none";
		}
		if(document.getElementById("round").checked){
			document.getElementById("no1").style.display = "none";
			document.getElementById("no2").style.display = "";
			document.getElementById("no3").style.display = "none";
			document.getElementById("no4").style.display = "";
		}
	};
};

// BOOKINGSELECT namespace
var bookingselect = new function(){

	// check at least one radio is selected
	this.isOneChecked = function(x){
		var chx = document.getElementsByName(x);
		for(var i = 0; i<chx.length; i++){
			if(chx[i].type == 'radio' && chx[i].checked){
				return true;
			}
		}
		return false;
	};

	// rewrite departure total
	this.rewritedeparture = function(x){
		var parse = document.getElementById(x).value.split(',');
		var fare = parse[0];
		var finfo = parse[1];
		var fclass = parse[2];
		var fid = parse[3];
		
		// calculate and rewrite departure fare
		var adultf = document.getElementById("adultfare");
		var adultn = parseInt(document.getElementById("adultnumber").innerHTML);
		adultf.innerHTML = fare * adultn;
		
		var childf = document.getElementById("childfare");
		var childn = parseInt(document.getElementById("childnumber").innerHTML);
		childf.innerHTML = fare * childn;
		
		var infantf = document.getElementById("infantfare");
		var infantn = parseInt(document.getElementById("infantnumber").innerHTML);
		infantf.innerHTML = fare * infantn;
		
		var totalf = document.getElementById("departurefare");
		totalf.innerHTML = parseInt(adultf.innerHTML) + parseInt(childf.innerHTML) + parseInt(infantf.innerHTML); 
		
		// rewrite total
		this.rewritetotal();
		
		// save information in hidden inputs
		var iclass = document.getElementById("inputclass");
		iclass.value = fclass;
		var iinfo = document.getElementById("inputflight");
		iinfo.value = finfo;
		var iid = document.getElementById("inputid");
		iid.value = fid;
		var iradio = document.getElementById("inputradio");
		iradio.value = x;
		
		
	};
	
	// rewrite return total
	this.rewritereturn = function(x){
		var parse = document.getElementById(x).value.split(',');
		var fare = parse[0];
		var finfo = parse[1];
		var fclass = parse[2];
		var fid = parse[3];
		
		// calculate and rewrite return fare
		var adultf = document.getElementById("adultreturnfare");
		var adultn = parseInt(document.getElementById("adultnumber").innerHTML);
		adultf.innerHTML = fare * adultn;
		
		var childf = document.getElementById("childreturnfare");
		var childn = parseInt(document.getElementById("childnumber").innerHTML);
		childf.innerHTML = fare * childn;
		
		var infantf = document.getElementById("infantreturnfare");
		var infantn = parseInt(document.getElementById("infantnumber").innerHTML);
		infantf.innerHTML = fare * infantn;
		
		var totalf = document.getElementById("returnfare");
		totalf.innerHTML = parseInt(adultf.innerHTML) + parseInt(childf.innerHTML) + parseInt(infantf.innerHTML); 
		
		// rewrite total
		this.rewritetotal();
		
		// save information in hidden inputs
		var iclass = document.getElementById("inputreturnclass");
		iclass.value = fclass;
		var iinfo = document.getElementById("inputreturnflight");
		iinfo.value = finfo;
		var iid = document.getElementById("inputreturnid");
		iid.value = fid;
		var iradio = document.getElementById("inputreturnradio");
		iradio.value = x;
	};
	
	// rewrite total fare
	this.rewritetotal = function(){
		var departureFare = document.getElementById("departurefare").innerHTML;
		var returnFare = document.getElementById("returnfare").innerHTML;
		
		var total = document.getElementById("totalfare");
		total.innerHTML = parseInt(departureFare) + parseInt(returnFare);
	};
	
	this.checkdeparture = function(){
		var element = document.getElementById("departureerror");
		var fare = parseInt(document.getElementById("departurefare").innerHTML);
		if(fare == 0 || !this.isOneChecked("bookingselecttype")){
			element.innerHTML = " You must select a departure schedule."
			element.style.color = "red";
			element.style.fontSize = "14px";
			return false;
		}else{
			element.innerHTML = "";
			return true;
		}
	};
	
	this.checkreturn = function(){
		var element = document.getElementById("returnerror");
		var isRoundTrip = document.getElementById("type").innerHTML;
		var fare = parseInt(document.getElementById("returnfare").innerHTML);
		if(isRoundTrip == "Round Trip" && (fare == 0 || !this.isOneChecked("bookingselectreturntype"))){
			element.innerHTML = " You must select a return schedule."
			element.style.color = "red";
			element.style.fontSize = "14px";
			return false;
		}else{
			element.innerHTML = "";
			return true;
		}
	};
	
	// validate our form
	this.validateform = function(){
		var total = document.getElementById("departurefare");
		var isRoundTrip = document.getElementById("type").innerHTML;
		var checked = true;
		if(this.checkdeparture() == false) checked = false;
		if(isRoundTrip == "Round Trip" && this.checkreturn() == false) checked = false;
		
		if(checked == false){
			return false;
		}else {
			return true;
		}
	};
	
	// setting hidden input data
	this.addinfo = function(){
		var type = document.getElementById("inputtype");
		type.value = document.getElementById("type").innerHTML;
	
		var from = document.getElementById("inputfrom");
		from.value = document.getElementById("from").innerHTML;
		
		var to = document.getElementById("inputto");
		to.value = document.getElementById("to").innerHTML;
		
		var adultnum = document.getElementById("inputadultnum");
		adultnum.value = document.getElementById("adultnumber").innerHTML;
		
		var childnum = document.getElementById("inputchildnum");
		childnum.value = document.getElementById("childnumber").innerHTML;
		
		var infantnum = document.getElementById("inputinfantnum");
		infantnum.value = document.getElementById("infantnumber").innerHTML;
		
		var fare = document.getElementById("inputfare");
		fare.value = document.getElementById("totalfare").innerHTML;
	};
};

// BOOKINGTRAVEL namespace
var bookingtravel = new function(){

	// check name
	this.checkname = function(){
		var name = document.getElementById("bookingtravelname").value;
		var element = document.getElementById("nameerror");
		var isname = /^[a-zA-Z ]+$/.test(name);
		if(name.length == 0){
			element.innerHTML = " Please insert your name correctly";
			element.style.color = "red";
			element.style.fontSize = "12px";
			return false;
		}else if(!isname){
			element.innerHTML = " Please insert English characters only";
			element.style.color = "red";
			element.style.fontSize = "12px";
			return false;
		}else {
			element.innerHTML = "";
			return true;
		}
	};
	
	// check id
	this.checkid = function(){
		var name = document.getElementById("bookingtravelid").value;
		var element = document.getElementById("iderror");
		if(name.length == 0){
			element.innerHTML = " Please insert your id correctly";
			element.style.color = "red";
			element.style.fontSize = "12px";
			return false;
		}else {
			element.innerHTML = "";
			return true;
		}
	};
	
	// check mobile no
	this.checkmobile = function(){
		var name = document.getElementById("bookingtravelmobile").value;
		var element = document.getElementById("mobileerror");
		var isnum = /^\d+$/.test(name);
		if(name.length != 8){
			element.innerHTML = " Please insert your mobile number correctly (8 digits)";
			element.style.color = "red";
			element.style.fontSize = "12px";
			return false;
		}else if(!isnum){
			element.innerHTML = " Please insert numbers only";
			element.style.color = "red";
			element.style.fontSize = "12px";
			return false;
		}else {
			element.innerHTML = "";
			return true;
		}
	};

	// check email
	this.checkemail = function(){
		var name = document.getElementById("bookingtravelemail").value;
		var element = document.getElementById("emailerror");
		var pattern = /^\w+@[a-zA-Z_]+?\.[a-zA-Z]{2,3}$/.test(name);
		if(name.length == 0){
			element.innerHTML = " Please insert your email correctly";
			element.style.color = "red";
			element.style.fontSize = "12px";
			return false;
		}else if(!pattern){
			element.innerHTML = " Please insert in correct form of your_email@your_site.com";
			element.style.color = "red";
			element.style.fontSize = "12px";
			return false;
		}else {
			element.innerHTML = "";
			return true;
		}
	};
	
	// validate our form
	this.validateform = function(){
		
		var checked = true;
		if(this.checkname()==false) checked = false;
		if(this.checkid()==false) checked = false;
		if(this.checkmobile()==false) checked = false;
		if(this.checkemail()==false) checked = false;
		
		if(checked == false){
			var error = document.getElementById("bookingtravelerror");
			error.innerHTML = " Please check your form";
			error.style.color = "red";
			error.style.fontSize = "14px";
			return false;
		}
		return true;
	};
	
	// set data
	this.addinfo = function(){
		var name = document.getElementById("inputname");
		name.value = document.getElementById("bookingtravelname").value;
		
		var id = document.getElementById("inputcontactid");
		id.value = document.getElementById("bookingtravelid").value;
		
		var mobile = document.getElementById("inputmobile");
		mobile.value = document.getElementById("bookingtravelmobile").value;
		
		var email = document.getElementById("inputemail");
		email.value = document.getElementById("bookingtravelemail").value;
	};
	
};

// BOOKINGPAYMENT namespace
var bookingpayment = new function(){
	// check card no
	this.checkcardnum = function(){
		var name = document.getElementById("bookingpaymentcardnum").value;
		var element = document.getElementById("cardnumerror");
		var isnum = /^\d+$/.test(name);
		if(name.length != 16){
			element.innerHTML = " Please insert your card num correctly (16 digits)";
			element.style.color = "red";
			element.style.fontSize = "12px";
			return false;
		}else if(!isnum){
			element.innerHTML = " Please insert numbers only";
			element.style.color = "red";
			element.style.fontSize = "12px";
			return false;
		}else {
			element.innerHTML = "";
			return true;
		}
	};
	
	// check security code
	this.checkscode = function(){
		var name = document.getElementById("bookingpaymentsecuritycode").value;
		var element = document.getElementById("securitycodeerror");
		var isnum = /^\d+$/.test(name);
		if(name.length != 3){
			element.innerHTML = " Please insert your security code correctly (3 digits)";
			element.style.color = "red";
			element.style.fontSize = "12px";
			return false;
		}else if(!isnum){
			element.innerHTML = " Please insert numbers only";
			element.style.color = "red";
			element.style.fontSize = "12px";
			return false;
		}else {
			element.innerHTML = "";
			return true;
		}
	};
	
	// check name
	this.checkname = function(){
		var name = document.getElementById("bookingpaymentname").value;
		var element = document.getElementById("cardnameerror");
		var isname = /^[a-zA-Z ]+$/.test(name);
		if(name.length == 0){
			element.innerHTML = " Please insert your name correctly";
			element.style.color = "red";
			element.style.fontSize = "12px";
			return false;
		}else if(!isname){
			element.innerHTML = " Please insert English characters only";
			element.style.color = "red";
			element.style.fontSize = "12px";
			return false;
		}else {
			element.innerHTML = "";
			return true;
		}
	};
	
	// set data
	this.addinfo = function(){
		
		var cardnum = document.getElementById("inputcardnum");
		cardnum.value = document.getElementById("bookingpaymentcardnum").value;
		
		var scode = document.getElementById("inputscode");
		scode.value = document.getElementById("bookingpaymentsecuritycode").value;
		
		var cname = document.getElementById("inputcardname");
		cname.value = document.getElementById("bookingpaymentname").value;
	};
	
	// validate our form
	this.validateform = function(){
		var checked = true;
		if(this.checkcardnum()==false) checked = false;
		if(this.checkscode()==false) checked = false;
		if(this.checkname()==false) checked = false;
		
		if(checked == false){
			var error = document.getElementById("bookingpaymenterror");
			error.innerHTML = "Please check your form";
			error.style.color = "red";
			error.style.fontSize = "14px";
			return false;
		}
		return true;
	};
};
		