#!/bin/bash
# mirror-closer.sh — close our mirror PR when its UPSTREAM PR closes (deterministic).
#
# Usage: mirror-closer.sh        (single instance; timer-driven, like the
#                                 mention-watcher — NOT per-repo instanced)
#
# ─────────────────────────────────────────────────────────────────────────────
# WHY AN UPSTREAM WATCHER IS PERMISSIBLE HERE (monitoring-safety carve-out)
# ─────────────────────────────────────────────────────────────────────────────
# CLAUDE.md § Monitoring safety constraint forbids feeding untrusted external
# repo TEXT (comments, PR bodies) into an LLM, because that text is a prompt-
# injection vector. That constraint guards a *model*. This service has NO `claude`
# in the loop and reads NO free-form text: it reads exactly one mechanical, typed
# state per mapped upstream PR — `state` (open|closed) and whether it was merged —
# and acts on a state TRANSITION. No upstream comment, title, or body is ever
# parsed, interpolated, or shown to a model. With no model and no untrusted text,
# there is no injection surface, so watching upstreams for this single mechanical
# state-change is injection-safe and does NOT require the per-repo monitoring
# authorization the comment-watcher does. The watcher is close-ONLY: it reacts to
# nothing but a mapped upstream PR transitioning to closed.
#
# ─────────────────────────────────────────────────────────────────────────────
# WHAT IT DOES
# ─────────────────────────────────────────────────────────────────────────────
# The watch set is SELF-MAINTAINING: it is exactly the upstream repos named by the
# mappings under journal2:pr-mirrors/ (written at mirror-creation time by
# record-mirror.sh; see roles/boatman/AGENT.md and skills/pr-handoff step 8). We
# only ever look at upstream PRs we actually mirror — an unmapped PR is never even
# fetched, which is what makes "never close anything without a recorded mapping"
# true by construction rather than by a filter.
#
# Each tick, for every mapping that is not already resolved:
#   1. read the UPSTREAM PR's state (handler GARDEN_MIRROR_PR_STATE).
#   2. if it is still open → nothing to do.
#   3. if it is closed:
#        - read OUR mirror PR's state.
#        - if the mirror is still OPEN → post a comment naming the upstream PR and
#          whether it merged or was closed, then `gh pr close` the mirror (handler
#          GARDEN_MIRROR_CLOSE, bot identity).
#        - if the mirror is ALREADY closed → close nothing; just reconcile.
#        - either way, stamp `closed_at:`/`upstream_outcome:` onto the mapping.
#
# THE DURABLE CURSOR is per-mapping, not a timestamp: a mapping carrying
# `closed_at:` is resolved and skipped on every future tick with NO GitHub call.
# This is strictly safer than a "closed since <time>" stream cursor — it is exact
# per PR, survives restarts/hosts (it lives on the journal), and a re-poll is a
# pure file read. We stamp it ONLY after the close is handled, so a crash mid-tick
# re-handles rather than skips.
#
# IDEMPOTENT: an already-resolved mapping is skipped; an already-closed mirror is
# reconciled without a duplicate comment; a duplicate run is a no-op.
#
# LOUD FAILURE (2026-06-24/25 hardening): a missing git/gh/jq or any failed GitHub
# call dies loudly (the default handlers require_tools and never swallow errors);
# the watcher never silently no-ops a close it should have made.
#
# Pluggable GitHub I/O for deterministic tests (the close path is NEVER exercised
# against a real upstream in CI — see test/mirror-closer-test.sh):
#   GARDEN_MIRROR_PR_STATE <owner/repo> <pr>          -> "<state>\t<merged>"
#   GARDEN_MIRROR_CLOSE    <owner/repo> <pr> <body-file>   (post comment + close)

set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=common.sh
source "$HERE/common.sh"
GARDEN_TAG="mirror-closer"

: "${GARDEN_MIRROR_PR_STATE:=$HERE/handlers/mirror-pr-state-gh.sh}"
: "${GARDEN_MIRROR_CLOSE:=$HERE/handlers/mirror-close-gh.sh}"

# git is this script's own hard dependency (it reads the journal). The default
# I/O handlers guard gh/jq themselves; a test that overrides them needs neither.
require_tools git

killswitch_engaged && { log "killswitch engaged; skipping"; exit 0; }

DIR="${GARDEN_MIRROR_CLONE:-$GARDEN_STATE/mirror-closer/journal}"
ensure_clone "$DIR"
sync_clone "$DIR"

# --- snapshot the mappings (read-only), then release the clone lock ----------
# Collect (key, upstream, mirror) for every unresolved mapping. A mapping that
# already carries closed_at is resolved → skipped here with no GitHub call.
declare -a KEYS=() UPS=() MIRS=()
shopt -s nullglob
for path in "$DIR"/pr-mirrors/*.md; do
  base="${path##*/}"; [ "$base" = .gitkeep ] && continue
  up="$(sed -n 's/^upstream:[[:space:]]*//p' "$path" | head -1)"
  mir="$(sed -n 's/^mirror:[[:space:]]*//p'   "$path" | head -1)"
  resolved="$(sed -n 's/^closed_at:[[:space:]]*//p' "$path" | head -1)"
  [ -n "$up" ] && [ -n "$mir" ] || { log "WARN: mapping pr-mirrors/$base missing upstream/mirror; skipping"; continue; }
  [ -n "$resolved" ] && continue        # durable per-mapping cursor: already done
  KEYS+=("pr-mirrors/$base"); UPS+=("$up"); MIRS+=("$mir")
done
shopt -u nullglob
clone_unlock "$DIR"      # read-only pass done; release before the (slow) gh work

n="${#KEYS[@]}"
if [ "$n" -eq 0 ]; then
  log "no unresolved pr-mirror mappings; nothing to watch"
  exit 0
fi
log "checking $n unresolved mapping(s) across $(printf '%s\n' "${UPS[@]}" | sed 's/#.*//' | sort -u | wc -l | tr -d ' ') upstream repo(s)"

# owner/repo#N  ->  https://github.com/owner/repo/pull/N
pr_url() { local r="${1%%#*}" num="${1##*#}"; printf 'https://github.com/%s/pull/%s' "$r" "$num"; }

# Stamp closed_at + upstream_outcome onto a mapping (CAS, idempotent). Its own
# sync→edit→push retry loop so it is safe under cross-host contention and always
# rebases on the authoritative tip. A mapping that already carries closed_at is a
# no-op (a peer host resolved it first).
mark_resolved() {  # mark_resolved <key> <outcome>
  local key="$1" outcome="$2" attempt
  for attempt in $(seq 1 "${GARDEN_POST_ATTEMPTS:-50}"); do
    sync_clone "$DIR"
    if [ ! -e "$DIR/$key" ]; then clone_unlock "$DIR"; log "WARN: $key vanished before resolve"; return 0; fi
    if grep -q '^closed_at:' "$DIR/$key"; then
      log "$key already resolved by a peer; nothing to stamp"; clone_unlock "$DIR"; return 0
    fi
    { printf 'closed_at: %s\n' "$(date -u +%FT%TZ)"
      printf 'upstream_outcome: %s\n' "$outcome"; } >> "$DIR/$key"
    git -C "$DIR" add "$key"
    if commit_and_push "$DIR" "pr-mirror($key) resolved: upstream $outcome on $GARDEN_HOST"; then
      return 0
    fi
    rc=$?; [ "$rc" -eq 2 ] && return 0
    backoff
  done
  die "could not stamp resolve on $key after retries"
}

# parse_state <handler-output> -> sets STATE and MERGED globals from a TSV line.
# Must end on a zero-status command (an if/else, not a trailing `&&`) so it never
# trips the caller's `set -e` when the line legitimately carries a tab.
parse_state() {
  STATE="${1%%$'\t'*}"
  if [ "$1" = "$STATE" ]; then MERGED=false; else MERGED="${1#*$'\t'}"; fi
}

acted=0
for i in $(seq 0 $((n-1))); do
  key="${KEYS[$i]}"; up="${UPS[$i]}"; mir="${MIRS[$i]}"
  up_repo="${up%%#*}"; up_num="${up##*#}"
  mir_repo="${mir%%#*}"; mir_num="${mir##*#}"

  if ! out="$("$GARDEN_MIRROR_PR_STATE" "$up_repo" "$up_num")"; then
    die "reading upstream state for $up failed (handler $GARDEN_MIRROR_PR_STATE)"
  fi
  parse_state "$out"
  if [ "$STATE" != closed ]; then
    log "$up still open; mirror $mir left alone"
    continue
  fi

  # Upstream is closed. Determine merged-vs-closed for the comment wording.
  if [ "$MERGED" = true ]; then phrasing="was merged"; outcome=merged
  else                          phrasing="was closed without merging"; outcome=closed; fi

  # Look at our mirror. Only close it if it is still open; otherwise reconcile.
  if ! mout="$("$GARDEN_MIRROR_PR_STATE" "$mir_repo" "$mir_num")"; then
    die "reading mirror state for $mir failed (handler $GARDEN_MIRROR_PR_STATE)"
  fi
  parse_state "$mout"
  if [ "$STATE" = closed ]; then
    log "$up closed ($outcome); mirror $mir already closed — reconciling mapping only"
    mark_resolved "$key" "$outcome"
    continue
  fi

  # Mirror is open → post the comment and close it.
  cbody="$(mktemp)"
  {
    printf 'The upstream pull request %s %s.\n\n' "$(pr_url "$up")" "$phrasing"
    printf 'Closing this mirror to follow. This is an automated action by the\n'
    printf 'garden mirror-closer (deterministic; no LLM in the loop).\n'
  } > "$cbody"
  if ! "$GARDEN_MIRROR_CLOSE" "$mir_repo" "$mir_num" "$cbody"; then
    rm -f "$cbody"
    die "closing mirror $mir failed (handler $GARDEN_MIRROR_CLOSE); leaving mapping unresolved to retry next tick"
  fi
  rm -f "$cbody"
  log "closed mirror $mir because upstream $up $phrasing"
  mark_resolved "$key" "$outcome"
  acted=$((acted+1))
done

log "tick complete: closed $acted mirror(s) this run"
