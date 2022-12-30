# Jenkins
#
### Notes
- open source and extensible
	- extensible = limitless plugins: VCS plugins, Build plugins, Cloud plugins, Testing plugins
- pre-req: Java, JRE, JDK, any OS
- Experimented with versioning, plugins, global configuration tools and local config tools
- Automate pipeline setup with Jenkinsfile
	- Jenkinsfile defines Stages in CI/CD pipeline
	- its a text file with its own domain specific language (DSL) - similar to groovy
	- 2 syntax - declarative and scripted


### Continuous Integration Pipeline
1. Dev uses git --> pushes to repo
2. Jenkins detects change and fetches code with a git tool
3. Code will build using tool like Maven
4. Unit Test will be conducted with tool like Maven
5. Code Analysis conducted by tool like SonarQube, checkstyle
	- checks for vulnerabilities/bugs/best practices
	- generates reports in .xml, uploaded to a server
6. Distributes the artifact to be deployed on server and versioned on NexusOSS Sonartype repo

![Jenkins CI pipeline](Jenkins.png)

### Setup
- Created unique instances for Jenkins, SonarQube, Nexus and used shell script from vprofile-project-ci-jenkins/userdata/
- For Jenkins, used the following plugins: 
	- Nexus Artifact Uploader - This plugin to upload the artifact to Nexus Repository.
	- SonarQube Scanner - This plugin allows an easy integration of SonarQube, the open source platform for Continuous Inspection of code quality.
	- Build Trigger Badge - This plugin displays an icon representing the cause of a construction.
	- Build Timestamp - This plugin adds BUILD_TIMESTAMP to Jenkins variables and system properties.
	- Pipeline Maven Integration - This plugin provides integration with Pipeline, configures maven environment to use within a pipeline job by calling sh mvn or bat mvn. The selected maven installation will be configured and prepended to the path.
	- Pipeline Utility Steps - Utility steps for pipeline jobs.

### Using JenkinsFile (Declarative pipeline - Pipeline as a Code)
- Followed standard formatting for Jenkinsfile (located in this directory)
- developed stages with each stage being a specific part of the build
- ran into an error with downloading jdk from oracle so used "sudo apt-get --yes install openjdk-8-jdk"
	- Jenkins requires sudo permissions for this action as the user
		- Used command "visudo -f /etc/sudoers.d/jenkins" to adjust permissions
		- Added this line : jenkins ALL=(ALL) NOPASSWD: ALL
		- We can create a file inside of the /etc/sudoers.d directory instead of modifying the base sudoers file. This keeps the primary sudoers file clean and prevents any conflicts or errors during an upgrade. All files inside of the /etc/sudoers.d directory will be automatically included thanks to this command at the bottom of your sudoers file
- Changed tool home in jdk global config to:
/usr/lib/jvm/java-8-openjdk-amd64
- This took me 6 hours to figure out, made me want to puke

### Code Analysis
- After Fetch Code --> Build --> Unit Test; we now move to Code Analysis
- We use SonarQube
- Using SonarQube plugin from setup, we add installation with a name
- add SonarQube from within configure systems; add sonar URL from ec2 instance hosting SQ
- Generate token from sonarqube, login, go to account, security, generate token, add that to jenkins settings
- Created JenkinsfileWSonarQube
- Quality Gates
	-added quality gate stage with a hour long timeout block; it waits for a quality gate defined on the sonarqube server
	- select quality gates tab on SQ server
	- create, define conditions
	- go to projects, and linke the quality gate you just create
	- once selected, you'll need webhooks to send the information
		- http://<ip>:<port>/sonarqube-webhook/
