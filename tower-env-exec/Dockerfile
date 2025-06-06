# Start from the official AWX EE base image
FROM quay.io/ansible/awx-ee:latest

# Set environment variables
ENV HOME=/root
ENV ANSIBLE_COLLECTIONS_PATHS=${HOME}/.ansible/collections
ENV KUBERNETES_AUTH_IN_CLUSTER=true  
# Switch to root for installations
USER root

# Install system dependencies: git, kubectl, helm + Python tools
RUN dnf install -y --allowerasing \
    git \
    curl \
    unzip \
    python3-pip \
    && dnf clean all \
    && curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl" \
    && install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl \
    && curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash

# Install required Python libraries for Kubernetes
RUN pip3 install --upgrade pip && \
    pip3 install kubernetes openshift pyyaml

# Setup project directories with correct permissions
RUN mkdir -p ${HOME}/.ansible/collections \
    ${HOME}/inventory \
    ${HOME}/project \
    ${HOME}/.kube \
    && chown -R 1000:0 ${HOME} \
    && chmod -R ug+rwx ${HOME}

# Copy Ansible configuration files
COPY requirements.yml /tmp/requirements.yml
COPY inventory ${HOME}/inventory/hosts
COPY ansible.cfg ${HOME}/project/ansible.cfg

# Install Ansible collections
RUN ansible-galaxy collection install -r /tmp/requirements.yml --collections-path ${ANSIBLE_COLLECTIONS_PATHS}

# Switch back to runner user (UID 1000)


# Final entrypoint
ENTRYPOINT ["dumb-init", "--"]
CMD ["sleep", "infinity"]