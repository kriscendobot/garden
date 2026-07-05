#!/bin/bash
# issue-inbox-watcher-test.sh — validate the garden's issue-inbox watcher on
# throwaway fixtures, with no GitHub and no claude. The issue SOURCE, the JOB
# POSTER, and the comment MESSENGER are stubbed deterministically; the
# maintainer-trust gate, the closing-etiquette / re-engagement rule, and the
# cursor-advance logic under test run for real against a throwaway journal.
#
# Regression focus (kriskowal/garden #10, 2026-06-28): a trusted maintainer CLOSED
# an issue and then COMMENTED on it twice before reopening. The watcher applied the
# "submitter-close is terminal" rule to the COMMENTS too, dropped both, and slid the
# cursor past them — two trusted directives lost. The fix: a trusted comment whose
# created_at POST-DATES the close is RE-ENGAGEMENT and is processed; only the close
# itself (and anything at/before it) stays terminal; no trusted comment is ever
# silently slid past (a genuine drop logs kind + id + reason).
#
# Asserts:
#   A. a trusted comment authored AFTER closed_at → DELIVERED (not dropped), cursor advances
#   B. a submitter-CLOSE with no later comment (kind=issue) → terminal, nothing dispatched
#   C. a trusted comment authored AT/BEFORE the close → terminal drop, logs id + reason
#   D. an UNTRUSTED author's post-close comment → dropped by the trust gate, logs id
#   E. reopen safety: a comment while state=open is processed regardless of a prior close
#   F. the #10 case end to end: TWO post-close trusted comments → BOTH delivered
#
# Reactji parity (kriskowal/garden #13, 2026-06-28): the issue path never fired a 👀,
# so a maintainer who opened an issue was left waiting for the acknowledgment the
# comment-watcher already gives. Added assertions:
#   G. a new trusted ISSUE → an `issue`-surface 👀 (id = issue NUMBER) BEFORE the post
#   H. a new trusted ISSUE-COMMENT → an `issue-comment`-surface 👀 (id = comment id) BEFORE the msg
#   I. the reactji helper's `issue` surface hits /issues/<number>/reactions (comment surface unchanged)
#   J. a reactji FAILURE does not block the dispatch
#
# Usage: issue-inbox-watcher-test.sh
set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
JOBS="$(cd "$HERE/.." && pwd)"
BRANCH=journal2
TR=/home/kris/.garden-iiw-test
REPO=kriskowal/garden
SLUG=kriskowal-garden
PASS=0; FAIL=0
ok()  { echo "  PASS: $*"; PASS=$((PASS+1)); }
bad() { echo "  FAIL: $*"; FAIL=$((FAIL+1)); }
hr()  { echo "----------------------------------------------------------------"; }

rm -rf "$TR"; mkdir -p "$TR"
git_id=(-c user.name=test -c user.email=test@localhost)

seed_bare() {  # seed_bare <bare-path>
  local bare="$1" seed; seed="$(mktemp -d "$TR/seed.XXXXXX")"
  git init -q --bare "$bare"
  git init -q "$seed"; git -C "$seed" checkout -q -b "$BRANCH"
  ( cd "$seed"
    mkdir -p jobs/todo jobs/doin jobs/tada cursors entries inboxes
    for d in jobs/todo jobs/doin jobs/tada cursors entries inboxes; do touch "$d/.gitkeep"; done )
  git -C "$seed" add -A; git -C "$seed" "${git_id[@]}" commit -q -m seed
  git -C "$seed" remote add origin "$bare"; git -C "$seed" push -q -u origin "$BRANCH"
  rm -rf "$seed"
}

# --- deterministic stubs ----------------------------------------------------
SRCSTUB="$TR/source-stub.sh"
cat > "$SRCSTUB" <<'EOF'
#!/bin/bash
# emit the fixture verbatim (ignores repo/since); the watcher gates & dispatches.
cat "${IIW_FIXTURE:?set IIW_FIXTURE}"
EOF
chmod +x "$SRCSTUB"

# POST / MSG stubs: log "<verb> <basename>" per call so dispatch is observable
# without real board mechanics, and report success so the watcher counts it acted.
# They also append a lowercase marker to IIW_SEQLOG (when set) so the reactji tests
# can prove the 👀 fires BEFORE the substantive dispatch.
POSTSTUB="$TR/post-stub.sh"
cat > "$POSTSTUB" <<'EOF'
#!/bin/bash
printf 'POST %s\n' "$1" >> "${IIW_POSTLOG:?set IIW_POSTLOG}"
[ -n "${IIW_SEQLOG:-}" ] && printf 'post %s\n' "$1" >> "$IIW_SEQLOG"
exit 0
EOF
chmod +x "$POSTSTUB"
MSGSTUB="$TR/msg-stub.sh"
cat > "$MSGSTUB" <<'EOF'
#!/bin/bash
printf 'MSG %s\n' "$1" >> "${IIW_MSGLOG:?set IIW_MSGLOG}"
[ -n "${IIW_SEQLOG:-}" ] && printf 'msg %s\n' "$1" >> "$IIW_SEQLOG"
exit 0
EOF
chmod +x "$MSGSTUB"

# reactji stub: log "<surface> <id> <content>" to IIW_REACTLOG and a "react"
# marker to IIW_SEQLOG (when set). Tolerant of unset logs (→ /dev/null) and always
# succeeds, so every run_watcher call uses it INSTEAD of the real gh-calling handler
# — the watcher must never touch the live GitHub API from a test.
REACTSTUB="$TR/reactji-stub.sh"
cat > "$REACTSTUB" <<'EOF'
#!/bin/bash
printf '%s %s %s\n' "$2" "$3" "$4" >> "${IIW_REACTLOG:-/dev/null}"
[ -n "${IIW_SEQLOG:-}" ] && printf 'react %s %s\n' "$2" "$3" >> "$IIW_SEQLOG"
exit 0
EOF
chmod +x "$REACTSTUB"

# a reactji stub that always FAILS (for the does-not-block assertion)
FAILREACT="$TR/reactji-fail-stub.sh"
cat > "$FAILREACT" <<'EOF'
#!/bin/bash
echo "reactji boom" >&2; exit 1
EOF
chmod +x "$FAILREACT"

ALLOW="$TR/allowlist"; printf 'kriskowal\n' > "$ALLOW"

cursor_seen() {  # cursor_seen <state-dir> <bare>  -> prints last_seen
  env GARDEN_STATE="$1" JOURNAL_REMOTE="$2" JOURNAL_BRANCH="$BRANCH" \
    "$JOBS/cursor-get.sh" "issues/$SLUG" | sed -n 's/^last_seen:[[:space:]]*//p' | head -1
}

run_watcher() {  # run_watcher <state> <bare> <fixture> <postlog> <msglog> <errlog> [reactlog] [seqlog] [reactji]
  # The reactji handler is ALWAYS stubbed (default $REACTSTUB) so a test never hits
  # the live GitHub API; reactlog/seqlog default to throwaway sinks so the existing
  # cases need not pass them.
  env GARDEN_STATE="$1" JOURNAL_REMOTE="$2" JOURNAL_BRANCH="$BRANCH" \
      GARDEN_GARDEN_REPO="$REPO" \
      GARDEN_MAINTAINERS_ALLOWLIST="$ALLOW" \
      IIW_FIXTURE="$3" IIW_POSTLOG="$4" IIW_MSGLOG="$5" \
      IIW_REACTLOG="${7:-$TR/react-sink.log}" IIW_SEQLOG="${8:-$TR/seq-sink.log}" \
      GARDEN_ISSUE_SOURCE="$SRCSTUB" \
      GARDEN_ISSUE_REACTJI="${9:-$REACTSTUB}" \
      GARDEN_ISSUE_POST="$POSTSTUB" \
      GARDEN_ISSUE_MSG="$MSGSTUB" \
      "$JOBS/issue-inbox-watcher.sh" >/dev/null 2>"$6"
}

# row helper: kind created id number author submitter state closed_by closed_at url body
row() { printf '%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\n' "$@"; }

# ============================================================================
hr; echo "A — trusted comment AUTHORED AFTER closed_at → delivered, not dropped"; hr
BARE_A="$TR/a.git"; seed_bare "$BARE_A"
FIX_A="$TR/fix-a.tsv"; PL_A="$TR/post-a.log"; ML_A="$TR/msg-a.log"; ERR_A="$TR/err-a.log"; : >"$PL_A"; : >"$ML_A"
row issue-comment 2026-06-28T17:07:40Z 9001 10 kriskowal kriskowal closed kriskowal 2026-06-28T16:27:12Z \
  https://github.com/kriskowal/garden/issues/10#issuecomment-9001 \
  "Bulletin still says write a reply first; please change it." > "$FIX_A"
run_watcher "$TR/state-a" "$BARE_A" "$FIX_A" "$PL_A" "$ML_A" "$ERR_A"
grep -q "MSG issue-$SLUG-10" "$ML_A" && ok "post-close comment was DELIVERED (re-engagement processed)" || bad "post-close comment not delivered (msglog: $(cat "$ML_A"))"
grep -qi 're-engagement, processing' "$ERR_A" && ok "log explains the re-engagement decision" || bad "no re-engagement log line"
[ "$(cursor_seen "$TR/state-a" "$BARE_A")" = 2026-06-28T17:07:40Z ] && ok "cursor advanced past the delivered comment" || bad "cursor not advanced ($(cursor_seen "$TR/state-a" "$BARE_A"))"

# ============================================================================
hr; echo "B — submitter-CLOSE with no later comment (kind=issue) → terminal, nothing dispatched"; hr
BARE_B="$TR/b.git"; seed_bare "$BARE_B"
FIX_B="$TR/fix-b.tsv"; PL_B="$TR/post-b.log"; ML_B="$TR/msg-b.log"; ERR_B="$TR/err-b.log"; : >"$PL_B"; : >"$ML_B"
row issue 2026-06-28T15:00:00Z 5500 11 kriskowal kriskowal closed kriskowal 2026-06-28T16:00:00Z \
  https://github.com/kriskowal/garden/issues/11 \
  "Opened and already resolved; closing." > "$FIX_B"
run_watcher "$TR/state-b" "$BARE_B" "$FIX_B" "$PL_B" "$ML_B" "$ERR_B"
[ ! -s "$PL_B" ] && [ ! -s "$ML_B" ] && ok "a clean submitter-close dispatched nothing" || bad "dispatched on a terminal close (post=$(cat "$PL_B") msg=$(cat "$ML_B"))"
grep -qi 'terminal, dropping' "$ERR_B" && ok "the terminal close logs its drop reason" || bad "no terminal-drop log"
[ "$(cursor_seen "$TR/state-b" "$BARE_B")" = 2026-06-28T15:00:00Z ] && ok "cursor slid past the terminal close" || bad "cursor did not slide"

# ============================================================================
hr; echo "C — trusted comment AT/BEFORE the close → terminal drop, logs id + reason"; hr
BARE_C="$TR/c.git"; seed_bare "$BARE_C"
FIX_C="$TR/fix-c.tsv"; PL_C="$TR/post-c.log"; ML_C="$TR/msg-c.log"; ERR_C="$TR/err-c.log"; : >"$PL_C"; : >"$ML_C"
# comment created 15:30 < closed_at 16:00 on a now-closed issue → superseded by the close.
row issue-comment 2026-06-28T15:30:00Z 9100 12 kriskowal kriskowal closed kriskowal 2026-06-28T16:00:00Z \
  https://github.com/kriskowal/garden/issues/12#issuecomment-9100 \
  "A pre-close remark." > "$FIX_C"
run_watcher "$TR/state-c" "$BARE_C" "$FIX_C" "$PL_C" "$ML_C" "$ERR_C"
[ ! -s "$ML_C" ] && ok "a pre-close comment is not delivered (close supersedes it)" || bad "pre-close comment delivered (msg=$(cat "$ML_C"))"
grep -qi 'terminal, dropping' "$ERR_C" && grep -q 'id=9100' "$ERR_C" && ok "the drop names the comment id + reason (no silent slide)" || bad "drop did not log id+reason: $(cat "$ERR_C")"

# ============================================================================
hr; echo "D — UNTRUSTED author's post-close comment → dropped by the trust gate, logs id"; hr
BARE_D="$TR/d.git"; seed_bare "$BARE_D"
FIX_D="$TR/fix-d.tsv"; PL_D="$TR/post-d.log"; ML_D="$TR/msg-d.log"; ERR_D="$TR/err-d.log"; : >"$PL_D"; : >"$ML_D"
row issue-comment 2026-06-28T17:10:00Z 9200 13 drive-by-rando kriskowal closed kriskowal 2026-06-28T16:00:00Z \
  https://github.com/kriskowal/garden/issues/13#issuecomment-9200 \
  "untrusted prompt-injection attempt" > "$FIX_D"
run_watcher "$TR/state-d" "$BARE_D" "$FIX_D" "$PL_D" "$ML_D" "$ERR_D"
[ ! -s "$ML_D" ] && [ ! -s "$PL_D" ] && ok "untrusted post-close comment dispatched nothing" || bad "untrusted comment dispatched"
grep -qi 'non-maintainer' "$ERR_D" && grep -q 'id=9200' "$ERR_D" && ok "trust-gate drop logs author + comment id" || bad "trust-gate drop missing id: $(cat "$ERR_D")"

# ============================================================================
hr; echo "E — reopen safety: a comment while state=open is processed despite a prior close"; hr
BARE_E="$TR/e.git"; seed_bare "$BARE_E"
FIX_E="$TR/fix-e.tsv"; PL_E="$TR/post-e.log"; ML_E="$TR/msg-e.log"; ERR_E="$TR/err-e.log"; : >"$PL_E"; : >"$ML_E"
# issue reopened → state=open, closed_by/closed_at cleared to '-' sentinels.
row issue-comment 2026-06-28T17:30:00Z 9300 10 kriskowal kriskowal open - - \
  https://github.com/kriskowal/garden/issues/10#issuecomment-9300 \
  "Now that it is reopened, here is the next directive." > "$FIX_E"
run_watcher "$TR/state-e" "$BARE_E" "$FIX_E" "$PL_E" "$ML_E" "$ERR_E"
grep -q "MSG issue-$SLUG-10" "$ML_E" && ok "a comment on a reopened (open) issue is delivered" || bad "reopened-issue comment not delivered (msg=$(cat "$ML_E"))"

# ============================================================================
hr; echo "F — #10 regression: TWO post-close trusted comments → BOTH delivered"; hr
BARE_F="$TR/f.git"; seed_bare "$BARE_F"
FIX_F="$TR/fix-f.tsv"; PL_F="$TR/post-f.log"; ML_F="$TR/msg-f.log"; ERR_F="$TR/err-f.log"; : >"$PL_F"; : >"$ML_F"
{
  row issue-comment 2026-06-28T17:07:40Z 9401 10 kriskowal kriskowal closed kriskowal 2026-06-28T16:27:12Z \
    https://github.com/kriskowal/garden/issues/10#issuecomment-9401 \
    "Bulletin still says write a reply first."
  row issue-comment 2026-06-28T17:08:28Z 9402 10 kriskowal kriskowal closed kriskowal 2026-06-28T16:27:12Z \
    https://github.com/kriskowal/garden/issues/10#issuecomment-9402 \
    "I would like every acknowledgement or reply to move the message from unread to read."
} > "$FIX_F"
run_watcher "$TR/state-f" "$BARE_F" "$FIX_F" "$PL_F" "$ML_F" "$ERR_F"
[ "$(grep -c "MSG issue-$SLUG-10" "$ML_F")" -eq 2 ] && ok "both post-close directives were delivered (neither lost)" || bad "expected 2 deliveries, got $(grep -c "MSG issue-$SLUG-10" "$ML_F") (msg=$(cat "$ML_F"))"
[ "$(cursor_seen "$TR/state-f" "$BARE_F")" = 2026-06-28T17:08:28Z ] && ok "cursor advanced to the last delivered comment" || bad "cursor not at last comment ($(cursor_seen "$TR/state-f" "$BARE_F"))"

# ============================================================================
hr; echo "G — new trusted ISSUE → issue-surface 👀 (id=NUMBER) BEFORE the post"; hr
BARE_G="$TR/g.git"; seed_bare "$BARE_G"
FIX_G="$TR/fix-g.tsv"; PL_G="$TR/post-g.log"; ML_G="$TR/msg-g.log"; ERR_G="$TR/err-g.log"; : >"$PL_G"; : >"$ML_G"
RL_G="$TR/react-g.log"; SQ_G="$TR/seq-g.log"; : >"$RL_G"; : >"$SQ_G"
row issue 2026-06-28T10:00:00Z 900 13 kriskowal kriskowal open - - \
  https://github.com/kriskowal/garden/issues/13 'Garden bulletin needs favicon' > "$FIX_G"
run_watcher "$TR/state-g" "$BARE_G" "$FIX_G" "$PL_G" "$ML_G" "$ERR_G" "$RL_G" "$SQ_G"
grep -q "POST issue-$SLUG-13" "$PL_G" && ok "issue job posted (issue-$SLUG-13)" || bad "issue job missing (post=$(cat "$PL_G"))"
grep -qx "issue 13 eyes" "$RL_G" && ok "issue-surface 👀 acked with id = issue NUMBER (13, not issue id 900)" || bad "wrong reactji ($(cat "$RL_G"))"
[ "$(grep -c . "$RL_G")" -eq 1 ] && ok "exactly one reactji" || bad "reactji count $(grep -c . "$RL_G")"
rl=$(grep -n '^react ' "$SQ_G" | head -1 | cut -d: -f1)
pl=$(grep -n '^post '  "$SQ_G" | head -1 | cut -d: -f1)
{ [ -n "$rl" ] && [ -n "$pl" ] && [ "$rl" -lt "$pl" ]; } && ok "reactji fired BEFORE the post" || bad "ordering wrong (react=$rl post=$pl seq=$(cat "$SQ_G"))"

# ============================================================================
hr; echo "H — new trusted ISSUE-COMMENT → issue-comment-surface 👀 (id=comment id) BEFORE the msg"; hr
BARE_H="$TR/h.git"; seed_bare "$BARE_H"
FIX_H="$TR/fix-h.tsv"; PL_H="$TR/post-h.log"; ML_H="$TR/msg-h.log"; ERR_H="$TR/err-h.log"; : >"$PL_H"; : >"$ML_H"
RL_H="$TR/react-h.log"; SQ_H="$TR/seq-h.log"; : >"$RL_H"; : >"$SQ_H"
row issue-comment 2026-06-28T11:00:00Z 555 13 kriskowal kriskowal open - - \
  'https://github.com/kriskowal/garden/issues/13#issuecomment-555' 'one more thought' > "$FIX_H"
run_watcher "$TR/state-h" "$BARE_H" "$FIX_H" "$PL_H" "$ML_H" "$ERR_H" "$RL_H" "$SQ_H"
grep -q "MSG issue-$SLUG-13" "$ML_H" && ok "comment delivered to the issue spine" || bad "comment not delivered (msg=$(cat "$ML_H"))"
grep -qx "issue-comment 555 eyes" "$RL_H" && ok "issue-comment-surface 👀 acked with id = comment id (555)" || bad "wrong reactji ($(cat "$RL_H"))"
[ "$(grep -c . "$RL_H")" -eq 1 ] && ok "exactly one reactji" || bad "reactji count $(grep -c . "$RL_H")"
rl=$(grep -n '^react ' "$SQ_H" | head -1 | cut -d: -f1)
ml=$(grep -n '^msg '   "$SQ_H" | head -1 | cut -d: -f1)
{ [ -n "$rl" ] && [ -n "$ml" ] && [ "$rl" -lt "$ml" ]; } && ok "reactji fired BEFORE the message" || bad "ordering wrong (react=$rl msg=$ml seq=$(cat "$SQ_H"))"

# ============================================================================
hr; echo "I — reactji helper: the issue surface hits /issues/<number>/reactions"; hr
BIN="$TR/bin"; mkdir -p "$BIN"; GHLOG="$TR/gh-args.log"; : > "$GHLOG"
cat > "$BIN/gh" <<EOF
#!/bin/bash
printf '%s\n' "\$*" >> "$GHLOG"
exit 0
EOF
chmod +x "$BIN/gh"
PATH="$BIN:$PATH" "$JOBS/handlers/comment-reactji-gh.sh" "$REPO" issue 13 eyes >/dev/null 2>&1
grep -qF "repos/$REPO/issues/13/reactions" "$GHLOG" && ok "issue surface POSTs to repos/$REPO/issues/13/reactions" || bad "wrong endpoint ($(cat "$GHLOG"))"
: > "$GHLOG"
PATH="$BIN:$PATH" "$JOBS/handlers/comment-reactji-gh.sh" "$REPO" issue-comment 555 eyes >/dev/null 2>&1
grep -qF "repos/$REPO/issues/comments/555/reactions" "$GHLOG" && ok "issue-comment surface unchanged (/issues/comments/555/reactions)" || bad "issue-comment regressed ($(cat "$GHLOG"))"

# ============================================================================
hr; echo "J — a reactji FAILURE does not block the dispatch"; hr
BARE_J="$TR/j.git"; seed_bare "$BARE_J"
FIX_J="$TR/fix-j.tsv"; PL_J="$TR/post-j.log"; ML_J="$TR/msg-j.log"; ERR_J="$TR/err-j.log"; : >"$PL_J"; : >"$ML_J"
RL_J="$TR/react-j.log"; SQ_J="$TR/seq-j.log"; : >"$RL_J"; : >"$SQ_J"
row issue 2026-06-28T12:00:00Z 901 14 kriskowal kriskowal open - - \
  https://github.com/kriskowal/garden/issues/14 'a second issue' > "$FIX_J"
run_watcher "$TR/state-j" "$BARE_J" "$FIX_J" "$PL_J" "$ML_J" "$ERR_J" "$RL_J" "$SQ_J" "$FAILREACT"
# The POST stub logs but does not land the job on the board, so the watcher's
# verify_posted confirmation legitimately holds the cursor — the assertion here is
# that the reactji failure did not stop the watcher BEFORE it attempted the post.
grep -q "POST issue-$SLUG-14" "$PL_J" && ok "job still posted despite a reactji failure (ack is best-effort, post is the obligation)" || bad "reactji failure blocked the post (post=$(cat "$PL_J"))"
grep -qi 'WARN: reactji failed' "$ERR_J" && ok "the reactji failure is logged as a WARN" || bad "no WARN logged on reactji failure ($(cat "$ERR_J"))"

# ============================================================================
# K — HELD FLOOR: an EARLIER item whose dispatch is lost must NOT abandon a
# chronologically-LATER item in the same batch. The old `failed=1; …; break` stopped
# the loop at the first lost dispatch, so every later issue/comment was silently
# abandoned tick after tick (the comment-watcher #594 head-of-line miss). With
# fail_floor the later item is still dispatched this tick, while the cursor freezes at
# the first failure so the lost item re-polls next tick.
#
# The POST stub reports success but never LANDS the job on the board, so a kind=issue
# row always POST-LOSTs (verify_posted holds — the same mechanic case J relies on),
# while a kind=issue-comment row is DELIVERED by the MSG stub (exit 0 = success). So
# an EARLIER issue (lost) followed by a LATER comment proves the later comment is still
# delivered despite the earlier lost post, and the cursor does not advance past the floor.
hr; echo "K — held floor: an earlier lost issue-post does not block a later comment"; hr
BARE_K="$TR/k.git"; seed_bare "$BARE_K"
FIX_K="$TR/fix-k.tsv"; PL_K="$TR/post-k.log"; ML_K="$TR/msg-k.log"; ERR_K="$TR/err-k.log"; : >"$PL_K"; : >"$ML_K"
{
  row issue 2026-06-28T18:00:00Z 800 20 kriskowal kriskowal open - - \
    https://github.com/kriskowal/garden/issues/20 'a new issue whose post will not land'
  row issue-comment 2026-06-28T18:05:00Z 8001 21 kriskowal kriskowal open - - \
    'https://github.com/kriskowal/garden/issues/21#issuecomment-8001' 'a later comment on another issue'
} > "$FIX_K"
run_watcher "$TR/state-k" "$BARE_K" "$FIX_K" "$PL_K" "$ML_K" "$ERR_K"
grep -q "POST issue-$SLUG-20" "$PL_K" && ok "the earlier (lost) issue was handed to the poster" || bad "earlier issue never posted ($(cat "$PL_K"))"
grep -q "MSG issue-$SLUG-21" "$ML_K" && ok "the LATER comment was still delivered despite the earlier lost post (no head-of-line block)" || bad "later comment abandoned after the earlier lost post ($(cat "$ML_K"))"
[ -z "$(cursor_seen "$TR/state-k" "$BARE_K")" ] && ok "cursor frozen at the floor (did not advance past the lost post)" || bad "cursor advanced past a lost post ($(cursor_seen "$TR/state-k" "$BARE_K"))"

# ============================================================================
hr; echo "RESULT: $PASS passed, $FAIL failed"; hr
[ "$FAIL" -eq 0 ]
