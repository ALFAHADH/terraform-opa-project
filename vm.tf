data "aws_ami" "amazon_linux_2" {
	most_recent = true
	owners      = ["amazon"]
	filter {
		name   = "name"
		values = ["amzn2-ami-hvm-*-x86_64-gp2"]
	}
}

data "aws_subnets" "default" {
	filter {
		name   = "vpc-id"
		values = [data.aws_vpc.default.id]
	}
}

resource "aws_instance" "vm" {
	ami                    = data.aws_ami.amazon_linux_2.id
	instance_type          = "t3.micro"
	subnet_id              = data.aws_subnets.default.ids[0]
	vpc_security_group_ids = [aws_security_group.sg.id]

	tags = {
		Name = "vm-instance"
	}
}