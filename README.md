# Devops tools testing
## Works
### Tools / Tech / Languages
- Languages: Bash
- Tools: Vim, AWS, Vagrant, Maven, VirtualBox, Apache Tomcat, RabbitMQ, Memcached, MySQL, NGINX, Docker, Git, Jenkins, Ansible, K8s, Terraform
- Others: Ubuntu OS, CentOS, RHEL, 
- All graphics were made with draw.io

## Main Projects:
### vprofileoncloud
1. Used the same design developed in /vprofile-project/ and produced replica with cloud applications
2. Cloud Architecture as follows:

	![Cloud Design](/vprofileoncloud/vprofileoncloud.png)

	- User access website by using a URL from AWS a DNS in Route 53. The URL will be pointing to an endpoint
	- URL will point to an ELB / ALB with a security group will be set to only allow HTTPS traffic
	- ALB will route request to Tomcat instances set on EC2, managed by an auto-scaling group. The instances will be in a security group allowing only trying from the load balancer
	- Tomcat instances will have access to backend services (backend server IP addresses) from the Route 53 private DNS zone
	- RabbitMQ, MySQL, and memcached will be in a separate security group running on EC2 servers

### vprofileRefactor
1. Replaced RabbitMQ, memcached, MySQL, with Amazon MQ, ElasticCache, and Amazon RDS respectively
2. Used Elastic Beanstalk to create entire infrastructure for EC2s, ALB, ASG, S3, and CloudWatching for monitoring
3. Incorporated CloudFront as primary CDN for global access
4. Re-factored design as follows:

	![Re-factored Design](/vprofileRefactor/cloudrefactor.drawio.png)

### Jenkins
- Continuous Integration pipeline
	1. Dev uses git --> pushes to repo
	2. Jenkins detects change and fetches code with a git tool
	3. Code will build using tool like Maven
	4. Unit Test will be conducted with tool like Maven
	5. Code Analysis conducted by tool like SonarQube, checkstyle
		- checks for vulnerabilities/bugs/best practices
		- generates reports in .xml, uploaded to a server
	6. Distributes the artifact to be deployed on server and versioned on NexusOSS Sonartype repo
	7. Publish Docker images and store on Amazon ECR
	8. Use Amazon ECS to host the application/image

![Jenkins CI pipeline](/Jenkins/Jenkins.png)

### Ansible
- Practiced setting up various .yaml files to run ansible-playbook
- learned basic modules to automate tasks/bootstrapping new environments
- Experimented with users and groups, templates for dynamic files, handlers for dependencies,
- Use of roles for complex projects and organization of large projects
- finished with /Ansible/test-aws.yml to automate setting up key-value pair and launching an ec2 instance

### VPC Architecture

![VPC Design](/vpcArchitecture/vpcDesign.png)

- Set up a VPC with 2 public and 2 private subnets
- Created an Internet Gateway for outside traffic to and from the VPC
- Created a route table to direct traffic between the subnets as well as to the Internet Gateway
- Created a NAT gateway for the route tables in the private subnets to route ONLY outbound traffic
- Created an EC2 instance to represent the web server, resides in the private subnets
- Created a Bastion Host that has SSH access to the EC2 web server
- Created a Load Balancer to direct incoming traffice to the EC2 web servers

### Containerizing vprofileoncloud

![Container vprofile](/Docker/ContainerizingProject.png)
- Using DockerHub as source of documentation, I customized Dockerfiles for Tomcat, MySQL, and NGINX
	- For Tomcat - ensured Docker built an image using a prepared .war file to run as our application page at a specified port; included a volume for persistent data
	- For MySQL - customized a docker image with personalized password and added pre-set SQL commands for creating the table
	- For NGINX - simply modified a .conf file to connect with the Tomcat server and listen on port 80
- Memcached and RabbitMQ were used OOTB, straight from docker hub
- Using Docker, I was able to create all 5 images and use docker-compose.yml to setup a multi-container application that launches the application in its entirety with docker-compose up command.

## Not As Interesting, But Fundamentals I Practiced Before Working With The Good Stuff:

### vagrant-vms
- Experimented with virtualization using virtualbox and vagrant
- Started with manual setup of each virtual machine and transitioned to using vagrant as primary method to configure centos7 and ubuntu18 machines
- Created bootstrap configuration in "VagrantFile" to automate development of WordPress and html templated sites
- Finally, used vagrant to automate creation of multiple vms with bootstrap configurations

### vprofile-project
- Manually provisioned 5 VMs to represent different services that coupled together
	1. Nginx - a web service (similar to httpd) to use as a load balancer and route traffic to the Tomcat server
	2. Apache Tomcat - Java web application service to host the webpage
	3. RabbitMQ - message broker that I connected to Tomcat (not needed but for practice). Normally it's a queueing agent to connect applications together.
	4. Memcached - database cache that routes information to MySQL server
	5. MySQL - primary database to retain user information
- Automated_provisioning - folder containing Vagrantfile that automates creation of all VMs and respective scripts for each of the needed services. Application.properties is the primary file for Tomcat to understand the connective properties between the services. 
	- To deploy, execute "Vagrant Up" in the same directory

### containerintro
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

## To Be Finished Later:

### couponservices
- Micro service that connects with a mySQL db to POST and GET details related to /couponapi/coupon/{code}
- Uses spring boot for REST api implementation

### productservices
- Micro service that connects with a mySQL db to POST details related to /productapi/product
- Uses spring boot for REST api implementation
- Integrates couponservices API to update product pricing
- Uses a data transfer object (DTO) for coupon as a @transient; no need to store in db, just use for coupon discount