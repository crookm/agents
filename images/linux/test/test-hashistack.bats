#!/usr/bin/env bats

# bats file_tags=packer,hashistack

@test "hashistack packer cli available" {
    packer --version
}

# bats file_tags=terraform,hashistack

@test "hashistack terraform cli available" {
    terraform --version
}
