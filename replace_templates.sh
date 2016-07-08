#!/bin/bash

set -e

rm -rf replaced.yaml
cd templates
find . -type f -exec sh -c "jinja2 $VALUE_OVERRIDE {} ../values.toml >> ../replaced.yaml && echo \\\\n---\\\\n >> ../replaced.yaml" \;
