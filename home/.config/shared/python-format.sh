#!/bin/sh

file_path="$1"

if [ -z "$file_path" ]; then
  printf '%s\n' 'python-format.sh: missing file path' >&2
  exit 1
fi

ruff check --exit-zero --fix --stdin-filename "$file_path" - | ruff format --stdin-filename "$file_path" -
