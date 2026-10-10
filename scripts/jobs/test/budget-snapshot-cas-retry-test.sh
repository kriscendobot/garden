#!/bin/bash
# budget-snapshot-cas-retry-test.sh — the live budget snapshot publish absorbs a
# lost journal CAS: a peer pushes first, the publisher's first push is rejected
# as non-fast-forward (push-class=cas), and the jittered retry re-syncs, rebuilds
# on the peer's tip, and lands. The scaler's WARN must not fire for that tick.
# Regression for the push-class=cas WARNs of 2026-10-07T19:17Z, 10-08T08:02Z,
# 10-08T16:17Z, 10-09T07:47Z and 10-10T03:47Z, where three retries 0-100ms
# apart all re-raced the same quarter-hour burst.
set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
JOBS="$(cd "$HERE/.." && pwd)"
TR="$(mktemp -d "${TMPDIR:-/tmp}/garden-budget-cas-retry.XXXXXX")"
trap 'rm -rf "$TR"' EXIT

export GARDEN_TEST=1
export GARDEN=testhost
export GARDEN_STATE="$TR/state"
GARDEN_USAGE_NOW="$(date -u -d 2026-08-22T12:00:00Z +%s)"
export GARDEN_USAGE_NOW
export GARDEN_CCUSAGE_LOGDIR="$TR/logs"
export GARDEN_NO_MAINTAINER_ALERT=1
export GARDEN_BUDGET_SNAPSHOT_STAGGER_SECS=0
export GARDEN_BUDGET_PUBLISH_OUTAGE_LATCH="$TR/latch"
unset GARDEN_BUDGET_PUBLISH_ATTEMPTS GARDEN_BUDGET_PUBLISH_BACKOFF_BASE_MS \
  GARDEN_BUDGET_PUBLISH_BACKOFF_CAP_MS

BARE="$TR/journal.git"; SEED="$TR/seed"; PEER="$TR/peer"; CLONE="$TR/publisher"
COUNT="$TR/push-count"; CLASSES="$TR/push-classes"; SLEEPS="$TR/backoffs"
export JOURNAL_REMOTE="$BARE"
git_id=(-c user.name=test -c user.email=test@example.invalid)
fail() { echo "FAIL: $*"; exit 1; }

git init -q --bare "$BARE"
git init -q "$SEED"
git -C "$SEED" checkout -q -b journal2
mkdir -p "$SEED/config"
printf '%s\n' 'anthropic:testhost anthropic testhost weekly-tokens 1000' > "$SEED/config/budget-pools"
git -C "$SEED" add config/budget-pools
git -C "$SEED" "${git_id[@]}" commit -qm seed
git -C "$SEED" push -q "$BARE" journal2
git clone -q --single-branch --branch journal2 "$BARE" "$PEER"

mkdir -p "$GARDEN_CCUSAGE_LOGDIR/p"
printf '%s\n' \
  '{"type":"assistant","timestamp":"2026-08-22T03:00:01Z","message":{"id":"live","usage":{"input_tokens":400,"output_tokens":0,"cache_creation_input_tokens":0,"cache_read_input_tokens":0}}}' \
  > "$GARDEN_CCUSAGE_LOGDIR/p/session.jsonl"

# shellcheck source=../common.sh
source "$JOBS/common.sh"

[ "$GARDEN_BUDGET_PUBLISH_ATTEMPTS" -eq 4 ] \
  || fail "default publish bound is $GARDEN_BUDGET_PUBLISH_ATTEMPTS pushes, want 1 + 3 retries"

# A peer's unrelated journal write lands just before the publisher's first push,
# so that push is a genuine non-fast-forward rejection from the real remote.
_push_journal() {
  local dir="$1" n
  n="$(cat "$COUNT" 2>/dev/null || echo 0)"; n=$((n + 1)); printf '%s\n' "$n" > "$COUNT"
  if [ "$n" -eq 1 ]; then
    mkdir -p "$PEER/msgs"
    printf 'peer\n' > "$PEER/msgs/peer-write"
    git -C "$PEER" add msgs/peer-write
    git -C "$PEER" "${git_id[@]}" commit -qm 'peer write'
    git -C "$PEER" push -q origin HEAD:journal2
  fi
  # shellcheck disable=SC2034 # commit_and_push classifies this after the stub returns.
  GARDEN_PUSH_STDERR="$(git -C "$dir" push origin HEAD:journal2 2>&1 1>/dev/null)"
}
contention_record() { [ "$2" != push-class ] || printf '%s\n' "$3" >> "$CLASSES"; }
# Record the jitter window each retry draws from instead of sleeping.
backoff() { printf '%s %s %s\n' "$1" "$GARDEN_BACKOFF_BASE_MS" "$GARDEN_BACKOFF_CAP_MS" >> "$SLEEPS"; }

ensure_clone "$CLONE"
sync_clone "$CLONE"
: > "$CLASSES"; : > "$SLEEPS"
if budget_publish_local_pool "$CLONE"; then
  budget_publish_note_success
else
  budget_publish_note_failure
  fail "one lost CAS exhausted publication (class=$_BUDGET_PUBLISH_FAILURE_CLASS)"
fi

[ "$(cat "$COUNT")" -eq 2 ] || fail "expected 2 push attempts, saw $(cat "$COUNT")"
[ "$(paste -sd' ' "$CLASSES")" = cas ] \
  || fail "first push was not classified as a lost CAS (classes: $(paste -sd' ' "$CLASSES"))"
[ "$(paste -sd' ' "$SLEEPS")" = "1 1000 8000" ] \
  || fail "retry did not back off on the seconds-scale publish window (saw '$(paste -sd' ' "$SLEEPS")')"
git --git-dir="$BARE" cat-file -e journal2:msgs/peer-write \
  || fail "the peer's winning write was lost"
git --git-dir="$BARE" show journal2:budget/live/testhost | grep -q '^spend: 400$' \
  || fail "the retried snapshot did not land on the peer's tip"
[ ! -e "$GARDEN_BUDGET_PUBLISH_OUTAGE_LATCH" ] \
  || fail "a recovered CAS race armed the publish-failure WARN latch"

echo 'PASS: a lost snapshot CAS re-syncs, backs off with jitter, and publishes without a WARN'
