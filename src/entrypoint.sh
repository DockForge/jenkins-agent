#!/bin/bash

# Ensure the Jenkins user is added to the docker group
sudo usermod -aG docker jenkins

# Change the permissions of the Docker socket
sudo chmod 666 /var/run/docker.sock

# Execute the original entrypoint command
exec /usr/local/bin/jenkins-agent "$@"