#!/bin/bash
# transcript-capture-test.sh — validate the transcript archive on throwaway
# fixtures, with no GitHub and no claude. A fake $HOME with synthetic
# ~/.claude/projects sessions, a local bare repo as the transcripts remote, and a
# local bare journal stand in for the real fleet. Everything under test —
# transcript_spool (common.sh), transcript-capture.sh, set-transcripts-remote.sh —
# runs for real.
#
# Asserts:
#   A. INERT WHEN UNARMED: no config/transcripts-remote → spool retained, nothing
#      pushed, but cleanupPeriodDays is STILL reconciled.
#   B. SETTINGS RECONCILE: absent file is created; a file with foreign keys keeps
#      them and gains cleanupPeriodDays=36500 (idempotent second run).
#   C. SET-TRANSCRIPTS-REMOTE + JOURNAL READ + SPOOL DRAIN: arm via the real
#      set-transcripts-remote.sh, then a capture reads the journal config, drains
#      the spool, creates the transcripts2 branch, and clears the spool.
#   D. REDACTION: a stored transcript has its gh/anthropic/Bearer secrets masked.
#   E. IDLE GATING: a freshly-touched session is NOT captured; the same session,
#      aged past the idle window, IS.
#   F. CHANGED-SESSION RE-CAPTURE: an unchanged idle session is not re-captured; a
#      grown one is captured again.
#   G. CAS RETRY: a racing peer commit landing between our fetch and push is
#      absorbed by the fetch/reset/reapply retry; both files end up on the branch.
#
# Usage: transcript-capture-test.sh
set -uo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
JOBS="$(cd "$HERE/.." && pwd)"
REPO="$(cd "$JOBS/../.." && pwd)"
TR=/home/kris/.garden-transcap-test
PASS=0; FAIL=0
ok()  { echo "  PASS: $*"; PASS=$((PASS+1)); }
bad() { echo "  FAIL: $*"; FAIL=$((FAIL+1)); }
hr()  { echo "----------------------------------------------------------------"; }

# Hermetic baseline: this test is often invoked BY a live gardener whose process
# exports the fleet's GARDEN_*/JOURNAL_* — scrub them so only our $TR settings win.
unset $(compgen -v 2>/dev/null | grep -E '^(GARDEN_|JOURNAL_)' || true) 2>/dev/null || true

rm -rf "$TR"; mkdir -p "$TR"
git_id=(-c user.name=test -c user.email=test@localhost)

# secrets that redaction must mask (20+ char tails).
GHP="ghp_ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
SKANT="sk-ant-abcdefghijklmnopqrstuvwxyz0123456789"
BEARER="Authorization: Bearer abcdefGHIJKL0123456789xyz"

# write a synthetic transcript with embedded secrets.
mk_session() {  # mk_session <path> [extra-line]
  local p="$1" extra="${2:-}"
  mkdir -p "$(dirname "$p")"
  { printf '{"type":"user","text":"hello"}\n'
    printf '{"type":"assistant","token":"%s"}\n' "$GHP"
    printf '{"type":"assistant","key":"%s"}\n' "$SKANT"
    printf '{"type":"assistant","hdr":"%s"}\n' "$BEARER"
    [ -n "$extra" ] && printf '%s\n' "$extra"
  } > "$p"
}

# a fresh, isolated environment (fake HOME, state, bare remotes).
fresh() {  # fresh <name>
  local name="$1"
  FHOME="$TR/$name/home"; STATE="$TR/$name/state"
  JBARE="$TR/$name/journal.git"; TBARE="$TR/$name/transcripts.git"
  mkdir -p "$FHOME/.claude/projects" "$STATE"
  git init -q --bare "$JBARE"
  # seed an empty journal2 branch (config absent = unarmed).
  local s="$TR/$name/jseed"; git init -q "$s"; git -C "$s" checkout -q -b journal2
  mkdir -p "$s/config"; touch "$s/config/.gitkeep"
  git -C "$s" add -A; git -C "$s" "${git_id[@]}" commit -q -m seed
  git -C "$s" remote add origin "$JBARE"; git -C "$s" push -q -u origin journal2
  git init -q --bare "$TBARE"
}

# run the capture with the current fresh env; extra env via args.
run_capture() {  # run_capture [K=V ...]
  local extra=("$@")
  env -u GARDEN_TRANSCRIPTS_REMOTE \
      HOME="$FHOME" GARDEN=testhost GARDEN_STATE="$STATE" GARDEN_ROOT="$REPO" \
      JOURNAL_REMOTE="$JBARE" JOURNAL_BRANCH=journal2 \
      GARDEN_NO_MAINTAINER_ALERT=1 \
      GARDEN_CLAUDE_PROJECTS="$FHOME/.claude/projects" \
      GARDEN_CLAUDE_SETTINGS="$FHOME/.claude/settings.json" \
      "${extra[@]}" \
      bash "$JOBS/transcript-capture.sh" 2>"$TR/last.err"
}

# spool a session through the real common.sh helper (simulates the hook).
spool_hook() {  # spool_hook <jsonl> <base>
  env HOME="$FHOME" GARDEN=testhost GARDEN_STATE="$STATE" GARDEN_ROOT="$REPO" \
    bash -c 'source "$1"; transcript_spool "$2" "$3"' _ "$JOBS/common.sh" "$1" "$2"
}

# clone the transcripts remote's branch for inspection (empty if absent).
tview() {
  rm -rf "$TR/tv"
  git clone -q --branch transcripts2 "$TBARE" "$TR/tv" 2>/dev/null || return 1
}

# ============================================================================
hr; echo "SCENARIO A/B — INERT WHEN UNARMED + SETTINGS RECONCILE"; hr
fresh a
# B1: absent settings file → created with the key.
run_capture; rcA=$?
[ "$rcA" -eq 0 ] && ok "unarmed capture exits 0" || bad "unarmed capture rc=$rcA"
if [ -f "$FHOME/.claude/settings.json" ] \
   && [ "$(jq -r '.cleanupPeriodDays' "$FHOME/.claude/settings.json")" = "36500" ]; then
  ok "absent settings.json created with cleanupPeriodDays=36500"
else bad "settings.json not created/reconciled (unarmed)"; fi
grep -q 'inert: no config/transcripts-remote' "$TR/last.err" \
  && ok "logged inert (no remote configured)" || bad "did not log inert"
# spool present but must be retained (nothing drained while unarmed).
mk_session "$FHOME/.claude/projects/-scratch-gardener-wt-job-x/sid-x.jsonl"
spool_hook "$FHOME/.claude/projects/-scratch-gardener-wt-job-x/sid-x.jsonl" job-x
run_capture >/dev/null 2>&1
if [ -s "$STATE/transcripts/spool/pending.tsv" ]; then
  ok "spool retained while unarmed (nothing lost)"
else bad "spool drained/lost while unarmed"; fi
tview && bad "transcripts2 branch created while unarmed (should not push)" \
       || ok "nothing pushed while unarmed (no transcripts2 branch)"

# B2: foreign keys preserved + idempotent second run.
fresh b
printf '{"theme":"dark","skipDangerousModePermissionPrompt":true}\n' > "$FHOME/.claude/settings.json"
run_capture >/dev/null 2>&1
th="$(jq -r '.theme' "$FHOME/.claude/settings.json" 2>/dev/null)"
cp="$(jq -r '.cleanupPeriodDays' "$FHOME/.claude/settings.json" 2>/dev/null)"
sk="$(jq -r '.skipDangerousModePermissionPrompt' "$FHOME/.claude/settings.json" 2>/dev/null)"
{ [ "$th" = "dark" ] && [ "$cp" = "36500" ] && [ "$sk" = "true" ]; } \
  && ok "foreign keys (theme, skipDangerous…) preserved; cleanupPeriodDays added" \
  || bad "reconcile clobbered foreign keys (theme=$th cleanup=$cp skip=$sk)"
before="$(md5sum "$FHOME/.claude/settings.json" | cut -d' ' -f1)"
run_capture >/dev/null 2>&1
after="$(md5sum "$FHOME/.claude/settings.json" | cut -d' ' -f1)"
[ "$before" = "$after" ] && ok "second reconcile is a no-op (idempotent)" || bad "reconcile not idempotent"

# ============================================================================
hr; echo "SCENARIO C/D — ARM (set-transcripts-remote) + SPOOL DRAIN + REDACTION"; hr
fresh c
# arm via the REAL script, writing config to the journal.
env HOME="$FHOME" GARDEN=testhost GARDEN_STATE="$STATE" GARDEN_ROOT="$REPO" \
    JOURNAL_REMOTE="$JBARE" JOURNAL_BRANCH=journal2 GARDEN_NO_MAINTAINER_ALERT=1 \
    bash "$JOBS/set-transcripts-remote.sh" "$TBARE" >/dev/null 2>&1 \
  && ok "set-transcripts-remote.sh wrote config to the journal" \
  || bad "set-transcripts-remote.sh failed"
# a finished job transcript, spooled by the hook, then removed from projects.
mk_session "$FHOME/.claude/projects/-scratch-gardener-wt-build-thing/sid-c.jsonl"
spool_hook "$FHOME/.claude/projects/-scratch-gardener-wt-build-thing/sid-c.jsonl" build-thing
rm -f "$FHOME/.claude/projects/-scratch-gardener-wt-build-thing/sid-c.jsonl"
run_capture; rcC=$?
[ "$rcC" -eq 0 ] && ok "armed capture exits 0" || bad "armed capture rc=$rcC ($(tail -1 "$TR/last.err"))"
if tview; then
  f="$TR/tv/transcripts/testhost/-scratch-gardener-wt-build-thing/sid-c.jsonl.gz"
  [ -f "$f" ] && ok "spooled transcript archived at transcripts/testhost/…/sid-c.jsonl.gz" \
              || bad "archived transcript path missing"
  # index row carries the back-recoverable job base.
  if [ -f "$TR/tv/index/testhost.tsv" ] && grep -q $'\tbuild-thing\t' "$TR/tv/index/testhost.tsv"; then
    ok "index/testhost.tsv row records job base 'build-thing'"
  else bad "index row missing or base not recorded"; fi
  # D: redaction.
  body="$(gzip -dc "$f" 2>/dev/null)"
  if ! grep -q "$GHP" <<<"$body" && ! grep -q "$SKANT" <<<"$body" \
     && ! grep -q "abcdefGHIJKL0123456789xyz" <<<"$body" \
     && grep -q 'REDACTED' <<<"$body"; then
    ok "gh/anthropic/Bearer secrets masked in the stored transcript"
  else bad "redaction failed (secret survived in archive)"; fi
else bad "transcripts2 branch not created on arm+drain"; fi
[ -s "$STATE/transcripts/spool/pending.tsv" ] \
  && bad "spool NOT cleared after a verified push" \
  || ok "spool cleared after a verified push"

# ============================================================================
hr; echo "SCENARIO E/F — IDLE GATING + CHANGED-SESSION RE-CAPTURE"; hr
fresh e
SESS="$FHOME/.claude/projects/-home-user-proj/sid-live.jsonl"
mk_session "$SESS"
# fresh mtime → within the idle window → NOT captured.
run_capture GARDEN_TRANSCRIPTS_REMOTE="$TBARE" GARDEN_TRANSCRIPT_IDLE_SECS=3600 >/dev/null 2>&1
tview 2>/dev/null && ig=$(find "$TR/tv/transcripts" -name 'sid-live.jsonl.gz' 2>/dev/null | wc -l) || ig=0
[ "$ig" -eq 0 ] && ok "fresh (non-idle) session NOT captured" || bad "fresh session captured (idle gate failed)"
# age it past the window → captured.
touch -d '3 hours ago' "$SESS"
run_capture GARDEN_TRANSCRIPTS_REMOTE="$TBARE" GARDEN_TRANSCRIPT_IDLE_SECS=3600 >/dev/null 2>&1
tview 2>/dev/null && ag=$(find "$TR/tv/transcripts" -name 'sid-live.jsonl.gz' 2>/dev/null | wc -l) || ag=0
[ "$ag" -eq 1 ] && ok "aged (idle) session captured" || bad "aged session not captured"
# F: unchanged → not re-captured (ledger); count index rows for the sid.
run_capture GARDEN_TRANSCRIPTS_REMOTE="$TBARE" GARDEN_TRANSCRIPT_IDLE_SECS=3600 >/dev/null 2>&1
tview 2>/dev/null
rows1=$(grep -c $'\tsid-live\t' "$TR/tv/index/testhost.tsv" 2>/dev/null || echo 0)
[ "$rows1" -eq 1 ] && ok "unchanged idle session NOT re-captured (ledger match)" || bad "re-captured unchanged session (rows=$rows1)"
# grow it, re-age → re-captured.
printf '{"type":"assistant","text":"more work"}\n' >> "$SESS"
touch -d '3 hours ago' "$SESS"
run_capture GARDEN_TRANSCRIPTS_REMOTE="$TBARE" GARDEN_TRANSCRIPT_IDLE_SECS=3600 >/dev/null 2>&1
tview 2>/dev/null
rows2=$(grep -c $'\tsid-live\t' "$TR/tv/index/testhost.tsv" 2>/dev/null || echo 0)
[ "$rows2" -eq 2 ] && ok "grown idle session re-captured (second index row)" || bad "grown session not re-captured (rows=$rows2)"

# ============================================================================
hr; echo "SCENARIO G — CAS RETRY against a racing peer commit"; hr
fresh g
# seed transcripts2 with an initial commit so the clone resets to a real tip.
gs="$TR/g/tseed"; git init -q "$gs"; git -C "$gs" checkout -q -b transcripts2
mkdir -p "$gs/index"; echo seed > "$gs/index/.gitkeep"
git -C "$gs" add -A; git -C "$gs" "${git_id[@]}" commit -q -m seed
git -C "$gs" remote add origin "$TBARE"; git -C "$gs" push -q -u origin transcripts2
# a racing push seam: on its FIRST call, a peer lands a commit on transcripts2 and
# we report the push as rejected (exit 1); subsequent calls do the real push.
PUSHCMD="$TR/g/pushcmd.sh"
cat > "$PUSHCMD" <<PUSHEOF
#!/bin/bash
set -u
cnt="$TR/g/pushcnt"; n=\$(cat "\$cnt" 2>/dev/null || echo 0); echo \$((n+1)) > "\$cnt"
if [ "\$n" -eq 0 ]; then
  pw="$TR/g/peerwt"; rm -rf "\$pw"
  git clone -q --branch transcripts2 "$TBARE" "\$pw" 2>/dev/null
  mkdir -p "\$pw/transcripts/peerhost/-p"; echo peer | gzip -n > "\$pw/transcripts/peerhost/-p/sid-peer.jsonl.gz"
  git -C "\$pw" add -A; git -C "\$pw" ${git_id[*]} commit -q -m 'peer race'
  git -C "\$pw" push -q origin transcripts2
  exit 1
fi
git -C "\$GARDEN_TRANSCRIPTS_PUSH_DIR" push -q origin "HEAD:\$GARDEN_TRANSCRIPTS_PUSH_BRANCH"
PUSHEOF
chmod +x "$PUSHCMD"
GSESS="$FHOME/.claude/projects/-home-user-g/sid-g.jsonl"
mk_session "$GSESS"; touch -d '3 hours ago' "$GSESS"
run_capture GARDEN_TRANSCRIPTS_REMOTE="$TBARE" GARDEN_TRANSCRIPT_IDLE_SECS=3600 \
            GARDEN_TRANSCRIPTS_PUSH_CMD="$PUSHCMD"; rcG=$?
[ "$rcG" -eq 0 ] && ok "capture survives a racing peer push (exits 0)" || bad "capture rc=$rcG under race ($(tail -1 "$TR/last.err"))"
[ "$(cat "$TR/g/pushcnt" 2>/dev/null || echo 0)" -ge 2 ] && ok "push retried after the CAS race" || bad "push not retried"
if tview; then
  { [ -f "$TR/tv/transcripts/peerhost/-p/sid-peer.jsonl.gz" ] \
    && find "$TR/tv/transcripts/testhost" -name 'sid-g.jsonl.gz' | grep -q .; } \
    && ok "both the peer's and our transcript are on transcripts2 (reapply preserved the peer)" \
    || bad "CAS reapply lost a side (peer or ours missing)"
else bad "transcripts2 unreadable after the race"; fi

# ============================================================================
hr
echo "TOTAL: $PASS passed, $FAIL failed"
[ "$FAIL" -eq 0 ] && { rm -rf "$TR"; exit 0; } || exit 1
