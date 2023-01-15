# Specifics
#
* Created Security group for backend services
* RDS
    * First created subnet group for RDS
    * Next created parameter groups - can configure database parameters
    * Created DB using Aurora w/MySQL compatibility
    * Attached backend SG created earlier
* ElasticCache
    * Same as RDS, created parameter group and subnet group
    * Then created memcached cluster, attached to backend SG
* Amazon MQ
    * Selected RabbitMQ as broker engine; added to backend SG
* Initialized the RDS DB
    * Created a temporary EC2 instance to ssh into RDS
    * Added userdata to bootstrap installing mysql
    * Created a separate SG with SSH access
        * Updated backend SG with inbound rule for allowing 3306 from newly created SG
    * Logged into RDS instance using endpoint (from RDS) and initialized the db
    * Used .sql file from /src/main/resources/ to input into tables
* Elastic Beanstalk
    * Collected endpoints and port #s for RDS, ElasticCache, and MQ
    * Created new beanstalk
        * Platform - tomcat
        * Instances - selected backend SG
        * ASG + LB (will be in a separate SG)
        * First time will be in terminated state, go back and make again and add newly created service role at the modify security section
* Added inbound rule within backend SG from beanstalk SG and added all internal traffic allowed
* Added HTTPS for LB
* Configured/adjusted application.properties within /src/main/resources with correct endpoints, and ports
* Used maven to install through pom.xml file
* Uploaded the .war file to beanstalk environment under application versions and deployed it
* Enabled CloudFront to cache content globally for faster access

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


