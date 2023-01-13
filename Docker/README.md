# Docker
#
### Notes
- Docker manages your Containers
- main strength are its images
- A standard unit of software; package software into standardized units for development, shipment, and deployment






#### Random Notes
- Isolating and hosting infrastructure results in high CapEx and OpEx due to cost of VMs
	- Every VM has OS, OSs need nurturing, licensing, and take time to boot; they can get bulky fast when multiple are required. Some require high amount of resources.
- Imagine multiple services running in the same OS but isolated
- Container
	- A standard unit of software; package software into standardized units for development, shipment, and deployment
	- process running on same OS but still isolated
	- Containers share the machine's OS system kernel
	- contains all the code and dependencies
	- Containers offer isolation, not virtualization; containers are OS virtualization
	- VMs are Hardware virtualization; VM needs OS
	- Containers don't need OS; Containers uses Host OS for compute resources