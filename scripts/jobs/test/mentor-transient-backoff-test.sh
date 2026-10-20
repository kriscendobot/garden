#!/bin/bash
# mentor-transient-backoff-test.sh — a sustained transient provider outage defers
# the handler on a persisted exponential retry deadline (fewer provider calls than
# timer ticks), WARNs on a bounded exponential backoff, keeps the input markers
# unadvanced, then emits ONE recovery notice and resets the deadline when a real
# verdict lands. Guards silent-until-error against the old every-tick retry loop.
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
OSTATE="$TR/state/mentor/transient-outage"
NOW=1000000
run_mentor() {  # <handler> ; appends this run's stderr to $MLOG
  local handler="$1"
  env PATH="$BIN:$PATH" GARDEN=testhost GARDEN_ROOT="$(cd "$JOBS/../.." && pwd)" \
    GARDEN_STATE="$TR/state" JOURNAL_REMOTE="$BARE" JOURNAL_BRANCH=journal2 \
    GARDEN_MENTOR_HANDLER="$handler" GARDEN_MENTOR_OUTAGE_BACKOFF_CAP=8 \
    GARDEN_MENTOR_OUTAGE_RETRY_BASE_SECS=1500 GARDEN_MENTOR_OUTAGE_RETRY_MAX_SECS=6000 \
    GARDEN_MENTOR_NOW="$NOW" \
    "$JOBS/mentor.sh" >/dev/null 2>>"$MLOG"
}
calls() { wc -l < "$CALL_LOG" 2>/dev/null || echo 0; }

# --- 10 consecutive transient timer ticks, 30 minutes apart --------------------
# Deadlines after attempts 1..4: +1500, +3000, +6000, +6000 (capped). With ticks
# at t=0,1800,…,16200 the handler is attempted at t=0, 1800, 5400, 12600 only.
for _ in $(seq 1 10); do
  rc=0; run_mentor "$TR/transient-handler" || rc=$?
  [ "$rc" -eq 0 ] || { echo "FAIL: transient tick exited nonzero (rc=$rc)"; exit 1; }
  NOW=$((NOW + 1800))
done

# Provider calls are reduced: 4 handler attempts over 10 ticks, not 10.
[ "$(calls)" -eq 4 ] \
  || { echo "FAIL: expected 4 handler attempts over 10 outage ticks, got $(calls)"; exit 1; }
if grep -qx 'entries/failure.md' "$TR/state/mentor/seen" 2>/dev/null; then
  echo 'FAIL: transient outage wrongly advanced the seen marker'; exit 1
fi
[ -e "$TR/state/mentor/journalctl-since" ] \
  && { echo 'FAIL: transient outage wrongly advanced the journalctl marker'; exit 1; }
# The persisted deadline is the last attempt (t0+12600) plus the capped 6000s.
read -r _ ocount odeadline < "$OSTATE"
[ "$ocount" -eq 4 ] && [ "$odeadline" -eq $((1000000 + 12600 + 6000)) ] \
  || { echo "FAIL: unexpected outage state: $(cat "$OSTATE")"; exit 1; }

# Backoff: with cap=8, warnings fire at attempts 1,2,4 → exactly 3.
warns="$(grep -c 'transient outage tick #' "$MLOG" || true)"
[ "$warns" -eq 3 ] \
  || { echo "FAIL: expected 3 backed-off warnings over 4 attempts, got $warns"; sed -n '/transient outage tick/p' "$MLOG"; exit 1; }

# Even a healthy provider is not called before the deadline (NOW is t0+18000).
run_mentor "$TR/ok-handler"
[ "$(calls)" -eq 4 ] || { echo 'FAIL: handler invoked before its retry deadline'; exit 1; }
grep -qx 'entries/failure.md' "$TR/state/mentor/seen" 2>/dev/null \
  && { echo 'FAIL: deferred tick advanced the seen marker'; exit 1; }

# --- recovery -----------------------------------------------------------------
NOW=$((1000000 + 12600 + 6000))
run_mentor "$TR/ok-handler"
[ "$(calls)" -eq 5 ] || { echo 'FAIL: handler not retried once the deadline elapsed'; exit 1; }
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

# --- all-providers-unavailable is transient, not a die -------------------------
# mentor-claude.sh's own FATAL when every configured provider reports rc=10
# (here: an unreachable local-inference endpoint and a failed provider run, with
# no high-water/overload wording the shared classifier would catch).
cat > "$TR/no-provider-handler" <<'EOH'
#!/bin/sh
printf '%s\n' "$1" >> "$CALL_LOG"
echo "[mentor] mentor local provider unavailable or quota-limited (rc=7): curl: (7) Failed to connect to 127.0.0.1 port 11434" >&2
echo "[mentor] mentor provider 'local' unavailable; trying the next configured provider" >&2
echo "[mentor] mentor provider 'anthropic' unavailable; trying the next configured provider" >&2
echo "[mentor] FATAL: no configured mentor inference provider was available" >&2
exit 1
EOH
chmod +x "$TR/no-provider-handler"
: > "$MLOG"
printf '%s\n' 'a third input' > "$SEED/entries/third.md"
git -C "$SEED" add entries/third.md
git -C "$SEED" -c user.name=test -c user.email=test@localhost commit -q -m third
git -C "$SEED" push -q origin journal2
rc=0; run_mentor "$TR/no-provider-handler" || rc=$?
[ "$rc" -eq 0 ] || { echo "FAIL: all-providers-unavailable tick died (rc=$rc)"; cat "$MLOG"; exit 1; }
grep -q 'transient outage tick #' "$MLOG" \
  || { echo 'FAIL: all-providers-unavailable was not noted as a transient outage'; cat "$MLOG"; exit 1; }
if grep -qx 'entries/third.md' "$TR/state/mentor/seen" 2>/dev/null; then
  echo 'FAIL: all-providers-unavailable wrongly advanced the seen marker'; exit 1
fi
# The recovery's real verdict reset the episode: this fresh outage starts over at
# attempt 1 with the base delay, not the previous episode's capped one.
read -r _ ocount odeadline < "$OSTATE"
[ "$ocount" -eq 1 ] && [ "$odeadline" -eq $((NOW + 1500)) ] \
  || { echo "FAIL: outage deadline not reset after a real verdict: $(cat "$OSTATE")"; exit 1; }

# --- a real (non-transient) verdict also clears the deadline ---------------------
cat > "$TR/real-handler" <<'EOH'
#!/bin/sh
printf '%s\n' "$1" >> "$CALL_LOG"
echo "TypeError: cannot read property of undefined at line 42" >&2
exit 1
EOH
chmod +x "$TR/real-handler"
NOW=$((NOW + 1500))
rc=0; run_mentor "$TR/real-handler" || rc=$?
[ "$rc" -ne 0 ] || { echo 'FAIL: genuine handler defect did not die'; exit 1; }
[ -f "$OSTATE" ] && { echo 'FAIL: a real verdict left the outage deadline armed'; exit 1; }

echo 'PASS: sustained transient outage defers handler retries on an exponential deadline, warns on bounded backoff, and recovers once'
