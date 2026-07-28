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
# ── Unwatch stays meaningful: the opt-out tombstone ───────────────────────────
# Deleting repos/<slug> or comment-repos/<slug> is the established unwatch signal
# — but a reconciler would re-add it on the next tick. To unwatch an
# auto-provisioned own fork durably, ALSO add a journal watch-optout/<slug> file
# (any content); the provisioner never re-adds a tombstoned slug. Removing the
# tombstone re-enables auto-provisioning.
#
# ── What one tick does ────────────────────────────────────────────────────────
#   1. DISCOVER (every host): scan $GARDEN_WORKTREES/*.git for slugs whose owner
#      is in config/fork-owners; for each not tombstoned and missing from
#      repos/ or comment-repos/ at the origin tip, first confirm the upstream fork
#      still EXISTS (cheap read-only `gh api repos/<owner>/<name>`) — a leftover
#      clone of a DELETED/renamed fork 404s and is auto-tombstoned instead of armed
#      (the kriscendobot/garden 404-flap class), so watchers that would only FATAL
#      are never created; otherwise CAS-land the missing arming record(s) — one
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
GARDEN_TAG="fork-watch"

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
# upstream_exists <owner> <name> — exit 0 exists, 1 upstream 404s (dead fork),
# 2 the check itself was inconclusive (network/auth/rate-limit) so the caller
# treats it as "unknown" and neither arms nor tombstones this tick. Overridable
# via GARDEN_FORKWATCH_UPSTREAM_CHECK (a command run as `<cmd> <owner> <name>`
# whose exit status is used verbatim) so the test harness can drive it with no
# GitHub.
upstream_exists() {
  local owner="$1" name="$2" out
  if [ -n "${GARDEN_FORKWATCH_UPSTREAM_CHECK:-}" ]; then
    "$GARDEN_FORKWATCH_UPSTREAM_CHECK" "$owner" "$name"
    return
  fi
  if out="$(gh api "repos/$owner/$name" --jq .id 2>&1)"; then
    return 0
  fi
  case "$out" in
    *"Not Found"*|*"HTTP 404"*|*'"status":"404"'*) return 1 ;;
    *) log "WARN: upstream check for $owner/$name inconclusive: $out"; return 2 ;;
  esac
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
shopt -s nullglob
for bare in "$GARDEN_WORKTREES"/*.git; do
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
  # Confirm the upstream before arming, and periodically after full arming: a
  # leftover clone of a DELETED/renamed fork would otherwise arm (or continue to
  # run) watchers that only ever FATAL. 404 → auto-tombstone; an inconclusive
  # check → defer, neither arm nor tombstone.
  owner="${slug%%-*}"; name="${slug#*-}"
  # Guarded capture (NOT a bare `upstream_exists ...; ur=$?`): a function that
  # returns non-zero in bare-command position is a `set -e` exit at the call
  # itself, which would kill the tick before we could classify 404 vs unknown.
  if upstream_exists "$owner" "$name"; then ur=0; else ur=$?; fi
  if [ "$ur" -eq 1 ]; then
    log "WARN: $slug upstream ($owner/$name) 404s — auto-tombstoning watch-optout/$slug"
    DEAD+=("$slug")
    continue
  elif [ "$ur" -eq 2 ]; then
    if [ -n "$armed" ]; then action="liveness recheck"; else action="arm"; fi
    log "WARN: $slug upstream check inconclusive — deferring $action to a later tick"
    continue
  fi
  if [ -n "$armed" ]; then
    mark_liveness_probe "$slug"
  else
    NEW+=("$slug")
  fi
done
shopt -u nullglob

# --- 1a. auto-tombstone dead-upstream forks (durable, so no re-arm) -----------
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
    printf '  designs/auto-provision-fork-watchers.md. To unwatch durably, delete this\n'
    printf '  file AND add watch-optout/%s.\n' "${2//\//-}"
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
