#!/bin/bash
# annotate-plan-test.sh — coverage for the parked-plan-job annotator
# (annotate-plan.sh).
#
# post-plan.sh is idempotent-only, so producers that learn something new about an
# already-parked job used to hand-roll a sync -> edit -> commit -> push CAS loop
# against the shared producer clone. annotate-plan.sh is that loop once,
# correctly; this suite pins the properties a hand-rolled append kept getting
# wrong:
#   1. APPEND    — the note lands on origin/journal2 with the frontmatter intact.
#   2. DEDUP     — an identical re-annotation is a no-op (a requeued producer
#                  must not double-append); a DIFFERENT note still appends.
#   3. FIELDS    — a priority/roadmap/role update rewrites the key in place (no
#                  duplicate line) and never drops the execution keys
#                  (role:/model:/handler-timeout:) a blind rewrite would eat.
#   4. LIFECYCLE — a job that has left plan/ is refused with rc 3, or skipped
#                  quietly under --if-parked.
#   5. GUARDS    — no-op invocations and the inline-body-string mistake fail fast
#                  rather than hanging on stdin holding the producer lock.
#   6. PROMOTE   — an annotated job still promotes to a clean todo body that
#                  carries the annotation and keeps its role:/model: pins.
#
# Hermetic: a throwaway bare journal2 origin stands in for the shared journal.
# No real journal and no network are touched.
#
# Usage: annotate-plan-test.sh
set -euo pipefail
export GARDEN_TEST=1
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
JOBS="$(cd "$HERE/.." && pwd)"
ANN="$JOBS/annotate-plan.sh"
BRANCH=journal2
PASS=0; FAIL=0
ok()  { echo "  PASS: $*"; PASS=$((PASS+1)); }
bad() { echo "  FAIL: $*"; FAIL=$((FAIL+1)); }
hr()  { echo "----------------------------------------------------------------"; }

# Hermetic baseline: a live gardener may invoke this test with the fleet's own
# GARDEN_*/JOURNAL_* exported (see run-test.sh). Scrub them so ONLY the throwaway
# fixture settings are authoritative.
unset $(compgen -v 2>/dev/null | grep -E '^(GARDEN_|JOURNAL_|SELF_HEAL_)' || true) 2>/dev/null || true
export GARDEN_TEST=1

TR="$(mktemp -d "${TMPDIR:-$HOME}/.garden-annotate-test.XXXXXX")"
BARE="$TR/origin.git"
git_id=(-c user.name=test -c user.email=test@localhost)
trap 'rm -rf "$TR"' EXIT

# --- seed the shared origin -------------------------------------------------
git init -q --bare "$BARE"
SEED="$TR/seed"; git init -q "$SEED"
git -C "$SEED" checkout -q -b "$BRANCH"
( cd "$SEED"
  mkdir -p jobs/todo jobs/doin jobs/tada jobs/plan
  for d in jobs/todo jobs/doin jobs/tada jobs/plan; do touch "$d/.gitkeep"; done )
git -C "$SEED" add -A
git -C "$SEED" "${git_id[@]}" commit -q -m "seed: board structure"
git -C "$SEED" remote add origin "$BARE"
git -C "$SEED" push -q -u origin "$BRANCH"

export JOURNAL_REMOTE="$BARE" JOURNAL_BRANCH="$BRANCH"
export GARDEN=testhost GARDEN_STATE="$TR/state" GARDEN_ROOT="$TR"
export GARDEN_POST_ATTEMPTS=20

# Run the annotator; fills $OUT/$RC. stdin is ALWAYS redirected explicitly so a
# case that means "no note" never blocks reading the suite's own stdin.
run_ann() {  # run_ann [args...]   ; note from $NOTE ("" means /dev/null stdin)
  set +e
  if [ -n "${NOTE:-}" ]; then OUT="$(bash "$ANN" "$@" <<<"$NOTE" 2>&1)"
  else                        OUT="$(bash "$ANN" "$@" </dev/null 2>&1)"; fi
  RC=$?
  set -e
}

plan_at_origin() { git -C "$BARE" show "$BRANCH:jobs/plan/$1.md" 2>/dev/null || true; }
todo_at_origin() { git -C "$BARE" show "$BRANCH:jobs/todo/$1.md" 2>/dev/null || true; }
countF() { grep -cF "$1" <<<"$2" || true; }   # occurrences of a fixed string

# ============================================================================
hr; echo "STATIC — the script parses (bash -n)"; hr
bash -n "$ANN" && ok "annotate-plan.sh parses" || bad "syntax error"

# ============================================================================
hr; echo "APPEND — a note reaches origin with the frontmatter intact"; hr
printf 'the original body line\n' > "$TR/body"
"$JOBS/post-plan.sh" --go-ahead --role designer --priority normal ann-a "$TR/body" >/dev/null

NOTE="follow-up: kriskowal asked for the simple:true variant too"
run_ann ann-a
[ "$RC" -eq 0 ] && ok "exit 0 appending a note" || bad "exit $RC appending: $OUT"
got="$(plan_at_origin ann-a)"
grep -qF "simple:true variant" <<<"$got" && ok "note reached origin/journal2" || bad "note not on origin: $got"
grep -qF "the original body line" <<<"$got" && ok "original body preserved" || bad "original body lost"
grep -q '^gate: go-ahead$' <<<"$got" && ok "gate: preserved" || bad "gate: lost"
grep -q '^role: designer$' <<<"$got" && ok "role: preserved" || bad "role: lost"
grep -qF "garden-annotation: key=" <<<"$got" && ok "annotation marker present" || bad "no annotation marker"
grep -qF "by=producer" <<<"$got" && ok "marker carries provenance" || bad "marker missing provenance"

# ============================================================================
hr; echo "DEDUP — an identical re-annotation is a no-op; a new note appends"; hr
run_ann ann-a
[ "$RC" -eq 0 ] && ok "identical re-annotation exits 0" || bad "re-annotation exit $RC: $OUT"
grep -qi "already carries annotation" <<<"$OUT" && ok "re-annotation reports the dedup" || bad "no dedup message: $OUT"
got="$(plan_at_origin ann-a)"
[ "$(countF "simple:true variant" "$got")" -eq 1 ] && ok "note appears exactly once" \
  || bad "note appended $(countF "simple:true variant" "$got")x (double-append)"

NOTE="second follow-up: also pin the shim's error shape"
run_ann ann-a
[ "$RC" -eq 0 ] && ok "a different note exits 0" || bad "second note exit $RC: $OUT"
got="$(plan_at_origin ann-a)"
{ grep -qF "simple:true variant" <<<"$got" && grep -qF "error shape" <<<"$got"; } \
  && ok "both annotations present" || bad "second annotation did not accumulate"
[ "$(countF "garden-annotation: key=" "$got")" -eq 2 ] && ok "two annotation markers" \
  || bad "$(countF "garden-annotation: key=" "$got") markers (want 2)"

# an EXPLICIT key re-appends the same text deliberately:
NOTE="second follow-up: also pin the shim's error shape"
run_ann --key r3548823737 ann-a
[ "$RC" -eq 0 ] && ok "explicit --key re-appends the same text" || bad "explicit key exit $RC: $OUT"
grep -qF "garden-annotation: key=r3548823737 " <<<"$(plan_at_origin ann-a)" \
  && ok "explicit key recorded in the marker" || bad "explicit key missing from marker"
# ...and is itself deduped on a re-run:
run_ann --key r3548823737 ann-a
[ "$(countF "key=r3548823737 " "$(plan_at_origin ann-a)")" -eq 1 ] \
  && ok "explicit key is idempotent on re-run" || bad "explicit key double-appended"

# ============================================================================
hr; echo "FIELDS — in-place update, no duplicate keys, execution keys kept"; hr
{ printf -- '---\ngate: deferred\npriority: low\nrole: builder\nmodel: opus\n'
  printf 'handler-timeout: 10800\nposted_by: gardener\n---\n\nbuild the thing\n'; } > "$TR/rich.md"
# park it by hand-seeding plan/ (post-plan owns the frontmatter it writes)
SEEDW="$TR/seedw"; git clone -q --single-branch --branch "$BRANCH" "$BARE" "$SEEDW"
cp "$TR/rich.md" "$SEEDW/jobs/plan/ann-b.md"
git -C "$SEEDW" add jobs/plan/ann-b.md
git -C "$SEEDW" "${git_id[@]}" commit -q -m "seed ann-b"
git -C "$SEEDW" push -q origin "HEAD:$BRANCH"

NOTE="scope narrowed to the sqlite path"
run_ann --priority urgent --roadmap endor-m3 ann-b
[ "$RC" -eq 0 ] && ok "exit 0 updating fields" || bad "field update exit $RC: $OUT"
got="$(plan_at_origin ann-b)"
grep -q '^priority: urgent$' <<<"$got" && ok "priority updated in place" || bad "priority not updated"
[ "$(grep -c '^priority:' <<<"$got")" -eq 1 ] && ok "no duplicate priority line" \
  || bad "$(grep -c '^priority:' <<<"$got") priority lines"
grep -q '^roadmap: endor-m3$' <<<"$got" && ok "missing roadmap key inserted" || bad "roadmap not inserted"
grep -q '^model: opus$' <<<"$got" && ok "model: preserved" || bad "model: dropped"
grep -q '^handler-timeout: 10800$' <<<"$got" && ok "handler-timeout: preserved" || bad "handler-timeout: dropped"
grep -q '^gate: deferred$' <<<"$got" && ok "gate: preserved" || bad "gate: dropped"
[ "$(grep -c -x -- '---' <<<"$got")" -eq 2 ] && ok "frontmatter still a single well-formed block" \
  || bad "$(grep -c -x -- '---' <<<"$got") '---' lines (want 2)"
grep -qF "fields=priority=urgent roadmap=endor-m3" <<<"$got" \
  && ok "marker records the metadata change" || bad "marker missing fields summary"

# a metadata-only annotation (no note at all) is legal:
run_ann --priority high ann-b
[ "$RC" -eq 0 ] && ok "metadata-only annotation exits 0" || bad "metadata-only exit $RC: $OUT"
grep -q '^priority: high$' <<<"$(plan_at_origin ann-b)" && ok "metadata-only update landed" || bad "metadata-only did not land"

# ============================================================================
hr; echo "LIFECYCLE — a job past plan/ is refused (rc 3) or skipped"; hr
"$JOBS/promote-plan.sh" ann-b >/dev/null
NOTE="too late"
run_ann ann-b
[ "$RC" -eq 3 ] && ok "annotating a promoted job exits 3" || bad "promoted-job exit $RC (want 3): $OUT"
grep -qi "no longer parked" <<<"$OUT" && ok "names the lifecycle refusal" || bad "no lifecycle message: $OUT"
grep -qF "too late" <<<"$(todo_at_origin ann-b)" && bad "the note leaked into the todo job" || ok "nothing leaked into todo/"

run_ann --if-parked ann-b
[ "$RC" -eq 0 ] && ok "--if-parked skips a promoted job with exit 0" || bad "--if-parked exit $RC: $OUT"
grep -qi "skipping annotation" <<<"$OUT" && ok "--if-parked says it skipped" || bad "--if-parked message missing: $OUT"

NOTE="nowhere"
run_ann ann-nonexistent
[ "$RC" -eq 3 ] && ok "an unknown basename exits 3" || bad "unknown base exit $RC (want 3): $OUT"
run_ann --if-parked ann-nonexistent
[ "$RC" -eq 0 ] && ok "--if-parked tolerates an unknown basename" || bad "--if-parked unknown base exit $RC"

# ============================================================================
hr; echo "GUARDS — empty annotation and the inline-body mistake fail fast"; hr
NOTE=""
run_ann ann-a
[ "$RC" -eq 1 ] && ok "no note and no fields exits 1" || bad "empty annotation exit $RC (want 1): $OUT"
grep -qi "nothing to annotate" <<<"$OUT" && ok "names the empty-annotation refusal" || bad "no empty message: $OUT"

run_ann ann-a "an inline body string, not a path"
[ "$RC" -eq 1 ] && ok "an inline body STRING exits 1 (no stdin hang)" || bad "inline body exit $RC: $OUT"
grep -qi "not a readable file" <<<"$OUT" && ok "names the body-source refusal" || bad "no body-source message: $OUT"

run_ann --note "inline" ann-a "$TR/body"
[ "$RC" -eq 1 ] && ok "--note plus a body-file exits 1" || bad "--note+file exit $RC: $OUT"

run_ann --note "x" -- -dashy
[ "$RC" -eq 1 ] && ok "a basename starting with '-' is refused" || bad "dashy basename exit $RC: $OUT"

run_ann --priority nope ann-a
[ "$RC" -eq 1 ] && ok "an illegal --priority is refused" || bad "bad priority exit $RC: $OUT"

# ============================================================================
hr; echo "PROMOTE — an annotated job promotes to a clean todo body"; hr
NOTE="the annotation the gardener must read"
run_ann ann-a
"$JOBS/promote-plan.sh" ann-a >/dev/null
got="$(todo_at_origin ann-a)"
grep -qF "the annotation the gardener must read" <<<"$got" \
  && ok "the annotation survives promotion into the work body" || bad "annotation lost on promotion: $got"
grep -q '^role: designer$' <<<"$got" && ok "role: pin survives promotion" || bad "role: pin lost on promotion"
grep -q '^gate:' <<<"$got" && bad "plan gate leaked into the todo body" || ok "plan frontmatter stripped as usual"

# ============================================================================
hr
echo "RESULTS: $PASS passed, $FAIL failed"
[ "$FAIL" -eq 0 ]
