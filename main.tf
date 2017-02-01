
                                   resource "aws_vpc" "terraform" {
     cidr_block = "10.100.0.0/16"
}

resource "aws_subnet" "public_1a" {
    vpc_id = "${aws_vpc.terraform.id}"
    cidr_block = "10.100.0.0/24"
    map_public_ip_on_launch = "true"
    availability_zone = "${var.availability_zone}"

    tags {
        Name = "Public 1"
    }
}

resource "aws_internet_gateway" "igw" {
    vpc_id = "${aws_vpc.terraform.id}"

    tags {
        Name = "Terraform igw"
    }
}
resource "aws_security_group" "Terraform_SG" {
  name = "Terraform_SG"
  description = "SG allocation"
  vpc_id = "${aws_vpc.terraform.id}"

  ingress {
      from_port = 22
      to_port = 22
      protocol = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
  }
 ingress {
      from_port = 80
      to_port = 80
      protocol = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
  }
egress {
      from_port = 0
      to_port = 0
      protocol = "-1"
      cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "web01" {
    ami = "${var.aws_ami}"
    instance_type = "${var.instance_type}"
    subnet_id = "${aws_subnet.public_1a.id}"
    vpc_security_group_ids = ["${aws_security_group.Terraform_SG.id}"]
    key_name = "${var.key_name}"
    tags {
        Name = "terraform_launch"
    }

}
