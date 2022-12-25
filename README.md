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
