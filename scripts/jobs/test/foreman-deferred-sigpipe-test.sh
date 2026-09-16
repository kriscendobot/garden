#!/bin/bash
# foreman-deferred-sigpipe-test.sh — regression guard for the foreman tick crashing
# with a nonzero rc and zero diagnostics whenever jobs/plan/ holds 2+ deferred plan
# jobs (job self-heal-fix-garden-foreman-plan-deferred-ranked-sigpipe, 2026-09-16).
#
# THE BUG this pins: foreman.sh's deferred-promotion loop read the top-ranked plan
# job with
#     top_deferred="$(plan_deferred_ranked "$DIR" | head -1)"
# under `set -euo pipefail`. plan_deferred_ranked (common.sh) ends its pipeline in
# `| cut -f3`. With 2+ deferred plan jobs it emits 2+ lines; the reader (`head -1`)
# captures the first line and closes the pipe, so `cut`'s still-pending write to the
# closed reader fails — under an inherited SIG_IGN disposition (as when the foreman
# runs under systemd) `cut` prints `cut: write error: Broken pipe` and exits 1; under
# the default disposition it is killed by SIGPIPE (exit 141). EITHER way pipefail
# makes the substitution nonzero and `set -e` aborts the ENTIRE tick — even though
# the value we wanted was already captured. A board with 2+ deferred plan jobs could
# therefore never pump: every tick died on this line, self-heal captured only a
# 30-byte broken-pipe blob (capture dbcf68b220fa…), and nothing past that line ran.
#
# THE FIX appends `|| true` so the writer-side pipeline failure cannot fail the tick;
# the captured first line is intact.
#
# SUBTEST 1 (behavioral, end-to-end) — a real foreman tick over a board with 2+
#   deferred plan jobs and NO in-flight work runs to COMPLETION (rc=0) and promotes
#   at least one plan job into todo/, exactly as the fix intends.
#
# SUBTEST 2 (mechanism, deterministic) — drives the EXACT idiom against the REAL
#   plan_deferred_ranked from common.sh: with the ranked output made large enough to
#   fill the pipe buffer (so `cut` is provably still writing when the reader closes),
#   the UNGUARDED substitution aborts a `set -euo pipefail` shell (proving the crash
#   is real and reproducible), while the GUARDED form (matching the shipped
#   foreman.sh:302 `|| true`) survives AND still captures the top-ranked basename.
#   A prompt-closing one-line reader stands in for `head -1`: it forces the writer's
#   broken-pipe failure that GNU head's large read buffer happens to mask in a fast
#   local shell but that the foreman hit in production. Subtest 2 also asserts the
#   shipped foreman.sh line still carries the `|| true` guard.
#
# systemd is not required: the scripts drive a throwaway journal remote and
# host-local $GARDEN_STATE markers, exactly like foreman-decision-log-test.sh.
#
# Usage: foreman-deferred-sigpipe-test.sh
set -euo pipefail
export GARDEN_TEST=1
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
JOBS="$(cd "$HERE/.." && pwd)"
PASS=0; FAIL=0
ok()  { echo "  PASS: $*"; PASS=$((PASS+1)); }
bad() { echo "  FAIL: $*"; FAIL=$((FAIL+1)); }
hr()  { echo "----------------------------------------------------------------"; }

# Scrub ambient fleet env so a live gardener running this as a board job does not
# splice its own GARDEN_*/JOURNAL_* state underneath the fixture.
# shellcheck disable=SC2046
unset $(compgen -v 2>/dev/null | grep -E '^(GARDEN_|JOURNAL_|SELF_HEAL_|XDG_)' || true) 2>/dev/null || true
export GARDEN_TEST=1

STUB="$HERE/foreman-stub.sh"
BRANCH=journal2
declare -a GIT_ID=(-c user.name=test -c user.email=test@localhost)
TR="$(mktemp -d "${TMPDIR:-/tmp}/garden-fdsig.XXXXXX")"; trap 'rm -rf "$TR"' EXIT

# ============================================================================
# SUBTEST 1 — behavioral, end-to-end
# ============================================================================
# new_journal <tag> <n> → bare path: a fresh journal seeded with <n> DEFERRED plan
# jobs (bare bodies, so plan_gate defaults to `deferred` and plan_priority to
# `normal`) and NO in-flight todo/doin work, so the board is below the active-job
# target and the deferred-promotion loop is reached.
new_journal() {
  local tag="$1" n="$2"; local bare="$TR/$tag.git"; local seed="$TR/$tag.seed"
  git init -q --bare "$bare"
  git init -q "$seed"; git -C "$seed" checkout -q -b "$BRANCH"
  ( cd "$seed"
    mkdir -p jobs/todo jobs/doin jobs/tada jobs/plan work repos msgs hosts entries \
             schedules cursors config inbox/maintainer/unread inbox/maintainer/read
    for d in jobs/todo jobs/doin jobs/tada jobs/plan work repos msgs hosts entries \
             schedules cursors config inbox/maintainer/unread inbox/maintainer/read; do
      touch "$d/.gitkeep"
    done
    local i
    for i in $(seq 1 "$n"); do
      printf '# deferred-%s\n\ndo the deferred work for deferred-%s\n' "$i" "$i" > "jobs/plan/deferred-$i.md"
    done )
  git -C "$seed" add -A
  git -C "$seed" "${GIT_ID[@]}" commit -q -m "seed: board + $n deferred plan jobs"
  git -C "$seed" remote add origin "$bare"
  git -C "$seed" push -q -u origin "$BRANCH"
  printf '%s\n' "$bare"
}

# tick <bare> <state> <target> → real foreman rc. Settle window collapsed to 0 so a
# two-tick caller reaches the pump on the second tick. The rc is RETURNED (not
# swallowed with `|| true`) so a crashing tick is visible to the assertions.
tick() {
  local bare="$1" state="$2" target="$3" rc=0
  mkdir -p "$state"
  env GARDEN="okhost" GARDEN_STATE="$state" HOME="$TR" \
      JOURNAL_REMOTE="$bare" JOURNAL_BRANCH="$BRANCH" \
      GARDEN_FOREMAN_IDLE_SETTLE=0 \
      GARDEN_FOREMAN_ACTIVE_TARGET="$target" \
      GARDEN_FOREMAN_HANDLER="$STUB" \
      GARDEN_FOREMAN_STUB_CALLS="$state/stub-calls" \
      "$JOBS/foreman.sh" >"$state/tick.log" 2>&1 || rc=$?
  printf '%s\n' "$rc"
}

# todo_count <bare> → number of *.md jobs in jobs/todo on the pushed board.
todo_count() {
  local bare="$1" v; v="$(mktemp -d)"
  git clone -q --single-branch --branch "$BRANCH" "$bare" "$v" 2>/dev/null
  local c; c="$(find "$v/jobs/todo" -maxdepth 1 -name '*.md' -type f 2>/dev/null | grep -c . || true)"
  rm -rf "$v"; printf '%s\n' "$c"
}

hr; echo "SUBTEST 1 — 2+ deferred plan jobs: the pump tick COMPLETES and promotes, does not crash"; hr
B1="$(new_journal one 4)"; S1="$TR/state-one/f"; mkdir -p "$S1"
tick "$B1" "$S1" 5 >/dev/null          # tick 1: below target → settle-start (settle=0)
rc="$(tick "$B1" "$S1" 5)"             # tick 2: settle elapsed → deferred-promotion loop
[ "$rc" = "0" ] \
  && ok "the pump tick over a board with 4 deferred plan jobs exited 0 (no abort)" \
  || bad "the pump tick exited $rc — the plan_deferred_ranked|head crash (log: $(tr '\n' '|' <"$S1/tick.log"))"
n="$(todo_count "$B1")"
[ "$n" -ge 1 ] \
  && ok "at least one deferred plan job was promoted plan→todo (todo now has $n)" \
  || bad "no deferred plan job was promoted (todo has $n) — the loop died before promoting"

# ============================================================================
# SUBTEST 2 — mechanism, deterministic
# ============================================================================
# A prompt-closing one-line reader: reads exactly ONE line byte-wise and exits,
# leaving the rest of the writer's output undrained in the pipe. This is a faithful
# stand-in for `head -1` that reliably forces the writer's broken-pipe failure (GNU
# head's large read buffer would otherwise drain the whole pipe in one read and mask
# the race locally). /tmp is often noexec, so it is invoked as `bash <path>`.
READER="$TR/read-one-line.sh"
printf 'IFS= read -r line; printf "%%s\\n" "$line"\n' > "$READER"

# A repro harness that sources the REAL common.sh, seeds a plain plan dir with
# long-named deferred jobs so plan_deferred_ranked's `| cut -f3` output exceeds the
# 64 KiB pipe buffer (cut is then provably still writing when the reader closes),
# then runs ONE trial of the idiom in the requested mode under `set -euo pipefail`.
#   mode=buggy → the UNGUARDED substitution; the harness must abort (nonzero exit).
#   mode=fixed → the GUARDED `|| true` substitution; the harness must exit 0 having
#                captured the top-ranked basename (exit 9 signals an empty capture).
HARNESS="$TR/repro.sh"
cat > "$HARNESS" <<'REPRO'
export GARDEN_TEST=1
source "$JOBS/common.sh"
mode="$1" reader="$2"
d="$(mktemp -d)"; mkdir -p "$d/$JOBS_PLAN"
long="$(head -c 210 /dev/zero | tr '\0' x)"           # ~230-char basenames …
for i in $(seq 1 520); do : > "$d/$JOBS_PLAN/def-$long-$(printf '%04d' "$i").md"; done  # … × 520 ≈ 114 KiB
rc=0
if [ "$mode" = buggy ]; then
  ( set -euo pipefail; x="$(plan_deferred_ranked "$d" | bash "$reader")"; ) || rc=$?
else
  ( set -euo pipefail
    x="$(plan_deferred_ranked "$d" | bash "$reader")" || true
    [ -n "$x" ] || exit 9 ) || rc=$?
fi
rm -rf "$d"
exit "$rc"
REPRO

run_repro() {  # run_repro <mode> → the harness rc
  local mode="$1" rc=0
  env JOBS="$JOBS" bash "$HARNESS" "$mode" "$READER" >/dev/null 2>&1 || rc=$?
  printf '%s\n' "$rc"
}

hr; echo "SUBTEST 2 — the idiom crashes UNGUARDED and survives with the shipped '|| true' guard"; hr

# 2a — the UNGUARDED idiom deterministically aborts the pipefail shell (the bug).
buggy_crashes=1
for _t in 1 2 3; do
  [ "$(run_repro buggy)" = "0" ] && buggy_crashes=0
done
[ "$buggy_crashes" = "1" ] \
  && ok "the UNGUARDED '\$(plan_deferred_ranked | reader)' aborts set -e (crash reproduced 3/3)" \
  || bad "the unguarded idiom did NOT crash — the repro no longer exercises the SIGPIPE defect"

# 2b — the GUARDED idiom (the shipped fix) survives AND captures the top-ranked base.
fixed_ok=1
for _t in 1 2 3; do
  [ "$(run_repro fixed)" = "0" ] || fixed_ok=0
done
[ "$fixed_ok" = "1" ] \
  && ok "the GUARDED '… | reader) || true' exits 0 and still captures the top-ranked job (3/3)" \
  || bad "the guarded idiom failed — '|| true' does not neutralize the writer-side broken pipe"

# 2c — the shipped foreman.sh line still carries the guard the mechanism above proves.
if grep -qE '^\s*top_deferred="\$\(plan_deferred_ranked "\$DIR" \| head -1\)" \|\| true\s*$' "$JOBS/foreman.sh"; then
  ok "foreman.sh reads the top deferred job with the '|| true' guard"
else
  bad "foreman.sh:top_deferred no longer carries the '|| true' guard — the crash can return"
fi

hr
echo "RESULTS: $PASS passed, $FAIL failed"
[ "$FAIL" -eq 0 ]
