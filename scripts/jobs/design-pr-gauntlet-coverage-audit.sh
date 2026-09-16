#!/bin/bash
# design-pr-gauntlet-coverage-audit.sh — the STANDING PERIODIC READINESS AUDIT for the
# manual-gauntlet-trigger regime (designs/manual-gauntlet-trigger.md, adopted
# 2026-09-16). It is NON-MUTATING: it ALERTS the maintainer about a bot-authored,
# OPEN, NON-DRAFT PR with no gauntlet coverage; it NEVER stages a gauntlet record and
# NEVER re-drafts a PR.
#
# WHY IT CHANGED.  This unit used to STAGE a gauntlet for every uncovered design PR it
# found. On 2026-08-30 that autonomous staging mass-staged 69 gauntlets in a single
# hourly pass (~$482 on one host — reports/credit-investigation-endolin-garden2-
# 20260905.md), including stale/superseded PRs churning at iteration 6/6. Under the
# manual-gauntlet regime the garden no longer stages gauntlets autonomously at all:
# `run the gauntlet #N` is the sole ordinary trigger. So this backstop is demoted from
# a stager to a READINESS AUDIT — it still catches the "a bot PR reached the mergeable
# queue with no review" drift, but it does so by telling the maintainer, not by
# spending a gauntlet. A maintainer who wants review answers with `run the gauntlet #N`.
#
# WHAT IT DOES (deterministic, NO LLM — PR metadata + trusted journal records only;
# never a PR body/title/comment into a model):
#   1. Enumerate the OPEN PRs on every actively-watched repo (the journal's
#      comment-repos/ set — the same gate the CI and comment watchers use), skipping
#      the garden's own repo (no PR workflow runs on it — CLAUDE.md § Conventions).
#   2. Keep only BOT-AUTHORED, OPEN, NON-DRAFT PRs (draft is the manual regime's hard
#      boundary — a draft PR is parked-by-design and owes nothing), exempting a probe.
#   3. If NO staged-gauntlet RECORD already covers the PR (active in jobs/gauntlet/ or
#      completed in jobs/tada/), raise a DEDUPLICATED maintainer alert.
#
# Dedup keys on `<repo>#<number>:<headRefOid>` via a durable per-PR marker under
# $GARDEN_STATE, so an UNCHANGED head never re-alerts (no per-tick spam) while a
# CHANGED head surfaces a fresh warning. The alert itself rides alert_maintainer
# (throttled + coalescing), so even a first-of-head alert cannot flood the inbox.
#
# It NEVER mutates anything on GitHub or the journal: no `gh pr ready`, no
# post-gauntlet.sh, no journal push. The whole #671/#867 force-draft-under-review
# hazard the old completion-time scripts guarded against simply cannot arise, because
# this audit only ever READS and, at most, writes a local dedup marker + inbox alert.
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
#     GARDEN_DPGCA_SOURCE_TIMEOUT_SECS / GARDEN_DPGCA_KILL_AFTER
#                                  bound both repo enumeration and each per-PR
#                                  metadata read (defaults: 180 / 10s).

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
      "$gh_bin" pr view "$1" --json url,isDraft,state,title,body,author,headRefOid
  else
    "$gh_bin" pr view "$1" --json url,isDraft,state,title,body,author,headRefOid
  fi
}

scanned_repos=0
candidate_prs=0
alerted=0
already=0
quiet=0

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

    # Re-confirm the invariants on the authoritative per-PR read.
    [ "$pauthor" = "$GARDEN_BOT_LOGIN" ] || continue
    [ "$state" = OPEN ] || continue

    # DRAFT is the manual regime's hard boundary — a draft PR is parked-by-design and
    # owes nothing. Only a NON-DRAFT PR that reached the mergeable queue is a concern.
    [ "$draft" = true ] && continue

    # A probe intentionally stays draft with no gauntlet — never a concern.
    if printf '%s\n' "$pr_json" | jq -r '[.title, .body] | join("\n")' 2>/dev/null \
         | grep -qi 'gap-revealing prototype\|gap-revealing'; then
      continue
    fi

    candidate_prs=$((candidate_prs + 1))
    slug="${repo%/*}-${repo#*/}"
    gauntlet_base="${slug}-pr${number}-gauntlet"

    # Already covered by an active (jobs/gauntlet/) or completed (jobs/tada/) gauntlet?
    if existing="$(gauntlet_record_for_pr "$DIR" "$repo" "$number")"; then
      already=$((already + 1))
      log "audit: $pr_url already covered by gauntlet record(s) [$(printf '%s' "$existing" | tr '\n' ' ')]; no alert"
      continue
    fi
    if [ -e "$DIR/$JOBS_GAUNTLET/$gauntlet_base.md" ] || [ -e "$DIR/$JOBS_TADA/$gauntlet_base.md" ]; then
      already=$((already + 1))
      log "audit: $pr_url already covered by gauntlet '$gauntlet_base' (active or completed); no alert"
      continue
    fi

    # Uncovered non-draft bot PR. Dedup on <repo>#<number>:<headRefOid> so an unchanged
    # head stays quiet; a re-pushed head re-warns. NEVER stage, NEVER touch the PR.
    marker="$GARDEN_DPGCA_DEDUP_DIR/${slug}-pr${number}"
    prev_oid="$(cat "$marker" 2>/dev/null || true)"
    if [ -n "$head_oid" ] && [ "$prev_oid" = "$head_oid" ]; then
      quiet=$((quiet + 1))
      log "audit: $pr_url uncovered but already alerted for head $head_oid; staying quiet"
      continue
    fi

    alert_maintainer "pr-gauntlet-readiness-${slug}-pr${number}-${head_oid:0:12}" \
      "Readiness audit: bot-authored OPEN NON-DRAFT PR $pr_url ($repo#$number) is in the mergeable queue with NO gauntlet review staged (head $head_oid). Under the manual-gauntlet regime the garden no longer stages gauntlets automatically. If you want it reviewed, reply with 'run the gauntlet #$number'; otherwise no action is needed. This audit never re-drafts or stages anything."
    printf '%s\n' "$head_oid" > "$marker" 2>/dev/null || true
    alerted=$((alerted + 1))
    log "audit: ALERTED maintainer about uncovered non-draft PR $pr_url (head $head_oid); no gauntlet staged, PR untouched"
  done <<<"$src"
done < <(repos_list)

log "audit: swept $scanned_repos watched repo(s); $candidate_prs bot-authored non-draft PR(s), $already already covered, $alerted newly alerted, $quiet quiet (already-alerted head)"
exit 0
