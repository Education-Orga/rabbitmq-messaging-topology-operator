#!/bin/bash

# set context to application-cluster
KUBE_CONTEXT="kind-application-cluster"
kubectl config use-context "$KUBE_CONTEXT"

# create rabbitmq  namespace if not present
RABBITMQ_NAMESPACE="rabbitmq"
kubectl get ns "$RABBITMQ_NAMESPACE" || kubectl create ns "$RABBITMQ_NAMESPACE"

# install OLM
curl -sL https://github.com/operator-framework/operator-lifecycle-manager/releases/download/v0.26.0/install.sh | bash -s v0.26.0

# deploy rabbitmq messaging topology operator from operatorhub manifests
echo "deploy rabbitmq messaging topology operator..."
kubectl create -f https://operatorhub.io/install/rabbitmq-messaging-topology-operator.yaml

# deploy mongodb crds
kubectl apply -f configs/binding.yaml -n "$RABBITMQ_NAMESPACE"
kubectl apply -f configs/exchange.yaml -n "$RABBITMQ_NAMESPACE"
kubectl apply -f configs/queue.yaml -n "$RABBITMQ_NAMESPACE"


echo "RabbitMQ Messaging Topology Operator and CRDs deployed successfully in namespace '$RABBITMQ_NAMESPACE' of context '$KUBE_CONTEXT'."