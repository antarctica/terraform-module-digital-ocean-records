# Module variables

variable "domain" {
    default = "do.net.nerc-bas.ac.uk"
    descrtiption = "The domain within Digital Ocean DNS records should be created within"
}
variable "sub_domains" {
    default = ""
    description = "Any additional sub-domains to be added before the domain variable"
}
variable "public_interface_label" {
    default = "ext"
    description = "The term used for describing the public interface for a machine within DNS"
}
variable "private_interface_label" {
    default = "int"
    description = "The term used for describing the private interface for a machine within DNS"
}
variable "hostname" {
    description = "Identifier for a machine within DNS, usually its hostname"
}
variable "machine_interface_ipv4_public" {
    description = "The public IPv4 address of a machine, i.e. the IP used for connecting to the machine from the outside world"
}
variable "machine_interface_ipv4_private" {
    description = "The private IPv4 address of a machine, i.e. the IP used for inter-machine communications within a data-centre"
}

# Module 'actions' (for lack of a better word)
resource "digitalocean_record" "public_interface_record" {
    domain = "${var.domain}"
    type = "A"
    name = "${var.hostname}.${var.public_interface_label}${var.sub_domains}"
    value = "${var.machine_interface_ipv4_public}"
}
resource "digitalocean_record" "private_interface_record" {
    domain = "${var.domain}"
    type = "A"
    name = "${var.hostname}.${var.private_interface_label}${var.sub_domains}"
    value = "${var.machine_interface_ipv4_private}"
}
resource "digitalocean_record" "default_interface_record" {
    domain = "${var.domain}"
    type = "CNAME"
    name = "${var.hostname}${var.sub_domains}"
    value = "${digitalocean_record.public_interface_record.name}"
}

# Module outputs
# (None)
