<?php session_start(); ?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>Booking Purchasing</title>
<link href="style.css" rel="stylesheet" type="text/css" />
<link rel="stylesheet" href="css/bookingStyle.css" type="text/css" />
<script type="text/javascript" src="http://code.jquery.com/jquery-1.8.0.min.js"></script>
<script type="text/javascript" src="js/bookingScript.js"></script>
</head>
<body>
<!--header start -->
	<div id="header">
    	<!--top start -->
        	<div id="top">
           	  <ul>
               	<li><a href="#" class="hover">Home</a></li>
                    <li><a href="#">About us</a></li>
                    <li><a href="#">News</a></li>
                    <li><a href="#">Blog</a></li>
                    <li><a href="#">Contact</a></li>
              </ul>
        	</div>
        <!--top end -->
        <!--headLeft start -->
        	<div id="headLeft"><a href="index.html"><img src="./images/skyscanner_app_0_7.jpg" width="243" height="121" />
            </a>
                 <p><span>See Our new Discounts</span>
                <a href="#">read mor</a></p>
            <br class="spacer" />
      </div>
        <!--headLeft end -->
        <!--headRight start -->
        	<div id="headRight">
            	<h2>Want to be a Member ?</h2>
                <form name="f1" action="#" method="post">
                	<label class="formTxt">-Enter Your Name-</label>
                	<input type="text" name="t1" value="" class="txtBox1" />
                    <label class="formTxt">-Enter Your Password-</label>
                    <input type="password" name="t2" value="" class="txtBox1" />
                    <label class="fp"><a href="#">Forgot&nbsp;Password</a></label>
                    <input type="submit" name="login" value="" class="login" />
                    <label class="reg"><a href="#">FREE Registration</a></label>
                <br class="spacer" />
                </form>
            <br class="spacer" />
            </div>
        <!--headRight end -->
        <ul class="botLink">
        	<li><a href="#">Whats New ~~~</a></li>
            <li><a href="#">What Our Goal</a></li>
            <li><a href="#">Rise in Air In a Different Way Towards Success</a></li>
            <li><a href="#"> Our  Updates</a></li>
            <li class="noMargin2"><a href="#">Why Choose Our Site</a></li>
        </ul>
    <br class="spacer" />
    </div>
<!--header end -->

<!--body2 start -->
	<div id="body2">
	
	<div id="booking">
      <div id="purchase">
        
        <div id="status">
          <h1>Online Ticket Booking</h1>
          <div id="statuspicture4"></div>
	    </div>
        <br/>
        
		<?php
//		session_start();
		$_SESSION["bookingtravelname"] = $_POST["bookingtravelname"];
		$_SESSION["bookingtravelid"] = $_POST["bookingtravelid"];
		$_SESSION["bookingtravelmobile"] = $_POST["bookingtravelmobile"];
		$_SESSION["bookingtravelemail"] = $_POST["bookingtravelemail"];
/*	
		echo $_SESSION["bookingselecttype"]." type<br/>";
		echo $_SESSION["bookingselectfrom"]." from<br/>";
		echo $_SESSION["bookingselectto"]." to<br/>";
		echo $_SESSION["bookingselectdeparture"]." departure<br/>";
		echo $_SESSION["bookingselectreturn"]." return<br/>";
		echo $_SESSION["bookingselectadultnum"]." adult<br/>";
		echo $_SESSION["bookingselectchildnum"]." child<br/>";
		echo $_SESSION["bookingselectinfantnum"]." infant<br/>";
		echo $_SESSION["bookingselectflight"]." flight<br/>";
		echo $_SESSION["bookingselectclass"]." class<br/>";
		echo $_SESSION["bookingselectid"]." id<br/>";
		echo $_SESSION["bookingselectreturnflight"]." flight<br/>";
		echo $_SESSION["bookingselectreturnclass"]." class<br/>";
		echo $_SESSION["bookingselectreturnid"]." id<br/>";
		echo $_SESSION["bookingselectfare"]." fare<br/>";
		echo $_SESSION["bookingtravelname"]." name<br/>";
		echo $_SESSION["bookingtravelid"]." id<br/>";
		echo $_SESSION["bookingtravelmobile"]." mobile<br/>";
		echo $_SESSION["bookingtravelemail"]." email<br/>";
	*/	
		?>
		
        <div id="formwrapper">
        <fieldset>
        <form id="" method="post" action="bookingconfirm.php" onsubmit="return bookingpayment.validateform()">
        
          <h3>Passenger's Card Details</h3><hr/>
		  <input type="radio" name="bookingpaymenttype" checked="checked" value="VISA"/><label class="labelradio"> VISA</label>
          <input type="radio" name="bookingpaymenttype" value="Master Card"/><label class="labelradio"> Mastercard</label>
          <br/><br/>
		  
          <label class="labelblock">Card Number:</label>
            	<input type="text" id="bookingpaymentcardnum" onblur="bookingpayment.checkcardnum()"/><label id="cardnumerror"></label>
          <label class="labelblock">Security Code:</label>
            	<input type="text" id="bookingpaymentsecuritycode" onblur="bookingpayment.checkscode()"/><label id="securitycodeerror"></label>
          <label class="labelblock">Name on Card:</label>
            	<input type="text" id="bookingpaymentname" onblur="bookingpayment.checkname()"/><label id="cardnameerror"></label>
          
          <br/><br/>
		  

		<input type="hidden" id="inputcardnum" name="bookingpaymentcardnum" value=""/>
		<input type="hidden" id="inputscode" name="bookingpaymentscode" value=""/>
		<input type="hidden" id="inputcardname" name="bookingpaymentname" value=""/>
		  
        <input type="submit" value="Pay Now" onclick="bookingpayment.addinfo()"/><label id="bookingpaymenterror"></label>
          
        
        </form>
        </fieldset>
        </div>
       
       </div>
     </div>
	
	<br class="spacer" />
    </div>
<!--body2 end -->
<!--footer start -->
	<div id="footer">
    	 <p class="copy">&nbsp;</p>
          
    	<ul class="botLink">
    		 <li><a href="#">Home</a>|</li>
             <li><a href="#">About&nbsp;us</a>|</li>
             <li><a href="#">Support</a>|</li>
             <li><a href="#">Solutions </a>|</li>
             <li><a href="#">Targets</a>|</li>
             <li><a href="#">Signup</a>|</li>
             <li><a href="#">Meetings</a>|</li>
             <li><a href="#">News</a>|</li>
             <li><a href="#">Blog</a>|</li>
              <li><a href="#">Contact</a></li>
     	</ul>
        <ul class="botLink2">
        		<li></li>
            <li></li>
        </ul>
        <p class="design">Designed By:ruby</p>
    </div>
<!--footer end -->
</body>
</html>