#!/bin/bash

#Variable declaration
PACKAGE="httpd wget unzip"
SVC="httpd"
URL="https://www.tooplate.com/zip-templates/2102_constructive.zip"
ART_NAME="2102_constructive"
TEMPDIR="/tmp/webfiles"


# Installing Dependencies
echo "##############################"
echo "Installing packages"
echo "##############################"
sudo yum install $PACKAGE  -y > /dev/null

sudo systemctl start $SVC
sudo systemctl enable $SVC

mkdir -p $TEMPDIR
cd $TEMPDIR

wget $URL  > /dev/null
unzip 2102_constructive.zip > /dev/null
sudo cp -r $ART_NAME/* /var/www/html/

sudo systemctl restart $SVC

rm -rf $TEMPDIR


sudo systemctl status $SVC
ls /var/www/html/
