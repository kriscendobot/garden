#!/bin/bash
# C-purist — fires on intrinsic-shaping, Endo primitive reuse, and URL-path-math signals.
set -uo pipefail
BASE=${BASE:-origin/master}
PATTERN="defineProperty\\([^)]*enumerable|Object\\.freeze\\(|\\bharden\\b|\\bpassStyleOf\\b|\\bRemotable\\w*\\b|createHash[[:space:]]*\\([[:space:]]*['\"]sha-?256|subtle\\.digest[[:space:]]*\\([[:space:]]*['\"]SHA-?256|new[[:space:]]+Text(Encoder|Decoder)[[:space:]]*\\(|(^|[^[:alnum:]_\$])(atob|btoa)[[:space:]]*\\(|\\.toString[[:space:]]*\\([[:space:]]*16[[:space:]]*\\)[[:space:]]*\\.padStart[[:space:]]*\\([[:space:]]*2|Uint8Array\\.from.*charCodeAt[[:space:]]*\\(|\\b(const|let|var|function)[[:space:]]+insist[A-Z_a-z0-9\$]*|base64::|BASE64_(STANDARD|URL_SAFE)|import[[:space:]]+[^'\"]*[[:space:]]from[[:space:]]+['\"](node:)?path['\"]|\\bpath\\.(resolve|dirname)[[:space:]]*\\("
hit=$(git diff "$BASE...HEAD" -U0 2>/dev/null | grep -E '^\+[^+]' | grep -oE "$PATTERN" | head -1 || true)
if [ -n "$hit" ]; then
  echo "fire purist matched: $hit"
  exit 0
fi
echo "skip purist"
