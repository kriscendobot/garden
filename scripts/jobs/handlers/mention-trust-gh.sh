#!/bin/bash
# mention-trust-gh.sh — default org-membership trust check for mention-watcher.sh.
#
# Invoked as: mention-trust-gh.sh <login>
# Exit 0  → the login is a CURRENT member of the endojs OR Agoric org.
# Exit 1  → DEFINITIVELY not a member of either (a 404 from both orgs; the
#           watcher then DROPS the mention, unless the login was on the
#           allowlist, which the watcher checks before calling this handler).
# Exit 2  → INDETERMINATE: the membership API could not answer even after
#           gh_api_retry's transient budget (a 5xx/rate-limit window, an
#           outage). NOT cached — a transient failure must not stamp a
#           genuinely-trusted sender 'other' for the whole cache TTL, which
#           silently dropped every mention of theirs for an hour while the
#           watcher advanced its cursor past them. The watcher holds its
#           cursor and retries next tick.
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

is_member() {  # is_member <org> <login>  → 0 member; 1 definitive non-member; 2 indeterminate
  local code errf rc=0 out
  # gh_api_retry rides out a TRANSIENT blip (5xx / 429 / DNS-TLS-reset) under
  # backoff so a flake no longer drops a genuinely-trusted sender's mention; on
  # a 204 it passes the response headers through unchanged (code=204 → member).
  # Its stderr distinguishes the two failure kinds — a DEFINITIVE 404 logs
  # "(definitive, ...); not retrying", an exhausted transient logs "after N
  # transient attempt(s)" — and that wording is the only place the distinction
  # survives (both paths return non-zero with empty stdout), so we capture it.
  errf="$(mktemp)"
  if out="$(gh_api_retry -X GET "orgs/$1/members/$2" -i 2>"$errf")"; then rc=0; else rc=$?; fi
  if [ "$rc" -eq 0 ]; then
    rm -f "$errf"
    code="$(printf '%s' "$out" | head -1 | grep -oE '[0-9]{3}' | head -1 || true)"
    [ "$code" = 204 ] && return 0
    return 1                       # a successful non-204 response: not a member
  fi
  if grep -q 'definitive' "$errf" 2>/dev/null; then rm -f "$errf"; return 1; fi
  rm -f "$errf"; return 2          # transient budget exhausted: no usable answer
}

r1=0; is_member endojs "$login" || r1=$?
if [ "$r1" -eq 0 ]; then
  echo member > "$cache"; log "trusted: $login is an endojs org member"; exit 0
fi
r2=0; is_member Agoric "$login" || r2=$?
if [ "$r2" -eq 0 ]; then
  echo member > "$cache"; log "trusted: $login is an Agoric org member"; exit 0
fi
# Neither org answered "member". Only a DEFINITIVE non-member verdict from BOTH
# orgs may be cached as 'other'; if either probe was indeterminate the sender
# might be a member we could not confirm — exit 2, cache nothing, let the
# watcher hold its cursor and re-ask next tick.
if [ "$r1" -eq 2 ] || [ "$r2" -eq 2 ]; then
  log "WARN: membership indeterminate for $login (transient API failure); not caching a verdict"
  exit 2
fi
echo other > "$cache"; exit 1
