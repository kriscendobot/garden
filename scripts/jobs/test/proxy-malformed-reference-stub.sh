#!/bin/bash
# Deterministic proxy handler for the per-question malformed-reference regression.
# A question containing MALFORMED_REF_REPLY produces the exact
# maintainer-reply.sh reference-validation rejection; every other question gets
# a valid tentative reply.
set -euo pipefail
digest="${1:?usage: proxy-malformed-reference-stub.sh <digest-file>}"
JOBS="$(cd "$(dirname "$0")/.." && pwd)"

msgid="$(sed -n 's/^===== QUESTION \(.*\) =====$/\1/p' "$digest" | head -1)"
[ -n "${GARDEN_PROXY_STUB_CALLS:-}" ] && printf '%s\n' "$msgid" >> "$GARDEN_PROXY_STUB_CALLS"

reply="$(mktemp)"
trap 'rm -f "$reply"' EXIT
if grep -q 'MALFORMED_REF_REPLY' "$digest"; then
  printf '(proxy/tentative) inspect #652 first.\n' > "$reply"
else
  printf '(proxy/tentative) proceed with the reversible experiment.\n' > "$reply"
fi
"$JOBS/maintainer-reply.sh" "$msgid" "$reply"
