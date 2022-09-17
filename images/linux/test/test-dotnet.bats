#!/usr/bin/env bats

# bats file_tags=dotnet

@test "dotnet cli available" {
    dotnet --info
}


# bats file_tags=dotnet,dotnet:tools

@test "dotnet tool ef is available" {
    dotnet ef --help
}

@test "dotnet tool dotcover is available" {
    dotnet dotcover --help
}

