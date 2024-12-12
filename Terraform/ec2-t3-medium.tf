
# Security Group for SSH access
resource "aws_security_group" "ssh_sg" {
  name        = "ssh-access-sg"
  description = "Allow SSH access"
  
  # Allow incoming traffic on port 22 (SSH) from your personal PC's IP address
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["111.88.221.177/32"]  # Replace with your actual IP address
  }

  # Allow all outbound traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"  # All traffic
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# EC2 Key Pair
resource "aws_key_pair" "key_pair" {
  key_name   = "my-ssh-key"  # Replace with your desired key name
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDD/7uPJnZ6j4tN8HZuZhpnH4nJWBGOfWJCSV3Gp9/w8SqbyBEEACfiWIWEFDkfRgYGOnRhXNpLsk/Bf1Y+NmhcIhh0mG79H5bunbV+FHGoOE978bpSXsbuWBjiFgkGBNHsKWc8lAp+0hvHzsXNAtnS8KDaJN/FZifgFfnGajLnZNnMGSeGNRGQ0ownyrtFc5jqlkStABet4YNoj/Hmy9MecNwoTo3Tc2p4/jueSeINzubA7rZ39fpRtKEb5GC6UhN9F88Ti96OALecNLoyi+oZrOs4kyFptQwZlzKoFT2MPj2c2lsbUCIU8eC+PMIB+GB2TXD+l6+67m8AJQXE0Ybk7xRNG9bdEif3Zva2HKHDHUkuKazoIVSGPD5VieNGXBcUreNZ1NCO/wCM3QtgZfWP2BR2ibx5K+zyeh08IbXQXPJ90+MA9NbMLRuqka6CJFxDIcfIA3Gmnuq9CIAZVPcEScopmapMgBzVF0VNxrRaq1kpQ1JGOK235lwCYde/yGxDMe97LiRBc4Ao69DsofGU+pFVewVHzm6IT2q0fGK97Gsx8M7SmIPK6la9ATMTzEKdJ0afdA3Vr62LiUbEsy8tO0GDX1DaxJuUqEnxaCkeIIz1jr6GyBztsMOveFUnTConJUC1zZWd502ut2+vp56rX+0c+l0CPSYjDuPsblZAQw== mbadar-ec2t3.medium"
}

# Launch EC2 Instance (t3.medium)
resource "aws_instance" "example" {
  ami           = "ami-0a91cd140a1fc148a"  # Amazon Linux 2 AMI ID for us-west-2, you can check the latest AMI in AWS
  instance_type = "t3.medium"
  key_name      = aws_key_pair.key_pair.key_name
  security_groups = [aws_security_group.ssh_sg.name]
  
  # Instance metadata
  tags = {
    Name = "MyEC2Instance"
  }

  # Enable monitoring (optional, but useful for production instances)
  monitoring = true

  # Enable SSH access (optional)
  user_data = <<-EOF
              #!/bin/bash
              sudo yum update -y
              EOF
}

# Output the public IP of the EC2 instance
output "public_ip" {
  value = aws_instance.example.public_ip
}
