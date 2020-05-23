#!/bin/bash

if ! [[ -a package.json ]]; then
  echo "package.json not found"
  exit
fi

if ! which jq > /dev/null; then
  echo "jq not available"
  exit
fi

if ! which fzf > /dev/null; then
  echo "fzf not available"
  exit
fi

jq -r ".scripts | keys[]" package.json | fzf | xargs npm run
