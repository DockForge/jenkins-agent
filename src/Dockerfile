# Base image
FROM jenkins/inbound-agent:latest

USER root

# Update and install essential packages
RUN apt-get update && apt-get upgrade -y
RUN apt-get install -y gnupg2 lsb-release sudo curl iptables iproute2 kmod \
    git build-essential htop zip unzip

# Install OpenJDK LTS version
RUN apt-get update && \
    (apt-get install -y openjdk-17-jdk || echo "Fallback to OpenJDK 17")

# Install Docker Engine (client and daemon)
RUN curl -fsSL https://download.docker.com/linux/debian/gpg | apt-key add -
RUN echo "deb [arch=amd64] https://download.docker.com/linux/debian buster stable" > /etc/apt/sources.list.d/docker.list
RUN apt-get update && apt-get install -y docker-ce

# Install pyenv dependencies
RUN apt-get install -y make build-essential libssl-dev zlib1g-dev libbz2-dev \
    libreadline-dev libsqlite3-dev wget curl llvm libncurses5-dev libncursesw5-dev \
    xz-utils tk-dev libffi-dev liblzma-dev python3-openssl git && \
    curl https://pyenv.run | bash && \
    export PYENV_ROOT="$HOME/.pyenv" && \
    export PATH="$PYENV_ROOT/bin:$PATH" && \
    eval "$(pyenv init --path)" && \
    eval "$(pyenv virtualenv-init -)" && \
    # Specify a known Python version
    pyenv install 3.10.4 && \
    pyenv global 3.10.4 && \
    ln -s /root/.pyenv/shims/python /usr/bin/python && \
    ln -s /root/.pyenv/shims/pip /usr/bin/pip

# Install Node.js LTS version
RUN curl -fsSL https://deb.nodesource.com/setup_lts.x | bash - && \
    apt-get install -y nodejs

# Install Docker Compose
RUN curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose && \
    chmod +x /usr/local/bin/docker-compose

# Install Python packages
RUN pip install virtualenv requests numpy pandas pytest pylint bandit

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
