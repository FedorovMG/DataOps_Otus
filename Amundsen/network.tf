resource "yandex_vpc_network" "data_net" {
  name = "data_net"
}

resource "yandex_vpc_subnet" "data_subnet" {
  name = "MySubnet"
  zone = var.zone
  network_id = yandex_vpc_network.data_net.id
  v4_cidr_blocks = [ "10.0.1.0/24" ]
}
