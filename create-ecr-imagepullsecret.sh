#!/bin/bash

# Required ENV Vars:
# AWS_REGISTRY_URL (e.g. 277555456074.dkr.ecr.eu-west-1.amazonaws.com)
# AWS_REGION (e.g. eu-west-1)
# optional KUBE_NAMESPACE
KUBE_NAMESPACE=${KUBE_NAMESPACE:-default}

# Script by Nayeem Syed  https://gist.github.com/developerinlondon/da738437fe561b8f342e1e343bafbf3e

#
# Create a Kubernetes registry secret for an AWS ECR region
# Requires AWS CLI: https://aws.amazon.com/cli/
# Requires kubectl: https://coreos.com/kubernetes/docs/latest/configure-kubectl.html
#

#
# This secret can be used with 'imagePullSecret' for Kubernetes
#
# ...
# spec:
#   containers:
#   - name: busybox
#     image: busybox:latest
#   imagePullSecrets:
#   - name: us-west-2-ecr-registry
#...
#

SECRET_NAME=${AWS_REGION}-ecr-registry

#
# Fetch token (which will expire in 12 hours)
#

TOKEN=`aws ecr --region=$AWS_REGION get-authorization-token --output text --query authorizationData[].authorizationToken | base64 -d | cut -d: -f2`

#
# Create or repleace registry secret
#

kubectl delete secret --ignore-not-found $SECRET_NAME --namespace=$KUBE_NAMESPACE
kubectl create secret docker-registry $SECRET_NAME \
 --docker-server=$AWS_REGISTRY_URL \
 --docker-username=AWS \
 --docker-password="${TOKEN}" \
 --docker-email=none

# end
