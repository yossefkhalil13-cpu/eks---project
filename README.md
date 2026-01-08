# 🚀 AWS EKS Production CI/CD Project

This repository contains a **production-grade AWS EKS architecture**
built using **Terraform, Docker, Kubernetes, and GitHub Actions (OIDC)**.

The project demonstrates how to deploy a **fully private Kubernetes workload**
behind **CloudFront + AWS WAF**, using a **CloudFront VPC Origin**
to securely reach private resources inside a VPC **without exposing anything to the public internet**.

---

## 🧱 Architecture Overview

![Architecture Diagram](screenshots/architecture-diagram.png)

### Traffic Flow

1. User sends request to **Amazon CloudFront**
2. **AWS WAF** inspects and filters malicious traffic
3. CloudFront forwards traffic to a **CloudFront VPC Origin**
4. VPC Origin routes traffic to an **Internal Application Load Balancer (ALB)**
5. ALB forwards traffic to a **Kubernetes Service**
6. Application runs on **Amazon EKS Pods (private subnets only)**

✔️ No public ALB  
✔️ No public EKS endpoint  
✔️ No NAT Gateway  
✔️ AWS access via **VPC Endpoints only**

---

## 🛠️ Technology Stack

- **AWS**: EKS, ECR, VPC, ALB, CloudFront, WAF, IAM
- **Infrastructure as Code**: Terraform
- **Containers**: Docker
- **Orchestration**: Kubernetes
- **CI/CD**: GitHub Actions (OIDC – no static secrets)
- **Security**: IRSA, Least Privilege IAM
- **Monitoring**: Amazon CloudWatch Container Insights

---

## 📂 Project Structure

```text
.
├── .github/workflows/
│   └── ci-cd.yaml                 # GitHub Actions CI/CD pipeline (OIDC)
│
├── app/                           # Application source code
│   ├── Dockerfile
│   ├── app.py
│   └── requirements.txt
│
├── infra/
│   ├── environments/dev/          # Environment-specific Terraform
│   │   ├── cloudfront.tf
│   │   ├── cloudfront-vpc-origin.tf
│   │   ├── ecr.tf
│   │   ├── eks-cluster.tf
│   │   ├── eks-node-group.tf
│   │   ├── eks-iam.tf              # IRSA roles & policies
│   │   ├── iam_policy.json
│   │   ├── main.tf
│   │   ├── output.tf
│   │   ├── provider.tf
│   │   ├── terraform.tfvars
│   │   ├── variables.tf
│   │   ├── versions.tf
│   │   └── waf.tf
│   │
│   └── modules/
│       └── vpc/
│           ├── endpoints.tf       # VPC Endpoints (ECR, STS, Logs)
│           ├── main.tf
│           ├── outputs.tf
│           └── variables.tf
│
├── k8s/                           # Kubernetes manifests
│   ├── deployment.yaml
│   ├── service.yaml
│   └── ingress.yaml               # Managed by AWS Load Balancer Controller
│
├── screenshots/                   # Architecture & monitoring screenshots
│   ├── architecture-diagram.png
│   ├── hello-from-eks.png
│   ├── cloudwatch-node-cpu-memory.png
│   ├── cloudwatch-container-cpu-memory.png
│   ├── cloudwatch-container-cpu-over-limit.png
│   ├── aws-waf-web-acl.png
│   └── kubectl-cluster-resources.png
│
├── .gitignore
└── README.md

🔐 Security Design
	•	EKS runs in private subnets only
	•	Internal ALB (no public load balancers)
	•	CloudFront accesses ALB using VPC Origin
	•	AWS WAF attached to CloudFront
	•	IAM Least Privilege
	•	IRSA (IAM Roles for Service Accounts) used for:
	•	AWS Load Balancer Controller
	•	Kubernetes workloads accessing AWS services
	•	GitHub Actions (OIDC)
	•	No AWS credentials stored in GitHub
	•	Short-lived, scoped IAM roles

⸻

⚙️ Kubernetes & ALB Design
	•	AWS Load Balancer Controller installed in EKS
	•	Controller uses IRSA (no node IAM permissions)
	•	Ingress resources automatically create:
	•	Internal ALB
	•	Target Groups
	•	Listener Rules
	•	ALB is reachable only via CloudFront VPC Origin

⸻

🔁 CI/CD Pipeline (GitHub Actions)

Pipeline steps:
	1.	Authenticate to AWS using OIDC
	2.	Build Docker image
	3.	Push image to Amazon ECR
	4.	Deploy application to EKS using kubectl

📌 Notes:
	•	CI/CD depends on infrastructure availability
	•	Pipeline is disabled when infrastructure is destroyed
	•	No hard-coded secrets or credentials

⸻

📊 Monitoring & Observability

CloudWatch Container Insights provides visibility into:
	•	Node CPU & Memory usage
	•	Pod & Container CPU & Memory usage
	•	CPU utilization over limits
	•	Cluster resource health

Screenshots are available in the screenshots/ directory.

⸻

🧹 Infrastructure Lifecycle
	•	Infrastructure provisioned using Terraform
	•	CI/CD runs only when infrastructure exists
	•	Infrastructure can be safely destroyed to avoid cost
	•	Repository remains as:
	•	Architecture reference
	•	Production-grade EKS CI/CD example
