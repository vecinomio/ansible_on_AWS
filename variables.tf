# Variables

variable "ami" {
    default = "ami-0cfbf4f6db41068ac"
}

variable "key_name" {
    default = "imaki_Frankfurt"
}

variable "amis" {
    description = "Run the EC2 Instances with these ami"
    type = "list"
    default = ["ami-0cfbf4f6db41068ac", "ami-090f10efc254eaf55"]
}
