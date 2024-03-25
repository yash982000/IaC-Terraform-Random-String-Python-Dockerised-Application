provider "aws" {
  access_key = "#######################"
  secret_key = "#######################"
  region = "ap-south-1"  # Set your desired region
}

variable "regions" {
  type    = list(string)
  default = ["ap-south-1"]  # Add more regions as needed
}

# Create an encrypted EBS volume
resource "aws_kms_key" "iac-server-key" {
  description             = "KMS key for encrypting EBS volume"
  deletion_window_in_days = 10
  multi_region = true
  tags = {
      Environment = "PROD"
      Name        = "iac-ebs-kms-key"
    }
}

resource "aws_ebs_volume" "iac-ebs-volume" {
  availability_zone = "ap-south-1a"  # Set your desired availability zone
  size             = 32
  encrypted        = true
  # kms_key_id       = aws_kms_key.example.id
}

# Create an EC2 instance with a public IP
resource "aws_instance" "test-iac-tf" {
  ami             = data.aws_ami.latest[count.index].id
  instance_type = "t2.micro"
  count = length(var.regions)
  key_name      = "test-iac"  # Set your SSH key pair

  tags = {
    Name = "ec2-test-iac-instance-tf"
  }
}

# Data source to fetch dynamic AMI
data "aws_ami" "latest" {
  count = length(var.regions)
  most_recent = true

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]  # Modify to match your AMI naming convention
  }

  owners = ["amazon"]
  
}
