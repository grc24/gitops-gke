#!/bin/bash
CLUSTER_NAME=$1
REGION=$2
PROJECT_ID=$3

echo "Authenticating to GKE..."
gcloud container clusters get-credentials "$CLUSTER_NAME" --region "$REGION" --project "$PROJECT_ID"