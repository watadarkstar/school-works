<?php ob_start(); session_start(); ?>
<?php
	function writeNewRecord($fid, $ffrom, $fto, $fdate, $ftime, $finfo, $ffirst, $fbusiness, $fpremium, $feconomy){
		$myfile = "db/data.csv";
		$record = $fid.",".$ffrom.",".$fto.",".$fdate.",".$ftime.",".$finfo.",".$ffirst.",".$fbusiness.",".$fpremium.",".$feconomy;
		file_put_contents($myfile, "\n", FILE_APPEND);
		file_put_contents($myfile, $record, FILE_APPEND);
		
		ob_clean();
//		header( 'Location: '.$_SERVER['REQUEST_URI']);
		header( 'Location: '."admin.php");
		return;
	}
	function deleteRecord($record){
		$myfile = 'db/data.csv';
		$lines = file($myfile);
		$filtered = '';
		for($i=0; $i<sizeof($lines); $i++){
			$keywords = explode(',', $lines[$i]);
			if(trim($keywords[0]) == "") goto deleteRecordLabel;
			if($keywords[0] != $record)	$filtered .= $lines[$i];
			deleteRecordLabel:
		}
		file_put_contents($myfile, $filtered);
		
		ob_clean();
//		header( 'Location: '.$_SERVER['REQUEST_URI']);
		header( 'Location: '."admin.php");
		return;
	}
?>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>Flight Schedule Modification</title>
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
    	




	<h3>Flight Schedule Modification</h3><br/>

	 <div id="formwrapper">
		<form id="" method="post" action="" onsubmit="">
        <fieldset>
			<?php
				// read our file
				$myfile = "db/data.csv";
				$fh = fopen($myfile, "rt");
				
				// read and ignore the first line of data record(the header or attributes)
				fgets($fh);
				
				echo "<h3> All Schedule </h3>";
				// print <table> and <thead>
				echo "<table border=\"1\"><thead><tr><th><label>ID</label></th><th><label>Date</label></th><th><label>Departure City</label></th><th><label>Destination City</label></th><th><label>Time</label></th><th><label>Flight Number</label></th><th><label>First-Class</label></th><th><label>Business-Class</label></th><th><label>Premium Economy</label></th><th><label>Economy</label></th></tr></thead><tbody>";
				
				// start reading data
				while(!feof($fh)){
					$instance = fgets($fh);
					$keywords = explode(',', $instance);
					
					// take care of cases of empty line
					if(trim($keywords[0]) == ""){
						goto jump;
					}
					
					// print <tbody>
					$id = $keywords[0];
					$from = $keywords[1];
					$to = $keywords[2];
					$date = $keywords[3];
					$time = $keywords[4];
					$info = $keywords[5];
					$first = $keywords[6];
					$business = $keywords[7];
					$premium = $keywords[8];
					$economy = $keywords[9];
					
					echo "<tr>";
					echo "<td><label>" . $id. "</label></td>";
					echo "<td><label>" . $date . "</label></td>";
					echo "<td><label>" . $from . "</label></td>";
					echo "<td><label>" . $to . "</label></td>";
					echo "<td><label>" . $time . "</label></td>";
					echo "<td><label>" . $info . "</label></td>";
					
					if (trim($first) == "none") echo "<td></td>";
					else echo "<td><label>$" . $first . "</label></td>";
					
					if (trim($business) == "none") echo "<td></td>";
					else echo "<td><label>$" . $business . "</label></td>";
					
					if (trim($premium) == "none") echo "<td></td>";
					else echo "<td><label>$" . $premium . "</label></td>";
					
					if (trim($economy) == "none") echo "<td></td>";
					else echo "<td><label>$" . $economy . "</label></td>";
					
					
					
					echo "</tr>";
					jump:
				}
				
				// print closing tags and close file
				echo "</tbody></table>";
				fclose($fh);
			?>
		</fieldset>
		<fieldset>
			<h3>Add Schedule</h3><label style="color: red; font-size:12px">Make sure you have all forms filled (no error checkings here)</label><br/>
			ID:<input name="sid" type="text"><label style="color: red; font-size:12px;"> MUST be unique!</label><br/>
			Date:<input name="sdate" type="date"><br/>
			Departure City:<select name="sfrom" size=1>
					<option value=""></option>
					<option value="Hong Kong">Hong Kong</option>
					<option value="Beijing">Beijing</option>
					<option value="Tianjin">Tianjin</option>
					<option value="Guangzhou">Guangzhou</option>
					<option value="Hangzhou">Hangzhou</option>
					<option value="Changsha">Changsha</option>
				</select><br/>
			Destination City:<select name="sto" size=1>
					<option value=""></option>
					<option value="Hong Kong">Hong Kong</option>
					<option value="Beijing">Beijing</option>
					<option value="Tianjin">Tianjin</option>
					<option value="Guangzhou">Guangzhou</option>
					<option value="Hangzhou">Hangzhou</option>
					<option value="Changsha">Changsha</option>
				</select><br/>
			Time:<input name="stime" type="text"><br/>
			Flight Number:<input name="sinfo" type="text"><br/>
			First Class Price:<input name="sfirst" type="text"><label style="color: red; font-size:12px"> Type "none" if not available, and no need to include "$" sign</label><br/>
			Business Class Price:<input name="sbusiness" type="text"><label style="color: red; font-size:12px"> Type "none" if not available, and no need to include "$" sign</label><br/>
			Premium Economy Price:<input name="spremium" type="text"><label style="color: red; font-size:12px"> Type "none" if not available, and no need to include "$" sign</label><br/>
			Economy Price:<input name="seconomy" type="text"><label style="color: red; font-size:12px"> Type "none" if not available, and no need to include "$" sign</label><br/>
			<br/><input name="go" type="submit" value="Add New"/><br/>
			<?php 
				if(isset($_POST['go'])){
					$id = $_POST['sid'];
					$from = $_POST['sfrom'];
					$to = $_POST['sto'];
					$date = $_POST['sdate'];
					$parseDate = explode('-', $date);
					$date = $parseDate[1]."/".$parseDate[2]."/".$parseDate[0];
					$time = $_POST['stime'];
					$info = $_POST['sinfo'];
					$first = $_POST['sfirst'];
					$business = $_POST['sbusiness'];
					$premium = $_POST['spremium'];
					$economy = $_POST['seconomy'];
					writeNewRecord($id, $from, $to, $date, $time, $info, $first, $business, $premium, $economy);
				}
			?>
		</fieldset>
		</form>
		<form id="" method="post" action="" onsubmit="">
		<fieldset>
			<h3>Delete Schedule</h3>
			
			<!--ID:<input name="delete" type="date"><br/> -->
			<?php
				// read our file
				$myfile = "db/data.csv";
				$fh = fopen($myfile, "rt");
				
				// read and ignore the first line of data record(the header or attributes)
				fgets($fh);
				
				// print <table> and <thead>
				echo "<table border=\"1\"><thead><tr><th><label>ID</label></th><th><label>Date</label></th><th><label>Departure City</label></th><th><label>Destination City</label></th><th><label>Time</label></th><th><label>Flight Number</label></th><th><label>First-Class</label></th><th><label>Business-Class</label></th><th><label>Premium Economy</label></th><th><label>Economy</label></th><th><kabel>Delete?</label></th></tr></thead><tbody>";
				
				// start reading data
				while(!feof($fh)){
					$instance = fgets($fh);
					$keywords = explode(',', $instance);
					
					// take care of cases of empty line
					if(trim($keywords[0]) == ""){
						goto jump1;
					}
					
					// print <tbody>
					$id = $keywords[0];
					$from = $keywords[1];
					$to = $keywords[2];
					$date = $keywords[3];
					$time = $keywords[4];
					$info = $keywords[5];
					$first = $keywords[6];
					$business = $keywords[7];
					$premium = $keywords[8];
					$economy = $keywords[9];
					
					echo "<tr>";
					echo "<td><label>" . $id. "</label></td>";
					echo "<td><label>" . $date . "</label></td>";
					echo "<td><label>" . $from . "</label></td>";
					echo "<td><label>" . $to . "</label></td>";
					echo "<td><label>" . $time . "</label></td>";
					echo "<td><label>" . $info . "</label></td>";
					
					if (trim($first) == "none") echo "<td></td>";
					else echo "<td><label>$" . $first . "</label></td>";
					
					if (trim($business) == "none") echo "<td></td>";
					else echo "<td><label>$" . $business . "</label></td>";
					
					if (trim($premium) == "none") echo "<td></td>";
					else echo "<td><label>$" . $premium . "</label></td>";
					
					if (trim($economy) == "none") echo "<td></td>";
					else echo "<td><label>$" . $economy . "</label></td>";
					
					echo "<td><input name=\"delete\" type=\"radio\" value=\"".$id."\"></td>";
					
					echo "</tr>";
					jump1:
				}
				
				// print closing tags and close file
				echo "</tbody></table>";
				fclose($fh);
			?>
			<br/><input name="del" type="submit" value="Delete Record"/>
			<?php 
				if(isset($_POST['del'])){
					$id = (isset($_POST['delete']) ? $_POST['delete'] : null);
					deleteRecord($id);
				}
			?>
		</fieldset>
		</form>
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