# Variables

variable "ami" {
    default = "ami-0cfbf4f6db41068ac"
}

variable "key_name" {
    default = "imaki_Frankfurt"
}

variable "prj_dir" {
    default = "ans_prj"
}

variable "amis" {
    description = "Run the EC2 Instances with these ami"
    type = "list"
    default = ["ami-0cfbf4f6db41068ac", "ami-090f10efc254eaf55", "ami-090f10efc254eaf55"]
}

variable "client_keys" {
    description = "attach the key to the instance"
    type = "list"
    default = ["frankfurt_key1", "frankfurt_key2", "frankfurt_key2"]
}
