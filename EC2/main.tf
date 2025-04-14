#Create Key pair
resource "aws_key_pair" "main" {
  key_name   = var.key_name
  public_key = file("/home/hardarmyyy/swe-7302.pub")
}

#Create Instances
resource "aws_instance" "ec2-public" {
  count                       = var.pub_ec2_count
  ami                         = var.ami
  instance_type               = element(var.instance_type, count.index)
  key_name                    = aws_key_pair.main.key_name
  vpc_security_group_ids      = [aws_security_group.sg-public[count.index].id]
  subnet_id                   = data.terraform_remote_state.vpc.outputs.public_subnet_ids[count.index < 1 ? 0 : 1]
  associate_public_ip_address = true
  user_data                   = count.index == 0 ? file("web-server.sh") : file("deployment-server.sh")
  user_data_replace_on_change = true
  tags = {
    Name = element(var.server_name, count.index)
  }
}

#Create security groups
resource "aws_security_group" "sg-public" {
  count       = var.pub_ec2_count
  name        = var.security_group_name[count.index]
  description = "Security group for ec2 instances"
  vpc_id      = data.terraform_remote_state.vpc.outputs.vpc_id

  dynamic "ingress" {
    for_each = var.ingress_rules[count.index]
    content {
      description = ingress.value["description"]
      from_port   = ingress.value["from_port"]
      to_port     = ingress.value["to_port"]
      protocol    = ingress.value["protocol"]
      cidr_blocks = ingress.value["cidr_blocks"]
    }
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = var.grp1_ec2_egress_cidr_blocks
  }

  tags = {
    Name = "SWE7302 EC2 Security Group"
  }
}

#create elastic IP
resource "aws_eip" "ec2_eip" {
  domain = "vpc"
  depends_on = [aws_instance.ec2-public]
}

#associate elastic IP with instance
resource "aws_eip_association" "ec2_eip_association" {
  instance_id   = aws_instance.ec2-public[0].id
  allocation_id = aws_eip.ec2_eip.id
  depends_on = [aws_instance.ec2-public]
}