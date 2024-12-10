# infra-take-home-exercise
## Thought process
![image](https://github.com/user-attachments/assets/555e398a-b12f-4f40-8008-fe7781de1f17)


# Python Microservice

## Overview

This is a simple Python microservice built using Flask. The service responds to GET requests on the `/student` endpoint with a JSON response: `{ "student_status": "hired" }`.

The microservice is containerized using Docker and deployed to a Kubernetes cluster. The setup includes health checks, resource management, and a script for automated deployment to Minikube.

---

## Features

- **Endpoint**: Responds to GET requests at `/student`.
- **JSON Response**: `{ "student_status": "hired" }`.
- **Health Probes**: Kubernetes liveness and readiness probes ensure reliability.
- **Scalability**: Kubernetes deployment is configured with flexible scaling options.
- **Resource Optimization**: Includes resource requests and limits for efficient usage.
- **Automated Deployment**: A Bash script for building, pushing, and deploying the microservice.

---

## Design Decisions

### 1. **Framework**

- I Chose Flask due to its simplicity and suitability for lightweight RESTful APIs and also my familiarity with the language.

### 2. **Containerization**

- Built with a python lightweight base image for memory optimization.
- Runs as a non-root user for security.

### 3. **Deployment to Kubernetes**

- Used Kubernetes for scalability, resilience, and ease of management.
- Configured readiness and liveness probes to ensure application health.
- Resource limits prevent the application from over-consuming cluster resources.

### 4. **Minikube for Local Testing**

- Minikube provides a lightweight local Kubernetes cluster for testing and development.

---

## Requirements

### Local Development
make sure you have the following already installed in your local environment
- Python 3.9+
- Flask
- pip

### Kubernetes Cluster

- Minikube or any Kubernetes environment
- kubectl
- Docker

Clone the repository:

   ```bash
   git clone https://github.com/Frankpromise/infra-take-home-exercise.git
   cd infra-take-home-exercise
   ```
---

## Setup Instructions

### Local Development without docker

1. ```terminal
   cd microservice
   flask run 
   ```
2. Navigate to the url displayed on the terminal

### Local Development with docker but without minikube


1. Build and run the Docker container locally:
   ```bash
   cd ..
   docker build -t python-microservice .
   docker run -p 8080:8080 python-microservice
   ```
   or run in detach mode

   ```
   docker run -d -name app -p 8080:8080 python-microservice
   ```

2. Access the service:

   Navigate to the url displayed on the terminal

   or 
   ```bash
   curl http://127.0.0.1:8080/student
   ```
---

## Kubernetes Deployment with minikube

### Prerequisites

- A running Minikube cluster:

  ```bash
  minikube start --driver=docker
  ```

- Enable Minikube’s Docker environment:

  ```bash
  eval $(minikube docker-env)
  ```

### Build and Push Image

1. Build the Docker image:

   ```bash
   docker build -t <dockerhub-username>/python-microservice:v1 .
   ```

2. Push the image to Docker Hub:

   ```bash
   docker push <dockerhub-username>/python-microservice:v1
   ```

### Apply Kubernetes Manifests

1. Create a namespace:

   ```bash
   kubectl create namespace dev
   ```

2. Deploy the application:

   ```bash
   kubectl apply -f release/deployment.yaml
   kubectl apply -f release/service.yaml
   ```

3. Verify the deployment:

   ```bash
   kubectl get pods -n dev
   ```

4. Access the service:

   ```bash
   minikube service python-microservice-service -n dev
   ```

---

## Automated Deployment Script

Run the provided Bash script to build and deploy the microservice with a single command:

```bash
chmod +x build-and-deploy.sh
./build-and-deploy.sh
```

The script:

1. Checks if Minikube is running.
2. Builds the Docker image in Minikube's environment.
3. Applies the Kubernetes manifests.
4. Waits for the deployment to become ready.
5. Automatically redirects you to the browser. Make sure to add a /student at the end

---

## Troubleshooting

1. **Minikube is not running**:

   ```bash
   minikube start --driver=docker
   ```

2. **Connection Refused**:

   - Ensure pods are running:
     ```bash
     kubectl get pods -n dev
     ```
   - Check application logs:
     ```bash
     kubectl logs <pod-name> -n dev
     ```

3. **Probes Failing**:

   - Ensure `/student` endpoint is functioning.
   - Adjust `initialDelaySeconds` and `timeoutSeconds` in the probes.

---

## Future Improvements

- Add CI/CD pipelines for automated builds and deployments.
- Implement horizontal pod autoscaling.
- Enhance monitoring with Prometheus and Grafana.

---

