#!/bin/bash



i="0"

while [ $i -lt 4 ]
do
sleep 1
touch "lesershop24_PROD_$(date +%T).sql"
i=$[$i+1]
done


ls file_* | sort -n -t _ -k 2 -r|head -1

