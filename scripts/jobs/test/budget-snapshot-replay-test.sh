#!/bin/bash
# budget-snapshot-replay-test.sh — a lost snapshot CAS is retried WITHOUT the
# working tree: the losing commit's host-owned budget/live blob is grafted onto
# the fresh journal tip and pushed. The retry must not call sync_clone, whose
# reset --hard over the ~68k-file journal took minutes per attempt on loaded
# virtiofs and lost every CAS (oros 2026-10-12 13:12-16:12Z, derotated at 14:05).
set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
JOBS="$(cd "$HERE/.." && pwd)"
TR="$(mktemp -d "${TMPDIR:-/tmp}/garden-budget-replay.XXXXXX")"
trap 'rm -rf "$TR"' EXIT

export GARDEN_TEST=1
export GARDEN=testhost
export GARDEN_STATE="$TR/state"
GARDEN_USAGE_NOW="$(date -u -d 2026-08-22T12:00:00Z +%s)"
export GARDEN_USAGE_NOW
export GARDEN_CCUSAGE_LOGDIR="$TR/logs"
export GARDEN_NO_MAINTAINER_ALERT=1
export GARDEN_BUDGET_SNAPSHOT_STAGGER_SECS=0
# Publish against the tip the measure pass synced, so only the retry is observed.
export GARDEN_BUDGET_PUBLISH_RESYNC_SECS=600
export GARDEN_BUDGET_PUBLISH_OUTAGE_LATCH="$TR/latch"
unset GARDEN_BUDGET_PUBLISH_ATTEMPTS GARDEN_BUDGET_PUBLISH_BACKOFF_BASE_MS \
  GARDEN_BUDGET_PUBLISH_BACKOFF_CAP_MS

BARE="$TR/journal.git"; SEED="$TR/seed"; PEER="$TR/peer"; CLONE="$TR/publisher"
COUNT="$TR/push-count"; CLASSES="$TR/push-classes"
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
backoff() { :; }
SYNCS="$TR/syncs"; : > "$SYNCS"
eval "_orig_sync_clone() $(declare -f sync_clone | tail -n +2)"
sync_clone() { [ -z "${WATCH_SYNCS:-}" ] || echo sync >> "$SYNCS"; _orig_sync_clone "$@"; }
ensure_clone "$CLONE"
sync_clone "$CLONE"
# From here on any worktree re-sync is the slow path this test forbids.
WATCH_SYNCS=1
: > "$CLASSES"
budget_publish_local_pool "$CLONE" \
  || fail "one lost CAS exhausted publication (class=$_BUDGET_PUBLISH_FAILURE_CLASS)"

[ "$(cat "$COUNT")" -eq 2 ] || fail "expected 2 push attempts, saw $(cat "$COUNT")"
[ "$(paste -sd' ' "$CLASSES")" = cas ] || fail "first push was not a lost CAS"
[ ! -s "$SYNCS" ] || fail "the retry re-synced the working tree ($(wc -l < "$SYNCS") sync_clone call(s))"
git --git-dir="$BARE" cat-file -e journal2:msgs/peer-write \
  || fail "the peer's winning write was lost"
git --git-dir="$BARE" show journal2:budget/live/testhost | grep -q '^spend: 400$' \
  || fail "the replayed snapshot did not land on the peer's tip"
[ "$(git --git-dir="$BARE" rev-list --count journal2)" -eq 3 ] \
  || fail "expected seed, peer, and one snapshot commit on journal2"
git --git-dir="$BARE" diff --name-only journal2~1 journal2 | grep -qx budget/live/testhost \
  || fail "the replayed commit touched more than the snapshot"
[ "$(git --git-dir="$BARE" diff --name-only journal2~1 journal2 | wc -l)" -eq 1 ] \
  || fail "the replayed commit touched more than the snapshot"

# The next ordinary sync leaves a clean checkout at the published tip.
_orig_sync_clone "$CLONE"; clone_unlock "$CLONE"
[ -z "$(git -C "$CLONE" status --porcelain)" ] || fail "clone left dirty after replay"
[ -f "$CLONE/msgs/peer-write" ] || fail "clone did not pick up the peer write"

echo 'PASS: a lost snapshot CAS replays onto the fresh tip without touching the working tree'
