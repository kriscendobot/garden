#!/bin/bash
# claim-job.sh — race for a job on the journal's job board.
#
# Usage:
#   GARDEN_ROLE=<role> claim-job.sh <open-path>
#
# <open-path> is the path the consumer learned from the bash daemon, relative
# to the journal worktree (e.g. `jobs/open/20260518T231500Z--a1b2c3--gamut-289.md`).
#
# Exit codes:
#   0  — claim won; the resulting `jobs/claimed/...` path is printed on stdout.
#   1  — claim lost (the file moved out of `open/` before our push, or our
#        push was rejected because someone else's claim landed first).
#  64  — usage error.
#
# The push to `origin/journal` is the serialization point. A rejected push
# is not retried with rebase: the rejection's whole semantics is that
# someone else's claim landed first, and our `git mv` from `open/<source>`
# no longer makes sense.

set -uo pipefail

if [ "$#" -lt 1 ]; then
  echo "usage: GARDEN_ROLE=<role> $0 <open-path>" >&2
  exit 64
fi

SOURCE=$1
if [ -z "${GARDEN_ROLE:-}" ]; then
  echo "claim-job: GARDEN_ROLE not set; cannot record claimant identity" >&2
  exit 64
fi
ROLE=$GARDEN_ROLE

SCRIPT_DIR=$(cd "$(dirname "$0")" && pwd)
GARDEN_ROOT=$(cd "$SCRIPT_DIR/../.." && pwd)
JRN="$GARDEN_ROOT/journal"

# The source path is supplied relative to the journal worktree. Refuse a
# path that does not start with jobs/open/.
case "$SOURCE" in
  jobs/open/*.md) ;;
  *) echo "claim-job: source must be under jobs/open/ (got $SOURCE)" >&2; exit 64;;
esac

BASE=$(basename "$SOURCE" .md)
# Filename shape: <UTC>--<sid>--<slug>. Recover sid and slug.
SHORT=$(echo "$BASE" | awk -F-- '{print $2}')
SLUG=$(echo "$BASE" | awk -F-- '{for (i=3;i<=NF;i++) printf "%s%s", $i, (i<NF?"--":"")}')
if [ -z "$SHORT" ] || [ -z "$SLUG" ]; then
  echo "claim-job: cannot parse short-id or slug from $BASE" >&2
  exit 64
fi

HOST=$(hostname -s)
SID=$(openssl rand -hex 2)
UTC=$(date -u +%Y%m%dT%H%M%SZ)
ISO=$(date -u +%Y-%m-%dT%H:%M:%SZ)

DEST_REL="jobs/claimed/${UTC}--${HOST}--${ROLE}--${SID}--${SHORT}--${SLUG}.md"

# Step 1: resync. A claim from stale HEAD is a lost race waiting to happen.
git -C "$JRN" fetch --quiet origin journal 2>/dev/null || true
git -C "$JRN" reset --hard origin/journal >/dev/null 2>&1 || true

# Step 2: verify the job is still on the board.
if [ ! -f "$JRN/$SOURCE" ]; then
  echo "lost-race"
  exit 1
fi

# Step 3: move and stamp.
git -C "$JRN" mv "$SOURCE" "$DEST_REL" >/dev/null

# Append claim-frontmatter fields after the second `---` line.
awk -v r="$ROLE" -v h="$HOST" -v s="$SID" -v t="$ISO" '
  BEGIN { count = 0; done = 0 }
  /^---$/ {
    count++
    if (count == 2 && !done) {
      print "claimed_by_role: " r
      print "claimed_by_host: " h
      print "claimed_by_session: " s
      print "claimed_at: " t
      done = 1
    }
  }
  { print }
' "$JRN/$DEST_REL" > "$JRN/$DEST_REL.tmp" && mv "$JRN/$DEST_REL.tmp" "$JRN/$DEST_REL"

git -C "$JRN" add -A "$DEST_REL" "$SOURCE" >/dev/null
git -C "$JRN" commit -m "jobs: claim $SHORT on $HOST/$ROLE/$SID" >/dev/null

# Step 4: push. Rejection = lost race; do not retry with rebase.
if git -C "$JRN" push --quiet origin HEAD:journal 2>/dev/null; then
  echo "$DEST_REL"
  exit 0
fi

# Lost: hard-reset to discard our local claim commit.
git -C "$JRN" reset --hard origin/journal >/dev/null 2>&1 || true
echo "lost-race"
exit 1
