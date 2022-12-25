# Devops tools testing
## Works
### 1. Maven
- Dependency management; pulls specific repositories
- Using pom.xml file to configure details for project; use command "mvn clean install" in the same direcotry as the pom file to load
### 2. couponservices
- Micro service that connects with a mySQL db to POST and GET details related to /couponapi/coupon/{code}
- Uses spring boot for REST api implementation
### 3. productservices
- Micro service that connects with a mySQL db to POST details related to /productapi/product
- Uses spring boot for REST api implementation
- Integrates couponservices API to update product pricing
- Uses a data transfer object (DTO) for coupon as a @transient; no need to store in db, just use for coupon discount
### 4. vagrant-vms
- Experimented with virtualization using virtualbox and vagrant
- Started with manual setup of each virtual machine and transitioned to using vagrant as primary method to configure centos7 and ubuntu18 machines
- Created bootstrap configuration in "VagrantFile" to automate development of WordPress and html templated sites
- Finally, used vagrant to automate creation of multiple vms with bootstrap configurations
### 5. vprofile-project
- Manually provisioned 5 VMs to represent different services that coupled together
	1. Nginx - a web service (similar to httpd) to use as a load balancer and route traffic to the Tomcat server
	2. Apache Tomcat - Java web application service to host the webpage
	3. RabbitMQ - message broker that we connected to Tomcat (not needed but for practice). Normally it's a queueing agent to connect applications together.
	4. Memcached - database cache that routes information to MySQL server
	5. MySQL - primary database to retain user information
- Automated_provisioning - folder containing Vagrantfile that automates creation of all VMs and respective scripts for each of the needed services. Application.properties is the primary file for Tomcat to understand the connective properties between the services. 
	- To deploy, execute "Vagrant Up" in the same directory
