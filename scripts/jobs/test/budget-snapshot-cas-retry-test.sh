#!/bin/bash
# budget-snapshot-cas-retry-test.sh — the live budget snapshot publish absorbs a
# lost journal CAS: peers push before three consecutive publisher pushes, and the
# final host-staggered retry re-syncs on the last winning tip immediately before
# it lands. The scaler's WARN must not fire for that tick.
# Regression for the push-class=cas WARNs of 2026-10-07T19:17Z, 10-08T08:02Z,
# 10-08T16:17Z, 10-09T07:47Z, 10-10T03:47Z, and 10-15T03:17:46Z, where
# every bounded retry re-raced a journal burst.
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
FINAL_STAGGERS="$TR/final-staggers"; FETCHES="$TR/fetches"
EVENTS="$TR/events"
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

# A peer's unrelated journal write lands just before each of the first three
# publisher pushes. This reproduces a sustained journal burst instead of proving
# only that one collision is recoverable.
_push_journal() {
  local dir="$1" n
  n="$(cat "$COUNT" 2>/dev/null || echo 0)"; n=$((n + 1)); printf '%s\n' "$n" > "$COUNT"
  printf 'push-%s\n' "$n" >> "$EVENTS"
  if [ "$n" -le 3 ]; then
    mkdir -p "$PEER/msgs"
    printf 'peer %s\n' "$n" > "$PEER/msgs/peer-write-$n"
    git -C "$PEER" add "msgs/peer-write-$n"
    git -C "$PEER" "${git_id[@]}" commit -qm "peer write $n"
    git -C "$PEER" push -q origin HEAD:journal2
  fi
  # shellcheck disable=SC2034 # commit_and_push classifies this after the stub returns.
  GARDEN_PUSH_STDERR="$(git -C "$dir" push origin HEAD:journal2 2>&1 1>/dev/null)"
}
contention_record() { [ "$2" != push-class ] || printf '%s\n' "$3" >> "$CLASSES"; }
# Record the jitter window each retry draws from instead of sleeping.
backoff() { printf '%s %s %s\n' "$1" "$GARDEN_BACKOFF_BASE_MS" "$GARDEN_BACKOFF_CAP_MS" >> "$SLEEPS"; }
budget_snapshot_final_stagger() {
  printf '%s\n' "$(budget_snapshot_final_stagger_secs "$GARDEN")" >> "$FINAL_STAGGERS"
}

ensure_clone "$CLONE"
sync_clone "$CLONE"
# Count the retry path's fresh fetches after the initial sync. Each lost CAS must
# be followed by one, including the fetch immediately before the final write.
eval "_orig_journal_fetch() $(declare -f journal_fetch | tail -n +2)"
journal_fetch() { echo fetch >> "$FETCHES"; echo fetch >> "$EVENTS"; _orig_journal_fetch "$@"; }
: > "$CLASSES"; : > "$SLEEPS"; : > "$FINAL_STAGGERS"; : > "$FETCHES"; : > "$EVENTS"
if budget_publish_local_pool "$CLONE"; then
  budget_publish_note_success
else
  budget_publish_note_failure
  fail "one lost CAS exhausted publication (class=$_BUDGET_PUBLISH_FAILURE_CLASS)"
fi

[ "$(cat "$COUNT")" -eq 4 ] || fail "expected 4 push attempts, saw $(cat "$COUNT")"
[ "$(paste -sd' ' "$CLASSES")" = "cas cas cas" ] \
  || fail "three peer wins were not classified as lost CASes (classes: $(paste -sd' ' "$CLASSES"))"
[ "$(paste -sd' ' "$SLEEPS")" = "1 1000 8000 2 1000 8000" ] \
  || fail "early retries did not use seconds-scale jitter (saw '$(paste -sd' ' "$SLEEPS")')"
[ "$(wc -l < "$FINAL_STAGGERS")" -eq 1 ] \
  || fail "final CAS retry did not take exactly one host-staggered slot"
final_delay="$(cat "$FINAL_STAGGERS")"
[ "$final_delay" = "$(budget_snapshot_final_stagger_secs "$GARDEN")" ] \
  || fail "final CAS retry used the wrong host-staggered slot"
if [ "$final_delay" -lt 1 ] || [ "$final_delay" -gt 45 ] \
  || [ "$final_delay" = "$(budget_snapshot_final_stagger_secs peerhost)" ]; then
  fail "final retry slots are not bounded and host-keyed (testhost=$final_delay)"
fi
[ "$(paste -sd' ' "$EVENTS")" = "push-1 fetch push-2 fetch push-3 fetch push-4 fetch" ] \
  || fail "CAS retries did not fetch immediately before each new write (events: $(paste -sd' ' "$EVENTS"))"
for n in 1 2 3; do
  git --git-dir="$BARE" cat-file -e "journal2:msgs/peer-write-$n" \
    || fail "peer winning write $n was lost"
done
git --git-dir="$BARE" show journal2:budget/live/testhost | grep -q '^spend: 400$' \
  || fail "the retried snapshot did not land on the peer's tip"
[ ! -e "$GARDEN_BUDGET_PUBLISH_OUTAGE_LATCH" ] \
  || fail "a recovered CAS race armed the publish-failure WARN latch"

echo 'PASS: repeated snapshot CAS losses end in one host-staggered, freshly synced publication without a WARN'
