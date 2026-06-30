#!/bin/bash
# pr-feedback-preflight-test.sh — coverage for the deterministic PR-feedback
# recheck gate (gardening/pr-feedback-preflight.sh).
#
# The gate decides, in plain code, whether a peer has ALREADY resolved the feedback
# this job was minted from, BEFORE the consumer makes any edit:
#   exit 0 = PROCEED — no peer resolution found; do the work.
#   exit 2 = NO-OP   — a peer's resolution citing THIS comment is already present.
#   (any other exit fails open → PROCEED)
#
# The match logic (the unit under test) lives in the script; the evidence corpus is
# injected through GARDEN_PREFLIGHT_EVIDENCE so each case is a deterministic fixture
# — no gh, no network, no live PR. A peer's resolution is detected via ANY of:
#   1. in_reply_to=<cid>            — a reply on the same inline thread,
#   2. the comment id <cid> word    — a commit/reply citing the comment, or
#   3. Addressed @<reviewer> / @<reviewer>'s review (only with a reviewer login).
#
# Usage: pr-feedback-preflight-test.sh
set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
JOBS="$(cd "$HERE/.." && pwd)"
PRE="$JOBS/gardening/pr-feedback-preflight.sh"
PASS=0; FAIL=0
ok()  { echo "  PASS: $*"; PASS=$((PASS+1)); }
bad() { echo "  FAIL: $*"; FAIL=$((FAIL+1)); }
hr()  { echo "----------------------------------------------------------------"; }

# Scrub ambient garden env (the test is often run BY a live gardener whose process
# exports the fleet's GARDEN_*/JOURNAL_*; common.sh's log uses GARDEN_TAG only).
unset $(compgen -v 2>/dev/null | grep -E '^(GARDEN_|JOURNAL_|SELF_HEAL_|XDG_)' || true) 2>/dev/null || true

TR=/home/kris/.garden-pr-feedback-preflight-test
rm -rf "$TR"; mkdir -p "$TR"

REPO=endojs/endo-but-for-bots
PR=548
CID=4597029908
REVIEWER=erights

# Write a corpus fixture and an evidence stub that emits it, then run the gate.
# Fills $RC / $OUT.
run_pre() {  # run_pre <corpus-text> [comment-id] [reviewer]
  local corpus="$1" cid="${2:-$CID}" reviewer="${3:-}"
  local cf="$TR/corpus"; printf '%s\n' "$corpus" > "$cf"
  local stub="$TR/evidence.sh"
  { printf '#!/bin/bash\ncat %q\n' "$cf"; } > "$stub"; chmod +x "$stub"
  set +e
  OUT="$(env GARDEN=testhost GARDEN_STATE="$TR/state" GARDEN_NO_MAINTAINER_ALERT=1 \
             GARDEN_PREFLIGHT_EVIDENCE="$stub" \
             bash "$PRE" "$REPO" "$PR" "$cid" "$reviewer" 2>&1)"
  RC=$?
  set -e
}

# ============================================================================
hr; echo "STATIC — pr-feedback-preflight.sh parses (bash -n)"; hr
bash -n "$PRE" && ok "pr-feedback-preflight.sh parses" || bad "syntax error"

# ============================================================================
hr; echo "PROCEED — unrelated activity only: exit 0"; hr
run_pre "$(printf 'fix: tidy unrelated docs\nin_reply_to=none Some other review thread\nin_reply_to=111 a reply to a different comment')"
[ "$RC" -eq 0 ] && ok "no peer resolution → exit 0 (PROCEED)" || bad "exit $RC (want 0) on unrelated corpus"
grep -qi "PROCEED" <<<"$OUT" && ok "logged PROCEED" || bad "no PROCEED log ($OUT)"

# ============================================================================
hr; echo "NO-OP #1 — a reply on the SAME inline thread (in_reply_to=<cid>): exit 2"; hr
run_pre "$(printf 'fix: something else\nin_reply_to=%s Done — folded the Handles as asked.' "$CID")"
[ "$RC" -eq 2 ] && ok "same-thread reply → exit 2 (NO-OP)" || bad "exit $RC (want 2) on same-thread reply"
grep -qi "NO-OP" <<<"$OUT" && ok "logged NO-OP with the same-thread reason" || bad "no NO-OP log ($OUT)"

# ============================================================================
hr; echo "NO-OP #2 — a commit message CITING the comment id: exit 2"; hr
run_pre "$(printf 'fix: address review comment %s\n\nSee https://github.com/%s/pull/%s#discussion_r%s\nin_reply_to=none reviewer body here' "$CID" "$REPO" "$PR" "$CID")"
[ "$RC" -eq 2 ] && ok "commit citing the comment id → exit 2 (NO-OP)" || bad "exit $RC (want 2) on id-citing commit"

# ============================================================================
hr; echo "NO-OP #3 — 'Addressed @<reviewer>' acknowledgment: exit 2"; hr
run_pre "$(printf 'fixup: review follow-up\n\nAddressed @%s feedback on the indent.\nin_reply_to=none unrelated' "$REVIEWER")" "$CID" "$REVIEWER"
[ "$RC" -eq 2 ] && ok "'Addressed @reviewer' note → exit 2 (NO-OP)" || bad "exit $RC (want 2) on Addressed-@reviewer"

# ============================================================================
hr; echo "NO-OP #4 — \"@<reviewer>'s review\" phrasing: exit 2"; hr
run_pre "$(printf 'chore: misc\n\nResolved all of @%s'\''s review comments.' "$REVIEWER")" "$CID" "$REVIEWER"
[ "$RC" -eq 2 ] && ok "\"@reviewer's review\" note → exit 2 (NO-OP)" || bad "exit $RC (want 2) on @reviewer's-review"

# ============================================================================
hr; echo "REVIEWER-GATED — Addressed note but NO reviewer arg: exit 0"; hr
# The prose patterns require the reviewer login; without it, an 'Addressed @x'
# note for a DIFFERENT reviewer must not no-op this job.
run_pre "$(printf 'fixup\n\nAddressed @someoneelse feedback.\nin_reply_to=none x')" "$CID" ""
[ "$RC" -eq 0 ] && ok "Addressed-@other with no reviewer arg → exit 0 (PROCEED)" || bad "exit $RC (want 0)"

# ============================================================================
hr; echo "NO SUBSTRING COLLISION — cid as a substring of a larger number: exit 0"; hr
# The id match is word-bounded, so a longer number CONTAINING the cid must not trip.
run_pre "$(printf 'fix: bumped count to %s99\nin_reply_to=99%s a reply to a different thread' "$CID" "$CID")"
[ "$RC" -eq 0 ] && ok "cid as a digit-substring does not match (word-bounded) → exit 0" || bad "exit $RC (want 0) — substring collided"

# ============================================================================
hr; echo "FAIL-OPEN — empty evidence corpus: exit 0 (PROCEED)"; hr
run_pre ""
[ "$RC" -eq 0 ] && ok "empty corpus → exit 0 (fail-open, push CAS is the backstop)" || bad "exit $RC (want 0) on empty corpus"

# ============================================================================
hr; echo "FAIL-OPEN — evidence hook fails (non-zero, no output): exit 0"; hr
stub="$TR/evidence-fail.sh"; printf '#!/bin/bash\nexit 1\n' > "$stub"; chmod +x "$stub"
set +e
OUT="$(env GARDEN=testhost GARDEN_STATE="$TR/state" GARDEN_NO_MAINTAINER_ALERT=1 \
           GARDEN_PREFLIGHT_EVIDENCE="$stub" \
           bash "$PRE" "$REPO" "$PR" "$CID" "$REVIEWER" 2>&1)"; RC=$?
set -e
[ "$RC" -eq 0 ] && ok "failing evidence hook → exit 0 (PROCEED, never silently skip)" || bad "exit $RC (want 0) on hook failure"

# ============================================================================
hr; echo "USAGE — missing required args: non-zero (not a NO-OP swallow)"; hr
set +e
env GARDEN=testhost GARDEN_STATE="$TR/state" GARDEN_NO_MAINTAINER_ALERT=1 bash "$PRE" "$REPO" >/dev/null 2>&1; urc=$?
set -e
[ "$urc" -ne 0 ] && ok "missing comment-id → non-zero usage error" || bad "missing args did not error (rc=$urc)"

hr; echo "RESULT: $PASS passed, $FAIL failed"; hr
rm -rf "$TR"
[ "$FAIL" -eq 0 ]
