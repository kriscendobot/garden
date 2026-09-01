#!/bin/bash
# budget-snapshot-publish-retry-test.sh — a transient journal push race is
# absorbed by re-syncing, rebuilding the cadence-bucketed snapshot, and retrying.
set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
JOBS="$(cd "$HERE/.." && pwd)"
TR="$(mktemp -d "${TMPDIR:-/tmp}/garden-budget-publish-retry.XXXXXX")"
trap 'rm -rf "$TR"' EXIT

export GARDEN_TEST=1
export GARDEN=testhost
export GARDEN_STATE="$TR/state"
GARDEN_USAGE_NOW="$(date -u -d 2026-08-22T12:00:00Z +%s)"
export GARDEN_USAGE_NOW
export GARDEN_CCUSAGE_LOGDIR="$TR/logs"
export GARDEN_BUDGET_PUBLISH_ATTEMPTS=3
export GARDEN_BACKOFF_BASE_MS=0
export GARDEN_BACKOFF_CAP_MS=0
export GARDEN_NO_MAINTAINER_ALERT=1

BARE="$TR/journal.git"
SEED="$TR/seed"
RIVAL="$TR/rival"
CLONE="$TR/publisher"
COUNT="$TR/push-count"
export JOURNAL_REMOTE="$BARE"
git_id=(-c user.name=test -c user.email=test@example.invalid)

git init -q --bare "$BARE"
git init -q "$SEED"
git -C "$SEED" checkout -q -b journal2
mkdir -p "$SEED/config"
printf '%s\n' 'anthropic:testhost anthropic testhost weekly-tokens 1000' > "$SEED/config/budget-pools"
git -C "$SEED" add config/budget-pools
git -C "$SEED" "${git_id[@]}" commit -qm seed
git -C "$SEED" remote add origin "$BARE"
git -C "$SEED" push -q -u origin journal2
git clone -q --single-branch --branch journal2 "$BARE" "$RIVAL"

mkdir -p "$GARDEN_CCUSAGE_LOGDIR/p"
printf '%s\n' \
  '{"type":"assistant","timestamp":"2026-08-22T03:00:01Z","message":{"id":"live","usage":{"input_tokens":900,"output_tokens":0,"cache_creation_input_tokens":0,"cache_read_input_tokens":0}}}' \
  > "$GARDEN_CCUSAGE_LOGDIR/p/session.jsonl"

# shellcheck source=../common.sh
source "$JOBS/common.sh"

# The first publisher push loses to a rival config update. A correct retry
# re-syncs that update and rebuilds the snapshot with cap=2000/status=ok instead
# of replaying the rejected cap=1000/status=backoff content.
_push_journal() {
  local dir="$1" count
  count="$(cat "$COUNT" 2>/dev/null || echo 0)"
  count="${count:-0}"
  count=$((count + 1))
  printf '%s\n' "$count" > "$COUNT"
  [ "${PUSH_MODE:-race}" != fail ] || return 1
  if [ "$count" -eq 1 ]; then
    printf '%s\n' 'anthropic:testhost anthropic testhost weekly-tokens 2000' > "$RIVAL/config/budget-pools"
    git -C "$RIVAL" add config/budget-pools
    git -C "$RIVAL" "${git_id[@]}" commit -qm 'rival pool update'
    git -C "$RIVAL" push -q origin HEAD:journal2
  fi
  git -C "$dir" push -q origin HEAD:journal2 2>/dev/null
}

ensure_clone "$CLONE"
sync_clone "$CLONE"
budget_publish_local_pool "$CLONE" \
  || { echo 'FAIL: transient snapshot push race exhausted publication'; exit 1; }

[ "$(cat "$COUNT")" -eq 2 ] \
  || { echo "FAIL: expected one retry, saw $(cat "$COUNT") push attempts"; exit 1; }
snapshot="$(git --git-dir="$BARE" show journal2:budget/live/testhost)"
grep -q '^cap: 2000$' <<<"$snapshot" \
  || { echo 'FAIL: retry did not rebuild from re-synced pool config'; exit 1; }
grep -q '^status: ok$' <<<"$snapshot" \
  || { echo 'FAIL: rebuilt snapshot retained the rejected attempt zone'; exit 1; }

# Persistent rejection consumes exactly the configured bound, reports failure,
# and returns control to the caller so the scaler can keep reconciling workers.
PUSH_MODE=fail
printf '0\n' > "$COUNT"
GARDEN_USAGE_NOW=$((GARDEN_USAGE_NOW + 900))
export GARDEN_USAGE_NOW
sync_clone "$CLONE"
if budget_publish_local_pool "$CLONE"; then
  echo 'FAIL: persistent push rejection was reported as published'
  exit 1
fi
[ "$(cat "$COUNT")" -eq "$GARDEN_BUDGET_PUBLISH_ATTEMPTS" ] \
  || { echo "FAIL: persistent rejection was not bounded at $GARDEN_BUDGET_PUBLISH_ATTEMPTS attempts"; exit 1; }

echo 'PASS: transient race retries from fresh state; persistent failure is bounded and fail-open'
