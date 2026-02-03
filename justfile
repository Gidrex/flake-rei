# Justfile for flake-rei

# Default recipe - list all available commands
@default:
    just --list

# QA
@qa:
    which niri > /dev/null && niri validate
