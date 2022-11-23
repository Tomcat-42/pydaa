#!/usr/bin/bash

# platforms to build against
PLATS=("manylinux2014_x86_64")
MANYLINUX_URL="quay.io/pypa"

# update all git submodules
echo "Updating git submodules..."
git submodule update --init --recursive

# clean up previous builds
echo "Cleaning up previous builds..."
./scripts/clean.sh

# check if the docker images exists
for PLAT in "${PLATS[@]}"; do
    MANYLINUX_IMAGE="${MANYLINUX_URL}/${PLAT}"

    echo "Checking if docker image for $PLAT exists..."
    if ! docker image inspect "$MANYLINUX_IMAGE" >/dev/null 2>&1; then
        echo "Docker image for $PLAT does not exist. Pulling..."
        docker pull "$MANYLINUX_IMAGE"
        echo "Docker image for $PLAT pulled."
    fi

    # build the wheels in the docker iage
    echo "Building wheels for $PLAT..."
    docker run --rm -v "$PWD":/io "$MANYLINUX_IMAGE" /io/scripts/build-wheels.sh
done

# publish the wheels to PyPI
echo "Publishing wheels to PyPI..."
poetry publish
