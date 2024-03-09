#!bin/bash

ruser=$(id -u)
MAONGODB_HOST=3.235.90.86

TIMESTAMP=$(date +%F-%H-%M-%S)

LOGFILE="/tmp/$0-$TIMESTAMP.log"


VALIDATE() {

if [ $1 -ne 0 ]
then
    echo -e "$2 is \e[31m failed"
    exit 1
else
    echo -e "$2 is \e[32m sucess"

fi

}

if [ $ruser -ne 0 ]
then
    echo "Plesae run command with root user"
    exit 1
else
    echo "You are root user"
fi

dnf module disable nodejs -y &>> $LOGFILE
VALIDATE $? "disabled nodejs"

dnf module enable nodejs:18 -y &>> $LOGFILE
VALIDATE $? "enagbled nodejs:18V"

dnf install nodejs -y &>> $LOGFILE
VALIDATE $? "installing nodejs"

id roboshop

if [ $? -ne 0]
then
    useradd roboshop &>> $LOGFILE
    VALIDATE $? "roboshop user created"
else
    echo -e "roboshop user e\[33m already existed"
fi

mkdir -p /app &>> $LOGFILE
VALIDATE $? "app directory cretaed" 

curl -o /tmp/catalogue.zip https://roboshop-builds.s3.amazonaws.com/catalogue.zip &>> $LOGFILE
VALIDATE $? "downloding Zip file"

cd /app 

unzip -o /tmp/catalogue.zip &>> $LOGFILE
VALIDATE $? "Unziped file"

npm install &>> $LOGFILE
VALIDATE $? "installing dependies"

cp /home/centos/reboshop-shell/catalogue.service /etc/systemd/system/catalogue.service &>> $LOGFILE
VALIDATE $? "copied catalogue service"

systemctl daemon-reload &>> $LOGFILE
VALIDATE $? "reloded daemon"

systemctl enable catalogue &>> $LOGFILE
VALIDATE $? "enabled catalogue"

systemctl start catalogue &>> $LOGFILE
VALIDATE $? "started catalogue"

cp mango.repo /etc/yum.repos.d/mango.repo &>> $LOGFILE
VALIDATE $? "mongodb repo copied"

dnf install mongodb-org-shell -y
VALIDATE $? "installing mongodb repo clent"

mongo --host $MAONGODB_HOST </app/schema/catalogue.js

VALIDATE $? "Loading data"


