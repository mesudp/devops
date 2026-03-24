# Guestbook App on Kubernetes 🚀

A simple full-stack **Guestbook application** deployed on **Kubernetes**.

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
└── gb-db.yaml
```

* **gb-frontend.yaml** → frontend Deployment + Service
* **gb-backend.yaml** → backend Deployment + Service
* **gb-db.yaml** → PostgreSQL Deployment + Service + PVC + ConfigMap

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
kubectl port-forward svc/gb-frontend-service 8080:80
```

Open in browser:

```
http://localhost:8080
```

---

### Backend

```bash
kubectl port-forward svc/gb-backend-service 5000:5000
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
* Transitioning from Docker Compose to Kubernetes


---

⭐ If you find this repository helpful, consider giving it a star!

