# API Gateway

Central entry point that routes and authenticates all external client requests.

---

## 🚀 CI/CD Architecture & Pipeline

This repository includes a production-grade CI/CD pipeline using **GitHub Actions**, **Azure Container Registry (ACR)**, and **Azure Kubernetes Service (AKS)** with **HPA** autoscaling.

```
[ Git Push / PR ] 
       │
       ▼
[ 1. Build & Test ] ──► Maven Compile & Unit Tests
       │
       ▼ (on push to main)
[ 2. Docker & ACR ] ──► Build Docker Image & Push to Azure ACR
       │
       ▼
[ 3. Deploy to AKS ] ──► Apply K8s Manifests (Deployment, Service, HPA, ConfigMap)
```

---

## 📁 Repository Structure for CI/CD

- **`.github/workflows/ci-cd.yml`** - GitHub Actions workflow pipeline.
- **`Dockerfile`** - Multi-stage, secure container build for Java/Spring Boot.
- **`.dockerignore`** - Build context optimization.
- **`k8s/`**:
  - `deployment.yaml` - Pod deployment with resource limits, liveness & readiness probes.
  - `service.yaml` - Internal ClusterIP service definition.
  - `hpa.yaml` - Horizontal Pod Autoscaler (2 to 10 pods based on CPU/RAM).
  - `configmap.yaml` - Environment configurations (Redis, etc.).

---

## 🔑 Required GitHub Secrets

Go to **GitHub Repository** ➔ **Settings** ➔ **Secrets and variables** ➔ **Actions** and add:

| Secret Name | Description | Example / How to generate |
| :--- | :--- | :--- |
| `AZURE_CREDENTIALS` | Azure Service Principal JSON | Output of `az ad sp create-for-rbac` (see below) |
| `ACR_NAME` | Azure Container Registry name | `myacrregistry` |
| `AZURE_RESOURCE_GROUP` | Resource group where AKS is hosted | `my-resource-group` |
| `AKS_CLUSTER_NAME` | Name of your AKS Cluster | `my-aks-cluster` |

### 🛠️ Azure Service Principal Generation

```bash
az ad sp create-for-rbac \
  --name "github-actions-aks-sp" \
  --role "Contributor" \
  --scopes /subscriptions/<SUBSCRIPTION_ID>/resourceGroups/<RESOURCE_GROUP> \
  --sdk-auth
```
Copy the resulting JSON output and paste it into the `AZURE_CREDENTIALS` secret.

Attach ACR Pull role to AKS:
```bash
az aks update -n <AKS_CLUSTER_NAME> -g <RESOURCE_GROUP> --attach-acr <ACR_NAME>
```

