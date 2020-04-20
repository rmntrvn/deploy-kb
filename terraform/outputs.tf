output "web_external_ip" {
  value = google_compute_instance.web.network_interface[0].access_config[0].nat_ip
}

output "cicd_external_ip" {
  value = google_compute_instance.cicd.network_interface[0].access_config[0].nat_ip
}

output "monitoring_external_ip" {
  value = google_compute_instance.monitoring.network_interface[0].access_config[0].nat_ip
}