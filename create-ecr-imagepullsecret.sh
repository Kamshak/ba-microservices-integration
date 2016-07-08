#!/bin/bash

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

#
# When Kubernetes 1.3.0+ is released this approach should not be necessary
# This patch will allow Kubernetes to automatically cache cross-region AWS ECR tokens
# https://github.com/kubernetes/kubernetes/pull/24369
#

ACCOUNT=277555456074
REGION=eu-west-1
SECRET_NAME=${REGION}-ecr-registry
EMAIL=funk.valentin@gmail.com

#
# Fetch token (which will expire in 12 hours)
#

TOKEN=`aws ecr --region=$REGION get-authorization-token --output text --query authorizationData[].authorizationToken | base64 -d | cut -d: -f2`

#
# Create or repleace registry secret
#

kubectl delete secret --ignore-not-found $SECRET_NAME
kubectl create secret docker-registry $SECRET_NAME \
 --docker-server=https://${ACCOUNT}.dkr.ecr.${REGION}.amazonaws.com \
 --docker-username=AWS \
 --docker-password="${TOKEN}" \
 --docker-email="${EMAIL}"

# end
