# Kubernetes
#

### App Deployment on Kubernetes Cluster
- What I used:
    - Kops
    - containerized apps (vprofile)
    - Create EBS volume for DB Pod
    - Label Node with zones names
    - Write the Kubernetes Defintion files for
        - Deployment, Service, Secret, Volume
- Process:
  1. Setup instructions from 'Setup with Kops' below
  2. kops create cluster --name=kubekops.jtechdevops.com --state=s3://jytech-kops-state --zones=us-east-1a,us-east-1b --node-count=2 --node-size=t3.small --master-size=t3.medium --dns-zone=kubekops.jtechdevops.com
  3. kops update cluster --name kubekops.jtechdevops.com --state=s3://jytech-kops-state --yes --admin
  4. kops validate cluster --state=s3://jytech-kops-state
  5. Creating an EBS volume
     1. aws ec2 create-volume --availability-zone=us-east-1a --size=3 --volume-type=gp2
     2. saved output of volumeId
     3. To ensure when we run our db pod, it's in the same availability zone. We can do that through nodeSelector option in our definition file.
     4. Creating our own label but if we wanted to see our own - kubectl get nodes --show-labels
     5. Getting the node names - kubectl get nodes
     6. checking which region one of the nodes are in - kubectl describe <enterNodeName> | grep us-east
     7. kubectl label nodes <sameNodeName> zone=<sameRegion>
     8. label the other node with the other region
  - Stopping here; continuing learning with CKAD training

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
 
### Taints, Tolerations, Jobs, DaemonSet
- Taints - allow a node to repel a set of pods
- Tolerations - applied to pods and allow (but do not require) the pods to schedule onto nodes with matching tains
- Taints and tolerations work together to ensure that pods are not scheduled onto inappropriate nodes. One or more taints are applied to a node; this marks that the node should not accept any pods that do not tolerate the taints
- e.g. kubectl tain nodes node1 key1=value1:NoSchedule
	-places a tain on node node1. The taint has key key1, value value1, and taint effect, NoSchedule. This means that no pod will be able to schedule onto node1 unless it has matching toleration
- you specify a toleration for a pod in the PodSpec
- Jobs - creates one or more pods and will continue to retry execution of the pods until a specified number of them successfuly complete/end. Jobs track the successful completions and when a specified number is reached, the job is complete.
	- could be a script/batch process
	- similar to pods but pods run continuously where jobs will end at some point
- CronJob - similar to Job, can use to schedule periodic jobs
- DaemonSet - ensures that all Nodes run a copy of a Pod. As nodes are added to the cluster, pods are added to them.

### Kubectl CLI
- kubectl run <name> --image=<containerimage> --dry-run=client -o yaml > <name.yaml>
	- produces a .yaml file with a template for running a specified container
- kubectl create deployment --image=nginx nginx --dry-run=client -o yaml > <filename.yaml>
	- this will create a deployment template in a .yaml file.
- ultimately, you can always just go to the documentation to pull a template but this is a neat shortcut
note: '-o' is output

### Ingress
###### ./PracticeYaml/Ingress.yaml
- An API object that manages external access to the services in a cluster, typically HTTP
- Ingress exposes 80/443 routes from outside the cluster to services within the cluster (think load balancer)
- Ingress Controller is required; NGINX is common but there are many
- you apply Ingress with rules: under spec:
	- identify the host, the path, where you want the service to be routed to

### Secrets
Opaque Secret
	- echo -n "secretpass" | base64
		- shows the encoded value of the password "secretpass" and encodes it in base64
	- echo 'type output of encoded password' | base64 --decode
		- decodes it
	- for declarative, first encode using base64
		use the value in .yaml file
	- place secret key in environment variable in config map
- many different types of secrets in kubernetes documentation page
- storing docker images in private repo
	- kubectl create secret docker-registry <name> --docker-email=xxx --docker-...
	- can decode using base64
- imagePullSecrets:
	- Can use when outlining the spec: during your pod .yaml file
	- pulls from private repo

### Config Map & Variables
###### ./config-map/samplecm.yaml
###### ./config-map/configure-pod.yaml
- you can store environment variables by categorizing them within the containers section as env:
	- e.g. store $MYSQL variables for account name and p/w
- config maps - to store your variables all in one place and inject when you need them into files
	- declaratively, you just use kind: ConfigMap and then add the metadata and the data
	- to inject into a pod, you use envFrom: within the container level
		then add configMapRef: or configMapRef: and then name: + key:
- samplecm.yaml (sample config map)
	- metadata shows the name of the config map
	- has 4 key-values with values tied to assigned variables
	- for the file-like keys, they can be stored in a container
- once made, you can apply by "kubectl apply -f <ConfigMap.yaml>"
	- then "kubectl get cm" to see all config maps
	- or "kubectl get cm <ConfigMapName.yaml> -o yaml" to see a specific file
- configure-pod.yaml (application of config map)
	- we can see how we apply config maps by prompting with env:
	- valuFrom: -> configMapKeyRef: we store the value of key: player_intial_lives from configMapKeyRef name: game-demo into the environment variable PLAYER_INITIAL_LIVES
	- same with UI_PROPERTIES_FILE_NAME
	- volumeMounts:
		- config map can be mounted to volumes; here it'll be mounted at /config directory
		- in the volumes section, you see the same name connecting to the volume mount
		- ConfigMap is used for this volume and keys are labeled
			- the path: is same but doesn't have to be, it'll be the name used in the volume.

### Volumes
###### ./PracticeYaml/EBSVolume.yaml
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
###### ./PracticeYaml/replicaset.yaml
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
###### ./PracticeYaml/lbService.yaml
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
###### ./PracticeYaml/firstPod.yaml
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