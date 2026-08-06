#!/bin/bash
# mentor-rejection-backstop-test.sh — identical semantic rejects cannot loop forever.
set -euo pipefail
export GARDEN_TEST=1
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
JOBS="$(cd "$HERE/.." && pwd)"
TR="$(mktemp -d "${TMPDIR:-/var/tmp}/garden-mentor-backstop.XXXXXX")"
trap 'rm -rf "$TR"' EXIT
BARE="$TR/journal.git"; SEED="$TR/seed"; BIN="$TR/bin"
mkdir -p "$BIN" "$TR/state"

git init -q --bare "$BARE"
git init -q "$SEED"; git -C "$SEED" checkout -q -b journal2
mkdir -p "$SEED/entries"
printf '%s\n' 'repeatable failure input' > "$SEED/entries/failure.md"
git -C "$SEED" add entries/failure.md
git -C "$SEED" -c user.name=test -c user.email=test@localhost commit -q -m seed
git -C "$SEED" remote add origin "$BARE"; git -C "$SEED" push -q -u origin journal2

cat > "$BIN/journalctl" <<'EOF'
#!/bin/sh
echo '-- No entries --'
EOF
cat > "$TR/reject-handler" <<'EOF'
#!/bin/sh
printf '%s\n' "$1" >> "$CALL_LOG"
echo "FATAL: mentor provider 'test' returned malformed semantic output (test rejection); refusing fallback" >&2
exit 1
EOF
cat > "$TR/alert" <<'EOF'
#!/bin/sh
printf '%s\n' "$1" >> "$ALERT_LOG"
EOF
chmod +x "$BIN/journalctl" "$TR/reject-handler" "$TR/alert"
export CALL_LOG="$TR/calls" ALERT_LOG="$TR/alerts"

run_mentor() {
  env PATH="$BIN:$PATH" GARDEN=testhost GARDEN_ROOT="$(cd "$JOBS/../.." && pwd)" \
    GARDEN_STATE="$TR/state" JOURNAL_REMOTE="$BARE" JOURNAL_BRANCH=journal2 \
    GARDEN_MENTOR_HANDLER="$TR/reject-handler" GARDEN_MENTOR_REJECT_THRESHOLD=3 \
    GARDEN_ALERT_CMD="$TR/alert" "$JOBS/mentor.sh" >/dev/null 2>&1
}

rc1=0; run_mentor || rc1=$?
rc2=0; run_mentor || rc2=$?
rc3=0; run_mentor || rc3=$?
if ! { [ "$rc1" -ne 0 ] && [ "$rc2" -ne 0 ] && [ "$rc3" -eq 0 ]; }; then
  echo "FAIL: expected reject rc sequence nonzero,nonzero,zero; got $rc1,$rc2,$rc3"; exit 1
fi
if ! { [ "$(sort -u "$CALL_LOG" | wc -l)" -eq 1 ] && [ "$(wc -l < "$CALL_LOG")" -eq 3 ]; }; then
  echo 'FAIL: handler did not reject the same digest exactly three times'; exit 1
fi
grep -qx 'entries/failure.md' "$TR/state/mentor/seen" \
  || { echo 'FAIL: rejection threshold did not advance the seen marker'; exit 1; }
[ "$(wc -l < "$ALERT_LOG")" -eq 1 ] \
  || { echo 'FAIL: rejection threshold did not escalate exactly once'; exit 1; }
run_mentor
[ "$(wc -l < "$CALL_LOG")" -eq 3 ] \
  || { echo 'FAIL: consumed digest was run again after the backstop'; exit 1; }
echo 'PASS: third identical semantic rejection advances markers, alerts once, and stops rerunning the digest'
