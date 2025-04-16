# gitops-gke
## Prerequisites

* A GKE cluster is already up and running.

* kubectl is configured to access the GKE cluster.

* **ansible** and **helm** are installed locally or on your CI/CD host.

The Ansible **community.kubernetes** collection is installed:

```bash
ansible-galaxy collection install community.kubernetes
```

## Argo CD on GKE with Ansible

### Setup
```bash
chmod +x scripts/gke-auth.sh
./scripts/gke-auth.sh <CLUSTER_NAME> <REGION> <PROJECT_ID>
ansible-playbook playbooks/install-argocd.yml