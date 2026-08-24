#!/bin/bash
# journal-entry-dedup-test.sh — coverage for journal-entry.sh's duplicate
# suppression.
#
# Regression for the 2026-07-28 double-post: an agent that invoked the script
# twice for the SAME report wrote two permanent entries into the append-only
# journal (entries/2026/07/28/071837Z-result-botanist-e4bedc.md and
# 071905Z-result-botanist-71442a.md — byte-identical results for the same PR from
# the same host, 38s apart). Every downstream consumer that scans new entries (the
# bulletin, the journalist, the mentor tick) then counted the report twice, and no
# role-prompt discipline makes an agent reliably remember it already posted. The
# script must therefore refuse the re-post itself: within the suppression window,
# an identical kind+role+host entry whose BODY is byte-identical (frontmatter, and
# so the differing `at:` stamp, excluded) means log `duplicate of <path>, not
# posting` and exit 0 having written nothing.
#
# Also asserts the escape hatches (--allow-duplicate, GARDEN_ENTRY_DUP_WINDOW=0,
# window expiry) and the negative cases that must STILL post (different body,
# kind, role, or host), plus the origin-ref discipline: only an entry that
# actually LANDED may suppress, never an untracked leftover in the producer clone.
#
# Hermetic: a throwaway bare journal origin stands in for the shared journal. No
# real journal and no network are touched.
#
# Usage: journal-entry-dedup-test.sh
set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
JOBS="$(cd "$HERE/.." && pwd)"
ENTRY="$JOBS/journal-entry.sh"
PASS=0; FAIL=0
ok()  { echo "  PASS: $*"; PASS=$((PASS+1)); }
bad() { echo "  FAIL: $*"; FAIL=$((FAIL+1)); }
hr()  { echo "----------------------------------------------------------------"; }

# Scrub ambient fleet env so a live gardener invoking this test cannot splice its
# own GARDEN_*/JOURNAL_* state underneath the fixture (mirrors the sibling tests).
unset $(compgen -v 2>/dev/null | grep -E '^(GARDEN_|JOURNAL_|SELF_HEAL_|XDG_)' || true) 2>/dev/null || true
export GARDEN_TEST=1

TR=/home/kris/.garden-jentry-dedup-test
BARE="$TR/origin.git"
STATE="$TR/state"
CLONE="$STATE/producer/journal"
git_id=(-c user.name=test -c user.email=test@localhost)

setup_fixture() {
  rm -rf "$TR"; mkdir -p "$TR"
  git init -q --bare "$BARE"
  local SEED="$TR/seed"; git init -q "$SEED"
  git -C "$SEED" checkout -q -b journal2
  mkdir -p "$SEED/entries"; touch "$SEED/entries/.gitkeep"
  git -C "$SEED" add -A
  git -C "$SEED" "${git_id[@]}" commit -q -m "seed journal2 fixture"
  git -C "$SEED" remote add origin "$BARE"
  git -C "$SEED" push -q -u origin journal2
}

# Run journal-entry.sh against the fixture; fills $OUT, $RC. Body from $BODY (a
# here-string, so the function runs in THIS shell and $OUT/$RC survive). Per-case
# knobs: $ROLE, $HOST, $WINDOW.
run_entry() {  # run_entry [args...]
  set +e
  OUT="$(env JOURNAL_REMOTE="$BARE" JOURNAL_BRANCH=journal2 \
             GARDEN_STATE="$STATE" GARDEN_ROOT="$TR" \
             GARDEN_PRODUCER_CLONE="$CLONE" \
             GARDEN="${HOST:-testhost}" GARDEN_ROLE="${ROLE:-botanist}" \
             GARDEN_ENTRY_DUP_WINDOW="${WINDOW:-900}" \
             GARDEN_TEST=1 GARDEN_NO_MAINTAINER_ALERT=1 \
             bash "$ENTRY" "$@" <<<"$BODY" 2>&1)"
  RC=$?
  set -e
}

# Run with the role environment shaped exactly as an agent sees it. A dash means
# the variable is absent, which distinguishes claimed-job attribution from an
# explicit per-invocation override and from the no-job fallback.
run_entry_with_roles() {  # run_entry_with_roles <explicit-or-> <claimed-or-> [args...]
  local explicit="$1" claimed="$2"; shift 2
  local -a role_env=()
  [ "$explicit" = - ] || role_env+=(GARDEN_ROLE="$explicit")
  [ "$claimed" = - ] || role_env+=(GARDEN_JOB_ROLE="$claimed")
  set +e
  OUT="$(env JOURNAL_REMOTE="$BARE" JOURNAL_BRANCH=journal2 \
             GARDEN_STATE="$STATE" GARDEN_ROOT="$TR" \
             GARDEN_PRODUCER_CLONE="$CLONE" GARDEN=testhost \
             GARDEN_ENTRY_DUP_WINDOW=900 GARDEN_TEST=1 \
             GARDEN_NO_MAINTAINER_ALERT=1 "${role_env[@]}" \
             bash "$ENTRY" "$@" <<<"$BODY" 2>&1)"
  RC=$?
  set -e
}

# Entries of a given kind at the origin tip (the serialization point: only what
# actually landed counts).
count_kind() { git -C "$BARE" ls-tree -r --name-only journal2 -- entries 2>/dev/null | grep -cE "Z-$1-" || true; }
count_all()  { git -C "$BARE" ls-tree -r --name-only journal2 -- entries 2>/dev/null | grep -cE 'Z-.*\.md$' || true; }
origin_head() { git -C "$BARE" rev-parse journal2; }

REPORT="$(printf '%s\n' '# botanist result' '' 'endojs/endo-but-for-bots#269: dependency bump reviewed, no action needed.')"

# ============================================================================
hr; echo "STATIC — the script parses (bash -n)"; hr
bash -n "$ENTRY" && ok "journal-entry.sh parses" || bad "syntax error"

# ============================================================================
hr; echo "ROLE — explicit override, claimed-job role, gardener fallback"; hr
setup_fixture
BODY="role attribution probe"
run_entry_with_roles - scholar progress
CLAIMED="$(git -C "$BARE" ls-tree -r --name-only journal2 -- entries | grep -E 'Z-progress-scholar-')"
[ "$RC" -eq 0 ] && [ -n "$CLAIMED" ] \
  && ok "GARDEN_JOB_ROLE supplies the claimed job's role" \
  || bad "claimed-job role was not attributed to scholar (rc=$RC, path=$CLAIMED): $OUT"

BODY="explicit override probe"
run_entry_with_roles botanist scholar progress
OVERRIDE="$(git -C "$BARE" ls-tree -r --name-only journal2 -- entries | grep -E 'Z-progress-botanist-')"
[ "$RC" -eq 0 ] && [ -n "$OVERRIDE" ] \
  && ok "GARDEN_ROLE overrides the claimed-job role" \
  || bad "explicit role did not override claimed role (rc=$RC, path=$OVERRIDE): $OUT"

BODY="fallback probe"
run_entry_with_roles - - progress
FALLBACK="$(git -C "$BARE" ls-tree -r --name-only journal2 -- entries | grep -E 'Z-progress-gardener-')"
[ "$RC" -eq 0 ] && [ -n "$FALLBACK" ] \
  && ok "callers outside a claimed job still fall back to gardener" \
  || bad "no-context caller did not fall back to gardener (rc=$RC, path=$FALLBACK): $OUT"

# Equivalent reports must share attribution no matter whether the scholar role
# was supplied explicitly (the old obligation) or inherited from the claim. If
# those paths disagree, duplicate suppression cannot recognize the second post.
setup_fixture
BODY="$REPORT"
run_entry_with_roles scholar - result
[ "$RC" -eq 0 ] && [ "$(count_kind result)" -eq 1 ] \
  || bad "explicit scholar fixture result did not land: $OUT"
ROLE_HEAD="$(origin_head)"
run_entry_with_roles - scholar result
[ "$RC" -eq 0 ] && [ "$(count_kind result)" -eq 1 ] && [ "$(origin_head)" = "$ROLE_HEAD" ] \
  && ok "explicit and claimed scholar attribution deduplicate as equivalent reports" \
  || bad "equivalent explicit/claimed scholar reports did not deduplicate: $OUT"

# ============================================================================
hr; echo "SUPPRESS — a second invocation with the same report posts nothing"; hr
setup_fixture
BODY="$REPORT"
run_entry result
[ "$RC" -eq 0 ] && ok "first post exits 0" || bad "first post exit $RC: $OUT"
[ "$(count_kind result)" -eq 1 ] && ok "the first result landed" || bad "first result did not land"
FIRST="$(git -C "$BARE" ls-tree -r --name-only journal2 -- entries | grep -E 'Z-result-' | head -1)"
H0="$(origin_head)"
# The re-post is a SEPARATE invocation seconds later: same body, later `at:`
# stamp and a fresh random id — exactly the shape of the 071837Z/071905Z pair.
run_entry result
[ "$RC" -eq 0 ] && ok "the duplicate exits 0 (a re-post is not an error)" || bad "duplicate exit $RC: $OUT"
grep -qF "duplicate of $FIRST, not posting" <<<"$OUT" \
  && ok "logs 'duplicate of <path>, not posting' naming the landed entry" \
  || bad "no 'duplicate of $FIRST, not posting' line: $OUT"
[ "$(count_kind result)" -eq 1 ] && ok "no second copy landed" || bad "a duplicate entry landed ($(count_kind result) results)"
[ "$(origin_head)" = "$H0" ] && ok "origin head unchanged by the duplicate" || bad "the duplicate advanced the journal head"

# The same body delivered by body-FILE (the other producer path) dedups too.
bf="$TR/body.md"; printf '%s\n' "$REPORT" > "$bf"
BODY=""
run_entry result "$bf"
[ "$RC" -eq 0 ] && ok "body-file duplicate exits 0" || bad "body-file duplicate exit $RC: $OUT"
[ "$(count_kind result)" -eq 1 ] && ok "body-file duplicate landed nothing" || bad "body-file duplicate landed a copy"

# ============================================================================
hr; echo "POST — anything that is not the same report still lands"; hr
BODY="$(printf '%s\n' "$REPORT" 'plus a second paragraph.')"
run_entry result
[ "$RC" -eq 0 ] && [ "$(count_kind result)" -eq 2 ] && ok "a DIFFERENT body posts" || bad "different body was suppressed: $OUT"
BODY="$REPORT"
run_entry progress
[ "$(count_kind progress)" -eq 1 ] && ok "the same body under a different KIND posts" || bad "different kind was suppressed: $OUT"
ROLE=gardener run_entry result
[ "$(count_kind result)" -eq 3 ] && ok "the same body under a different ROLE posts" || bad "different role was suppressed: $OUT"
HOST=otherhost run_entry result
[ "$(count_kind result)" -eq 4 ] && ok "the same body from a different HOST posts" || bad "different host was suppressed: $OUT"
# ...and the original (kind=result, role=botanist, host=testhost) is still held.
run_entry result
[ "$(count_kind result)" -eq 4 ] && ok "the original re-post is still suppressed" || bad "suppression broke after the negatives"

# ============================================================================
hr; echo "ESCAPE HATCHES — --allow-duplicate, window=0, window expiry"; hr
setup_fixture
BODY="$REPORT"
run_entry result
[ "$(count_kind result)" -eq 1 ] || bad "fixture post did not land"
run_entry --allow-duplicate result
[ "$(count_kind result)" -eq 2 ] && ok "--allow-duplicate posts the identical entry" || bad "--allow-duplicate was suppressed: $OUT"
run_entry result --allow-duplicate
[ "$(count_kind result)" -eq 3 ] && ok "--allow-duplicate works after the kind too" || bad "trailing --allow-duplicate was suppressed: $OUT"
WINDOW=0 run_entry result
[ "$(count_kind result)" -eq 4 ] && ok "GARDEN_ENTRY_DUP_WINDOW=0 disables suppression" || bad "window=0 still suppressed: $OUT"
# A window that has EXPIRED must not suppress: post, wait past a 1s window, repost.
setup_fixture
WINDOW=1 run_entry result
[ "$(count_kind result)" -eq 1 ] || bad "fixture post did not land (expiry case)"
sleep 2
WINDOW=1 run_entry result
[ "$(count_kind result)" -eq 2 ] && ok "an entry older than the window no longer suppresses" || bad "expired window still suppressed: $OUT"
# A malformed knob is refused loudly rather than losing the entry in arithmetic.
WINDOW=fifteen run_entry result
[ "$RC" -ne 0 ] && grep -qi 'must be non-negative integers' <<<"$OUT" \
  && ok "a non-numeric window dies with a named refusal" || bad "non-numeric window rc=$RC: $OUT"

# ============================================================================
hr; echo "DAY WALK — the scan reaches yesterday, and stops where the cap says"; hr
# The window is expressed in seconds but the entries are filed per UTC day, so a
# window that spans midnight must reach the previous day's directory — and the
# MAX_DAYS cap must still bound how far a large window can walk.
setup_fixture
now="$(date -u +%s)"
ydir="$(date -u -d "@$(( now - 86400 ))" +%Y/%m/%d)"
ystamp="$(date -u -d "@$(( now - 86400 ))" +%H%M%SZ)"
YSEED="$TR/yseed"; git clone -q --branch journal2 "$BARE" "$YSEED"
mkdir -p "$YSEED/entries/$ydir"
{ printf -- '---\nkind: %s\nrole: %s\nhost: %s\nat: %s\n---\n' \
    result botanist testhost "$(date -u -d "@$(( now - 86400 ))" +%FT%TZ)"
  printf '%s\n' "$REPORT"; } > "$YSEED/entries/$ydir/$ystamp-result-botanist-yester.md"
git -C "$YSEED" add -A
git -C "$YSEED" "${git_id[@]}" commit -q -m "an entry filed yesterday"
git -C "$YSEED" push -q origin journal2
BODY="$REPORT"
WINDOW=172800 run_entry result   # a 2-day window; the default cap allows 2 days
[ "$RC" -eq 0 ] && [ "$(count_kind result)" -eq 1 ] \
  && ok "a window spanning midnight matches yesterday's entry" \
  || bad "yesterday's entry did not suppress (results=$(count_kind result)): $OUT"
OUT="$(env JOURNAL_REMOTE="$BARE" JOURNAL_BRANCH=journal2 GARDEN_STATE="$STATE" \
           GARDEN_ROOT="$TR" GARDEN_PRODUCER_CLONE="$CLONE" GARDEN=testhost \
           GARDEN_ROLE=botanist GARDEN_ENTRY_DUP_WINDOW=172800 \
           GARDEN_ENTRY_DUP_MAX_DAYS=1 GARDEN_TEST=1 GARDEN_NO_MAINTAINER_ALERT=1 \
           bash "$ENTRY" result <<<"$REPORT" 2>&1)"
[ "$(count_kind result)" -eq 2 ] && ok "GARDEN_ENTRY_DUP_MAX_DAYS=1 stops the walk at today" \
  || bad "the day cap did not bound the walk: $OUT"

# ============================================================================
hr; echo "ORIGIN-REF — only a LANDED entry may suppress"; hr
# A run that died between writing its file and committing leaves an UNTRACKED
# file in the producer clone (sync_clone's `clean` only touches jobs/). Scanning
# the working tree would let that leftover swallow a real, never-posted entry
# forever; the scan reads origin/journal2, so it must not.
setup_fixture
BODY="$(printf '%s\n' 'a report that has never been posted')"
day="$(date -u +%Y/%m/%d)"
mkdir -p "$CLONE" 2>/dev/null || true
# Materialize the clone (first run creates it), then plant the leftover.
run_entry progress   # unrelated entry, just to create the clone
mkdir -p "$CLONE/entries/$day"
{ printf -- '---\nkind: %s\nrole: %s\nhost: %s\nat: %s\n---\n' \
    result botanist testhost "$(date -u +%FT%TZ)"
  printf '%s\n' "$BODY"; } > "$CLONE/entries/$day/$(date -u +%H%M%SZ)-result-botanist-deadbe.md"
run_entry result
[ "$RC" -eq 0 ] && [ "$(count_kind result)" -eq 1 ] \
  && ok "an untracked leftover does not suppress a real post" \
  || bad "untracked leftover suppressed the post (rc=$RC, results=$(count_kind result)): $OUT"

# ============================================================================
hr; echo "COMPAT — the argv guards still hold with the flag in play"; hr
setup_fixture
BODY="never written"
run_entry --help
[ "$RC" -eq 0 ] && grep -qi 'Usage:' <<<"$OUT" && ok "--help still prints usage" || bad "--help broke: $OUT"
run_entry --allow-duplicate --help
[ "$RC" -eq 0 ] && grep -qi 'Usage:' <<<"$OUT" && ok "--allow-duplicate --help still prints usage" || bad "flag+help broke: $OUT"
run_entry --allow-duplicate --foo
[ "$RC" -ne 0 ] && grep -qi 'unknown kind' <<<"$OUT" && ok "an unrecognized dash-led kind is still refused" || bad "stray flag accepted: $OUT"
[ "$(count_all)" -eq 0 ] && ok "no entry landed from the guard cases" || bad "a guard case landed an entry"

# ============================================================================
hr
echo "RESULTS: $PASS passed, $FAIL failed"
rm -rf "$TR"
[ "$FAIL" -eq 0 ]
