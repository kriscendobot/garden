#!/bin/bash
# mentor-transient-backoff-test.sh — a sustained transient provider outage retries
# every tick but WARNs on a bounded exponential backoff, then emits ONE recovery
# notice when it clears. Guards the silent-until-error contract against the old
# every-tick WARN loop.
set -euo pipefail
export GARDEN_TEST=1
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
JOBS="$(cd "$HERE/.." && pwd)"
TR="$(mktemp -d "${TMPDIR:-/var/tmp}/garden-mentor-backoff.XXXXXX")"
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

# journalctl stub: nothing to report, so the digest is stable across ticks.
cat > "$BIN/journalctl" <<'EOF'
#!/bin/sh
echo '-- No entries --'
EOF
# Transient handler: a signature is_transient_claude_signature matches ("overloaded")
# on a non-empty capture with rc=1 — the classic provider-outage shape.
cat > "$TR/transient-handler" <<'EOF'
#!/bin/sh
printf '%s\n' "$1" >> "$CALL_LOG"
echo "Error: overloaded_error: server is overloaded, please retry" >&2
exit 1
EOF
# Success handler: the outage has cleared.
cat > "$TR/ok-handler" <<'EOF'
#!/bin/sh
printf '%s\n' "$1" >> "$CALL_LOG"
exit 0
EOF
chmod +x "$BIN/journalctl" "$TR/transient-handler" "$TR/ok-handler"
export CALL_LOG="$TR/calls"

MLOG="$TR/mentor.log"
run_mentor() {  # <handler> ; appends this run's stderr to $MLOG
  local handler="$1"
  env PATH="$BIN:$PATH" GARDEN=testhost GARDEN_ROOT="$(cd "$JOBS/../.." && pwd)" \
    GARDEN_STATE="$TR/state" JOURNAL_REMOTE="$BARE" JOURNAL_BRANCH=journal2 \
    GARDEN_MENTOR_HANDLER="$handler" GARDEN_MENTOR_OUTAGE_BACKOFF_CAP=8 \
    "$JOBS/mentor.sh" >/dev/null 2>>"$MLOG"
}

# --- 10 consecutive transient ticks ------------------------------------------
for _ in $(seq 1 10); do
  rc=0; run_mentor "$TR/transient-handler" || rc=$?
  [ "$rc" -eq 0 ] || { echo "FAIL: transient tick exited nonzero (rc=$rc)"; exit 1; }
done

# Retry behavior retained: the handler ran every tick and markers never advanced.
[ "$(wc -l < "$CALL_LOG")" -eq 10 ] \
  || { echo "FAIL: handler did not run on all 10 transient ticks"; exit 1; }
if grep -qx 'entries/failure.md' "$TR/state/mentor/seen" 2>/dev/null; then
  echo 'FAIL: transient outage wrongly advanced the seen marker'; exit 1
fi

# Backoff: with cap=8, warnings fire at ticks 1,2,4,8 → exactly 4, not 10.
warns="$(grep -c 'transient outage tick #' "$MLOG" || true)"
[ "$warns" -eq 4 ] \
  || { echo "FAIL: expected 4 backed-off warnings over 10 ticks, got $warns"; sed -n '/transient outage tick/p' "$MLOG"; exit 1; }

# --- recovery -----------------------------------------------------------------
run_mentor "$TR/ok-handler"
rec="$(grep -c 'transient provider outage cleared' "$MLOG" || true)"
[ "$rec" -eq 1 ] \
  || { echo "FAIL: expected exactly 1 recovery notice, got $rec"; exit 1; }
grep -qx 'entries/failure.md' "$TR/state/mentor/seen" \
  || { echo 'FAIL: recovery run did not advance the seen marker'; exit 1; }
[ -f "$TR/state/mentor/transient-outage" ] \
  && { echo 'FAIL: recovery did not clear the outage episode state'; exit 1; }

# --- no false recovery when there was no outage -------------------------------
: > "$MLOG"
printf '%s\n' 'a fresh input' > "$SEED/entries/second.md"
git -C "$SEED" add entries/second.md
git -C "$SEED" -c user.name=test -c user.email=test@localhost commit -q -m second
git -C "$SEED" push -q origin journal2
run_mentor "$TR/ok-handler"
[ "$(grep -c 'transient provider outage cleared' "$MLOG" || true)" -eq 0 ] \
  || { echo 'FAIL: emitted a recovery notice with no outage open'; exit 1; }

echo 'PASS: sustained transient outage retries every tick, warns on bounded backoff, and recovers once'
