FROM jenkins/inbound-agent:latest

USER root

# Update and install essential packages
RUN apt-get update && apt-get upgrade -y
RUN apt-get install -y gnupg2 lsb-release sudo curl iptables iproute2 kmod

# Install Docker Engine (client and daemon)
RUN curl -fsSL https://download.docker.com/linux/debian/gpg | apt-key add -
RUN echo "deb [arch=amd64] https://download.docker.com/linux/debian buster stable" > /etc/apt/sources.list.d/docker.list
RUN apt-get update && apt-get install -y docker-ce

# Add Jenkins user to the docker group and set permissions
RUN usermod -aG docker jenkins
RUN echo "jenkins ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

# Copy and set permissions for the entrypoint script
COPY entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

# Ensure necessary kernel modules are loaded
RUN modprobe br_netfilter || true
RUN modprobe overlay || true

# Switch to jenkins user
USER jenkins

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
