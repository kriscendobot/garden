#!/bin/bash
# The declarative design-to-build directive has exactly three terminal actions:
# post its fixed follow-up, re-arm one deterministic once schedule, or notify the
# maintainer that the design closed unmerged. All classification comes from the
# typed metadata source stub; no report prose is involved in the decision.
set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
HANDLER="$HERE/../handlers/follow-up-claude.sh"
TR="$(mktemp -d "${TMPDIR:-/tmp}/follow-up-design-build.XXXXXX")"
trap 'rm -rf "$TR"' EXIT

BLOCKS="$TR/blocks"
DIGEST="$TR/digest"
LOG="$TR/calls"
PRODUCER="$HERE/follow-up-design-build-producer-stub.sh"
SOURCE="$HERE/follow-up-design-build-source-stub.sh"
cat > "$BLOCKS" <<'EOF'
DESIGN-BUILD-RECHECK daemon-commit https://github.com/endojs/endo-but-for-bots/pull/988 3600 mtown-commit-act
Act on the daemon commit formula in minion.town.
Origin: https://github.com/kriscendobot/minion.town/pull/41
END-DESIGN-BUILD-RECHECK
EOF
cp "$BLOCKS" "$DIGEST"

run_case() {
  : > "$LOG"
  env GARDEN_ROOT="$(cd "$HERE/../../.." && pwd)" \
    GARDEN_STATE="$TR/state" GARDEN=test GARDEN_TEST=1 \
    GARDEN_FOLLOWUP_CLAUDE="$TR/definitely-missing-agent" \
    GARDEN_FOLLOWUP_DESIGN_BUILD_SOURCE="$SOURCE" FDB_STATE="$1" \
    GARDEN_FOLLOWUP_NOW=0 FDB_LOG="$LOG" \
    GARDEN_FOLLOWUP_POST_JOB="$TR/post-job" \
    GARDEN_FOLLOWUP_SET_SCHEDULE="$TR/set-schedule" \
    GARDEN_FOLLOWUP_SET_SCHEDULE_ONCE="$TR/set-schedule-once" \
    GARDEN_FOLLOWUP_INBOX_SEND="$TR/inbox-send" \
    "$HANDLER" "$DIGEST"
}

for producer in post-job set-schedule set-schedule-once inbox-send; do
  ln -s "$PRODUCER" "$TR/$producer"
done

run_case $'OPEN\t-'
grep -q '^CALL set-schedule-once <daemon-commit> <1970-01-01T01:00:00Z> <daemon-commit-19700101-010000>$' "$LOG"
grep -q '^DESIGN-BUILD-RECHECK daemon-commit https://github.com/endojs/endo-but-for-bots/pull/988 3600 mtown-commit-act$' "$LOG"
if grep -q '^CALL post-job\|^CALL inbox-send' "$LOG"; then exit 1; fi

run_case $'MERGED\thttps://github.com/endojs/endo-but-for-bots/pull/1200'
grep -q '^CALL post-job <mtown-commit-act>$' "$LOG"
grep -q '^Act on the daemon commit formula in minion.town.$' "$LOG"
if grep -q 'Build PR detected' "$LOG"; then exit 1; fi
if grep -q '^CALL set-schedule-once\|^CALL inbox-send' "$LOG"; then exit 1; fi

run_case $'CLOSED\t-'
grep -q '^CALL inbox-send <maintainer>$' "$LOG"
grep -q 'closed without merging' "$LOG"
if grep -q '^CALL post-job\|^CALL set-schedule-once' "$LOG"; then exit 1; fi

set +e
run_case FAIL >/dev/null 2>&1
rc=$?
set -e
[ "$rc" -eq 75 ]
[ ! -s "$LOG" ]

echo 'PASS: design-to-build directive deterministically posts, re-arms, or messages from typed PR/timeline metadata'
