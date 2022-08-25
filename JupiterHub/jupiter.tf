resource "yandex_compute_instance" "jupiter" {
  name = "jupiter-server"
  platform_id = "standard-v1"
  resources {
    cores = 2
    memory = 4
  }
  
  boot_disk {
    disk_id = yandex_compute_disk.disk_jupiter.id
  }
  
  network_interface {
    subnet_id = yandex_vpc_subnet.data_subnet.id
    nat = true
  }
  
  metadata = {
    
    ssh-keys = "ubuntu:${file("~/.ssh/id_rsa.pub")}" 
  }
}
