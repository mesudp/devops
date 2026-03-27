# Kubernetes Cluster on AWS with Terraform

## 📌 Overview

This project provisions a simple Kubernetes cluster on AWS using Terraform.

It creates:

* 1 Kubernetes **master (control plane)** node
* 1 Kubernetes **worker** node
* Security group with required ports
* IAM role for EC2 access

The cluster is automatically configured using `user_data` scripts.

---

## ⚙️ Technologies Used

* AWS EC2
* Terraform
* Kubernetes (kubeadm)
* Bash scripting

---

## 📁 Project Structure

```
.
├── main.tf        # Terraform configuration
├── master.sh      # Setup script for master node
├── worker.sh      # Setup script for worker node
```

---

## 🚀 How It Works

1. Terraform provisions EC2 instances on AWS
2. `master.sh` initializes the Kubernetes control plane
3. `worker.sh` joins the worker node to the cluster
4. After provisioning, you can connect via SSH and use `kubectl`

---

## 🔑 Prerequisites

* AWS account
* AWS key pair (e.g. `awskey.pem`)
* Terraform installed

---

## ▶️ Usage

### 1. Create Terraform Runner EC2

* Launch an EC2 instance (Amazon Linux or Ubuntu)
* Attach an IAM role with permissions for:

  * EC2
  * IAM (if needed)
* Open port 22 (SSH) in the security group

---

### 2. Connect via SSH / VS Code

From your local machine:

```bash
ssh -i ~/.ssh/awskey.pem ec2-user@<TERRAFORM_EC2_PUBLIC_IP>
```

Or connect using VS Code Remote SSH.

---

### 3. Install Terraform on EC2

```bash
sudo yum install -y yum-utils
sudo yum-config-manager --add-repo https://rpm.releases.hashicorp.com/AmazonLinux/hashicorp.repo
sudo yum -y install terraform
```

Verify:

```bash
terraform -v
```

---

### 4. Upload Project Files

Copy or create the following files on the EC2 instance:

* `main.tf`
* `master.sh`
* `worker.sh`

---

### 5. Initialize Terraform

```bash
terraform init
```

---

### 6. Apply Infrastructure

```bash
terraform apply
```

Confirm with:

```bash
yes
```

Terraform will:

* Create master and worker EC2 instances
* Run setup scripts automatically
* Output public and private DNS

---

### 7. Connect to Kubernetes Master

From your **local machine**:

```bash
ssh -i ~/.ssh/awskey.pem ubuntu@<MASTER_PUBLIC_IP>
```

---

### 8. Verify Cluster

```bash
kubectl get nodes
```

You should see:

* `kube-master` (control-plane)
* `kube-worker`

Expected output:

* master node (control-plane)
* worker node

---

## 🌐 Deploy Test Application

```bash
kubectl create deployment nginx --image=nginx
kubectl expose deployment nginx --type=NodePort --port=80
kubectl get svc
```

Access via:

```
http://<EC2_PUBLIC_IP>:<NODE_PORT>
```

---

## ⚠️ Notes

* Security group allows SSH and NodePort access
* This setup is for learning/testing purposes (not production-ready)



