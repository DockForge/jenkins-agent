#!/bin/bash

# Start the Docker daemon as root
if [ "$EUID" -ne 0 ]; then
    echo "Switching to root to start Docker daemon"
    exec sudo -E "$0" "$@"
fi

# Set up sudo environment
echo "Setting up sudo environment"
echo "jenkins ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/jenkins
chmod 440 /etc/sudoers.d/jenkins

# Start the Docker daemon with vfs as the storage driver
dockerd --storage-driver=vfs &

# Wait for the Docker daemon to start
while (! docker info > /dev/null 2>&1 ); do
    echo "Waiting for Docker daemon to start..."
    sleep 1
done

# Create directories and set permissions
mkdir -p /home/jenkins/agent/workspace
chown -R jenkins:jenkins /home/jenkins
chmod -R 775 /home/jenkins

# Set environment variables
export JENKINS_HOME=/home/jenkins
export JENKINS_AGENT_HOME=/home/jenkins/agent
export PATH="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"

# Create a wrapper script to run the Jenkins agent
cat > /usr/local/bin/run-jenkins-agent.sh << 'EOF'
#!/bin/bash
export JENKINS_HOME=/home/jenkins
export JENKINS_AGENT_HOME=/home/jenkins/agent
export PATH="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"
exec /usr/local/bin/jenkins-agent "$@"
EOF

chmod +x /usr/local/bin/run-jenkins-agent.sh
chown jenkins:jenkins /usr/local/bin/run-jenkins-agent.sh

# Switch to Jenkins user and run Jenkins agent
exec gosu jenkins /usr/local/bin/run-jenkins-agent.sh "$@"