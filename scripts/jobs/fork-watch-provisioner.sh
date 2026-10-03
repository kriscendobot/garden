#!/bin/bash
# fork-watch-provisioner.sh — map the garden's OWN-FORK bare clones into the
# journal watch sets, so a fork the garden creates is watched without a human.
#
# Usage: fork-watch-provisioner.sh      (no arguments; invoked at the top of every
#                                        repo-watcher.sh tick, and runnable by hand)
#
# ── Why this exists (the missed minion.town approvals) ───────────────────────
# The per-repo watchers are armed from two journal-backed sets that
# repo-watcher.sh reconciles to systemd units: repos/ → garden-triager@<slug>
# (commit watch) and comment-repos/ → garden-comment-watcher@ + garden-ci-watcher@
# (comment + CI). Both sets were provisioned MANUALLY, so watch membership never
# followed fork creation: the garden held a bare clone of kriscendobot/minion.town
# and worked its PRs, yet three kriskowal APPROVED reviews on minion.town#3
# (2026-07-09) went unwatched because nobody had added the slug to either set.
# This script closes that class: the standing bare clones under
# worktrees/<owner>-<name>.git ARE the deterministic record of which forks the
# garden works (ensure-project-worktree.sh cuts every project checkout from them),
# so reconciling that record into the watch sets makes provisioning automatic for
# every creation path — a gardener's by-hand clone, clone-keeper's repair, an
# import script — with no LLM anywhere. Design:
# designs/auto-provision-fork-watchers.md. Maintainer authorization: journal
# broadcast msgs/broadcast/20260709T225552Z-e61229.md (kriskowal, 2026-07-09,
# "watch the garden's own forks").
#
# ── Own forks ONLY (the monitoring-safety line) ───────────────────────────────
# Auto-provisioning is scoped HARD to owners listed in the journal's
# config/fork-owners (the garden's bot logins; seeded: kriscendobot). A bare
# clone of any OTHER owner — upstream, a third party, a contributor's fork — is
# never auto-added: widening surveillance onto a repo we don't own keeps the
# existing explicit per-repo maintainer-authorization bar (CLAUDE.md § Monitoring
# safety constraint). Listed owners must carry no '-' (the <owner>-<name> slug
# convention splits on the FIRST dash); a dashed entry is skipped with a warning.
#
# ── The sender-gate coupling (load-bearing) ───────────────────────────────────
# Own forks may be PUBLIC, so repo-gating (the bar that clears
# endojs/endo-but-for-bots) cannot make their COMMENT surveillance safe. Every
# comment-repos/ arming record this script writes therefore carries
# `sender-gate: required`, which comment-watcher.sh reads and enforces: any
# comment whose author is not on trusted-senders/allowlist, maintainers/allowlist,
# or a current endojs/Agoric org member is dropped in plain code before any text
# reaches a job, a reactji, or `claude -p` (the same substitute defense as
# mention-watcher.sh). This script is the ONLY writer of own-fork comment-repos
# entries and ships in the same tree as the comment-watcher's gate, so an own
# fork can never be comment-armed by a deployed tree that lacks the gate. The
# ci-watcher rides the same set and reads only CI status (no external text) — no
# extra surface. The commit triager (repos/) reads our own fork's commits.
#
# ── Issues-disabled forks are fine to arm (no has_issues gate here) ───────────
# A fork defaults to has_issues:false, which permanently 404s the repo-wide
# GET /repos/<repo>/issues/comments surface. That is NOT a reason to withhold or
# gate arming: comment-source-gh.sh detects the disabled state authoritatively
# (a cached has_issues probe on the already-404'd path) and degrades to a
# per-open-PR /issues/<n>/comments walk that still recovers surface=pr-comment,
# so the watch works unchanged on such a fork. We deliberately do NOT probe
# has_issues at arming time (it would cost a read on every healthy tick to gate
# a case the source already handles); the note lives in the arming record's
# rationale so the next reader isn't surprised by the 404 in the journal blob.
#
# ── Unwatch stays meaningful: the opt-out tombstone ───────────────────────────
# Deleting repos/<slug> or comment-repos/<slug> is the established unwatch signal
# — but a reconciler would re-add it on the next tick. To unwatch an
# auto-provisioned own fork durably, ALSO add a journal watch-optout/<slug> file
# (any content); the provisioner never re-adds a tombstoned slug. Removing the
# tombstone re-enables auto-provisioning.
#
# ── What one tick does ────────────────────────────────────────────────────────
#   1. DISCOVER (every host): scan $GARDEN_WORKTREES/*.git for slugs whose owner
#      is in config/fork-owners; for each not tombstoned, confirm the upstream fork
#      still EXISTS (cheap read-only `gh api repos/<owner>/<name>`) — before arming
#      one missing from repos/ or comment-repos/, and on a four-hourly liveness
#      beat for one already armed in both. A leftover clone of a DELETED/renamed
#      fork 404s and is auto-tombstoned instead of armed, and an armed fork whose
#      upstream is deleted LATER is retired the same way (the kriscendobot/garden
#      and kriscendobot/chrome-native-function-caller-arguments-repro 404-flap
#      class), so watchers that would only FATAL are never created and never
#      outlive their repo; otherwise CAS-land the missing arming record(s) — one
#      commit, retried through the standard sync/commit_and_push loop, idempotent
#      (a peer landing first makes ours a no-op).
#   2. MATERIALIZE (leader only): the triager hard-requires a bare clone at
#      $GARDEN_REPOS/<slug>.git and the per-repo units are leader-gated, so for
#      every own-fork slug armed in repos/ whose clone is missing on THIS host,
#      clone it (bounded, staged into a sibling temp, atomically mv -T'd — the
#      clone-keeper discipline) so a just-armed triager never dies "no bare
#      clone". A persistent clone failure throttle-escalates to the maintainer.
#
# Inert until config/fork-owners exists on origin/journal2 — writing it is the
# deliberate arming act, so deploying this script is harmless (the issue-inbox
# arming shape).
#
# Config (overridable; tests point these at fixtures):
#   GARDEN_FORKWATCH_CLONE        journal clone this producer works in
#   GARDEN_WORKTREES              standing bare-clone shelf (default worktrees/)
#   GARDEN_REPOS                  triager clone shelf (default worktrees/) —
#                                 MUST match triager.sh's GARDEN_REPOS default so
#                                 a clone materialized here lands where the triager
#                                 reads it (see the default below)
#   GARDEN_FORK_CLONE_URL_BASE    clone-URL base for materialization
#                                 (default ssh://git@github.com)
#   GARDEN_FORKWATCH_MATERIALIZE  1 force on, 0 force off, empty → is_main_host
#   GARDEN_FORKWATCH_LIVENESS_INTERVAL
#                                 seconds between liveness probes for an already
#                                 fully armed fork (default 14400 / four hours;
#                                 0 probes on every tick, useful to tests)

set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=common.sh
source "$HERE/common.sh"
export GARDEN_TAG="fork-watch"

: "${GARDEN_WORKTREES:=$GARDEN_ROOT/worktrees}"
# The triager shelf MUST agree with triager.sh (and comment-watcher.sh), whose
# GARDEN_REPOS default is worktrees/ — the garden's standing bare clones live at
# worktrees/<owner>-<name>.git per CLAUDE.md § Layout, and no repos/ dir exists.
# When this defaulted to repos/ the leader materialized each armed fork's clone
# into repos/<slug>.git while the triager looked in worktrees/<slug>.git, so a
# just-armed fork (e.g. kriscendobot-cosgov, armed 2026-07-10) was never actually
# cloned where the triager reads and garden-triager@<slug> either skipped forever
# or FATAL-stormed "no bare clone at .../repos/<slug>.git". Keep it equal to
# GARDEN_WORKTREES so materialize-here lands where triage-reads.
: "${GARDEN_REPOS:=$GARDEN_ROOT/worktrees}"
: "${GARDEN_FORK_CLONE_URL_BASE:=ssh://git@github.com}"
: "${GARDEN_FORKWATCH_MATERIALIZE:=}"
: "${GARDEN_FORKWATCH_LIVENESS_INTERVAL:=14400}"
AUTH_MSG="msgs/broadcast/20260709T225552Z-e61229.md"

case "$GARDEN_FORKWATCH_LIVENESS_INTERVAL" in
  ''|*[!0-9]*)
    log "WARN: GARDEN_FORKWATCH_LIVENESS_INTERVAL must be a non-negative number of seconds; using 14400"
    GARDEN_FORKWATCH_LIVENESS_INTERVAL=14400
    ;;
esac

fleet_draining && { log "fleet draining; skipping"; exit 0; }

DIR="${GARDEN_FORKWATCH_CLONE:-$GARDEN_STATE/fork-watch/journal}"
ensure_clone "$DIR"
sync_clone "$DIR"     # may exit EX_TEMPFAIL on a connectivity outage — skip tick

tip_has() {  # tip_has <journal2-relative-path>
  git -C "$DIR" cat-file -e "origin/$JOURNAL_BRANCH:$1" 2>/dev/null
}

# --- the own-fork owner set (journal data; extensible, no code change) --------
# config/fork-owners on origin/journal2: one GitHub login per line, '#' comments
# and blanks ignored, case-insensitive. Absent/empty → this script is INERT.
declare -a OWNERS=()
while IFS= read -r line; do
  line="${line%%#*}"; line="$(printf '%s' "$line" | tr -d '[:space:]' | tr '[:upper:]' '[:lower:]')"
  [ -n "$line" ] || continue
  case "$line" in
    *-*) log "WARN: config/fork-owners entry '$line' contains '-' (ambiguous against the <owner>-<name> slug split); skipping it"; continue ;;
  esac
  OWNERS+=("$line")
done < <(git -C "$DIR" show "origin/$JOURNAL_BRANCH:config/fork-owners" 2>/dev/null || true)

if [ "${#OWNERS[@]}" -eq 0 ]; then
  log "inert: no fork owners configured (config/fork-owners absent or empty on origin/$JOURNAL_BRANCH)"
  clone_unlock "$DIR"
  exit 0
fi

owner_listed() {  # owner_listed <lowercase-login>
  local o
  for o in "${OWNERS[@]}"; do [ "$o" = "$1" ] && return 0; done
  return 1
}

# slug_owner_lc <slug> — the owner half of the FIRST-dash split, lowercased.
slug_owner_lc() { printf '%s' "${1%%-*}" | tr '[:upper:]' '[:lower:]'; }

# --- dead-upstream guard (the kriscendobot/garden 404-flap class) -------------
# A bare clone whose upstream fork was DELETED or RENAMED on GitHub still sits in
# the worktrees shelf, so DISCOVER would re-arm repos/ + comment-repos/ for it and
# all three per-repo watchers (garden-triager@, garden-comment-watcher@,
# garden-ci-watcher@) would FATAL-flap against a 404 repo every tick — exactly what
# a stale worktrees/kriscendobot-garden.git did after kriscendobot/garden was
# deleted. Before arming a NOT-yet-armed own fork we therefore confirm the upstream
# still exists with a cheap read-only `gh api repos/<owner>/<name>` (bot identity,
# via the fleet gh wrapper). Fully armed forks also need that check: their upstream
# can be deleted later. To avoid probing every clone on every one-minute tick, each
# host records a successful probe in its local state and revisits a fully armed fork
# only once per four hours. A 404 is therefore self-healed within four hours plus
# one tick; an inconclusive probe deliberately leaves no stamp, so it retries rather
# than silently extending the interval.
#
# RETIRING an ARMED fork is deliberately HARDER than declining to arm an unarmed
# one: declining costs a tick, retiring tears down a live watch set (four unit
# families) and writes a tombstone only a human removes. Two guards therefore sit
# on the armed path only:
#   * a CONFIRM re-check — a first definitive 404 is re-probed once, and anything
#     but a second definitive 404 defers to the next tick, so a one-off 404 (a
#     rename mid-flight, an eventual-consistency blip) cannot retire a live fork;
#   * a MASS-404 breaker — if EVERY armed fork probed this tick 404s and there are
#     at least two of them, that is a systemic read failure, not N deleted forks
#     (a degraded token reads a PRIVATE fork as 404, not as 401), so no armed fork
#     is retired this tick and the maintainer is alerted. A mixed tick (some armed
#     forks still resolve) is exactly the "one fork really was deleted" case and
#     retires normally.
# Neither guard touches UNARMED candidates: not arming a dead clone is cheap and
# reversible, so it keeps the single-probe bar.
#
# upstream_exists <owner> <name> — exit 0 exists, 1 upstream 404s (dead fork),
# 2 the check itself was inconclusive (network/auth/rate-limit) so the caller
# treats it as "unknown" and neither arms nor tombstones this tick. On rc 2 it sets
# UPSTREAM_FAIL_CLASS (normalized, see probe_fail_class) and UPSTREAM_FAIL_DETAIL
# (the exit status plus bounded normalized output, or an explicit no-output
# marker) and logs NOTHING: the caller coalesces the
# warning through the inconclusive cooldown below. Overridable via
# GARDEN_FORKWATCH_UPSTREAM_CHECK (a command run as `<cmd> <owner> <name>` whose
# exit status is used verbatim and whose output is classified the same way) so
# the test harness can drive it with no GitHub. The production probe goes through
# gh_api_retry: besides absorbing a transient blip, that helper admits the request
# under the host-shared GitHub API cooldown lock and latches primary-quota
# refusals before another poller can issue a doomed request.
upstream_exists() {
  local owner="$1" name="$2" out rc detail
  UPSTREAM_FAIL_CLASS=""; UPSTREAM_FAIL_DETAIL=""; UPSTREAM_FAIL_SILENT=""
  if [ -n "${GARDEN_FORKWATCH_UPSTREAM_CHECK:-}" ]; then
    if out="$("$GARDEN_FORKWATCH_UPSTREAM_CHECK" "$owner" "$name" 2>&1)"; then rc=0; else rc=$?; fi
    [ "$rc" -eq 2 ] || return "$rc"
  elif out="$(gh_api_retry "repos/$owner/$name" --jq .id 2>&1)"; then
    return 0
  else
    rc=$?
    case "$out" in
      *"Not Found"*|*"HTTP 404"*|*'"status":"404"'*) return 1 ;;
    esac
  fi
  UPSTREAM_FAIL_CLASS="$(probe_fail_class "$out")"
  detail="$(printf '%s' "$out" | tr -s '[:space:]' ' ' | cut -c1-180)"
  if [ -n "$detail" ]; then
    UPSTREAM_FAIL_DETAIL="rc=$rc: $detail"
  else
    UPSTREAM_FAIL_DETAIL="rc=$rc (no output)"
    UPSTREAM_FAIL_SILENT=1
  fi
  return 2
}

# --- inconclusive-probe cooldown (one condition → one warning, not one per fork) --
# An inconclusive probe is almost always ONE shared GitHub condition (a rate limit,
# an auth lapse, a 5xx, a network outage), not N per-fork facts. Probing every
# armed fork anyway re-hits the same wall and, since repo-watcher runs this every
# minute, logged two WARNs per fork per tick across the whole fleet (observed
# 2026-09-30 11:21:53-11:40:03). So the first inconclusive probe of a tick
# normalizes its failure CLASS and, for a host-wide class, stops every further
# probe for the rest of the tick and records a host-local, bounded cooldown window
# keyed by that class; later ticks skip probing silently until it expires. One
# coalesced WARN is emitted only by the tick that opens a window. Deferral stays
# fail-open: a skipped fork is neither armed nor tombstoned nor retired, exactly
# as a single inconclusive probe always was.
#
# A repository-specific refusal (a plain 403/451 with no rate-limit wording) says
# nothing about the other forks, so its class is keyed per slug
# (repo-denied@<slug>) and defers only that fork. The slug that opened the last
# host-wide window is probed LAST on the next attempt, so one oddly failing fork
# cannot starve the rest of the fleet window after window.
#
# GARDEN_FORKWATCH_INCONCLUSIVE_COOLDOWN_SECS: base window length (default 300,
# capped at 3600). A silent inconclusive probe doubles the window after each
# consecutive retry, up to the same 3600-second bound; any successful probe
# resets that backoff. 0 keeps the halt-for-this-tick coalescing but records no
# window or escalation state.
: "${GARDEN_FORKWATCH_INCONCLUSIVE_COOLDOWN_SECS:=300}"
case "$GARDEN_FORKWATCH_INCONCLUSIVE_COOLDOWN_SECS" in
  ''|*[!0-9]*)
    log "WARN: GARDEN_FORKWATCH_INCONCLUSIVE_COOLDOWN_SECS must be a non-negative number of seconds; using 300"
    GARDEN_FORKWATCH_INCONCLUSIVE_COOLDOWN_SECS=300
    ;;
esac
[ "$GARDEN_FORKWATCH_INCONCLUSIVE_COOLDOWN_SECS" -le 3600 ] || GARDEN_FORKWATCH_INCONCLUSIVE_COOLDOWN_SECS=3600
PROBE_COOLDOWN_DIR="$GARDEN_STATE/fork-watch/inconclusive-cooldown"
SILENT_BACKOFF_FILE="$PROBE_COOLDOWN_DIR/silent-failures"

probe_fail_class() {  # probe_fail_class <output> → a normalized class key
  local lc
  lc="$(printf '%s' "$1" | tr '[:upper:]' '[:lower:]')"
  case "$lc" in
    *"rate limit"*|*"rate-limit"*|*"ratelimit"*|*"abuse detection"*|*"quota"*) echo rate-limit ;;
    *"http 401"*|*"bad credentials"*|*"gh auth login"*|*"authentication"*|*"token"*) echo auth ;;
    *"http 403"*|*"http 451"*) echo repo-denied ;;
    *"http 5"[0-9][0-9]*|*"server error"*|*"bad gateway"*|*"service unavailable"*|*"gateway time"*) echo server ;;
    *"could not resolve"*|*"timeout"*|*"timed out"*|*"connection"*|*"tls"*|*"eof"*|*"network"*|*"no such host"*) echo network ;;
    *) echo unclassified ;;
  esac
}

probe_cooldown_live() {  # probe_cooldown_live <key> — rc 0 = a live window; expired markers removed
  local m="$PROBE_COOLDOWN_DIR/$1" expiry
  [ -f "$m" ] || return 1
  expiry="$(sed -n '1p' "$m" 2>/dev/null || true)"
  case "$expiry" in ''|*[!0-9]*) expiry=0 ;; esac
  [ "$expiry" -gt "$(date +%s)" ] && return 0
  rm -f "$m"
  return 1
}

global_cooldown_live() {  # rc 0 = some HOST-WIDE class window is live
  local m
  [ -d "$PROBE_COOLDOWN_DIR" ] || return 1
  for m in "$PROBE_COOLDOWN_DIR"/*; do
    [ -f "$m" ] || continue
    case "${m##*/}" in repo-denied@*|last-tripper|silent-failures) continue ;; esac
    probe_cooldown_live "${m##*/}" && return 0
  done
  return 1
}

open_probe_cooldown() {  # open_probe_cooldown <key> <slug> <detail> [secs]; rc 0 = window opened (or tick-only)
  local m="$PROBE_COOLDOWN_DIR/$1" tmp secs="${4:-$GARDEN_FORKWATCH_INCONCLUSIVE_COOLDOWN_SECS}"
  OPENED_COOLDOWN_SECS="$secs"
  [ "$secs" -gt 0 ] || return 0
  probe_cooldown_live "$1" && return 1    # a live window is never extended
  mkdir -p "$PROBE_COOLDOWN_DIR"
  tmp="$m.$$.tmp"
  printf '%s\n%s\n%s\n%s\n' "$(( $(date +%s) + secs ))" "$2" "$3" "$secs" > "$tmp"
  mv -f "$tmp" "$m"
}

next_silent_probe_cooldown() {  # print the next bounded exponential window
  local level=0 remaining duration="$GARDEN_FORKWATCH_INCONCLUSIVE_COOLDOWN_SECS"
  [ "$duration" -gt 0 ] || { printf '0\n'; return 0; }
  if [ -f "$SILENT_BACKOFF_FILE" ]; then
    level="$(sed -n '1p' "$SILENT_BACKOFF_FILE" 2>/dev/null || true)"
    case "$level" in ''|*[!0-9]*) level=0 ;; esac
  fi
  # The cap is reached in at most five steps with the default base. Limit a
  # corrupt/hand-edited level too, so arithmetic and loop time stay bounded.
  [ "$level" -le 31 ] || level=31
  remaining="$level"
  while [ "$remaining" -gt 0 ] && [ "$duration" -lt 3600 ]; do
    duration=$((duration * 2))
    [ "$duration" -le 3600 ] || duration=3600
    remaining=$((remaining - 1))
  done
  mkdir -p "$PROBE_COOLDOWN_DIR"
  printf '%s\n' "$((level + 1))" > "$SILENT_BACKOFF_FILE"
  printf '%s\n' "$duration"
}

reset_silent_probe_backoff() {
  [ -e "$SILENT_BACKOFF_FILE" ] || return 0
  rm -f "$SILENT_BACKOFF_FILE"
}

liveness_probe_due() {  # liveness_probe_due <slug>
  # State is deliberately per-host and untracked: it rate-limits API reads without
  # creating journal churn or a cross-host CAS for every healthy fork.
  local slug="$1" stamp="$GARDEN_STATE/fork-watch/liveness/$1" now stamp_mtime
  [ "$GARDEN_FORKWATCH_LIVENESS_INTERVAL" -eq 0 ] && return 0
  [ -f "$stamp" ] || return 0
  now="$(date +%s)"
  stamp_mtime="$(stat -c %Y "$stamp" 2>/dev/null || printf 0)"
  [ $((now - stamp_mtime)) -ge "$GARDEN_FORKWATCH_LIVENESS_INTERVAL" ]
}

mark_liveness_probe() {  # mark_liveness_probe <slug>
  local stamp="$GARDEN_STATE/fork-watch/liveness/$1"
  mkdir -p "${stamp%/*}"
  touch "$stamp"
}

write_dead_tombstone() {  # write_dead_tombstone <out-path> <owner/name>
  {
    printf '# watch-optout tombstone (auto — dead upstream)\n'
    printf 'unwatched: %s\n' "$2"
    printf 'reason: upstream 404 (deleted or renamed fork)\n'
    printf 'tombstoned_at: %s\n' "$(date -u +%FT%TZ)"
    printf 'tombstoned_by: scripts/jobs/fork-watch-provisioner.sh\n'
    printf 'note: A bare clone worktrees/%s.git exists on a garden host but\n' "${2//\//-}"
    printf '  gh api repos/%s returned 404, so arming the per-repo watchers would\n' "$2"
    printf '  only FATAL-flap every tick (the kriscendobot/garden class). Auto-\n'
    printf '  tombstoned so the reconciler never re-adds it. Remove this file only\n'
    printf '  after the upstream repo exists again AND the stale bare clone is\n'
    printf '  refreshed. Design: designs/auto-provision-fork-watchers.md.\n'
  } > "$1"
}

# --- 1. DISCOVER: local own-fork bare clones and upstream liveness ------------
declare -a NEW=()
declare -a DEAD=()
declare -a ARMED_DEAD=()   # the subset of DEAD that is currently armed (retirements)
ARMED_PROBED=0             # armed forks actually probed this tick (breaker denominator)
declare -a DEFERRED=()     # forks left unprobed/undecided by an inconclusive condition
declare -a WARNED=()       # "class: detail" of each cooldown THIS tick opened
HALTED=""                  # a host-wide inconclusive class stopped probing this tick
PREEXISTING_WINDOW=""
global_cooldown_live && PREEXISTING_WINDOW=1

# note_inconclusive <slug> — route an rc-2 probe through the class cooldown.
note_inconclusive() {
  local key="$UPSTREAM_FAIL_CLASS" window="$GARDEN_FORKWATCH_INCONCLUSIVE_COOLDOWN_SECS"
  DEFERRED+=("$1")
  if [ "$key" = repo-denied ]; then
    key="repo-denied@$1"
  else
    HALTED="$key"
    mkdir -p "$PROBE_COOLDOWN_DIR"
    printf '%s\n' "$1" > "$PROBE_COOLDOWN_DIR/last-tripper"
  fi
  [ -z "$UPSTREAM_FAIL_SILENT" ] || window="$(next_silent_probe_cooldown)"
  open_probe_cooldown "$key" "$1" "$UPSTREAM_FAIL_DETAIL" "$window" \
    && WARNED+=("$key (first seen on $1: $UPSTREAM_FAIL_DETAIL; cooldown ${OPENED_COOLDOWN_SECS}s)")
  return 0
}

shopt -s nullglob
declare -a BARES=()
last_tripper="$(cat "$PROBE_COOLDOWN_DIR/last-tripper" 2>/dev/null || true)"
tripper_bare=""
for bare in "$GARDEN_WORKTREES"/*.git; do
  if [ -n "$last_tripper" ] && [ "$(basename "$bare" .git)" = "$last_tripper" ]; then
    tripper_bare="$bare"
  else
    BARES+=("$bare")
  fi
done
shopt -u nullglob
[ -n "$tripper_bare" ] && BARES+=("$tripper_bare")

for bare in ${BARES[@]+"${BARES[@]}"}; do
  slug="$(basename "$bare" .git)"
  case "$slug" in *-*) ;; *) continue ;; esac          # no owner/name split → not a fork shelf entry
  owner_listed "$(slug_owner_lc "$slug")" || continue  # own forks ONLY
  [ -f "$bare/HEAD" ] || continue                      # not actually a bare repo
  tip_has "watch-optout/$slug" && continue             # deliberately unwatched — never re-add
  armed=""
  if tip_has "repos/$slug" && tip_has "comment-repos/$slug"; then
    armed=1
    liveness_probe_due "$slug" || continue
  fi
  # A live inconclusive-class window (host-wide, or this fork's own refusal)
  # defers the probe entirely: fail-open, no arm, no tombstone, no WARN.
  if [ -n "$HALTED" ] || [ -n "$PREEXISTING_WINDOW" ] || probe_cooldown_live "repo-denied@$slug"; then
    DEFERRED+=("$slug")
    continue
  fi
  # Confirm the upstream before arming, and periodically after full arming: a
  # leftover clone of a DELETED/renamed fork would otherwise arm (or continue to
  # run) watchers that only ever FATAL. 404 → auto-tombstone; an inconclusive
  # check → defer, neither arm nor tombstone.
  owner="${slug%%-*}"; name="${slug#*-}"
  # Guarded capture (NOT a bare `upstream_exists ...; ur=$?`): a function that
  # returns non-zero in bare-command position is a `set -e` exit at the call
  # itself, which would kill the tick before we could classify 404 vs unknown.
  if upstream_exists "$owner" "$name"; then ur=0; else ur=$?; fi
  [ "$ur" -ne 0 ] || reset_silent_probe_backoff
  [ -n "$armed" ] && ARMED_PROBED=$((ARMED_PROBED + 1))
  if [ "$ur" -eq 1 ]; then
    if [ -n "$armed" ]; then
      # Confirm re-check: retiring a LIVE watch set on a single fluke 404 is the
      # expensive mistake, so demand a second definitive 404 before believing it.
      if upstream_exists "$owner" "$name"; then cr=0; else cr=$?; fi
      [ "$cr" -ne 0 ] || reset_silent_probe_backoff
      if [ "$cr" -eq 2 ]; then
        note_inconclusive "$slug"
        continue
      elif [ "$cr" -ne 1 ]; then
        log "WARN: $slug upstream ($owner/$name) 404 NOT confirmed on re-check (rc=$cr) — leaving its armed watch set intact this tick"
        continue
      fi
      ARMED_DEAD+=("$slug")
    fi
    log "WARN: $slug upstream ($owner/$name) 404s — auto-tombstoning watch-optout/$slug"
    DEAD+=("$slug")
    continue
  elif [ "$ur" -eq 2 ]; then
    note_inconclusive "$slug"
    continue
  fi
  if [ -n "$armed" ]; then
    mark_liveness_probe "$slug"
  else
    NEW+=("$slug")
  fi
done

if [ "${#WARNED[@]}" -gt 0 ]; then
  if [ "$GARDEN_FORKWATCH_INCONCLUSIVE_COOLDOWN_SECS" -gt 0 ]; then
    window="opening bounded cooldown(s)"
  else
    window="stopped probing for this tick"
  fi
  log "WARN: upstream checks inconclusive [$(IFS=';'; printf '%s' "${WARNED[*]}")] — $window; deferring ${#DEFERRED[@]} fork(s) (neither armed, tombstoned, nor retired): ${DEFERRED[*]}"
fi

# A tick whose probing was cut short by a host-wide inconclusive condition never
# RETIRES an armed fork: that condition may be the same read-side failure the
# mass-404 breaker below guards against, seen only partially. Retirement waits
# for a clean tick (declining to arm and tombstoning unarmed clones are cheap and
# keep their single-probe bar).
if [ -n "$HALTED" ] && [ "${#ARMED_DEAD[@]}" -gt 0 ]; then
  log "WARN: deferring retirement of ${ARMED_DEAD[*]} — this tick's probes halted on an inconclusive '$HALTED' condition"
  declare -a KEPT=()
  for slug in "${DEAD[@]}"; do
    suppressed=""
    for a in "${ARMED_DEAD[@]}"; do [ "$a" = "$slug" ] && suppressed=1 && break; done
    [ -n "$suppressed" ] || KEPT+=("$slug")
  done
  DEAD=(${KEPT[@]+"${KEPT[@]}"})
  ARMED_DEAD=()
fi

# --- 1a. mass-404 breaker: never retire EVERY armed fork in one tick ----------
# Two or more armed forks reading 404 while NONE reads live is a read-side
# failure (a token that lost repo scope sees every PRIVATE own fork as 404), not
# a maintainer deleting the whole fleet's forks at once. Suppress the armed
# retirements — the confirm re-check cannot catch this, since both probes ride the
# same broken credential — and alert. Unarmed candidates keep their (cheap,
# reversible) decline-to-arm tombstone.
if [ "${#ARMED_DEAD[@]}" -ge 2 ] && [ "${#ARMED_DEAD[@]}" -eq "$ARMED_PROBED" ]; then
  msg="fork-watch: ALL $ARMED_PROBED armed own-fork upstream probes 404'd this tick (${ARMED_DEAD[*]}) — treating that as a read-side failure (a gh token that lost repo scope reads a private fork as 404) rather than as $ARMED_PROBED deleted forks, so NO armed watch set was retired. If those forks really are gone, tombstone them by hand (journal watch-optout/<slug> + git rm repos/<slug> comment-repos/<slug>); otherwise check the bot token's scopes."
  log "WARN: $msg"
  alert_maintainer "fork-watch-mass-404" "$msg"
  declare -a KEPT=()
  for slug in "${DEAD[@]}"; do
    suppressed=""
    for a in "${ARMED_DEAD[@]}"; do [ "$a" = "$slug" ] && suppressed=1 && break; done
    [ -n "$suppressed" ] || KEPT+=("$slug")
  done
  DEAD=("${KEPT[@]}")
fi

# --- 1b. auto-tombstone dead-upstream forks (durable, so no re-arm) -----------
if [ "${#DEAD[@]}" -gt 0 ]; then
  log "discovered ${#DEAD[@]} own-fork clone(s) whose upstream 404s: ${DEAD[*]} — auto-tombstoning"
  for attempt in $(seq 1 50); do
    sync_clone "$DIR"
    for slug in "${DEAD[@]}"; do
      tip_has "watch-optout/$slug" && continue   # tombstoned by a racing peer
      owner="${slug%%-*}"; name="${slug#*-}"
      mkdir -p "$DIR/watch-optout"
      write_dead_tombstone "$DIR/watch-optout/$slug" "$owner/$name"
      git -C "$DIR" add "watch-optout/$slug"
      # drop any stale/partial arming records so the tombstone fully closes it
      for rec in "repos/$slug" "comment-repos/$slug"; do
        [ -e "$DIR/$rec" ] && git -C "$DIR" rm -q "$rec"
      done
    done
    if git -C "$DIR" diff --cached --quiet; then
      log "dead-fork tombstone(s) already at tip (a peer won the race) — no-op"
      break
    fi
    if commit_and_push "$DIR" "fork-watch: auto-tombstone dead-upstream fork(s) ${DEAD[*]} (gh 404)"; then
      log "auto-tombstoned ${DEAD[*]} (watch-optout) on origin/$JOURNAL_BRANCH"
      break
    fi
    backoff "$attempt"
  done
fi

write_triager_record() {  # write_triager_record <out-path> <owner/name>
  {
    printf '# garden-triager arming record (auto-provisioned)\n'
    printf 'repo: %s\n' "$2"
    printf 'armed_at: %s\n' "$(date -u +%FT%TZ)"
    printf 'authorized_by: kriskowal\n'
    printf 'authorization: %s ("watch the garden'\''s own forks",\n' "$AUTH_MSG"
    printf '  2026-07-09). Own-fork commit triage (the laxer repos/ bar), added\n'
    printf '  automatically by scripts/jobs/fork-watch-provisioner.sh because a bare\n'
    printf '  clone of this own fork exists on a garden host. Design:\n'
    printf '  designs/auto-provision-fork-watchers.md. To unwatch durably, delete this\n'
    printf '  file AND add watch-optout/%s.\n' "${2//\//-}"
  } > "$1"
}

write_comment_record() {  # write_comment_record <out-path> <owner/name>
  {
    printf '# garden-comment-watcher arming record (auto-provisioned)\n'
    printf 'repo: %s\n' "$2"
    printf 'sender-gate: required\n'
    printf 'armed_at: %s\n' "$(date -u +%FT%TZ)"
    printf 'authorized_by: kriskowal\n'
    printf 'authorization: %s ("watch the garden'\''s own forks",\n' "$AUTH_MSG"
    printf '  2026-07-09), added automatically by\n'
    printf '  scripts/jobs/fork-watch-provisioner.sh. Own forks may be PUBLIC, so\n'
    printf '  repo-gating cannot clear their comment surveillance; the sender-gate:\n'
    printf '  required line above makes comment-watcher.sh drop any comment whose\n'
    printf '  author is not on trusted-senders/allowlist, maintainers/allowlist, or a\n'
    printf '  current endojs/Agoric org member — in plain code, before any text\n'
    printf '  reaches a job, a reactji, or claude -p. The ci-watcher rides this same\n'
    printf '  set and reads only CI status. Design:\n'
    printf '  designs/auto-provision-fork-watchers.md.\n'
    printf '  NOTE: a fork with the Issues feature OFF (has_issues:false, the GitHub\n'
    printf '  default for a fork) permanently 404s the repo-wide issues/comments\n'
    printf '  surface; comment-source-gh.sh recognizes that (authoritative has_issues\n'
    printf '  probe) and degrades to a per-open-PR walk rather than crash-looping — so\n'
    printf '  this arming is correct as-is and needs no has_issues gate. To unwatch\n'
    printf '  durably, delete this file AND add watch-optout/%s.\n' "${2//\//-}"
  } > "$1"
}

if [ "${#NEW[@]}" -gt 0 ]; then
  log "discovered ${#NEW[@]} own fork(s) missing watch membership: ${NEW[*]}"
  landed=""
  for attempt in $(seq 1 50); do
    sync_clone "$DIR"
    for slug in "${NEW[@]}"; do
      tip_has "watch-optout/$slug" && continue   # tombstoned by a racing peer
      owner="${slug%%-*}"; name="${slug#*-}"
      if [ ! -e "$DIR/repos/$slug" ]; then
        mkdir -p "$DIR/repos"
        write_triager_record "$DIR/repos/$slug" "$owner/$name"
        git -C "$DIR" add "repos/$slug"
      fi
      if [ ! -e "$DIR/comment-repos/$slug" ]; then
        mkdir -p "$DIR/comment-repos"
        write_comment_record "$DIR/comment-repos/$slug" "$owner/$name"
        git -C "$DIR" add "comment-repos/$slug"
      fi
    done
    if git -C "$DIR" diff --cached --quiet; then
      log "watch membership already landed at tip (a peer won the race) — no-op"
      landed=1; break
    fi
    if commit_and_push "$DIR" "fork-watch: auto-provision ${NEW[*]} (auth $AUTH_MSG)"; then
      log "armed ${NEW[*]} in repos/ + comment-repos/ (sender-gated) on origin/$JOURNAL_BRANCH"
      landed=1; break
    fi
    backoff "$attempt"
  done
  if [ -z "$landed" ]; then
    # Never wedge the tick: the next tick retries, and repo-watcher's reconcile
    # of the already-armed set must still run.
    log "WARN: could not land watch membership for ${NEW[*]} after retries; retrying next tick"
  fi
fi

# --- 2. MATERIALIZE (leader only): triager clones for armed own forks ---------
# triager.sh dies without a bare clone at $GARDEN_REPOS/<slug>.git, and the
# per-repo units are leader-gated, so the leader must hold the clone. Staged
# into a sibling temp and atomically mv -T'd so a partial/timed-out or racing
# clone never half-populates the tracked path (the clone-keeper discipline).
materialize=""
case "$GARDEN_FORKWATCH_MATERIALIZE" in
  1) materialize=1 ;;
  0) : ;;
  *) is_main_host && materialize=1 ;;
esac

if [ -n "$materialize" ]; then
  while IFS= read -r slug; do
    [ -n "$slug" ] || continue
    [ "$slug" = .gitkeep ] && continue
    owner_listed "$(slug_owner_lc "$slug")" || continue   # only own forks; hand-armed repos are the operator's clone
    tb="$GARDEN_REPOS/$slug.git"
    [ -e "$tb" ] && continue
    owner="${slug%%-*}"; name="${slug#*-}"
    src="$GARDEN_FORK_CLONE_URL_BASE/$owner/$name.git"
    tmp="${tb%.git}.provision.$$.git"
    rm -rf "$tmp"
    mkdir -p "$GARDEN_REPOS"
    if timeout --kill-after="$GARDEN_FETCH_KILL_AFTER" "$GARDEN_FETCH_TIMEOUT" \
         git clone -q --bare "$src" "$tmp" 2>/dev/null; then
      git -C "$tmp" config remote.origin.fetch '+refs/heads/*:refs/remotes/origin/*' || true
      if mv -T "$tmp" "$tb" 2>/dev/null; then
        log "materialized triager clone $tb from $src"
      else
        rm -rf "$tmp"   # a racing tick landed it first — theirs stands
      fi
    else
      rm -rf "$tmp"
      msg="fork-watch: could not clone $src into $tb — the armed garden-triager@$slug will die 'no bare clone' every tick until this clone exists. Retried next tick; if it persists the source is unreachable from this host (ssh key/auth?) and needs manual attention."
      log "WARN: $msg"
      alert_maintainer "fork-watch-clone-failed-$slug" "$msg"
    fi
  done < <(git -C "$DIR" ls-tree --name-only "origin/$JOURNAL_BRANCH" repos/ 2>/dev/null | sed 's|^repos/||')
fi

clone_unlock "$DIR"
