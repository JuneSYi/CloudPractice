# Ansible
#
### Notes
- Acquired by Red Hat
- Use Cases: 
	o Automation
	o Change Management - production server changes
	o Provisioning
	o Orchestration - large scale automation, integrating with other cloud tools like jenkins
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
		o can use * (need to surround with ') or all
4. Removing host-key checking
	- WHY? Using host-key checking (the response you have to say yes to after you send a ping) adds an interactive step that we don't want if we're looking to automate
	- sudo vim /etc/ansible/ansible.cfg
		o uncomment host_key_checking = False
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
	o need to use -a for attributes
	o need to use sudo if the user doesn't have root privileges (--become)
	o e.g. ansible -i <inventoryName> -m yum -a "name=<package you want to install> state=<installed>" <instanceName> --become
- service module
	o controls services (e.g. can start/shutdown)
	o e.g. "... -m service -a "name=<package> enabled=<boolean> state=<started>" ..."
- copy module
	o module that copies the file that you identify

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
	o e.g. if a package is needed in an centos OS, you can search using "yum search" and "grep -i <name>" to see if it exists
	o once found, we'll have to add remotely through the playbook

### Ansible Configuration
- priority of settings: 
	1. ANSIBLE_CONFIG (env variable if set)
	2. ansible.cfg (in the current directory) - most commonly used
	3. ~/.ansible.cfg (in the home directory)
	4. /etc/ansible/ansible.cfg (global config file)
- ./ansible.cfg (default file)
	o basic default values are shown in the beginning to show paths/location
	o forks - defines parallel execution of how many machine it will simultaneously execute at a time
	o no default log file but you can uncomment it in config (line 113) to create one
	o privilege_escalation (line 342), escalated privilege for all the playbooks in the selected directory (global/home/current)
	o configuration file in docs.ansible site has details for every setting
- ./ansibleCustom.cfg (customized file)
	o log_path = <location of where you want the log file>
		- keep in mind, if you choose a path like /var/log/ansible.log, consider who the user would be executing this .cfg file as
		- e.g. if a normal user on ubuntu is the standard user, then they won't have access to this directory unless they use root
		- you'll have to create the ansible.log first, give the user, who is executing the playbook, ownership, then access the file