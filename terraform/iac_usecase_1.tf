resource "aws_security_group" "basic_security" {
  name = "sg_flask"
  description = "Web Security Group for HTTP"
  vpc_id = "vpc-ddwdwdwdwdwdwdwdwdw"
  ingress = [
    {
      description = "TLS from VPC"
      from_port = 80
      to_port = 80
      protocol = "tcp"
      cidr_blocks = ["99.99.99.99/32"]
      security_groups = []
      ipv6_cidr_blocks = []
      prefix_list_ids =[]
      self = true
    }
  ]

  egress = [
    {
      description = "TLS from VPC"
      from_port = 0
      to_port = 0
      protocol = "-1"
      cidr_blocks = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
      security_groups = []
      prefix_list_ids =[]
      self = true
    }
  ]

   tags = {
    Name = "rm-application"
  }
}

resource "aws_instance" "app_server" {
  ami = "ami-0c2d06d50ce30b442"
  iam_instance_profile = "EC2_DefaultRole"
  instance_type = "t2.nano"
  subnet_id = "subnet-005_ankur_public"
  associate_public_ip_address = true
  vpc_security_group_ids = [aws_security_group.basic_security.id]
    user_data = <<EOF
                  #!/bin/bash
                  echo "Starting user_data"
                  sudo su -
                  sudo yum -y install pip
                  aws s3 cp  s3://test-ankur/users/temp/ . --recursive
                  mkdir myproject
                  pip install *.whl
                  pip install *.whl -t /root/myproject
                  echo "export FLASK_APP=/root/myproject/my_application/application"  >> /etc/profile
                  source /etc/profile
                  nohup flask run --host=0.0.0.0 --port 80 > log.txt 2>&1 &
                  echo "Application started"
                  echo "End user_data"
                EOF
  tags = {
    Name = "rm-application"
  }
}

