# VPC Fundamentals
#
VPC Addressing (CIDR)
	• private address space, so without an internet gateway, no traffic to the world.
	• one AWS account can span multiple regions
		○ with multiple vpcs in each region
			§ common to have multiple vpcs to separate users from other departments and control traffic
	• AWS Services that require a VPC
		○ EC2, RDS, Redshift, ELB for example
		○ Services that can exist at the region level (outside of vpc)
			§ S3, DynamoDB, Lambda, API Gateway, SQS, SNS
	• CIDR
		○ two components
			§ base IP (xx.xx.xx.xx)
			§ subnet mask or prefix (/26)
		○ base IP represents an IP contained in teh range
		○ subnet masks defines how many bits can change in the IP
		○ e.g. 10.10.0.0/16
			§ 32-16 = 16 
				□ 2^16 = 65,536 IPs available
			§ /32 = 2^0
			§ /31 = 2^1
			§ /24 = 256
			§ /16 = 65k
	• when you create a vpc, you'll need to create subnets to go with it
		○ if you give a vpc 10.10.0.0/16
			§ you can give a subnet 10.10.0.0/24
				□ for 256 addresses
			§ and another 10.10.0.1/24
			§ and so forth
	• private IP addresses
		○ 10.0.0.0 - 10.255.255.255
		○ 172.16.0.0 - 172.31.255.255
192.168.0.0 - 192.168.255.255
