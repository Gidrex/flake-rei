# Justfile for flake-rei

# Default recipe - list all available commands
@default:
    just --list

# Format all Nix files
@fmt:
    nixfmt .

# Validate flake syntax and check for issues
@lint:
    nix flake check --no-build

# Fmt + Lint
@qa: fmt lint

# Validate flake syntax and check for issues with trace
@lint-trace:
    nix flake check --no-build --show-trace

# Full check - format check + lint
@check: fmt lint

# Update flake inputs
@update: check
    nix flake update
    rb
