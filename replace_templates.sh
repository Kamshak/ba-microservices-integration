rm -rf replaced.yaml
cd templates
find . -type f -exec sh -c "jinja2 {} ../values.toml >> ../replaced.yaml && echo \\\\n---\\\\n >> ../replaced.yaml" \;
