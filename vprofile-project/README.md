# vprofile-project
#
- Manually provisioned 5 VMs to represent different services that coupled together
	1. Nginx - a web service (similar to httpd) to use as a load balancer and route traffic to the Tomcat server
	2. Apache Tomcat - Java web application service to host the webpage
	3. RabbitMQ - message broker that we connected to Tomcat (not needed but for practice). Normally it's a queueing agent to connect applications together.
	4. Memcached - database cache that routes information to MySQL server
	5. MySQL - primary database to retain user information
- Automated_provisioning - folder containing Vagrantfile that automates creation of all VMs and respective scripts for each of the needed services. Application.properties is the primary file for Tomcat to understand the connective properties between the services. 
	- To deploy, execute "Vagrant Up" in the same directory
