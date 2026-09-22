#!/bin/bash
# receipt-watcher-test.sh — failure-containment guards for the per-repo receipt
# watcher. All GitHub reads are stubbed and the journal is a throwaway bare repo.

set -euo pipefail
export GARDEN_TEST=1
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
JOBS="$(cd "$HERE/.." && pwd)"
TR="$(mktemp -d /home/kris/.garden-receipt-watcher.XXXXXX)"
TEST_KEEP="${GARDEN_TEST_KEEP:-0}"
trap '[ "$TEST_KEEP" = 1 ] || rm -rf "$TR"' EXIT
BRANCH=journal2
PASS=0; FAIL=0
ok() { echo "  PASS: $*"; PASS=$((PASS+1)); }
bad() { echo "  FAIL: $*"; FAIL=$((FAIL+1)); }
proc_running() {  # proc_running <pid>
  local p="$1" st
  kill -0 "$p" 2>/dev/null || return 1
  st="$(awk '{ s=$0; sub(/^.*\) /,"",s); print substr(s,1,1) }' "/proc/$p/stat" 2>/dev/null || echo Z)"
  [ "$st" != Z ]
}

# Scrub ambient fleet configuration before constructing the isolated fixture.
# shellcheck disable=SC2046 # intentional variable-name expansion for unset
unset $(compgen -v 2>/dev/null | grep -E '^(GARDEN_|JOURNAL_)' || true) 2>/dev/null || true
export GARDEN_TEST=1

BARE="$TR/journal.git"
SEED="$TR/seed"
git init -q --bare "$BARE"
git init -q "$SEED"
git -C "$SEED" checkout -q -b "$BRANCH"
mkdir -p "$SEED/jobs/todo" "$SEED/jobs/doin" "$SEED/jobs/tada" \
  "$SEED/work" "$SEED/cursors/receipts"
for slug in kriscendobot-race1 kriscendobot-race2 kriscendobot-race3 \
            kriscendobot-race4 kriscendobot-race5 kriscendobot-race6 \
            kriscendobot-source; do
  printf 'last_completed_at: 2026-09-01T00:00:00Z\n' > "$SEED/cursors/receipts/$slug"
done
touch "$SEED/jobs/todo/.gitkeep" "$SEED/jobs/doin/.gitkeep" \
  "$SEED/jobs/tada/.gitkeep" "$SEED/work/.gitkeep"
git -C "$SEED" add -A
git -C "$SEED" -c user.name=test -c user.email=test@localhost commit -q -m seed
git -C "$SEED" remote add origin "$BARE"
git -C "$SEED" push -q -u origin "$BRANCH"

STATE="$TR/state"
export GARDEN_API_COOLDOWN_DIR="$STATE/gh-api-cooldown"
export GARDEN_API_COOLDOWN_SECS=300
WATCH_CLONE="$STATE/receipt-watcher/journal"
CURSOR_CLONE="$STATE/cursors/journal"
mkdir -p "$(dirname "$WATCH_CLONE")"
git clone -q --single-branch --branch "$BRANCH" "$BARE" "$WATCH_CLONE"

mkdir -p "$TR/bin"
mkdir -p "$TR/gitbin"
cat > "$TR/bin/offline-fetch" <<'EOF'
#!/bin/bash
echo 'fatal: unable to access remote: Could not resolve host: github.com' >&2
exit 128
EOF
cat > "$TR/bin/structural-fetch" <<'EOF'
#!/bin/bash
echo '<3>FATAL: Authentication failed for journal remote' >&2
exit 128
EOF
cat > "$TR/bin/empty-source" <<'EOF'
#!/bin/bash
exit 0
EOF
cat > "$TR/bin/timeout-source" <<'EOF'
#!/bin/bash
exit 124
EOF
cat > "$TR/bin/structural-source" <<'EOF'
#!/bin/bash
echo 'jq: parse error: invalid schema returned by source' >&2
exit 2
EOF
cat > "$TR/gitbin/git" <<'EOF'
#!/bin/bash
if [ "${FAIL_GIT_CLONE:-0}" = 1 ] && [ "${1:-}" = clone ]; then
  echo 'fatal: unable to access remote: Could not resolve host: github.com' >&2
  exit 128
fi
exec /usr/bin/git "$@"
EOF
chmod +x "$TR/bin/"*
chmod +x "$TR/gitbin/git"

run_watch() {  # run_watch <slug> <stderr-file> [fetch-command] [source-command] [fail-clone] [watch-clone] [cgroup-procs]
  local slug="$1" err="$2" fetch="${3:-}" source="${4:-$TR/bin/empty-source}"
  local fail_clone="${5:-0}" watch_clone="${6:-$WATCH_CLONE}" cgroup_procs="${7:-}"
  local -a runenv=(env JOURNAL_REMOTE="$BARE" GARDEN_STATE="$STATE"
    PATH="$TR/gitbin:$PATH" FAIL_GIT_CLONE="$fail_clone"
    GARDEN_RECEIPT_WATCH_CLONE="$watch_clone" GARDEN_CURSOR_CLONE="$CURSOR_CLONE"
    GARDEN_RECEIPT_PR_SOURCE="$source" GARDEN_RECEIPT_POST="$TR/bin/empty-source"
    GARDEN_FETCH_RETRIES=1 GARDEN_BACKOFF_BASE=0 GARDEN_BACKOFF_CAP=0
    GARDEN_API_COOLDOWN_SECS=120)
  [ -z "$fetch" ] || runenv+=(GARDEN_FETCH_CMD="$fetch")
  [ -z "$cgroup_procs" ] || runenv+=(GARDEN_RECEIPT_CGROUP_PROCS_FILE="$cgroup_procs")
  "${runenv[@]}" "$JOBS/receipt-watcher.sh" "$slug" >/dev/null 2>"$err"
}

# Like run_watch but WITHOUT pinning GARDEN_RECEIPT_WATCH_CLONE, so the watcher's own
# per-slug default ($GARDEN_STATE/receipt-watcher/journal-<slug>) takes effect.
run_watch_default() {  # run_watch_default <slug> <stderr-file>
  local slug="$1" err="$2"
  env JOURNAL_REMOTE="$BARE" GARDEN_STATE="$STATE" PATH="$TR/gitbin:$PATH" \
    GARDEN_CURSOR_CLONE="$CURSOR_CLONE" GARDEN_RECEIPT_PR_SOURCE="$TR/bin/empty-source" \
    GARDEN_RECEIPT_POST="$TR/bin/empty-source" GARDEN_FETCH_RETRIES=1 \
    GARDEN_BACKOFF_BASE=0 GARDEN_BACKOFF_CAP=0 GARDEN_API_COOLDOWN_SECS=120 \
    "$JOBS/receipt-watcher.sh" "$slug" >/dev/null 2>"$err"
}

# A fleet-wide journal outage races six independently-instantiated watchers. Every
# tick must be clean, one detector owns the warning, and one bounded marker backs the
# skip. This also proves sync_clone's internal exit(75) is contained by the watcher.
for n in 1 2 3 4 5 6; do
  ( set +e; run_watch "kriscendobot-race$n" "$TR/journal-$n.err" "$TR/bin/offline-fetch"; echo $? > "$TR/journal-$n.rc" ) &
done
wait
if [ "$(grep -hv '^0$' "$TR"/journal-*.rc | wc -l)" -eq 0 ]; then
  ok "six concurrent journal-outage ticks all exit cleanly"
else
  bad "a concurrent journal-outage tick returned nonzero"
fi
if [ "$(grep -hil 'cooling all receipt/gh-api watchers' "$TR"/journal-*.err | wc -l)" -eq 1 ]; then
  ok "one concurrent observer owns the shared outage warning"
else
  bad "shared journal outage did not emit exactly one warning"
fi
if [ -s "$STATE/gh-api-cooldown/marker" ]; then
  expiry="$(sed -n '1p' "$STATE/gh-api-cooldown/marker")"; now="$(date +%s)"
  if [ "$expiry" -gt "$now" ] && [ "$expiry" -le $((now + 120)) ]; then
    ok "journal outage opens a bounded host-wide cooldown"
  else
    bad "journal cooldown expiry is outside its bound"
  fi
else
  bad "journal outage did not create a shared cooldown marker"
fi

# A first-ever tick has no receipt clone yet. ensure_clone reports a network clone
# failure as rc=1 today, so classification must use the captured signature too, not
# only sync_clone's EX_TEMPFAIL code.
rm -f "$STATE/gh-api-cooldown/marker"
FRESH_CLONE="$STATE/receipt-watcher/fresh-journal"
if run_watch kriscendobot-source "$TR/fresh-clone.err" "" "$TR/bin/empty-source" 1 "$FRESH_CLONE"; then
  grep -q 'receipt journal prerequisite unavailable (transient, rc=1)' "$TR/fresh-clone.err" \
    && [ -s "$STATE/gh-api-cooldown/marker" ] \
    && ok "fresh-clone network outage is signature-classified and skipped with cooldown" \
    || bad "fresh-clone outage lost its warning/cooldown"
else
  bad "fresh-clone network outage escaped as a failure"
fi

# Source-level wall-clock timeout is availability, even with empty stderr. It must
# skip and arm the same shared marker rather than becoming a systemd failure.
rm -f "$STATE/gh-api-cooldown/marker"
if run_watch kriscendobot-source "$TR/timeout.err" "" "$TR/bin/timeout-source"; then
  ok "source timeout exits as a skipped tick"
else
  bad "source timeout escaped as a failure"
fi
grep -q 'receipt PR source unavailable (transient, rc=124)' "$TR/timeout.err" \
  && [ -s "$STATE/gh-api-cooldown/marker" ] \
  && ok "source timeout emits one useful warning and opens the shared cooldown" \
  || bad "source timeout warning/cooldown missing"

# Persistent structural failures remain failures and retain the underlying stderr,
# so cooldown containment cannot hide broken credentials or a malformed source.
rm -f "$STATE/gh-api-cooldown/marker"
if run_watch kriscendobot-source "$TR/struct-source.err" "" "$TR/bin/structural-source"; then
  bad "structural source failure was swallowed"
else
  grep -q 'source: jq: parse error: invalid schema returned by source' "$TR/struct-source.err" \
    && grep -q 'FATAL: receipt PR source failed' "$TR/struct-source.err" \
    && ok "structural source failure stays loud with its diagnostic" \
    || bad "structural source failure lost its diagnostic"
fi

rm -f "$STATE/gh-api-cooldown/marker"
if run_watch kriscendobot-source "$TR/struct-journal.err" "$TR/bin/structural-fetch"; then
  bad "structural journal failure was swallowed"
elif grep -q '^<3>  prerequisite: .*FATAL: fetch failed in .* after bounded retries' "$TR/struct-journal.err" \
     && grep -q 'FATAL: receipt journal prerequisite failed' "$TR/struct-journal.err"; then
  ok "structural journal failure preserves its priority-tagged diagnostic"
else
  bad "structural journal failure lost its diagnostic or priority tag"
fi

# The EXIT-path cgroup sweep must wait until the service cgroup is empty, not merely
# signal one snapshot. A fixture cgroup.procs file lets the test exercise the loop
# without a real systemd service cgroup. The two children use separate process groups
# to model helpers that escaped the source's group-level reap.
CGPROCS="$TR/cgroup.procs"; : > "$CGPROCS"
S1PID="$TR/s1.pid"; S2PID="$TR/s2.pid"
setsid bash -c 'echo $$ > "'"$S1PID"'"; exec sleep 600' &
setsid bash -c 'echo $$ > "'"$S2PID"'"; exec sleep 600' &
for _ in $(seq 1 100); do
  [ -s "$S1PID" ] && [ -s "$S2PID" ] && break
  sleep 0.1
done
SPID1="$(cat "$S1PID" 2>/dev/null || true)"
SPID2="$(cat "$S2PID" 2>/dev/null || true)"
printf '%s\n%s\n' "$SPID1" "$SPID2" > "$CGPROCS"
if proc_running "$SPID1" && proc_running "$SPID2"; then
  ok "cgroup stragglers start alive in separate process groups"
else
  bad "cgroup straggler fixture children did not start"
fi
rm -f "$STATE/gh-api-cooldown/marker"
run_watch kriscendobot-source "$TR/cgroup-reap.err" "" "$TR/bin/empty-source" 0 "$WATCH_CLONE" "$CGPROCS" || true
if ! proc_running "$SPID1" && ! proc_running "$SPID2"; then
  ok "cgroup sweep waits until both stragglers are gone before watcher exit"
else
  bad "cgroup sweep left a straggler alive after watcher exit"
  kill -KILL "$SPID1" "$SPID2" 2>/dev/null || true
fi

# The DEFAULT receipt clone is PER-SLUG: with GARDEN_RECEIPT_WATCH_CLONE unset, each
# templated instance syncs its OWN $GARDEN_STATE/receipt-watcher/journal-<slug> with its
# OWN sibling clone_lock, so the 16 concurrent instances never contend on one shared lock
# (the shared-clone contention this fix removes). Two distinct slugs must land in two
# distinct clone dirs, neither of them the old shared $STATE/receipt-watcher/journal.
rm -f "$STATE/gh-api-cooldown/marker"
run_watch_default kriscendobot-race1 "$TR/default-a.err" || true
run_watch_default kriscendobot-race2 "$TR/default-b.err" || true
A="$STATE/receipt-watcher/journal-kriscendobot-race1"
B="$STATE/receipt-watcher/journal-kriscendobot-race2"
if [ -d "$A/.git" ] && [ -d "$B/.git" ] && [ "$A" != "$B" ]; then
  ok "default receipt clone is per-slug (distinct journal-<slug> dirs per instance)"
else
  bad "default receipt clone was not per-slug (A=$A exists=$([ -d "$A/.git" ] && echo y) B=$B exists=$([ -d "$B/.git" ] && echo y))"
fi

echo "TOTAL: $PASS passed, $FAIL failed"
[ "$FAIL" -eq 0 ]
