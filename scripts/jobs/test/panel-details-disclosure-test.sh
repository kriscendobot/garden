#!/bin/bash
# panel-details-disclosure-test.sh — regression guard for the <details> disclosure
# wrapping of the panel aggregate (scripts/jobs/gardening/panel.sh, the per-seat
# aggregation loop + seat_verdict_label).
#
# THE PROBLEM: the code panel's aggregate runs many hundreds of lines across ~31
# seats. Posted as one undifferentiated block it is unscannable — a reviewer cannot
# see each seat's stance without reading the whole wall of prose.
#
# THE FIX: each seat's full block (its verdict, findings, and per-seat provenance
# footnote) is wrapped in a `<details>` whose `<summary>` carries the seat name and
# its verdict, so the collapsed view is scannable and the detail is one click away.
#
# SUBTEST 1 — every seat block is wrapped in exactly one <details> disclosure, and
#             the <summary> carries the seat name AND its own (normalized) verdict.
# SUBTEST 2 — GitHub's rendering contract: a BLANK LINE follows every </summary>
#             (without it the Markdown body shows as literal text).
# SUBTEST 3 — the per-seat provenance footnote stays INSIDE the seat's collapsed
#             block (between <summary> and </details>), never hoisted out.
#
# Hermetic: the seat review, the disposition decider, the appellate and the un-draft
# are env-stubbed, so NO real `claude -p` and NO network.
#
# The ok/bad idiom is the intended A && pass || fail (SC2015, safe: ok never fails).
# shellcheck disable=SC2015
set -uo pipefail
export GARDEN_TEST=1
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PANEL="$(cd "$HERE/../gardening" && pwd)/panel.sh"
TR="$(mktemp -d "${TMPDIR:-/tmp}/panel-details.XXXXXX")"
PASS=0; FAIL=0
ok()  { echo "  PASS: $*"; PASS=$((PASS+1)); }
bad() { echo "  FAIL: $*"; FAIL=$((FAIL+1)); }
hr()  { echo "----------------------------------------------------------------"; }
trap 'rm -rf "$TR"' EXIT

STUB_SEAT="$HERE/panel-details-verdict-stub.sh"      # per-seat verdict blocks
STUB_DECIDE="$HERE/panel-decide-stub.sh"             # prints `pass`
STUB_PROV="$HERE/panel-per-section-provenance-stub.sh"

# assessor → request-changes, breaker → comment only (space form), stylist → approve.
SEATS="assessor breaker stylist"
mkdir -p "$TR/wt"   # non-git worktree → code panel

FAN_DIR="$TR/fan" FAN_SLEEP=0 \
GARDEN_CODE_SEATS="$SEATS" \
GARDEN_PANEL_CONCURRENCY=3 \
GARDEN_PANEL_SEAT="$STUB_SEAT" \
GARDEN_PANEL_DECIDE="$STUB_DECIDE" \
GARDEN_PANEL_APPELLATE=":" \
GARDEN_PANEL_UNDRAFT="true" \
GARDEN_PANEL_SEAT_ATTEMPTS=1 \
GARDEN_PANEL_SEAT_BACKOFF=0 \
GARDEN_PANEL_SEAT_PROVENANCE="$STUB_PROV" \
GARDEN_PANEL_RUNDIR="$TR/rd" \
  bash "$PANEL" "$TR/wt" 999 HEAD~1 >/dev/null 2>&1
rc=$?
AGG="$TR/rd/round-1.md"
hr; echo "SUBTEST 1 — each seat wrapped in a <details> with a verdict-bearing <summary>"; hr
[ "$rc" -eq 0 ] && ok "panel exits 0" || bad "panel exited $rc"

nopen="$(grep -c '^<details>' "$AGG" 2>/dev/null || true)"
nclose="$(grep -c '^</details>' "$AGG" 2>/dev/null || true)"
{ [ "$nopen" = 3 ] && [ "$nclose" = 3 ]; } \
  && ok "3 seats → 3 balanced <details> blocks" \
  || bad "unbalanced disclosures: $nopen open, $nclose close (expected 3/3)"

grep -q '<summary><b>assessor</b> — request-changes</summary>' "$AGG" \
  && ok "assessor summary carries its request-changes verdict" \
  || bad "assessor summary missing/wrong: $(grep '<summary><b>assessor</b>' "$AGG")"
# `Verdict: comment only` (space form) must normalize to the hyphenated token.
grep -q '<summary><b>breaker</b> — comment-only</summary>' "$AGG" \
  && ok "breaker summary normalizes 'comment only' → comment-only" \
  || bad "breaker summary missing/wrong: $(grep '<summary><b>breaker</b>' "$AGG")"
grep -q '<summary><b>stylist</b> — approve</summary>' "$AGG" \
  && ok "stylist summary carries its approve verdict" \
  || bad "stylist summary missing/wrong: $(grep '<summary><b>stylist</b>' "$AGG")"

# The seat's own block content still reached the aggregate, inside the disclosure.
grep -q 'none of note from assessor' "$AGG" \
  && ok "seat block content survives the wrapping" \
  || bad "seat block content lost from the aggregate"

hr; echo "SUBTEST 2 — a blank line follows every </summary> (GitHub render contract)"; hr
if awk '/<\/summary>/{ getline nxt; if (nxt != "") { found=1 } } END { exit(found?1:0) }' "$AGG"; then
  ok "every </summary> is followed by a blank line (Markdown renders)"
else
  bad "a </summary> is NOT followed by a blank line — body would render as literal text"
fi

hr; echo "SUBTEST 3 — the per-seat provenance footnote stays inside the disclosure"; hr
# For each seat, the footnote (section marker) must appear between its <summary> and
# the next </details>. Extract the assessor block and check containment.
SECTION_MARKER="garden-provenance-section"
assessor_block="$(awk '/<summary><b>assessor<\/b>/{c=1} c{print} /<\/details>/{if(c)exit}' "$AGG")"
printf '%s' "$assessor_block" | grep -q "$SECTION_MARKER" \
  && ok "assessor's provenance footnote is inside its collapsed <details>" \
  || bad "assessor's provenance footnote is NOT inside its disclosure block"
# And no footnote leaks OUTSIDE any details (a marker on a line that is not within a
# details block). Count markers vs markers-inside-details; they must be equal.
total_markers="$(grep -c "$SECTION_MARKER" "$AGG" 2>/dev/null || true)"
inside_markers="$(awk -v m="$SECTION_MARKER" '
  /^<details>/{d=1} /^<\/details>/{d=0}
  d && $0 ~ m {n++}
  END{print n+0}' "$AGG")"
{ [ "$total_markers" = 3 ] && [ "$inside_markers" = 3 ]; } \
  && ok "all 3 provenance footnotes are inside a disclosure (none hoisted out)" \
  || bad "footnote containment wrong: $total_markers total, $inside_markers inside (expected 3/3)"

hr
echo "RESULT: $PASS passed, $FAIL failed"
[ "$FAIL" -eq 0 ]
