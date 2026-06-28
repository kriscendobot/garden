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
POSTSTUB="$TR/post-stub.sh"
cat > "$POSTSTUB" <<'EOF'
#!/bin/bash
printf 'POST %s\n' "$1" >> "${IIW_POSTLOG:?set IIW_POSTLOG}"
EOF
chmod +x "$POSTSTUB"
MSGSTUB="$TR/msg-stub.sh"
cat > "$MSGSTUB" <<'EOF'
#!/bin/bash
printf 'MSG %s\n' "$1" >> "${IIW_MSGLOG:?set IIW_MSGLOG}"
exit 0
EOF
chmod +x "$MSGSTUB"

ALLOW="$TR/allowlist"; printf 'kriskowal\n' > "$ALLOW"

cursor_seen() {  # cursor_seen <state-dir> <bare>  -> prints last_seen
  env GARDEN_STATE="$1" JOURNAL_REMOTE="$2" JOURNAL_BRANCH="$BRANCH" \
    "$JOBS/cursor-get.sh" "issues/$SLUG" | sed -n 's/^last_seen:[[:space:]]*//p' | head -1
}

run_watcher() {  # run_watcher <state> <bare> <fixture> <postlog> <msglog> <errlog>
  env GARDEN_STATE="$1" JOURNAL_REMOTE="$2" JOURNAL_BRANCH="$BRANCH" \
      GARDEN_GARDEN_REPO="$REPO" \
      GARDEN_MAINTAINERS_ALLOWLIST="$ALLOW" \
      IIW_FIXTURE="$3" IIW_POSTLOG="$4" IIW_MSGLOG="$5" \
      GARDEN_ISSUE_SOURCE="$SRCSTUB" \
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
hr; echo "RESULT: $PASS passed, $FAIL failed"; hr
[ "$FAIL" -eq 0 ]
