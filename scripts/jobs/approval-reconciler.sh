#!/bin/bash
# approval-reconciler.sh — per-repo APPROVAL producer. Periodically sweep one
# gated repo's OWN open bot-authored PRs and post the conductor (or the shepherd)
# for any that carry a CURRENT trusted-maintainer approval the event-driven
# comment/review watcher missed.
#
# Usage: approval-reconciler.sh <repo-slug>      e.g. endojs-endo-but-for-bots
#
# ── Why this exists ──────────────────────────────────────────────────────────
# The finalization (un-draft + merge) trigger today is EVENT-DRIVEN off the PR
# comment/review feed (comment-watcher.sh's [APPROVED] path): a trusted maintainer
# approves, the watcher sees the review, probes mergeable/green, and mints
# `<slug>-pr<N>-conduct`. That path is blind to any approval submitted while the
# watcher is DOWN, over a cursor gap, or during a rate-limit outage — the approval
# is a one-shot event with no re-poll, so a missed one leaves an approved, green,
# mergeable PR sitting forever with no conductor. On 2026-07-28 several such
# approvals dispatched no conductor and the maintainer had to request them by hand
# (investigation: jobs/tada/investigate-pr721-review-false-peer-resolution.md §5,
# "Approval reconciler … closes a real hole"; the one-off manual sweep that proved
# it out: jobs/tada/ebfb-approved-pr-conductor-reconcile-20260730.md).
#
# This is the periodic BACKSTOP the investigation recommended. An approval is a
# STATE, not an event, so unlike the comment watcher this needs no cursor: each
# tick re-derives the world from the live board + live PR/approval state, so a
# missed tick SELF-HEALS on the next one.
#
# ── Fully deterministic, NO LLM ──────────────────────────────────────────────
# Like ci-watcher.sh, the pipeline is plain-code reads and a fixed mapping — no
# model reasoning over any PR body, title, or comment:
#
#     enumerate the repo's OWN open PRs (authoritative paginated REST — never a
#       default gh page cap, the #284 surveillance-drop lesson; shared source with
#       ci-watcher via ci-pr-source-gh.sh)
#       → keep only PRs AUTHORED by the bot whose head branch is bot-pushable (so a
#         conductor/shepherd can actually drive the branch)
#       → activity-bound: skip a PR untouched beyond the window BEFORE its
#         (API-heavy) approval read — a fresh approval bumps updated_at, so newly
#         approved PRs are always in-window (steady-state API thrift)
#       → board dedup FIRST (no API): if a conductor is already tracked for the PR
#         (any basename), the finalization is handled — skip, saving the read
#       → require a CURRENT trusted-MAINTAINER approval on the EXACT head SHA
#         (pr-maintainer-approval-gh.sh) — stale approvals (approval commit_id !=
#         current head) and untrusted approvers do NOT count
#       → reuse the event watcher's EXACT eligibility probe (pr-mergeable-gh.sh):
#           rc 0  ready (open+mergeable+green+approved)      → post the conductor
#           rc 2  already merged/closed                      → nothing to do
#           rc 1  approved but not mergeable/green           → post the shepherd
#                 (exactly the comment-watcher finalize→shepherd degrade)
#       → dedup the shepherd path against any live/tracked shepherd for the PR.
#
# ── Reuse, not reinvention ───────────────────────────────────────────────────
# Every gate is the SAME code the event path already trusts: is_bot_repo (this
# file), the bot-author gate (this file), pr-maintainer-approval-gh.sh (the exact
# approval-on-current-head authority the merge spine ci-wait-merge.sh independently
# requires), and pr-mergeable-gh.sh (the draft/mergeable/CI/approval rollup the
# comment watcher's GARDEN_PR_MERGEABLE points at). We invent NO weaker gate. The
# reconciler is deliberately at least as strict as the merge authority: it anchors
# on maintainers/allowlist (not the broader is_trusted set the comment watcher's
# event trigger uses), so a conductor it posts can always actually merge — it never
# mints a job that would stall at ci-wait-merge's approval gate. The looser
# trusted-sender approvals stay the event path's job, live.
#
# ── Dedup: restart / overlap / event-plus-sweep races ────────────────────────
# The basename is the SAME the event path mints (`<slug>-pr<N>-conduct` /
# `<slug>-pr<N>-shepherd`), and post-job.sh is idempotent by basename across
# plan/todo/doin/tada, so a concurrent event-post and sweep-post collapse to one.
# On top of that we pre-check the board deterministically, and — because a
# maintainer may hand-name a conductor/shepherd job (the 07-28 manual requests,
# e.g. `conduct-ebfb-805-tla`) — we also CONTENT-scan every lifecycle lane
# (todo/doin/tada/plan/orch/gauntlet) for any job that references THIS PR's URL and
# classifies as conductor/shepherd work, so a differently-named manual job also
# suppresses a duplicate. All of that reads only TRUSTED journal job files, never a
# PR body, so it adds no injection surface.
#
# ── Leader-only singleton ────────────────────────────────────────────────────
# Posting a conductor/shepherd is a fleet-global act; two hosts posting would still
# collapse by basename, but we gate to the leader anyway (no wasted API on
# followers). garden-approval-reconciler@.service carries the is-main-host.sh
# ExecCondition; a defense-in-depth in-script is_main_host check (mockable, and what
# the leader/follower test exercises) skips a follower cleanly. See CLAUDE.md
# § Leader and follower hosts.
#
# ── Monitoring safety ────────────────────────────────────────────────────────
# This watcher reads only PR metadata (number, author, head repo, timestamp) and
# CI/approval STATUS — NEVER a PR body, title, or comment — and feeds NONE of it to
# an LLM; the job bodies it writes are deterministic and name the PR by URL. So like
# the CI watcher it is injection-safe by construction. It is nonetheless gated to
# the SAME cleared, maintainer-authorized comment-repos/ set (armed per-repo by
# repo-watcher.sh) for defence in depth (CLAUDE.md § Monitoring safety constraint).
# agoric/agoric-sdk and the endojs/endo upstream are denied at is_bot_repo — the
# reconciler NEVER interacts with or links to upstream (per the job brief).
#
# The per-PR I/O is indirected so tests substitute deterministic stubs:
#   GARDEN_AR_PR_SOURCE <owner/name> <bot-login>  -> TSV: number author head updated title
#   GARDEN_AR_APPROVAL  <owner/name> <pr>         -> exit 0 current maintainer approval on head
#   GARDEN_AR_MERGEABLE <owner/name> <pr>         -> exit 0 ready / 1 not-green / 2 merged-closed
#   GARDEN_AR_POST      <basename> <body-file>    (post-job.sh)
# The bot-author, head-pushable, and is-bot-repo gates live HERE (not a handler) so
# the test exercises them directly.

set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=common.sh
source "$HERE/common.sh"

slug="${1:?usage: approval-reconciler.sh <repo-slug>}"
GARDEN_TAG="approval-reconciler/$slug"
: "${GARDEN_BOT_LOGIN:=kriscendobot}"
: "${GARDEN_AR_PR_SOURCE:=$HERE/handlers/ci-pr-source-gh.sh}"
: "${GARDEN_AR_APPROVAL:=$HERE/handlers/pr-maintainer-approval-gh.sh}"
: "${GARDEN_AR_MERGEABLE:=$HERE/handlers/pr-mergeable-gh.sh}"
: "${GARDEN_AR_POST:=$HERE/post-job.sh}"
: "${GARDEN_AR_VERIFY_CLONE:=$GARDEN_STATE/approval-reconciler/verify}"
# post-job.sh already retries its own journal CAS, but its caller still has to
# handle an uncertain outcome: it can fail after the push landed, or a transient
# fetch/push race can outlive its inner loop. Retry that whole operation a small,
# bounded number of times in this tick, confirming against a freshly-fetched
# origin after EVERY attempt. Tests lower the backoff to zero through common.sh's
# normal GARDEN_BACKOFF_* controls.
: "${GARDEN_AR_POST_ATTEMPTS:=3}"
VERIFY="$GARDEN_AR_VERIFY_CLONE"
# Activity-bound the EXPENSIVE per-PR approval read: a PR untouched beyond this
# window is skipped before its read. A fresh approval bumps the PR's updated_at, so
# a newly-approved PR is always in-window — the bound only spares the read on stale,
# quiet PRs. Generous by default so a missed approval during a multi-day outage is
# still recovered; empty disables the bound (reads every open bot PR).
: "${GARDEN_AR_ACTIVITY_WINDOW:=14 days}"
# Bound the PR-source enumeration so a hung gh/git can never outlive the tick.
: "${GARDEN_AR_SOURCE_TIMEOUT_SECS:=180}"
: "${GARDEN_AR_KILL_AFTER:=10s}"
# Defense-in-depth leader gate (the unit's ExecCondition is the primary). Mockable
# for the leader/follower test. Set to 0 to defer entirely to the ExecCondition.
: "${GARDEN_AR_LEADER_GUARD:=1}"

fleet_draining && { log "fleet draining; skipping"; exit 0; }

if [ "$GARDEN_AR_LEADER_GUARD" = 1 ] && ! is_main_host; then
  log "not the leader host — approval reconcile is a leader-only singleton; skipping tick"
  exit 0
fi

# slug is <owner>-<name>; owners in our set carry no dash, so split on the first.
owner="${slug%%-*}"; name="${slug#*-}"
repo="$owner/$name"
[ "$owner" != "$slug" ] && [ -n "$name" ] || die "cannot derive owner/name from slug '$slug'"

# --- bot-repo gate (identical to ci-watcher.sh) ------------------------------
# Un-drafting + merging (and driving a branch to green) is scoped HARD to bot
# repos: endojs/endo-but-for-bots and the bot's own forks. agoric/agoric-sdk and
# the endojs/endo upstream are NEVER autonomously finalized — those stay the
# maintainer's (and the boatman's) call. The garden's OWN repo is denied ahead of
# the bot-fork rule (post-2026-07-28-transfer it is bot-owned, so the fork arm would
# otherwise pass for its long-lived review-vessel PRs). Denylist-by-default.
is_bot_repo() {  # is_bot_repo <owner/name>
  local r
  for r in "$GARDEN_PRODUCTION_JOURNAL_REPO" $GARDEN_PRODUCTION_JOURNAL_REPO_ALIASES; do
    [ "$1" = "$r" ] && return 1                 # the garden's own repo — never self-finalize
  done
  case "$1" in
    agoric/agoric-sdk|endojs/endo) return 1 ;;   # explicit out-of-scope upstreams
    endojs/endo-but-for-bots)      return 0 ;;   # the gated bot repo
    "$GARDEN_BOT_LOGIN"/*)         return 0 ;;   # bot-owned forks
    *)                             return 1 ;;
  esac
}
if ! is_bot_repo "$repo"; then
  log "not a bot repo ($repo) — never autonomously finalize non-bot PRs; skipping"
  exit 0
fi

# rc 0 if the PR's head branch lives on a repo the bot can push (so a shepherd can
# drive it and a conductor can act on it): bot-owned head, OR a same-repo branch on
# this (already bot-verified) repo. Mirrors ci-watcher.sh head_pushable.
head_pushable() {  # head_pushable <head-repo-full-name>
  local head="$1"
  [ -n "$head" ] || return 1
  case "$head" in "$GARDEN_BOT_LOGIN"/*) return 0 ;; esac
  [ "$head" = "$repo" ]
}

# Reuse a persistent VERIFY clone (under $GARDEN_STATE, never torn down) for the
# board dedup reads and the post-confirm.
_VERIFY_FETCHED=""
verify_fetch() {  # verify_fetch [fresh]; ensure+fetch the VERIFY clone (once/tick unless fresh)
  ensure_clone "$VERIFY"
  if [ -n "${1:-}" ] || [ -z "$_VERIFY_FETCHED" ]; then
    journal_fetch "$VERIFY" >/dev/null 2>&1 || return 1
    _VERIFY_FETCHED=1
  fi
  return 0
}

# --- deterministic board dedup ----------------------------------------------
# rc 0 if <base> is present in any of the given lanes on origin/journal2.
base_in_lanes() {  # base_in_lanes <base> <lane> [<lane>...]
  local base="$1"; shift
  local lane
  for lane in "$@"; do
    git -C "$VERIFY" cat-file -e "origin/$JOURNAL_BRANCH:$lane/$base.md" 2>/dev/null && return 0
  done
  return 1
}

# Classify a lifecycle job (by path) as conductor / shepherd / other. Basename
# tokens first (the deterministic producers and the hand-named manual jobs both
# carry `conduct`/`shepherd` in the name — e.g. `conduct-ebfb-805-tla`,
# `ebfb-pr-405-rebase-retcon-conduct`), then the `role:` frontmatter a posted
# job carries, so a manual job named neither still classifies by its role line.
classify_job() {  # classify_job <lane/base.md-path-on-ref>  -> prints conductor|shepherd|other
  local path="$1" b head
  b="$(basename "$path" .md)"
  case "$b" in
    *conduct*)  printf 'conductor\n'; return 0 ;;   # also matches '*conductor*'
    *shepherd*) printf 'shepherd\n';  return 0 ;;
  esac
  head="$(git -C "$VERIFY" show "origin/$JOURNAL_BRANCH:$path" 2>/dev/null | head -20 || true)"
  case "$head" in
    *"role: conductor"*) printf 'conductor\n'; return 0 ;;
    *"role: shepherd"*)  printf 'shepherd\n';  return 0 ;;
  esac
  printf 'other\n'
}

# Content-scan the board for any job that references THIS PR's URL and classifies as
# <want> (conductor|shepherd). Catches a differently-named MANUAL conductor/shepherd
# and orchestration children the deterministic-base check cannot see. Reads only
# trusted journal job files (never a PR body). Echoes the first matching base (empty
# if none). The PR URL is matched with a trailing non-digit/EOL boundary so #7 never
# matches #71.
pr_role_job() {  # pr_role_job <pr> <want:conductor|shepherd>  -> echoes matching base or empty
  local pr="$1" want="$2" ref="origin/$JOURNAL_BRANCH" repo_re url_re files f
  repo_re="$(printf '%s' "$repo" | sed 's/[.]/\\./g')"
  url_re="github\\.com/${repo_re}/pull/${pr}([^0-9]|\$)"
  # git grep across the lifecycle lanes; -I skips binary, -l lists paths only.
  files="$(git -C "$VERIFY" grep -lIE "$url_re" "$ref" -- \
             "$JOBS_TODO/"'*.md' "$JOBS_DOIN/"'*.md' "$JOBS_TADA/"'*.md' \
             "$JOBS_PLAN/"'*.md' "$JOBS_ORCH/"'*.md' "$JOBS_GAUNTLET/"'*.md' 2>/dev/null \
           | sed "s#^${ref}:##" || true)"
  for f in $files; do
    [ "$(classify_job "$f")" = "$want" ] && { basename "$f" .md; return 0; }
  done
  return 0
}

# conductor_tracked <pr>: a conductor (merge step) already exists for this PR, in any
# lane, deterministic-base OR hand-named. If so the finalization is handled — the
# reconciler must not post either a conductor OR a shepherd.
conductor_tracked() {  # conductor_tracked <pr>  -> rc 0 if tracked
  local pr="$1"
  base_in_lanes "$slug-pr$pr-conduct" "$JOBS_TODO" "$JOBS_DOIN" "$JOBS_TADA" "$JOBS_PLAN" && return 0
  [ -n "$(pr_role_job "$pr" conductor)" ]
}
# shepherd_tracked <pr>: a shepherd already exists for this PR (live or done), in any
# lane, deterministic-base OR hand-named. Matches ci-watcher's posted_anywhere
# (incl. tada) anti-thrash: a fresh red after a completed shepherd is ci-watcher's job.
shepherd_tracked() {  # shepherd_tracked <pr>  -> rc 0 if tracked
  local pr="$1"
  base_in_lanes "$slug-pr$pr-shepherd" "$JOBS_TODO" "$JOBS_DOIN" "$JOBS_TADA" "$JOBS_PLAN" && return 0
  [ -n "$(pr_role_job "$pr" shepherd)" ]
}

# Give an operator a stable failure class plus the actual tail from post-job,
# instead of the old `>/dev/null 2>&1 || true` diagnostic black hole. These are
# operational classifications, not policy decisions: every class is retried
# because our generated basename/body are fixed and post-job is idempotent.
classify_post_failure() {  # classify_post_failure <rc> <stderr-file>
  local rc="$1" err="$2"
  case "$rc" in
    124|137|143) printf 'timeout-or-termination\n'; return ;;
  esac
  if is_transient_net_error "$err"; then
    printf 'transient-network\n'
  elif is_transient_auth_error "$err"; then
    printf 'transient-auth\n'
  elif is_transient_gh_source_error "$err"; then
    printf 'transient-service\n'
  elif grep -qiE 'push race|could not post|did not land|fetch|push|journal\.lock|lock busy|remote (end|host)|failed to sync' "$err" 2>/dev/null; then
    printf 'journal-contention\n'
  else
    printf 'unclassified\n'
  fi
}

# post_and_confirm <base> <body-file>
# rc 0 only when the job is freshly confirmed on the shared journal; rc 1 after
# the bounded retries are exhausted. A non-zero post followed by confirmation is
# success: the producer's final fetch/verification may have lost a race after its
# push actually landed.
post_and_confirm() {
  local base="$1" body="$2" attempt rc class fetch_ok err out detail
  err="$(mktemp "${TMPDIR:-/tmp}/approval-post.XXXXXX.err")"
  out="$(mktemp "${TMPDIR:-/tmp}/approval-post.XXXXXX.out")"
  for attempt in $(seq 1 "$GARDEN_AR_POST_ATTEMPTS"); do
    : > "$err"; : > "$out"; rc=0
    if "$GARDEN_AR_POST" "$base" "$body" >"$out" 2>"$err"; then
      rc=0
    else
      rc=$?
    fi

    fetch_ok=1
    verify_fetch fresh || fetch_ok=0
    if [ "$fetch_ok" -eq 1 ] \
       && base_in_lanes "$base" "$JOBS_TODO" "$JOBS_DOIN" "$JOBS_TADA"; then
      if [ "$rc" -ne 0 ]; then
        class="$(classify_post_failure "$rc" "$err")"
        detail="$(tail -c 600 "$err" 2>/dev/null | tr '\n' ' ' || true)"
        log "post of $base exited rc=$rc class=$class but fresh confirmation found it on origin/$JOURNAL_BRANCH${detail:+; stderr=[$detail]}"
      fi
      rm -f "$err" "$out"
      return 0
    fi

    if [ "$rc" -eq 0 ]; then
      class="unconfirmed-success"
    else
      class="$(classify_post_failure "$rc" "$err")"
    fi
    [ "$fetch_ok" -eq 1 ] || class="confirmation-fetch-failed+$class"
    detail="$(tail -c 600 "$err" 2>/dev/null | tr '\n' ' ' || true)"
    [ -n "$detail" ] || detail="$(tail -c 300 "$out" 2>/dev/null | tr '\n' ' ' || true)"
    if [ "$attempt" -lt "$GARDEN_AR_POST_ATTEMPTS" ]; then
      log "WARN: post of $base not confirmed (attempt $attempt/$GARDEN_AR_POST_ATTEMPTS, rc=$rc, class=$class)${detail:+; diagnostic=[$detail]}; retrying after backoff"
      backoff "$attempt"
    else
      log "WARN: post of $base not confirmed after $attempt attempt(s) (rc=$rc, class=$class)${detail:+; diagnostic=[$detail]}; deferring to the next tick"
    fi
  done
  rm -f "$err" "$out"
  return 1
}

# --- enumerate the repo's open PRs (bounded, reaped source subtree) ----------
# Identical guard shape to ci-watcher.sh: the source runs `gh --paginate`, which
# forks git credential helpers; bound it under `timeout` and reap the whole process
# group so a systemd stop mid-tick cannot orphan a git child into the unit cgroup.
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
  timeout --signal=TERM --kill-after="$GARDEN_AR_KILL_AFTER" "${GARDEN_AR_SOURCE_TIMEOUT_SECS}s" \
    "$GARDEN_AR_PR_SOURCE" "$repo" "$GARDEN_BOT_LOGIN" > "$SRC" 2>"$ERRF" &
  SOURCE_TIMEOUT_PID=$!
  wait "$SOURCE_TIMEOUT_PID" || src_rc=$?
  SOURCE_TIMEOUT_PID=""
else
  "$GARDEN_AR_PR_SOURCE" "$repo" "$GARDEN_BOT_LOGIN" > "$SRC" 2>"$ERRF" || src_rc=$?
fi

# A source failure normally must stay loud (a partial/absent list would silently
# stop reconciliation). A transient connectivity/overload blip degrades to a skip —
# the sweep is stateless, so the next tick recovers everything (mirrors ci-watcher).
REPO_GONE_REASON=""
repo_is_definitively_gone() {
  local probe_err stderr
  probe_err="$(mktemp 2>/dev/null || printf '%s' "${TMPDIR:-/tmp}/ar-repo-probe.$$")"
  if gh_api_retry "repos/$repo" --jq '.full_name' >/dev/null 2>"$probe_err"; then
    rm -f "$probe_err"; return 1
  fi
  stderr="$(cat "$probe_err" 2>/dev/null || true)"
  rm -f "$probe_err"
  _gh_api_stderr_is_transient "$stderr" && return 1
  case "$stderr" in
    *"Not Found"*|*"HTTP 404"*|*'"status":"404"'*|*"HTTP 403"*|*"Must have admin rights"*)
      REPO_GONE_REASON="$stderr"; return 0 ;;
  esac
  return 1
}

if [ "$src_rc" -ne 0 ]; then
  sed 's/^/  source: /' "$ERRF" >&2 || true
  if is_transient_net_error "$ERRF"; then
    log "WARN: PR source unreachable (transient network) — skipping tick (never guess)"
    exit 0
  fi
  if is_transient_gh_source_error "$ERRF"; then
    log "WARN: PR source hit a transient gh-api blip (5xx/HTML/rate-limit) — skipping tick (never guess)"
    exit 0
  fi
  if repo_is_definitively_gone; then
    log "REPO GONE: $repo returns a definitive repo-level error (${REPO_GONE_REASON:-<no stderr>}) — deactivating this reconcile gracefully (exit 0) rather than failing forever."
    alert_maintainer "approval-reconcile-repo-gone-${slug//[^A-Za-z0-9._-]/_}" \
      "approval-reconciler: $repo no longer exists (or is unreadable) on GitHub — gh api repos/$repo returns a definitive error: ${REPO_GONE_REASON:-<no stderr>}. The reconciler is armed by journal comment-repos/$slug; it now exits 0 and reconciles nothing. To close this out: delete journal comment-repos/$slug (and any repos/$slug sibling), add a journal watch-optout/$slug tombstone so fork-watch-provisioner.sh never re-arms it, and remove the stale bare clone worktrees/$slug.git. If the repo was RENAMED/TRANSFERRED, re-key the arming record to the new <owner>-<name> slug."
    exit 0
  fi
  die "PR source failed for $repo (rc=$src_rc; see source stderr above)"
fi

# Activity-window cutoff, computed once/tick. 0 (empty/unparseable) => no bound.
activity_cutoff=0
if [ -n "${GARDEN_AR_ACTIVITY_WINDOW:-}" ]; then
  activity_cutoff="$(date -d "-${GARDEN_AR_ACTIVITY_WINDOW}" +%s 2>/dev/null || echo 0)"
fi

bot_lc="$(printf '%s' "$GARDEN_BOT_LOGIN" | tr '[:upper:]' '[:lower:]')"
open_prs=0; ours=0; stale=0; deduped=0; approved=0; conducted=0; shepherded=0
merged_closed=0; not_approved=0

# Fetch the board once up front; if we cannot read it, skip the tick (never guess
# board state → never double-dispatch).
if ! verify_fetch; then
  log "WARN: journal fetch failed — skipping tick (never guess board state)"
  exit 0
fi

while IFS=$'\t' read -r pr author head updated _title; do
  [ -n "$pr" ] || continue
  case "$pr" in *[!0-9]*) continue ;; esac      # numeric PR ids only
  open_prs=$((open_prs+1))

  # Gate 1: our PR — authored by the bot.
  [ "$(printf '%s' "$author" | tr '[:upper:]' '[:lower:]')" = "$bot_lc" ] || continue
  # Gate 2: head branch is bot-pushable (a conductor/shepherd can drive it).
  if ! head_pushable "$head"; then
    log "skip #$pr: head '$head' is not bot-pushable"
    continue
  fi
  ours=$((ours+1))

  # Gate 3 (API thrift): skip a PR untouched beyond the activity window BEFORE its
  # approval read. A fresh approval bumps updated_at, so this never hides a new one.
  if [ "$activity_cutoff" -gt 0 ] && [ -n "$updated" ]; then
    upd_epoch="$(date -d "$updated" +%s 2>/dev/null || echo 0)"
    if [ "$upd_epoch" -gt 0 ] && [ "$upd_epoch" -lt "$activity_cutoff" ]; then
      stale=$((stale+1)); continue
    fi
  fi

  # Gate 4 (board dedup, no API): a conductor already tracked → finalization handled.
  if conductor_tracked "$pr"; then
    log "#$pr: a conductor is already tracked — idempotent skip (no approval read)"
    deduped=$((deduped+1)); continue
  fi

  # Gate 5 (API): CURRENT trusted-maintainer approval on the EXACT head SHA. Stale
  # approvals (approval commit_id != head) and untrusted approvers return nonzero.
  set +e; "$GARDEN_AR_APPROVAL" "$repo" "$pr" >/dev/null 2>&1; arc=$?; set -e
  if [ "$arc" -ne 0 ]; then
    not_approved=$((not_approved+1))
    log "#$pr: no current trusted-maintainer approval on head (rc=$arc) — skipping"
    continue
  fi
  approved=$((approved+1))

  # Gate 6 (API): the event watcher's EXACT eligibility probe decides conductor vs
  # shepherd vs nothing (draft/mergeable/CI/approval semantics, reused wholesale).
  set +e; "$GARDEN_AR_MERGEABLE" "$repo" "$pr" >/dev/null 2>&1; mrc=$?; set -e
  case "$mrc" in
    2)  log "#$pr approved but already merged/closed — nothing to finalize"
        merged_closed=$((merged_closed+1)); continue ;;
    0)  # ready → conductor
        base="$slug-pr$pr-conduct"
        jb="$(mktemp)"
        {
          printf '%s\n%s\n%s\n\n' '---' 'role: conductor' '---'
          printf '# Finalize (curate -> merge) %s PR #%s\n\n' "$repo" "$pr"
          printf 'A trusted maintainer APPROVED this PR on its CURRENT head and the\n'
          printf 'approval RECONCILER confirmed it is OPEN, mergeable, and checks green.\n'
          printf 'The event-driven comment/review watcher MISSED this approval (it was\n'
          printf 'down, over a cursor gap, or rate-limited when the review landed); this\n'
          printf 'periodic backstop caught it. This is the CURATION step: dispatch the\n'
          printf '**conductor** to un-draft (if the PR is still draft) and merge. Do NOT\n'
          printf 'name a merge method — the conductor owns that (roles/conductor/AGENT.md).\n\n'
          printf 'Guards (the reconciler already enforced these; re-verify before merging):\n'
          printf '  - Bot repo only (%s). NEVER merge agoric-sdk or the endojs/endo\n' "$repo"
          printf '    upstream, and never link to upstream agoric/agoric-sdk.\n'
          printf '  - The PR must still be OPEN, mergeable, and checks green, with a\n'
          printf '    current maintainer approval on the exact head. If it has regressed\n'
          printf '    (conflicts, red CI, head moved past the approval), dispatch the\n'
          printf '    shepherd/fixer instead of forcing the merge.\n'
          printf '  - Idempotent: if the PR is already merging/merged/closed, do nothing.\n\n'
          printf 'PR: https://github.com/%s/pull/%s\n' "$repo" "$pr"
          printf 'Head: %s (bot-pushable)\n' "$head"
          printf 'Posted AUTOMATICALLY by the approval reconciler on %s (no maintainer comment).\n' "$GARDEN"
        } > "$jb"
        # Re-check dedup on a FRESH board read to close the event-plus-sweep race as
        # tightly as possible before the post (post-job basename idempotency is the
        # final backstop under true concurrency).
        if conductor_tracked "$pr"; then
          log "#$pr: conductor appeared concurrently — idempotent skip"; rm -f "$jb"
          deduped=$((deduped+1)); continue
        fi
        if post_and_confirm "$base" "$jb"; then
          log "posted $base (recovered missed approval -> conductor for #$pr)"
          conducted=$((conducted+1))
        else
          log "WARN: post of $base exhausted its in-tick recovery — next reconcile tick will retry"
        fi
        rm -f "$jb"
        ;;
    *)  # approved but not mergeable/green → shepherd (the finalize->shepherd degrade)
        if shepherd_tracked "$pr"; then
          log "#$pr approved but not green; a shepherd is already tracked — idempotent skip"
          deduped=$((deduped+1)); continue
        fi
        base="$slug-pr$pr-shepherd"
        jb="$(mktemp)"
        {
          printf '%s\n%s\n%s\n\n' '---' 'role: shepherd' '---'
          printf 'handler-timeout: %s\n\n' "$GARDEN_SHEPHERD_HANDLER_TIMEOUT"
          printf '# shepherd (auto: approved but CI needs work) on %s PR #%s\n\n' "$repo" "$pr"
          printf 'A trusted maintainer APPROVED this PR on its CURRENT head, but it is not\n'
          printf 'yet mergeable/green. The approval RECONCILER caught an approval the\n'
          printf 'event watcher missed and, exactly as the event finalize path does when\n'
          printf 'a PR is approved-but-not-ready, dispatched a **shepherd** (drive CI to\n'
          printf 'green) rather than forcing the merge. Map: **shepherd** -> drive CI to green.\n\n'
          printf 'PR: https://github.com/%s/pull/%s\n' "$repo" "$pr"
          printf 'Head: %s (bot-pushable)\n\n' "$head"
          printf 'Read the failing checks and drive them green (see roles/shepherd/AGENT.md).\n'
          printf 'If the failure is out of a shepherd''s scope, escalate to a fixer per the\n'
          printf 'shepherd->fixer auto-chain. Re-fetch the live state before acting; this\n'
          printf 'job was minted from a status read at post time. Once green, the conductor\n'
          printf 'is posted by the event watcher / a later reconcile tick. Never link to\n'
          printf 'upstream agoric/agoric-sdk.\n'
        } > "$jb"
        if shepherd_tracked "$pr"; then
          log "#$pr: shepherd appeared concurrently — idempotent skip"; rm -f "$jb"
          deduped=$((deduped+1)); continue
        fi
        if post_and_confirm "$base" "$jb"; then
          log "posted $base (recovered missed approval -> shepherd for #$pr, CI needs work)"
          shepherded=$((shepherded+1))
        else
          log "WARN: post of $base exhausted its in-tick recovery — next reconcile tick will retry"
        fi
        rm -f "$jb"
        ;;
  esac
done < "$SRC"

log "reconciled $repo: $open_prs open PR(s), $ours bot-authored, $stale stale-skipped, $deduped already-tracked, $approved approved-current-head ($not_approved without), $merged_closed merged/closed, $conducted conductor(s) + $shepherded shepherd(s) posted"
