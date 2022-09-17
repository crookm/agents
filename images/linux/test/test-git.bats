#!/usr/bin/env bats

# bats file_tags=dotnet

@test "git cli available" {
    git --help
}
