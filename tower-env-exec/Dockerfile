# Start from the official AWX-EE base image
FROM quay.io/ansible/awx-ee:latest

# Environment for Ansible Collections and Home directory
ENV HOME=/home/runner
ENV ANSIBLE_COLLECTIONS_PATHS=${HOME}/.ansible/collections

# Switch to root user for installing and setting permissions
USER root

# Install additional system packages if needed
# RUN dnf install -y git && dnf clean all

# Setup working directories
RUN mkdir -p ${HOME}/.ansible/collections \
    ${HOME}/inventory \
    ${HOME}/project \
 && chown -R 1000:0 ${HOME} \
 && chmod -R ug+rwx ${HOME}

# Copy necessary files
COPY requirements.yml /tmp/requirements.yml
COPY inventory /home/runner/inventory/hosts
COPY ansible.cfg /home/runner/project/ansible.cfg 

# Switch to runner user (UID 1000)
USER 1000

# Install Ansible Collections if requirements file exists
RUN ansible-galaxy collection install -r /tmp/requirements.yml --collections-path ${ANSIBLE_COLLECTIONS_PATHS}

# Set dumb-init and default command for AWX
ENTRYPOINT ["dumb-init", "--"]
CMD ["sleep", "infinity"]
