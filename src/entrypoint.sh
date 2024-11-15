#!/bin/bash

# Start the Docker daemon as root
if [ "$EUID" -ne 0 ]; then
  echo "Switching to root to start Docker daemon"
  exec sudo -E "$0" "$@"
fi

# Attempt to modify user permissions before switching users
if ! usermod -aG docker jenkins; then
  echo "Warning: Failed to add Jenkins to the docker group. Permissions might be limited."
fi

# Start the Docker daemon with vfs as the storage driver
dockerd --storage-driver=vfs &

# Wait for the Docker daemon to start
while (! docker info > /dev/null 2>&1 ); do
  echo "Waiting for Docker daemon to start..."
  sleep 1
done

# Switch to Jenkins user and run Jenkins agent
sudo -u jenkins -E /bin/bash -c '
  mkdir -p /home/jenkins/agent/workspace
  chown -R jenkins:jenkins /home/jenkins/agent/workspace
  chmod -R 775 /home/jenkins/agent/workspace

  exec /usr/local/bin/jenkins-agent "$@"
'
