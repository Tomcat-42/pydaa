#!/bin/bash
set -e -u -x

# if PLAT is not set, set a default value
if [ "${PLAT+x}" = "" ]; then
    PLAT=manylinux2014_$(uname -m)
fi

function repair_wheel {
    wheel="$1"
    if ! auditwheel show "$wheel"; then
        echo "Skipping non-platform wheel $wheel"
    else
        mkdir -p /io/dist >/dev/null 2>&1
        auditwheel repair "$wheel" --plat "$PLAT" -w /io/dist
    fi
}

function is_installed {
    rpm -q "$1" >/dev/null 2>&1 || return 1
}

# Install a system package required by our library

# rpm packages array
DEPS=("ninja-build")
for dep in "${DEPS[@]}"; do
    if ! is_installed "$dep"; then
        yum install -y "$dep"
    fi
done

# Compile wheels
for PYBIN in /opt/python/*/bin; do
    "${PYBIN}/pip" install -r /io/dev-requirements.txt
    "${PYBIN}/pip" wheel /io/ --no-deps -w wheelhouse/
done

# Bundle external shared libraries into the wheels
# and copy to dist folder
for whl in wheelhouse/*.whl; do
    repair_wheel "$whl"
done

# fix up the permissions
chmod -R a+rw /io/dist /io/build /io/daa.egg-info

# Install packages and test
for PYBIN in /opt/python/*/bin/; do
    "${PYBIN}/pip" install python-manylinux-demo --no-index -f /io/dist
    (
        cd "$HOME"
        "${PYBIN}/nosetests" pymanylinuxdemo
    )
done
