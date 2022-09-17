packer {
    required_plugins {
        digitalocean = {
            version = ">= 1.0.4"
            source  = "github.com/digitalocean/digitalocean"
        }
    }
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
            "${path.root}/scripts/prepare-user.sh"]
    }

    # install
    # ---
    provisioner "shell" {
        environment_vars = ["DEBIAN_FRONTEND=noninteractive"]
        scripts          = [
            "${path.root}/scripts/install-utils.sh",
            "${path.root}/scripts/install-bats.sh",
            "${path.root}/scripts/install-docker.sh",
            "${path.root}/scripts/install-dotnet.sh",
            "${path.root}/scripts/install-jdk.sh"]
    }

    # cleanup
    # ---
    provisioner "shell" {
    environment_vars = ["DEBIAN_FRONTEND=noninteractive"]
        script = "${path.root}/scripts/cleanup.sh"
    }

    # test
    # ---
    provisioner "file" {
        source = "${path.root}/test"
        destination = "/tmp"
    }
    provisioner "shell" {
        inline_shebang = "/bin/bash" # do not exit fast (so we can cleanup test dir even on failure)
        inline         = [
            "source /etc/environment",
            "su - ci -c 'time bats -r /tmp/test'",
            "test_result=$?",
            "rm -rf /tmp/test",
            "exit $test_result"]
    }
}
