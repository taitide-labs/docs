#!/usr/bin/env bash
set -euo pipefail

if [ "$#" -lt 1 ]; then
  echo "Usage: $0 <file.md>..." >&2
  exit 1
fi

autocorrect --fix -q "$@"
rumdl check --fix -q "$@"
typos "$@"

if ! lychee_out=$(lychee --offline -qq -n "$@" 2>&1); then
  printf '%s\n' "$lychee_out" >&2
  exit 1
fi

for file in "$@"; do
  if grep -q '```mermaid' "$file"; then
    mmdr -i "$file" --size --fastText >/dev/null
  fi
done
