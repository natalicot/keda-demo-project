provider "aws" {
  region  = var.region
  profile = "natali-aws-testing"
}

module "aws_key_pair" {
  source              = "cloudposse/key-pair/aws"
  version             = "0.18.3"
  namespace           = module.this.namespace
  stage               = module.this.stage
  name                = module.this.name
  attributes          = module.this.attributes
  ssh_public_key_path = var.ssh_public_key_path
  generate_ssh_key    = true
}

module "vpc" {
  source  = "cloudposse/vpc/aws"
  version = "1.1.1"

  ipv4_primary_cidr_block  = "172.16.0.0/16"
  assign_generated_ipv6_cidr_block = false

  context = module.this.context
}

module "subnets" {
  source  = "cloudposse/dynamic-subnets/aws"
  version = "2.0.3"

  availability_zones   = var.availability_zones
  vpc_id               = module.vpc.vpc_id
  igw_id               = [module.vpc.igw_id]
  ipv4_cidr_block      = [module.vpc.vpc_cidr_block]
  nat_gateway_enabled  = false
  nat_instance_enabled = false

  context = module.this.context
}

module "instance_profile_label" {
  source  = "cloudposse/label/null"
  version = "0.22.1"

  attributes = distinct(compact(concat(module.this.attributes, ["profile"])))

  context = module.this.context
}

data "aws_iam_policy_document" "test" {
  statement {
    effect = "Allow"

    actions = [
      "sts:AssumeRole"
    ]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "test" {
  name               = module.instance_profile_label.id
  assume_role_policy = data.aws_iam_policy_document.test.json
  tags               = module.instance_profile_label.tags
}

# https://github.com/hashicorp/terraform-guides/tree/master/infrastructure-as-code/terraform-0.13-examples/module-depends-on
resource "aws_iam_instance_profile" "test" {
  name = module.instance_profile_label.id
  role = aws_iam_role.test.name
}

# Render a part using a `template_file`
data "template_file" "script" {
  template = "${file("${path.module}/cloud-init.yml")}"
}

data "template_cloudinit_config" "config" {
  gzip          = true
  base64_encode = true

  # Main cloud-config configuration file.
  part {
    filename     = "init.cfg"
    content_type = "text/cloud-config"
    content      = "${data.template_file.script.rendered}"
  }
}

module "ec2_instance" {
  source  = "cloudposse/ec2-instance/aws"
  version = "0.43.0"

  ssh_key_pair                = module.aws_key_pair.key_name
  vpc_id                      = module.vpc.vpc_id
  subnet                      = module.subnets.public_subnet_ids[0]
  assign_eip_address          = var.assign_eip_address
  associate_public_ip_address = var.associate_public_ip_address
  instance_type               = var.instance_type
  security_group_rules        = var.security_group_rules
  instance_profile            = aws_iam_instance_profile.test.name
  user_data_base64            = "${data.template_cloudinit_config.config.rendered}"

  context = module.this.context
}