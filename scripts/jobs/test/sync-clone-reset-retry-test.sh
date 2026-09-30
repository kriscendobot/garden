#!/bin/bash
# sync-clone-reset-retry-test.sh — regression guard for sync_clone's reset-retry arm.
#
# Incident (garden-sysop, 2026-09-30 21:31-21:34): the first `reset --hard` failed,
# the guarded re-fetch timed out (rc=124, then rc=137 on the SIGKILL escalation),
# and the arm fell through to the retry reset, which died on the `.git/HEAD.lock`
# the killed git child left behind:
#   FATAL: hard reset ... failed after retry: ... cannot lock ref 'HEAD': ... File exists
# Two gaps closed: the re-fetch is now classified like the other fetch sites
# (124/137/offline/ambiguous outage -> clean EX_TEMPFAIL skip), and stale git locks
# are swept again (clone_lock still held) before the retry reset.
#
# The first reset is failed deterministically by having the injected fetch leave a
# HEAD.lock behind AFTER sync_clone's entry sweep — exactly the production shape.
#
# Usage: sync-clone-reset-retry-test.sh
set -euo pipefail
export GARDEN_TEST=1
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
JOBS="$(cd "$HERE/.." && pwd)"
PASS=0; FAIL=0
ok()  { echo "  PASS: $*"; PASS=$((PASS+1)); }
bad() { echo "  FAIL: $*"; FAIL=$((FAIL+1)); }
hr()  { echo "----------------------------------------------------------------"; }

TR="$(mktemp -d "$HOME/.garden-sync-reset-test.XXXXXX")"  # $HOME, not /tmp: the fake fetch must be executable
trap 'rm -rf "$TR"' EXIT
mkdir -p "$TR/bin"
export GARDEN_STATE="$TR/state" GARDEN_CONTENTION_DIR="$TR/state/journal-contention"

# shellcheck source=../common.sh
source "$JOBS/common.sh"
export GARDEN_FETCH_RETRIES=1

# A real local journal remote, so the successful reset path is genuine.
RB="$TR/journal.git"; SEED="$TR/seed"
git init -q --bare "$RB"
git init -q "$SEED"
git -C "$SEED" checkout -q -b journal2
printf 'seed\n' > "$SEED/README"
git -C "$SEED" add README
git -C "$SEED" -c user.name=test -c user.email=test@localhost commit -q -m seed
git -C "$SEED" remote add origin "$RB"
git -C "$SEED" push -q origin HEAD:journal2

# fetch mock: call 1 succeeds but leaves HEAD.lock (the first reset fails on it);
# call 2 does whatever $SECOND says:
#   rc=<n>     exit <n> with no diagnostic (a timeout kill)
#   lock-ok    succeed, but leave HEAD.lock again (a killed child's leftover)
cat > "$TR/bin/fetch" <<EOF
#!/bin/bash
n=\$(cat "\$COUNT"); n=\$((n+1)); echo "\$n" > "\$COUNT"
git -C "\$GARDEN_FETCH_DIR" update-ref refs/remotes/origin/journal2 "\$(git -C "$RB" rev-parse journal2)"
if [ "\$n" -eq 1 ]; then : > "\$GARDEN_FETCH_DIR/.git/HEAD.lock"; exit 0; fi
case "\$SECOND" in
  rc=*) exit "\${SECOND#rc=}" ;;
  lock-ok) : > "\$GARDEN_FETCH_DIR/.git/HEAD.lock"; exit 0 ;;
esac
EOF
chmod +x "$TR/bin/fetch"

run_case() {  # <name> <second> -> sets rc, CL, ERR
  CL="$TR/clone-$1"; ERR="$TR/$1.err"
  git clone -q --single-branch --branch journal2 "$RB" "$CL"
  export COUNT="$TR/$1.count"; echo 0 > "$COUNT"
  rc=0
  ( export JOURNAL_REMOTE="$RB" GARDEN_FETCH_CMD="$TR/bin/fetch" SECOND="$2"
    sync_clone "$CL" ) >/dev/null 2>"$ERR" || rc=$?
}

for kill_rc in 124 137; do
  hr; echo "CASE — first reset fails, re-fetch killed (rc=$kill_rc) -> offline skip"; hr
  run_case "kill$kill_rc" "rc=$kill_rc"
  if [ "$rc" -eq "$GARDEN_OFFLINE_RC" ] && [ "$(cat "$COUNT")" -eq 2 ] \
     && ! grep -q 'FATAL' "$ERR"; then
    ok "re-fetch rc=$kill_rc takes the clean EX_TEMPFAIL skip ($rc), no FATAL"
  else
    bad "re-fetch rc=$kill_rc: rc=$rc fetches=$(cat "$COUNT") stderr=$(tr '\n' ' ' < "$ERR")"
  fi
done

hr; echo "CASE — stale HEAD.lock between re-fetch and retry reset -> swept, reset succeeds"; hr
run_case lock lock-ok
if [ "$rc" -eq 0 ] && [ ! -e "$CL/.git/HEAD.lock" ] \
   && [ "$(git -C "$CL" rev-parse HEAD)" = "$(git -C "$RB" rev-parse journal2)" ]; then
  ok "retry reset succeeded after sweeping the leftover HEAD.lock"
else
  bad "stale-lock retry: rc=$rc lock=$([ -e "$CL/.git/HEAD.lock" ] && echo present || echo gone) stderr=$(tr '\n' ' ' < "$ERR")"
fi

hr; echo "CASE — gc.log.lock leftover is swept"; hr
CL="$TR/clone-gclock"
git clone -q --single-branch --branch journal2 "$RB" "$CL"
: > "$CL/.git/gc.log.lock"
_sweep_stale_git_locks "$CL" 2>/dev/null
if [ ! -e "$CL/.git/gc.log.lock" ]; then
  ok "_sweep_stale_git_locks removes a stale gc.log.lock"
else
  bad "_sweep_stale_git_locks left gc.log.lock behind"
fi

hr; echo "RESULT: $PASS passed, $FAIL failed"
[ "$FAIL" -eq 0 ]
