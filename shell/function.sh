#!/bin/bash

backup_name="lesershop24_PROD_"
backup_extension=".sql"


function setLatestBackupName() {

return "$backup_name$(date +%T)$backup_extension";

}

function getLatestBackupName() {

backup_location=$1


ls $backup_location/$backup_name* | sort -n -t _ -k 2 -r|head -1

}

getLatestBackupName "."
