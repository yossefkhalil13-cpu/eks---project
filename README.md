# 🚀 AWS EKS Production CI/CD Project

This repository demonstrates a **production-grade AWS EKS architecture**
built using **Terraform, Docker, Kubernetes, and GitHub Actions (OIDC)**.

The project focuses on deploying a **fully private Kubernetes workload**
behind **Amazon CloudFront + AWS WAF**, using a **CloudFront VPC Origin**
to securely access private resources inside a VPC **without exposing anything to the public internet**.

---

### Traffic Flow

1. User sends request to **Amazon CloudFront**
2. **AWS WAF** inspects and blocks malicious traffic
3. CloudFront forwards traffic to a **CloudFront VPC Origin**
4. VPC Origin routes traffic to an **Internal Application Load Balancer (ALB)**
5. ALB forwards traffic to a **Kubernetes Service**
6. Application runs on **Amazon EKS Pods (private subnets only)**

✔️ No public ALB  
✔️ No public EKS endpoint  
✔️ No NAT Gateway  
✔️ AWS access via **VPC Endpoints only**

---

## 🌍 CloudFront Configuration

- CloudFront is configured using **Price Class 100**
- Traffic is served only from the most cost-effective edge locations
- AWS WAF is attached to CloudFront for Layer-7 protection

---

## 🛠 Technology Stack

- **AWS**: EKS, ECR, VPC, ALB, CloudFront, WAF, IAM
- **Infrastructure as Code**: Terraform
- **Containers**: Docker
- **Orchestration**: Kubernetes
- **CI/CD**: GitHub Actions (OIDC – no static secrets)
- **Monitoring**: Amazon CloudWatch Container Insights

---

## 📂 Project Structure

```text
.
├── .github/workflows/
│   └── ci-cd.yaml                # GitHub Actions CI/CD pipeline (manual)
│
├── app/                          # Application source code
│   ├── Dockerfile
│   ├── app.py
│   └── requirements.txt
│
├── infra/
│   ├── environments/dev/         # Terraform environment
│   │   ├── cloudfront.tf
│   │   ├── cloudfront-vpc-origin.tf
│   │   ├── waf.tf
│   │   ├── ecr.tf
│   │   ├── eks-cluster.tf
│   │   ├── eks-node-group.tf
│   │   ├── main.tf
│   │   ├── provider.tf
│   │   ├── variables.tf
│   │   └── versions.tf
│   │
│   └── modules/
│       └── vpc/
│           ├── main.tf
│           ├── endpoints.tf      # VPC Endpoints (ECR, STS, Logs)
│           ├── variables.tf
│           └── outputs.tf
│
├── k8s/                          # Kubernetes manifests
│   ├── deployment.yaml
│   ├── service.yaml
│   └── ingress.yaml
│
├── screenshots/                  # Architecture & monitoring screenshots
│
├── .gitignore
└── README.md
🔐 Security Design
	•	EKS runs in private subnets only
	•	Internal ALB (no public exposure)
	•	CloudFront accesses ALB via VPC Origin
	•	AWS WAF attached to CloudFront
	•	IAM follows least-privilege principle
	•	IRSA is used for the AWS Load Balancer Controller pod
	•	GitHub Actions uses OIDC (no AWS secrets stored in GitHub)

⸻

⚙️ Kubernetes & ALB Control Flow
	•	AWS Load Balancer Controller is installed in EKS
	•	Controller runs using IRSA
	•	Ingress resources trigger the controller to:
	•	Create and manage Internal ALB
	•	Configure listeners and target groups
	•	ALB is reachable only via CloudFront VPC Origin

⸻

🔁 CI/CD Pipeline (GitHub Actions)

The CI/CD pipeline is implemented using GitHub Actions.

Pipeline Steps
	1.	Authenticate to AWS using OIDC
	2.	Build Docker image
	3.	Push image to Amazon ECR
	4.	Update Kubernetes deployment using kubectl set image
(rolling update)

Pipeline Status
	•	CI/CD depends on live AWS infrastructure (EKS & ECR)
	•	Infrastructure has been intentionally destroyed to avoid cost
	•	Workflow is currently manual
	•	The workflow file is preserved as a reference implementation
	•	When infrastructure is recreated, the pipeline can be re-enabled without changes

⸻

📊 Monitoring & Observability
	•	Amazon CloudWatch Container Insights
	•	Node CPU & Memory metrics
	•	Pod & Container resource usage
	•	CPU utilization over limits

Screenshots are available in the screenshots/ directory.

⸻

🧹 Infrastructure Lifecycle
	•	Infrastructure provisioned using Terraform
	•	CI/CD operates only when infrastructure exists
	•	Infrastructure can be safely destroyed to control cost
	•	Repository remains as:
	•	Architecture reference
	•	Production-grade EKS CI/CD example
