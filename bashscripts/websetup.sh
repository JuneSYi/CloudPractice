echo "##############################"
echo "Installing packages"
echo "##############################"
sudo yum install wget unzip httpd -y > /dev/null

sudo systemctl start httpd
sudo systemctl enable httpd

mkdir -p /tmp/webfiles
cd /tmp/webfiles

wget https://www.tooplate.com/zip-templates/2102_constructive.zip > /dev/null
unzip 2102_constructive.zip > /dev/null
sudo cp -r 2102_constructive/* /var/www/html/

sudo systemctl restart httpd

rm -rf /tmp/webfiles


sudo systemctl status httpd
ls /var/www/html/
