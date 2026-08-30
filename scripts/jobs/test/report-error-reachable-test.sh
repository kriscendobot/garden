#!/bin/bash
# report-error-reachable-test.sh — prove a gardener-inbox escalation is
# INSPECTABLE BY AN OFF-HOST RESPONDER, on throwaway fixtures with no GitHub and
# no claude. A local bare repo stands in for origin/journal2, one clone is the
# failing host's journal worktree, and a SECOND, independent clone is the central
# mentor — the responder that could not read a thing before this fix.
#
# The defect this pins (2026-08-01): report-error.sh wrote the transcript with
# `git hash-object -w` (a LOOSE blob) and committed only the inbox markdown that
# NAMES the SHA. Nothing in the pushed history pointed at the blob, so
# `git push HEAD:journal2` left it behind and every escalation reached the mentor
# as an un-inspectable SHA.
#
# Asserts:
#   A. REACHABLE OFF-HOST: after a plain `journal2` fetch, the mentor clone
#      resolves the escalated SHA and gets back the transcript bytes.
#   B. INBOX SECTION: the appended section names the SHA and the capture path,
#      and the capture is committed in the SAME commit as the section.
#   C. DEDUP: the same transcript escalated twice yields one capture file and one
#      SHA (content-addressed), while still appending a second inbox section.
#   D. EMPTY TRANSCRIPT: the empty-blob defense still holds AND its synthetic
#      content is reachable off-host (never the zero-byte blob e69de29b…).
#   E. TRUNCATION BEFORE HASHING: over the byte cap, bounded beginning and ending
#      slices surround an explicit omission marker, and the SHA still names
#      EXACTLY the committed bytes.
#
# Usage: report-error-reachable-test.sh
set -uo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO="$(cd "$HERE/../../.." && pwd)"
REPORT_ERROR="$REPO/skills/gardener-inbox-error-reporting/report-error.sh"
PASS=0; FAIL=0
ok()  { echo "  PASS: $*"; PASS=$((PASS+1)); }
bad() { echo "  FAIL: $*"; FAIL=$((FAIL+1)); }
hr()  { echo "----------------------------------------------------------------"; }

# Hermetic baseline: this suite is often invoked BY a live gardener whose process
# exports the fleet's GARDEN_*/JOURNAL_* — scrub them so only our fixtures win,
# then re-assert the positive test-context sentinel the scrub just removed.
# shellcheck disable=SC2046  # deliberate word-splitting: unset a list of names.
unset $(compgen -v 2>/dev/null | grep -E '^(GARDEN_|JOURNAL_)' || true) 2>/dev/null || true
export GARDEN_TEST=1

TR="$(mktemp -d "${TMPDIR:-/tmp}/garden-report-error-test.XXXXXX")" || exit 1
trap '[ "$FAIL" -eq 0 ] && rm -rf "$TR"' EXIT
git_id=(-c user.name=test -c user.email=test@localhost)

# --- fixture: a bare journal2 origin, a host clone, a mentor clone -------------
fresh() {  # fresh <name> -> sets BARE / CLONE / MENTOR
  local name="$1"
  BARE="$TR/$name/journal.git"; CLONE="$TR/$name/clone"; MENTOR="$TR/$name/mentor"
  mkdir -p "$TR/$name"
  git init -q --bare "$BARE"
  local seed="$TR/$name/seed"
  git init -q "$seed"; git -C "$seed" checkout -q -b journal2
  mkdir -p "$seed/jobs/todo"; touch "$seed/jobs/todo/.gitkeep"
  git -C "$seed" add -A; git -C "$seed" "${git_id[@]}" commit -q -m seed
  git -C "$seed" remote add origin "$BARE"; git -C "$seed" push -q origin journal2
  git -C "$BARE" symbolic-ref HEAD refs/heads/journal2
  git clone -q "$BARE" "$CLONE"; git -C "$CLONE" config user.name test
  git -C "$CLONE" config user.email test@localhost
  git clone -q "$BARE" "$MENTOR"
}

# run report-error.sh against the host clone; prints the SHA it reports.
report() {  # report <transcript> [K=V ...]
  local t="$1"; shift
  env GARDEN=testhost GARDEN_JOURNAL="$CLONE" "$@" \
    "$REPORT_ERROR" --transcript "$t" --lane 0 --state handler-nonzero \
    --context "gardener-1 on testhost: job 'demo' handler exited rc=1"
}

# what the OFF-HOST responder can see after a plain journal2 fetch.
mentor_cat() {  # mentor_cat <sha>
  git -C "$MENTOR" fetch -q origin journal2 2>/dev/null
  git -C "$MENTOR" cat-file -p "$1" 2>/dev/null
}

hr; echo "A/B. off-host reachability + inbox section"
fresh a
printf 'step 3 FAILED\nyarn test exploded\n' > "$TR/a/transcript.txt"
SHA="$(report "$TR/a/transcript.txt")"
if [ -n "$SHA" ]; then ok "escalation printed a SHA ($SHA)"; else bad "no SHA printed"; fi

got="$(mentor_cat "$SHA")"
if [ "$got" = "$(cat "$TR/a/transcript.txt")" ]; then
  ok "A: mentor clone resolves the SHA after a plain journal2 fetch (bytes match)"
else
  bad "A: mentor clone cannot read the transcript (got: ${got:-<unresolved>})"
fi

sect="$CLONE/inboxes/testhost/gardener.md"
if grep -qF "Transcript SHA: $SHA" "$sect" 2>/dev/null \
   && grep -qF "Capture: inboxes/testhost/captures/$SHA" "$sect" 2>/dev/null; then
  ok "B: inbox section names the SHA and the capture path"
else
  bad "B: inbox section missing the SHA/capture lines"
fi
# both files in ONE commit: a responder never sees a section whose capture is absent.
files="$(git -C "$MENTOR" show --name-only --pretty=format: origin/journal2 | grep -c .)"
if git -C "$MENTOR" cat-file -e "origin/journal2:inboxes/testhost/captures/$SHA" 2>/dev/null \
   && git -C "$MENTOR" cat-file -e "origin/journal2:inboxes/testhost/gardener.md" 2>/dev/null \
   && [ "$files" -eq 2 ]; then
  ok "B: capture + inbox section landed in the same pushed commit ($files paths)"
else
  bad "B: capture and section did not land together (paths in tip commit=$files)"
fi

hr; echo "C. dedup on identical content"
SHA2="$(report "$TR/a/transcript.txt")"
n_caps="$(find "$CLONE/inboxes/testhost/captures" -type f | wc -l)"
n_sects="$(grep -c '^## lane 0 -- handler-nonzero failure at ' "$sect")"
if [ "$SHA2" = "$SHA" ] && [ "$n_caps" -eq 1 ] && [ "$n_sects" -eq 2 ]; then
  ok "C: identical transcript reused one capture file, appended a second section"
else
  bad "C: dedup broke (sha2=$SHA2 sha=$SHA captures=$n_caps sections=$n_sects)"
fi

hr; echo "D. empty transcript (empty-blob defense, still reachable)"
fresh d
: > "$TR/d/empty.txt"
SHAD="$(report "$TR/d/empty.txt")"
gotd="$(mentor_cat "$SHAD")"
if [ "$SHAD" != "e69de29bb2d1d6434b8b29ae775ad8c2e48c5391" ] && [ -n "$gotd" ] \
   && case "$gotd" in *"handler produced no captured output"*) true;; *) false;; esac; then
  ok "D: synthetic stand-in escalated and readable off-host (not the zero-byte blob)"
else
  bad "D: empty-transcript escalation broken (sha=$SHAD body='${gotd:-<unresolved>}')"
fi

hr; echo "E. truncation happens BEFORE hashing"
fresh e
{ printf 'THE INITIAL DIAGNOSTIC\n'; printf 'noise line %s\n' $(seq 1 400); printf 'THE ACTUAL FAILURE\n'; } > "$TR/e/big.txt"
before_sum="$(cksum < "$TR/e/big.txt")"
SHAE="$(report "$TR/e/big.txt" GARDEN_REPORT_ERROR_MAX_BYTES=200)"
gote="$(mentor_cat "$SHAE")"
capfile="$CLONE/inboxes/testhost/captures/$SHAE"
if [ -n "$gote" ] && [ -f "$capfile" ] && [ "$gote" = "$(cat "$capfile")" ]; then
  ok "E: the SHA resolves off-host to exactly the committed capture"
else
  bad "E: truncated capture does not match its SHA (sha=$SHAE)"
fi
if case "$gote" in "report-error: transcript truncated"*) true;; *) false;; esac \
   && case "$gote" in *"THE INITIAL DIAGNOSTIC"*) true;; *) false;; esac \
   && case "$gote" in *"[report-error: omitted "*" bytes from the middle of the transcript]"*) true;; *) false;; esac \
   && case "$gote" in *"THE ACTUAL FAILURE"*) true;; *) false;; esac \
   && [ "$(wc -c < "$capfile")" -lt "$(wc -c < "$TR/e/big.txt")" ]; then
  ok "E: banner, head, omission marker, and tail kept; capture smaller than source"
else
  bad "E: truncation did not retain both slices ($(wc -c < "$capfile") bytes)"
fi
if [ "$(cksum < "$TR/e/big.txt")" = "$before_sum" ]; then
  ok "E: the caller's transcript file was not mutated"
else
  bad "E: the caller's transcript file was mutated"
fi

hr
echo "report-error reachability: $PASS passed, $FAIL failed"
[ "$FAIL" -eq 0 ] || echo "fixtures kept at $TR"
[ "$FAIL" -eq 0 ]
