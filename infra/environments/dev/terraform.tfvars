region = "eu-west-1"

vpc_cidr = "10.0.0.0/16"

azs = [
  "eu-west-1a",
  "eu-west-1b"
]

public_subnets = [
  "10.0.1.0/24",
  "10.0.2.0/24"
]

private_subnets = [
  "10.0.3.0/24",
  "10.0.4.0/24"
]

alb_dns_name = "internal-k8s-default-demoappi-40f6b7232d-1713644966.eu-west-1.elb.amazonaws.com"

alb_arn = "arn:aws:elasticloadbalancing:eu-west-1:615299736509:loadbalancer/app/k8s-default-demoappi-40f6b7232d/38dd549a02b7cf88"
