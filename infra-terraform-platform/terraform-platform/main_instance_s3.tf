provider "aws"{
    region="us-east-1"
}

# for security group

resource "aws_security_group" "terraform-test" {
  name        = "terraform-test"
  description = "Allow TLS inbound traffic"
 

  ingress {
    description      = "TLS from VPC"
    from_port        = 0
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      =  ["0.0.0.0/0"]
    
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    
  }

  tags = {
    Name = "terraform-test"
  }
}

# for instance
resource "aws_instance" "terraform-instance"{
    ami=var.my_ami_id
    instance_type=var.my_instance_type
  
     iam_instance_profile = aws_iam_instance_profile.test_profile.id
    # vpc_id= "vpc-0f1a4468"
    key_name = data.aws_key_pair.example.key_name
    tags={
        Name="terraformEc2ubuntu"

    }
}
   


# iam policy
resource "aws_iam_policy" "policy" {
  name        = "terraform-policy"
 description = "My test policy"


  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "ec2:AmazonS3FullAccess*",
        ]
        Effect   = "Allow"
        Resource = "*"
      },
    ]
  })
}
# iam role role

 resource "aws_iam_role" "terraform-role" {
  name = "terraform-role"

  assume_role_policy = <<EOF
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
EOF
}
# attaching policy
resource "aws_iam_policy_attachment" "test-attach" {
  name       = "test-attachment"
  roles      = [aws_iam_role.terraform-role.name]
  policy_arn = aws_iam_policy.policy.arn
}
# instance profile
resource "aws_iam_instance_profile" "test_profile" {
  name = "test_profile"
  role = aws_iam_role.terraform-role.name
}


# s3 bucket creation with lookup function

resource "aws_s3_bucket" "bucket" {
    bucket=lookup(var.my_bucket_name,"bucket1")
}

resource "aws_s3_bucket" "bucket1" {
    bucket=lookup(var.my_bucket_name,"bucket2")
}


# s3 bucket uploading
# resource "aws_s3_bucket_object" "object" {
#   bucket = "terraform-6042022"
# }


# key pair for server login

data "aws_key_pair" "example" {
  key_name = "452022"
 }

