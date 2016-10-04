<?php


$time_start = microtime();

$i=10000000;
//$i=19546420;
$search="a51dea5";
$email_prefix="nischalbachu+";
$email_suffix="@gmail.com";

//$i=0;
while (true){
  $email = $email_prefix.$i.$email_suffix;

  if(($i % 1000000) == 0){
    echo((microtime() - $time_start)." - ".$i.PHP_EOL);
  }

  if(strpos(sha1($email), $search) === 0){
    echo($email." - ".sha1($email).PHP_EOL);
    echo(htmlentities($email));
    break;
  }


  $i++;
}

echo(microtime()-$time_start);

 ?>
