#!/bin/bash

set -e

if [ -f "$1" ]; then
  OUTFILE=$(readlink -f $1)
  rm -rf $OUTFILE
else
  OUTFILE="/dev/stdout"
fi

cd templates
find . -type f -exec sh -c "jinja2 --strict $VALUE_OVERRIDE {} ../values.toml >> $OUTFILE && echo \\\\n---\\\\n >> $OUTFILE" \;
