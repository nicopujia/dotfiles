#!/bin/sh
set -e

file_path="$1"

if [ -z "$file_path" ]; then
  printf '%s\n' 'python-format.sh: missing file path' >&2
  exit 1
fi

tmp_dir=$(mktemp -d)
input_file="$tmp_dir/input.py"
checked_file="$tmp_dir/checked.py"

cleanup() {
  rm -rf "$tmp_dir"
}

trap cleanup EXIT HUP INT TERM

cat > "$input_file"
uv run --no-project ruff check --exit-zero --fix --stdin-filename "$file_path" - < "$input_file" > "$checked_file"
exec uv run --no-project ruff format --stdin-filename "$file_path" - < "$checked_file"
