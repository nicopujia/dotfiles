#!/bin/sh

file_path="$1"
script_dir=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)

if [ -z "$file_path" ]; then
  printf '%s\n' 'python-format.sh: missing file path' >&2
  exit 1
fi

exec uv run --script "$script_dir/python-format.py" "$file_path"
