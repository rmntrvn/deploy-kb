terraform {
  # Версия terraform
  required_version = "0.12.18"
}

provider "google" {
  # Версия провайдера
  version = "2.15"

  # ID проекта
  project = var.project
  region = var.region
}

resource "google_compute_instance" "web" {
  name         = "web"
  machine_type = "g1-small"
  zone         = "europe-west1-b"

  # определение загрузочного диска
  boot_disk {
    initialize_params {
      image = var.disk_image
    }
  }

  metadata = {
    ssh-keys = "rmntrvn:${file(var.public_key_path)}"
  }

  tags = ["web"]

  # определение сетевого интерфейса
  network_interface {
    # сеть, к которой присоединить данный интерфейс
    network = "default"

    # использовать ephemeral IP для доступа из Интернет
    access_config {}
  }

  connection {
    type        = "ssh"
    user        = "rmntrvn"
    agent       = false
    private_key = file(var.private_key_path)
  }

#  provisioner "file" {
#    source      = "files/puma.service"
#    destination = "/tmp/puma.service"
#  }

#  provisioner "remote-exec" {
#    script = "files/deploy.sh"
#  }
}

resource "google_compute_instance" "cicd" {
  name         = "cicd"
  machine_type = "n1-standard-1"
  zone         = "europe-west1-b"

  # определение загрузочного диска
  boot_disk {
    initialize_params {
      image = var.disk_image
    }
  }

  metadata = {
    ssh-keys = "rmntrvn:${file(var.public_key_path)}"
  }

  tags = ["cicd"]

  # определение сетевого интерфейса
  network_interface {
    # сеть, к которой присоединить данный интерфейс
    network = "default"

    # использовать ephemeral IP для доступа из Интернет
    access_config {}
  }

  connection {
    type        = "ssh"
    user        = "rmntrvn"
    agent       = false
    private_key = file(var.private_key_path)
  }

#  provisioner "file" {
#    source      = "files/puma.service"
#    destination = "/tmp/puma.service"
#  }

#  provisioner "remote-exec" {
#    script = "files/deploy.sh"
#  }
}

resource "google_compute_instance" "monitoring" {
  name         = "monitoring"
  machine_type = "g1-small"
  zone         = "europe-west1-b"

  # определение загрузочного диска
  boot_disk {
    initialize_params {
      image = var.disk_image
    }
  }

  metadata = {
    ssh-keys = "rmntrvn:${file(var.public_key_path)}"
  }

  tags = ["monitoring"]

  # определение сетевого интерфейса
  network_interface {
    # сеть, к которой присоединить данный интерфейс
    network = "default"

    # использовать ephemeral IP для доступа из Интернет
    access_config {}
  }

  connection {
    type        = "ssh"
    user        = "rmntrvn"
    agent       = false
    private_key = file(var.private_key_path)
  }

#  provisioner "file" {
#    source      = "files/puma.service"
#    destination = "/tmp/puma.service"
#  }

#  provisioner "remote-exec" {
#    script = "files/deploy.sh"
#  }
}

resource "google_compute_firewall" "firewall_web" {
  name = "allow-web-default"
  # Название сети, в которой действует правило
  network = "default"
  # Какой доступ разрешить
  allow {
    protocol = "tcp"
    ports = ["80"]
  }
  # Каким адресам разрешаем доступ
  source_ranges = ["0.0.0.0/0"]
  # Правило применимо для инстансов с перечисленными тэгами
  target_tags = ["web"]
}

resource "google_compute_firewall" "firewall_cicd" {
  name = "allow-cicd-default"
  # Название сети, в которой действует правило
  network = "default"
  # Какой доступ разрешить
  allow {
    protocol = "tcp"
    ports = ["80","443","2222"]
  }

  provisioner "local-exec" {
      command = <<EOT
        echo "EXT_IP_VM_CICD=${google_compute_instance.cicd.network_interface.0.access_config.0.nat_ip}" > ../ansible/files/cicd/.env
      EOT
  }

  # Каким адресам разрешаем доступ
  source_ranges = ["0.0.0.0/0"]
  # Правило применимо для инстансов с перечисленными тэгами
  target_tags = ["cicd"]
}

resource "google_compute_firewall" "firewall_monitoring" {
  name = "allow-monitoring-default"
  # Название сети, в которой действует правило
  network = "default"
  # Какой доступ разрешить
  allow {
    protocol = "tcp"
    ports = ["9090","9100","9093","8080","3000"]
  }
  # Каким адресам разрешаем доступ
  source_ranges = ["0.0.0.0/0"]
  # Правило применимо для инстансов с перечисленными тэгами
  target_tags = ["monitoring"]
}