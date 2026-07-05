#!/bin/bash
# pages-watcher.sh — GitHub-Pages-build STATUS producer. Watch the garden's own
# repo's Pages build/deploy action and auto-post a pages-shepherd job the moment the
# live site's last deploy goes red.
#
# Usage: pages-watcher.sh            (repo from journal config/garden-repo, else the
#                                     GARDEN_ROOT origin remote)
#
# This is the sibling the maintainer asked for on kriskowal/garden#27: the shepherd,
# but applied to a push WITHOUT a pull request. The fleet pushes to main2 (the Pages
# source branch, serving main2/docs — the bulletin web app) constantly; each push
# fires the built-in `pages-build-deployment` workflow. Nothing watched that action,
# so a broken Pages build (a bad docs/ edit, or a flaky "Deployment failed, try again
# later") could leave https://kriskowal.github.io/garden/ stale with no one noticing.
# Now a completed-red Pages deploy yields exactly one pages-shepherd job, deduped
# across ticks and hosts, with no maintainer comment.
#
# The pipeline is fully DETERMINISTIC — a plain-code read of the NEWEST run's
# status/conclusion and a fixed mapping, no LLM reasoning over build logs (the
# triager's low-discretion spirit). The DISCRETION — is this a transient deploy flake
# to re-run, or a real docs build error to fix? — lives in the pages-shepherd JOB
# (roles/pages-shepherd/AGENT.md, skills/pages-build-shepherd/SKILL.md), never here:
#
#     read the recent Pages runs, NEWEST first (deterministic source)
#       → the newest run is still queued/in_progress   → back off, no job
#       → the newest completed run is a success         → nothing to do
#       → the newest completed run is red (failure/…)   → post garden-pages-<sha>-shepherd
#         unless one is already live/posted for that head SHA (idempotent).
#
# Keying on the NEWEST run means a transient deploy flake that a LATER push already
# turned green is never chased: the newest run supersedes it. Only the CURRENT tip's
# deploy being red is worth a shepherd.
#
# ── Leader-only singleton ────────────────────────────────────────────────────
# Like the other watchers this is a leader-only singleton: garden-pages-watcher.service
# carries the is-main-host.sh ExecCondition, so on a follower the tick is skipped
# cleanly and the pages-shepherd is never double-posted across hosts (CLAUDE.md
# § Leader and follower hosts).
#
# ── Monitoring safety ────────────────────────────────────────────────────────
# This watcher reads only Pages workflow-RUN metadata (id, status, conclusion, head
# SHA, URL) of the garden's OWN repo — NEVER a PR body, an issue, or a comment — and
# feeds NONE of it to an LLM; the job body it writes is deterministic and names the
# run by URL. So, like the ci-watcher, it introduces no prompt-injection surface
# (injection-safe by construction). It watches only the garden's own repo, so no
# comment-repos/ gating applies (CLAUDE.md § Monitoring safety constraint).
#
# The run source and the post are indirected so tests substitute deterministic stubs:
#   GARDEN_PAGES_SOURCE <owner/name> [<workflow>]  -> TSV: databaseId status conclusion headSha url  (newest first)
#   GARDEN_PAGES_POST   <basename> <body-file>     (post-job.sh)

set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=common.sh
source "$HERE/common.sh"
GARDEN_TAG="pages-watcher"
: "${GARDEN_PAGES_SOURCE:=$HERE/handlers/pages-runs-gh.sh}"
: "${GARDEN_PAGES_POST:=$HERE/post-job.sh}"
: "${GARDEN_PAGES_WORKFLOW:=pages-build-deployment}"
: "${GARDEN_PAGES_VERIFY_CLONE:=$GARDEN_STATE/pages-watcher/verify}"
VERIFY="$GARDEN_PAGES_VERIFY_CLONE"
# Bound the source read so a hung gh/git can never outlive the tick.
: "${GARDEN_PAGES_SOURCE_TIMEOUT_SECS:=120}"
: "${GARDEN_PAGES_KILL_AFTER:=10s}"

fleet_draining && { log "fleet draining; skipping"; exit 0; }

# --- resolve the watched repo -----------------------------------------------
# The Pages site is the garden's own repo. Read config/garden-repo (the same journal
# config the issue-inbox watcher uses, written by set-garden-repo.sh) when present;
# otherwise fall back to the GARDEN_ROOT origin remote — watching one's OWN Pages
# build is monitoring-safe by construction, so unlike the issue-inbox this watcher
# need not be inert until armed. GARDEN_GARDEN_REPO overrides both (tests).
_VERIFY_FETCHED=""
verify_fetch() {  # ensure+fetch the VERIFY clone (once/tick unless a `fresh` arg)
  ensure_clone "$VERIFY"
  if [ -n "${1:-}" ] || [ -z "$_VERIFY_FETCHED" ]; then
    journal_fetch "$VERIFY" >/dev/null 2>&1 || return 1
    _VERIFY_FETCHED=1
  fi
  return 0
}
parse_owner_repo() {  # parse_owner_repo <git-remote-url> -> owner/name on stdout
  local url="$1"
  url="${url%.git}"
  case "$url" in
    *github.com:*)  printf '%s\n' "${url##*github.com:}" ;;   # git@github.com:owner/name
    *github.com/*)  printf '%s\n' "${url##*github.com/}" ;;   # https://github.com/owner/name
    *)              return 1 ;;
  esac
}
resolve_repo() {
  if [ -n "${GARDEN_GARDEN_REPO:-}" ]; then REPO="$GARDEN_GARDEN_REPO"; return 0; fi
  if verify_fetch; then
    REPO="$(git -C "$VERIFY" show "origin/$JOURNAL_BRANCH:config/garden-repo" 2>/dev/null \
              | head -n1 | tr -d '[:space:]' || true)"
    [ -n "$REPO" ] && return 0
  fi
  # Fall back to the deployed garden root's origin remote.
  local url
  url="$(git -C "${GARDEN_ROOT:-$HOME}" remote get-url origin 2>/dev/null || true)"
  [ -n "$url" ] && REPO="$(parse_owner_repo "$url" || true)"
  [ -n "${REPO:-}" ]
}

if ! resolve_repo; then
  log "cannot resolve the garden's own repo (no config/garden-repo, no parseable origin remote); nothing to watch"
  exit 0
fi

# rc 0 if <base> exists anywhere in the lifecycle (plan/todo/doin/tada) — the post
# landed, so we never re-mint it. A completed pages-shepherd (tada) still counts:
# post-job.sh's own idempotency prevents re-minting the identical basename, so a red
# that lingers on the SAME head SHA does not thrash a second job.
posted_anywhere() {  # posted_anywhere <base> [fresh]
  local base="$1" sub
  verify_fetch "${2:-}" || return 1
  for sub in "$JOBS_PLAN" "$JOBS_TODO" "$JOBS_DOIN" "$JOBS_TADA"; do
    git -C "$VERIFY" cat-file -e "origin/$JOURNAL_BRANCH:$sub/$base.md" 2>/dev/null && return 0
  done
  return 1
}

# --- read the recent Pages runs (bounded, reaped source subtree) -------------
# The source runs `gh run list`, which forks git credential helpers; bound it under
# `timeout` and reap the whole process group on signal/exit so a systemd stop mid-tick
# cannot orphan a git child into the unit cgroup (mirrors ci-watcher.sh's reap).
SRC="$(mktemp)"; ERRF="$(mktemp)"
SOURCE_TIMEOUT_PID=""
cleanup() {
  rm -f "$SRC" "$ERRF"
  local pid="$SOURCE_TIMEOUT_PID"
  SOURCE_TIMEOUT_PID=""
  [ -n "$pid" ] || return 0
  kill -TERM "-$pid" 2>/dev/null || kill -TERM "$pid" 2>/dev/null || true
  wait "$pid" 2>/dev/null || true
  kill -KILL "-$pid" 2>/dev/null || true
}
trap 'cleanup' EXIT
trap 'cleanup; exit 143' TERM
trap 'cleanup; exit 130' INT

src_rc=0
if command -v timeout >/dev/null 2>&1; then
  timeout --signal=TERM --kill-after="$GARDEN_PAGES_KILL_AFTER" "${GARDEN_PAGES_SOURCE_TIMEOUT_SECS}s" \
    "$GARDEN_PAGES_SOURCE" "$REPO" "$GARDEN_PAGES_WORKFLOW" > "$SRC" 2>"$ERRF" &
  SOURCE_TIMEOUT_PID=$!
  wait "$SOURCE_TIMEOUT_PID" || src_rc=$?
  SOURCE_TIMEOUT_PID=""
else
  "$GARDEN_PAGES_SOURCE" "$REPO" "$GARDEN_PAGES_WORKFLOW" > "$SRC" 2>"$ERRF" || src_rc=$?
fi
if [ "$src_rc" -ne 0 ]; then
  sed 's/^/  source: /' "$ERRF" >&2 || true
  # A transient connectivity failure is not a broken enumeration — degrade the same
  # way the ci-watcher does: skip the tick rather than die, so a GitHub outage doesn't
  # detonate a systemd restart storm. A structural failure (auth, 404, malformed) still
  # dies loud — that IS a bug to surface.
  if is_transient_net_error "$ERRF"; then
    log "WARN: pages run source unreachable (transient network) — skipping tick (never guess)"
    exit 0
  fi
  die "pages run source failed for $REPO (rc=$src_rc; see source stderr above)"
fi

# The NEWEST run is the first non-empty line. Its state decides the whole tick.
newest_id=""; newest_status=""; newest_conclusion=""; newest_sha=""; newest_url=""
while IFS=$'\t' read -r id status conclusion sha url; do
  [ -n "$id" ] || continue
  newest_id="$id"; newest_status="$status"; newest_conclusion="$conclusion"
  newest_sha="$sha"; newest_url="$url"
  break
done < "$SRC"

if [ -z "$newest_id" ]; then
  log "no Pages runs reported for $REPO ($GARDEN_PAGES_WORKFLOW) — nothing to do"
  exit 0
fi

# Back off while the tip is still building — a red predecessor may yet be superseded.
case "$newest_status" in
  completed) : ;;
  *) log "newest Pages run ($newest_id) is $newest_status — backing off (no premature job)"; exit 0 ;;
esac

# Green tip → the live site's last deploy is healthy.
concl_uc="$(printf '%s' "$newest_conclusion" | tr '[:lower:]' '[:upper:]')"
case "$concl_uc" in
  SUCCESS)
    log "newest Pages run ($newest_id) is green — site deploy healthy, nothing to do"
    exit 0 ;;
  FAILURE|CANCELLED|TIMED_OUT|ACTION_REQUIRED|STARTUP_FAILURE|ERROR)
    : ;;   # red → shepherd (below)
  *)
    log "newest Pages run ($newest_id) has an unrecognized conclusion '$newest_conclusion' — skipping (never guess)"
    exit 0 ;;
esac

# Red tip. Key the job on the failing run's head SHA (short) so re-ticks are a no-op
# and a fresh commit (the shepherd's own fix) mints a fresh base.
short_sha="$(printf '%s' "$newest_sha" | cut -c1-12)"
[ -n "$short_sha" ] || short_sha="$newest_id"
base="garden-pages-$short_sha-shepherd"

if posted_anywhere "$base"; then
  log "Pages deploy red on $short_sha but a pages-shepherd ($base) already exists — idempotent skip"
  exit 0
fi

jb="$(mktemp)"
{
  printf '# pages-shepherd (auto: red Pages deploy) on %s\n\n' "$REPO"
  printf 'The GitHub Pages build/deploy action (`%s`) for the garden site is RED on\n' "$GARDEN_PAGES_WORKFLOW"
  printf 'its NEWEST completed run — the live site (https://kriskowal.github.io/garden/)\n'
  printf 'last deploy failed. This is a push WITHOUT a pull request, so wear the\n'
  printf '**pages-shepherd** role (roles/pages-shepherd/AGENT.md) — the shepherd applied\n'
  printf 'to a branch push — and drive the Pages deploy back to green.\n\n'
  printf 'Failing run: %s\n' "$newest_url"
  printf 'Head SHA:    %s\n' "$newest_sha"
  printf 'Conclusion:  %s\n\n' "$newest_conclusion"
  printf 'Classify and act per skills/pages-build-shepherd/SKILL.md:\n'
  printf '  - a transient deploy flake ("Deployment failed, try again later") → re-run\n'
  printf '    the failed run and verify it goes green (no code change);\n'
  printf '  - a real content/build error (a bad docs/ edit, a broken asset path) → fix\n'
  printf '    the docs source on the Pages source branch (main2/docs) and push, then\n'
  printf '    verify the new deploy is green.\n'
  printf 'Re-fetch the live run state before acting; a NEWER push may already have\n'
  printf 'superseded this run (then: nothing to do).\n'
} > "$jb"
"$GARDEN_PAGES_POST" "$base" "$jb" >/dev/null 2>&1 || true
rm -f "$jb"

if posted_anywhere "$base" fresh; then
  log "posted $base (auto pages-shepherd on red Pages deploy for $short_sha)"
else
  log "WARN: post of $base did not reach origin/$JOURNAL_BRANCH — will retry next tick"
fi
