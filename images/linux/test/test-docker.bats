#!/usr/bin/env bats

# bats file_tags=docker

@test "docker cli available" {
    docker --help
}

@test "docker daemon access permitted" {
    docker ps
}

