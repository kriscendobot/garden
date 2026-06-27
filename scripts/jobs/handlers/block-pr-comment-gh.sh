#!/bin/bash
# block-pr-comment-gh.sh — default courtesy-comment poster for the proxy's
# blocked-job parking (scripts/jobs/proxy.sh § park_blocked_jobs).
#
# Invoked as: block-pr-comment-gh.sh <owner/repo> <pr-number> <plan-base>
#
# Posts ONE informational comment on the BOT-FORK pull request noting that
# completing it auto-promotes the parked garden plan `<plan-base>` back to todo/.
# The comment is COURTESY ONLY — the load-bearing unblock trigger is the parked
# plan's `blocked_on:` field, which the unblock watcher scans deterministically.
# So this poster is BEST-EFFORT: it never fails its caller (the park must complete
# whether or not the comment lands), but it never silently swallows a MISSING
# tool either — a missing `gh` is logged, not hidden.
#
# Safety gate (CLAUDE.md § scope; memory: bot repos + bot forks only): this is the
# proxy's only outward action. It refuses agoric-sdk unconditionally and makes NO
# state change to the PR beyond a single comment. The fleet `gh`
# (scripts/jobs/bin/gh) is pinned to the bot identity.

set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=../common.sh
source "$HERE/../common.sh"
GARDEN_TAG="block-pr-comment"

repo="${1:?usage: block-pr-comment-gh.sh <owner/repo> <pr-number> <plan-base>}"
num="${2:?usage: block-pr-comment-gh.sh <owner/repo> <pr-number> <plan-base>}"
base="${3:?usage: block-pr-comment-gh.sh <owner/repo> <pr-number> <plan-base>}"

# Hard scope gate: never touch agoric-sdk (off-limits). Refuse loudly so a
# mis-routed blocker can never make the proxy comment there.
case "$repo" in
  */agoric-sdk|agoric/*|Agoric/*)
    log "refusing courtesy comment on out-of-scope repo '$repo' (agoric-sdk/agoric is off-limits)"
    exit 0
    ;;
esac

# Best-effort: a missing gh is logged (never hidden), but does not fail the park.
if ! command -v gh >/dev/null 2>&1; then
  log "WARN: gh not on PATH; skipping courtesy comment on $repo#$num (load-bearing record is the plan's blocked_on field)"
  exit 0
fi

body="Completing this pull request promotes garden plan \`$base\` back to its work queue (\`todo/\`). Posted automatically by the garden proxy's blocked-job parking; no action required."

if gh pr comment "$num" --repo "$repo" --body "$body" >/dev/null 2>&1; then
  log "posted courtesy unblock note on $repo#$num for plan '$base'"
else
  log "WARN: could not post courtesy comment on $repo#$num (non-fatal; the plan's blocked_on field is the load-bearing trigger)"
fi
exit 0
