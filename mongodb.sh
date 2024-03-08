#!bin/bash

ruser=$(id -u)


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

cp mango.repo /etc/yum.repos.d/mongo.repo

VALIDATE $? "Copied mongodb repo"

dnf install mongodb-org -y 

VALIDATE $? "mangodb installation"

systemctl enable mongod

VALIDATE $? "enabling mangodb" 

systemctl start mongod

VALIDATE $? "mangodb started"