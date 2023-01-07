# Ansible
#
### Notes
- Acquired by Red Hat
- Use Cases: 
	- Automation
	- Change Management - production server changes
	- Provisioning
	- Orchestration - large scale automation, integrating with other cloud tools like jenkins
- No agents of any sort required, uses API/WINRM/SSH
- YAML; no databases
- Simple setup, a single python library; no residual software

### Setting up
1. Ansible control instance using Ubuntu and bootstrap instructions from docs; add -y
	$ sudo apt update
	$ sudo apt install software-properties-common -y
	$ sudo add-apt-repository --yes --update ppa:ansible/ansible
	$ sudo apt install ansible -y
2. 2 web servers instances and 1 db server instance-all w/centos 7; port 22 access with inbound access from Ansible Control instance.

### Using Inventory & Ping
###### located ./inventory
1. Within control instance, created a local file called inventory and added data for the web and db instances in the following format:
	- <instanceName> ansible_host=<privateIP> ansible_user=<name> ansible_ssh_private_key_file=<keyName>
2. Separately created another file locally that had the .pem key data used for ssh access to each instance, needs to match <keyName>; made file read-only (chmod 400)
3. ansible -i inventory -m ping web01
	- i to indicate inventory file followed by name
	- m to indicate what module we want to use followed by module name (ping)
	- ping - tries to connect to host, verify a usable python (/usr/bin/python), returns a pong on success through a .json file
		- can use * (need to surround with ') or all
4. Removing host-key checking
	- WHY? Using host-key checking (the response you have to say yes to after you send a ping) adds an interactive step that we don't want if we're looking to automate
	- sudo vim /etc/ansible/ansible.cfg
		- uncomment host_key_checking = False
5. Adding groups
	- using square brackets in inventory file; can categories each instance within a group
	- e.g. [<groupName>]
			web01
			web02
	- to group the groups can use [<newGroupName>:children] - followed by group names in the lines below
6. Defining variables at group level: [<groupName>:vars]
	- can define 'ansible_user=' and 'ansible_ssh_private_key_file=' below
	- group must already be previously defined
	- if variables are defined at host level (top of the line) then group variables won't even be checked

### Ad Hoc commands
- ad-hoc commands that deal with configuration management are idempotent; after the first application, same execution won't apply again
- yum module
	- need to use -a for attributes
	- need to use sudo if the user doesn't have root privileges (--become)
	- e.g. ansible -i <inventoryName> -m yum -a "name=<package you want to install> state=<installed>" <instanceName> --become
- service module
	- controls services (e.g. can start/shutdown)
	- e.g. "... -m service -a "name=<package> enabled=<boolean> state=<started>" ..."
- copy module
	- module that copies the file that you identify

### Playbook
###### ./web_db.yaml
- written in YAML - Ansible playbooks run multiple tasks, assign roles, and define configurations, deployment steps, and variables. If you’re using multiple servers, Ansible playbooks organize the steps between the assembled machines or servers and get them organized and running in the way the users need them to.
- can check syntax with: ansible-playbook -i <inventoryName> <filename> --syntax-check
- to execute: ansible-playbook -i <inventoryName> <filename>
- to conduct dry-run: ansible-playbook -i <inventoryName> <filename> -C

### Modules
###### ./db.yaml
- Details of a package: ansible-doc <package>
- Sometimes you'll find errors in executing a module due to missing dependencies, in these cases you'll need to search in the instance to see if it exists
	- e.g. if a package is needed in an centos OS, you can search using "yum search" and "grep -i <name>" to see if it exists
	- once found, we'll have to add remotely through the playbook

### Ansible Configuration
- priority of settings: 
	1. ANSIBLE_CONFIG (env variable if set)
	2. ansible.cfg (in the current directory) - most commonly used
	3. ~/.ansible.cfg (in the home directory)
	4. /etc/ansible/ansible.cfg (global config file)
- ./ansible.cfg (default file)
	- basic default values are shown in the beginning to show paths/location
	- forks - defines parallel execution of how many machine it will simultaneously execute at a time
	- no default log file but you can uncomment it in config (line 113) to create one
	- privilege_escalation (line 342), escalated privilege for all the playbooks in the selected directory (global/home/current)
	- configuration file in docs.ansible site has details for every setting
- ./ansibleCustom.cfg (name customized to separate from other example, in real-time, the file name will have to be ansible.cfg)
	- log_path = <location of where you want the log file>
		- keep in mind, if you choose a path like /var/log/ansible.log, consider who the user would be executing this .cfg file as
		- e.g. if a normal user on ubuntu is the standard user, then they won't have access to this directory unless they use root
		- you'll have to create the ansible.log first, give the user, who is executing the playbook, ownership, then access the file
			- e.g.  $ sudo touch /var/log/ansible.og
			 		$ sudo chown ubuntu.ubuntu /var/log/ansible.log
			 		$ ansible-playbook <.yaml file> 
			 			- (will be able to execute ansibleCustom.cfg without any errors now)
		- for helping with debug 
			- ansible-playbook <.yaml> -vv
			- more details: -vvv
			- last level: -vvvv
			- choose accordingly based on what you want to know

### Variables, Host Variables, Debug, Groups
###### ./variables.yaml
- Variables:
	- Can define variables using vars:
	- for each variable, they can be used throughout the .yaml file with (using double quotes): "{{varName}}"
- Debug:
	- for debug, the module helps print statements during execution
	- if its a long json format, you can access specific variables you want printed instead of a wall of texts
		- e.g. when you use ansible -m setup <variable>, you get a huge list of information 
			- you can browse through and see that you want to pull ansible_memory_free
			- even that list is pretty detailed and there's a lot of information you may not want
			- to narrow down even more, you can use debug and have the var as ansible_memory_mb.real.free
				- this will give you a one liner of the available free real memory
				- if it's a list, can also use [#] to access specific index in a list
- Host Variables:
- Groups: (./groupsExample/db.yaml)
	- ansible checks for "group_vars/all"
	- need to create the directory and create the file, in the file you add variable names and its values
	- if variables aren't defined within the .yaml file, ansible will check for group_vars/all file to pull definitions
- Precedence of variables: (./vars_precedence.yaml)
	- you can use "register" to store the output of a task into a variable that we define
	- can print the variables using debug; will return a json, can specify what key:value we want to see by using .<key>
	- if you have group variables in the group_vars directory, ansible will take precedence of the groups over specific user variables
	- highest priority goes to host_vars, if that directory exists, ansible will prioritize there first before group_vars
	- priority: playbook --> host_vars --> group_vars/grpname --> group_Vars/all
	- one higher priority is using CLI: e.g. ansible-playbook -e USRNM=cliuser -e COMM=cli vars_precedence.yaml

### Fact Variables
- fact variables are runtime variables that get generated when setup module gets executed; few examples used are OS, # of CPU corse, Kernel version, etc
- you see this every time you run the playbook "TASK [Gathering Facts]"
	- uses a module called "setup"
		- can execute this "setup" module thru adhoc: ansible -m setup <variable>
		- uses OHAI tool to return detailed system information in json format
- can disable if you want: gather_facts: False
	- improves execution time

### Provisioning Servers: Decision Making, Loops
##### NTP service on multi OS, User & Groups, Config files, Decision Making
- ./NTPprovisioning.yaml
	- using when statements to install NTP service on multiple OSs
	- fixed some bug where ntp installation on ubuntu would fail due to .cache.py not being updated. used a update_cache module to fix
- ./loopProvisioning.yaml
	- using loops to install multiple and various packages. Use "{{item}}" for ansible to know what to replace each loop pkg
	- also used loops to create a list of users with a group attached to each user
	- created a file within ./group_vars/ directory called all so ansible will automatically search there when variables are called. Created a list of users within the variable usernames and incorporated it in loopProvisioning.yaml for test purposes

### Loops, templates, handlers, ansible roles
##### ./templateprovisioning.yaml
- Banner file - when you log into the linux OS, it prints the content of the banner file /etc/motd
	- you can use copy module to output a text for users that log in by copying the text into /etc/motd
- Templates - with template module, you can have dynamic files. template module will read the files, see if there's dynamic content, and replace it with actual content and then push it. 
	- To demo this, we created ./templateprovisioning.yaml that pulls from 
	/templates/ directory
		- within /templates/ directory are 2 .conf files converted to an ansible readable .j2 file
		- the 2 .conf files are NTP files we pulled from 2 different web servers (one CentOS and one Ubuntu) where we replaced the server origin with US based servers to have that specific modification (servers were found by just googling ntp servers)
		- these original .conf files were found within their respective instances under 
		/etc/ntp.conf
		- through this modification, ansible will dynamically overwrite these files when we run the playbook
	- in /templates/ntp_debian.conf.j2 from lines 21-24, we can see a demonstration of using jinja2 format to add variables
		- these variables are represented in the 
		group_vars/all file