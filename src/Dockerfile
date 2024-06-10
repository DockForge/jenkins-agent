FROM jenkins/inbound-agent:latest

USER root

RUN apt-get update && apt-get upgrade -y
RUN apt-get install -y gnupg2 lsb-release sudo

# Download the GPG key and save it to /usr/share/keyrings/
RUN curl -fsSL https://download.docker.com/linux/debian/gpg | gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg

# Add the Docker repository to your sources list (replace 'buster' with your actual codename)
RUN echo "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/debian buster stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null

# Update the package index
RUN apt-get update

# Install Docker CLI
RUN apt-get install -y docker-ce-cli

# Add Docker group and add Jenkins user to it
RUN groupadd -g 993 docker || true
RUN usermod -aG docker jenkins

# Grant Jenkins user sudo privileges without a password
RUN usermod -aG sudo jenkins
RUN echo "jenkins ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

# Create an entrypoint script to set permissions on the Docker socket
COPY entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

USER jenkins

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]

# Specify the entrypoint script for the Jenkins agent
# ENTRYPOINT ["/usr/local/bin/jenkins-agent"]
# docker build -t dublok/jenkins-agent:dev .
# docker push dublok/jenkins-agent:dev
# single command: docker build -t dublok/jenkins-agent:dev . && docker push dublok/jenkins-agent:dev