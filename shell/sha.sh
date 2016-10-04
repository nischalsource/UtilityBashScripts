#!/bin/bash

clear
#sha=$(echo -n example+19546430@example.com | openssl sha1);
#echo $sha



i=10000000; 
#i=19546420;
search=a51dea5;
#email_prefix=example+;
#email_suffix=@example.com;

email_prefix=nischalbachu+;
email_suffix=#@gmail.com


while [ true ]; 

string=$email_prefix$i$email_suffix

 do 
   echo -n $string| sha1sum | grep -q "^$search"  && echo $string $(echo -n $string | sha1sum)  && exit;
 ((i++));
done


exit;
