# +-----------------+
# | Local Variables |
# +-----------------+
locals {
    all_images = data.oci_core_images.ubuntu_images.images
}
# +-----------+
# | Instances |
# +-----------+
resource "oci_core_instance" "nginx" {
    availability_domain = data.oci_identity_availability_domains.rad.availability_domains.0.name
    compartment_id      = var.compartment_ocid
    display_name        = "VM_nginx"
    fault_domain        = "FAULT-DOMAIN-1"

    shape               = var.shape
    shape_config {
        memory_in_gbs = var.shape_memory
        ocpus         = var.shape_cpu
    }

    metadata = {
        ssh_authorized_keys = tls_private_key.key.public_key_openssh
    }

    create_vnic_details {
        subnet_id                 = oci_core_subnet.public_subnet.id
        display_name              = "primaryvnic"
        assign_public_ip          = true
        assign_private_dns_record = true
        hostname_label            = "nginx"
    }

    source_details {
        source_type             = "image"
        source_id               = local.all_images.0.id
        boot_volume_size_in_gbs = var.shape_disk
    }
}
# +------------------+
# | Remote Execution |
# +------------------+
resource "null_resource" "remote_exec_nginx" {
    depends_on = [oci_core_instance.nginx]

    provisioner "remote-exec" {
        connection {
            agent       = false
            timeout     = "10m"
            host        = oci_core_instance.nginx.public_ip
            user        = "ubuntu"
            private_key = tls_private_key.key.private_key_pem
        }

        inline = [
            "sudo apt-get install -y nginx unzip ufw",
            "wget https://github.com/startbootstrap/startbootstrap-resume/archive/gh-pages.zip",
            "sudo unzip gh-pages.zip",
            "sudo mv startbootstrap-resume-gh-pages/* /var/www/html/",
            "echo \"y\" | sudo ufw enable",
            "sudo ufw allow 22/tcp",
            "sudo ufw allow 80/tcp",
            "sudo systemctl enable nginx",
            "sudo systemctl start nginx",
            "sudo reboot",
        ]
    }
}