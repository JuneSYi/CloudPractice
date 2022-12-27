# Prerequisites
#
- JDK 1.8 or later
- Maven 3 or later
- MySQL 5.6 or later

# Technologies 
- Spring MVC
- Spring Security
- Spring Data JPA
- Maven
- JSP
- MySQL
# Database
Here,we used Mysql DB 
MSQL DB Installation Steps for Linux ubuntu 14.04:
- $ sudo apt-get update
- $ sudo apt-get install mysql-server

Then look for the file :
- /src/main/resources/accountsdb
- accountsdb.sql file is a mysql dump file.we have to import this dump to mysql db server
- > mysql -u <user_name> -p accounts < accountsdb.sql


Specifics
1. Created ELB SG with inbound traffic from only HTTPS
2. Created application SG with inbound traffic from only the ELB SG port
3. Created backend SG with inbound traffic for specific applications (MySQL, custom ports determined during bootstrap script for RabbitMQ/memcached)
4. Used /userdata/mysql.sh, memcache.sh, and rabbitmq01 for ec2 instance as part of user data (bootstrap) - centos 07
5. Created a private hosted zone
    1. Created record type that routes traffic to an IPv4 address for each of the ec2 instances, using their private IPv4 addresses
        1. They will be used by the Tomcat EC2 instance
6. Used /userdata/tomcat_ubuntu.sh for application instance - ubuntu 18
7. Configured applications.properties file within /src/main/resources/ to ensure spring application is configured correctly to the new record names increased in route 53
8. Ran “mvn install” in base directory where pom.xml is located
9. Used aws-cli to create an s3 bucket; copied .war file from /target/
    1. aws s3 mb s3://<uniquebucketname>
    2. aws s3 cp <.war file> s3://<bucket name>/<.war file>
10. Created an IAM role for EC2 instances with S3fullAccess, attached the role to application instance for full access to S3 bucket
11. Entered our tomcat8 directory within /var/lib/ and removed default ROOT folder within ./tomcat8/webapps/
12. Downloaded aws-cli in order to download the .war file from s3 bucket; moved the file to /var/lib/tomcat8/webapps/ as ROOT.war file
    1. Restarted tomcat8
    2. Validated connection to all instances using telnet <name e.g. db01.vprofile.in> <port# e.g. 3306 for db>
        1. Common errors: 
            1. make sure to use private IPs for all records, 
            2. make sure security groups outbound/inbound are correct
            3. make sure all systems are actually active status, may need to restart (systemctl <command> <service>)
            4. Verify correct port numbers are listed in application.properties file under /target/ folder
13.  Create load balancer starting with target group first
    1. Target type instances, remember to use the correct port (for our example, we choose 8080 because app inbound rule is 8080)
    2. Ensure port override is correct #
14. For LB we chose ALB, choose > 1 zones for HA
    1. Ensure to choose correct SG that we created earlier
    2. 443 listener forwarded to correct target group we made earlier
    3. Connected with certificate
15. Logged on to domain hosting site, added the new endpoint from the LB as name record
16. Test: https://<hostvaluefromstep#15>.domainname.com
17. For auto-scaling, created image out of app ec2 instance
18. Created a launch configuration (soon to be migrated to launch template)
