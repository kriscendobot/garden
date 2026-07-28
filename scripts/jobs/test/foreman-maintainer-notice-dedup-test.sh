#!/bin/bash
# foreman-maintainer-notice-dedup-test.sh — regression guard for the foreman's
# milestone/bottleneck maintainer-notice DEDUP (job foreman-dedup-maintainer-notices).
#
# THE BUG: when the board is bottlenecked on a maintainer merge/review, the foreman
# has nothing to promote, so its `claude -p` handler returns a MAINTAINER block
# EVERY tick. The old code keyed the note_once dedup on a `cksum` of the notice's
# PROSE — but the handler rewords the prose each tick, so the cksum changed and the
# near-identical notice re-posted every few minutes, flooding the maintainer inbox.
#
# THE FIX (mirrors identity-drift-guard.sh): key the dedup on a stable SUBSTANCE
# signature — the milestone ids (M2, M3, …) and PR/issue numbers (#719, #263, …)
# the notice references, normalized+sorted — recorded in a marker under
# $GARDEN_STATE. An unchanged state posts NOTHING; a new/closed PR or advancing
# milestone changes the signature and fires exactly once.
#
# SUBTEST 1 — two consecutive ticks over the SAME substance (prose reworded) post
#             the maintainer notice ONCE, not twice.
# SUBTEST 2 — a tick after the substance CHANGES (a PR number added) posts again
#             exactly once.
# SUBTEST 3 — the dedup marker lives under $GARDEN_STATE.
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

# Count the messages currently in inbox/maintainer/unread/ on the remote
# (excluding the .gitkeep placeholder).
maintainer_count() {
  local v n=0 f; v="$(mktemp -d)"
  git clone -q --single-branch --branch "$BRANCH" "$BARE" "$v" 2>/dev/null
  for f in "$v"/inbox/maintainer/unread/*; do
    [ -e "$f" ] || continue
    case "${f##*/}" in .gitkeep) continue ;; esac
    n=$(( n + 1 ))
  done
  rm -rf "$v"
  printf '%s\n' "$n"
}

# Run ONE foreman tick against the fixture. The board is empty (in-flight 0 < the
# default target 5) and IDLE_SETTLE=0, so any tick past the priming tick pumps.
# The handler is our stub, emitting the MAINTAINER body from $body_file.
tick() {
  local body_file="$1"
  env -i PATH="$PATH" HOME="$TR" \
    GARDEN="okhost" GARDEN_STATE="$STATE" \
    JOURNAL_REMOTE="$BARE" JOURNAL_BRANCH="$BRANCH" \
    GARDEN_FOREMAN_IDLE_SETTLE=0 \
    GARDEN_FOREMAN_HANDLER="$STUB" \
    GARDEN_TEST_NOTICE_BODY="$body_file" \
    "$JOBS/foreman.sh" >/dev/null 2>&1 || true
}

BODY_A1="$TR/body-a1"; BODY_A2="$TR/body-a2"; BODY_B="$TR/body-b"
# A1 and A2 describe the SAME substance (milestone M2/M3, PRs #719 and #263) with
# DIFFERENT prose — the exact flood the fix targets.
printf 'M2/M3 are stalled on the merge decision between #719 and #263.\n' > "$BODY_A1"
printf 'The milestone M2 (and M3) is one merge from complete: choose #263 over #719.\n' > "$BODY_A2"
# B changes the substance: a NEW PR (#800) enters the decision.
printf 'M2/M3 now stalled on #719 vs #263 vs the new #800.\n' > "$BODY_B"

# Priming tick: the first below-target observation only starts the settle clock
# (foreman.sh always exits after writing idle-since), so it posts nothing.
tick "$BODY_A1"
primed="$(maintainer_count)"

hr; echo "SUBTEST 1 — two ticks, SAME substance (reworded) → posts ONCE"; hr
tick "$BODY_A1"; after1="$(maintainer_count)"
tick "$BODY_A2"; after2="$(maintainer_count)"   # reworded, same substance
posted_same=$(( after2 - primed ))
[ "$after1" -gt "$primed" ] \
  && ok "first real tick posted the notice (count $primed → $after1)" \
  || bad "first real tick did NOT post (count stayed $primed)"
[ "$posted_same" -eq 1 ] \
  && ok "two consecutive same-substance ticks posted exactly ONCE (net +1), reworded prose deduped" \
  || bad "same-substance ticks posted $posted_same times (expected exactly 1)"

hr; echo "SUBTEST 2 — substance CHANGES (a PR added) → posts again ONCE"; hr
tick "$BODY_B"; after3="$(maintainer_count)"
delta_changed=$(( after3 - after2 ))
[ "$delta_changed" -eq 1 ] \
  && ok "the changed-substance tick posted again exactly once (net +1)" \
  || bad "changed-substance tick posted $delta_changed times (expected exactly 1)"
# And re-confirm the new state now dedups too.
printf 'Reworded: M2/M3 blocked across #263, #719, #800.\n' > "$BODY_B.re"
tick "$BODY_B.re"; after4="$(maintainer_count)"
[ "$(( after4 - after3 ))" -eq 0 ] \
  && ok "the changed state then dedups on repeat (net +0)" \
  || bad "changed state re-posted on repeat (expected +0)"

hr; echo "SUBTEST 3 — the dedup marker lives under \$GARDEN_STATE"; hr
[ -f "$STATE/foreman/notice-sig" ] \
  && ok "marker present at \$GARDEN_STATE/foreman/notice-sig" \
  || bad "expected marker \$GARDEN_STATE/foreman/notice-sig not found"
sig="$(cat "$STATE/foreman/notice-sig" 2>/dev/null || true)"
# The signature must carry substance tokens (PR numbers + milestone ids), not prose.
case "$sig" in
  *"#800"*|*"M2"*) ok "signature keys on substance tokens (sig='$sig')" ;;
  *)               bad "signature does not look substance-keyed (sig='$sig')" ;;
esac

hr
echo "RESULTS: $PASS passed, $FAIL failed"
[ "$FAIL" -eq 0 ]
