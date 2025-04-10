resource "tls_private_key" "this_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "this_key" {
  key_name   = "this_key"
  public_key = tls_private_key.this_key.public_key_openssh
}

resource "aws_instance" "this_instance" {
  ami                  = data.aws_ami.amazon_linux_2.id
  instance_type        = "t3.micro"
  subnet_id            = aws_subnet.this_subnet[0].id
  key_name             = aws_key_pair.this_key.key_name
  security_groups      = [aws_security_group.this_sg.id]
  iam_instance_profile = aws_iam_instance_profile.this_ec2_profile.name
}

resource "aws_ebs_volume" "this_ebs_volume" {
  availability_zone = "us-east-1d"
  size              = 10
  type              = "gp2"
}

resource "aws_volume_attachment" "this_ebs_attach" {
  device_name = "/dev/xvdf"
  instance_id = aws_instance.this_instance.id
  volume_id   = aws_ebs_volume.this_ebs_volume.id
}

resource "aws_iam_instance_profile" "this_ec2_profile" {
  name = "ec2_profile"
  role = aws_iam_role.this_role.name
}

resource "null_resource" "remote_exec" {
  triggers = {
    ec2_instance_id = aws_instance.this_instance.id
  }

  connection {
    type        = "ssh"
    user        = "ec2-user"
    private_key = tls_private_key.this_key.private_key_openssh
    host        = aws_instance.this_instance.public_ip
  }

  provisioner "remote-exec" {
    inline = [
      "cd /tmp",
      "sudo amazon-linux-extras install nginx1 -y",
      "sudo systemctl enable nginx",
      "sudo systemctl start nginx",
      "rm -rf /tmp/awscliv2.zip /tmp/aws && curl https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip -o awscliv2.zip",
      "unzip -qq awscliv2.zip",
      "sudo ./aws/install --update",
      "aws s3 cp s3://${aws_s3_bucket.this.id}/index.html ./ 2>/dev/null",
      "sudo mv index.html /usr/share/nginx/html/ -f"
    ]
  }
}
