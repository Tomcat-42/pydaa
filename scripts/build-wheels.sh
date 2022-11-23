#!/bin/bash
set -e -u -x

# if PLAT is not set, set a default value
if [ "${PLAT+x}" = "" ]; then
    PLAT=manylinux_2_5_x86_64
fi

function repair_wheel {
    wheel="$1"
    if ! auditwheel show "$wheel"; then
        echo "Skipping non-platform wheel $wheel"
    else
        auditwheel repair "$wheel" --plat "$PLAT" -w /io/dist
    fi
}

# Install a system package required by our library
yum install -y ninja-build

# Compile wheels
for PYBIN in /opt/python/*/bin; do
    "${PYBIN}/pip" install -r /io/dev-requirements.txt
    "${PYBIN}/pip" wheel /io/ --no-deps -w wheelhouse/
done

# Bundle external shared libraries into the wheels
for whl in wheelhouse/*.whl; do
    repair_wheel "$whl"
done

# fix up the permissions
chmod -R a+rw /io/dist

# Install packages and test
# for PYBIN in /opt/python/*/bin/; do
#     "${PYBIN}/pip" install python-manylinux-demo --no-index -f /io/wheelhouse
#     (
#         cd "$HOME"
#         "${PYBIN}/nosetests" pymanylinuxdemo
#     )
# done
