#!/bin/zsh

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

cat package.json | jq -r ".scripts | keys[]" | fzf | xargs npm run
