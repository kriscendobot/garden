#!/bin/bash
# design-pr-gauntlet-coverage-audit.sh — the STANDING PERIODIC READINESS AUDIT for the
# readiness backstop. Its historical-backlog path is NON-MUTATING: it ALERTS the
# maintainer about a bot-authored, OPEN, NON-DRAFT PR with no gauntlet coverage. A
# separately bounded path stages coverage for PRs created after this installation
# first armed the audit. It NEVER re-drafts a PR.
#
# WHY IT CHANGED.  This unit used to STAGE a gauntlet for every uncovered design PR it
# found. On 2026-08-30 that autonomous staging mass-staged 69 gauntlets in a single
# hourly pass (~$482 on one host — reports/credit-investigation-endolin-garden2-
# 20260905.md), including stale/superseded PRs churning at iteration 6/6. Under the
# producer completions now stage their own gauntlets automatically, but a periodic
# backlog sweep must not do so. On its first run this audit records an epoch and
# treats every already-open PR as historical forever. PRs created after that epoch
# are safe to reconcile automatically, subject to a small per-tick stage cap. This
# closes the short race in which a newly opened ready PR can merge before its
# producer's completion hook stages coverage, without turning the old backlog back
# into work. Historical drift still only tells the maintainer, who can answer with
# `run the gauntlet #N`.
#
# WHAT IT DOES (deterministic, NO LLM — PR metadata + trusted journal records only;
# never a PR body/title/comment into a model):
#   1. Enumerate the OPEN PRs on every actively-watched repo (the journal's
#      comment-repos/ set — the same gate the CI and comment watchers use), skipping
#      the garden's own repo (no PR workflow runs on it — CLAUDE.md § Conventions).
#   2. Keep only BOT-AUTHORED, OPEN, NON-DRAFT PRs (draft artifacts belong to their
#      completion-local handoff), except that post-arm drafts are reconciled when
#      that handoff was missed. Probes remain exempt.
#   3. If NO gauntlet has EVER covered the PR (live or terminal in jobs/gauntlet/,
#      archived, or finished in jobs/tada/ — gauntlet_history_for_pr), stage it
#      only when created after the durable arm epoch and the per-tick cap has
#      room; otherwise raise a DEDUPLICATED alert for a ready PR or quietly retry
#      a draft on the next tick.
#
# Dedup keys on `<repo>#<number>:<headRefOid>` via a durable per-PR marker under
# $GARDEN_STATE, so an UNCHANGED head never re-alerts (no per-tick spam) while a
# CHANGED head surfaces a fresh warning. The alert itself rides alert_maintainer
# (throttled + coalescing), so even a first-of-head alert cannot flood the inbox.
#
# It NEVER mutates anything on GitHub: no `gh pr ready`, so the whole #671/#867
# force-draft-under-review hazard cannot arise. The only journal mutation is an
# idempotent post-gauntlet record for a post-arm PR, bounded per tick. Historical
# PRs only write a local dedup marker + inbox alert.
#
# Leader-only (the unit's ExecCondition gates it to the leader host): running it on
# every host would multiply the gh enumeration cost for no benefit. Resilient by
# construction: an inconclusive read (gh error, offline clone) skips that repo/PR and
# the next tick retries.
#
# Usage: design-pr-gauntlet-coverage-audit.sh
#   Injection points (for the test; all default to the production handlers):
#     GARDEN_DPGCA_REPO_SOURCE     command printing one owner/repo per line
#                                  (default: the comment-repos/ set in the clone).
#     GARDEN_DPGCA_PR_SOURCE       <owner/name> <bot-login> -> TSV
#                                  number author head_repo updated_at title
#                                  (default: handlers/ci-pr-source-gh.sh).
#     GARDEN_GH                    the gh binary (default: gh).
#     GARDEN_ALERT_CMD             alert sink (default: the maintainer inbox via
#                                  alert_maintainer/watchdog-notice.sh).
#     GARDEN_DPGCA_GAUNTLET_POST   gauntlet record producer (default:
#                                  post-gauntlet.sh).
#     GARDEN_DPGCA_MAX_NEW_PR_STAGES
#                                  maximum post-arm PRs staged per tick (default: 2).
#     GARDEN_DPGCA_SOURCE_TIMEOUT_SECS / GARDEN_DPGCA_KILL_AFTER
#                                  bound both repo enumeration and each per-PR
#                                  metadata read (defaults: 180 / 10s).
#     GARDEN_DPGCA_POST_TIMEOUT_SECS
#                                  bound each gauntlet post (default: 180).

set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=common.sh
source "$HERE/common.sh"
export GARDEN_TAG="design-pr-gauntlet-coverage-audit"

: "${GARDEN_BOT_LOGIN:=kriscendobot}"
: "${GARDEN_DPGCA_PR_SOURCE:=$HERE/handlers/ci-pr-source-gh.sh}"
: "${GARDEN_DPGCA_CLONE:=$GARDEN_STATE/design-pr-gauntlet-audit/journal}"
# Durable per-PR dedup markers (repo#number -> last-alerted headRefOid).
: "${GARDEN_DPGCA_DEDUP_DIR:=$GARDEN_STATE/pr-gauntlet-readiness}"
: "${GARDEN_DPGCA_ARM_EPOCH_FILE:=$GARDEN_DPGCA_DEDUP_DIR/new-pr-arm-epoch}"
: "${GARDEN_DPGCA_GAUNTLET_POST:=$HERE/post-gauntlet.sh}"
: "${GARDEN_DPGCA_MAX_NEW_PR_STAGES:=2}"
: "${GARDEN_DPGCA_POST_TIMEOUT_SECS:=180}"
# Bound each repo's PR-source enumeration so a hung gh/git can never outlive the tick.
: "${GARDEN_DPGCA_SOURCE_TIMEOUT_SECS:=180}"
: "${GARDEN_DPGCA_KILL_AFTER:=10s}"

fleet_draining && { log "fleet draining; skipping"; exit 0; }

gh_bin="${GARDEN_GH:-gh}"
case "$gh_bin" in
  */*) [ -x "$gh_bin" ] || die "audit: gh binary '$gh_bin' is not executable" ;;
  *)   command -v "$gh_bin" >/dev/null 2>&1 || die "audit: gh ('$gh_bin') is required to inspect PRs" ;;
esac

# A read/enumerate clone of the journal: the source of the comment-repos/ watch set
# AND of the existing gauntlet records. This audit never writes through it.
DIR="$GARDEN_DPGCA_CLONE"
ensure_clone "$DIR" || die "audit: journal clone $DIR unavailable"
sync_clone "$DIR" >/dev/null 2>&1 || true

mkdir -p "$GARDEN_DPGCA_DEDUP_DIR" 2>/dev/null || true

case "$GARDEN_DPGCA_MAX_NEW_PR_STAGES" in
  ''|*[!0-9]*) die "audit: GARDEN_DPGCA_MAX_NEW_PR_STAGES must be a non-negative integer" ;;
esac
case "$GARDEN_DPGCA_POST_TIMEOUT_SECS" in
  ''|*[!0-9]*|0) die "audit: GARDEN_DPGCA_POST_TIMEOUT_SECS must be a positive integer" ;;
esac

# An absent epoch means this installation has never distinguished future PRs from
# backlog. Arm now, before enumeration, and deliberately stage nothing from the
# first snapshot. Losing local state safely returns to alert-only behavior rather
# than replaying every open PR into the gauntlet queue.
arming_run=false
arm_epoch="$(cat "$GARDEN_DPGCA_ARM_EPOCH_FILE" 2>/dev/null || true)"
case "$arm_epoch" in
  ''|*[!0-9]*)
    arming_run=true
    arm_epoch="$(date -u +%s)"
    arm_tmp="$GARDEN_DPGCA_ARM_EPOCH_FILE.tmp.$$"
    if printf '%s\n' "$arm_epoch" >"$arm_tmp" 2>/dev/null \
       && mv "$arm_tmp" "$GARDEN_DPGCA_ARM_EPOCH_FILE" 2>/dev/null; then
      log "audit: armed bounded new-PR reconciliation at epoch $arm_epoch; this first snapshot remains alert-only"
    else
      rm -f "$arm_tmp" 2>/dev/null || true
      # Without a durable epoch, fail safe: every run remains historical/alert-only.
      log "audit: could not persist new-PR arm epoch; this tick remains alert-only"
    fi
    ;;
esac

# The garden runs NO PR workflow on itself (main2/journal2 push direct — CLAUDE.md
# § Conventions); its only open PRs are long-lived review vessels. Keyed to the
# canonical repo and its migration aliases so the exclusion follows any future transfer.
is_own_repo() {  # is_own_repo <owner/name>
  local r
  for r in "$GARDEN_PRODUCTION_JOURNAL_REPO" $GARDEN_PRODUCTION_JOURNAL_REPO_ALIASES; do
    [ "$1" = "$r" ] && return 0
  done
  return 1
}

# Enumerate the actively-watched repos as owner/name, one per line.
repos_list() {
  if [ -n "${GARDEN_DPGCA_REPO_SOURCE:-}" ]; then
    "$GARDEN_DPGCA_REPO_SOURCE"
    return
  fi
  local d="$DIR/comment-repos" p slug owner name
  [ -d "$d" ] || return 0
  for p in "$d"/*; do
    [ -e "$p" ] || continue
    slug="${p##*/}"
    case "$slug" in .gitkeep|.git|.*|README*|CLAUDE*) continue ;; esac
    slug="${slug%.git}"
    owner="${slug%%-*}"; name="${slug#*-}"
    [ "$owner" != "$slug" ] && [ -n "$name" ] || continue
    printf '%s/%s\n' "$owner" "$name"
  done
}

# Bounded PR-source read for one repo → TSV on stdout (empty on any failure).
pr_source() {  # pr_source <owner/name>
  local repo="$1"
  if command -v timeout >/dev/null 2>&1; then
    timeout --signal=TERM --kill-after="$GARDEN_DPGCA_KILL_AFTER" \
      "${GARDEN_DPGCA_SOURCE_TIMEOUT_SECS}s" \
      "$GARDEN_DPGCA_PR_SOURCE" "$repo" "$GARDEN_BOT_LOGIN" 2>/dev/null || true
  else
    "$GARDEN_DPGCA_PR_SOURCE" "$repo" "$GARDEN_BOT_LOGIN" 2>/dev/null || true
  fi
}

# Bounded authoritative metadata read for one PR. headRefOid rides along so the
# dedup key can distinguish a re-pushed head from an unchanged one.
pr_view() {  # pr_view <PR URL>
  if command -v timeout >/dev/null 2>&1; then
    timeout --signal=TERM --kill-after="$GARDEN_DPGCA_KILL_AFTER" \
      "${GARDEN_DPGCA_SOURCE_TIMEOUT_SECS}s" \
      "$gh_bin" pr view "$1" --json url,isDraft,state,title,body,author,headRefOid,createdAt
  else
    "$gh_bin" pr view "$1" --json url,isDraft,state,title,body,author,headRefOid,createdAt
  fi
}

post_gauntlet() {  # post_gauntlet <base> <PR URL>
  if command -v timeout >/dev/null 2>&1; then
    timeout --signal=TERM --kill-after="$GARDEN_DPGCA_KILL_AFTER" \
      "${GARDEN_DPGCA_POST_TIMEOUT_SECS}s" \
      "$GARDEN_DPGCA_GAUNTLET_POST" --by design-pr-gauntlet-coverage-audit "$1" "$2"
  else
    "$GARDEN_DPGCA_GAUNTLET_POST" --by design-pr-gauntlet-coverage-audit "$1" "$2"
  fi
}

scanned_repos=0
candidate_prs=0
alerted=0
already=0
quiet=0
staged=0
stage_attempted=0
deferred=0

while IFS= read -r repo; do
  [ -n "$repo" ] || continue
  if is_own_repo "$repo"; then
    log "audit: skipping the garden's own repo $repo (no PR workflow runs on it)"
    continue
  fi
  scanned_repos=$((scanned_repos + 1))

  src="$(pr_source "$repo")"
  [ -n "$src" ] || continue

  while IFS=$'\t' read -r number author _head _updated _title; do
    [ -n "$number" ] || continue
    # Cheap bot-author gate from the enumeration before any per-PR read.
    [ "$author" = "$GARDEN_BOT_LOGIN" ] || continue

    pr_url="https://github.com/$repo/pull/$number"
    pr_json=""
    pr_rc=0
    pr_json="$(pr_view "$pr_url" 2>/dev/null)" || pr_rc=$?
    if [ "$pr_rc" -eq 124 ] || [ "$pr_rc" -eq 137 ]; then
      log "audit: metadata read timed out for $pr_url; skipping (inconclusive)"
      continue
    fi
    if [ "$pr_rc" -ne 0 ] || [ -z "$pr_json" ]; then
      log "audit: could not read $pr_url; skipping (inconclusive)"
      continue
    fi

    state="$(printf '%s' "$pr_json" | jq -r '.state // empty' 2>/dev/null || true)"
    pauthor="$(printf '%s' "$pr_json" | jq -r '.author.login // empty' 2>/dev/null || true)"
    draft="$(printf '%s' "$pr_json" | jq -r '.isDraft // false' 2>/dev/null || true)"
    head_oid="$(printf '%s' "$pr_json" | jq -r '.headRefOid // empty' 2>/dev/null || true)"
    created_at="$(printf '%s' "$pr_json" | jq -r '.createdAt // empty' 2>/dev/null || true)"

    # Re-confirm the invariants on the authoritative per-PR read.
    [ "$pauthor" = "$GARDEN_BOT_LOGIN" ] || continue
    [ "$state" = OPEN ] || continue

    # A probe intentionally stays draft with no gauntlet — never a concern.
    if printf '%s\n' "$pr_json" | jq -r '[.title, .body] | join("\n")' 2>/dev/null \
         | grep -qi 'gap-revealing prototype\|gap-revealing'; then
      continue
    fi

    # A historical draft is parked-by-design and owes nothing. A post-arm draft,
    # however, is the normal artifact produced immediately before the completion
    # hook stages its gauntlet. Reconcile that narrowly bounded class so a missed
    # producer handoff does not leave the draft stranded forever.
    created_epoch="$(date -u -d "$created_at" +%s 2>/dev/null || true)"
    post_arm=false
    if [ "$arming_run" = false ] && [ -n "$created_epoch" ] \
       && [ "$created_epoch" -gt "$arm_epoch" ]; then
      post_arm=true
    fi
    [ "$draft" = true ] && [ "$post_arm" = false ] && continue

    candidate_prs=$((candidate_prs + 1))
    slug="${repo%/*}-${repo#*/}"
    gauntlet_base="${slug}-pr${number}-gauntlet"

    # Already covered by ANY gauntlet this PR has ever had: live or terminal in
    # jobs/gauntlet/, archived, or finished into the date-sharded jobs/tada/. A
    # finished run (complete, review-budget-reached, halted) is coverage, not a gap:
    # the record leaves jobs/gauntlet/ when it finishes, and checking only there
    # re-ran six more panel/fix rounds on endo-but-for-bots#1425/#1426 on
    # 2026-10-06. A fresh run on a terminal PR is the maintainer's call
    # (`run the gauntlet #N`), never this audit's.
    if existing="$(gauntlet_history_for_pr "$DIR" "$repo" "$number")"; then
      already=$((already + 1))
      log "audit: $pr_url already covered by gauntlet history [$(printf '%s' "$existing" | tr '\n' ' ')]; not staging, no alert"
      continue
    fi
    if [ -e "$DIR/$JOBS_GAUNTLET/$gauntlet_base.md" ] || tada_exists "$DIR" "$gauntlet_base"; then
      already=$((already + 1))
      log "audit: $pr_url already covered by gauntlet '$gauntlet_base' (active or completed); no alert"
      continue
    fi

    # Only PRs demonstrably created after the durable arm epoch enter this path.
    # The first snapshot is unconditionally historical, even if a remote clock is
    # ahead. A malformed/missing createdAt likewise fails safe to alert-only.
    if [ "$post_arm" = true ]; then
      if [ "$stage_attempted" -lt "$GARDEN_DPGCA_MAX_NEW_PR_STAGES" ]; then
        stage_attempted=$((stage_attempted + 1))
        if post_gauntlet "$gauntlet_base" "$pr_url"; then
          staged=$((staged + 1))
          log "audit: STAGED bounded new-PR gauntlet '$gauntlet_base' for $pr_url (created $created_at, arm epoch $arm_epoch)"
          continue
        fi
        if [ "$draft" = true ]; then
          log "audit: bounded new-PR staging failed for draft $pr_url; leaving it eligible for the next tick"
        else
          log "audit: bounded new-PR staging failed for $pr_url; falling back to maintainer alert"
        fi
      else
        deferred=$((deferred + 1))
        if [ "$draft" = true ]; then
          log "audit: new draft $pr_url exceeded this tick's stage cap ($GARDEN_DPGCA_MAX_NEW_PR_STAGES); deferring without alert and leaving it eligible for the next tick"
        else
          log "audit: new PR $pr_url exceeded this tick's stage cap ($GARDEN_DPGCA_MAX_NEW_PR_STAGES); alerting now and leaving it eligible for the next tick"
        fi
      fi
    fi

    # Draft overflow or a failed draft post remains eligible for the next tick,
    # but is not in the mergeable queue and therefore does not warrant a readiness
    # alert. In particular, do not stamp an alert-dedup marker that could obscure
    # the later transition to ready.
    if [ "$draft" = true ]; then
      log "audit: post-arm draft $pr_url remains unstaged; deferring without alert"
      continue
    fi

    # Historical, overflow, or failed-stage candidate. Dedup the alert on
    # <repo>#<number>:<headRefOid> so an unchanged head stays quiet; a re-pushed head
    # re-warns. This path never touches the PR.
    marker="$GARDEN_DPGCA_DEDUP_DIR/${slug}-pr${number}"
    prev_oid="$(cat "$marker" 2>/dev/null || true)"
    if [ -n "$head_oid" ] && [ "$prev_oid" = "$head_oid" ]; then
      quiet=$((quiet + 1))
      log "audit: $pr_url uncovered but already alerted for head $head_oid; staying quiet"
      continue
    fi

    alert_maintainer "pr-gauntlet-readiness-${slug}-pr${number}-${head_oid:0:12}" \
      "Readiness audit: bot-authored OPEN NON-DRAFT PR $pr_url ($repo#$number) is in the mergeable queue with NO gauntlet review staged (head $head_oid). Producer jobs normally stage their gauntlet at completion. The audit keeps historical backlog alert-only and stages only post-arm PRs within its per-tick bound; this PR was not staged. If you want it reviewed, reply with 'run the gauntlet #$number'; otherwise no action is needed. This audit never re-drafts a PR."
    printf '%s\n' "$head_oid" > "$marker" 2>/dev/null || true
    alerted=$((alerted + 1))
    log "audit: ALERTED maintainer about uncovered non-draft PR $pr_url (head $head_oid); no gauntlet staged, PR untouched"
  done <<<"$src"
done < <(repos_list)

log "audit: swept $scanned_repos watched repo(s); $candidate_prs eligible bot-authored PR(s), $already already covered, $staged newly staged from $stage_attempted attempt(s) (cap $GARDEN_DPGCA_MAX_NEW_PR_STAGES), $deferred deferred by cap, $alerted newly alerted, $quiet quiet (already-alerted head)"
exit 0
