resource "aws_db_subnet_group" "main" {
  name       = var.subnet_group_name
  subnet_ids = tolist(data.terraform_remote_state.vpc.outputs.private_subnet_ids)
}

resource "aws_security_group" "db_sg" {
  name        = "db_sg"
  description = "Security group for database instances"
  vpc_id      = data.terraform_remote_state.vpc.outputs.vpc_id

  ingress {
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [data.terraform_remote_state.ec2.outputs.ec2_sg_id-public]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "SWE7302 DB Security Group"
  }

}

resource "aws_db_instance" "main" {
  allocated_storage      = var.allocated_storage
  engine                 = var.engine
  engine_version         = var.engine_version
  instance_class         = var.instance_class
  identifier             = var.DB-name
  storage_type           = var.storage_type
  db_name                = var.DB-name
  username               = var.username
  password               = var.password
  db_subnet_group_name   = aws_db_subnet_group.main.name
  vpc_security_group_ids = [aws_security_group.db_sg.id]
  skip_final_snapshot    = true
  publicly_accessible    = false
  multi_az               = false

  lifecycle {
    ignore_changes = [
      availability_zone,
      db_name
    ]
  }
}