#!/usr/bin/env bats

# bats file_tags=java

@test "java cli available" {
    java --version
}

@test "java home env directory exists" {
    [ -d "$JAVA_HOME" ]
}

