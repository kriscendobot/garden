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
export GARDEN_BUDGET_PUBLISH_BACKOFF_BASE_MS=0
export GARDEN_BUDGET_PUBLISH_BACKOFF_CAP_MS=0
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
  if [ "${PUSH_MODE:-race}" = fail ]; then
    # shellcheck disable=SC2034 # commit_and_push consumes this after the stub returns.
    GARDEN_PUSH_STDERR='remote: error: protected branch policy refused this update
 ! [remote rejected] HEAD -> journal2 (pre-receive hook declined)'
    return 1
  fi
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
# Next bucket, at this host's staggered slot (the boundary itself is not due).
GARDEN_USAGE_NOW=$((GARDEN_USAGE_NOW + 900 + $(budget_snapshot_offset "$GARDEN" 900 1800)))
export GARDEN_USAGE_NOW
sync_clone "$CLONE"
if budget_publish_local_pool "$CLONE"; then
  echo 'FAIL: persistent push rejection was reported as published'
  exit 1
fi
[ "$(cat "$COUNT")" -eq "$GARDEN_BUDGET_PUBLISH_ATTEMPTS" ] \
  || { echo "FAIL: persistent rejection was not bounded at $GARDEN_BUDGET_PUBLISH_ATTEMPTS attempts"; exit 1; }
[ "$_BUDGET_PUBLISH_FAILURE_POOL" = 'anthropic:testhost' ] \
  || { echo "FAIL: exhausted publication lost the failing pool ($_BUDGET_PUBLISH_FAILURE_POOL)"; exit 1; }
[ "$_BUDGET_PUBLISH_FAILURE_RC" = 1 ] \
  || { echo "FAIL: exhausted publication lost commit_and_push rc ($_BUDGET_PUBLISH_FAILURE_RC)"; exit 1; }
[ "$_BUDGET_PUBLISH_FAILURE_CLASS" = server-reject ] \
  || { echo "FAIL: exhausted publication lost the push class ($_BUDGET_PUBLISH_FAILURE_CLASS)"; exit 1; }

echo 'PASS: transient race retries from fresh state; persistent failure is bounded and fail-open'

# Simultaneous-host contention (13:31:43, 13:46:13): every host's scaler ticks
# once a minute and, unstaggered, all of them publish on the first tick of a new
# bucket, so each tick syncs every clone from the same journal tip and all but
# one push lose the CAS. Model that directly: per tick, sync every host's clone
# first, then let each host publish with no retry, and count lost pushes.
unset PUSH_MODE
_push_journal() {
  # shellcheck disable=SC2034 # commit_and_push consumes this after the stub returns.
  GARDEN_PUSH_STDERR="$(git -C "$1" push -q origin HEAD:journal2 2>&1 1>/dev/null)"
}
HOSTS=(endolin-garden2-5bcdff64 endolin-garden-ece02cb4 host-b host-c host-d)
CBARE="$TR/contention.git"
CSEED="$TR/contention-seed"
git init -q --bare "$CBARE"
git init -q "$CSEED"
git -C "$CSEED" checkout -q -b journal2
mkdir -p "$CSEED/config"
for h in "${HOSTS[@]}"; do
  printf 'anthropic:%s anthropic %s weekly-tokens 100000\n' "$h" "$h"
done > "$CSEED/config/budget-pools"
git -C "$CSEED" add config/budget-pools
git -C "$CSEED" "${git_id[@]}" commit -qm seed
git -C "$CSEED" push -q "$CBARE" journal2
export JOURNAL_REMOTE="$CBARE"
unset GARDEN_BUDGET_SNAPSHOT_STAGGER_SECS

# Fixture precondition: default stagger width, deterministic in-window offsets,
# and one distinct scaler-tick slot per host.
W="$(budget_snapshot_stagger_secs 900 1800)"
[ "$W" = 300 ] || { echo "FAIL: default stagger width is $W, want 300"; exit 1; }
declare -A OFFSET SLOT_OWNER
for h in "${HOSTS[@]}"; do
  OFFSET[$h]="$(budget_snapshot_offset "$h" 900 1800)"
  [ "${OFFSET[$h]}" = "$(budget_snapshot_offset "$h" 900 1800)" ] \
    || { echo "FAIL: $h offset is not deterministic"; exit 1; }
  [ "${OFFSET[$h]}" -ge 0 ] && [ "${OFFSET[$h]}" -lt "$W" ] \
    || { echo "FAIL: $h offset ${OFFSET[$h]} outside [0,$W)"; exit 1; }
  slot=$(((OFFSET[$h] + 59) / 60))
  [ -z "${SLOT_OWNER[$slot]:-}" ] \
    || { echo "FAIL: fixture hosts $h and ${SLOT_OWNER[$slot]} share tick slot $slot"; exit 1; }
  SLOT_OWNER[$slot]="$h"
done
[ "$(GARDEN_BUDGET_SNAPSHOT_STAGGER_SECS=0 budget_snapshot_offset host-b 900 1800)" = 0 ] \
  || { echo 'FAIL: stagger 0 did not disable the offset'; exit 1; }
[ "$(GARDEN_BUDGET_SNAPSHOT_STAGGER_SECS=5000 budget_snapshot_stagger_secs 900 1800)" = 450 ] \
  || { echo 'FAIL: stagger width not clamped to half the max-age headroom'; exit 1; }

sample_at() { git --git-dir="$CBARE" show "journal2:budget/live/$1" 2>/dev/null \
  | sed -n 's/^sampled_at_epoch:[[:space:]]*//p'; }

# run_bucket <bucket-start> — 15 one-minute ticks; echoes the lost pushes.
run_bucket() {
  local start="$1" tick h lost=0
  for tick in $(seq 0 14); do
    GARDEN_USAGE_NOW=$((start + tick * 60)); export GARDEN_USAGE_NOW
    for h in "${HOSTS[@]}"; do GARDEN="$h" sync_clone "$TR/clone-$h" >/dev/null 2>&1; done
    for h in "${HOSTS[@]}"; do
      GARDEN="$h" GARDEN_BUDGET_PUBLISH_ATTEMPTS=1 budget_publish_local_pool "$TR/clone-$h" >/dev/null 2>&1 \
        || lost=$((lost + 1))
    done
  done
  echo "$lost"
}

B0=$(( ($(date -u -d 2026-08-22T13:30:00Z +%s) / 900) * 900 ))
# Seed one sample per host, serially (no contention), on bucket B0's boundary:
# a host with no prior sample publishes at once.
for h in "${HOSTS[@]}"; do
  GARDEN_USAGE_NOW="$B0"; export GARDEN_USAGE_NOW
  GARDEN="$h" ensure_clone "$TR/clone-$h"
  GARDEN="$h" sync_clone "$TR/clone-$h"
  GARDEN="$h" budget_publish_local_pool "$TR/clone-$h" \
    || { echo "FAIL: $h could not seed its first snapshot"; exit 1; }
  [ "$(sample_at "$h")" = "$B0" ] || { echo "FAIL: $h first snapshot was deferred"; exit 1; }
done

# Unstaggered (the old behavior): the whole fleet collides on the boundary tick.
lost="$(GARDEN_BUDGET_SNAPSHOT_STAGGER_SECS=0 run_bucket $((B0 + 900)))"
[ "$lost" -ge $((${#HOSTS[@]} - 1)) ] \
  || { echo "FAIL: contention model did not reproduce boundary collisions (lost=$lost)"; exit 1; }

# Staggered: each host publishes exactly on its own slot, nothing loses the CAS,
# and consecutive samples stay within cadence + W, well inside the 1800s max-age.
for b in 2 3; do
  declare -A PREV=()
  for h in "${HOSTS[@]}"; do PREV[$h]="$(sample_at "$h")"; done
  start=$((B0 + b * 900))
  lost="$(run_bucket "$start")"
  [ "$lost" -eq 0 ] || { echo "FAIL: staggered bucket $b still lost $lost CAS races"; exit 1; }
  for h in "${HOSTS[@]}"; do
    at="$(sample_at "$h")"
    want=$((start + ((OFFSET[$h] + 59) / 60) * 60))
    [ "$at" = "$want" ] || { echo "FAIL: bucket $b $h published at $at, want its slot $want"; exit 1; }
    [ $((at - PREV[$h])) -le $((900 + W)) ] \
      || { echo "FAIL: bucket $b $h sample gap $((at - PREV[$h]))s exceeds cadence+stagger"; exit 1; }
  done
done

# A host whose prior sample is overdue (a missed bucket) does not wait out its
# stagger again: it publishes on the first tick of the next bucket.
late=host-b
GARDEN_USAGE_NOW=$((B0 + 5 * 900)); export GARDEN_USAGE_NOW
GARDEN="$late" sync_clone "$TR/clone-$late"
GARDEN="$late" budget_publish_local_pool "$TR/clone-$late" \
  || { echo 'FAIL: overdue host could not publish'; exit 1; }
[ "$(sample_at "$late")" = "$GARDEN_USAGE_NOW" ] \
  || { echo 'FAIL: an overdue host deferred to its stagger slot'; exit 1; }

echo 'PASS: host-keyed stagger spreads simultaneous publishers across the bucket without CAS losses'
