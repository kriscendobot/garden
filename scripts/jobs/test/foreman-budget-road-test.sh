#!/bin/bash
# foreman-budget-road-test.sh — the foreman under the budget road
# (designs/budget-road.md § The foreman's part), end to end against a throwaway
# journal remote:
#   A. the digest carries allocation/mandate.md and an arc_admission block, and
#      the accepted step is posted with its arc stamped;
#   B. a step for a held arc is refused (arc-refused);
#   C. when everything is spent, ONE "Budget spent" maintainer notice goes out,
#      and not again the same day.
set -euo pipefail
export GARDEN_TEST=1
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
JOBS="$(cd "$HERE/.." && pwd)"
PASS=0; FAIL=0
ok()  { echo "  PASS: $*"; PASS=$((PASS+1)); }
bad() { echo "  FAIL: $*"; FAIL=$((FAIL+1)); }
hr()  { echo "----------------------------------------------------------------"; }
# shellcheck disable=SC2046
unset $(compgen -v 2>/dev/null | grep -E '^(GARDEN_|JOURNAL_|SELF_HEAL_|XDG_)' || true) 2>/dev/null || true
export GARDEN_TEST=1

BRANCH=journal2
declare -a GIT_ID=(-c user.name=test -c user.email=test@localhost)
TR="$(mktemp -d "${TMPDIR:-/tmp}/garden-froad.XXXXXX")"; trap 'rm -rf "$TR"' EXIT
NOW="$(date -u -d 2026-09-29T15:00:00Z +%s)"   # t = 0.5 in the 09-26 -> 10-03 window

new_journal() { # <tag> → bare path
  local tag="$1" bare="$TR/$1.git" seed="$TR/$1.seed" d
  git init -q --bare "$bare"
  git init -q "$seed"; git -C "$seed" checkout -q -b "$BRANCH"
  ( cd "$seed"
    for d in jobs/todo jobs/doin jobs/tada jobs/plan work repos msgs hosts entries schedules cursors \
             config inbox/maintainer/unread inbox/maintainer/read allocation budget/reset-events maintainers usage; do
      mkdir -p "$d"; touch "$d/.gitkeep"
    done
    printf 'claude-endolin1\tanthropic\tweekly-tokens\t100\tfixture\t2026-09-20\n' > config/budget-pools
    printf 'claude-endolin1\tokhost\tmonk\n' > config/subscription-mapping
    printf '%s\n' '{"subscription_id":"claude-endolin1","event_type":"declared-schedule","cadence":"calendar","schedule_weekday":5,"schedule_time":"20:00","timezone":"America/Los_Angeles","reset_at_precision":"exact","reset_at":"2026-09-19T03:00:00Z"}' \
      > budget/reset-events/claude-endolin1.jsonl
    printf '{"schema":1,"lanes":{"primary":0.6,"secondary":0.4},"pinned":["alpha"],"arcs":[{"arc":"alpha","summary":"Alpha arc"},{"arc":"beta","summary":"Beta arc"}],"aliases":{}}\n' \
      > allocation/road.json
    printf 'Work the road in order.\n1. alpha (pinned): Alpha arc\n' > allocation/mandate.md
    printf -- '---\narc: alpha\n---\nwork\n' > jobs/todo/alpha-1.md )
  git -C "$seed" add -A
  git -C "$seed" "${GIT_ID[@]}" commit -q -m seed
  git -C "$seed" remote add origin "$bare"
  git -C "$seed" push -q -u origin "$BRANCH"
  printf '%s\n' "$bare"
}

tick() { # <bare> <state> [env…]
  local bare="$1" state="$2"; shift 2
  mkdir -p "$state"
  env GARDEN=okhost GARDEN_STATE="$state" HOME="$TR" JOURNAL_REMOTE="$bare" JOURNAL_BRANCH="$BRANCH" \
      GARDEN_FOREMAN_IDLE_SETTLE=0 GARDEN_FOREMAN_ACTIVE_TARGET=5 GARDEN_FOREMAN_NOW="$NOW" \
      GARDEN_USAGE_NOW="$NOW" GARDEN_ROAD_CACHE_SECS=0 GARDEN_ROAD_W_KRIS=0 \
      GARDEN_FOREMAN_HANDLER="$HERE/foreman-stub.sh" GARDEN_FOREMAN_STUB_CALLS="$state/stub-calls" \
      GARDEN_CCUSAGE_LOGDIR="$TR/no-logs" "$@" "$JOBS/foreman.sh" >>"$state/foreman.log" 2>&1 || true
}
peek() { # <bare> <path-glob> — print matching files on the remote's journal2
  local w="$TR/peek.$RANDOM"
  git clone -q -b "$BRANCH" "$1" "$w" 2>/dev/null
  # shellcheck disable=SC2086
  cat $w/$2 2>/dev/null || true
  rm -rf "$w"
}

hr; echo "SUBTEST A — digest and stamped post"; hr
BA="$(new_journal a)"; SA="$TR/state-a"
tick "$BA" "$SA" GARDEN_ROAD_U=0.20 GARDEN_FOREMAN_STUB_DIGEST="$TR/digest-a" GARDEN_FOREMAN_STUB_ARC=alpha
tick "$BA" "$SA" GARDEN_ROAD_U=0.20 GARDEN_FOREMAN_STUB_DIGEST="$TR/digest-a" GARDEN_FOREMAN_STUB_ARC=alpha
grep -q '^arc_admission: |' "$TR/digest-a" 2>/dev/null && grep -q 'alpha primary reserved' "$TR/digest-a" \
  && ok "the digest carries arc_admission with alpha in the primary lane" \
  || bad "digest lacks arc_admission: $(cat "$TR/digest-a" 2>/dev/null)"
grep -q 'Work the road in order' "$TR/digest-a" 2>/dev/null \
  && ok "the digest carries allocation/mandate.md" || bad "digest lacks the road mandate"
grep -q '^arc: alpha' <<<"$(peek "$BA" 'jobs/todo/foreman-next-step.md')" \
  && ok "the accepted step is posted with arc: alpha" \
  || bad "posted step lacks arc: alpha ($(peek "$BA" 'jobs/todo/foreman-next-step.md'))"

hr; echo "SUBTEST B — a held arc's step is refused"; hr
BB="$(new_journal b)"; SB="$TR/state-b"
# u = 0.60 at t = 0.5: under the 0.65 bound, but discretion is spent, so beta
# (no lane) is held while alpha keeps its reservation.
tick "$BB" "$SB" GARDEN_ROAD_U=0.60 GARDEN_FOREMAN_STUB_ARC=beta
tick "$BB" "$SB" GARDEN_ROAD_U=0.60 GARDEN_FOREMAN_STUB_ARC=beta
grep -q 'guard=arc-refused base=foreman-next-step arc=beta' "$SB/foreman/decisions.log" 2>/dev/null \
  && ok "a step for held beta is refused" \
  || bad "held arc not refused: $(cat "$SB/foreman/decisions.log" 2>/dev/null)"

hr; echo "SUBTEST B2 — a pin holds the pump silently"; hr
BB="$(new_journal b2)"; SB="$TR/state-b2"
tick "$BB" "$SB" GARDEN_ROAD_U=0.20 GARDEN_FOREMAN_STUB_ARC=gamma GARDEN_TOKEN_BACKOFF_FRACTION=0.10
tick "$BB" "$SB" GARDEN_ROAD_U=0.20 GARDEN_FOREMAN_STUB_ARC=gamma GARDEN_TOKEN_BACKOFF_FRACTION=0.10
if grep -q 'guard=token-backoff\|guard=budget-backoff' "$SB/foreman/decisions.log" 2>/dev/null; then
  ok "a pin below u holds the pump"
else
  bad "a pin below u did not hold the pump: $(cat "$SB/foreman/decisions.log" 2>/dev/null)"
fi
[ -z "$(peek "$BB" 'inbox/maintainer/unread/*')" ] \
  && ok "a pin never sends the Budget spent notice" || bad "a pin sent a maintainer notice"

hr; echo "SUBTEST C — one Budget spent notice a day"; hr
BC="$(new_journal c)"; SC="$TR/state-c"
rm -f "$TR/seedc"; git clone -q -b "$BRANCH" "$BC" "$TR/seedc"
rm "$TR/seedc/jobs/todo/alpha-1.md"; git -C "$TR/seedc" add -A
git -C "$TR/seedc" "${GIT_ID[@]}" commit -q -m "no planned work"; git -C "$TR/seedc" push -q origin "$BRANCH"
tick "$BC" "$SC" GARDEN_ROAD_U=0.70
tick "$BC" "$SC" GARDEN_ROAD_U=0.70
tick "$BC" "$SC" GARDEN_ROAD_U=0.70
n="$(peek "$BC" 'inbox/maintainer/unread/*' | grep -c 'Budget spent' || true)"
[ "$n" = 1 ] && ok "exactly one Budget spent notice across three spent ticks" \
  || bad "expected one Budget spent notice, got $n: $(tail -5 "$SC/foreman.log")"
[ ! -s "$SC/stub-calls" ] && ok "a spent budget never invokes the agent" || bad "spent budget invoked the agent"

hr
echo "RESULTS: $PASS passed, $FAIL failed"
[ "$FAIL" -eq 0 ]
