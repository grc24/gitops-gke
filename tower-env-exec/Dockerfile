# Start from the official AWX-EE base image
FROM quay.io/ansible/awx-ee:latest

# Set environment variables for Ansible collections
ENV ANSIBLE_COLLECTIONS_PATHS=/home/runner/.ansible/collections
ENV HOME=/home/runner

# Switch to root to install dependencies
USER root

# Install additional system packages (if needed)
# Example: RUN dnf install -y git && dnf clean all

# Ensure the collections directory exists and has correct permissions
RUN mkdir -p /home/runner/.ansible/collections  /home/runner/inventory /home/runner/project \
    && chown -R 1000:0 /home/runner \
    && chmod -R ug+rwx /home/runner

# Copy all needed
COPY requirements.yml /tmp/requirements.yml
COPY inventory /home/runner/inventory/hosts
COPY ansible.cfg /home/runner/project/ansible.cfg 

# Switch back to the non-root user (UID 1000)
USER 1000

# Install Ansible collections (requirements.yml (if needed)if requirements.yml exists)
RUN if [ -f /tmp/requirements.yml ]; then \
      ansible-galaxy collection install -r /tmp/requirements.yml \
        --collections-path /home/runner/.ansible/collections; \
    fi

# Set the default entrypoint (critical for AWX compatibility)
ENTRYPOINT ["dumb-init", "--"]
CMD ["sleep", "infinity"]