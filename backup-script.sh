#!/bin/bash

time=$(date +%m-%d-%y_%H_%M_%S)
Backup_file=/home/ubuntu/bash	
Dest=/home/ubuntu/backup
filename=file-backup-$time.tar.gz
Log_FILE="/home/ubuntu/backup/logfile.log"

S3_Bucket="s3-bashh" 

FILE_TO_UPLOAD="$Dest/$filename"

if ! command -v aws &> /dev/null 
then
	echo "AWS CLI is not installed. install it first. "
        exit 2 
fi	


if [ $? -ne 2 ] 
then 
 if [ -f " $filename" ] 
 then 
	echo " error file $filename is already exists! "  | tee -a "$Log_FILE"
 else
	tar -czvf "$Dest/$filename" "$Backup_file" 
	echo
	echo "Backup completed successfuly. Backup file: $Dest/$filename" | tee -a "$Log_FILE"
        echo
        aws s3 cp "$FILE_TO_UPLOAD" "s3://$S3_Bucket/" 	
       
 fi
fi

if [ $? -eq 0  ]
then
	echo
	echo "File uploaded successfuly to the S3 bucket: $S3_Bucket "
else
	echo "File upload to S3 failed"
fi

	


