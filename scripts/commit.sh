#!/bin/bash

# bump version
./scripts/bump_version.sh

# Get current version
VERSION=$(grep version <setup.py | cut -d '"' -f 2)

# Commit using version as a new tag
git commit -am "Bump version to $VERSION"
git tag "$VERSION"
git push --tags
git push
