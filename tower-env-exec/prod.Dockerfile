# Start from the official AWX EE base image
FROM quay.io/ansible/awx-ee:latest

# Set environment variables
ENV HOME=/root
ENV ANSIBLE_COLLECTIONS_PATHS=${HOME}/.ansible/collections
ENV CLOUDSDK_PYTHON=/usr/bin/python3
ENV PATH="$PATH:/usr/local/gcloud/google-cloud-sdk/bin"

# Switch to root for installations
USER root

# Install system dependencies: git, kubectl, helm, and Google Cloud SDK
RUN dnf install -y --allowerasing \
    git \
    curl \
    wget \
    unzip \
    python3-pip \
    && dnf clean all \
    && curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl" \
    && install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl \
    && curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash \
    && curl -sSL https://sdk.cloud.google.com | bash \
    && mv /root/google-cloud-sdk /usr/local/gcloud \
    && ln -s /usr/local/gcloud/google-cloud-sdk/bin/gcloud /usr/bin/gcloud \
    && ln -s /usr/local/gcloud/google-cloud-sdk/bin/gsutil /usr/bin/gsutil

# Install required Python libraries for Kubernetes and GCP
RUN pip3 install --upgrade pip && \
    pip3 install kubernetes openshift pyyaml google-auth requests

# Setup project directories with correct permissions
RUN mkdir -p ${HOME}/.ansible/collections \
    ${HOME}/inventory \
    ${HOME}/project \
    ${HOME}/.kube \
    ${HOME}/.config/gcloud \
    && chown -R 1000:0 ${HOME} \
    && chmod -R ug+rwx ${HOME}

# Copy Ansible configuration files
COPY requirements.yml /tmp/requirements.yml
COPY inventory ${HOME}/inventory/hosts
COPY ansible.cfg ${HOME}/project/ansible.cfg
COPY application_default_credentials.json ${HOME}/.config/gcloud/application_default_credentials.json

# Install Ansible collections
RUN ansible-galaxy collection install -r /tmp/requirements.yml --collections-path ${ANSIBLE_COLLECTIONS_PATHS}

# Switch back to runner user (UID 1000)
USER 1000

# Final entrypoint
ENTRYPOINT ["dumb-init", "--"]
CMD ["sleep", "infinity"]