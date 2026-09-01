#!/bin/bash
# design-pr-gauntlet-coverage-audit.sh — the STANDING PERIODIC BACKSTOP for the
# design-PR gauntlet-bypass class (review-misses cluster
# `garden-design-pr-gauntlet-bypass`). It is the third coverage layer the two
# completion-time scripts' own comments already presuppose ("the design-gauntlet
# sensor/audit will surface it") but which, until now, did not exist.
#
# THE GAP THIS CLOSES.  Two scripts fire at a job's COMPLETION:
#   * auto-gauntlet-handoff.sh (STAGER)   — stages a design PR's gauntlet, but only
#     when the PR is still DRAFT; it deliberately declines to stage for a design PR
#     that is already NON-DRAFT at completion time, because force-drafting a PR that
#     may be under active maintainer review is the endojs/endo-but-for-bots
#     #671/#867 corruption hazard.
#   * assert-design-pr-gauntlet.sh (SENSOR) — blocks a completion whose design PR
#     has no gauntlet record, but likewise steps aside for a NON-DRAFT design PR
#     (it "did not create that draft state").
# Both leave the non-draft case "for the design-gauntlet sensor/audit" — a periodic
# sweep that never got built.  So a design PR that is NON-DRAFT AT BIRTH (opened
# ready-for-review, never through a draft->gauntlet handoff) had NO safety net ever,
# unless a human happened to notice.  The grounding incident: kriscendobot/minion.town#47,
# a SECURITY-CRITICAL ocap-redesign design PR opened non-draft on 2026-08-16 that sat
# with ZERO review activity for over a day and NO gauntlet ever staged (staged by hand
# 2026-08-17; this timer is the structural fix).
#
# WHAT IT DOES (deterministic, NO LLM — PR metadata + file PATHS + trusted journal
# records only; never a PR body/title/comment into a model):
#   1. Enumerate the OPEN PRs on every actively-watched repo (the journal's
#      comment-repos/ set — the same gate the CI and comment watchers use), skipping
#      the garden's own repo (no PR workflow runs on it — CLAUDE.md § Conventions).
#   2. Keep only BOT-AUTHORED, OPEN, DESIGN-ONLY PRs (design_only_paths — the exact
#      predicate the two sibling scripts key on), exempting a probe (a gap-revealing
#      prototype intentionally stays draft with no gauntlet).
#   3. If NO staged-gauntlet record already covers the PR (gauntlet_record_for_pr —
#      PR-keyed, reused, not reimplemented), stage one (post-gauntlet.sh, the same
#      call shape as the two sibling scripts).
# Critically, UNLIKE the two completion-time scripts, this audit stages regardless of
# the PR's DRAFT STATE and NEVER touches it: staging a gauntlet RECORD does not draft
# or un-draft anything, so the non-draft-under-review corruption hazard those scripts
# guard against simply does not arise here.  That is the whole reason the audit can
# safely cover the non-draft case they cannot.
#
# It is a small NEW backstop, not a change to those two scripts — their completion-time
# logic and its non-draft caution are correct and stay as they are.
#
# Leader-only (the unit's ExecCondition gates it to the leader host): staging is
# CAS-pushed and idempotent per PR, but running it on every host would multiply the
# gh enumeration cost for no benefit.  Resilient by construction: an inconclusive
# read (gh error, offline clone) skips that repo/PR and the next tick retries — a
# transient blip never wedges anything, because the audit only ever ADDS a missing
# record.
#
# Usage: design-pr-gauntlet-coverage-audit.sh
#   Injection points (for the test; all default to the production handlers):
#     GARDEN_DPGCA_REPO_SOURCE     command printing one owner/repo per line
#                                  (default: the comment-repos/ set in the clone).
#     GARDEN_DPGCA_PR_SOURCE       <owner/name> <bot-login> -> TSV
#                                  number author head_repo updated_at title
#                                  (default: handlers/ci-pr-source-gh.sh — the same
#                                  authoritative paginated open-PR source ci-watcher
#                                  uses, so an older open PR is never page-capped out).
#     GARDEN_DPGCA_POST_GAUNTLET   the stager (default: post-gauntlet.sh).
#     GARDEN_GH                    the gh binary (default: gh).
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
: "${GARDEN_DPGCA_POST_GAUNTLET:=$HERE/post-gauntlet.sh}"
: "${GARDEN_DPGCA_CLONE:=$GARDEN_STATE/design-pr-gauntlet-audit/journal}"
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
# AND of the existing gauntlet records. post-gauntlet.sh writes through its OWN
# producer clone, so this one is never a write target.
DIR="$GARDEN_DPGCA_CLONE"
ensure_clone "$DIR" || die "audit: journal clone $DIR unavailable"
sync_clone "$DIR" >/dev/null 2>&1 || true

# The garden runs NO PR workflow on itself (main2/journal2 push direct — CLAUDE.md
# § Conventions); its only open PRs are long-lived review vessels a gauntlet must
# never be staged over. Keyed to the canonical repo and its migration aliases so the
# exclusion follows any future transfer (the same reasoning ci-watcher's is_bot_repo
# states for the auto-shepherd gate).
is_own_repo() {  # is_own_repo <owner/name>
  local r
  for r in "$GARDEN_PRODUCTION_JOURNAL_REPO" $GARDEN_PRODUCTION_JOURNAL_REPO_ALIASES; do
    [ "$1" = "$r" ] && return 0
  done
  return 1
}

# Enumerate the actively-watched repos as owner/name, one per line. Default source is
# the journal clone's comment-repos/ set (bare <owner>-<name> slugs); owners in our
# set carry no dash, so split on the FIRST dash exactly as ci-watcher does.
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

# Bounded PR-source read for one repo → TSV on stdout (empty on any failure; a repo
# we cannot enumerate is skipped, never fatal — the next tick retries).
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

# Bounded authoritative metadata read for one PR. A single stalled GitHub request
# must not consume the audit unit's whole 900-second systemd deadline; it is just an
# inconclusive read, and the next periodic tick will retry it.
pr_view() {  # pr_view <PR URL>
  if command -v timeout >/dev/null 2>&1; then
    timeout --signal=TERM --kill-after="$GARDEN_DPGCA_KILL_AFTER" \
      "${GARDEN_DPGCA_SOURCE_TIMEOUT_SECS}s" \
      "$gh_bin" pr view "$1" --json url,isDraft,state,title,body,author,files
  else
    "$gh_bin" pr view "$1" --json url,isDraft,state,title,body,author,files
  fi
}

scanned_repos=0
candidate_prs=0
staged=0
already=0

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

    # Re-confirm the invariants on the authoritative per-PR read.
    [ "$pauthor" = "$GARDEN_BOT_LOGIN" ] || continue
    [ "$state" = OPEN ] || continue

    # A probe intentionally stays draft with no gauntlet — never a miss. Prefer the
    # PR's durable annotation (title/body carries the gap-revealing marker).
    if printf '%s\n' "$pr_json" | jq -r '[.title, .body] | join("\n")' 2>/dev/null \
         | grep -qi 'gap-revealing prototype\|gap-revealing'; then
      continue
    fi

    mapfile -t _files < <(printf '%s' "$pr_json" | jq -r '(.files // [])[].path // empty' 2>/dev/null || true)
    # Not a design-only diff → the design-PR invariant does not apply.
    if [ "${#_files[@]}" -eq 0 ] || ! design_only_paths "${_files[@]}"; then
      continue
    fi

    candidate_prs=$((candidate_prs + 1))
    slug="${repo%/*}-${repo#*/}"
    gauntlet_base="${slug}-pr${number}-gauntlet"

    # Already covered? Mirror the SENSOR's exact triple check (not just
    # gauntlet_record_for_pr): a gauntlet that has already RUN TO COMPLETION lives in
    # jobs/tada/, which the PR-keyed record scan (jobs/gauntlet/ only) does not see.
    # Checking only the active-record path would make the audit log a false "STAGED"
    # and call post-gauntlet.sh EVERY tick for a PR whose gauntlet finished long ago
    # (post-gauntlet's own base-keyed tada/ idempotence stops a duplicate, so it is
    # harmless — but noisy and wrong). The three arms: PR-keyed records under ANY base
    # in gauntlet/ (an active run); the PR-derived base in gauntlet/; and the
    # PR-derived base in tada/ (a completed run).
    if existing="$(gauntlet_record_for_pr "$DIR" "$repo" "$number")"; then
      already=$((already + 1))
      log "audit: design PR $pr_url (draft=$draft) already covered by gauntlet record(s) [$(printf '%s' "$existing" | tr '\n' ' ')]"
      continue
    fi
    if [ -e "$DIR/$JOBS_GAUNTLET/$gauntlet_base.md" ] || [ -e "$DIR/$JOBS_TADA/$gauntlet_base.md" ]; then
      already=$((already + 1))
      log "audit: design PR $pr_url (draft=$draft) already covered by gauntlet '$gauntlet_base' (active or completed); no new record"
      continue
    fi

    # Uncovered design PR — stage its gauntlet. NEVER touch draft state (staging a
    # record neither drafts nor un-drafts), so the non-draft-under-review hazard the
    # two completion-time scripts avoid does not arise here.
    if "$GARDEN_DPGCA_POST_GAUNTLET" --by "$GARDEN_TAG" "$gauntlet_base" "$pr_url"; then
      staged=$((staged + 1))
      log "audit: STAGED design gauntlet '$gauntlet_base' for uncovered $([ "$draft" = true ] && printf 'DRAFT' || printf 'NON-DRAFT') design PR $pr_url — the completion-time stager had left this case for the audit; panel.sh runs before maintainer review"
    else
      log "audit: WARNING failed to stage gauntlet '$gauntlet_base' for $pr_url; a later tick retries"
    fi
  done <<<"$src"
done < <(repos_list)

log "audit: swept $scanned_repos watched repo(s); $candidate_prs bot-authored design PR(s), $already already covered, $staged newly staged"
exit 0
