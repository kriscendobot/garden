#!/bin/bash
# C-typist-inline-import-jsdoc -- fires on an added inline import() JSDoc type.
set -uo pipefail

BASE=${BASE:-origin/master}
hit=$(git diff "$BASE...HEAD" -U0 2>/dev/null \
  | grep -E "^\\+[^+].*(@[[:alpha:]][[:alnum:]_-]*|\\{).*import[[:space:]]*\\([[:space:]]*['\\\"]" \
  | head -1 || true)

if [ -n "$hit" ]; then
  echo "fire typist inline import() JSDoc type: ${hit#+}"
  exit 0
fi

echo "skip typist"
