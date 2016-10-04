<?php

require_once('qrcodedecoder/lib/QrReader.php');
echo('start'.PHP_EOL);
$qrcode = new QrReader('mate2.png');
$text = $qrcode->text(); //return decoded text from QR Code
echo($text);
echo('finish'.PHP_EOL);
