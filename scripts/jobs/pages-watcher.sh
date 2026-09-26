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
# later") could leave https://kriscendobot.github.io/garden/ stale with no one noticing.
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
export GARDEN_TAG="pages-watcher"
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
  ensure_clone_or_latch_outage "$VERIFY" pages-watcher-verify  # timeout → quiet exit 75, not FATAL
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
  for sub in "$JOBS_PLAN" "$JOBS_TODO" "$JOBS_DOIN"; do
    git -C "$VERIFY" cat-file -e "origin/$JOURNAL_BRANCH:$sub/$base.md" 2>/dev/null && return 0
  done
  tada_find_tree "$VERIFY" "origin/$JOURNAL_BRANCH" "$base" >/dev/null && return 0
  return 1
}

# --- read the recent Pages runs (bounded, reaped source subtree) -------------
# The source runs `gh run list`, which forks git credential helpers; bound it under
# `timeout` and reap the whole process group on signal/exit so a systemd stop mid-tick
# cannot orphan a git child into the unit cgroup (mirrors ci-watcher.sh's reap).
SRC="$(mktemp)"; ERRF="$(mktemp)"
SOURCE_TIMEOUT_PID=""
# Final cgroup-wide straggler sweep — the EXIT-path complement to the stop-time cgroup
# SIGKILL backstop, which never covers a clean tick exit. The negated-PGID reap in
# cleanup alone is NOT enough: a gh run list-forked git credential helper, or an ssh master
# that `setsid`'d itself into its own session, escapes the group and the next start
# logs "Found left-over process (git) in control group". Safety: a strict no-op unless
# this process is inside its OWN garden-pages-watcher service cgroup (unreadable
# /proc/self/cgroup, no unified `0::` line, or any other leaf → no-op), and it NEVER
# kills $$ or any of its ancestors — only the lost descendant stragglers. A BOUNDED
# re-read loop, not one snapshot: the source forks a helper per request, so it keeps
# re-reading cgroup.procs and SIGKILLing live stragglers until two consecutive reads
# find none, capped by GARDEN_PAGES_CGROUP_REAP_DEADLINE_SECS (default 3s).
# Mirrors approval-reconciler.sh's reap_cgroup_stragglers.
#
# rc 0 iff <pid> is a still-RUNNING, non-zombie process (a SIGKILLed zombie has left
# the cgroup yet still answers `kill -0`).
_straggler_alive() {  # _straggler_alive <pid>
  local p="$1" st
  kill -0 "$p" 2>/dev/null || return 1
  st="$(awk '{ s=$0; sub(/^.*\) /,"",s); print substr(s,1,1) }' "/proc/$p/stat" 2>/dev/null || echo Z)"
  [ "$st" != Z ]
}
reap_cgroup_stragglers() {
  local procs
  # Test-only override: sweep a FIXTURE cgroup.procs file (honored only in a test
  # context; the $$+ancestors keep-set still protects the runner).
  if [ -n "${GARDEN_PAGES_CGROUP_PROCS_FILE:-}" ] && _in_test_context; then
    procs="$GARDEN_PAGES_CGROUP_PROCS_FILE"
    [ -r "$procs" ] || return 0
  else
    local line cgpath leaf
    line="$(grep '^0::' /proc/self/cgroup 2>/dev/null)" || return 0
    [ -n "$line" ] || return 0
    cgpath="${line#0::}"
    leaf="${cgpath##*/}"
    case "$leaf" in
      garden-pages-watcher.service) ;;
      *) return 0 ;;
    esac
    procs="/sys/fs/cgroup${cgpath}/cgroup.procs"
    [ -r "$procs" ] || return 0
  fi
  # Collect $$ and its ancestor chain so we never signal ourselves or our parents.
  local keep=" $$ " p ppid
  p="$$"
  while [ -n "$p" ] && [ "$p" != "0" ]; do
    ppid="$(awk '/^PPid:/{print $2}' "/proc/$p/status" 2>/dev/null)" || break
    [ -n "$ppid" ] || break
    keep="$keep$ppid "
    [ "$ppid" = "1" ] && break
    p="$ppid"
  done
  local deadline_secs="${GARDEN_PAGES_CGROUP_REAP_DEADLINE_SECS:-3}"
  local now start pid remaining zero_reads=0 survivors
  start="$(date +%s 2>/dev/null || echo 0)"
  while :; do
    remaining=0
    survivors=""
    while read -r pid; do
      [ -n "$pid" ] || continue
      case "$keep" in *" $pid "*) continue ;; esac
      _straggler_alive "$pid" || continue
      kill -KILL "$pid" 2>/dev/null || true
      remaining=$((remaining + 1))
      survivors="$survivors $pid"
    done < "$procs"
    # One zero-read is not proof the cgroup is DURABLY empty (a helper can fork in the
    # gap after it): return only on TWO consecutive zero-reads; a straggler resets it.
    if [ "$remaining" -eq 0 ]; then
      zero_reads=$((zero_reads + 1))
      [ "$zero_reads" -ge 2 ] && return 0
    else
      zero_reads=0
    fi
    now="$(date +%s 2>/dev/null || echo 0)"
    if [ $(( now - start )) -ge "$deadline_secs" ]; then
      [ "$remaining" -eq 0 ] && return 0
      log "WARN: cgroup still holds $remaining straggler(s) after ${deadline_secs}s reap deadline ($procs) — best-effort; the unit's ExecStopPost drain keeps waiting for them"
      # shellcheck disable=SC2086  # word-split the pid list on purpose
      bash "$HERE/cgroup-drain.sh" --describe $survivors 2>/dev/null \
        | while IFS= read -r d; do log "WARN:   straggler $d"; done
      return 0
    fi
    sleep 0.1 2>/dev/null || sleep 1
  done
}
cleanup() {
  rm -f "$SRC" "$ERRF"
  local pid="$SOURCE_TIMEOUT_PID"
  SOURCE_TIMEOUT_PID=""                 # idempotent: the TERM and EXIT traps both fire
  if [ -n "$pid" ]; then
    kill -TERM "-$pid" 2>/dev/null || kill -TERM "$pid" 2>/dev/null || true
    wait "$pid" 2>/dev/null || true
    kill -KILL "-$pid" 2>/dev/null || true
  fi
  # Then fell any straggler that escaped the group into a different session/group, on
  # every exit path (clean completion included).
  reap_cgroup_stragglers
}
trap 'cleanup' EXIT
trap 'cleanup; exit 143' TERM
trap 'cleanup; exit 130' INT

# Bounded backoff before a 401-retry; tests set it to 0 to keep the run fast.
: "${GARDEN_PAGES_AUTH_RETRY_SLEEP:=5}"

# classify_source_failure <errf> [context] — the shared transient gate BOTH the
# first-pass and post-401-retry die sites consult before dying, so the two stay in
# sync. When GitHub is overloaded it serves an HTML gateway/5xx/rate-limit page
# instead of JSON; the default `gh run list … | jq` source then fails rc=1 with a
# Go-decoder / HTTP-5NN / rate-limit signature that matches NEITHER
# is_transient_net_error NOR is_transient_auth_error. That is the exact transient
# class commit 9cf685607d added to GARDEN_TRANSIENT_GH_API_SIGNATURES; consult it
# via is_transient_gh_source_error and, on a match, WARN + exit 0 (skip the tick)
# rather than `die` and detonate the self-heal restart. Ordered AFTER the net/auth
# checks and BEFORE the final die, so a genuinely structural failure (a real 404, a
# malformed slug) still dies loud and preserves "never guess a state".
classify_source_failure() {
  local errf="$1" ctx="${2:-}"
  if is_transient_gh_source_error "$errf"; then
    log "WARN: pages run source hit a transient gh-api blip (5xx/HTML/rate-limit)${ctx:+ $ctx} — skipping tick"
    exit 0
  fi
}

# run_source — invoke the Pages-run source ONCE into $SRC/$ERRF, setting src_rc.
# Wrapped in `timeout` and reaped through SOURCE_TIMEOUT_PID/cleanup so a hung or
# signalled `gh`/git child cannot outlive the tick or orphan into the unit cgroup.
# Factored so the 401-retry below reuses the identical bounded, reaped path.
run_source() {
  src_rc=0
  if command -v timeout >/dev/null 2>&1; then
    # `setsid` makes $! a fresh session+group leader from its first instruction (it execs
    # in place: a job-control-off background child is never already a group leader), so
    # cleanup's `kill -TERM "-$pid"` addresses a real group and reaps gh/git grandchildren.
    local sid=(); command -v setsid >/dev/null 2>&1 && sid=(setsid)
    "${sid[@]}" timeout --signal=TERM --kill-after="$GARDEN_PAGES_KILL_AFTER" "${GARDEN_PAGES_SOURCE_TIMEOUT_SECS}s" \
      "$GARDEN_PAGES_SOURCE" "$REPO" "$GARDEN_PAGES_WORKFLOW" > "$SRC" 2>"$ERRF" &
    SOURCE_TIMEOUT_PID=$!
    wait "$SOURCE_TIMEOUT_PID" || src_rc=$?
    SOURCE_TIMEOUT_PID=""
  else
    "$GARDEN_PAGES_SOURCE" "$REPO" "$GARDEN_PAGES_WORKFLOW" > "$SRC" 2>"$ERRF" || src_rc=$?
  fi
}

run_source
if [ "$src_rc" -ne 0 ]; then
  sed -E 's/^(<[0-9]>)?/\1  source: /' "$ERRF" >&2 || true
  # A transient connectivity failure is not a broken enumeration — degrade the same
  # way the ci-watcher does: skip the tick rather than die, so a GitHub outage doesn't
  # detonate a systemd restart storm. A structural failure (404, malformed) still
  # dies loud — that IS a bug to surface.
  if is_transient_net_error "$ERRF"; then
    log "WARN: pages run source unreachable (transient network) — skipping tick (never guess)"
    exit 0
  fi
  # GitHub returns a transient `HTTP 401: Bad credentials` for a brief window while an
  # OAuth/installation token rotates; the identical call succeeds moments later. Retry
  # ONCE (same reaped, timeout-wrapped path) after a short backoff before treating a 401
  # as structural, so a rotation blip doesn't detonate a systemd restart + self-heal.
  if is_transient_auth_error "$ERRF"; then
    log "WARN: pages run source auth failed (HTTP 401) — retrying once after ${GARDEN_PAGES_AUTH_RETRY_SLEEP}s backoff"
    [ "$GARDEN_PAGES_AUTH_RETRY_SLEEP" -gt 0 ] 2>/dev/null && sleep "$GARDEN_PAGES_AUTH_RETRY_SLEEP"
    run_source
    if [ "$src_rc" -ne 0 ]; then
      sed -E 's/^(<[0-9]>)?/\1  source(retry): /' "$ERRF" >&2 || true
      if is_transient_net_error "$ERRF"; then
        log "WARN: pages run source unreachable (transient network) on retry — skipping tick (never guess)"
        exit 0
      fi
      # Still 401 after the retry — a persistent auth failure (a revoked/misconfigured
      # credential), not a rotation blip. Surface it loudly and skip the tick; the WARN
      # repeats every tick until the credential is fixed (never swallowed into "all green").
      if is_transient_auth_error "$ERRF"; then
        log "WARN: pages run source auth failed twice (persistent 401) — skipping tick"
        exit 0
      fi
      classify_source_failure "$ERRF" "on retry"
      die "pages run source failed for $REPO (rc=$src_rc; see source stderr above)"
    fi
    # Retry succeeded — the 401 was transient; fall through and process the runs.
  else
    classify_source_failure "$ERRF"
    die "pages run source failed for $REPO (rc=$src_rc; see source stderr above)"
  fi
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
  printf '%s\n' '---'
  printf '%s\n' 'role: pages-shepherd'
  printf '%s\n\n' '---'
  printf '# pages-shepherd (auto: red Pages deploy) on %s\n\n' "$REPO"
  printf 'The GitHub Pages build/deploy action (`%s`) for the garden site is RED on\n' "$GARDEN_PAGES_WORKFLOW"
  printf 'its NEWEST completed run — the live site (https://kriscendobot.github.io/garden/)\n'
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
