#!/bin/bash
# watchman-claude.sh — default watchman handler: broadcast evolution via claude.
#
# Invoked by watchman.sh as: watchman-claude.sh <old-sha> <new-sha> <garden-root>
# Wears the watchman role, inspects how roles/ and skills/ changed on main2, and
# broadcasts messages to the affected roles so running agents learn how their
# brief just evolved. The watchman role brief lives at roles/watchman/AGENT.md.
#
# Contract with claude: emit each message as a block
#     MSG <address>            (role/<name> | job/<base> | broadcast)
#     <body lines...>
#     ENDMSG
# This handler sends each via send-msg.sh. Test harness overrides
# GARDEN_WATCH_HANDLER with a stub.

set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=../common.sh
source "$HERE/../common.sh"
GARDEN_TAG="watchman-claude"

old="${1:-}"; new="${2:?new}"; root="${3:?root}"
role_brief="$root/roles/watchman/AGENT.md"
diff="$(git -C "$root" log --stat "${old:+$old..$new}" -- roles skills 2>/dev/null | head -400)"

prompt="$(cat <<EOF
You are the garden watchman (role brief: $role_brief). The garden library
(main2) advanced. roles/ and skills/ changes follow. Broadcast any meta
information running agents need about how their role or skills evolved. Emit
zero or more message blocks in EXACTLY this format and nothing else:

MSG <address: role/<name> | job/<base> | broadcast>
<body lines for the recipients>
ENDMSG

----- ROLE/SKILL CHANGES -----
$diff
----- END CHANGES -----
EOF
)"

command -v claude >/dev/null 2>&1 || die "claude not on PATH; cannot run watchman"
# --dangerously-skip-permissions: autonomous headless context, no human
# approver; the default permission gate would deny every tool call. Bypass is
# the intended fleet posture (operator pre-consents via
# skipDangerousModePermissionPrompt in ~/.claude). Requires running as non-root.
out="$(claude -p --dangerously-skip-permissions "$prompt")"

sent=0; addr=""; body=""
while IFS= read -r line; do
  if [[ "$line" =~ ^MSG[[:space:]]+(.+)$ ]]; then
    addr="${BASH_REMATCH[1]}"; body=""
  elif [ "$line" = "ENDMSG" ] && [ -n "$addr" ]; then
    printf '%s' "$body" | "$HERE/../send-msg.sh" "$addr"
    sent=$((sent+1)); addr=""; body=""
  elif [ -n "$addr" ]; then
    body+="$line"$'\n'
  fi
done <<< "$out"
log "broadcast $sent message(s) from main2 evolution"
