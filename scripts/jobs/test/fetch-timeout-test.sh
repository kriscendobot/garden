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
hr; echo "SUBTEST 3 — sync_clone classifies a DNS/connectivity outage as EX_TEMPFAIL (75)"; hr
# An outage surfaces as git exit 128 with a recognizable resolver/remote
# diagnostic. sync_clone must exit GARDEN_OFFLINE_RC (75), NOT die(1), so the
# wrapper treats a fleet-wide blip as a transient skip, not a per-worker failure.
cat > "$TR/bin/offline-fetch" <<'EOF'
#!/bin/bash
echo "ssh: Could not resolve hostname github.com: Temporary failure in name resolution" >&2
echo "fatal: Could not read from remote repository." >&2
exit 128
EOF
chmod +x "$TR/bin/offline-fetch"
OCLONE="$TR/oclone"; mkdir -p "$OCLONE"
rc=0
( export GARDEN_FETCH_RETRIES=1 GARDEN_FETCH_CMD="$TR/bin/offline-fetch"
  sync_clone "$OCLONE" ) >/dev/null 2>&1 || rc=$?
if [ "$rc" -eq 75 ]; then
  ok "sync_clone exited EX_TEMPFAIL ($rc) on a resolver outage"
else
  bad "sync_clone exited $rc on a resolver outage (expected 75)"
fi

# ============================================================================
hr; echo "SUBTEST 4 — sync_clone still dies (rc=1) on a genuine repo error"; hr
# A non-outage 128 (e.g. a missing ref) is a real error: it must keep dying so a
# true fault is never silently masked as a transient skip.
cat > "$TR/bin/realerr-fetch" <<'EOF'
#!/bin/bash
echo "fatal: couldn't find remote ref journal2" >&2
exit 128
EOF
chmod +x "$TR/bin/realerr-fetch"
RCLONE="$TR/rclone"; mkdir -p "$RCLONE"
rc=0
( export GARDEN_FETCH_RETRIES=1 GARDEN_FETCH_CMD="$TR/bin/realerr-fetch"
  sync_clone "$RCLONE" ) >/dev/null 2>&1 || rc=$?
if [ "$rc" -eq 1 ]; then
  ok "sync_clone died (rc=$rc) on a genuine repo error, not masked as transient"
else
  bad "sync_clone exited $rc on a genuine repo error (expected 1 via die)"
fi

# ============================================================================
hr; echo "SUBTEST 5 — sync_clone offline path survives a BARE set -e caller"; hr
# REGRESSION GUARD. SUBTEST 3 invokes sync_clone as `( ... sync_clone ) || rc=$?`,
# which suspends set -e for the whole subshell — so it never exercised the path
# the real claim/complete callers use: a BARE `sync_clone "$DIR"` under an active
# set -e. In that context two separate set -e trip points used to kill the process
# with the raw fetch rc (128) BEFORE the offline classification ran: (a) the
# `GARDEN_FETCH_STDERR="$(...failing-fetch...)"` assignment inside journal_fetch,
# and (b) the `journal_fetch "$dir"; rc=$?` call inside sync_clone (a function
# returning non-zero is itself a set -e exit). Both are now captured through an
# `if`, so the EX_TEMPFAIL (75) skip is actually reachable. Run sync_clone from a
# child shell that has `set -e` ON and calls it BARE; the child must exit 75.
cat > "$TR/bin/bare-sync.sh" <<EOF
#!/bin/bash
set -euo pipefail
source "$JOBS/common.sh"
export GARDEN_FETCH_RETRIES=1 GARDEN_FETCH_CMD="$TR/bin/offline-fetch"
sync_clone "$TR/bareclone"
echo "REACHED-PAST-SYNC"   # must NOT print: sync_clone exits 75 before here
EOF
chmod +x "$TR/bin/bare-sync.sh"
mkdir -p "$TR/bareclone"
set +e; out="$("$TR/bin/bare-sync.sh" 2>&1)"; brc=$?; set -e
if [ "$brc" -eq 75 ] && ! grep -q REACHED-PAST-SYNC <<<"$out"; then
  ok "bare set -e caller: sync_clone exited EX_TEMPFAIL (75), classification reachable"
else
  bad "bare set -e caller: sync_clone exited $brc (expected 75; offline path not reachable from a bare caller)"
fi

# ============================================================================
hr; echo "SUBTEST 6 — sync_clone classifies a transient outage on the RESET path as EX_TEMPFAIL (75)"; hr
# The fetch can SUCCEED yet the subsequent `git reset --hard origin/journal2`
# still fail 128 on a momentary network/ref blip. Under set -e that raw 128 would
# escape classification. sync_clone must guard the reset too: on a reset failure
# it re-fetches once, and if THAT fetch trips an offline signature it exits 75 —
# the same EX_TEMPFAIL the fetch path yields — so the loop skips the tick.
#
# Drive it with a stateful fake `git` on PATH: fetch #1 succeeds (so we reach the
# reset), `reset` fails 128, and fetch #2 (the re-fetch) reports a resolver
# outage. Everything else execs the real git.
RESET_COUNTER="$TR/reset-fetch-count"; echo 0 > "$RESET_COUNTER"
cat > "$TR/bin/git" <<EOF
#!/bin/bash
sub=
for a in "\$@"; do
  case "\$a" in fetch|reset|clean) sub="\$a"; break ;; esac
done
case "\$sub" in
  fetch)
    n=\$(cat "$RESET_COUNTER"); n=\$((n+1)); echo "\$n" > "$RESET_COUNTER"
    if [ "\$n" -ge 2 ]; then
      echo "ssh: Could not resolve hostname github.com: Temporary failure in name resolution" >&2
      echo "fatal: Could not read from remote repository." >&2
      exit 128
    fi
    exit 0 ;;
  reset)
    echo "fatal: Could not read from remote repository." >&2
    exit 128 ;;
  *) exec "$REAL_GIT" "\$@" ;;
esac
EOF
chmod +x "$TR/bin/git"
SCLONE="$TR/sclone"; mkdir -p "$SCLONE"
rc=0
# No GARDEN_FETCH_CMD: journal_fetch uses the PATH `git` (our stateful fake).
( export GARDEN_FETCH_RETRIES=1 GARDEN_FETCH_TIMEOUT=5
  sync_clone "$SCLONE" ) >/dev/null 2>&1 || rc=$?
if [ "$rc" -eq 75 ]; then
  ok "sync_clone exited EX_TEMPFAIL ($rc) on a transient reset-path outage"
else
  bad "sync_clone exited $rc on a transient reset-path outage (expected 75)"
fi
# Restore the original hanging fake git for any later subtest that relies on it.
cat > "$TR/bin/git" <<EOF
#!/bin/bash
for a in "\$@"; do [ "\$a" = fetch ] && { sleep 30; exit 0; }; done
exec "$REAL_GIT" "\$@"
EOF
chmod +x "$TR/bin/git"

# ============================================================================
hr; echo "SUBTEST 7 — the gardener loop ABSORBS a transient claim outage (does not exit 1)"; hr
# End-to-end: a claim that exits EX_TEMPFAIL (75) because of an offline blip must
# make the long-running gardener SKIP the tick (sleep + continue), NOT die(1) and
# force a systemd restart. We point gardener.sh at a real local clone (so
# ensure_clone is a no-op) and force every claim offline via GARDEN_FETCH_CMD.
# With the fix the loop never exits on its own, so a wrapping `timeout` kills it
# (rc 124); WITHOUT the fix it dies(1) on the first claim. Assert: not 1, and the
# transient-skip log line is present.
GBARE="$TR/gardener-journal.git"; git init -q --bare "$GBARE"
GSEED="$TR/gardener-seed"; git init -q "$GSEED"
git -C "$GSEED" checkout -q -b journal2
( cd "$GSEED"; mkdir -p jobs/todo jobs/doin jobs/tada work; touch jobs/todo/.gitkeep )
git -C "$GSEED" add -A
git -C "$GSEED" -c user.name=test -c user.email=test@localhost commit -q -m seed
git -C "$GSEED" push -q "$GBARE" HEAD:journal2
GCLONE="$TR/gardener-clone"
git clone -q --single-branch --branch journal2 "$GBARE" "$GCLONE"

cat > "$TR/bin/offline-fetch" <<'EOF'
#!/bin/bash
echo "ssh: Could not resolve hostname github.com: Temporary failure in name resolution" >&2
echo "fatal: Could not read from remote repository." >&2
exit 128
EOF
chmod +x "$TR/bin/offline-fetch"

GLOG="$TR/gardener.log"; grc=0
timeout 6 env \
  GARDEN_GARDENER_CLONE="$GCLONE" \
  JOURNAL_REMOTE="$GBARE" \
  GARDEN_FETCH_CMD="$TR/bin/offline-fetch" \
  GARDEN_FETCH_RETRIES=1 \
  GARDEN_IDLE_SLEEP=1 \
  GARDEN_STATE="$TR/gardener-state" \
  bash "$JOBS/gardener.sh" 92 >"$GLOG" 2>&1 || grc=$?
if [ "$grc" -eq 1 ]; then
  bad "gardener.sh exited 1 on a transient claim outage (the fatal-per-blip regression)"
else
  ok "gardener.sh did not die(1) on a transient claim outage (rc=$grc; 124=timed-out-still-looping)"
fi
if grep -q "claim transiently offline" "$GLOG"; then
  ok "gardener loop logged the transient-skip branch"
else
  bad "gardener loop did not log 'claim transiently offline' (see $GLOG)"
  sed -n '1,40p' "$GLOG" >&2 || true
fi

# ============================================================================
hr
rm -rf "$TR"
echo "RESULTS: $PASS passed, $FAIL failed"
[ "$FAIL" -eq 0 ]
