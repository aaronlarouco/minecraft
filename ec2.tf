data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

resource "aws_instance" "minecraft" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t2.medium"

  subnet_id = var.subnet_id

  security_groups = [
    aws_security_group.minecraft.id
  ]

  tags = {
    Name = "Minecrap"
  }
}


resource "aws_security_group" "minecraft" {
  name        = "mc-ingress"
  description = "traffic"
  vpc_id      = var.vpc_id
}
