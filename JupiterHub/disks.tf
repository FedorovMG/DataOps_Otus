resource "yandex_compute_disk" "disk_jupiter" {
  type = "network-hdd"
  size = "20"
  image_id = "fd8cqj9qiedndmmi3vq6"
}
