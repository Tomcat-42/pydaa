echo "Publishing wheels to PyPI..."
twine upload dist/* -u "$PYPI_USERNAME" -p "$PYPI_PASSWORD"
