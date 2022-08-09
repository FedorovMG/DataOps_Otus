terraform{
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }
}

provider "yandex" {
    token     = "MyToken"
    cloud_id  = "MyCloudId"
    folder_id = "MyFolderId"
}

resource "yandex_vpc_network" "cluster-net" {
  name = "cluster-net"
}

resource "yandex_vpc_subnetwork" "cluster-subnet-a" {
  name           = "cluster-subnet-ru-central1-a"
  zone           = "ru-central1-a"
  network_id     = yandex_vpc_network.cluster-net.id
  v4_cidr_blocks = ["172.16.1.0/24"]
}

resource "yandex_vpc_subnet" "cluster-subnet-b" {
  name           = "cluster-subnet-ru-central1-b"
  zone           = "ru-central1-b"
  network_id     = yandex_vpc_network.cluster-net.id
  v4_cidr_blocks = ["172.16.2.0/24"]
}

resource "yandex_vpc_subnet" "cluster-subnet-c" {
  name           = "cluster-subnet-ru-central1-c"
  zone           = "ru-central1-c"
  network_id     = yandex_vpc_network.cluster-net.id
  v4_cidr_blocks = ["172.16.3.0/24"]
}

resource "yandex_vpc_default_security_group" "cluster-sg" {
  network_id = yandex_vpc_network.cluster-net.id

  ingress {
    description    = "HTTPS (secure)"
    port           = 8443
    protocol       = "TCP"
    v4_cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description    = "clickhouse-client (secure)"
    port           = 9440
    protocol       = "TCP"
    v4_cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description    = "Allow all egress cluster traffic"
    protocol       = "TCP"
    v4_cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "yandex_mdb_clickhouse_cluster" "mych" {
  name               = "mych"
  environment        = "PRESTABLE"
  network_id         = yandex_vpc_network.cluster-net.id
  security_group_ids = [yandex_vpc_default_security_group.cluster-sg.id]

  clickhouse {
    resources {
      resource_preset_id = "s2.micro"
      disk_type_id       = "network-ssd"
      disk_size          = 32
    }
  }

  host {
    type      = "CLICKHOUSE"
    zone      = "ru-central1-a"
    subnet_id = yandex_vpc_subnet.cluster-subnet-a.id
  }

  host {
    type      = "CLICKHOUSE"
    zone      = "ru-central1-b"
    subnet_id = yandex_vpc_subnet.cluster-subnet-b.id
  }

  host {
    type      = "CLICKHOUSE"
    zone      = "ru-central1-c"
    subnet_id = yandex_vpc_subnet.cluster-subnet-c.id
  }

  zookeeper {
    resources {
      resource_preset_id = "b2.medium"
      disk_type_id       = "network-ssd"
      disk_size          = 10
    }
  }

  host {
    type      = "ZOOKEEPER"
    zone      = "ru-central1-a"
    subnet_id = yandex_vpc_subnet.cluster-subnet-a.id
  }

  host {
    type      = "ZOOKEEPER"
    zone      = "ru-central1-b"
    subnet_id = yandex_vpc_subnet.cluster-subnet-b.id
  }

  host {
    type      = "ZOOKEEPER"
    zone      = "ru-central1-c"
    subnet_id = yandex_vpc_subnet.cluster-subnet-c.id
  }

  database {
    name = "db1"
  }

  user {
    name     = "testuser"
    password = "testuser1"
    permission {
      database_name = "db1"
    }
  }
}
