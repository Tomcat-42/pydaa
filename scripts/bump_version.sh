#!/bin/bash

FILES=${*:-setup.py}

# NOTE: THIS IS UTTER GARBAGE. I'M SORRY.
# In setup.py, we have a version number in the form of `version='X.Y.Z'`.
# in every run of this script, we increment the Z value by 1. If the Z value
# is 9, we increment the Y value by 1 and set the Z value to 0. If the Y value
# is 9, we increment the X value by 1 and set the Y value to 0.
# This is a terrible way to do this, but it works for now.

# version="X.Y.Z", => X.Y.Z => X Y Z
function get_current_version() {
	grep version <"$1" | cut -d '"' -f 2 | tr '.' ' '
}

# X Y Z => bump Z => X Y Z
function bump_version() {
  read -r X Y Z <<<"$1"
  if [ "$Z" -eq 9 ]; then
    Z=0
    Y=$((Y+1))
  else
    Z=$((Z+1))
  fi

  echo "$X.$Y.$Z"
}

# substitute every instance of version="X.Y.Z" with version="X.Y.Z+1"
function bump_version_in_file() {
  local file="$1"
  local version="$2"

  sed -i "s/version=\"[0-9]\+\.[0-9]\+\.[0-9]\+\"/version=\"$version\"/" "$file"
}

for i in "${FILES[@]}"; do
	a=$(get_current_version "$i")
  b=$(bump_version "$a")
  bump_version_in_file "$i" "$b"
done
