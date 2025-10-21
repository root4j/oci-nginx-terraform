# +----------------+ 
# | Output Section |
# +----------------+ 
output "public_key_openssh" {
  value     = tls_private_key.key.public_key_openssh
  sensitive = false
}

output "private_key_pem" {
  value     = tls_private_key.key.private_key_pem
  sensitive = true
}

output "public_ip" {
  value     = oci_core_instance.nginx.public_ip
}