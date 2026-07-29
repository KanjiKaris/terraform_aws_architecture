# Resource replaced
# resource "aws_instance" "example" {
#     ami = "ami-06067086cf86c58e6"
#     instance_type = "t2.micro"
#    vpc_security_group_ids = [aws_security_group.instance.id]

#     user_data = <<-EOF
#               #!/bin/bash
#               echo "Hello, World!" > index.html
#               nohup busybox httpd -f -p ${var.server_port} &
#               EOF

#     user_data_replace_on_change = true

#     tags = { 
#         Name = "terraform-example"
#     }
# }

resource "aws_security_group" "instance" {
  name        = "${var.cluster_name}-instance-sg"
  description = "Security group for the Terraform example instance"

  ingress {
    from_port   = var.server_port
    to_port     = var.server_port
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

data "aws_ami" "amazon_linux_2" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}

resource "aws_launch_template" "example" {
  image_id               = data.aws_ami.amazon_linux_2.id
  instance_type          = var.instance_type
  vpc_security_group_ids = [aws_security_group.instance.id]

  user_data = base64encode(templatefile("${path.module}/user-data.sh", {
    db_address  = data.terraform_remote_state.mysql.outputs.address
    db_port     = data.terraform_remote_state.mysql.outputs.port
    server_port = var.server_port
  }))

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "example_asg" {
  launch_template {
    id      = aws_launch_template.example.id
    version = "$Latest"
  }
  vpc_zone_identifier = var.subnet_ids #updated

  target_group_arns = var.target_group_arns #updated
  health_check_type = "ELB"

  min_size = var.min_size
  max_size = var.max_size

  tag {
    key                 = "Name"
    value               = var.cluster_name
    propagate_at_launch = true
  }
}


data "terraform_remote_state" "mysql" {
  backend = "s3"

  config = {
    bucket = var.db_remote_state_bucket
    key    = var.db_remote_state_key
    region = "us-east-1"
  }
}