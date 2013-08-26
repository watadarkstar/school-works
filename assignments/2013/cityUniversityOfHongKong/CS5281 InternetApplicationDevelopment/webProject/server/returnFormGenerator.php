<?php
	if ($_POST["bookingsearchtype"]=="Round Trip"){
		// read our file
		$myfile = "../db/data.csv";
		$fh = fopen($myfile, "rt");
		
		// read and ignore the first line of data record(the header or attributes)
		fgets($fh);
		
		echo "<h3>Return Information</h3>";
		// print <table> and <thead>
		echo "<table border=\"1\"><thead><tr><th><label>From/to</label></th><th><label>Info</label></th><th><label>First-Class</label></th><th><label>Business-Class</label></th><th><label>Premium Economy</label></th><th><label>Economy</label></th></tr></thead><tbody>";
		
		// start reading data
		while(!feof($fh)){
			$instance = fgets($fh);
			$keywords = explode(',', $instance);
			
			// take care of cases of empty line
			if(trim($keywords[0]) == ""){
				goto jump2;
			}
			
			// print <tbody>
			$id = trim($keywords[0]);
			$from = trim($keywords[1]);
			$to = trim($keywords[2]);
			$date = trim($keywords[3]);
			$time = trim($keywords[4]);
			$info = trim($keywords[5]);
			$first = trim($keywords[6]);
			$business = trim($keywords[7]);
			$premium = trim($keywords[8]);
			$economy = trim($keywords[9]);
			
			// recheck the radio button that user has checked in previous form
			if($_POST["bookingselectreturnradio"] != ""){
				$parseRadio = explode('-', $_POST["bookingselectreturnradio"]);
				$rid = $parseRadio[0];
				$rid = trim($rid);
				$rclass = $parseRadio[1];
				$rclass = trim($rclass);

				//$rid = trim(explode('-',$_POST["bookingselectreturnradio"])[0]);
				//$rclass = trim(explode('-',$_POST["bookingselectreturnradio"])[1]);
			}
			
			$parseDate = explode('-', $_POST["bookingreturndate"]);
			$returnDate = trim($parseDate[1]) ."/". trim($parseDate[2]) ."/". trim($parseDate[0]);
			//echo $date."-".$returnDate."\n";
			//echo $_POST["bookingreturndate"];
			
			// skip if city does not match
			if(($from == $_POST["bookingsearchto"]) && ($to == $_POST["bookingsearchfrom"]) && ($date == $returnDate)){
			
			
			echo "<tr>";		
			echo "<td><label>" . $time . "</label></td>";
			echo "<td><label>" . $info . "</label></td>";
			
			if ($first == "none") echo "<td></td>";
			else if($_POST["bookingselectreturnradio"]!= "" && $rid == $id && $rclass=="returnfirst") echo "<td><input type=\"radio\" id=\"".$id."-returnfirst\" name=\"bookingselectreturntype\" value=\"".$first.",".$info.",first,".$id."\" onclick=\"bookingselect.rewritereturn(this.id); bookingselect.checkreturn();\" checked=\"checked\"/><label>$" . $first . "</label></td>";
			else echo "<td><input type=\"radio\" id=\"".$id."-returnfirst\" name=\"bookingselectreturntype\" value=\"".$first.",".$info.",first,".$id."\" onclick=\"bookingselect.rewritereturn(this.id); bookingselect.checkreturn();\"/><label>$" . $first . "</label></td>";
			
			if ($business == "none") echo "<td></td>";
			else if($_POST["bookingselectreturnradio"]!= "" && $rid == $id && $rclass=="returnbusiness") echo "<td><input type=\"radio\" id=\"".$id."-returnbusiness\" name=\"bookingselectreturntype\" value=\"".$business.",".$info.",business,".$id."\" onclick=\"bookingselect.rewritereturn(this.id); bookingselect.checkreturn()\" checked=\"checked\"/><label>$" . $business . "</label></td>";
			else echo "<td><input type=\"radio\" id=\"".$id."-returnbusiness\" name=\"bookingselectreturntype\" value=\"".$business.",".$info.",business,".$id."\" onclick=\"bookingselect.rewritereturn(this.id); bookingselect.checkreturn()\"/><label>$" . $business . "</label></td>";
			
			if ($premium == "none") echo "<td></td>";
			else if($_POST["bookingselectreturnradio"]!= "" && $rid == $id && $rclass=="returnpremium") echo "<td><input type=\"radio\" id=\"".$id."-returnpremium\" name=\"bookingselectreturntype\" value=\"".$premium.",".$info.",premium,".$id."\" onclick=\"bookingselect.rewritereturn(this.id); bookingselect.checkreturn()\" checked=\"checked\"/><label>$" . $premium . "</label></td>";
			else echo "<td><input type=\"radio\" id=\"".$id."-returnpremium\" name=\"bookingselectreturntype\" value=\"".$premium.",".$info.",premium,".$id."\" onclick=\"bookingselect.rewritereturn(this.id); bookingselect.checkreturn()\"/><label>$" . $premium . "</label></td>";
			
			if ($economy == "none") echo "<td></td>";
			else if($_POST["bookingselectreturnradio"]!= "" && $rid == $id && $rclass=="returneconomy") echo "<td><input type=\"radio\" id=\"".$id."-returneconomy\" name=\"bookingselectreturntype\" value=\"".$economy.",".$info.",economy,".$id."\" onclick=\"bookingselect.rewritereturn(this.id); bookingselect.checkreturn()\" checked=\"checked\"/><label>$" . $economy . "</label></td>";
			else echo "<td><input type=\"radio\" id=\"".$id."-returneconomy\" name=\"bookingselectreturntype\" value=\"".$economy.",".$info.",economy,".$id."\" onclick=\"bookingselect.rewritereturn(this.id); bookingselect.checkreturn()\"/><label>$" . $economy . "</label></td>";
			
			echo "</tr>";
			}
			
			jump2:
		}
		
		// print closing tags and close file
		echo "</tbody></table>";
		fclose($fh);
	}
	
?>
