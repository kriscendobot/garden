#!/bin/bash
# report-error.sh -- append a failure section to the gardener inbox, and commit
# the transcript itself so the SHA that section names is reachable off-host.
#
# Usage:
#   report-error.sh --transcript <path> --lane <n> [--pr <id>] [--state <name>] [--context <line>]
#
# Env:
#   GARDEN_REPORT_ERROR_MAX_BYTES  cap on committed transcript bytes (default
#                                  65536; 0 disables). Applied BEFORE hashing.
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

GARDEN=${GARDEN:-$(hostname -s)}
GARDEN_JOURNAL=${GARDEN_JOURNAL:-}
if [ -z "$GARDEN_JOURNAL" ]; then
  SCRIPT_DIR=$(cd "$(dirname "$0")" && pwd)
  GARDEN_JOURNAL=$(cd "$SCRIPT_DIR/../.." && pwd)/journal
fi

test -d "$GARDEN_JOURNAL" || { echo "report-error: journal worktree missing: $GARDEN_JOURNAL" >&2; exit 1; }

# Cap on the bytes committed per escalation. The capture lands in the journal2
# TREE (see step 1b), so unlike a loose blob it is permanent and every host pays
# for it on every fetch -- and journal2 is deliberately NOT the transcript
# archive (that is the `transcripts2` orphan branch; see
# designs/transcript-journal-capture.md), so an escalation attachment must stay
# small. 64 KiB is not arbitrary: it is exactly the slice the fleet's capture
# readers consume. Oversized transcripts keep half of the cap from each end:
# setup and initial diagnostics are often at the beginning, while the failure is
# usually at the end. 0 disables the cap.
: "${GARDEN_REPORT_ERROR_MAX_BYTES:=65536}"

# 1. Hash the transcript.
if [ ! -f "$TRANSCRIPT" ]; then
  echo "report-error: transcript file missing: $TRANSCRIPT" >&2
  exit 1
fi
# SOURCE is the byte-exact content that gets hashed AND committed, so the SHA
# named in the inbox always resolves to the committed capture. When the caller's
# file is used verbatim SOURCE is that file; the two rewrite cases below stage a
# temp copy instead, so the caller's file is never mutated.
SOURCE=$TRANSCRIPT
TRANSCRIPT_COPY=
# Empty-blob defense, centralized here so no caller can ever escalate the
# zero-byte git blob (e69de29b...): a fired escalation with no diagnostic for
# the responder. If the transcript is empty, hash a synthetic, self-describing
# line instead so the escalated blob is always fetchable and non-empty.
if [ ! -s "$TRANSCRIPT" ]; then
  TRANSCRIPT_COPY=$(mktemp)
  printf 'report-error: handler produced no captured output (empty transcript); rc/state=%s, context=%s\n' \
    "$STATE" "$CONTEXT" > "$TRANSCRIPT_COPY"
  SOURCE=$TRANSCRIPT_COPY
elif [ "$GARDEN_REPORT_ERROR_MAX_BYTES" -gt 0 ] \
  && [ "$(wc -c < "$TRANSCRIPT")" -gt "$GARDEN_REPORT_ERROR_MAX_BYTES" ]; then
  # Truncate BEFORE hashing, never after: the responder's `cat-file -p <sha>`
  # must yield exactly the bytes the escalation is about.
  TRANSCRIPT_COPY=$(mktemp)
  TRANSCRIPT_BYTES=$(wc -c < "$TRANSCRIPT")
  HEAD_BYTES=$((GARDEN_REPORT_ERROR_MAX_BYTES / 2))
  TAIL_BYTES=$((GARDEN_REPORT_ERROR_MAX_BYTES - HEAD_BYTES))
  OMITTED_BYTES=$((TRANSCRIPT_BYTES - HEAD_BYTES - TAIL_BYTES))
  {
    printf 'report-error: transcript truncated from %s bytes; retained first %s and last %s bytes. Raise GARDEN_REPORT_ERROR_MAX_BYTES to keep more.\n\n' \
      "$TRANSCRIPT_BYTES" "$HEAD_BYTES" "$TAIL_BYTES"
    head -c "$HEAD_BYTES" "$TRANSCRIPT"
    printf '\n\n[report-error: omitted %s bytes from the middle of the transcript]\n\n' \
      "$OMITTED_BYTES"
    tail -c "$TAIL_BYTES" "$TRANSCRIPT"
  } > "$TRANSCRIPT_COPY"
  SOURCE=$TRANSCRIPT_COPY
fi

TRANSCRIPT_SHA=$(git -C "$GARDEN_JOURNAL" hash-object -w --stdin < "$SOURCE")
if [ -z "$TRANSCRIPT_SHA" ]; then
  echo "report-error: could not hash the transcript into $GARDEN_JOURNAL" >&2
  [ -z "$TRANSCRIPT_COPY" ] || rm -f "$TRANSCRIPT_COPY"
  exit 1
fi

# 1b. Make the transcript REACHABLE to off-host responders.
#
# `hash-object -w` alone writes a LOOSE blob: it lives in this clone's object DB
# and nothing in the pushed history points at it, so `git push HEAD:journal2`
# does not carry it and every off-host responder (the central mentor) gets an
# escalation naming a SHA it cannot `cat-file`. Committing the same bytes as a
# tracked, content-addressed file puts the blob in the pushed TREE, so it rides
# the existing push and resolves after a plain `journal2` fetch -- which is
# exactly what the "Inspect via git cat-file" line below promises.
#
# The path is the SHA, so the write is idempotent and deduped: an identical
# transcript escalated twice reuses one file and adds no bytes to the branch.
CAPTURE_REL="inboxes/$GARDEN/captures/$TRANSCRIPT_SHA"
CAPTURE_FILE="$GARDEN_JOURNAL/$CAPTURE_REL"
mkdir -p "$(dirname "$CAPTURE_FILE")"
[ -f "$CAPTURE_FILE" ] || cp "$SOURCE" "$CAPTURE_FILE"
[ -z "$TRANSCRIPT_COPY" ] || rm -f "$TRANSCRIPT_COPY"

# 2. Build the inbox section.
INBOX_DIR="$GARDEN_JOURNAL/inboxes/$GARDEN"
INBOX_FILE="$INBOX_DIR/gardener.md"
mkdir -p "$INBOX_DIR"

ISO=$(date -u +%Y-%m-%dT%H:%M:%SZ)

if [ ! -f "$INBOX_FILE" ]; then
  cat > "$INBOX_FILE" <<EOF
---
host: $GARDEN
role: gardener
last_drained_at: 1970-01-01T00:00:00Z
last_drained_commit:
---

# gardener inbox state on $GARDEN

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
- Capture: $CAPTURE_REL

Inspect via \`git -C journal cat-file -p $TRANSCRIPT_SHA\` (or read
\`journal/$CAPTURE_REL\`) -- both work off-host after a plain \`journal2\` fetch.
EOF

# 3. Commit and push. The retry loop mirrors skills/journal-sync.
# Both pathspecs: the inbox section NAMES the SHA, the capture file is what makes
# that SHA reachable from the pushed branch. Staging them together keeps the two
# in one commit, so a responder never reads a section whose capture is missing.
git -C "$GARDEN_JOURNAL" add "inboxes/$GARDEN/gardener.md" "$CAPTURE_REL" >/dev/null 2>&1 || true
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
