#!/bin/bash
# block-job.sh — a gardener signals that its job is BLOCKED on an artifact.
#
# Usage: block-job.sh <doer-base> <artifact> [<body-file>]   (body else stdin)
#
#   <doer-base>  the blocked job's basename (normally the gardener's own job).
#   <artifact>   the blocker: a pull-request URL (https://github.com/<o>/<r>/pull/<n>)
#                or another job's basename. Completing it auto-unblocks this job.
#   [body-file]  optional human-readable explanation of WHY it is blocked; becomes
#                the parked plan job's body if the job is not still on the board.
#
# This is the STRUCTURED blocking convention. It posts ONE message to the
# maintainer inbox carrying a `blocked_on:` frontmatter field (and reply_to=<doer>
# so the blocked job is unambiguous). The proxy's deterministic blocked-parking
# pre-pass (scripts/jobs/proxy.sh) then, with NO `claude -p`:
#   1. parks <doer-base> as a `gate: blocked` plan job carrying blocked_on=<artifact>,
#   2. leaves a courtesy note on a bot-fork PR blocker (load-bearing record is the
#      plan's blocked_on field), and
#   3. archives this notification from the maintainer inbox.
# The unblock watcher (scripts/jobs/unblock.sh) promotes the parked job back to
# todo/ when the blocker completes (PR merged/closed, or blocking job in tada/).
#
# Because the signal is structured, the proxy never needs the LLM to extract the
# (blocked-job, blocker) pair. After calling this, a gardener should stop working
# the job and return — the work resumes automatically as a fresh claim once the
# blocker clears. See roles/proxy/AGENT.md § Blocked-job parking.

set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
doer="${1:?usage: block-job.sh <doer-base> <artifact> [body-file]}"
artifact="${2:?usage: block-job.sh <doer-base> <artifact> [body-file]}"
body="${3:-}"
case "$doer" in */*|.*|'') echo "block-job: illegal doer '$doer'" >&2; exit 1;; esac

export GARDEN_REPLY_TO="$doer"
export GARDEN_BLOCKED_ON="$artifact"
export GARDEN_SENDER="${GARDEN_SENDER:-gardener:$doer}"
exec "$HERE/inbox-send.sh" maintainer ${body:+"$body"}
