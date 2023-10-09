# Use an official Tomcat runtime as the base image
FROM tomcat:latest

# Copy your combined WAR file into the Tomcat webapps directory
COPY ./searcher.war /usr/local/tomcat/webapps/

# Copy application.properties into the Docker image
COPY ./application.properties /usr/local/tomcat/webapps/searcher/WEB-INF/classes/

# Expose the Tomcat port (default is 8080)
EXPOSE 8080


# Start Tomcat when the container runs
CMD ["catalina.sh", "run"]
