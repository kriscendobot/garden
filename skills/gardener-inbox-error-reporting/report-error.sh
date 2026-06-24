#!/bin/bash
# report-error.sh -- append a failure section to the gardener inbox.
#
# Usage:
#   report-error.sh --transcript <path> --lane <n> [--pr <id>] [--state <name>] [--context <line>]
#
# Targets the v2 job-board / message-bus branch (directory `journal`, branch
# `journal2` -- see scripts/jobs/common.sh). Override with JOURNAL_BRANCH.
#
# See skills/gardener-inbox-error-reporting/SKILL.md for the contract.

set -uo pipefail

# The journal branch. Directory is `journal`; branch is `journal2` (v2).
: "${JOURNAL_BRANCH:=journal2}"

TRANSCRIPT=
LANE=
PR="(none)"
STATE=unknown
CONTEXT="(no context)"

while [ "$#" -gt 0 ]; do
  case "$1" in
    --transcript) TRANSCRIPT=$2; shift 2;;
    --lane) LANE=$2; shift 2;;
    --pr) PR=$2; shift 2;;
    --state) STATE=$2; shift 2;;
    --context) CONTEXT=$2; shift 2;;
    *) echo "report-error: unknown option: $1" >&2; exit 64;;
  esac
done

if [ -z "$TRANSCRIPT" ] || [ -z "$LANE" ]; then
  echo "usage: $0 --transcript <path> --lane <n> [--pr <id>] [--state <name>] [--context <line>]" >&2
  exit 64
fi

GARDEN_HOST=${GARDEN_HOST:-$(hostname -s)}
GARDEN_JOURNAL=${GARDEN_JOURNAL:-}
if [ -z "$GARDEN_JOURNAL" ]; then
  SCRIPT_DIR=$(cd "$(dirname "$0")" && pwd)
  GARDEN_JOURNAL=$(cd "$SCRIPT_DIR/../.." && pwd)/journal
fi

test -d "$GARDEN_JOURNAL" || { echo "report-error: journal worktree missing: $GARDEN_JOURNAL" >&2; exit 1; }

# 1. Hash the transcript.
if [ ! -f "$TRANSCRIPT" ]; then
  echo "report-error: transcript file missing: $TRANSCRIPT" >&2
  exit 1
fi
TRANSCRIPT_SHA=$(git -C "$GARDEN_JOURNAL" hash-object -w --stdin < "$TRANSCRIPT")

# 2. Build the inbox section.
INBOX_DIR="$GARDEN_JOURNAL/inboxes/$GARDEN_HOST"
INBOX_FILE="$INBOX_DIR/gardener.md"
mkdir -p "$INBOX_DIR"

ISO=$(date -u +%Y-%m-%dT%H:%M:%SZ)

if [ ! -f "$INBOX_FILE" ]; then
  cat > "$INBOX_FILE" <<EOF
---
host: $GARDEN_HOST
role: gardener
last_drained_at: 1970-01-01T00:00:00Z
last_drained_commit:
---

# gardener inbox state on $GARDEN_HOST

Append-only failure log. Each section is a discrete failure event
appended by a job-board service or worker via
\`skills/gardener-inbox-error-reporting/report-error.sh\`. The gardener
reads entries on its next dispatch.

EOF
fi

cat >> "$INBOX_FILE" <<EOF

## lane $LANE -- $STATE failure at $ISO

- PR: $PR
- State: $STATE
- Transcript SHA: $TRANSCRIPT_SHA
- Context: $CONTEXT

Inspect via \`git -C journal cat-file -p $TRANSCRIPT_SHA\`.
EOF

# 3. Commit and push. The retry loop mirrors skills/journal-sync.
git -C "$GARDEN_JOURNAL" add "inboxes/$GARDEN_HOST/gardener.md" >/dev/null 2>&1 || true
if ! git -C "$GARDEN_JOURNAL" diff --cached --quiet 2>/dev/null; then
  git -C "$GARDEN_JOURNAL" commit -m "inboxes(gardener): error from lane $LANE state $STATE" >/dev/null 2>&1 || true
  for i in 1 2 3; do
    if git -C "$GARDEN_JOURNAL" push --quiet origin "HEAD:$JOURNAL_BRANCH" 2>/dev/null; then
      break
    fi
    git -C "$GARDEN_JOURNAL" fetch --quiet origin "$JOURNAL_BRANCH" 2>/dev/null || true
    git -C "$GARDEN_JOURNAL" rebase "origin/$JOURNAL_BRANCH" >/dev/null 2>&1 || {
      git -C "$GARDEN_JOURNAL" rebase --abort >/dev/null 2>&1 || true
      sleep $((i*i))
    }
  done
fi

echo "$TRANSCRIPT_SHA"
