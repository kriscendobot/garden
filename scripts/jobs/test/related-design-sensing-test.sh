#!/bin/bash
# related-design-sensing-test.sh — RE-LITIGATION of the stale-related-design-direction
# review-miss (review-misses/clusters/stale-related-design-direction.md; member
# kriscendobot/minion.town#48) against the real PR 47/48 timestamps and relationship.
#
# The historical failure: PR 47's maintainer changes-requested review was submitted at
# 2026-08-17T23:22:53Z, BEFORE PR 48's first commit at 2026-08-18T00:38:55Z; all four
# PR 48 panel rounds came later. The build asserted its serving slice was "independent"
# of PR 47 based only on a design document, and four code panels reviewed local
# correctness while never re-checking PR 47's live direction. The maintainer closed PR
# 48 for reconstruction.
#
# This test demonstrates the two new deterministic checks against that exact history:
#
#   BUILD-TIME (prevention): related-design-state.sh, run at build preparation over
#   PR 48's declared related set {47}, returns `attention` (exit 10) — the build cannot
#   declare independence; it reconciles or redirects. It fires even though PR 47's
#   direction PREDATES PR 48's first commit (newer_than_impl=no), the case a naive
#   "is the direction newer than my head?" test would have missed.
#
#   PANEL-TIME (durable sensing): panel.sh's related-design pre-pass rediscovers {47}
#   from PR 48's own body marker, forces the integrator lens, and hands it the live
#   evidence — so no later panel round can silently clear the dependency question.
#
#   NEGATIVE CONTROL: a SATISFIED related design (PR 50, changes-requested later
#   approved) and an UNRELATED changes-requested design (PR 99, never declared) do NOT
#   block the build or force the panel.
#
# Hermetic: a committed GARDEN_GH stub (related-design-gh-stub.sh), throwaway git repos,
# no network, no systemd, no `claude`.

# shellcheck disable=SC2015  # the ok/bad idiom is the intended A && pass || fail
set -uo pipefail
export GARDEN_TEST=1
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
GARDENING="$(cd "$HERE/../gardening" && pwd)"
HELPER="$GARDENING/related-design-state.sh"
PANEL="$GARDENING/panel.sh"
GH_STUB="$HERE/related-design-gh-stub.sh"
SEAT_STUB="$HERE/related-design-panel-seat-stub.sh"
DECIDE_STUB="$HERE/related-design-panel-decide-stub.sh"
REPO="kriscendobot/minion.town"
PR48_FIRST_COMMIT="2026-08-18T00:38:55Z"
PR47_REVIEW_AT="2026-08-17T23:22:53Z"

TR="$(mktemp -d "${TMPDIR:-/tmp}/rds-test.XXXXXX")"
PASS=0; FAIL=0
ok()  { echo "  PASS: $*"; PASS=$((PASS+1)); }
bad() { echo "  FAIL: $*"; FAIL=$((FAIL+1)); }
trap 'rm -rf "$TR"' EXIT

chmod +x "$GH_STUB" "$SEAT_STUB" "$DECIDE_STUB" 2>/dev/null || true
export GARDEN_GH="$GH_STUB"

# run_helper <expected-exit> <label> -- args...; captures stdout into $OUT.
OUT=""
run_helper() {
  local want="$1" label="$2"; shift 2
  local rc=0
  OUT="$(bash "$HELPER" "$REPO" "$@" 2>/dev/null)" || rc=$?
  if [ "$rc" = "$want" ]; then ok "$label (exit $rc)"; else bad "$label (exit $rc, wanted $want)"; fi
}

echo "== (A) BUILD-TIME check — the exact query that would have stopped/redirected PR 48 =="

# A1: PR 48's declared related set {47}, impl-ref = PR 48's first commit. ATTENTION.
run_helper 10 "A1 declared related PR 47 with outstanding direction -> attention" \
  --related 47 --impl-ref "$PR48_FIRST_COMMIT"
printf '%s\n' "$OUT" | grep -q 'related-design-verdict=attention' \
  && ok "A1 verdict=attention" || bad "A1 verdict line"
printf '%s\n' "$OUT" | grep -q "related-design pr=47 .*relation=outstanding" \
  && ok "A1 PR 47 classified outstanding" || bad "A1 PR 47 outstanding"
printf '%s\n' "$OUT" | grep -q "changes_requested_at=$PR47_REVIEW_AT" \
  && ok "A1 records PR 47 review timestamp $PR47_REVIEW_AT" || bad "A1 review timestamp"
# The fire does NOT depend on the direction being newer than the implementation:
printf '%s\n' "$OUT" | grep -q "newer_than_impl=no" \
  && ok "A1 fires despite direction PREDATING impl (newer_than_impl=no)" || bad "A1 newer_than_impl=no"

echo "== (B) PANEL-TIME check — rediscovery from PR 48's own body marker =="

# B1: the query panel.sh's pre-pass runs — discover {47} from PR 48's body marker.
run_helper 10 "B1 discover related PR 47 via PR 48 body marker -> attention" \
  --self 48 --impl-ref "$PR48_FIRST_COMMIT"
printf '%s\n' "$OUT" | grep -q "related-design pr=47 .*relation=outstanding" \
  && ok "B1 marker discovery reaches PR 47" || bad "B1 marker discovery"

echo "== (C) NEGATIVE CONTROL — satisfied / unrelated designs do NOT block =="

# C1: a SATISFIED related design (PR 50, changes-requested later approved). CLEAR.
run_helper 0 "C1 declared-but-satisfied PR 50 -> clear" \
  --related 50 --impl-ref "$PR48_FIRST_COMMIT"
printf '%s\n' "$OUT" | grep -q 'related-design-verdict=clear' \
  && ok "C1 verdict=clear" || bad "C1 verdict=clear"

# C2: an UNRELATED changes-requested design (PR 99) that no implementation declares is
# never fetched and never blocks — here the build declares only the satisfied PR 50.
run_helper 0 "C2 undeclared unrelated PR 99 -> clear (only satisfied PR 50 declared)" \
  --self 61 --impl-ref "$PR48_FIRST_COMMIT"
printf '%s\n' "$OUT" | grep -q 'pr=99' \
  && bad "C2 must NOT fetch undeclared PR 99" || ok "C2 undeclared PR 99 never fetched"

# C3: an implementation that declares NO related design (no marker). CLEAR, no fetch.
run_helper 0 "C3 no related-design declaration -> clear" \
  --self 60 --impl-ref "$PR48_FIRST_COMMIT"

echo "== (D) PANEL.SH end-to-end — the pre-pass forces the integrator lens =="

# A throwaway git worktree standing in for PR 48's checkout: base + head commits, a
# code-panel diff, and an origin so panel.sh derives the repo slug.
WT="$TR/wt"
mkdir -p "$WT"
(
  cd "$WT" || exit 1
  git init -q
  git config user.email t@t; git config user.name t
  git remote add origin "https://github.com/$REPO.git"
  echo base > serve.js; git add serve.js; git commit -qm base
  echo head >> serve.js; git add serve.js; git commit -qm 'feat: serving slice'
)

run_panel() {  # run_panel <self-pr> <rundir> <seatlog|-> <code-seats>
  local self="$1" rundir="$2" seatlog="$3" seats="$4"
  GARDEN_PANEL_SINGLE_ROUND=1 \
  GARDEN_PANEL_SEAT="$SEAT_STUB" \
  GARDEN_PANEL_DECIDE="$DECIDE_STUB" \
  GARDEN_PANEL_APPELLATE=: \
  GARDEN_PANEL_RECORD=: \
  GARDEN_PANEL_RUNDIR="$rundir" \
  GARDEN_CODE_SEATS="$seats" \
  GARDEN_RD_SEAT_LOG="$seatlog" \
  GARDEN_GH="$GH_STUB" \
  bash "$PANEL" "$WT" "$self" HEAD~1 >/dev/null 2>&1
}

# D1 — ATTENTION: PR 48 (declares related PR 47). GARDEN_CODE_SEATS deliberately OMITS
# integrator, proving the pre-pass FORCES it in and delivers the evidence.
RUNDIR_A="$TR/run-attention"; SEATLOG_A="$TR/seatlog-attention"
run_panel 48 "$RUNDIR_A" "$SEATLOG_A" "assessor"
rc=$?
[ "$rc" = 0 ] && ok "D1 panel single-round completed (exit 0)" || bad "D1 panel exit $rc"
grep -q 'related-design-verdict=attention' "$RUNDIR_A/related-design.md" 2>/dev/null \
  && ok "D1 pre-pass wrote attention evidence to the run dir" || bad "D1 run-dir evidence"
grep -q 'related-design pr=47' "$RUNDIR_A/related-design.md" 2>/dev/null \
  && ok "D1 evidence names related PR 47" || bad "D1 evidence names PR 47"
if [ -f "$SEATLOG_A" ]; then
  ok "D1 integrator was FORCED into the panel despite trimmed seat list"
  grep -q 'integrator-saw-evidence=1' "$SEATLOG_A" \
    && ok "D1 integrator received the related-design evidence" || bad "D1 integrator evidence delivery"
  grep -q 'verdict=attention' "$SEATLOG_A" \
    && ok "D1 evidence handed to integrator carries verdict=attention" || bad "D1 integrator verdict"
else
  bad "D1 integrator was not dispatched (seat log absent)"
fi

# D2 — CLEAR negative control: PR 60 declares no related design. The pre-pass stays
# quiet: it does NOT force the integrator and delivers no evidence; the panel proceeds.
RUNDIR_B="$TR/run-clear"; SEATLOG_B="$TR/seatlog-clear"
run_panel 60 "$RUNDIR_B" "$SEATLOG_B" "assessor"
rc=$?
[ "$rc" = 0 ] && ok "D2 panel single-round completed (exit 0)" || bad "D2 panel exit $rc"
grep -q 'related-design-verdict=clear' "$RUNDIR_B/related-design.md" 2>/dev/null \
  && ok "D2 pre-pass recorded clear" || bad "D2 clear evidence"
[ ! -f "$SEATLOG_B" ] \
  && ok "D2 integrator NOT force-added on a clear pre-pass (no silent block)" \
  || bad "D2 integrator wrongly forced on clear"

echo
echo "related-design-sensing-test: $PASS passed, $FAIL failed"
[ "$FAIL" -eq 0 ]
