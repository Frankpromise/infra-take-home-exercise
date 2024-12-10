#!/bin/bash

# Exit on errors
set -e

# Variables
IMAGE_NAME="promiserepo/python-microservice"
K8S_MANIFEST="release/deployment.yaml"
MINIKUBE_SERVICE_NAME="python-microservice-service"
NAMESPACE="dev"

function create_namespace {
    echo "Checking if namespace '$NAMESPACE' exists..."
    if ! kubectl get namespace $NAMESPACE > /dev/null 2>&1; then
        echo "Namespace '$NAMESPACE' does not exist. Creating it..."
        kubectl create namespace $NAMESPACE
    else
        echo "Namespace '$NAMESPACE' already exists."
    fi
}

# Function: Check if Minikube is running
function check_minikube {
    # brew install socket_vmnet
    # brew tap homebrew/services
    # HOMEBREW=$(which brew) && sudo ${HOMEBREW} services start socket_vmnet
    # brew install qemu
    echo "Checking if Minikube is running..."
    if ! minikube status > /dev/null 2>&1; then
        echo "Minikube is not running. Starting Minikube..."
        minikube start
    else
        echo "Minikube is running."
    fi
}

# Function: Build Docker image inside Minikube's Docker environment
function build_image {
    echo "Switching to Minikube's Docker environment..."
    eval $(minikube docker-env)
    echo "Building Docker image: $IMAGE_NAME"
    docker build -t $IMAGE_NAME .
    echo "Docker image $IMAGE_NAME built successfully."
}

# Function: Apply Kubernetes manifests
function deploy_to_kubernetes {
    echo "Deploying the application to Kubernetes..."
    kubectl apply -f $K8S_MANIFEST
    echo "Deployment applied. Waiting for pods to become ready..."
    kubectl wait --for=condition=available --timeout=60s deployment/python-microservice -n $NAMESPACE
}

# Function: Get Minikube service URL
function test_microservice {
    echo "Retrieving service URL..."
    SERVICE_URL=$(minikube service $MINIKUBE_SERVICE_NAME -n $NAMESPACE)
    echo "Service is available at: $SERVICE_URL"
}


# Main script execution
create_namespace
check_minikube
build_image
deploy_to_kubernetes
test_microservice

echo "Deployment completed successfully!"
