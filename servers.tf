resource "aws_instance" "ansible" {
  ami             = "${var.ami}" #Amazon Linux
  instance_type   = "t2.micro"
  key_name        = "${var.key_name}"
  monitoring      = "false"
  #security_groups = ["${aws_security_group.new_Alex_task1_SSH_HTTP_HTTPS_8080.name}"]
  vpc_security_group_ids = ["sg-0bab7953543f29ecc"] # My-firewall-HTTP-HTTPS-SSH
  root_block_device = {
    volume_size = "8"
    volume_type = "gp2"
  }

  tags {
    Name = "Ansible-master"
  }
  provisioner "file" {
    source      = "./frankfurt_key1.pem"
    destination = "~/.ssh/frankfurt_key1.pem"
  }
  provisioner "file" {
    source      = "./frankfurt_key2.pem"
    destination = "~/.ssh/frankfurt_key2.pem"
  }
  provisioner "file" {
    source      = "./ans_prj"
    destination = "~/ans_prj"
  }
  provisioner "remote-exec" {
    inline = [
      "sudo pip install ansible",
      "sudo chmod 400 ~/.ssh/frankfurt_key*"
    ]
  }
  connection {
    type        = "ssh"
    user        = "ec2-user"
    private_key = "${file("imaki_Frankfurt.pem")}"
  }
}

resource "aws_instance" "client" {
  count = 2
  ami             = "${element(var.amis, count.index)}" #Amazon Linux or Ubuntu
  instance_type   = "t2.micro"
  key_name        = "frankfurt_key${count.index + 1}"
  #key_name        = "frankfurt_key1" # without count
  monitoring      = "false"
  #security_groups = ["${aws_security_group.new_Alex_task1_SSH_HTTP_HTTPS_8080.name}"]
  vpc_security_group_ids = ["sg-0c4d0b9d26d81d4fc", "sg-0bab7953543f29ecc"]
  root_block_device = {
    volume_size = "8"
    volume_type = "gp2"
  }

  tags {
    Name = "Client-${count.index + 1}"
    #Name = "Client-1" # without count
  }
}

# resource "aws_instance" "client2" {
#   #count = 1
#   ami             = "ami-090f10efc254eaf55" #Ubuntu
#   instance_type   = "t2.micro"
#   #key_name        = "frankfurt_key${count.index + 1}"
#   key_name        = "frankfurt_key2"
#   monitoring      = "false"
#   #security_groups = ["${aws_security_group.new_Alex_task1_SSH_HTTP_HTTPS_8080.name}"]
#   vpc_security_group_ids = ["sg-0c4d0b9d26d81d4fc", "sg-0bab7953543f29ecc"]
#   root_block_device = {
#     volume_size = "8"
#     volume_type = "gp2"
#   }
#
#   tags {
#     #Name = "Client-${count.index + 1}"
#     Name = "Client-2"
#   }
# }
