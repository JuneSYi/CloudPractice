# Devops tools testing
## Works
1. Maven
- Dependency management; pulls specific repositories
- Using pom.xml file to configure details for project; use command "mvn clean install" in the same direcotry as the pom file to load
2. couponservices
- Micro service that connects with a mySQL db to POST and GET details related to /couponapi/coupon/{code}
- Uses spring boot for REST api implementation
3. productservices
- Micro service that connects with a mySQL db to POST details related to /productapi/product
- Uses spring boot for REST api implementation
- Integrates couponservices API to update product pricing
- Uses a data transfer object (DTO) for coupon as a @transient; no need to store in db, just use for coupon discount

