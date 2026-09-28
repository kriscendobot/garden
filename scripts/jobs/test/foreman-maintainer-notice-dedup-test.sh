#!/bin/bash
# foreman-maintainer-notice-dedup-test.sh — regression guard for the foreman's
# milestone/bottleneck maintainer-notice DEDUP (jobs foreman-dedup-maintainer-notices,
# fix-foreman-milestone-notice-dedup).
#
# THE BUG (twice): the handler's `claude -p` rewords its MAINTAINER notice every
# tick. A prose cksum re-posted every tick; the exact-set signature of the notice's
# M/# tokens that replaced it still re-posted whenever the prose named a different
# SUBSET of the same blockers (2026-09-27/28: 25 notices for M2 stalled on #1349 and
# #1356, alternating {#1349}, {#1349,#1356}, {#1356}).
#
# THE FIX: key by milestone, deliver only a never-seen ref (or after the TTL), and
# deliver through inbox-send.sh's coalescing mode so each milestone has ONE unread
# entry whose notice_count counts deliveries.
#
# SUBTEST 1 — the first notice for a milestone is delivered.
# SUBTEST 2 — the real captured M2 notices (subset/order/prose variation over the
#             SAME blockers) deliver nothing further.
# SUBTEST 3 — a genuinely new blocking PR is delivered, amending the SAME entry.
# SUBTEST 4 — a different milestone gets its own entry.
# SUBTEST 5 — past GARDEN_FOREMAN_NOTICE_TTL the stalled state re-reminds once,
#             still into the same entry.
# SUBTEST 6 — the seen-set lives under $GARDEN_STATE.
#
# systemd is not required: the test drives foreman.sh directly against a throwaway
# journal remote and inspects what lands in inbox/maintainer/unread/.
#
# Usage: foreman-maintainer-notice-dedup-test.sh
set -euo pipefail
# Explicit positive test-context sentinel: protects this standalone suite even when
# invoked outside the test-tree entrypoint heuristic.
export GARDEN_TEST=1
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
JOBS="$(cd "$HERE/.." && pwd)"
PASS=0; FAIL=0
ok()  { echo "  PASS: $*"; PASS=$((PASS+1)); }
bad() { echo "  FAIL: $*"; FAIL=$((FAIL+1)); }
hr()  { echo "----------------------------------------------------------------"; }

# Scrub ambient fleet env so a live gardener running this as a board job does not
# splice its own GARDEN_*/JOURNAL_* state underneath the fixture.
# shellcheck disable=SC2046  # deliberate word-splitting: unset each matched var
unset $(compgen -v 2>/dev/null | grep -E '^(GARDEN_|JOURNAL_|SELF_HEAL_|XDG_)' || true) 2>/dev/null || true

STUB="$HERE/foreman-maintainer-notice-stub.sh"

TR="$(mktemp -d "${TMPDIR:-/tmp}/garden-fnotice.XXXXXX")"; trap 'rm -rf "$TR"' EXIT
BARE="$TR/journal.git"; SEED="$TR/seed"; BRANCH=journal2
STATE="$TR/state"
declare -a GIT_ID=(-c user.name=test -c user.email=test@localhost)

# --- seed a throwaway journal remote: empty board + a live maintainer inbox ---
git init -q --bare "$BARE"
git init -q "$SEED"; git -C "$SEED" checkout -q -b "$BRANCH"
( cd "$SEED"
  mkdir -p jobs/todo jobs/doin jobs/tada jobs/plan work repos msgs hosts entries \
           schedules cursors inbox/maintainer/unread inbox/maintainer/read
  for d in jobs/todo jobs/doin jobs/tada jobs/plan work repos msgs hosts entries \
           schedules cursors inbox/maintainer/unread inbox/maintainer/read; do
    touch "$d/.gitkeep"
  done )
git -C "$SEED" add -A
git -C "$SEED" "${GIT_ID[@]}" commit -q -m "seed: empty board + live maintainer inbox"
git -C "$SEED" remote add origin "$BARE"
git -C "$SEED" push -q -u origin "$BRANCH"

# inbox_stat — print "<files> <deliveries>" for inbox/maintainer/unread/ on the
# remote: the entry count, and the sum of notice_count (an entry without one is 1).
inbox_stat() {
  local v files=0 deliv=0 f n; v="$(mktemp -d)"
  git clone -q --single-branch --branch "$BRANCH" "$BARE" "$v" 2>/dev/null
  for f in "$v"/inbox/maintainer/unread/*; do
    [ -e "$f" ] || continue
    case "${f##*/}" in .gitkeep) continue ;; esac
    files=$(( files + 1 ))
    n="$(sed -n 's/^notice_count: *//p' "$f" | head -1)"
    deliv=$(( deliv + ${n:-1} ))
  done
  rm -rf "$v"
  printf '%s %s\n' "$files" "$deliv"
}

# Run ONE foreman tick against the fixture. The board is empty (in-flight 0 < the
# default target 5) and IDLE_SETTLE=0, so any tick past the priming tick pumps.
# The handler is our stub, emitting the MAINTAINER body given as $1.
N=0
tick() {
  N=$(( N + 1 )); printf '%s\n' "$1" > "$TR/body-$N"
  env -i PATH="$PATH" HOME="$TR" \
    GARDEN="okhost" GARDEN_STATE="$STATE" \
    JOURNAL_REMOTE="$BARE" JOURNAL_BRANCH="$BRANCH" \
    GARDEN_FOREMAN_IDLE_SETTLE=0 \
    GARDEN_FOREMAN_NOTICE_TTL="${TTL:-86400}" \
    GARDEN_FOREMAN_HANDLER="$STUB" \
    GARDEN_TEST_NOTICE_BODY="$TR/body-$N" \
    "$JOBS/foreman.sh" >/dev/null 2>&1 || true
}

# Real notices captured from inbox/maintainer/unread/ on 2026-09-27/28, in posting
# order. Every one describes the same static state; the old signature gave them
# {#1349,M2}, {#1349,#1356,M2}, {#1356,M2}, {#1349,#1356,M2}, {#1349,M2} — five posts.
M2_FIRST='M2 is blocked at green draft PRs endojs/endo-but-for-bots#1349 and #1356. Decide the outstanding audit/design scope and authorize `run the gauntlet` for the PR(s); no autonomous work job can advance them.'
M2_VARIANTS=(
  'M2 hardened-url-shim is blocked at draft PR endojs/endo-but-for-bots#1356; decide whether to run its manual gauntlet and confirm the documented URL-shim design choices.'
  'M2 is awaiting promotion of draft PRs endojs/endo-but-for-bots#1349 and #1356. Decide whether to run the gauntlet for either PR; no autonomous work step may advance them past draft.'
  'Milestone M2 is blocked on maintainer-only manual-gauntlet promotion of its two green draft implementation PRs: endojs/endo-but-for-bots#1356 and #1349. Decide whether to run the gauntlet for each, and whether #1349 requires its remaining `llm` downstream audit before completion.'
  'Milestone M2 is blocked at draft endojs/endo-but-for-bots#1349 (hardened-text-codecs-shim), whose checks are clean. Decide whether to promote it with `run the gauntlet #1349`.'
)

# Priming tick: the first below-target observation only starts the settle clock
# (foreman.sh always exits after writing idle-since), so it posts nothing.
tick "$M2_FIRST"
read -r f0 d0 < <(inbox_stat)

hr; echo "SUBTEST 1 — first M2 notice is delivered"; hr
tick "$M2_FIRST"; read -r f1 d1 < <(inbox_stat)
[ "$f1" -eq $(( f0 + 1 )) ] && [ "$d1" -eq $(( d0 + 1 )) ] \
  && ok "first notice delivered (entries $f0 → $f1)" \
  || bad "first notice not delivered once (entries $f0 → $f1, deliveries $d0 → $d1)"

hr; echo "SUBTEST 2 — real reworded/subset M2 notices deliver nothing"; hr
for v in "${M2_VARIANTS[@]}"; do tick "$v"; done
read -r f2 d2 < <(inbox_stat)
[ "$f2" -eq "$f1" ] && [ "$d2" -eq "$d1" ] \
  && ok "${#M2_VARIANTS[@]} variant notices over the same blockers delivered nothing" \
  || bad "variants re-posted (entries $f1 → $f2, deliveries $d1 → $d2)"

hr; echo "SUBTEST 3 — a NEW blocking PR is delivered, into the same entry"; hr
tick 'M2 is now also blocked on draft #1400, alongside #1349 and #1356.'
read -r f3 d3 < <(inbox_stat)
[ "$f3" -eq "$f2" ] && [ "$d3" -eq $(( d2 + 1 )) ] \
  && ok "new PR #1400 delivered as an amend (deliveries $d2 → $d3, entries stay $f3)" \
  || bad "new PR not delivered as one amend (entries $f2 → $f3, deliveries $d2 → $d3)"
tick 'M2 blocked on #1400.'
read -r f3b d3b < <(inbox_stat)
[ "$d3b" -eq "$d3" ] \
  && ok "the new blocker then dedups on repeat" \
  || bad "new blocker re-posted on repeat (deliveries $d3 → $d3b)"
v="$(mktemp -d)"; git clone -q --single-branch --branch "$BRANCH" "$BARE" "$v" 2>/dev/null
grep -qs '#1400' "$v"/inbox/maintainer/unread/*foreman-milestone-M2* \
  && ok "the M2 entry carries the latest detail (#1400)" \
  || bad "the M2 entry does not carry the new blocker"
rm -rf "$v"

hr; echo "SUBTEST 4 — a different milestone gets its own entry"; hr
tick 'M3 is blocked on approval of draft #1015.'
read -r f4 d4 < <(inbox_stat)
[ "$f4" -eq $(( f3b + 1 )) ] && [ "$d4" -eq $(( d3b + 1 )) ] \
  && ok "M3 notice delivered as a separate entry" \
  || bad "M3 notice not delivered separately (entries $f3b → $f4, deliveries $d3b → $d4)"

hr; echo "SUBTEST 5 — past the TTL a stalled milestone re-reminds once"; hr
TTL=0 tick "${M2_VARIANTS[0]}"
read -r f5 d5 < <(inbox_stat)
[ "$f5" -eq "$f4" ] && [ "$d5" -eq $(( d4 + 1 )) ] \
  && ok "expired seen-set re-delivered as an amend (deliveries $d4 → $d5)" \
  || bad "TTL reminder wrong (entries $f4 → $f5, deliveries $d4 → $d5)"
tick "${M2_VARIANTS[1]}"   # #1349 was dropped from the seen-set at the restart
read -r _ d6 < <(inbox_stat)
[ "$d6" -eq $(( d5 + 1 )) ] \
  && ok "after the TTL restart the seen-set restarts from the reminder" \
  || bad "seen-set did not restart (deliveries $d5 → $d6)"

hr; echo "SUBTEST 6 — the seen-set lives under \$GARDEN_STATE"; hr
seen="$STATE/foreman/notice-seen/M2"
[ -f "$seen" ] && ok "seen-set present at \$GARDEN_STATE/foreman/notice-seen/M2" \
  || bad "expected \$GARDEN_STATE/foreman/notice-seen/M2 not found"
grep -qx '#1356' "$seen" 2>/dev/null && grep -qx '#1349' "$seen" 2>/dev/null \
  && ok "seen-set records the refs ($(tail -n +2 "$seen" | paste -sd, -))" \
  || bad "seen-set does not record the refs"

hr
echo "RESULTS: $PASS passed, $FAIL failed"
[ "$FAIL" -eq 0 ]
