# VPC outputs (from module)
output "vpc_id" {
  value = module.vpc.vpc_id
}

output "public_subnets" {
  value = module.vpc.public_subnets
}

output "private_subnets" {
  value = module.vpc.private_subnets
}

# EKS outputs
output "eks_cluster_name" {
  value = aws_eks_cluster.this.name
}

output "eks_cluster_endpoint" {
  value = aws_eks_cluster.this.endpoint
}

output "eks_cluster_arn" {
  value = aws_eks_cluster.this.arn
}

output "eks_cluster_ca" {
  value = aws_eks_cluster.this.certificate_authority[0].data
}
output "ecr_repository_url" {
  value = aws_ecr_repository.app.repository_url
}
