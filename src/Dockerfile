FROM jenkins/inbound-agent:latest

USER root

RUN apt-get update && apt-get upgrade -y
RUN apt-get install -y gnupg2 lsb-release

# Download the GPG key and save it to /usr/share/keyrings/
RUN curl -fsSL https://download.docker.com/linux/debian/gpg | gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg

# Add the Docker repository to your sources list (replace 'buster' with your actual codename)
RUN echo "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/debian buster stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null

# Update the package index
RUN apt-get update

# Install Docker CLI
RUN apt-get install docker-ce-cli

# RUN usermod -aG docker jenkins

USER jenkins

# Specify the entrypoint script for the Jenkins agent
# ENTRYPOINT ["/usr/local/bin/jenkins-agent"]
# docker build -t dublok/jenkins-agent:dev .
# docker push dublok/jenkins-agent:dev
# single command: docker build -t dublok/jenkins-agent:dev . && docker push dublok/jenkins-agent:dev