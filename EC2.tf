data "aws_ami" "ubuntu" {
    most_recent = true

    filter {
        name  = "name"
        values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
    }

    filter {
        name = "virtualization-type"
        values = ["hvm"]
    }

    owners = ["099720109477"]
}

resource "aws_instance" "tahaec2fore1" {
    ami = data.aws_ami.ubuntu.id
    instance_type = "t3.micro"
    tags = {
        Name = "TahasE1"
    }
    key_name = aws_key_pair.newkpfore1.name
    subnet_id = aws_subnet.tahaspublicsubnetfore1.id
    iam_instance_profile = aws_iam_instance_profile.tahaiamipfore1.id
}

resource "aws_eip" "tahaec2eipfore1" {

    tags = {
        name = "TahasEIPforE1"
    }
}

resource "aws_eip_association" "tahaeipafore1" {
  instance_id   = aws_instance.tahaec2fore1.id
  allocation_id = aws_eip.tahaec2eipfore1.id
}

resource "aws_key_pair" "tahakpfore1" {
  key_name   = "newkpfore1"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQC2y2DwBWoCpvXWq1PaixvcqvQz+l34KxN6bK+kCJD1Zl3EJj6d5A/5ySHZQTy4oZ1f0jVIlrIpQ4RzsjCm6xQtGbHhJy3S9Kf0NF6bRzg7MpGeld67aoRBGhDeC6GKO4POa4lY08iwu183wxHWyIvVkKMz8xWnTuK9VcWRy3pMirPcW2rzoFYMtQaZ9s7WGndx2jdSJKkrSPkXLKr4+VTfQAWmNyG+HejNjW4W51hsetpJcIjGiCA4+nM7Gt+ZABkN7GN6V1IsNRauxFfAPcs/+fSSkWko4WFunG9pY0oEb9nNu4pi6Z08J7i/Of/erLJnh4jTujmgpQBVYedpzGNt9+9anm3UgOQ08gQpQ0i5JfoEIw/kg6wYITAJ5CvlrfwyANOMgSl240ehrKx186wb5bknblAJ8DqLymxUiIzpO2hfdZcV8ZFbGDwXeqmRK2VXVa7SpL2gjZEP9kKPwn7nej61xlYhofh2PS5HoBLYphAsdQLez5n5FLxFzy+E8s8= taharizvi@tahas-air.lan"
}


resource "aws_iam_role" "tahaiamrfore1" {
    name = "taha-iam-role-for-e1"

    assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
POLICY
}

resource "aws_iam_policy" "tahasiampfore1" {
    name = "tahas-new-iam-policy-for-e1"

    policy = <<POLICY
{
  "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "s3:*"
            ],
            "Resource": ["arn:aws:s3:::tahass3bucketfore1/*"]
        }
    ]
}
POLICY
}

resource "aws_iam_role_policy_attachment" "tahaiamrpafore1" {
    role = aws_iam_role.tahaiamrfore1.name
    policy_arn = aws_iam_policy.tahasiampfore1.arn
}

resource "aws_iam_instance_profile" "tahaiamipfore1" {
    name = "tahas-iam-instance-profile-for-e1"
    role = aws_iam_role.tahaiamrfore1.name
}