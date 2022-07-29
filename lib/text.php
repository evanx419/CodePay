<?php 
  $db = "guavacod_codepay"; //database name
  $dbuser = "guavacod_codepay"; //database username
  $dbpassword = "Vv3l34f7#SYI@f"; //database password
  $dbhost = "localhost"; //database host

  $return["error"] = false;
  $return["message"] = "";

  $link = mysqli_connect($dbhost, $dbuser, $dbpassword, $db);
  //connecting to database server
//   if($link){
//       echo("true");
//   }


// INSERT INTO `users`(`id`, `email`, `wallet_id`, `imgUrl`, `pwd`) VALUES ([value-1],[value-2],[value-3],[value-4],[value-5])

  $val = isset($_POST["name"]) && isset($_POST["description"])
         && isset($_POST["amount"]) && isset($_POST["payout currency"]) && isset($_POST["method"]) 
         && isset($_POST["country"]) && isset($_POST["senderCurrency"]) && isset($_POST["date"])
         && isset($_POST["img"]) && isset($_POST["wallet"]) && isset($_POST["mydata"]) && isset($_POST["status"]);

  if($val){
       //checking if there is POST data

       $name = isset($_POST["name"]); 
       $description = isset($_POST["description"]);
       $amount = isset($_POST["amount"]) ;
       $payoutcurrency = isset($_POST["payout currency"]) ;
       $method = isset($_POST["method"]) ;
       $country = isset($_POST["country"]) ;
       $scurrency = isset($_POST["senderCurrency"]);
       $date = isset($_POST["date"]);
       $img = isset($_POST["img"]) ;
       $wallet = isset($_POST["wallet"]) ;
       $mydata = isset($_POST["mydata"]);
       $status = isset($_POST["status"]); //add more validations here

       //if there is no any error then ready for database write
       if($return["error"] == false){
            $name  = mysqli_real_escape_string($link,  $name);
            $description = mysqli_real_escape_string($link, $description);
            $amount = mysqli_real_escape_string($link, $amount);
            $payoutcurrency = mysqli_real_escape_string($link, $payoutcurrency);
            $method = mysqli_real_escape_string($link, $method);
            $country = mysqli_real_escape_string($link, $country);
            $scurrency = mysqli_real_escape_string($link, $scurrency);
           $date = mysqli_real_escape_string($link, $date);
           $img = mysqli_real_escape_string($link, $img);
            $wallet = mysqli_real_escape_string($link, $wallet);
            $mydata = mysqli_real_escape_string($link, $mydata);
           $status = mysqli_real_escape_string($link, $status);
           
            //escape inverted comma query conflict from string

            
            // echo("here");
            $sql = "INSERT INTO `business`(`id`, `name`, `description`, `amount`, `payout currency`, `method`, `country`, 
            `senderCurrency`, `date`, `img`, `wallet`, `mydata`, `status`) VALUES (null,'$name','$description','$amount',
            '$payoutcurrency','$method','$country', '$scurrency','$date','$img', '$wallet', '$mydata', '$status')";



            $res = mysqli_query($link, $sql);
            if($res){
                $return["error"] = false;
      $return["message"] = 'Successful.';
            }else{
                $return["error"] = true;
                $return["message"] = "Database error";
            }
       }
  }else{
      $return["error"] = true;
      $return["message"] = 'Send all parameters.';
  }

  mysqli_close($link); //close mysqli

  header('Content-Type: application/json');
  // tell browser that its a json data
  echo json_encode($return);
  //converting array to JSON string
?>
