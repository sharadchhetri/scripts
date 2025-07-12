#!/bin/bash
# mysql backup script
# Author: Sharad Chhetri
# Website: https://sharadchhetri.com
# 4-Sept-2013
#

MYSQLUSER=root
PASSWORD=123456
s3_bucket_name=YourS3BucketName
### Give MYSQL Server IP address or FQDN, For eg. 127.0.0.1 or localhost
MYSQLHOST=localhost
# In this file, add the list of Database name.
DB_LIST_FILEPATH='~/mysqlbackup/dblist'
BACKUPPATH=/opt/database-backup/$db_name-`date +%F-%H%M%S`

#You can give multiple email id in MAILTO variable by using comma (,) for eg. MAILTO=abc@example.com,xyz@example.com
MAILTO=alert@example.com

for db_name in `cat $DB_LIST_FILEPATH`

do
mysqldump -h$MYSQLHOST -u$MYSQLUSER -p$PASSWORD $db_name > $BACKUPPATH
### compressing the file
gzip $BACKUPPATH
sleep 2

# Upload the backup file in AWS S3 bucket. You must configure either AWS API keys or attach the S3 IAM role to EC2
aws s3 cp $BACKUPPATH.gz  s3://$s3_bucket_name --region us-east-1

FILESIZE=$( du -sh $BACKUPPATH.gz )

if [ ! -f  $BACKUPPATH.gz ]; then
    echo "$BACKUPPATH.gz File not found!, Database Name: $db_name" | mail -s "$db_name backup failed" $MAILTO
else
    echo "$BACKUPPATH.gz File found,Database Name: $db_name, Actual size after compression is $FILESIZE " | mail -s "DBNAME database backup is done" $MAILTO
fi
done

# Find and remove last 30 Days backup file.
find /opt/database-backup/* -mtime +30 -exec rm {} \;
