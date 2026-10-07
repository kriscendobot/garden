#!/bin/bash
# C-locksmith - fires on capability-flow signals and identity-keyed authorization.
#
# The identity arm senses review-miss cluster `identity-gated-authority`
# (kriscendobot/minion.town #85): clip upgrade copied an owner-equality check even
# though the standing design says per-action authorization comes from a capability
# the caller holds. Err toward firing. The locksmith decides whether identity is
# merely an authentication/accounting key or is incorrectly granting the action.
set -uo pipefail
BASE=${BASE:-origin/master}

CAPABILITY_PATTERN='\battenuate\w*\b|\bendowments?\b|\bFar\(|\bpassStyleOf\b|\bmakeCapTP\b|\bExo(Class)?\b|\bgrant\w*\b'
IDENTITY_EQUALITY='(\.(owner|caller|principal|subject|sub|iss|issuer)|\b(owner|caller|principal|subject|sub|iss|issuer)\b)[[:space:]]*[!=]==?'
IDENTITY_HELPER='\b(is|assert|require|check)[_-]?owner\b'
IDENTITY_ALLOWLIST='\b(owner|caller|principal|subject|sub|iss|issuer)(s|ers)?[_-]?(allowlist|whitelist)\b|\ballowed[_-]?(owners|callers|principals|subjects|subs|issuers)\b'
IDENTITY_REJECTION='\bnon[- ]owner\b|\bnot[[:space:]-]+the[[:space:]-]+owner\b|\bonly[[:space:]-]+the[[:space:]-]+owner\b|\bdoes[[:space:]]+not[[:space:]]+own\b|\bowner[- ]gated\b'

if [ "${1:-}" = "--scan-stdin" ]; then
  lines=$(cat)
else
  lines=$(git diff "$BASE...HEAD" -U0 2>/dev/null | grep -E '^\+[^+]' | sed 's/^+//' || true)
fi

hit=$(printf '%s\n' "$lines" | grep -oiE "$IDENTITY_EQUALITY|$IDENTITY_HELPER|$IDENTITY_ALLOWLIST|$IDENTITY_REJECTION" | head -1 || true)
if [ -n "$hit" ]; then
  echo "fire locksmith identity-keyed authorization signal: $hit"
  exit 0
fi

hit=$(printf '%s\n' "$lines" | grep -oE "$CAPABILITY_PATTERN" | head -1 || true)
if [ -n "$hit" ]; then
  echo "fire locksmith capability-flow signal: $hit"
  exit 0
fi

echo "skip locksmith"
