#!/bin/bash
# Hermetic coverage for deferred time gates, rolling arc spend, self-continuation,
# and foreman-only Ironhorse promotion.
set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
JOBS="$(cd "$HERE/.." && pwd)"
unset $(compgen -v 2>/dev/null | grep -E '^(GARDEN_|JOURNAL_|SELF_HEAL_)' || true) 2>/dev/null || true
export GARDEN_TEST=1
TR="$(mktemp -d "${TMPDIR:-$HOME}/.ironhorse-press-test.XXXXXX")"
trap 'rm -rf "$TR"' EXIT
PASS=0; FAIL=0
ok() { echo "PASS: $*"; PASS=$((PASS+1)); }
bad() { echo "FAIL: $*"; FAIL=$((FAIL+1)); }
git_id=(-c user.name=test -c user.email=test@example.invalid)

BARE="$TR/origin.git"; SEED="$TR/seed"; BRANCH=journal2
git init -q --bare "$BARE"
git init -q "$SEED"; git -C "$SEED" checkout -q -b "$BRANCH"
mkdir -p "$SEED"/{jobs/{todo,doin,tada,plan},work,usage,config/{delegations,arc-budgets},ratchets/ironhorse-test262-ratchet,inbox/maintainer/{unread,read},maintainers,reputation/{events,pending,verdicts},jobs/bids}
for d in jobs/todo jobs/doin jobs/tada jobs/plan work usage inbox/maintainer/unread inbox/maintainer/read; do touch "$SEED/$d/.gitkeep"; done
auth="entries/2026/09/28/201230Z-message-gardener-aa49da.md"
mkdir -p "$SEED/$(dirname "$auth")"
printf 'fixture authorization\n' > "$SEED/$auth"
auth_sha="$(sha256sum "$SEED/$auth" | cut -d' ' -f1)"
jq -n --arg auth "$auth" --arg sha "$auth_sha" \
  '{schema:1,status:"active",authorized_by:"kriskowal",authorization:$auth,
    authorization_sha256:$sha,repository:"endojs/endo-but-for-bots",base:"llm",
    author:"kriscendobot",marker:"<!-- garden-arc: ironhorse-test262-ratchet -->"}' \
  > "$SEED/config/delegations/ironhorse-test262-ratchet"
jq -n '{schema:1,status:"active",arc:"ironhorse-test262-ratchet",token_cap:100,
  window_seconds:3600,press_interval_seconds:21600}' \
  > "$SEED/config/arc-budgets/ironhorse-test262-ratchet"
printf 'kriskowal\n' > "$SEED/maintainers/allowlist"
base=arc-builder-one
{
  printf -- '---\nrole: builder\nratchet-arc: ironhorse-test262-ratchet\n---\nwork\n'
  printf -- '\n---\nclaim:\n  provider: openai\n  model: gpt-6-sol\n'
} > "$SEED/jobs/doin/$base.md"
git -C "$SEED" add -A
git -C "$SEED" "${git_id[@]}" commit -qm seed
git -C "$SEED" remote add origin "$BARE"
git -C "$SEED" push -q -u origin "$BRANCH"

CLONE="$TR/worker"; git clone -q --single-branch --branch "$BRANCH" "$BARE" "$CLONE"
git -C "$CLONE" config user.name test; git -C "$CLONE" config user.email test@example.invalid
REPORT="$TR/report"; printf 'done\n' > "$REPORT"
export JOURNAL_REMOTE="$BARE" JOURNAL_BRANCH="$BRANCH" GARDEN=testhost GARDEN_STATE="$TR/state"
export GARDEN_ROOT="$(cd "$JOBS/../.." && pwd)" GARDEN_WORKER_CLONE="$CLONE"
export GARDEN_PRESS_NOW=1790683200 GARDEN_WORKER_KIND=cleric GARDEN_GARDENER_ID=1
export GARDEN_JOB_DURATION_SECS=2
export GARDEN_ENGAGEMENT_USAGE='{"source":"codex","input_tokens":10,"output_tokens":5,"cache_creation_tokens":0,"cache_read_tokens":2}'
"$JOBS/complete-job.sh" 1 "$base" "$REPORT" >/dev/null

VERIFY="$TR/verify"; git clone -q --single-branch --branch "$BRANCH" "$BARE" "$VERIFY"
press=ironhorse-test262-press-20260929-120000
plan="$VERIFY/jobs/plan/$press.md"
if [ -f "$plan" ] && grep -q '^not_before: 2026-09-29T18:00:00Z$' "$plan"; then
  ok "completion atomically parked the six-hour successor"
else
  bad "successor missing or has wrong not_before"
fi
[ "$(find "$VERIFY/jobs/plan" -maxdepth 1 -name 'ironhorse-test262-press-*.md' | wc -l)" -eq 1 ] \
  && ok "exactly one live press exists" || bad "press successor count is not one"
python3 "$JOBS/ratchet/policy.py" job "$VERIFY" "$plan" >/dev/null \
  && ok "successor satisfies canonical watcher policy" || bad "successor failed policy"
jq -e '.arc == "ironhorse-test262-ratchet"' "$VERIFY/usage/$base.jsonl" >/dev/null \
  && ok "usage row carries the arc marker" || bad "usage row lacks arc marker"
printf '%s\n' '---' 'gate: deferred' 'not_before: not-a-time' '---' 'never early' \
  > "$VERIFY/jobs/plan/invalid-clock.md"
ranked_future="$(GARDEN_PLAN_NOW=1790686800 bash -c \
  'source "$1/common.sh"; plan_deferred_ranked "$2"' _ "$JOBS" "$VERIFY")"
[ -z "$ranked_future" ] && ok "plan_deferred_ranked skips future and malformed times" \
  || bad "ranker admitted a future/malformed plan: $ranked_future"
ranked_due="$(GARDEN_PLAN_NOW=1790704800 bash -c \
  'source "$1/common.sh"; plan_deferred_ranked "$2"' _ "$JOBS" "$VERIFY")"
[ "$ranked_due" = "$press" ] && ok "plan_deferred_ranked admits the due press only" \
  || bad "due rank output was '$ranked_due'"

export GARDEN_PRODUCER_CLONE="$TR/producer"
set +e
GARDEN_PLAN_NOW=1790686800 "$JOBS/promote-plan.sh" --foreman --omega-rank 0 "$press" >/dev/null 2>&1
early_rc=$?
set -e
[ "$early_rc" -eq 7 ] && ok "foreman promotion before not_before fails closed" \
  || bad "early promotion rc=$early_rc (want 7)"
set +e
GARDEN_PLAN_NOW=1790704800 "$JOBS/promote-plan.sh" "$press" >/dev/null 2>&1
manual_rc=$?
set -e
[ "$manual_rc" -eq 7 ] && ok "non-foreman promotion is refused" \
  || bad "manual promotion rc=$manual_rc (want 7)"
GARDEN_PLAN_NOW=1790704800 "$JOBS/promote-plan.sh" --foreman --omega-rank 0 "$press" >/dev/null
rm -rf "$VERIFY"; git clone -q --single-branch --branch "$BRANCH" "$BARE" "$VERIFY"
[ -f "$VERIFY/jobs/todo/$press.md" ] && ok "due, under-budget press promotes" \
  || bad "due press did not promote"

# The rolling sum is immutable-ledger-derived and blocks at cap. The completion
# row above was stamped with the wall clock; pin it before the fixture window so
# the sum does not depend on the day the test runs.
jq -c '.ts = "2026-09-29T12:00:00Z"' "$VERIFY/usage/$base.jsonl" > "$VERIFY/usage/$base.jsonl.tmp"
mv "$VERIFY/usage/$base.jsonl.tmp" "$VERIFY/usage/$base.jsonl"
printf '%s\n' '{"ts":"2026-09-29T18:30:00Z","arc":"ironhorse-test262-ratchet","source":"codex","input_tokens":110,"output_tokens":0,"cache_creation_tokens":0}' \
  >> "$VERIFY/usage/$base.jsonl"
git -C "$VERIFY" add "usage/$base.jsonl"; git -C "$VERIFY" "${git_id[@]}" commit -qm usage-cap; git -C "$VERIFY" push -q origin "HEAD:$BRANCH"
snapshot="$("$JOBS/arc-spend.sh" --dir "$VERIFY" --now-epoch 1790708400 ironhorse-test262-ratchet)"
[ "$(jq -r '.spend_tokens' <<<"$snapshot")" -eq 110 ] && [ "$(jq -r '.over_budget' <<<"$snapshot")" = true ] \
  && ok "rolling spend reaches cap from usage rows" || bad "wrong arc spend: $snapshot"

# The foreman leaves an over-budget press parked and says why in its durable
# host-local decision log, even if it pumps unrelated work in the open slot.
git -C "$VERIFY" rm -q "jobs/todo/$press.md"
over=ironhorse-test262-press-20260929-190100
python3 "$JOBS/ratchet/policy.py" plan "$VERIFY" "$VERIFY/jobs/plan/$over.md" \
  2026-09-29T19:00:00Z 2026-09-29T19:01:00Z
git -C "$VERIFY" add "jobs/plan/$over.md"
git -C "$VERIFY" "${git_id[@]}" commit -qm over-budget-plan
git -C "$VERIFY" push -q origin "HEAD:$BRANCH"
FOREMAN_STATE="$TR/foreman-state"
for _ in 1 2; do
  env GARDEN=testhost GARDEN_STATE="$FOREMAN_STATE" HOME="$TR" \
    GARDEN_ROOT="$GARDEN_ROOT" JOURNAL_REMOTE="$BARE" JOURNAL_BRANCH="$BRANCH" \
    GARDEN_FOREMAN_NOW=1790708400 GARDEN_FOREMAN_IDLE_SETTLE=0 \
    GARDEN_FOREMAN_ACTIVE_TARGET=1 GARDEN_FOREMAN_HANDLER="$HERE/foreman-stub.sh" \
    "$JOBS/foreman.sh" >/dev/null 2>&1
done
grep -q "skipped=$over:arc-budget-over:ironhorse-test262-ratchet:spend=110:cap=100:window=3600" \
  "$FOREMAN_STATE/foreman/decisions.log" \
  && ok "foreman decision log records the over-budget arc skip" \
  || bad "foreman decision log omitted the arc-budget reason"

echo "RESULTS: $PASS passed, $FAIL failed"
[ "$FAIL" -eq 0 ]
