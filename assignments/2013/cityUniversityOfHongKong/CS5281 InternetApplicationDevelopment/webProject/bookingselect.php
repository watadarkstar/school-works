<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>Booking Selection</title>
<link href="style.css" rel="stylesheet" type="text/css" />
<link rel="stylesheet" href="css/bookingStyle.css" type="text/css" />
<script type="text/javascript" src="http://code.jquery.com/jquery-1.8.0.min.js"></script>
<script type="text/javascript" src="js/bookingScript.js"></script>
<script type="text/javascript" src="js/bookingAjax.js"></script>
</head>

<body onload="process(); process1()"">
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

	<?php 
	if($_POST["bookingsearchtype"]!="oneway") $_POST["bookingsearchdeparture"] = $_POST["bookingsearchrounddeparture"];
	?>
	<div id="body2">
	<div id="booking" >
      <div id="select">
      	
        <div id="status">
          <h1>Online Ticket Booking</h1>
          <div id="statuspicture2"></div>
	    </div>
        <br/>
      
      	<div id="formwrapper">
        <fieldset>
        
        <!-- OUR INFO -->
        <b><p><label id="type"><?php if($_POST["bookingsearchtype"]=="oneway") echo "One Way";else if($_POST["bookingsearchtype"]=="roundtrip") echo "Round Trip";?></label></p></b>
        <p>Departure Date: 
			<label id="departure"><?php echo $_POST["bookingsearchdeparture"];?></label></p>
		<p><?php if($_POST["bookingsearchtype"]=="oneway") echo ""; else echo "Return Date: " ;?>
			<label id="returnd">
				<?php if($_POST["bookingsearchtype"]=="oneway") echo "";
					else echo $_POST["bookingsearchreturn"];?></label></p>
			
        <P>Flight: 
			<label id="from"><?php if($_POST["bookingsearchtype"]=="oneway") echo $_POST["bookingsearchfrom"]; else echo $_POST["bookingsearchroundfrom"]; ?></label> - <label id="to"><?php if($_POST["bookingsearchtype"]=="oneway") echo $_POST["bookingsearchto"]; else echo $_POST["bookingsearchroundto"]; ?></label></p>
        

        <form id="" method="post" action="bookingtravel.php" onsubmit="return bookingselect.validateform()" >
         
        <!-- OUR TABLE -->       	
            <?php
				// code here
				
			?>
			<br/>
			<label id="ajaxForm"></label>
            <label id="departureerror"></label>
			
			<br/>
			<label id="ajaxReturnForm"></label>
            <label id="returnerror"></label>

            <br/>
            
            <p>
            <label>Fare for</label> <label id="adultnumber"><?php echo $_POST["bookingsearchadult"]; ?></label> <label>Adult: </label> <label id="adultfare">0</label>     <?php if ($_POST["bookingsearchtype"]=="roundtrip") echo "<label>+ </label><label id=\"adultreturnfare\">0</label>";?><br/> 
            <label>Fare for</label>	<label id="childnumber"><?php echo $_POST["bookingsearchchild"]; ?></label> <label>Child: </label> <label id="childfare">0</label>     <?php if ($_POST["bookingsearchtype"]=="roundtrip") echo "<label>+ </label><label id=\"childreturnfare\">0</label>";?><br/>
            <label>Fare for</label>	<label id="infantnumber"><?php echo $_POST["bookingsearchinfant"]; ?></label> <label>Infant: </label> <label id="infantfare">0</label> <?php if ($_POST["bookingsearchtype"]=="roundtrip") echo "<label>+ </label><label id=\"infantreturnfare\">0</label>";?><br/>
            <hr/>
			<label>Total Departure fare is $</label><label id="departurefare">0</label><br/>
			<label>Total Return fare is $</label><label id="returnfare">0</label><br/>
            <label>Total fare is $</label><label id="totalfare">0</label><br/>
            </p>
            
   
			<input type="hidden" id="inputtype" name="bookingselecttype" value=""/>
			<input type="hidden" id="inputfrom" name="bookingselectfrom" value=""/>
			<input type="hidden" id="inputto" name="bookingselectto" value=""/>
			<input type="hidden" id="inputdeparture" name="bookingselectdeparture" value="<?php echo $_POST["bookingsearchdeparture"];?>"/>
			<input type="hidden" id="inputreturn" name="bookingselectreturn" value="<?php echo $_POST["bookingsearchreturn"];?>"/>
			<input type="hidden" id="inputadultnum" name="bookingselectadultnum" value=""/>
			<input type="hidden" id="inputchildnum" name="bookingselectchildnum" value=""/>
			<input type="hidden" id="inputinfantnum" name="bookingselectinfantnum" value=""/>
			<input type="hidden" id="inputflight" name="bookingselectflight" value=""/>
			<input type="hidden" id="inputclass" name="bookingselectclass" value=""/>
			<input type="hidden" id="inputid" name="bookingselectid" value=""/>
			<input type="hidden" id="inputreturnflight" name="bookingselectreturnflight" value=""/>
			<input type="hidden" id="inputreturnclass" name="bookingselectreturnclass" value=""/>
			<input type="hidden" id="inputreturnid" name="bookingselectreturnid" value=""/>
			<input type="hidden" id="inputradio" name="bookingselectradio" value=""/>
			<input type="hidden" id="inputreturnradio" name="bookingselectreturnradio" value=""/>
			<input type="hidden" id="inputfare" name="bookingselectfare" value=""/>
			
		
  
            <input name="bookselectsubmit" type="submit" value="Book Now" onclick="bookingselect.addinfo()"/>
                
        
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