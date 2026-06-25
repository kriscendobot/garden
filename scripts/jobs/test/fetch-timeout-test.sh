#!/bin/bash
# fetch-timeout-test.sh — regression guard for the stuck-fetch hardening.
#
# SECOND outage (2026-06-25): dozens of `git fetch origin journal2` hung 5–15 min
# across the fleet. git has NO default fetch IO timeout, so a half-open
# connection after a transient blip stalls a fetch FOREVER; and since clones
# serialize behind an flock, a stuck fetch holds its clone lock and wedges every
# producer behind it. The hardening bounds BOTH:
#   1. journal_fetch wraps every fetch in `timeout` + backoff/retry, so a stalled
#      fetch is killed and retried, never an unbounded hang.
#   2. clone_lock uses `flock -w`, so a waiter behind a stuck holder times out and
#      backs off instead of blocking forever.
#
# Both checks assert the operation FINISHES well under the time it would take to
# hang, using a fake `git` on PATH (sleeps on `fetch`) and a real held flock.
#
# Usage: fetch-timeout-test.sh
set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
JOBS="$(cd "$HERE/.." && pwd)"
PASS=0; FAIL=0
ok()  { echo "  PASS: $*"; PASS=$((PASS+1)); }
bad() { echo "  FAIL: $*"; FAIL=$((FAIL+1)); }
hr()  { echo "----------------------------------------------------------------"; }

TR=/home/kris/.garden-fetch-test
rm -rf "$TR"; mkdir -p "$TR/bin"

# A fake `git` that hangs for 30s on any `fetch` subcommand and execs the real
# git for everything else. The timeout wrapper must kill it long before 30s.
REAL_GIT="$(command -v git)"
cat > "$TR/bin/git" <<EOF
#!/bin/bash
for a in "\$@"; do [ "\$a" = fetch ] && { sleep 30; exit 0; }; done
exec "$REAL_GIT" "\$@"
EOF
chmod +x "$TR/bin/git"

# Source the real helpers, then put the fake git first on PATH.
# shellcheck source=../common.sh
source "$JOBS/common.sh"
export PATH="$TR/bin:$PATH"

# ============================================================================
hr; echo "SUBTEST 1 — journal_fetch times out + retries instead of hanging"; hr
# 1s timeout, 2 attempts: a healthy run is ~2s + backoff; a HANG would be 30s+.
export GARDEN_FETCH_TIMEOUT=1 GARDEN_FETCH_RETRIES=2
start="$(date +%s)"
if journal_fetch "$TR" >/dev/null 2>&1; then rc=0; else rc=1; fi
elapsed=$(( $(date +%s) - start ))
if [ "$rc" -ne 0 ]; then
  ok "journal_fetch reported failure (rc=$rc) on a stalled fetch"
else
  bad "journal_fetch returned success on a stalled fetch (should fail)"
fi
if [ "$elapsed" -lt 15 ]; then
  ok "journal_fetch returned in ${elapsed}s (bounded; a hang would be >=30s)"
else
  bad "journal_fetch took ${elapsed}s — it HUNG instead of timing out"
fi

# ============================================================================
hr; echo "SUBTEST 2 — clone_lock waiter times out instead of blocking forever"; hr
# Hold the clone lock from a background process for 20s, then race a waiter with a
# 1s wait + 1 retry. The waiter must give up (non-zero) in ~a couple seconds, not
# block the full 20s behind the holder.
LOCKDIR="$TR/clone"; mkdir -p "$LOCKDIR"
LF="$LOCKDIR.lock"   # _clone_lockfile uses "<dir>.lock"
( exec {h}>"$LF"; flock "$h"; sleep 20 ) & holder=$!
sleep 1  # let the holder acquire first
start="$(date +%s)"
if ( export GARDEN_LOCK_WAIT=1 GARDEN_LOCK_RETRIES=1
     clone_lock "$LOCKDIR" ) >/dev/null 2>&1; then wrc=0; else wrc=1; fi
elapsed=$(( $(date +%s) - start ))
kill "$holder" 2>/dev/null || true; wait "$holder" 2>/dev/null || true
if [ "$wrc" -ne 0 ]; then
  ok "clone_lock waiter gave up (rc=$wrc) rather than blocking on a stuck holder"
else
  bad "clone_lock waiter acquired the lock — the holder's flock did not exclude it"
fi
if [ "$elapsed" -lt 15 ]; then
  ok "clone_lock waiter returned in ${elapsed}s (bounded; the holder ran 20s)"
else
  bad "clone_lock waiter took ${elapsed}s — it BLOCKED on the holder"
fi

# ============================================================================
hr
rm -rf "$TR"
echo "RESULTS: $PASS passed, $FAIL failed"
[ "$FAIL" -eq 0 ]
