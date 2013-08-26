<?php session_start(); ?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>Booking Travellers</title>
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
      <div id="travel">
        
        <div id="status">
          <h1>Online Ticket Booking</h1>
          <div id="statuspicture3"></div>
	    </div>
        <br/>
		
		<?php
//		session_start();
		$_SESSION['bookingselecttype'] = $_POST['bookingselecttype'];
		$_SESSION['bookingselectfrom'] = $_POST['bookingselectfrom'];
		$_SESSION['bookingselectto'] = $_POST['bookingselectto'];
		$_SESSION['bookingselectdeparture'] = $_POST['bookingselectdeparture'];
		$_SESSION['bookingselectreturn'] = $_POST['bookingselectreturn'];
		
		$_SESSION['bookingselectadultnum'] = $_POST['bookingselectadultnum'];
		$_SESSION['bookingselectchildnum'] = $_POST['bookingselectchildnum'];
		$_SESSION['bookingselectinfantnum'] = $_POST['bookingselectinfantnum'];
		
		$_SESSION['bookingselectflight'] = $_POST['bookingselectflight'];
		$_SESSION['bookingselectclass'] = $_POST['bookingselectclass'];
		$_SESSION['bookingselectid'] = $_POST['bookingselectid'];
		
		$_SESSION['bookingselectreturnflight'] = $_POST['bookingselectreturnflight'];
		$_SESSION['bookingselectreturnclass'] = $_POST['bookingselectreturnclass'];
		$_SESSION['bookingselectreturnid'] = $_POST['bookingselectreturnid'];
		
		$_SESSION['bookingselectfare'] = $_POST['bookingselectfare'];
	/*	
		echo $_SESSION["bookingselecttype"]."<br/>";
		echo $_SESSION["bookingselectfrom"]."<br/>";
		echo $_SESSION["bookingselectto"]."<br/>";
		echo $_SESSION["bookingselectdeparture"]."<br/>";
		echo $_SESSION["bookingselectreturn"]."<br/>";
		echo $_SESSION["bookingselectadultnum"]."<br/>";
		echo $_SESSION["bookingselectchildnum"]."<br/>";
		echo $_SESSION["bookingselectinfantnum"]."<br/>";
		echo $_SESSION["bookingselectflight"]."<br/>";
		echo $_SESSION["bookingselectclass"]."<br/>";
		echo $_SESSION["bookingselectid"]."<br/>";
		echo $_SESSION["bookingselectreturnflight"]."<br/>";
		echo $_SESSION["bookingselectreturnclass"]."<br/>";
		echo $_SESSION["bookingselectreturnid"]."<br/>";
		echo $_SESSION["bookingselectfare"]."<br/>";
*/
		?>
        
        
        <div id="formwrapper">
        <fieldset>  
        
        <p><label><?php echo $_POST["bookingselecttype"]; ?></label></p>
        <p><label>Departure	Date: <?php echo $_POST["bookingselectdeparture"]; ?>
		<?php if ($_POST["bookingselecttype"] == "One Way") echo "";
			else echo "<p><label>Return Date: ".$_POST["bookingselectreturn"]."</label></p>"; ?>
        <P><label>Flight: <?php echo $_POST["bookingselectfrom"]; ?> - <?php echo $_POST["bookingselectto"]; ?></label></p><hr/>
        
		<form id="" method="post" action="bookingpurchase.php" onsubmit="return bookingtravel.validateform()">
		
        <h3>Passenger's Contact Details</h3><hr/>
        <label class="labelblock">Name</label><input id="bookingtravelname" type="text" onblur="bookingtravel.checkname()" value=""/><label id="nameerror"></label>
        <label class="labelblock">ID No</label><input id="bookingtravelid" type="text" onblur="bookingtravel.checkid()" value=""/><label id="iderror"></label>
        <label class="labelblock">Mobile No</label><input id="bookingtravelmobile" type="text" onblur="bookingtravel.checkmobile()" value=""/><label id="mobileerror"></label>
        <label class="labelblock">E-mail</label><input id="bookingtravelemail" type="text" onblur="bookingtravel.checkemail()" value=""/><label id="emailerror"></label>
        
        <br/><br/>
		
		
		
		<input type="hidden" id="inputname" name="bookingtravelname" value=""/>
		<input type="hidden" id="inputcontactid" name="bookingtravelid" value=""/>
		<input type="hidden" id="inputmobile" name="bookingtravelmobile" value=""/>
		<input type="hidden" id="inputemail" name="bookingtravelemail" value=""/>
		
        <input type="submit" value="I agree and submit" onclick="bookingtravel.addinfo()"/><label id="bookingtravelerror"></label>
        
        

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