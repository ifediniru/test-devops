
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.17.0"
    }
  }
}

provider "aws" {
  region = "us-east-2"
}

resource "aws_instance" "test" {
  ami = "ami-01103fb68b3569475"
  instance_type = "t2.micro"
  tags = {
    Name = "terraform_test"
  }
  key_name = "tera_test"
  security_groups = ["jenkins"]

  ebs_block_device {
     volume_size = 20
     volume_type = "standard"
     device_name = "/dev/xvdb"
     tags = {
        Filesystem = "/data"
     }
  }
}
resource "aws_ebs_volume" "vol" {
  availability_zone = aws_instance.test.availability_zone
  size = 1
}

resource "aws_volume_attachment" "sample" {
  device_name = "/dev/xvdc"
  volume_id =  aws_ebs_volume.vol.id
  instance_id = aws_instance.test.id
  }

output "public_ip" {
  value = aws_instance.test.public_ip
}