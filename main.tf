resource "digitalocean_ssh_key" "default" {
    name = "terraform"
    public_key = "${file("${var.pub_key}")}"
}

resource "digitalocean_droplet" "swarmkit-mgmt-01" {
    image = "ubuntu-14-04-x64"
    name = "swarmkit-mgmt-01"
    region = "ams2"
    size = "512mb"
    private_networking = true
    ssh_keys = [
      "${var.ssh_fingerprint}"
    ]

    connection {
      user = "root"
      private_key = "${file("${var.pvt_key}")}"
    }

    provisioner "remote-exec" {
      script = "install-docker.sh"
    }

    provisioner "file" {
      source = "bin/"
      destination = "/opt/swarmkit/bin"
    }

    provisioner "file" {
      source = "swarmkit.sh"
      destination = "/etc/profile.d/swarmkit.sh"
    }

    provisioner "remote-exec" {
      inline = [
        "chmod 755 /opt/swarmkit/bin/*",
        "nohup /opt/swarmkit/bin/swarmd -d /tmp/node-mgmt-01 --listen-control-api /tmp/mgmt-01/swarm.sock --hostname swarmkit-mgmt-01 > /tmp/swarmkit.log 2>&1 &",
        "echo 'Sleeping for a while so swarmkit can start' && sleep 10"
      ]
    }

}

resource "digitalocean_droplet" "swarmkit-worker-01" {
    image = "ubuntu-14-04-x64"
    name = "swarmkit-worker-01"
    region = "ams2"
    size = "512mb"
    private_networking = true
    ssh_keys = [
      "${var.ssh_fingerprint}"
    ]

    connection {
      user = "root"
      private_key = "${file("${var.pvt_key}")}"
    }

    provisioner "remote-exec" {
      script = "install-docker.sh"
    }

    provisioner "file" {
      source = "bin/"
      destination = "/opt/swarmkit/bin"
    }

    provisioner "remote-exec" {
      inline = [
        "chmod 755 /opt/swarmkit/bin/*",
        "nohup /opt/swarmkit/bin/swarmd -d /tmp/node-worker-01 --hostname swarmkit-worker-01 --join-addr ${digitalocean_droplet.swarmkit-mgmt-01.ipv4_address}:4242 > /tmp/swarmkit.log 2>&1 &",
        "echo 'Sleeping for a while so swarmkit can start' && sleep 10"
      ]
    }
}

output "swarmkit-mgmt-01" {
    value = "${digitalocean_droplet.swarmkit-mgmt-01.ipv4_address}"
}

output "swarmkit-worker-01" {
    value = "${digitalocean_droplet.swarmkit-worker-01.ipv4_address}"
}
