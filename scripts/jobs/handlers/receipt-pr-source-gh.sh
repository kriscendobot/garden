#!/bin/bash
# receipt-pr-source-gh.sh — default terminally-closed-PR source for receipt-watcher.sh.
#
# Invoked as: receipt-pr-source-gh.sh <owner/name>
#
# Emits one TSV line per recently-closed pull request on the repo:
#
#   pr_number  disposition  completed_at
#
# where disposition is `merged` (merged_at set) or `closed` (closed without merge),
# and completed_at is the merge/close ISO timestamp. The watcher applies the
# cursor (completed-after), the garden-worked gate, and the receipt-exists gate
# itself, against this raw enumeration.
#
# BOUNDED, newest-first. Unlike the OPEN-PR sources (small sets, fully paginated),
# the CLOSED set on a busy repo is thousands deep and re-fetching all of it every
# tick is wasteful and rate-limit-hostile. The watcher only needs PRs completed
# since its last cursor (minutes ago), so we fetch closed PRs sorted by UPDATED
# desc and take a bounded prefix — far more than a tick's worth of new completions.
# Tunable via GARDEN_RECEIPT_PAGES (pages of per_page=100; default 2 → 200 PRs).
#
# Monitoring safety: reads only PR number/state/timestamps — never a PR body or
# comment, nothing author-controlled, nothing that reaches an LLM. Injection-safe
# by construction; the watcher is still gated to comment-repos/ for defence in depth.
#
# Silent-failure discipline: require_tools fails loud; a structural gh failure
# surfaces its stderr and exits nonzero so the watcher never mistakes a broken
# enumeration for "no closed PRs".

set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=../common.sh
source "$HERE/../common.sh"
export GARDEN_TAG="receipt-pr-source"

repo="${1:?usage: receipt-pr-source-gh.sh <owner/name>}"
require_tools gh jq
pages="${GARDEN_RECEIPT_PAGES:-2}"
case "$pages" in ''|*[!0-9]*) pages=2 ;; esac

p=1
while [ "$p" -le "$pages" ]; do
  out="$(gh_api_retry "repos/$repo/pulls?state=closed&sort=updated&direction=desc&per_page=100&page=$p")"
  count="$(printf '%s' "$out" | jq -r 'length')"
  printf '%s' "$out" | jq -r '.[]
      | [ (.number|tostring),
          (if .merged_at then "merged" else "closed" end),
          (.merged_at // .closed_at // "") ]
      | @tsv'
  # Stop early once a page returns fewer than a full page (end of the closed set).
  [ "${count:-0}" -lt 100 ] && break
  p=$((p+1))
done
