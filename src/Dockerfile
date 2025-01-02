# Base image
FROM jenkins/inbound-agent:latest

# Switch to root for installations
USER root

# Set environment variables
ENV JENKINS_USER=jenkins
ENV JENKINS_AGENT_WORKDIR=/home/jenkins/agent/workspace
ENV PATH="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"
ENV SUDO_FORCE_REMOVE=yes

# Update and install essential packages
RUN apt-get update && apt-get upgrade -y && \
    apt-get install -y \
    gnupg2 \
    lsb-release \
    sudo \
    curl \
    iptables \
    iproute2 \
    kmod \
    git \
    build-essential \
    htop \
    zip \
    unzip \
    gosu

# Install OpenJDK LTS version
RUN apt-get update && \
    (apt-get install -y openjdk-17-jdk || echo "Fallback to OpenJDK 17")

# Install Docker Engine
RUN curl -fsSL https://download.docker.com/linux/debian/gpg | apt-key add - && \
    echo "deb [arch=amd64] https://download.docker.com/linux/debian buster stable" > /etc/apt/sources.list.d/docker.list && \
    apt-get update && \
    apt-get install -y docker-ce

# Install Docker Compose
RUN curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose && \
    chmod +x /usr/local/bin/docker-compose

# Set up sudo access for jenkins user
RUN echo "jenkins ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/jenkins && \
    chmod 440 /etc/sudoers.d/jenkins

# Add Jenkins user to the docker group
RUN usermod -aG docker jenkins

# Create necessary directories and set permissions
RUN mkdir -p /home/jenkins/agent/workspace && \
    chown -R jenkins:jenkins /home/jenkins && \
    chmod -R 775 /home/jenkins

# Copy and set permissions for the entrypoint script
COPY entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

# Ensure necessary kernel modules are loaded
RUN modprobe br_netfilter || true
RUN modprobe overlay || true

# Set default command
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]