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
# Explicit positive test-context sentinel: protects this standalone suite even when
# invoked outside the test-tree entrypoint heuristic.
export GARDEN_TEST=1
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
hr; echo "SUBTEST 5 — sync_clone heals a corrupt local journal clone by re-cloning"; hr
# A corrupt local clone is a repository failure, not an outage. sync_clone heals it
# by REPLACING the clone through ensure_clone's atomic sibling-temp path, ONCE per
# invocation: corruption that survives a fresh clone is an upstream problem and must
# surface rather than spin a re-clone loop. It uses a REAL local journal remote for
# the reset, proving the healed clone is usable. The injected fetch mock reports the
# production corruption signature on its failing calls and, on success, (re)creates
# the remote-tracking ref exactly as a real fetch would, so the subsequent
# `reset --hard origin/journal2` resolves.
#
# HISTORY (why these cases were rewritten, 2026-07-28): this subtest used to assert a
# TWO-TIER heal — a cheap in-place repair (rm gc.log + the corrupt tracking ref) with
# a full re-clone only as fallback (7ccfe92e62, 2026-07-20). Later the same day the
# implementation was deliberately simplified back to always-re-clone (6f8501d8db,
# 4465b7d45a), and the richer corruption set in run-test.sh SUBTEST 24 was written
# against THAT contract. Only this file was left asserting the superseded two-tier
# behavior, so it stayed red. The two suites now agree; run-test.sh SUBTEST 24 is the
# canonical corruption set (gc.log-only shape, bounded-once, repo-watcher shape).
CB="$TR/corrupt-journal.git"; CS="$TR/corrupt-seed"; CC="$TR/corrupt-clone"
git init -q --bare "$CB"
git init -q "$CS"
git -C "$CS" checkout -q -b journal2
printf 'seed\n' > "$CS/README"
git -C "$CS" add README
git -C "$CS" -c user.name=test -c user.email=test@localhost commit -q -m seed
git -C "$CS" remote add origin "$CB"
git -C "$CS" push -q origin HEAD:journal2

# --- the gardener-6 signature: one re-clone, then recover --------------------
# fetch #1 fails with a wedged remote-tracking ref + failed-repack; sync_clone
# replaces the clone and fetch #2 (against the fresh clone) succeeds. The
# pre-existing doom file must be GONE — proof the clone was replaced, not
# patched — and exactly 2 fetches ran.
git clone -q --single-branch --branch journal2 "$CB" "$CC"
touch "$CC/doomed-before-reclone"
printf 'bad gc\n' > "$CC/.git/gc.log"
mkdir -p "$CC/.git/refs/remotes/origin"
: > "$CC/.git/refs/remotes/origin/journal2"
CORRUPT_COUNT="$TR/corrupt-fetch-count"; echo 0 > "$CORRUPT_COUNT"
cat > "$TR/bin/corrupt-then-good-fetch" <<EOF
#!/bin/bash
n=\$(cat "$CORRUPT_COUNT"); n=\$((n+1)); echo "\$n" > "$CORRUPT_COUNT"
if [ "\$n" -eq 1 ]; then
  echo "fatal: bad object refs/remotes/origin/journal2" >&2
  echo "error: refs/remotes/origin/journal2: invalid sha1 pointer 0000000000000000000000000000000000000000" >&2
  echo "fatal: failed to run repack" >&2
  exit 1
fi
# success: behave like a real fetch — (re)create the remote-tracking ref
git -C "\$GARDEN_FETCH_DIR" update-ref refs/remotes/origin/journal2 "\$(git -C "$CB" rev-parse journal2)" 2>/dev/null || true
exit 0
EOF
chmod +x "$TR/bin/corrupt-then-good-fetch"
rc=0
( export JOURNAL_REMOTE="$CB" GARDEN_FETCH_RETRIES=1 GARDEN_FETCH_CMD="$TR/bin/corrupt-then-good-fetch"
  sync_clone "$CC" ) >/dev/null 2>&1 || rc=$?
if [ "$rc" -eq 0 ] && [ "$(cat "$CORRUPT_COUNT")" -eq 2 ] && [ -d "$CC/.git" ] \
   && [ ! -e "$CC/doomed-before-reclone" ] && [ ! -e "$CC/.git/gc.log" ]; then
  ok "sync_clone re-cloned the corrupt clone and recovered on its one post-reclone fetch"
else
  bad "sync_clone corrupt-clone heal wrong (rc=$rc, fetches=$(cat "$CORRUPT_COUNT"), doom=$([ -e "$CC/doomed-before-reclone" ] && echo kept || echo gone), gc.log=$([ -e "$CC/.git/gc.log" ] && echo present || echo gone))"
fi

# --- corruption that SURVIVES the re-clone is bounded to one attempt ---------
# fetch #1 AND the post-re-clone fetch #2 both report corruption (an upstream or
# unhealable shape). sync_clone must NOT spin: it re-clones exactly once and then
# dies loudly. The doom file is gone (the wipe ran) and exactly 2 fetches happen.
CB2="$TR/corrupt-journal2.git"; CC2="$TR/corrupt-clone2"
git init -q --bare "$CB2"
git -C "$CS" push -q "$CB2" HEAD:journal2
git clone -q --single-branch --branch journal2 "$CB2" "$CC2"
touch "$CC2/doomed-before-reclone"
printf 'bad gc\n' > "$CC2/.git/gc.log"
CORRUPT_COUNT2="$TR/corrupt-fetch-count2"; echo 0 > "$CORRUPT_COUNT2"
cat > "$TR/bin/corrupt-twice-then-good-fetch" <<EOF
#!/bin/bash
n=\$(cat "$CORRUPT_COUNT2"); n=\$((n+1)); echo "\$n" > "$CORRUPT_COUNT2"
if [ "\$n" -le 2 ]; then
  echo "fatal: bad object refs/heads/journal2" >&2
  echo "error: refs/heads/journal2 does not point to a valid object!" >&2
  echo "fatal: did not send all necessary objects" >&2
  exit 1
fi
git -C "\$GARDEN_FETCH_DIR" update-ref refs/remotes/origin/journal2 "\$(git -C "$CB2" rev-parse journal2)" 2>/dev/null || true
exit 0
EOF
chmod +x "$TR/bin/corrupt-twice-then-good-fetch"
rc=0
( export JOURNAL_REMOTE="$CB2" GARDEN_FETCH_RETRIES=1 GARDEN_FETCH_CMD="$TR/bin/corrupt-twice-then-good-fetch"
  sync_clone "$CC2" ) >/dev/null 2>&1 || rc=$?
if [ "$rc" -ne 0 ] && [ "$(cat "$CORRUPT_COUNT2")" -eq 2 ] && [ ! -e "$CC2/doomed-before-reclone" ]; then
  ok "sync_clone bounded the heal to ONE re-clone on unhealable corruption, then died loud"
else
  bad "sync_clone re-clone bound wrong (rc=$rc, fetches=$(cat "$CORRUPT_COUNT2"), doom=$([ -e "$CC2/doomed-before-reclone" ] && echo kept || echo gone))"
fi

# A present `.git` is not proof of health. Seed the exact gardener/14 shape:
# a bad origin/journal2 object plus stale gc.log. ensure_clone runs before every
# normal sync, so it must replace this clone atomically before a fetch can die.
EC="$TR/ensure-corrupt-clone"
git clone -q --single-branch --branch journal2 "$CB" "$EC"
touch "$EC/doomed-before-reclone"
mkdir -p "$EC/.git/refs/remotes/origin"
printf '%040d\n' 0 > "$EC/.git/refs/remotes/origin/journal2"
printf 'failed gc\n' > "$EC/.git/gc.log"
rc=0
( export JOURNAL_REMOTE="$CB"
  ensure_clone "$EC" ) >/dev/null 2>&1 || rc=$?
if [ "$rc" -eq 0 ] && [ -d "$EC/.git" ] && [ ! -e "$EC/doomed-before-reclone" ] \
   && [ ! -e "$EC/.git/gc.log" ] \
   && git -C "$EC" rev-parse -q --verify "refs/remotes/origin/journal2^{commit}" >/dev/null 2>&1; then
  ok "ensure_clone re-cloned a present corrupt clone (bad origin ref + gc.log)"
else
  bad "ensure_clone did not re-clone the present corrupt clone (rc=$rc, doom=$([ -e "$EC/doomed-before-reclone" ] && echo kept || echo gone), gc.log=$([ -e "$EC/.git/gc.log" ] && echo present || echo gone))"
fi

# Guard the EXACT reported repo-watcher signature (a zero-byte loose
# refs/heads/journal2 shadowing packed-refs + bad reflogs): its fetch stderr must
# classify as CORRUPT (heal by re-clone) and NOT as an offline outage (skip tick).
REPORTED_STDERR="fatal: bad object refs/heads/journal2
error: refs/heads/journal2 does not point to a valid object!
fatal: did not send all necessary objects
error: bad ref for .git/logs/refs/heads/journal2
error: bad ref for .git/logs/HEAD
fatal: invalid HEAD"
if _fetch_stderr_is_corrupt "$REPORTED_STDERR" && ! _fetch_stderr_is_offline "$REPORTED_STDERR"; then
  ok "reported repo-watcher stderr classifies CORRUPT and not offline"
else
  bad "reported repo-watcher stderr misclassified (corrupt=$(_fetch_stderr_is_corrupt "$REPORTED_STDERR" && echo y || echo n), offline=$(_fetch_stderr_is_offline "$REPORTED_STDERR" && echo y || echo n))"
fi

# ============================================================================
hr; echo "SUBTEST 6 — sync_clone offline path survives a BARE set -e caller"; hr
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
hr; echo "SUBTEST 7 — sync_clone classifies a transient outage on the RESET path as EX_TEMPFAIL (75)"; hr
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
hr; echo "SUBTEST 8 — the gardener loop ABSORBS a transient claim outage (does not exit 1)"; hr
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
hr; echo "SUBTEST 9 — a SIGTERM-IGNORING fetch is escalated to SIGKILL by --kill-after (rc=137), bounded + classified TRANSIENT"; hr
# THIRD outage shape (2026-06-29): bare `timeout` sends only SIGTERM, but git's
# transport child (git-remote-https on a half-open TLS connection) does not reliably
# die on SIGTERM — `git fetch` blocks in waitpid on the wedged child, so the timeout
# wrapper's direct child survives the deadline and, without a kill-after grace, the
# wrapper would block forever and the child would orphan into the service cgroup
# (the `garden-reaper.service: Found left-over process <pid> (git)` warnings).
# _journal_git_fetch now wraps with `timeout --kill-after=GARDEN_FETCH_KILL_AFTER`,
# which escalates to an unconditional SIGKILL after the grace. The SIGKILL surfaces
# as rc=137, which journal_fetch logs as a timeout and sync_clone classifies as
# EX_TEMPFAIL (75) ALONGSIDE the rc=124 SIGTERM-at-deadline kill. A fake `git` that
# IGNORES SIGTERM and hangs models the wedge: a healthy bound is ~timeout+grace; a
# regression (missing --kill-after) would hang the full 30s.
cat > "$TR/bin/git" <<EOF
#!/bin/bash
for a in "\$@"; do
  if [ "\$a" = fetch ]; then trap '' TERM; sleep 30; exit 0; fi
done
exec "$REAL_GIT" "\$@"
EOF
chmod +x "$TR/bin/git"
KCLONE="$TR/kclone"; mkdir -p "$KCLONE"
# 1s deadline + 1s grace: SIGTERM at 1s (ignored), SIGKILL at 2s -> rc=137. A hang
# (no --kill-after escalation) would run the fake git's full 30s sleep.
start="$(date +%s)"
rc=0
# No GARDEN_FETCH_CMD: journal_fetch routes through _journal_git_fetch -> PATH `git`.
( export GARDEN_FETCH_RETRIES=1 GARDEN_FETCH_TIMEOUT=1 GARDEN_FETCH_KILL_AFTER=1
  sync_clone "$KCLONE" ) >/dev/null 2>&1 || rc=$?
elapsed=$(( $(date +%s) - start ))
if [ "$elapsed" -lt 15 ]; then
  ok "SIGTERM-ignoring fetch was bounded in ${elapsed}s (--kill-after escalated; a hang would be >=30s)"
else
  bad "SIGTERM-ignoring fetch took ${elapsed}s — --kill-after did NOT escalate to SIGKILL (it HUNG)"
fi
if [ "$rc" -eq 75 ]; then
  ok "sync_clone classified the --kill-after SIGKILL (rc=137) as EX_TEMPFAIL (75), the same transient skip as rc=124"
else
  bad "sync_clone exited $rc on a --kill-after SIGKILL (expected 75; rc=137 must be a transient timeout like rc=124)"
fi
# Restore the original hanging fake git in case a later subtest is appended.
cat > "$TR/bin/git" <<EOF
#!/bin/bash
for a in "\$@"; do [ "\$a" = fetch ] && { sleep 30; exit 0; }; done
exec "$REAL_GIT" "\$@"
EOF
chmod +x "$TR/bin/git"

# ============================================================================
hr
rm -rf "$TR"
echo "RESULTS: $PASS passed, $FAIL failed"
[ "$FAIL" -eq 0 ]
