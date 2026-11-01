#!/bin/bash
# watchman-broadcast-test.sh — the reread broadcast survives producer-lock contention.
#
# 2026-11-01 04:32: send-msg.sh gave up on the producer journal clone lock and
# watchman.sh died on "could not broadcast reread notice", failing the unit. The
# broadcast now retries a transient lock failure (rc 75, or clone_lock's hard
# give-up diagnostic), WARNs and exits 0 when it persists, and leaves the seen
# marker unadvanced so the next tick re-attempts. Any other send failure stays
# fatal, and a landed broadcast records the advance before the best-effort handler.
#
# Hermetic: a throwaway git ROOT, a mock GARDEN_WATCHMAN_SEND_MSG, a no-op handler.
#
# Usage: watchman-broadcast-test.sh
set -euo pipefail
export GARDEN_TEST=1
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
JOBS="$(cd "$HERE/.." && pwd)"
WATCHMAN="$JOBS/watchman.sh"
PASS=0; FAIL=0
ok()  { echo "  PASS: $*"; PASS=$((PASS+1)); }
bad() { echo "  FAIL: $*"; FAIL=$((FAIL+1)); }
hr()  { echo "----------------------------------------------------------------"; }

unset $(compgen -v 2>/dev/null | grep -E '^(GARDEN_|JOURNAL_|SELF_HEAL_|XDG_)' || true) 2>/dev/null || true

TR="$(mktemp -d "${TMPDIR:-/tmp}/garden-watchman-test.XXXXXX")"
trap 'rm -rf "$TR"' EXIT
git init -q "$TR/root"
git -C "$TR/root" -c user.name=test -c user.email=test@localhost commit -q --allow-empty -m seed
HEAD_SHA="$(git -C "$TR/root" rev-parse HEAD)"
SEEN="$TR/state/watchman/seen-main2"

# The mock send pops one scripted outcome per call from $TR/script:
#   ok | busy75 | busyhard | fatal
cat > "$TR/send-mock.sh" <<MOCK
#!/bin/bash
cat >/dev/null
echo call >> "$TR/calls"
outcome="\$(head -1 "$TR/script")"; sed -i 1d "$TR/script"
case "\$outcome" in
  ok)       exit 0 ;;
  busy75)   echo "repository lock for x busy; skipping tick (rc=75)" >&2; exit 75 ;;
  busyhard) echo "FATAL: cannot acquire clone lock $TR/producer/journal.lock after 3 waits of 60s and 0 reclaim attempt(s) (a live holder is still busy; if it is crashed, rm -f x)" >&2; exit 1 ;;
  *)        echo "FATAL: illegal address" >&2; exit 1 ;;
esac
MOCK
chmod +x "$TR/send-mock.sh"
cat > "$TR/handler.sh" <<HANDLER
#!/bin/bash
echo handled >> "$TR/handled"
HANDLER
chmod +x "$TR/handler.sh"

run_watchman() {  # run_watchman <outcome>... ; fills $OUT/$RC/$CALLS
  printf '%s\n' "$@" > "$TR/script"; : > "$TR/calls"; rm -f "$TR/handled"
  set +e
  OUT="$(env GARDEN_ROOT="$TR/root" GARDEN_STATE="$TR/state" GARDEN_SCRATCH="$TR/scratch" \
             GARDEN=testhost GARDEN_LEADER=testhost GARDEN_MAIN_BRANCH=main2 \
             GARDEN_WATCHMAN_SEND_MSG="$TR/send-mock.sh" GARDEN_WATCH_HANDLER="$TR/handler.sh" \
             GARDEN_BACKOFF_BASE_MS=1 GARDEN_BACKOFF_CAP_MS=1 \
             bash "$WATCHMAN" 2>&1)"
  RC=$?
  set -e
  CALLS="$(wc -l < "$TR/calls")"
}

hr; echo "STATIC"; hr
bash -n "$WATCHMAN" && ok "watchman.sh parses" || bad "watchman.sh syntax error"

hr; echo "LOCK-BUSY — persistent contention WARNs, exits 0, leaves SEEN for the next tick"; hr
rm -rf "$TR/state"
run_watchman busy75 busyhard busy75
[ "$RC" -eq 0 ] && ok "exit 0 (unit not failed)" || bad "exit $RC: $OUT"
[ "$CALLS" -eq 3 ] && ok "retried the send 3 times" || bad "send called $CALLS times"
grep -q 'WARN: producer journal lock still busy' <<<"$OUT" && ok "WARN logged" || bad "no WARN: $OUT"
[ ! -e "$SEEN" ] && ok "SEEN not advanced" || bad "SEEN advanced despite no broadcast"
[ ! -e "$TR/handled" ] && ok "handler not run" || bad "handler ran without a broadcast"

hr; echo "RETRY — a transient failure followed by success broadcasts and advances SEEN"; hr
run_watchman busyhard ok
[ "$RC" -eq 0 ] && ok "exit 0" || bad "exit $RC: $OUT"
[ "$CALLS" -eq 2 ] && ok "succeeded on the second attempt" || bad "send called $CALLS times"
[ "$(cat "$SEEN" 2>/dev/null)" = "$HEAD_SHA" ] && ok "SEEN advanced to HEAD" || bad "SEEN not advanced"
[ -e "$TR/handled" ] && ok "handler ran" || bad "handler did not run"

hr; echo "NO-CHANGE — the next tick does not re-broadcast"; hr
run_watchman ok
[ "$RC" -eq 0 ] && [ "$CALLS" -eq 0 ] && ok "no broadcast once SEEN matches" || bad "rc=$RC calls=$CALLS"

hr; echo "FATAL — a non-lock send failure still fails the unit, without retry"; hr
rm -rf "$TR/state"
run_watchman fatal ok
[ "$RC" -ne 0 ] && ok "non-zero exit" || bad "exit 0 on a real failure"
[ "$CALLS" -eq 1 ] && ok "no retry on a non-lock failure" || bad "send called $CALLS times"
grep -q 'could not broadcast reread notice' <<<"$OUT" && ok "FATAL logged" || bad "no FATAL: $OUT"
[ ! -e "$SEEN" ] && ok "SEEN not advanced" || bad "SEEN advanced on failure"

hr; echo "RESULT: $PASS passed, $FAIL failed"; hr
[ "$FAIL" -eq 0 ]
