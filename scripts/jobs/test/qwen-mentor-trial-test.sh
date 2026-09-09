#!/bin/bash
# qwen-mentor-trial-test.sh — bounded admission and split-arm checks.
set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
JOBS="$(cd "$HERE/.." && pwd)"
PASS=0; FAIL=0
ok() { echo "  PASS: $*"; PASS=$((PASS+1)); }
bad() { echo "  FAIL: $*"; FAIL=$((FAIL+1)); }
export GARDEN_TEST=1
# shellcheck source=../common.sh
source "$JOBS/common.sh"
# shellcheck source=../reputation.sh
source "$JOBS/reputation.sh"

TR="$(mktemp -d "${TMPDIR:-/tmp}/garden-qwen-trial.XXXXXX")"
trap 'rm -rf "$TR"' EXIT
mkdir -p "$TR/jobs"/{plan,todo,doin,tada} "$TR/reputation/events"

job="$TR/jobs/todo/canary.md"
printf '%s\n' '---' 'trial: qwen3.6-mentor-v1' 'trial-tier: mentor' \
  'trial-slot: 1' 'provider: local' 'model: qwen3.6' 'dispatch: canary' 'role: builder' '---' > "$job"
qwen_mentor_trial_job "$job" && ok 'exact curated metadata is admitted' || bad 'valid metadata rejected'
qwen_mentor_trial_slot_unique "$TR" "$job" && ok 'one lifecycle owner has a unique slot' || bad 'unique slot rejected'
[ "$(rep_kind_for_job hermit "$job")" = hermit-mentor-trial ] \
  && ok 'trial maps to a distinct reputation kind' || bad 'trial arm pooled with ordinary hermit'
cp "$job" "$TR/jobs/doin/inflight.md"
qwen_mentor_trial_no_inflight "$TR" \
  && bad 'second trial job admitted beside an in-flight trial' || ok 'only one trial job may be in flight fleet-wide'
rm "$TR/jobs/doin/inflight.md"

cp "$job" "$TR/jobs/tada/duplicate.md"
qwen_mentor_trial_slot_unique "$TR" "$job" \
  && bad 'duplicate slot was admitted' || ok 'duplicate slot fails closed across lifecycle states'
rm "$TR/jobs/tada/duplicate.md"

sed 's/trial-slot: 1/trial-slot: 7/' "$job" > "$TR/bad.md"
qwen_mentor_trial_job "$TR/bad.md" && bad 'slot beyond cap admitted' || ok 'slot 7 exceeds the six-job cap'
[ "$(rep_kind_for_job hermit "$TR/bad.md")" = hermit ] \
  && ok 'malformed trial cannot enter the split arm' || bad 'malformed trial entered split arm'

# Exercise the only supported producer path against a throwaway journal.
POST="$TR/post"; BARE="$POST/journal.git"; SEED="$POST/seed"; mkdir -p "$POST"
git init -q --bare "$BARE"
git init -q "$SEED"; git -C "$SEED" checkout -q -b journal2
mkdir -p "$SEED/jobs"/{plan,todo,doin,tada} "$SEED/jobs/index" "$SEED/entries"
touch "$SEED/jobs/todo/.gitkeep"
git -C "$SEED" -c user.name=test -c user.email=test@localhost add -A
git -C "$SEED" -c user.name=test -c user.email=test@localhost commit -q -m seed
git -C "$SEED" remote add origin "$BARE"; git -C "$SEED" push -q -u origin journal2
printf '%s\n' '---' 'role: builder' '---' '# real mentor-shaped work' > "$POST/body.md"
post_env=(GARDEN=testhost GARDEN_TEST=1 GARDEN_ROOT="$(cd "$JOBS/../.." && pwd)" \
  GARDEN_STATE="$POST/state" GARDEN_PRODUCER_CLONE="$POST/producer/journal" \
  JOURNAL_REMOTE="$BARE" JOURNAL_BRANCH=journal2)
env "${post_env[@]}" "$JOBS/post-job.sh" --identity test/repo#12:qwen-trial:2 \
  --qwen-mentor-trial 2 canary-two "$POST/body.md" >/dev/null 2>&1 \
  && ok 'producer posts a numbered trial canary' || bad 'producer rejected a valid trial canary'
git clone -q --single-branch --branch journal2 "$BARE" "$POST/verify"
posted="$POST/verify/jobs/todo/canary-two.md"
if [ -f "$posted" ] && qwen_mentor_trial_job "$posted" \
   && [ "$(plan_field "$posted" trial-slot)" = 2 ] && [ "$(plan_field "$posted" role)" = builder ]; then
  ok 'producer stamps the exact model/trial/slot/canary contract and preserves role'
else
  bad 'posted trial metadata is incomplete or changed'
fi
rm -rf "$POST/verify"
worker_env=("${post_env[@]}" GARDEN_WORKER_KIND=hermit \
  GARDEN_WORKER_CLONE="$POST/worker/journal" GARDEN_GARDENER_CLONE="$POST/worker/journal")
claimed="$(env "${worker_env[@]}" "$JOBS/claim-job.sh" 1 2>/dev/null || true)"
printf 'completed canary\n' > "$POST/report.md"
if [ "$claimed" = canary-two ] && env "${worker_env[@]}" GARDEN_JOB_DURATION_SECS=1 \
    "$JOBS/complete-job.sh" 1 canary-two "$POST/report.md" >/dev/null 2>&1; then
  git clone -q --single-branch --branch journal2 "$BARE" "$POST/verify"
  event="$POST/verify/reputation/events/canary-two.md"
  if [ "$(plan_field "$event" kind)" = hermit-mentor-trial ] \
     && [ "$(plan_field "$event" trial-slot)" = 2 ]; then
    ok 'live completion records the split arm and durable consumed slot'
  else
    bad 'live completion pooled its event or lost the slot tombstone'
  fi
else
  bad 'valid trial job did not claim and complete through the live primitives'
fi
env "${post_env[@]}" "$JOBS/post-job.sh" --identity test/repo#17:qwen-trial:7 \
  --qwen-mentor-trial 7 bad-canary "$POST/body.md" >/dev/null 2>&1 \
  && bad 'producer accepted out-of-range slot 7' || ok 'producer refuses out-of-range slots'
env "${post_env[@]}" "$JOBS/post-job.sh" --qwen-mentor-trial 3 unindexed-canary "$POST/body.md" >/dev/null 2>&1 \
  && bad 'producer accepted a trial job without a durable PR edge' \
  || ok 'producer requires a durable base-to-PR identity edge'

rep_record_demerit "$TR" failed-canary hermit-mentor-trial local qwen3.6 high build:m main2 \
  censored claude reference qwen3.6-mentor-v1 1
demerit_event="$TR/reputation/events/failed-canary.hermit-demerit.md"
if [ "$(plan_field "$demerit_event" kind)" = hermit-mentor-trial ] \
   && [ "$(plan_field "$demerit_event" trial-slot)" = 1 ]; then
  ok 'verified demerit records the split arm and consumes its trial slot'
else
  bad 'verified demerit lost trial attribution'
fi
qwen_mentor_trial_slot_unique "$TR" "$job" \
  && bad 'demerit-consumed slot was re-admitted' || ok 'demerit is a durable no-retry slot tombstone'
rm "$demerit_event"

mkevent() {
  local name="$1" accepted="$2" slot="${3:-$1}" wc="${4:-fix:s}"
  printf '%s\n' '---' "kind: hermit-mentor-trial" 'provider: local' 'model: qwen3.6' \
    "base: $name" 'trial: qwen3.6-mentor-v1' "trial-slot: $slot" "accepted: $accepted" \
    "work_class: $wc" \
    "$([ "$accepted" = false ] && printf 'demerit: true' || true)" '---' > "$TR/reputation/events/$name.md"
}
mkmeasurement() {
  local name="$1" slot="$2" sittings="$3" comments="$4" bases="${5:-1}" pr
  pr=$((100 + slot))
  mkdir -p "$TR/jobs/index" "$TR/receipts/test-repo/2026/09"
  printf 'base: %s\nidentity: test/repo#%s:qwen-trial:%s\n' "$name" "$pr" "$slot" \
    > "$TR/jobs/index/$name"
  printf '%s\n' '---' 'repo: test/repo' "pr: $pr" "bases: $bases" \
    "maintainer_review_sittings: $sittings" "maintainer_comments: $comments" '---' \
    "| \`$name\` **∑** | |" > "$TR/receipts/test-repo/2026/09/pr$pr.md"
}
mkevent s1 true 2; mkevent s2 true 3
printf '%s\n' '---' 'kind: hermit-mentor-trial' 'provider: local' 'model: qwen3.6' \
  'trial: qwen3.6-mentor-v1' 'trial-slot: 6' 'accepted: false' '---' > "$TR/reputation/events/unverified.md"
qwen_mentor_trial_admits "$TR" \
  && bad 'unmeasured accepted outcomes unlocked another permit' \
  || ok 'accepted outcomes wait for terminal PR receipts before admission resumes'
mkmeasurement s1 2 4 8; mkmeasurement s2 3 5 9
qwen_mentor_trial_admits "$TR" && ok 'two measured clean outcomes keep admission open' || bad 'measured clean trial stopped early'
mkdir -p "$TR/reputation/pending"
printf '%s\n' '---' 'trial: qwen3.6-mentor-v1' 'trial-slot: 5' 'accepted: pending' '---' \
  > "$TR/reputation/pending/waiting.md"
qwen_mentor_trial_admits "$TR" \
  && bad 'pending PR outcome unlocked another permit' \
  || ok 'pending PR outcome blocks admission until terminal measurement'
rm "$TR/reputation/pending/waiting.md"
rm "$TR/reputation/events/unverified.md"
mkevent d1 false 4
qwen_mentor_trial_admits "$TR" \
  && bad '25% threshold did not stop after 1/3 demerits' || ok 'one demerit in three outcomes stops at the 25% threshold'
rm "$TR/reputation/events/d1.md"; mkevent d1 false 4; rm "$TR/reputation/events/s1.md" "$TR/reputation/events/s2.md"; mkevent d2 false 5
qwen_mentor_trial_admits "$TR" \
  && bad 'two verified demerits did not stop immediately' || ok 'two verified demerits stop immediately'
rm "$TR/reputation/events"/*.md
rm -rf "$TR/jobs/index" "$TR/receipts"
mkevent costly true 1; mkmeasurement costly 1 11 5
qwen_mentor_trial_admits "$TR" \
  && bad 'per-case human sitting cap did not stop admission' \
  || ok 'per-case human sitting cap stops admission'
rm "$TR/reputation/events"/*.md; rm -rf "$TR/jobs/index" "$TR/receipts"
mkevent chatty true 1; mkmeasurement chatty 1 5 31
qwen_mentor_trial_admits "$TR" \
  && bad 'per-case human comment cap did not stop admission' \
  || ok 'per-case human comment cap stops admission'
rm "$TR/reputation/events"/*.md; rm -rf "$TR/jobs/index" "$TR/receipts"
mkevent total1 true 1; mkmeasurement total1 1 10 10
mkevent total2 true 2; mkmeasurement total2 2 10 10
mkevent total3 true 3; mkmeasurement total3 3 10 10
mkevent total4 true 4; mkmeasurement total4 4 10 10
qwen_mentor_trial_admits "$TR" \
  && bad 'cumulative human sitting cap did not stop admission' \
  || ok 'cumulative human sitting cap stops admission'
rm "$TR/reputation/events"/*.md; rm -rf "$TR/jobs/index" "$TR/receipts"
mkevent comments1 true 1; mkmeasurement comments1 1 1 18
mkevent comments2 true 2; mkmeasurement comments2 2 1 18
mkevent comments3 true 3; mkmeasurement comments3 3 1 18
mkevent comments4 true 4; mkmeasurement comments4 4 1 18
mkevent comments5 true 5; mkmeasurement comments5 5 1 18
qwen_mentor_trial_admits "$TR" \
  && bad 'cumulative human comment cap did not stop admission' \
  || ok 'cumulative human comment cap stops admission'
rm "$TR/reputation/events"/*.md; rm -rf "$TR/jobs/index" "$TR/receipts"
mkevent b1 true 1 build:m; mkmeasurement b1 1 2 5
mkevent b2 true 2 build:m; mkmeasurement b2 2 2 5
mkevent w1 true 3 weave:s; mkmeasurement w1 3 2 5
mkevent w2 true 4 weave:s; mkmeasurement w2 4 2 5
qwen_mentor_trial_promotion_reviewable "$TR" \
  && ok 'four clean cases balanced across two classes make evidence reviewable' \
  || bad 'balanced clean-carrier floor was not recognized'
rm "$TR/reputation/events/w2.md" "$TR/jobs/index/w2" "$TR/receipts/test-repo/2026/09/pr104.md"
qwen_mentor_trial_promotion_reviewable "$TR" \
  && bad 'three clean cases were treated as promotion evidence' \
  || ok 'fewer than four balanced clean cases remain insufficient'
rm "$TR/reputation/events"/*.md; rm -rf "$TR/jobs/index" "$TR/receipts"
for slot in 1 2 3 4 5 6; do mkevent "cap$slot" true "$slot"; done
[ "$(qwen_mentor_trial_attempts "$TR")" = 6 ] && ! qwen_mentor_trial_admits "$TR" \
  && ok 'six consumed slots hard-stop the trial' || bad 'six-slot cap did not stop admission'

echo "qwen-mentor-trial-test: $PASS passed, $FAIL failed"
[ "$FAIL" -eq 0 ]
