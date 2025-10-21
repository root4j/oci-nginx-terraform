# +--------------+ 
# | Data Sources |
# +--------------+
data "oci_identity_availability_domains" "rad" {
    compartment_id = var.compartment_ocid
}

data "oci_core_images" "ubuntu_images" {
    compartment_id           = var.compartment_ocid
    shape                    = var.shape
    operating_system         = "Canonical Ubuntu"
    operating_system_version = var.ubuntu_version
    sort_by                  = "TIMECREATED"
    sort_order               = "DESC"
}