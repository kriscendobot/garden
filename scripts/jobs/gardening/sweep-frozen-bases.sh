#!/bin/bash
# sweep-frozen-bases.sh — the deterministic *Sweep on PR close* step of
# skills/frozen-base-branch: after a fork-side PR merges or closes, delete every
# pinned `<base>-<sha>` snapshot it used as base, UNLESS another open PR still
# targets it — and repair the one race that check cannot close.
#
# The incident (kriscendobot/minion.town#114, 2026-09-23): the frozen base
# `main-8e9f2be` already existed, so `design-minion-town-siwe-guest-recovery`'s
# push was "Everything up-to-date" and ensure-pr.sh opened #114 against the
# SHARED ref. Eight seconds later a concurrent close-time sweep, whose
# "does any other open PR use this base?" check had answered "no", deleted the
# ref; GitHub emitted `base_ref_deleted` and AUTO-CLOSED the brand-new #114.
# Recovery was by hand: re-push the base SHA, reopen through the REST API.
#
# Two defects made that possible, and this script fixes both:
#   1. The prose sweep asked `gh pr list --search "base:<ref> is:open"` — the
#      SEARCH index, which lags PR creation by seconds to minutes. A PR opened
#      moments ago is invisible to it. Here the re-check reads the authoritative
#      REST list (`pulls?state=open&base=<ref>`) IMMEDIATELY before each delete.
#   2. Even an authoritative check leaves a check-then-delete window (GitHub
#      ref deletion has no compare-and-swap). So after each delete the script
#      settles, then looks for any OTHER PR on that base that is open, or was
#      closed unmerged at/after the delete instant (the `base_ref_deleted`
#      auto-close). If it finds one it RE-CREATES the ref at the captured SHA
#      and REOPENS each victim — exactly the manual #114 recovery, now automatic.
#
# Only pinned names (assert-pinned-base.sh's `-<7..40 hex>` shape) are ever
# candidates, so a live trunk (`main`/`llm`/`master`) can never be deleted.
# A ref that is the HEAD of an open PR is also retained (a stacked PR's parent).
# Every read failure RETAINS the ref (fail-retain): a leaked snapshot branch is
# cosmetic, a deleted in-use one closes a PR.
#
# Usage:
#   sweep-frozen-bases.sh [--dry-run] <owner/repo> <pr-number>
#
# Candidates: every ref named by the PR's `base_ref_changed` events plus its
# current base ref, deduplicated. The swept PR itself is never counted as a user.
#
# Exit codes:
#   0  sweep finished (each candidate deleted, retained, or raced-and-restored)
#   1  a raced deletion could NOT be fully repaired — a PR may be closed or its
#      base missing; the log names it. Surface to the maintainer.
#   2  usage error
#   4  INCONCLUSIVE — could not read the PR's base history; nothing deleted
#
# Env / test seams:
#   GARDEN_GH                       the gh binary (a stub)
#   GARDEN_SWEEP_SETTLE_SECONDS     wait before the post-delete race check (15)
#   GARDEN_SWEEP_RACE_SLACK_SECONDS clock slack on "closed at/after delete" (30)

set -uo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

log() { echo "sweep-frozen-bases: $*" >&2; }
die() { log "$*"; exit 2; }

dry=0
[ "${1:-}" = "--dry-run" ] && { dry=1; shift; }
repo="${1:-}"; pr="${2:-}"
[ -n "$repo" ] && [[ "$pr" =~ ^[0-9]+$ ]] || die "usage: sweep-frozen-bases.sh [--dry-run] <owner/repo> <pr-number>"
settle="${GARDEN_SWEEP_SETTLE_SECONDS:-15}"
slack="${GARDEN_SWEEP_RACE_SLACK_SECONDS:-30}"

GH="gh"
if [ -n "${GARDEN_GH:-}" ]; then
  if [ -x "$GARDEN_GH" ] || command -v "$GARDEN_GH" >/dev/null 2>&1; then
    GH="$GARDEN_GH"
  else
    log "GARDEN_GH=$GARDEN_GH does not resolve; falling back to the PATH gh"
  fi
fi
command -v jq >/dev/null 2>&1 || { log "jq not found"; exit 4; }

api() { "$GH" api "$@" 2>/dev/null; }

# --- candidates ----------------------------------------------------------------
cur="$(api "repos/$repo/pulls/$pr" --jq '.base.ref')" || { log "cannot read $repo#$pr — INCONCLUSIVE, nothing deleted"; exit 4; }
hist="$(api --paginate "repos/$repo/issues/$pr/events" \
          --jq '.[] | select(.event == "base_ref_changed") | (.base_ref, .previous_ref, .current_ref) // empty')" \
  || { log "cannot read $repo#$pr base_ref_changed history — INCONCLUSIVE, nothing deleted"; exit 4; }

mapfile -t candidates < <(printf '%s\n%s\n' "$cur" "$hist" | sed '/^$/d;/^null$/d' | sort -u)

failed=0
for fb in "${candidates[@]}"; do
  if ! "$HERE/assert-pinned-base.sh" name "$fb" 2>/dev/null; then
    log "skip '$fb': not a pinned <base>-<sha> snapshot (never swept)"
    continue
  fi

  sha="$(api "repos/$repo/git/ref/heads/$fb" --jq '.object.sha')"
  if [ -z "$sha" ] || [ "$sha" = null ]; then
    log "skip '$fb': ref already gone"
    continue
  fi

  # Authoritative re-check, immediately before the delete (never the search index).
  users="$(api --paginate --slurp "repos/$repo/pulls?state=open&base=$fb&per_page=100" \
             | jq -r --argjson self "$pr" '[.[][] | select(.number != $self) | .number] | map(tostring) | join(" ")')" \
    || { log "retain '$fb': cannot enumerate open PRs based on it (fail-retain)"; continue; }
  if [ -n "$users" ]; then
    echo "retain $repo:$fb — still the base of open PR(s) #${users// / #}"
    continue
  fi
  heads="$(api --paginate --slurp "repos/$repo/pulls?state=open&head=${repo%%/*}:$fb&per_page=100" \
             | jq -r '[.[][] | .number | tostring] | join(" ")')" \
    || { log "retain '$fb': cannot enumerate open PRs headed on it (fail-retain)"; continue; }
  if [ -n "$heads" ]; then
    echo "retain $repo:$fb — it is the head of open PR(s) #${heads// / #}"
    continue
  fi

  if [ "$dry" -eq 1 ]; then
    echo "would-delete $repo:$fb @ $sha"
    continue
  fi

  t0="$(date -u +%s)"
  if ! "$GH" api -X DELETE "repos/$repo/git/refs/heads/$fb" >/dev/null 2>&1; then
    log "delete of '$fb' failed (left in place)"
    continue
  fi
  echo "deleted $repo:$fb @ $sha"

  # --- post-delete race check: did a PR land on this base inside the window? ---
  [ "$settle" -gt 0 ] && sleep "$settle"
  victims="$(api --paginate --slurp "repos/$repo/pulls?state=all&base=$fb&sort=updated&direction=desc&per_page=100" \
               | jq -r --argjson self "$pr" --argjson t0 "$t0" --argjson slack "$slack" '
                   [.[][] | select(.number != $self)
                          | select(.state == "open"
                                   or (.merged_at == null and .closed_at != null
                                       and ((.closed_at | fromdateiso8601) >= ($t0 - $slack))))
                          | .number | tostring] | join(" ")')"
  rc=$?
  if [ "$rc" -ne 0 ]; then
    log "WARN: could not run the post-delete race check for '$fb'; re-creating it to be safe"
    victims=""
  fi
  if [ "$rc" -eq 0 ] && [ -z "$victims" ]; then
    continue
  fi

  echo "RACE $repo:$fb — deleted while PR(s) #${victims// / #} targeted it; restoring @ $sha (skills/frozen-base-branch § Sweep on PR close)"
  if ! "$GH" api -X POST "repos/$repo/git/refs" -f "ref=refs/heads/$fb" -f "sha=$sha" >/dev/null 2>&1; then
    log "FAILED to re-create '$fb' @ $sha — PR(s) #$victims may stay closed; restore by hand: gh api -X POST repos/$repo/git/refs -f ref=refs/heads/$fb -f sha=$sha"
    failed=1
    continue
  fi
  echo "restored $repo:$fb @ $sha"
  for v in $victims; do
    state="$(api "repos/$repo/pulls/$v" --jq '.state')"
    [ "$state" = open ] && { echo "ok #$v still open"; continue; }
    if "$GH" api -X PATCH "repos/$repo/pulls/$v" -f state=open >/dev/null 2>&1; then
      echo "reopened $repo#$v"
    else
      log "FAILED to reopen $repo#$v after restoring '$fb' — reopen by hand: gh api -X PATCH repos/$repo/pulls/$v -f state=open"
      failed=1
    fi
  done
done

exit "$failed"
