#!/bin/bash

# bump version
./scripts/bump_version.sh setup.py pyproject.toml

# Get current version
VERSION=$(grep version <setup.py | cut -d '"' -f 2)

# Commit using version as a new tag
git commit -am "Bump version to v$VERSION"
git tag v"$VERSION"
git push --tags
git push
