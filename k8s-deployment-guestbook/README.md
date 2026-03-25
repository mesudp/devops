# Guestbook App on Kubernetes 🚀

A simple full-stack **Guestbook application** deployed on **Kubernetes**.

This project was built as a hands-on learning exercise to understand containerization and Kubernetes deployment.

It demonstrates how to deploy a multi-tier application (frontend, backend, database) using Kubernetes with best practices such as:

* Docker image versioning
* Kubernetes Services (ClusterIP, NodePort)
* Secrets management for sensitive data
* Internal service communication

This project is a Kubernetes version of my Dockerized guestbook app (docker-compose-guestbook), consisting of:

* Frontend (Nginx)
* Backend (Node.js + Express)
* Database (PostgreSQL)

---

## 📦 Architecture

```
User
  ↓
Frontend (Nginx)
  ↓
Backend (Node.js / Express)
  ↓
PostgreSQL
```

---

## 📁 Project Structure

```
k8s-deployment-guestbook/
├── gb-frontend.yaml
├── gb-backend.yaml
├── gb-db.yaml
└── gb-secrets.yaml
```

* **gb-frontend.yaml** → frontend Deployment + Service
* **gb-backend.yaml** → backend Deployment + Service
* **gb-db.yaml** → PostgreSQL Deployment + Service + PVC + ConfigMap
* **gb-secrets.yaml** → Kubernetes Secret for database credentials (username & password)

---

## 🛠️ Technologies

* Kubernetes
* Docker
* Docker Hub
* Nginx
* Node.js
* Express
* PostgreSQL

---

## ⚙️ Features

* Full-stack app deployed on Kubernetes
* Docker images pushed to Docker Hub
* Persistent storage using PersistentVolumeClaim
* Automatic database initialization using SQL
* Service-based communication between components

---
## 🔐 Secrets Management

Sensitive data such as database credentials are managed using Kubernetes Secrets.

Example (gb-secrets.yaml):
```bash
apiVersion: v1
kind: Secret
metadata:
  name: db-secret
type: Opaque
stringData:
  user: mesud #chnage to any DB username you want
  password: pass43212 #chnage to any DB password you want
```

---
## 🚀 Deployment

Apply all Kubernetes resources:

```bash
kubectl apply -f k8s-deployment-guestbook/
```

---

## 🔍 Check Resources

```bash
kubectl get pods
kubectl get svc
```

---

## 🌐 Access the Application (Local)

### Frontend

```bash
kubectl port-forward svc/guestbook-frontend-service 8080:80
```

Open in browser:

```
http://localhost:8080
```

---

### Backend

```bash
kubectl port-forward svc/guestbook-backend-service 5000:5000
```

Test:

```
http://localhost:5000/health
```

---

## 📝 Notes

* This project uses **port-forwarding** for local access.
* In production, **Ingress** should be used instead of NodePort or port-forward.
* PostgreSQL is initialized automatically with a table for guestbook entries.

---

## 🎯 Learning Goals

This project demonstrates:

* Building Docker images
* Pushing images to Docker Hub
* Writing Kubernetes YAML manifests
* Using Deployments and Services
* Working with ConfigMaps and PersistentVolumeClaims
* Managing sensitive data with Kubernetes Secrets
* Transitioning from Docker Compose to Kubernetes


---

## ⚠️ Important Note: PostgreSQL + Persistent Volumes

When using PostgreSQL with a PersistentVolumeClaim (PVC), environment variables such as:

- `POSTGRES_USER`
- `POSTGRES_PASSWORD`
- `POSTGRES_DB`

are **only applied during the initial database setup**.

If the database has already been initialized, changing these values later (for example via Kubernetes Secrets) will **not update existing users or credentials**.

### 🔴 Common Issue

You may encounter errors like:
```bash
FATAL: password authentication failed for user "..."
```
```bash
DETAIL: Role "..." does not exist.
```

This happens because the database is still using the old credentials stored in the persistent volume.

### ✅ Solution

To apply new credentials, you must reinitialize the database by deleting the existing volume:

```bash
kubectl delete deployment db
kubectl delete pvc postgres-pvc
kubectl apply -f .
```
⚠️ This will delete all existing database data.
---
---
---
⭐ If you find this repository helpful, consider giving it a star!

