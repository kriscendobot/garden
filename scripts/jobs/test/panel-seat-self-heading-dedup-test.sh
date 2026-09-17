#!/bin/bash
# panel-seat-self-heading-dedup-test.sh — regression guard for the seat-heading
# de-duplication in the panel aggregate (scripts/jobs/gardening/panel.sh,
# strip_seat_self_heading + the per-seat aggregation loop).
#
# THE PROBLEM: the aggregate loop already prints each seat's name as its block
# heading (the `<summary>`). Many seats ALSO re-head their own generated block with
# `### <seat>`, often after throwaway meta-narration ("Now I have the block shape.
# I'll produce the assessor's per-juror block."), copying the `### <perspective
# name>` template artifact from skills/panel-review/SKILL.md literally. The result is
# a DOUBLED heading (and a useless preamble sentence) in the posted review.
#
# THE FIX: strip_seat_self_heading drops a seat-authored leading heading that
# duplicates the seat's own name — plus any preamble before it — before the aggregate
# wraps the block, so even when prompt compliance drifts the aggregate never shows
# the doubled heading.
#
# SUBTEST 1 — the seat-authored `### <seat>` heading and its meta-narration preamble
#             are gone from the aggregate; the seat name appears only in the
#             panel-authored `<summary>` (one occurrence per seat).
# SUBTEST 2 — the seat's real content (a unique finding line) still survives.
#
# Hermetic: the seat review, the decider, the appellate and the un-draft are
# env-stubbed, so NO real `claude -p` and NO network.
#
# The ok/bad idiom is the intended A && pass || fail (SC2015, safe: ok never fails).
# shellcheck disable=SC2015
set -uo pipefail
export GARDEN_TEST=1
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PANEL="$(cd "$HERE/../gardening" && pwd)/panel.sh"
TR="$(mktemp -d "${TMPDIR:-/tmp}/panel-selfhead.XXXXXX")"
PASS=0; FAIL=0
ok()  { echo "  PASS: $*"; PASS=$((PASS+1)); }
bad() { echo "  FAIL: $*"; FAIL=$((FAIL+1)); }
hr()  { echo "----------------------------------------------------------------"; }
trap 'rm -rf "$TR"' EXIT

STUB_SEAT="$HERE/panel-self-heading-stub.sh"   # each seat re-heads its own block
STUB_DECIDE="$HERE/panel-decide-stub.sh"       # prints `pass`

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
GARDEN_PANEL_SEAT_PROVENANCE=":" \
GARDEN_PANEL_RUNDIR="$TR/rd" \
  bash "$PANEL" "$TR/wt" 999 HEAD~1 >/dev/null 2>&1
rc=$?
AGG="$TR/rd/round-1.md"

hr; echo "SUBTEST 1 — the seat-authored heading + preamble are stripped"; hr
[ "$rc" -eq 0 ] && ok "panel exits 0" || bad "panel exited $rc"

# The panel-authored <summary> heading is present for each seat...
for s in $SEATS; do
  grep -q "<summary><b>$s</b>" "$AGG" \
    && ok "$s: panel-authored <summary> heading present" \
    || bad "$s: panel-authored <summary> heading missing"
done

# ...but NO seat-authored `### <seat>` heading survives.
if grep -Eq '^### (assessor|breaker|stylist)$' "$AGG"; then
  bad "a seat-authored '### <seat>' heading leaked into the aggregate: $(grep -E '^### ' "$AGG" | tr '\n' '|')"
else
  ok "no seat-authored '### <seat>' heading in the aggregate"
fi

# ...and the throwaway meta-narration preamble is gone too.
if grep -q "Now I have the block shape" "$AGG"; then
  bad "seat meta-narration preamble leaked into the aggregate"
else
  ok "seat meta-narration preamble stripped"
fi

hr; echo "SUBTEST 2 — the seat's real content survives the strip"; hr
for s in $SEATS; do
  grep -q "unique-finding-from-$s" "$AGG" \
    && ok "$s: real finding content survives" \
    || bad "$s: real finding content lost"
done

hr
echo "RESULT: $PASS passed, $FAIL failed"
[ "$FAIL" -eq 0 ]
