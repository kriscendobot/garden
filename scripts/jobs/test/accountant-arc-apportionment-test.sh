#!/bin/bash
# Hermetic coverage for the accountant's weekly arc apportionment
# (designs/accountant-arc-apportionment.md): arc-spend.sh schema 2, the `arc:`
# field and its `ratchet-arc` alias, set-apportionment.sh (atomic write,
# refusals, carry-forward), rank ordering and reserve gating in the deferred
# selector, arc inheritance through post-plan / orchestration / gauntlet
# records, per-arc headroom in the foreman, the re-slice nudge, and
# accountant-statement.sh.
set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
JOBS="$(cd "$HERE/.." && pwd)"
unset $(compgen -v 2>/dev/null | grep -E '^(GARDEN_|JOURNAL_|SELF_HEAL_)' || true) 2>/dev/null || true
export GARDEN_TEST=1
TR="$(mktemp -d "${TMPDIR:-$HOME}/.accountant-arc-test.XXXXXX")"
trap 'rm -rf "$TR"' EXIT
PASS=0; FAIL=0
ok() { echo "PASS: $*"; PASS=$((PASS+1)); }
bad() { echo "FAIL: $*"; FAIL=$((FAIL+1)); }
git_id=(-c user.name=test -c user.email=test@example.invalid)

BARE="$TR/origin.git"; SEED="$TR/seed"; BRANCH=journal2
git init -q --bare "$BARE"
git init -q "$SEED"; git -C "$SEED" checkout -q -b "$BRANCH"
mkdir -p "$SEED"/{jobs/{todo,doin,tada,plan,orch,gauntlet},usage,config/arc-budgets,inbox/maintainer/{unread,read},maintainers}
for d in jobs/todo jobs/doin jobs/tada jobs/plan jobs/orch jobs/gauntlet usage inbox/maintainer/unread inbox/maintainer/read; do
  touch "$SEED/$d/.gitkeep"
done
printf 'kriskowal\n' > "$SEED/maintainers/allowlist"
jq -n '{schema:1,status:"active",arc:"ironhorse-test262-ratchet",token_cap:100,
  window_seconds:3600,press_interval_seconds:21600}' > "$SEED/config/arc-budgets/ironhorse-test262-ratchet"
jq -n '{schema:2,status:"active",arc:"gamma",rank:1,summary:"old",token_cap:10,
  window:"week",window_start:"2026-09-19T04:00:00Z"}' > "$SEED/config/arc-budgets/gamma"
git -C "$SEED" add -A
git -C "$SEED" "${git_id[@]}" commit -qm seed
git -C "$SEED" remote add origin "$BARE"
git -C "$SEED" push -q -u origin "$BRANCH"

export JOURNAL_REMOTE="$BARE" JOURNAL_BRANCH="$BRANCH" GARDEN=testhost GARDEN_STATE="$TR/state"
export GARDEN_ROOT="$(cd "$JOBS/../.." && pwd)" GARDEN_PRODUCER_CLONE="$TR/producer"
WEEK=2026-09-26T04:00:00Z
NOW=1790708400   # 2026-09-29T19:00:00Z, inside the week of $WEEK
V="$TR/verify"
refresh() { rm -rf "$V"; git clone -q --single-branch --branch "$BRANCH" "$BARE" "$V"; }
push_v() { git -C "$V" add -A; git -C "$V" "${git_id[@]}" commit -qm "$1"; git -C "$V" push -q origin "HEAD:$BRANCH"; }
commits() { git --git-dir="$BARE" rev-list --count "$BRANCH"; }
common() { bash -c 'source "$1/common.sh"; shift; "$@"' _ "$JOBS" "$@"; }

# --- set-apportionment.sh ---------------------------------------------------
cat > "$TR/slate.json" <<'JSON'
{"total_tokens":"1K","notes":"Finish what is open before starting anything new.",
 "arcs":[{"arc":"alpha","tokens":"50%","summary":"Alpha work"},
         {"arc":"beta","tokens":300,"summary":"Beta work","tracker":"https://example.invalid/1"}]}
JSON
"$JOBS/set-apportionment.sh" --authorized-by kriskowal --message-id m1 --week-start "$WEEK" "$TR/slate.json" >/dev/null 2>&1
refresh
jq -e '.total_tokens == 1000 and .unallocated_tokens == 200 and .authorized_by == "kriskowal"
  and .message_id == "m1" and .week_start == "2026-09-26T04:00:00Z"
  and ([.slate[] | "\(.rank):\(.arc):\(.token_cap)"] == ["1:alpha:500","2:beta:300"])' \
  "$V/config/apportionment" >/dev/null && ok "apportionment records the resolved slate" \
  || bad "apportionment wrong: $(cat "$V/config/apportionment")"
jq -e '.schema == 2 and .status == "active" and .rank == 1 and .token_cap == 500
  and .window == "week" and .window_start == "2026-09-26T04:00:00Z"' "$V/config/arc-budgets/alpha" >/dev/null \
  && ok "slate arc materialized as a schema-2 weekly slice" || bad "alpha slice wrong"
jq -e '.rank == 3 and .token_cap == 200' "$V/config/arc-budgets/unallocated" >/dev/null \
  && ok "the remainder funds the unallocated reserve, ranked last" || bad "reserve wrong"
jq -e '.status == "retired"' "$V/config/arc-budgets/gamma" >/dev/null \
  && ok "a schema-2 arc dropped from the slate is retired" || bad "gamma not retired"
jq -e '.schema == 1 and .status == "active"' "$V/config/arc-budgets/ironhorse-test262-ratchet" >/dev/null \
  && ok "a rolling schema-1 arc off the slate is left alone" || bad "ironhorse arc disturbed"
grep -q '^1\. alpha: Alpha work (500 tokens)$' "$V/config/foreman-mandate" \
  && grep -q 'Finish what is open' "$V/config/foreman-mandate" \
  && grep -q 'Reserve: unallocated, 200 tokens' "$V/config/foreman-mandate" \
  && ok "foreman-mandate regenerated from the slate" || bad "mandate: $(cat "$V/config/foreman-mandate")"
[ "$(git --git-dir="$BARE" log -1 --format=%s "$BRANCH" -- config/apportionment)" = \
  "$(git --git-dir="$BARE" log -1 --format=%s "$BRANCH" -- config/foreman-mandate)" ] \
  && ok "apportionment, slices, and mandate land in one commit" || bad "not one commit"

before="$(commits)"
jq '.arcs[0].tokens = "80%"' "$TR/slate.json" > "$TR/over.json"
if out="$("$JOBS/set-apportionment.sh" --authorized-by kriskowal --week-start "$WEEK" "$TR/over.json" 2>&1)"; then
  bad "over-subscription accepted"
else
  grep -q 'over-subscribed' <<<"$out" && ok "over-subscription is refused with an explanation" || bad "wrong refusal: $out"
fi
"$JOBS/set-apportionment.sh" --authorized-by mallory --week-start "$WEEK" "$TR/slate.json" >/dev/null 2>&1 \
  && bad "a non-maintainer authorization was accepted" || ok "authorized_by must be on maintainers/allowlist"
dry="$("$JOBS/set-apportionment.sh" --dry-run --authorized-by kriskowal --week-start "$WEEK" "$TR/slate.json" 2>/dev/null)"
grep -q '"unallocated_tokens": 200' <<<"$dry" && [ "$(commits)" = "$before" ] \
  && ok "--dry-run previews without pushing" || bad "dry-run pushed or printed nothing"

# --- arc-spend.sh schema 2 ----------------------------------------------------
refresh
row() { jq -cn --arg ts "$1" --arg arc "$2" --argjson n "$3" --arg base "$4" \
  '{ts:$ts,base:$base,arc:$arc,source:"codex",outcome:"tada",input_tokens:$n,output_tokens:0,cache_creation_tokens:0}'; }
{ row 2026-09-25T00:00:00Z alpha 100 old-alpha   # last week: excluded
  row 2026-09-27T00:00:00Z alpha 450 job-alpha
} > "$V/usage/alpha.jsonl"
push_v usage-alpha
snap="$("$JOBS/arc-spend.sh" --dir "$V" --now-epoch "$NOW" alpha)"
jq -e '.spend_tokens == 450 and .over_budget == false and .window_start == "2026-09-26T04:00:00Z"
  and .completions == 1 and .rank == 1' <<<"$snap" >/dev/null \
  && ok "schema-2 spend sums from the fixed window_start only" || bad "schema-2 snapshot: $snap"
row 2026-09-28T00:00:00Z alpha 60 job-alpha-2 >> "$V/usage/alpha.jsonl"; push_v usage-alpha-2
"$JOBS/arc-spend.sh" --dir "$V" --now-epoch "$NOW" alpha | jq -e '.spend_tokens == 510 and .over_budget' >/dev/null \
  && ok "schema-2 slice reports over_budget at its cap" || bad "alpha not over"
"$JOBS/arc-spend.sh" --dir "$V" --now-epoch $((NOW + 7*86400)) alpha \
  | jq -e '.spend_tokens == 0 and .window_start == "2026-10-03T04:00:00Z"' >/dev/null \
  && ok "the weekly window rolls forward without a carry-forward" || bad "window did not roll"
{ jq -cn '{ts:"2026-09-27T01:00:00Z",base:"unmetered",arc:"alpha",source:"none",outcome:"requeue"}'
  jq -cn '{ts:"bogus",base:"bad-ts",arc:"alpha",source:"codex",input_tokens:5}'
  jq -cn '{ts:"2026-09-27T02:00:00Z",base:"bad-n",arc:"alpha",source:"codex",input_tokens:-1}'
} >> "$V/usage/alpha.jsonl"; push_v usage-alpha-unmetered
"$JOBS/arc-spend.sh" --dir "$V" --now-epoch "$NOW" alpha \
  | jq -e '.spend_tokens == 510 and .engagements == 2 and .unmetered == 3' >/dev/null \
  && ok "unusable usage rows are filtered and counted, not poisoning the arc" || bad "unmetered rows poisoned the arc"
set +e; "$JOBS/arc-spend.sh" --dir "$V" --now-epoch "$NOW" gamma >/dev/null 2>&1; rc=$?; set -e
[ "$rc" -eq 5 ] && ok "a retired arc exits 5" || bad "retired arc rc=$rc"

# --- job_arc alias, admission, rank order --------------------------------------
plan() {  # plan <base> <mtime> [field-line]
  { printf -- '---\ngate: deferred\npriority: normal\n'; [ -z "${3:-}" ] || printf '%s\n' "$3"
    printf -- '---\n\nwork\n'; } > "$V/jobs/plan/$1.md"
  touch -d "@$2" "$V/jobs/plan/$1.md"
}
plan p-none 1000; plan p-beta 2000 'arc: beta'; plan p-legacy 3000 'ratchet-arc: beta'
plan p-alpha 500 'arc: alpha'; plan p-gamma 600 'arc: gamma'
[ "$(common job_arc "$V/jobs/plan/p-legacy.md")" = beta ] \
  && ok "ratchet-arc is read as the legacy alias of arc" || bad "alias not honored"
st() { GARDEN_PLAN_NOW="$NOW" common plan_deferred_status "$V" "$V/jobs/plan/$1.md" || true; }
[[ "$(st p-alpha)" == arc-budget-over:alpha:spend=510:cap=500:window=604800 ]] \
  && ok "an exhausted slice holds its plans" || bad "p-alpha status: $(st p-alpha)"
[ "$(st p-gamma)" = arc-retired:gamma ] && ok "a retired arc's plans stay parked" || bad "p-gamma: $(st p-gamma)"
[ "$(st p-none)" = ready ] && [ "$(st p-beta)" = ready ] && ok "arcs with headroom admit" || bad "admission wrong"
ranked="$(GARDEN_PLAN_NOW="$NOW" common plan_deferred_ranked_omega "$V" | cut -f2 | paste -sd' ')"
[ "$ranked" = "p-beta p-legacy p-none" ] && ok "deferred selector orders by arc rank before FIFO" \
  || bad "ranked order: '$ranked'"
row 2026-09-28T00:00:00Z unallocated 200 job-u > "$V/usage/u.jsonl"
[[ "$(st p-none)" == arc-budget-over:unallocated:* ]] \
  && ok "unarced foreman-drawn plans are gated by the reserve" || bad "p-none: $(st p-none)"
rm "$V/usage/u.jsonl"
push_v plans

GARDEN_PLAN_NOW="$NOW" "$JOBS/promote-plan.sh" --foreman p-none >/dev/null 2>&1
GARDEN_PLAN_NOW="$NOW" "$JOBS/promote-plan.sh" --foreman p-beta >/dev/null 2>&1
refresh
grep -qx 'arc: unallocated' "$V/jobs/todo/p-none.md" 2>/dev/null \
  && ok "foreman promotion stamps unarced work to the reserve" || bad "p-none todo lacks arc: unallocated"
grep -qx 'arc: beta' "$V/jobs/todo/p-beta.md" 2>/dev/null \
  && ok "promotion carries arc: into the todo job" || bad "p-beta todo lacks arc"

# --- producers stamp and inherit ---------------------------------------------
"$JOBS/post-plan.sh" --arc beta --role builder p-posted </dev/null >/dev/null 2>&1
"$JOBS/post-plan.sh" --orchestrated --orchestrated-by orch-a child-a </dev/null >/dev/null 2>&1
"$JOBS/post-orchestration.sh" --arc alpha orch-a child-a >/dev/null 2>&1
refresh
grep -qx 'arc: beta' "$V/jobs/plan/p-posted.md" && ok "post-plan.sh --arc stamps arc:" || bad "post-plan --arc"
grep -qx 'arc: alpha' "$V/jobs/orch/orch-a.md" && ok "post-orchestration.sh --arc records the arc" || bad "orch arc"
"$JOBS/promote-plan.sh" child-a >/dev/null 2>&1
refresh
grep -qx 'arc: alpha' "$V/jobs/todo/child-a.md" 2>/dev/null \
  && ok "an orchestrated child inherits its orchestration's arc" || bad "child-a lacks inherited arc"
"$JOBS/post-gauntlet.sh" --arc beta g-one https://github.com/o/r/pull/7 >/dev/null 2>&1
refresh
grep -qx 'arc: beta' "$V/jobs/gauntlet/g-one.md" && ok "post-gauntlet.sh --arc records the producer's arc" \
  || bad "gauntlet record lacks arc"

# --- foreman: per-arc headroom ---------------------------------------------------
refresh
git -C "$V" rm -q "$V"/jobs/plan/*.md; push_v clear-plans
FSTATE="$TR/foreman-state"; CALLS="$TR/calls"; DIGEST="$TR/digest"; : > "$CALLS"
foreman() {  # foreman <stub-base> [stub-arc]
  env GARDEN=testhost GARDEN_STATE="$FSTATE" HOME="$TR" GARDEN_ROOT="$GARDEN_ROOT" \
    JOURNAL_REMOTE="$BARE" JOURNAL_BRANCH="$BRANCH" GARDEN_FOREMAN_NOW="$NOW" \
    GARDEN_FOREMAN_IDLE_SETTLE=0 GARDEN_FOREMAN_ACTIVE_TARGET=20 \
    GARDEN_FOREMAN_HANDLER="$HERE/foreman-stub.sh" GARDEN_FOREMAN_STUB_CALLS="$CALLS" \
    GARDEN_FOREMAN_STUB_DIGEST="$DIGEST" GARDEN_FOREMAN_STUB_BASE="$1" \
    GARDEN_FOREMAN_STUB_ARC="${2:-}" GARDEN_RESLICE_RESET_EPOCH=$((NOW + 3600)) \
    "$JOBS/foreman.sh" >/dev/null 2>&1 || true
}
foreman step-beta beta; foreman step-beta beta
refresh
grep -qx 'arc: beta' "$V/jobs/todo/step-beta.md" 2>/dev/null \
  && ok "the foreman stamps the arc its step was drawn from" || bad "step-beta missing or unstamped"
grep -q '^arc_headroom: |' "$DIGEST" && grep -qE '^  1 alpha 0/500 over: Alpha work$' "$DIGEST" \
  && grep -qE '^  2 beta 300/300 ok: Beta work$' "$DIGEST" \
  && ok "the foreman digest carries per-arc headroom" || bad "digest: $(cat "$DIGEST")"
foreman step-alpha alpha
refresh
[ ! -e "$V/jobs/todo/step-alpha.md" ] && grep -q 'guard=arc-refused base=step-alpha arc=alpha' "$FSTATE/foreman/decisions.log" \
  && ok "a step for an exhausted arc is refused" || bad "step-alpha was posted or not logged"
foreman step-reserve
refresh
grep -qx 'arc: unallocated' "$V/jobs/todo/step-reserve.md" 2>/dev/null \
  && ok "a step with no ARC charges the reserve" || bad "step-reserve lacks arc: unallocated"
{ row 2026-09-28T00:00:00Z beta 300 job-b; row 2026-09-28T00:00:00Z unallocated 200 job-u; } > "$V/usage/held.jsonl"
push_v all-held
calls_before="$(wc -l < "$CALLS")"
foreman step-none; foreman step-none
refresh
[ "$(wc -l < "$CALLS")" = "$calls_before" ] && grep -q 'guard=arc-held' "$FSTATE/foreman/decisions.log" \
  && ok "with every slice held the foreman agent is not invoked" || bad "agent invoked while all held"
nudges="$(grep -l '^from: accountant' "$V"/inbox/maintainer/unread/*.md 2>/dev/null | wc -l)"
[ "$nudges" -eq 1 ] && grep -qh 're-slice' "$V"/inbox/maintainer/unread/*.md \
  && ok "the re-slice nudge fires once per held episode" || bad "nudge count $nudges"

# --- foreman-claude protocol validator accepts one ARC line -------------------------
validate="$(sed -n '/^validate_foreman_response()/,/^}/p' "$JOBS/handlers/foreman-claude.sh")"
printf 'JOB x-step\nROLE builder\nARC beta\ndo it\nENDJOB\n' > "$TR/resp"
out="$(bash -c "log() { :; }; $validate"'; validate_foreman_response "$1"' _ "$TR/resp")"
grep -qx 'ARC beta' <<<"$out" && ok "the handler validator passes an ARC line" || bad "validator: $out"
printf 'JOB x-step\nARC beta\nARC alpha\ndo it\nENDJOB\n' > "$TR/resp"
set +e; bash -c "log() { :; }; $validate"'; validate_foreman_response "$1"' _ "$TR/resp" >/dev/null; rc=$?; set -e
[ "$rc" -eq 20 ] && ok "a second ARC line fails closed" || bad "double ARC rc=$rc"

# --- carry-forward -------------------------------------------------------------------
"$JOBS/set-apportionment.sh" --carry-forward --week-start 2026-10-03T04:00:00Z >/dev/null 2>&1
refresh
jq -e '.week_start == "2026-10-03T04:00:00Z" and .carried_forward_from == "2026-09-26T04:00:00Z"
  and .authorized_by == "kriskowal" and .unallocated_tokens == 200' "$V/config/apportionment" >/dev/null \
  && jq -e '.window_start == "2026-10-03T04:00:00Z" and .token_cap == 500' "$V/config/arc-budgets/alpha" >/dev/null \
  && ok "carry-forward rolls the slate to the new week unchanged" || bad "carry-forward wrong"
before="$(commits)"
"$JOBS/set-apportionment.sh" --carry-forward --week-start 2026-10-03T04:00:00Z >/dev/null 2>&1
[ "$(commits)" = "$before" ] && ok "carry-forward is a no-op when already current" || bad "carry-forward re-committed"

# --- accountant-statement.sh ------------------------------------------------------------
refresh
plan p-held 100 'arc: beta'
stmt="$(GARDEN_STATE="$FSTATE" "$JOBS/accountant-statement.sh" --dir "$V" --now-epoch "$NOW" 2>/dev/null)"
grep -q '^# Accountant statement: week of 2026-09-26T04:00:00Z$' <<<"$stmt" \
  && grep -qF '| 1 | alpha | 500 | 510 | 102% | 0 | 0 | 2 | 10 |' <<<"$stmt" \
  && grep -qF '| 2 | beta | 300 | 300 | 100% | 0 | 1 | 1 | - |' <<<"$stmt" \
  && grep -q 'gamma: retired from the slate' <<<"$stmt" \
  && grep -q 'ironhorse-test262-ratchet: rolling' <<<"$stmt" \
  && grep -q -- '- p-held: arc-budget-over:beta' <<<"$stmt" \
  && grep -q -- '- arc-held:' <<<"$stmt" \
  && ok "the statement reports slices, spend, holds, and foreman decisions" \
  || { bad "statement:"; printf '%s\n' "$stmt"; }

# The Pools section estimates each pool's unattributed share: ceiling x used %
# minus arc-tagged rows on the pool's hosts and provider since its reset.
mkdir -p "$V/budget/reset-events" "$V/budget/manual-checkpoints"
printf 'pool-a\tanthropic\tweekly-tokens\t100000\ttest\t2026-09-26\npool-c\topenai\tpercent\t95\ttest\t2026-09-26\n' \
  > "$V/config/budget-pools"
printf 'pool-a\ttesthost\tmonk\npool-c\ttesthost\tcleric\n' > "$V/config/subscription-mapping"
for p in pool-a pool-c; do
  printf '{"cadence":"observed","reset_at":"2026-09-26T04:00:00Z"}\n' > "$V/budget/reset-events/$p.jsonl"
done
printf '{"checked_at":"2026-09-29T18:00:00Z","weekly_percent":10}\n' > "$V/budget/manual-checkpoints/pool-a.jsonl"
pool_row() { jq -cn --arg ts "$1" --arg host "$2" --arg arc "$3" --argjson n "$4" --arg model "$5" \
  '{ts:$ts,base:"p",host:$host,source:"result",model:$model,input_tokens:$n,output_tokens:0,cache_creation_tokens:0}
   + (if $arc != "" then {arc:$arc} else {} end)'; }
{ pool_row 2026-09-28T00:00:00Z testhost alpha 1000 claude-opus-5-5   # charged (provider from model)
  pool_row 2026-09-25T00:00:00Z testhost alpha 500 claude-opus-5-5    # before the reset
  pool_row 2026-09-28T00:00:00Z otherhost alpha 700 claude-opus-5-5   # another account's host
  pool_row 2026-09-28T00:00:00Z testhost "" 3000 claude-opus-5-5      # untagged
  echo 'not json'
} > "$V/usage/pools.jsonl"
stmt="$(GARDEN_STATE="$FSTATE" "$JOBS/accountant-statement.sh" --dir "$V" --now-epoch "$NOW" 2>/dev/null)"
grep -qF '| pool-a | ' <<<"$stmt" && grep -qF ' | 10 | 10K | 1K | 9K (90%) |' <<<"$stmt" \
  && grep -qE '^\| pool-c \| .* \| - \| 0 \| - \|$' <<<"$stmt" \
  && grep -q '^Method: used tokens = ceiling x used %' <<<"$stmt" \
  && ok "the statement estimates each pool's unattributed share" \
  || { bad "pool statement:"; sed -n '/## Pools/,/## Foreman/p' <<<"$stmt"; }

echo "RESULTS: $PASS passed, $FAIL failed"
[ "$FAIL" -eq 0 ]
