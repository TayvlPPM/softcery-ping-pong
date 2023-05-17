resource "tls_private_key" "my_key_pair" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "my_key_pair" {
  key_name   = "ec2-client-pair"
  public_key = tls_private_key.my_key_pair.public_key_openssh
}

resource "local_file" "my_key_file" {
  content  = tls_private_key.my_key_pair.private_key_pem
  filename = "/key.pem"
}

resource "aws_instance" "ec2_instance" {
  ami           = "ami-05fc4b58217803cb7"
  instance_type = "t2.micro"
  key_name      = aws_key_pair.my_key_pair.key_name
  subnet_id     = aws_subnet.public[0].id
  vpc_security_group_ids = [aws_security_group.vpn-sg.id] 

  user_data = <<-EOF
              #!/bin/bash

              curl -O https://raw.githubusercontent.com/angristan/openvpn-install/master/openvpn-install.sh
              chmod +x openvpn-install.sh
              sudo AUTO_INSTALL=y ./openvpn-install.sh
              EOF

 
  tags = {
    Name        = "${var.app_name}-ec2-instance"
    Environment = var.app_environment
  }
}

output "vpn_public_ip" {
  value = aws_instance.ec2_instance.public_ip
}