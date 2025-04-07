#!/bin/bash

set -e

echo "🚀 Installing Argo CD on Minikube..."

# Step 1: Create namespace
kubectl create namespace argocd || echo "Namespace 'argocd' already exists"

# Step 2: Apply Argo CD core components
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml

# Step 3: Wait for all pods to be ready
echo "⏳ Waiting for Argo CD pods to be ready..."
kubectl wait --for=condition=available deployment/argocd-server -n argocd --timeout=180s

# Step 4: Get default admin password
PASSWORD=$(kubectl get secret argocd-initial-admin-secret -n argocd \
  -o jsonpath="{.data.password}" | base64 --decode)

# Step 5: Start port forwarding in the background
echo "🔁 Starting port-forward to localhost:8080..."
kubectl port-forward svc/argocd-server -n argocd 8080:443 >/dev/null 2>&1 &
PORT_FORWARD_PID=$!

# Optional: Give port-forwarding a moment to establish
sleep 3

echo ""
echo "✅ Argo CD installed and accessible locally!"
echo "🌐 Access the UI at: http://localhost:8080"
echo "🔐 Username: admin"
echo "🔑 Password: $PASSWORD"
echo ""
echo "🛑 To stop port forwarding, run: kill $PORT_FORWARD_PID"
