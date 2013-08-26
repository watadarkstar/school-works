<?php session_start(); ?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>Booking Confirmation</title>
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
                <a href="#">read more</a></p>
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
      <div id="confirm">	
        
        <div id="status">
          <h1>Online Ticket Booking</h1>
          <div id="statuspicture5"></div>
        </div>
        <br/>
		  
		<?php
//		session_start();
		$_SESSION['bookingpaymenttype'] = $_POST['bookingpaymenttype'];
		$_SESSION['bookingpaymentcardnum'] = $_POST['bookingpaymentcardnum'];
		$_SESSION['bookingpaymentscode'] = $_POST['bookingpaymentscode'];
		$_SESSION['bookingpaymentname'] = $_POST['bookingpaymentname'];
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
		
		echo $_SESSION["bookingpaymenttype"]." ptype<br/>";
		echo $_SESSION["bookingpaymentcardnum"]." cardnum<br/>";
		echo $_SESSION["bookingpaymentscode"]." scode<br/>";
		echo $_SESSION["bookingpaymentname"]." name<br/>";
*/
		?>
          
		<div id="formwrapper">
		<fieldset>
		<form id="" method="post" action="bookingthankyou.php" onsubmit="">

		<h2>Booking Confirmation</h2><hr/>
		<p> Would you like to confirm your booking? </p>
		<hr/>

		<h3><?php echo $_SESSION["bookingselecttype"];?></h3><br/>
		<fieldset>
		<h3>Ticket Information</h3><hr/>
		<p>From <label><?php echo $_SESSION["bookingselectfrom"];?></label> to <label><?php echo $_SESSION["bookingselectto"];?></label></p>
		<h4> Departure </h4>
		<p>Departure Date: <label><?php echo $_SESSION["bookingselectdeparture"];?></label></p>
		<p>Flight Number: <label><?php echo $_SESSION["bookingselectflight"];?></label></p>
		<p>Cabin: <label><?php 
							if($_SESSION["bookingselectclass"] == "first"){
								echo "First Class";
							}else if($_SESSION["bookingselectclass"] == "business"){
								echo "Business Class";
							}else if($_SESSION["bookingselectclass"] == "premium"){
								echo "Premium Economy Class";
							}else {
								echo "Economy Class";
							}
								?></label></p>
		<?php
			if ($_SESSION["bookingselecttype"] == "Round Trip"){
				echo "<h4> Return </h4>";
				echo "<p>Return Date: <label>".$_SESSION["bookingselectreturn"]."</label></p>";
				echo "<p>Flight Number: <label>".$_SESSION["bookingselectreturnflight"]."</label></p>";
				echo "<p>Cabin: <label>";
				if($_SESSION["bookingselectreturnclass"] == "first"){
					echo "First Class";
				}else if($_SESSION["bookingselectreturnclass"] == "business"){
					echo "Business Class";
				}else if($_SESSION["bookingselectreturnclass"] == "premium"){
					echo "Premium Economy Class";
				}else {
					echo "Economy Class";
				}
				echo "</label></p>";
			}
		?>
		<h4> Passengers Information </h4>
		<p>Number of Adults: <label><?php echo $_SESSION["bookingselectadultnum"];?></label></p>
		<p>Number of Childs: <label><?php echo $_SESSION["bookingselectchildnum"];?></label></p>
		<p>Number of Infants: <label><?php echo $_SESSION["bookingselectinfantnum"];?></label></p>
		</fieldset>

		<fieldset>
		<h3>Contact Information</h3><hr/>
		<p>Name: <label><?php echo $_SESSION["bookingtravelname"];?></label></p>
		<p>ID Number: <label> <?php echo $_SESSION["bookingtravelid"];?></label></p>
		<p>Contact Number: <label> <?php echo $_SESSION["bookingtravelmobile"];?></label></p>
		<p>Email: <label> <?php echo $_SESSION["bookingtravelemail"];?></label></p>
		</fieldset>
		
		<fieldset>
		<h3>Payment Information</h3><hr/>
		<p>Total fare: $<label><?php echo $_SESSION["bookingselectfare"];?></label></p>
		<p>Card Holder Name: <label><?php echo $_SESSION["bookingpaymentname"];?></label></p>
		<p>Payment Type: <label><?php echo $_SESSION["bookingpaymenttype"];?></label></p>
		<p>Card Number: <label><?php echo $_SESSION["bookingpaymentcardnum"];?></label></p>
		</fieldset>
		
		<br/>
		<input type="submit" value="Yes" />
		<input name="discard" type="button" value="No" onclick="self.location.href='bookingsearch.html'"/>

		
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