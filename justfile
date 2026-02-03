# Justfile for flake-rei

# Default recipe - list all available commands
@default:
    just --list

# QA
@qa:
    command -v niri > /dev/null && niri validate
