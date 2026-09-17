#!/bin/bash
# reputation-reduce-incremental-test.sh - bounded discovery, scan resume, and
# changed-arm-only reputation projection updates. Hermetic; no network/systemd.
set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
JOBS="$(cd "$HERE/.." && pwd)"
ROOT="$(cd "$JOBS/../.." && pwd)"
# shellcheck disable=SC2046 # Intentional variable-name expansion.
unset $(compgen -v 2>/dev/null | grep -E '^(GARDEN_|JOURNAL_|SELF_HEAL_|XDG_)' || true) 2>/dev/null || true
export GARDEN_TEST=1 GARDEN_ROOT="$ROOT" GARDEN_NO_MAINTAINER_ALERT=1
PASS=0; FAIL=0
ok() { echo "  PASS: $*"; PASS=$((PASS+1)); }
bad() { echo "  FAIL: $*"; FAIL=$((FAIL+1)); }
TR="$(mktemp -d "${TMPDIR:-/tmp}/rep-incremental.XXXXXX")"
trap 'rm -rf "$TR"' EXIT
BARE="$TR/journal.git"; SEED="$TR/seed"; STATE="$TR/state"
git_id=(-c user.name=test -c user.email=test@localhost)
git init -q --bare "$BARE"
git init -q "$SEED"; git -C "$SEED" checkout -q -b journal2
mkdir -p "$SEED/reputation/events" "$SEED/reputation/arms" "$SEED/reputation/pending" \
  "$SEED/reputation/adjustments" "$SEED/reputation/verdicts" "$SEED/reputation/reviews" \
  "$SEED/jobs/doin" "$SEED/jobs/tada"

event() { # event <base> <model>
  local base="$1" model="$2"
  {
    printf -- '---\nbase: %s\nkind: cleric\nprovider: openai\n' "$base"
    printf 'model: %s\nthoughtfulness: medium\nwork_class: fix:s\ntarget: main2\n' "$model"
    printf 'accepted: true\naggregate_dollars: 1.000000\nduration_secs: 10\n---\n'
  } > "$SEED/reputation/events/$base.md"
}
for n in 1 2 3 4 5; do event "a$n" model-a; done
git -C "$SEED" add -A; git -C "$SEED" "${git_id[@]}" commit -q -m seed
git -C "$SEED" remote add origin "$BARE"; git -C "$SEED" push -q -u origin journal2

run_reduce() {
  env GARDEN=test GARDEN_STATE="$STATE" JOURNAL_REMOTE="$BARE" JOURNAL_BRANCH=journal2 \
    GARDEN_REP_FLAT_PROVIDERS= GARDEN_REP_REDUCE_DISCOVERY_BATCH=2 \
    GARDEN_REP_REDUCE_EVENT_BUDGET=2 "$JOBS/reputation-reduce.sh" > "$TR/reduce.log" 2>&1 || {
      sed 's/^/    /' "$TR/reduce.log" >&2
      return 1
    }
}
arm_a='reputation/arms/cleric/openai/model-a/medium/fix-s@main2.md'
arm_b='reputation/arms/cleric/openai/model-b/medium/fix-s@main2.md'

run_reduce
[ ! -e "$STATE/reducer/journal/$arm_a" ] && [ -s "$STATE/reducer/checkpoint/active-cursor" ] \
  && ok "first tick defers after the two-event scan budget and saves an active cursor" \
  || bad "first tick did not stop at a resumable event checkpoint"
run_reduce; run_reduce
[ -f "$STATE/reducer/journal/$arm_a" ] \
  && [ "$(sed -n 's/^attempts:[[:space:]]*//p' "$STATE/reducer/journal/$arm_a")" = 5 ] \
  && ok "later ticks resume and finish the five-event arm" \
  || bad "resumed bootstrap did not produce attempts=5"

a_before="$(git -C "$STATE/reducer/journal" hash-object "$arm_a")"
event b1 model-b
git -C "$SEED" pull -q --rebase origin journal2
git -C "$SEED" add reputation/events/b1.md
git -C "$SEED" "${git_id[@]}" commit -q -m add-b
git -C "$SEED" push -q origin journal2
for _ in 1 2 3 4; do run_reduce; done
[ -f "$STATE/reducer/journal/$arm_b" ] \
  && [ "$(sed -n 's/^attempts:[[:space:]]*//p' "$STATE/reducer/journal/$arm_b")" = 1 ] \
  && ok "a newly finalized event queues and recomputes only its affected arm" \
  || bad "changed-arm projection was not produced"
a_after="$(git -C "$STATE/reducer/journal" hash-object "$arm_a")"
[ "$a_before" = "$a_after" ] \
  && ok "unaffected arm projection stays byte-identical" \
  || bad "unaffected arm was rewritten"

mkdir -p "$SEED/reputation/adjustments/b1"
printf '%s\n' 'base: b1' 'agentic_dollars: 7.000000' > "$SEED/reputation/adjustments/b1/invoice.md"
git -C "$SEED" pull -q --rebase origin journal2
git -C "$SEED" add reputation/adjustments/b1/invoice.md
git -C "$SEED" "${git_id[@]}" commit -q -m adjust-b
git -C "$SEED" push -q origin journal2
for _ in 1 2 3 4; do run_reduce; done
[ "$(sed -n 's/^mean_dollars:[[:space:]]*//p' "$STATE/reducer/journal/$arm_b")" = 7.000000 ] \
  && ok "an adjustment requeues its event arm without touching other projections" \
  || bad "adjustment path did not requeue the affected arm"

run_reduce
grep -q 'reputation projections current' "$TR/reduce.log" \
  && ok "an empty tick starts no full-history reduction" \
  || bad "empty tick did not report a current checkpoint"

echo "reputation-reduce-incremental-test: $PASS passed, $FAIL failed"
[ "$FAIL" -eq 0 ]
