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
### 6. containerintro
	1. Used Vagrant to bootstrap a vm with docker
		1. Practiced basic commands related to docker:
			- systemctl status docker
			- docker run, docker images, docker ps, docker ps -a, docker inspect <name>
		2. Created an image directory to run pre-built images; file named Dockerfile
		3. docker build -t <anynameforimage> . (. is location of file which is current loc)
		4. docker images - check all images
		5. docker run -d -P <imagename> (d runs it in background, P make it take host port)
	2. Removed all docker files and images and reloaded Vagrant file to use docker-compose; docker-compose allows you to use a YAML file to define multiple containers
		1. Created sub-directory for .yaml file(s)
		2. used wget to pull pre-built image from docker hub
		3. docker-compose up -d; builds and runs the image
		4. docker ps to check; used ip addr show to find ip and tested adding on the correct port
### 7. vprofileoncloud
	1. Used the same design developed with Vagrant and produced replica with cloud applications
	2. Incorporated best security practices through utilization of security groups and private DNS zones
	3. Cloud Architecture as follows:

	!(./vprofileoncloud/vprofileoncloud.png)

	- User access website by using a URL from AWS a DNS in Route 53. The URL will be pointing to an endpoint
	- URL will point to an ELB / ALB with a security group will be set to only allow HTTPS traffic
	- ALB will route request to Tomcat instances set on EC2, managed by an auto-scaling group. The instances will be in a security group allowing only trying from the load balancer
	- Tomcat instances will have access to backend services (backend server IP addresses) from the Route 53 private DNS zone
	- RabbitMQ, MySQL, and NGINX will be in a separate security group running on EC2 servers




