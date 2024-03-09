#!bin/bash

ruser=$(id -u)

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

cp mango.repo /etc/yum.repos.d/mongo.repo &>> $LOGFILE

VALIDATE $? "Copied mongodb repo" 

dnf install mongodb-org -y &>> $LOGFILE

VALIDATE $? "mangodb installation" 

systemctl enable mongod &>> $LOGFILE

VALIDATE $? "enabling mangodb" 

systemctl start mongod &>> $LOGFILE

VALIDATE $? "mangodb started"

sed -i 's/127.0.0.1/0.0.0.0/g' /etc/mongod.conf &>> $LOGFILE

VALIDATE $? "file edited for remote access"

systemctl restart mongod &>> $LOGFILE

VALIDATE $? "mangodb resrted"