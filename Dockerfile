FROM java:8
WORKDIR /
ADD target/spring-boot-rest-example-0.5.0.war .
EXPOSE 9000
CMD java -jar -Dspring.profiles.active=test spring-boot-rest-example-0.5.0.war
