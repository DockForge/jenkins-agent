#!/bin/bash

# Ensure the Jenkins user is added to the docker group
sudo usermod -aG docker jenkins

# Change the permissions of the Docker socket
sudo chmod 666 /var/run/docker.sock

# Correct permissions for the Jenkins workspace directory
sudo chown -R jenkins:jenkins /home/jenkins/agent/workspace
sudo chmod -R 775 /home/jenkins/agent/workspace

# Execute the original entrypoint command
exec /usr/local/bin/jenkins-agent "$@"
