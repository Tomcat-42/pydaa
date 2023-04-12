#!/bin/bash
echo "Publishing wheels to PyPI..."
echo "USER ==> $PYPI_USERNAME"
twine upload dist/* -u "$PYPI_USERNAME" -p "$PYPI_PASSWORD"
