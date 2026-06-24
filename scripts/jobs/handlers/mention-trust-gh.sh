#!/bin/bash
# mention-trust-gh.sh — default org-membership trust check for mention-watcher.sh.
#
# Invoked as: mention-trust-gh.sh <login>
# Exit 0  → the login is a CURRENT member of the endojs OR Agoric org.
# Exit 1  → not a confirmable member of either (the watcher then DROPS the
#           mention, unless the login was on the allowlist, which the watcher
#           checks before calling this handler).
#
# This is the second half of the deterministic sender-trust gate (the first half
# is the allowlist, matched in the watcher). It is a READ-ONLY trust check:
# `gh api orgs/<org>/members/<login>` returns 204 for a member and 404 otherwise.
# Confirming Agoric membership establishes that the sender is a trusted human; it
# does NOT authorize any work on agoric-sdk, which stays off-limits per the
# standing scope rule. No mention text is read here — only the author login.
#
# Results are cached briefly on disk (default 1h) so a chatty contributor does not
# burn the membership endpoint's rate limit on every tick.

set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=../common.sh
source "$HERE/../common.sh"
GARDEN_TAG="mention-trust"

login="${1:?usage: mention-trust-gh.sh <login>}"
case "$login" in *[!A-Za-z0-9-]*|'') die "illegal login '$login'";; esac

command -v gh >/dev/null 2>&1 || die "gh not on PATH; cannot check org membership"

: "${GARDEN_TRUST_CACHE_DIR:=$GARDEN_STATE/mention-watcher/trust-cache}"
: "${GARDEN_TRUST_CACHE_TTL:=3600}"
mkdir -p "$GARDEN_TRUST_CACHE_DIR"
cache="$GARDEN_TRUST_CACHE_DIR/$(printf '%s' "$login" | tr '[:upper:]' '[:lower:]')"

# Fresh cache hit short-circuits the API call.
if [ -f "$cache" ]; then
  age=$(( $(date +%s) - $(stat -c %Y "$cache" 2>/dev/null || echo 0) ))
  if [ "$age" -lt "$GARDEN_TRUST_CACHE_TTL" ]; then
    [ "$(cat "$cache")" = member ] && exit 0 || exit 1
  fi
fi

is_member() {  # is_member <org> <login>  → 0 if 204 (member)
  local code
  code="$(gh api -X GET "orgs/$1/members/$2" -i 2>/dev/null | head -1 | grep -oE '[0-9]{3}' | head -1 || true)"
  [ "$code" = 204 ]
}

if is_member endojs "$login" || is_member Agoric "$login"; then
  echo member > "$cache"; log "trusted: $login is an endojs/Agoric org member"; exit 0
fi
echo other > "$cache"; exit 1
