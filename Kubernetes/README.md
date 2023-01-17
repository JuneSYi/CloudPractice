# Kubernetes
#

### Config Map & Variables
-

### Volumes
###### EBSVolume.yaml
- Creating an AWS EBS volume
	- Before using, you need to create
	- e.g. aws ec2 create-volume --availability-zone=eu-west-1a --size=10 --volume-type=gp2
- Adding volume configuration (see EBSVolume.yaml)
	- when you create your pod, the volumeMounts: points to where you want to mount the volume in the container.
	- volumes: points to what volume you want to use from the host


### Command and Arguments
- if you have CMD and ENTRYPOINT, cmd comes latter
	- usually entrypoint will be the cmd, and cmd will be the argument
- key point - containers run the command, containers are inside the pod. we give commands and argument at the container level

### Deployment
- Deployment controller provides declarative updates for pods and replica sets; declarative = desired state
- kubectl apply -f <deploymentfile>
- everything on documentation


### Replica Set
###### replicaset.yaml
- re-creates pods if they go down
- copied replicaset.yaml from kubernetes.io documentation
	- kubectl create -f <yamlfile>
	- kubectl get rs
- if changes are made to replica set file you can reapply by:
	- kubectl apply -f <yamlfile>
- adhoc command
	- kubectl scale --replicas=(number) rs/<nameofReplica>
	- kubectl edit rs <nameOfReplica>

### Services
###### lbService.yaml
- key note: service is not a pod or container, it's more similar to rules
- way to expose an application running on a set of pods as a network service; similar to load balancers
- NodePort service - similar to port mapping in docker; backend oriented
	- port numbers start at 30000
- ClusterIP service - internal communication; e.g. tomcat to mysql
- LoadBalancer service - to map port to outside; aws will create an actual LB for this
- created lbService.yaml
	- Here I created a NodePort service that's connected internally on port 8090, with an external frontend port of 30001, and target port pointing to the vproapp pod (created from firstPod.yaml)
	- kubectl create -f nodePortService.yaml
	- kubectl get svc
		- verify creation and other details
	- kubectl describe svc <nameOfService>
		- specific details of service
	- kubectl describe pod <nameOfPod>
		- we can see that the svc and pod are mapped to the same endpoints/IP

### Logging
- kubectl describe pod <podName>
- kubectl logs <podName>
	- shows you the output of the process that the pod is trying to run

### Pods
###### ./firstPod.yaml
- smallest unit in k8s object, represents processes running on your cluster
- most common usage is running a single container per pod
- K8s manages pods rather than containers directly
- definition file in YAML
- created firstPod.yaml
	- for container we used an image we created previously during Docker learning session
	- kubectl create -f <podName.yaml>
	- kubectl describe pod <podName.yaml>
		- gives specific details
	- here we created a node inside one of the clusters running a container with the tomcat image

### Namespaces
- provides a mechanism for isolating groups of resources within a single cluster
- Commands:
	- kubectl get ns
	- kubectl get all
	- kubectl get all --all-namespaces
	- kubectl get svc -n kube-system
	- kubectl create ns kubekart
		- to create a namepsace
	- kubectl run nginx1 --image=nginx -n kubekart
		- run an image on a specific namespace
	- kubectl delete ns <nsName>

### .kube/config file
- file contains information about clusters, users, namespaces, authentication mechanisms
- server - api.<nameserverrecord> will represents the api server in the master node
- context - couples the cluster with the user
- current-context - kubectl will use, by default, current-context (there can be multiple contexts)

### Objects
- Objects
	- Pod - smallest object, container lives inside pods
	- service - e.g. load balancer to your ec2
	- replica set - to make clusters of same pod
	- deployment - similar to replica set, plus you can deploy new image tags; very commonly used
	- config map - to store variables and configuration
	- secret - more storing of information
	- volumes - we can have different kind of volumes attached to pods

### Setup with Kops
- kubekops.jtechdevops.com
- ec2 instance
	- genereated ssh key, installed awscli, inserted iam key and password into cli, installed kubectl, gave it write privileges, installed kops, gave write privileges, moved both kops and kubectl to /usr/local/bin
		- moving to /usr/local/bin makes it accessible anywhere to local user
- iam user
- s3 - going to store the state of kops. we can run our commands from anywhere as long as we store it in our bucket
	- jytech-kops-state
- route53 - added nameserver record from route 53 to domain
	- registers with domain
- to check: nslookup -type=ns kubekops.jtechdevops.com
- Commands:
	- for configuration for cluster and store in s3 bucket
		- kops create cluster --name=kubekops.jtechdevops.com --state=s3://jytech-kops-state --zones=us-east-1a,us-east-1b --node-count=2 --node-size=t3.small --master-size=t3.medium --dns-zone=kubekops.jtechdevops.com --node-volume-size=8 --master-volume-size=8
	- final config portion - key to always add --state and specify s3 bucket
		- kops update cluster --name kubekops.jtechdevops.com --state=s3://jytech-kops-state --yes --admin
	- to validate: kops validate cluster --state=s3://jytech-kops-state
	- to delete: kops delete cluster --name kubekops.jtechdevops.com --state=s3://jytech-kops-state --yes
	- sudo poweroff


### Introduction Notes
- Master Node: 
	- Kube API Server
		- Handles all requests and enables communication across stack services
		- Admins connects to it using Kubectl CLI
	- ETCD Server
		- Stores all the information
	- Kube Scheduler
		- watches pods that have no nodes assigned and selects nodes for them to run on
	- Controller Manager
		- Node Controller - Responsible for noticing and responding when nodes go down
		- Replication Controller - Responible for maintaining the correct # of pods for every replication controller object in the system
		- Endpoints Controller - Populates the Endpoints object
		- Service Account & Token Controller - Create default accounts and API access tokens for new namespace
- Worker Node:
	- Kubelet - An agent that runs on each node in the cluster; makes sure that containers are running in a pod
	- Kube Proxy - network proxy that runs on each node in your cluster
	- Container Runtime (environment) - K8s supports several container runtime; docker, containerd, etc
	- Each Node can/will maintain several to many pods; the pods within the nodes talk to each other using bridge0
- Containers are enclosed in pods
	- Similar to how a VM provides all the resources to the process its running; pods provide all the resources to a container
	- Overlay Network - think of it like a VPC with all the pods as subnets inside the VPC; allows the nodes to talk to each other.
		- uses wg0 to talk to other nodes
- Kubernetes Setup Tools
	- Manual setup
	- Minikube - one node kubernetes cluster for testing/practice
	- Kubeadm - multi node kubernetes cluster
	- Kops - Multi node Kubernetes Cluster on AWS/GCP/etc