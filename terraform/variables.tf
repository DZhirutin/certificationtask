variable vpc_cidr_block {
    default = "10.0.0.0/16"
}

variable subnet_1_cidr_block {
    default = "10.0.10.0/24"
}

variable avail_zone {
    default = "eu-west-3b"
}

variable env_prefix {
    default = "general"
}

variable env_prefix_1 {
    default = "build"
}

variable env_prefix_2 {
    default = "prod"
}

variable my_ip {
    default = "178.176.77.199/32"
}

variable jenkins_ip {
    default = "35.225.175.226/32"
}
variable instance_type {
    default = "t2.micro"
}

variable region {
    default = "eu-west-3"
}