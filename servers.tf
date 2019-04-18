# =================== ANSIBLE-MASTER =================== #
resource "aws_instance" "ansible" {
  ami             = "${var.ami}" #Amazon Linux
  instance_type   = "t2.micro"
  key_name        = "${var.key_name}"
  monitoring      = "false"
  vpc_security_group_ids = ["sg-0bab7953543f29ecc"] # My-firewall-HTTP-HTTPS-SSH
  root_block_device = {
    volume_size = "8"
    volume_type = "gp2"
  }

  tags {
    Name = "Ansible-master"
  }
  # Here we need to rewrite inventory file according to the new clients private_ip
  provisioner "local-exec" {
    command =<<EOF
      echo [RTH] > ./${var.prj_dir}/hosts.txt
      echo client-1 ansible_host=${aws_instance.client.0.private_ip} >> ./${var.prj_dir}/hosts.txt
      echo [DEB] >> ./${var.prj_dir}/hosts.txt
      echo client-2 ansible_host=${aws_instance.client.1.private_ip} >> ./${var.prj_dir}/hosts.txt
      echo client-3 ansible_host=${aws_instance.client.2.private_ip} >> ./${var.prj_dir}/hosts.txt
EOF
  }
  provisioner "file" {
    source      = "./secret/"
    destination = "~/.ssh/"
  }
  provisioner "file" {
    source      = "./${var.prj_dir}"
    destination = "~/${var.prj_dir}"
  }
  provisioner "remote-exec" {
    inline = [
      "sudo pip install ansible",
      "sudo chmod 400 ~/.ssh/frankfurt_key*",
      "cd ans_prj && ansible DEB --become -m raw -a 'apt install -y python-minimal python-simplejson'"
    ]
  }
  connection {
    type        = "ssh"
    user        = "ec2-user"
    private_key = "${file("imaki_Frankfurt.pem")}"
  }
}

# ================== CLIENTS ==================== #
resource "aws_instance" "client" {
  count = 3 # number of clients
  ami             = "${element(var.amis, count.index)}" #Amazon Linux or Ubuntu
  instance_type   = "t2.micro"
  key_name        = "${element(var.client_keys, count.index)}" #Attach key
  monitoring      = "false"
  vpc_security_group_ids = ["sg-0c4d0b9d26d81d4fc", "sg-0bab7953543f29ecc"]
  root_block_device = {
    volume_size = "8"
    volume_type = "gp2"
  }

  tags {
    Name = "Client-${count.index + 1}"
  }
}
