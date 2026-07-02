#!/bin/bash
# reaper-poison-park-test.sh — validate the reaper's POISON path (kriskowal
# 2026-07-02): on exhausting a job's requeue budget the reaper must (a) PARK the
# job in jobs/plan/ under a HELD gate (never dropped, never auto-promoted) and
# (b) AMEND an existing keyed maintainer notice for the same job+condition rather
# than posting a near-identical new message.
#
# Subtests (all hermetic; no systemd, no network — a local bare journal):
#   1. PARK       — a poisoned job lands in jobs/plan/ gated `go-ahead`, carrying
#                   poison provenance, with its original body preserved; it is gone
#                   from doin/ and NOT in todo/. plan_deferred_ranked excludes it,
#                   so no auto-promoter will re-run it.
#   2. DEDUP      — poisoning the SAME job for the SAME condition a second time
#                   updates the SAME plan entry (no duplicate) and AMENDS the SAME
#                   maintainer notice (notice_count bumps) — ONE parked plan, ONE
#                   message, not two of each. (The 37-identical-messages fix.)
#   3. DIFFERENT  — poisoning the same job for a MATERIALLY DIFFERENT reason
#                   (deadline-overrun vs requeue-exhausted) posts a NEW message
#                   (distinct key), not an amend.
#
# Usage: reaper-poison-park-test.sh

set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
JOBS="$(cd "$HERE/.." && pwd)"
BRANCH=journal2
TR=/home/kris/.garden-reaper-poison-test
PASS=0; FAIL=0
ok()  { echo "  PASS: $*"; PASS=$((PASS+1)); }
bad() { echo "  FAIL: $*"; FAIL=$((FAIL+1)); }
hr()  { echo "----------------------------------------------------------------"; }

# Hermetic baseline: a live gardener may invoke this test with the fleet's own
# GARDEN_*/JOURNAL_* exported (see run-test.sh). Scrub them so ONLY the throwaway
# $TR settings are authoritative.
unset $(compgen -v 2>/dev/null | grep -E '^(GARDEN_|JOURNAL_|SELF_HEAL_)' || true) 2>/dev/null || true

rm -rf "$TR"; mkdir -p "$TR"
BARE="$TR/journal.git"
git_id=(-c user.name=test -c user.email=test@localhost)

# --- seed the shared origin -------------------------------------------------
git init -q --bare "$BARE"
SEED="$TR/seed"; git init -q "$SEED"
git -C "$SEED" checkout -q -b "$BRANCH"
( cd "$SEED"
  mkdir -p jobs/todo jobs/doin jobs/tada jobs/plan work \
           inbox/maintainer/unread inbox/maintainer/read
  for d in jobs/todo jobs/doin jobs/tada jobs/plan work \
           inbox/maintainer/unread inbox/maintainer/read; do touch "$d/.gitkeep"; done )
git -C "$SEED" add -A
git -C "$SEED" "${git_id[@]}" commit -q -m "seed: board structure"
git -C "$SEED" remote add origin "$BARE"
git -C "$SEED" push -q -u origin "$BRANCH"

# common env pointing every script at the throwaway journal
export JOURNAL_REMOTE="$BARE" JOURNAL_BRANCH="$BRANCH"
export GARDEN=testhost GARDEN_STATE="$TR/state"
export GARDEN_POST_ATTEMPTS=50 GARDEN_REAP_PUSH_ATTEMPTS=50
# Poison on the FIRST reap so the test is deterministic; overrun threshold at its
# default 2 so a deadline-overrun marker of 2 trips the distinct signature.
export GARDEN_REAP_POISON_THRESHOLD=1 GARDEN_REAP_OVERRUN_THRESHOLD=2
export GARDEN_CLAIM_TTL=3600

# --- board inspection helpers (fresh clone each call) -----------------------
V="$TR/verify"
resync() { rm -rf "$V"; git clone -q --single-branch --branch "$BRANCH" "$BARE" "$V"; }
count_unread() { resync; ls -1 "$V/inbox/maintainer/unread" 2>/dev/null | grep -v -x '.gitkeep' | grep -c . || true; }

# Place a STALE claim in doin/<base>.md (old claimed_at → past TTL), optionally
# carrying a deadline-overrun marker in its body. Simulates a gardener that
# claimed the job and died.  place_stale <base> [overrun-N]
place_stale() {
  local base="$1" overrun="${2:-}" wt; wt="$(mktemp -d "$TR/edit.XXXXXX")"
  git clone -q --single-branch --branch "$BRANCH" "$BARE" "$wt"
  {
    printf '# %s\n\nthe original work body for %s\n\n' "$base" "$base"
    [ -n "$overrun" ] && printf '<!-- garden-deadline-overrun: %s -->\n' "$overrun"
    printf -- '---\nclaim:\n  host: testhost\n  gardener: 7\n  claimed_at: 2020-01-01T00:00:00Z\n'
  } > "$wt/jobs/doin/$base.md"
  # A real claimed job always has a work/<base> record (written at claim time); the
  # reaper reads its worktree_dir for orphan cleanup. Provide one so the fixture
  # matches production shape.
  printf 'worktree_dir: %s\n' "$TR/nonexistent-wt-$base" > "$wt/work/$base"
  git -C "$wt" add "jobs/doin/$base.md" "work/$base"
  git -C "$wt" "${git_id[@]}" commit -q -m "place stale $base"
  git -C "$wt" push -q origin "HEAD:$BRANCH"
  rm -rf "$wt"
}

run_reaper() { "$JOBS/reaper.sh" >"$TR/reap.log" 2>&1 || { echo "  (reaper.sh rc=$? — see below)"; sed 's/^/    /' "$TR/reap.log"; }; }

# ============================================================================
hr; echo "SUBTEST 1 — PARK: a poisoned job is parked in plan/ (held), not dropped"; hr
place_stale boom
run_reaper
resync

plan_file="$V/jobs/plan/boom.md"
park_ok=1
[ -f "$plan_file" ] || { park_ok=0; echo "    plan/boom.md missing"; }
[ -f "$V/jobs/doin/boom.md" ] && { park_ok=0; echo "    doin/boom.md still present"; }
[ -f "$V/jobs/todo/boom.md" ] && { park_ok=0; echo "    boom leaked into todo/"; }
if [ -f "$plan_file" ]; then
  grep -q '^gate: go-ahead$'      "$plan_file" || { park_ok=0; echo "    gate is not go-ahead"; }
  grep -q '^poisoned: true$'      "$plan_file" || { park_ok=0; echo "    poisoned marker missing"; }
  grep -q '^poison_signature: requeue-exhausted$' "$plan_file" || { park_ok=0; echo "    signature wrong"; }
  grep -q 'the original work body for boom' "$plan_file" || { park_ok=0; echo "    original body not preserved"; }
fi
[ "$park_ok" -eq 1 ] \
  && ok "poisoned 'boom' parked in plan/ (gate=go-ahead, provenance + original body), gone from doin/, not in todo/" \
  || bad "park: plan=[$(ls "$V/jobs/plan" 2>/dev/null)] doin=[$(ls "$V/jobs/doin" 2>/dev/null)] todo=[$(ls "$V/jobs/todo" 2>/dev/null)]"

# The held gate must be invisible to the auto-promoters: plan_deferred_ranked
# (the foreman's picker) takes only `deferred`, so it must NOT list boom.
( set +u; source "$JOBS/common.sh" 2>/dev/null
  ranked="$(plan_deferred_ranked "$V" | tr '\n' ' ')"
  case " $ranked " in *" boom "*) exit 1;; *) exit 0;; esac )
[ $? -eq 0 ] \
  && ok "held poison plan is excluded from plan_deferred_ranked (foreman will not auto-promote it)" \
  || bad "held poison plan 'boom' appeared in the foreman's deferred pick list"

[ "$(count_unread)" -eq 1 ] \
  && ok "exactly one maintainer notice posted for the first poison" \
  || bad "expected 1 maintainer notice, found $(count_unread)"

# ============================================================================
hr; echo "SUBTEST 2 — DEDUP: re-poisoning the same job amends, not duplicates"; hr
# Simulate the job being re-claimed (a human promoted it, a gardener claimed and
# died again) by placing a fresh stale claim under the same base.
place_stale boom
run_reaper
resync

dedup_ok=1
nplan="$(ls -1 "$V/jobs/plan" | grep -v -x '.gitkeep' | grep -c 'boom' || true)"
[ "$nplan" -eq 1 ] || { dedup_ok=0; echo "    expected 1 plan entry for boom, found $nplan"; }
nunread="$(count_unread)"
[ "$nunread" -eq 1 ] || { dedup_ok=0; echo "    expected 1 maintainer notice, found $nunread"; }
notice="$V/inbox/maintainer/unread/poison-boom-requeue-exhausted.md"
if [ -f "$notice" ]; then
  grep -q '^notice_count: 2$' "$notice" || { dedup_ok=0; echo "    notice_count did not bump to 2"; }
  grep -qi 'occurrence #2' "$notice"    || { dedup_ok=0; echo "    amended body missing occurrence marker"; }
else
  dedup_ok=0; echo "    keyed notice file missing"
fi
[ "$dedup_ok" -eq 1 ] \
  && ok "second poison of the same job+condition: ONE plan entry, ONE notice amended to #2 (not two of each)" \
  || bad "dedup: plan=[$(ls "$V/jobs/plan" 2>/dev/null)] unread=[$(ls "$V/inbox/maintainer/unread" 2>/dev/null)]"

# ============================================================================
hr; echo "SUBTEST 3 — DIFFERENT: a materially different reason posts a new notice"; hr
# Same job, but now a DEADLINE-OVERRUN signature (handler hit its own wall-clock
# budget) — a materially different failure reason ⇒ a NEW keyed notice.
place_stale boom 2
run_reaper
resync

diff_ok=1
nunread="$(count_unread)"
[ "$nunread" -eq 2 ] || { diff_ok=0; echo "    expected 2 distinct notices, found $nunread"; }
[ -f "$V/inbox/maintainer/unread/poison-boom-requeue-exhausted.md" ] \
  || { diff_ok=0; echo "    original requeue-exhausted notice vanished"; }
overrun_notice="$V/inbox/maintainer/unread/poison-boom-deadline-overrun.md"
if [ -f "$overrun_notice" ]; then
  grep -q '^notice_count: 1$' "$overrun_notice" || { diff_ok=0; echo "    new overrun notice count != 1"; }
  grep -qi 'DEADLINE-OVERRUN' "$overrun_notice"  || { diff_ok=0; echo "    overrun notice missing signature wording"; }
else
  diff_ok=0; echo "    new deadline-overrun notice missing"
fi
grep -q '^poison_signature: deadline-overrun$' "$V/jobs/plan/boom.md" \
  || { diff_ok=0; echo "    plan entry not updated to the overrun signature"; }
[ "$diff_ok" -eq 1 ] \
  && ok "same job, different reason: a NEW keyed notice posted (2 total), plan updated in place" \
  || bad "different-reason: unread=[$(ls "$V/inbox/maintainer/unread" 2>/dev/null)]"

# ============================================================================
hr
echo "RESULTS: $PASS passed, $FAIL failed"
hr
[ "$FAIL" -eq 0 ]
