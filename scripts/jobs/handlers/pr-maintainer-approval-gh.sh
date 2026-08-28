#!/bin/bash
# pr-maintainer-approval-gh.sh -- deterministic maintainer-review gate.
#
# Usage: pr-maintainer-approval-gh.sh <owner/name> <pr-number>
#
# Returns 0 only when a current journal maintainer's EFFECTIVE (latest) review is
# APPROVED and no maintainer's effective review is CHANGES_REQUESTED. On repos WITH
# required-reviewer branch protection the GitHub reviewDecision rollup must not be
# CHANGES_REQUESTED or REVIEW_REQUIRED; on repos WITHOUT required-reviewer branch
# protection the rollup is always empty and that check is skipped — the
# individual-review gate (below) still enforces effective maintainer approval.
#
# An approval is a STATE, not a per-commit event: a still-effective APPROVED review
# from a trusted maintainer authorizes the PR even after the head advances or is
# rebased. This is deliberate — a garden rebase-before-merge (ci-wait-merge.sh) and
# ordinary follow-up pushes move the head past the reviewed commit, and requiring
# the review's commit_id to equal the current headRefOid made a maintainer's real,
# undismissed approval unsatisfiable (it stranded #656/#708/#755-class PRs and every
# post-rebase merge). What still revokes an approval is a GitHub review DISMISSAL
# (the review's state becomes DISMISSED) or the maintainer's own later
# CHANGES_REQUESTED — both are honored below. CI freshness (that the green checks
# belong to the current head) is a SEPARATE gate enforced by ci-wait-merge.sh and
# is not weakened here.
#
# The maintainer trust source is journal2:maintainers/allowlist, matching the
# issue-inbox gate. If that file is present but contains no login, the documented
# bootstrap owner set (kriskowal, erights) is used. A failed journal read fails
# closed; an outage is not evidence that a PR has approval.

set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=../common.sh
source "$HERE/../common.sh"
GARDEN_TAG="pr-maintainer-approval"

repo="${1:?usage: pr-maintainer-approval-gh.sh <owner/name> <pr-number>}"
pr="${2:?usage: pr-maintainer-approval-gh.sh <owner/name> <pr-number>}"
require_tools gh jq
GH=gh
if [ -n "${GARDEN_GH:-}" ]; then
  if [ -x "$GARDEN_GH" ] || command -v "$GARDEN_GH" >/dev/null 2>&1; then
    GH="$GARDEN_GH"
  else
    log "GARDEN_GH=$GARDEN_GH does not resolve; using durable PATH gh"
  fi
fi
require_tools "$GH"

declare -a MAINTAINERS=()
load_maintainers() {
  local line source_file verify
  if [ -n "${GARDEN_MAINTAINERS_ALLOWLIST:-}" ]; then
    source_file="$GARDEN_MAINTAINERS_ALLOWLIST"
    [ -f "$source_file" ] || { log "maintainer allowlist override is unreadable: $source_file"; return 1; }
    while IFS= read -r line; do
      line="${line%%#*}"; line="$(printf '%s' "$line" | tr -d '[:space:]' | tr '[:upper:]' '[:lower:]')"
      [ -n "$line" ] && MAINTAINERS+=("$line")
    done < "$source_file"
  else
    verify="${GARDEN_MAINTAINER_APPROVAL_VERIFY_CLONE:-$GARDEN_STATE/maintainer-approval/verify}"
    ensure_clone "$verify"
    sync_clone "$verify"
    while IFS= read -r line; do
      line="${line%%#*}"; line="$(printf '%s' "$line" | tr -d '[:space:]' | tr '[:upper:]' '[:lower:]')"
      [ -n "$line" ] && MAINTAINERS+=("$line")
    done < <(git -C "$verify" show "origin/$JOURNAL_BRANCH:maintainers/allowlist" 2>/dev/null || true)
  fi
  # This fallback is intentionally narrow and documented, for a freshly seeded
  # journal before its explicit maintainer file is populated.
  if [ "${#MAINTAINERS[@]}" -eq 0 ]; then
    MAINTAINERS=(kriskowal erights)
    log "maintainers/allowlist is empty; using documented bootstrap owners: kriskowal, erights"
  fi
}

is_maintainer() {
  local login="$1" maintainer
  login="$(printf '%s' "$login" | tr '[:upper:]' '[:lower:]')"
  for maintainer in "${MAINTAINERS[@]}"; do
    [ "$maintainer" = "$login" ] && return 0
  done
  return 1
}

load_maintainers
meta="$("$GH" pr view "$pr" -R "$repo" --json reviewDecision,headRefOid 2>/dev/null)" \
  || { log "gh pr view $repo#$pr failed -- no maintainer approval"; exit 1; }
printf '%s' "$meta" | jq -e . >/dev/null 2>&1 \
  || { log "unparseable PR metadata for $repo#$pr -- no maintainer approval"; exit 1; }
decision="$(printf '%s' "$meta" | jq -r '.reviewDecision // ""')"
head="$(printf '%s' "$meta" | jq -r '.headRefOid // ""')"
# CHANGES_REQUESTED means a reviewer explicitly asked for changes.
# REVIEW_REQUIRED means branch protection requires a review but none submitted.
# Either is a hard block. An empty reviewDecision means the repo has no
# required-reviewer branch protection; fall through to the individual-review
# check below — that check still requires an effective maintainer approval.
# An unreadable head signals degenerate PR metadata (a broken read), so fail closed.
if [ "$decision" = CHANGES_REQUESTED ] || [ "$decision" = REVIEW_REQUIRED ] || [ -z "$head" ]; then
  log "merge blocked: no maintainer approval (reviewDecision=${decision:-none})"
  exit 1
fi

# Slurping all pages prevents a long review history from hiding the current state.
reviews="$("$GH" api --paginate "repos/$repo/pulls/$pr/reviews?per_page=100" 2>/dev/null)" \
  || { log "could not read reviews for $repo#$pr -- no maintainer approval"; exit 1; }
printf '%s\n' "$reviews" | jq -s -e . >/dev/null 2>&1 \
  || { log "unparseable reviews for $repo#$pr -- no maintainer approval"; exit 1; }

# Compute each maintainer's EFFECTIVE (latest) review state. Reviews arrive in
# chronological order, so the last state-bearing entry per login wins. COMMENTED
# and PENDING reviews carry no approval state and are ignored, so a later comment
# never masks a standing APPROVED. A review dismissed on GitHub has state DISMISSED
# (revoking a prior APPROVED); a later CHANGES_REQUESTED supersedes an earlier
# APPROVED. The reviewed commit_id is deliberately NOT consulted — an approval on an
# earlier head stays effective (see header).
declare -A EFFECTIVE=()
while IFS=$'\t' read -r login state; do
  [ -n "$login" ] || continue
  is_maintainer "$login" || continue
  login="$(printf '%s' "$login" | tr '[:upper:]' '[:lower:]')"
  EFFECTIVE["$login"]="$state"
done < <(printf '%s\n' "$reviews" | jq -r -s '
  [ .[] | .[]? ]
  | .[]
  | (.state // "") as $s
  | select($s=="APPROVED" or $s=="CHANGES_REQUESTED" or $s=="DISMISSED")
  | [ (.user.login // ""), $s ] | @tsv')

# A maintainer's effective CHANGES_REQUESTED is a hard veto even without branch
# protection, and even if another maintainer approved — never merge over it.
for login in "${!EFFECTIVE[@]}"; do
  if [ "${EFFECTIVE[$login]}" = CHANGES_REQUESTED ]; then
    log "merge blocked: maintainer $login has an effective CHANGES_REQUESTED review"
    exit 1
  fi
done
for login in "${!EFFECTIVE[@]}"; do
  if [ "${EFFECTIVE[$login]}" = APPROVED ]; then
    echo "maintainer-approval repo=$repo pr=$pr reviewer=$login head=$head"
    exit 0
  fi
done

log "merge blocked: no effective maintainer approval (head $head)"
exit 1
