resource "oci_core_network_security_group" "simple_nsg" {
  #Required
  compartment_id = var.network_compartment_ocid
  vcn_id         = local.use_existing_network ? var.vcn_id : oci_core_vcn.simple.0.id

  #Optional
  display_name = var.nsg_display_name

  freeform_tags = map(var.tag_key_name, var.tag_value)
}

# Allow Egress traffic to all networks
resource "oci_core_network_security_group_security_rule" "simple_rule_egress" {
  network_security_group_id = oci_core_network_security_group.simple_nsg.id

  direction   = "EGRESS"
  protocol    = "all"
  destination = "0.0.0.0/0"

}

# Allow SSH (TCP port 22) Ingress traffic from any network
resource "oci_core_network_security_group_security_rule" "simple_rule_ssh_ingress" {
  network_security_group_id = oci_core_network_security_group.simple_nsg.id
  protocol                  = "6"
  direction                 = "INGRESS"
  source                    = "0.0.0.0/0"
  stateless                 = false

  tcp_options {
    destination_port_range {
      min = 22
      max = 22
    }
  }
}

# Allow HTTPS (TCP port 443) Ingress traffic from any network
resource "oci_core_network_security_group_security_rule" "simple_rule_https_ingress" {
  network_security_group_id = oci_core_network_security_group.simple_nsg.id
  protocol                  = "6"
  direction                 = "INGRESS"
  source                    = "0.0.0.0/0"
  stateless                 = false

  tcp_options {
    destination_port_range {
      min = 443
      max = 443
    }
  }
}

# Allow HTTP (TCP port 80) Ingress traffic from any network
resource "oci_core_network_security_group_security_rule" "simple_rule_http_ingress" {
  network_security_group_id = oci_core_network_security_group.simple_nsg.id
  protocol                  = "6"
  direction                 = "INGRESS"
  source                    = "0.0.0.0/0"
  stateless                 = false

  tcp_options {
    destination_port_range {
      min = 80
      max = 80
    }
  }
}

# Allow ANY Ingress traffic from within simple vcn
resource "oci_core_network_security_group_security_rule" "simple_rule_all_simple_vcn_ingress" {
  network_security_group_id = oci_core_network_security_group.simple_nsg.id
  protocol                  = "all"
  direction                 = "INGRESS"
  source                    = var.vcn_cidr_block
  stateless                 = false
}