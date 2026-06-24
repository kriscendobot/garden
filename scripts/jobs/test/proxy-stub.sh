#!/bin/bash
# proxy-stub.sh — deterministic proxy handler for tests. For each QUESTION block
# in the digest it records the call (so the cost gate / no-duplicate-call can be
# asserted) and routes the outcome exactly as the real handler would, but with a
# fixed in/out-of-bounds rule instead of a `claude -p` call:
#   - out-of-bounds (body names a ferry/identity-switch/agoric-sdk/authority ask)
#     → DEFER: post the "beyond proxy authority" note, leave the message unread;
#   - otherwise → ANSWER: route a tentative reply into the gardener's inbox AND
#     archive the maintainer message (maintainer-reply.sh), then post a report.
set -euo pipefail
digest="${1:?usage: proxy-stub.sh <digest-file>}"
JOBS="$(cd "$(dirname "$0")/.." && pwd)"

out_of_bounds() { printf '%s' "$1" | grep -qiE 'agoric-sdk|identity[- ]switch|\bferry\b|grant .*authority'; }

msgid=""; doer=""; block=""
process() {
  [ -n "$msgid" ] || return 0
  [ -n "${GARDEN_PROXY_STUB_CALLS:-}" ] && printf '%s\n' "$msgid" >> "$GARDEN_PROXY_STUB_CALLS"
  if out_of_bounds "$block"; then
    nf="$(mktemp)"
    printf 'awaiting maintainer — beyond proxy authority: gardener %s, msgid %s\n' "$doer" "$msgid" > "$nf"
    GARDEN_SENDER=proxy "$JOBS/inbox-send.sh" maintainer "$nf"; rm -f "$nf"
  else
    rf="$(mktemp)"
    printf '(proxy/tentative) proceed; treat the result as provisional, the maintainer may revise.\n' > "$rf"
    "$JOBS/maintainer-reply.sh" "$msgid" "$rf"
    repf="$(mktemp)"
    printf 'proxy answered a gating question (tentative): gardener %s, msgid %s\n' "$doer" "$msgid" > "$repf"
    GARDEN_SENDER=proxy "$JOBS/inbox-send.sh" maintainer "$repf"
    rm -f "$rf" "$repf"
  fi
}

while IFS= read -r line; do
  case "$line" in
    "===== QUESTION "*" =====") process; msgid="${line#===== QUESTION }"; msgid="${msgid% =====}"; doer=""; block="";;
    "===== END QUESTION "*" =====") process; msgid=""; doer=""; block="";;
    "doer: "*) [ -z "$doer" ] && doer="${line#doer: }"; block+="$line"$'\n';;
    *) [ -n "$msgid" ] && block+="$line"$'\n';;
  esac
done < "$digest"
process
