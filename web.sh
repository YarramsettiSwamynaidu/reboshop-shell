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

dnf install nginx -y &>> $LOGFILE
VALIDATE $? "nginx installed"

systemctl enable nginx &>> $LOGFILE
VALIDATE $? "nginx enabled"

systemctl start nginx &>> $LOGFILE
VALIDATE $? "nginx started"

rm -rf /usr/share/nginx/html/* &>> $LOGFILE
VALIDATE $? "defult file removed"

curl -o /tmp/web.zip https://roboshop-builds.s3.amazonaws.com/web.zip" &>> $LOGFILE

VALIDATE $? "Download the frontend content"

cd /usr/share/nginx/html &>> $LOGFILE
VALIDATE $? "to go html path"

unzip-p /tmp/web.zip &>> $LOGFILE
VALIDATE $? "flie unziped"

cp /home/centos/roboshop /etc/nginx/default.d/roboshop.conf &>> $LOGFILE
VALIDATE $? "file copied"

systemctl restart nginx &>> $LOGFILE
VALIDATE $? "restrted nginx"
