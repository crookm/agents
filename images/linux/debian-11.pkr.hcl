packer {
  required_plugins {
    digitalocean = {
      version = ">= 1.0.4"
      source  = "github.com/digitalocean/digitalocean"
    }
  }
}

variable "report_output" {
  type    = string
  default = "/tmp"
}

source "digitalocean" "agent" {
  image  = "debian-11-x64"
  size   = "s-1vcpu-512mb-10gb"
  region = "sfo3"

  ssh_username = "root"
  ipv6         = true

  snapshot_name    = "agent-debian-11-{{timestamp}}"
  snapshot_regions = ["sfo3"]
}

build {
  sources = ["source.digitalocean.agent"]

  # prepare
  # ---
  provisioner "shell" {
    environment_vars = ["DEBIAN_FRONTEND=noninteractive"]
    scripts          = [
      "${path.root}/scripts/prepare-os.sh",
      "${path.root}/scripts/prepare-apt.sh",
      "${path.root}/scripts/prepare-user.sh"
    ]
  }

  # install
  # ---
  provisioner "shell" {
    environment_vars = ["DEBIAN_FRONTEND=noninteractive"]
    scripts          = [
      "${path.root}/scripts/install-utils.sh",
      "${path.root}/scripts/install-git.sh",
      "${path.root}/scripts/install-bats.sh",
      "${path.root}/scripts/install-docker.sh",
      "${path.root}/scripts/install-dotnet.sh",
      "${path.root}/scripts/install-hashistack.sh",
      "${path.root}/scripts/install-jdk.sh"
    ]
  }

  # cleanup
  # ---
  provisioner "shell" {
    environment_vars = ["DEBIAN_FRONTEND=noninteractive"]
    script           = "${path.root}/scripts/cleanup.sh"
  }

  # test
  # ---
  provisioner "file" {
    source      = "${path.root}/test"
    destination = "/tmp"
  }

  provisioner "shell" {
    inline_shebang = "/bin/bash" # do not exit fast (so we can cleanup test dir even on failure)
    inline         = [
      "su - ci -c 'source /etc/environment && bats --report-formatter junit -o /tmp -T --jobs 4 -r /tmp/test'",
      "echo -n $? > /tmp/test_result",
      "rm -rf /tmp/test",
      "exit 0"
    ]
  }

  provisioner "file" {
    direction   = "download"
    source      = "/tmp/report.xml"
    destination = "${var.report_output}/test_report.xml"
  }

  provisioner "shell" {
    # fail the execution if any tests failed
    # > separated out here so we can download the report on failure as well
    inline = ["exit $(cat /tmp/test_result)"]
  }
}
