#!/bin/bash
# Shared guard: a test suite must never latch the LIVE host's gh-api cooldown.
#
# common.sh defaults GARDEN_API_COOLDOWN_DIR to $GARDEN_ROOT/.garden-state/gh-api-
# cooldown, and a gardener's environment exports GARDEN_ROOT as the deployed root.
# A suite run standalone from a job worktree therefore inherited the live directory,
# and a primary-quota fixture wrote a one-hour latch into it that blocked every
# fleet `gh` call on that host (2026-10-06 ~16:27Z, comment-watcher-test RATE).
#
#   live_cooldown_guard_begin <tmp-root>
#       Snapshot the live markers, then export GARDEN_API_COOLDOWN_DIR under
#       <tmp-root> so any case that does not name its own directory latches the
#       fixture, never the fleet. Call it before the first case runs.
#   live_cooldown_guard_end
#       rc 1 (with a loud message) if any live marker changed during the suite.

_live_cooldown_dirs() {
  local here d seen=""
  here="$(cd "$(dirname "${BASH_SOURCE[0]}")/../../.." && pwd)"
  for d in "${_LIVE_COOLDOWN_INHERITED_ROOT:-}" "$here"; do
    [ -n "$d" ] || continue
    d="$d/.garden-state/gh-api-cooldown"
    case " $seen " in *" $d "*) continue ;; esac
    seen="$seen $d"; printf '%s\n' "$d"
  done
}

_live_cooldown_snapshot() {
  local d m
  while IFS= read -r d; do
    for m in marker marker-graphql; do
      if [ -e "$d/$m" ]; then
        printf '%s/%s %s\n' "$d" "$m" "$(cksum < "$d/$m" 2>/dev/null)"
      else
        printf '%s/%s absent\n' "$d" "$m"
      fi
    done
  done < <(_live_cooldown_dirs)
}

live_cooldown_guard_begin() {  # live_cooldown_guard_begin <tmp-root>
  local tmp="${1:?live_cooldown_guard_begin needs the suite temp root}"
  _LIVE_COOLDOWN_INHERITED_ROOT="${GARDEN_ROOT:-}"
  _LIVE_COOLDOWN_BEFORE="$(_live_cooldown_snapshot)"
  export GARDEN_API_COOLDOWN_DIR="$tmp/gh-api-cooldown"
}

live_cooldown_guard_end() {
  local after
  after="$(_live_cooldown_snapshot)"
  [ "$after" = "${_LIVE_COOLDOWN_BEFORE:-}" ] && return 0
  echo "  FAIL: the suite touched the LIVE gh-api cooldown (a test must never latch the fleet)" >&2
  diff <(printf '%s\n' "${_LIVE_COOLDOWN_BEFORE:-}") <(printf '%s\n' "$after") >&2 || true
  return 1
}
