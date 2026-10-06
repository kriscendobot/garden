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
            kriscendobot-source \
            kriscendobot-gena kriscendobot-genb kriscendobot-genc; do
  printf 'last_completed_at: 2026-09-01T00:00:00Z\n' > "$SEED/cursors/receipts/$slug"
done
# Mark PR #5 of each gen* slug as garden-worked (panel-runs record), so the direct
# in-process generate path is reached for it (garden_worked_pr returns true).
for slug in kriscendobot-gena kriscendobot-genb kriscendobot-genc; do
  mkdir -p "$SEED/panel-runs/$slug-pr5"
  touch "$SEED/panel-runs/$slug-pr5/.gitkeep"
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
# Emits one garden-worked, completed-after-cursor PR (#5) so the per-PR generate path
# is exercised. Same output for every gen* slug (the source ignores its repo arg).
cat > "$TR/bin/gen-source" <<'EOF'
#!/bin/bash
printf '5\tMERGED\t2026-09-15T00:00:00Z\n'
EOF
# Stub generators (stand in for pr-receipt.sh) and a recording post stub (stands in for
# post-job.sh), so the direct-vs-fallback dispatch is testable with no real gh/git.
cat > "$TR/bin/gen-ok" <<EOF
#!/bin/bash
echo "\$@" >> "$TR/gen.log"
exit 0
EOF
cat > "$TR/bin/gen-structural-fail" <<EOF
#!/bin/bash
echo "\$@" >> "$TR/gen.log"
echo 'pr-receipt.sh: BUG: unexpected null in reputation ledger' >&2
exit 1
EOF
cat > "$TR/bin/gen-transient-fail" <<EOF
#!/bin/bash
echo "\$@" >> "$TR/gen.log"
exit 124
EOF
cat > "$TR/bin/post-record" <<EOF
#!/bin/bash
echo "\$1" >> "$TR/post.log"
exit 0
EOF
cat > "$TR/gitbin/git" <<'EOF'
#!/bin/bash
if [ "${FAIL_GIT_CLONE:-0}" = 1 ] && [ "${1:-}" = clone ]; then
  echo 'fatal: unable to access remote: Could not resolve host: github.com' >&2
  exit 128
fi
# Fail sync_clone's `git reset -q --hard origin/<branch>` (both the first attempt
# and the post-re-fetch retry) while leaving every other git op — clone, fetch,
# config, clean — working, so the test can drive sync_clone's SECOND (post-re-fetch)
# hard-reset failure path deterministically. The signature is non-offline on purpose:
# the re-fetch succeeds (GARDEN_FETCH_CMD exits 0), so the reset failure must surface
# as a die() diagnostic, not be reclassified as a transient outage.
if [ "${FAIL_GIT_RESET:-0}" = 1 ]; then
  is_reset=0; is_hard=0; has_target=0
  for a in "$@"; do
    case "$a" in
      reset)     is_reset=1 ;;
      --hard)    is_hard=1 ;;
      origin/*)  has_target=1 ;;
    esac
  done
  if [ "$is_reset" = 1 ] && [ "$is_hard" = 1 ] && [ "$has_target" = 1 ]; then
    echo 'fatal: unable to update ref refs/heads/journal2: reset simulated failure' >&2
    exit 128
  fi
fi
# Model an ENVIRONMENTAL CUT of the prerequisite subshell (a signal — one of the causes the
# empty-stderr WARN names) at ensure_clone's `git config user.name` WRITE, which runs as a
# direct child of that subshell. Match `config` WITHOUT `--get`, so bot_name/bot_email's own
# `config --get user.*` READS (run inside a command-substitution subshell — a DIFFERENT
# $PPID) pass through and only the write is intercepted. SIGTERM fells the subshell with
# rc=143 and an EMPTY captured stderr: no command failed under errexit, so neither the ERR
# trap nor any die()/log() fires — exactly the undiagnosable shape the receipt-watcher's
# empty-$PREREQ_ERR guard must handle (2026-09-22 kriscendobot-ymax-e2e captures, rc=1, 0 B).
if [ "${FAIL_GIT_CONFIG_KILL:-0}" = 1 ]; then
  is_config=0; is_get=0
  for a in "$@"; do
    case "$a" in
      config) is_config=1 ;;
      --get)  is_get=1 ;;
    esac
  done
  if [ "$is_config" = 1 ] && [ "$is_get" = 0 ]; then
    kill -TERM "$PPID"; exit 0
  fi
fi
exec /usr/bin/git "$@"
EOF
cat > "$TR/gitbin/flock" <<'EOF'
#!/bin/bash
if [ "${FAIL_CLONE_LOCK_BUSY:-0}" = 1 ]; then
  exit 1
fi
exec /usr/bin/flock "$@"
EOF
chmod +x "$TR/bin/"*
chmod +x "$TR/gitbin/git" "$TR/gitbin/flock"

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
  ${WATCH_WRAP:+$WATCH_WRAP} "${runenv[@]}" "$JOBS/receipt-watcher.sh" "$slug" >/dev/null 2>"$err"
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

# Drive the per-PR GENERATE dispatch with a stubbed source, generator, and post, so the
# direct-in-process common path and the structural-failure fallback are both testable.
run_watch_gen() {  # run_watch_gen <slug> <err> <generate> <post>
  local slug="$1" err="$2" generate="$3" post="$4"
  env JOURNAL_REMOTE="$BARE" GARDEN_STATE="$STATE" PATH="$TR/gitbin:$PATH" \
    GARDEN_RECEIPT_WATCH_CLONE="$WATCH_CLONE" GARDEN_CURSOR_CLONE="$CURSOR_CLONE" \
    GARDEN_RECEIPT_PR_SOURCE="$TR/bin/gen-source" \
    GARDEN_RECEIPT_GENERATE="$generate" GARDEN_RECEIPT_POST="$post" \
    GARDEN_FETCH_RETRIES=1 GARDEN_BACKOFF_BASE=0 GARDEN_BACKOFF_CAP=0 \
    GARDEN_API_COOLDOWN_SECS=120 \
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

# A live peer holding clone_lock past its bounded wait is ordinary, self-resolving
# contention (for example journal-contention-watch doing a cold rebuild). Stub flock
# busy so the REAL clone_lock emits its exact fatal give-up diagnostic immediately;
# the watcher must classify that capture, skip cleanly, and avoid both a FATAL and the
# gh-api cooldown (this is a local lock, not API unavailability).
rm -f "$STATE/gh-api-cooldown/marker"
export FAIL_CLONE_LOCK_BUSY=1 GARDEN_LOCK_WAIT=0 GARDEN_LOCK_RETRIES=1 GARDEN_LOCK_STEALS=0
if run_watch kriscendobot-source "$TR/clone-lock-busy.err" "$TR/bin/empty-source"; then
  if grep -q 'receipt journal clone lock busy (live peer; likely a contention rebuild) — skipping tick' "$TR/clone-lock-busy.err" \
     && ! grep -q 'FATAL:' "$TR/clone-lock-busy.err" \
     && [ ! -e "$STATE/gh-api-cooldown/marker" ]; then
    ok "live-peer clone-lock contention skips the tick without FATAL or gh-api cooldown"
  else
    bad "live-peer clone-lock contention lost its skip diagnostic, emitted FATAL, or opened gh-api cooldown"
  fi
else
  bad "live-peer clone-lock contention escaped as a watcher failure"
fi
unset FAIL_CLONE_LOCK_BUSY GARDEN_LOCK_WAIT GARDEN_LOCK_RETRIES GARDEN_LOCK_STEALS

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

# sync_clone's SECOND hard reset (the post-re-fetch retry at common.sh) must die() with
# a diagnostic, not fall through as a bare `set -e` exit with an EMPTY prerequisite
# stderr. The fetch succeeds (GARDEN_FETCH_CMD exits 0), so the offline/corrupt
# branches are skipped; the first reset fails, the re-fetch succeeds (rc=0, so the
# offline guard is FALSE and the tick is NOT reclassified as transient), and the
# second reset fails too. The regression this guards: a bare second reset killed the
# subshell on git's raw rc, producing the observed "receipt journal prerequisite
# failed ... (rc=1)" with a completely empty captured stderr. The fix's die() must now
# leave a priority-tagged, attributable diagnostic instead.
rm -f "$STATE/gh-api-cooldown/marker"
export FAIL_GIT_RESET=1
if run_watch kriscendobot-source "$TR/second-reset.err" "$TR/bin/empty-source"; then
  bad "second-reset failure was swallowed"
elif grep -q '^<3>  prerequisite: .*FATAL: hard reset of .* to origin/journal2 failed after retry' "$TR/second-reset.err" \
     && grep -q 'FATAL: receipt journal prerequisite failed' "$TR/second-reset.err" \
     && ! grep -q 'produced NO diagnostic output' "$TR/second-reset.err"; then
  ok "sync_clone second-reset failure dies with a priority-tagged diagnostic (not empty)"
else
  bad "second-reset failure lost its diagnostic, priority tag, or hit the empty-stderr path"
fi
unset FAIL_GIT_RESET

# An EMPTY-STDERR nonzero prerequisite exit — the subshell felled by an environmental
# interruption (a signal, a fork failure, ENOSPC on $TMPDIR, an OOM kill) BEFORE any
# command could fail-and-report — must take the LOUD resource-check diagnostic path, not a
# die() that falsely points at a "prerequisite stderr above" that does not exist. This is
# the 2026-09-22 garden-receipt-watcher@kriscendobot-ymax-e2e regression (rc=1 with zero
# bytes captured). The git stub TERMs the prerequisite subshell at ensure_clone's `git
# config user.name` write, so the subshell dies rc=143 with a COMPLETELY EMPTY $PREREQ_ERR;
# 143 is not a transient code (75/124/137), so shared_availability_failure declines it and
# the empty-stderr guard must fire: a WARN pointing at a resource check, and a die() whose
# wording says "no diagnostic captured" — never the inaccurate "see prerequisite stderr
# above".
rm -f "$STATE/gh-api-cooldown/marker"
export FAIL_GIT_CONFIG_KILL=1
if run_watch kriscendobot-source "$TR/empty-prereq.err" "$TR/bin/empty-source"; then
  bad "empty-stderr prerequisite failure was swallowed (must die loud)"
elif grep -q 'produced NO diagnostic output (rc=143)' "$TR/empty-prereq.err" \
     && grep -q 'FATAL: receipt journal prerequisite failed' "$TR/empty-prereq.err" \
     && grep -q 'no diagnostic captured' "$TR/empty-prereq.err" \
     && ! grep -q 'see prerequisite stderr above' "$TR/empty-prereq.err"; then
  ok "empty-stderr prerequisite exit dies loud with the resource-check diagnostic (no false 'stderr above')"
else
  bad "empty-stderr prerequisite exit lost its WARN/no-diagnostic wording or falsely cited 'stderr above'"
fi
unset FAIL_GIT_CONFIG_KILL

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

# The STARTUP sweep fells verified prior-run stragglers BEFORE the PR source runs
# (systemd "Found left-over process ... (git)" at start, 2026-09-29). The fixture
# models the service cgroup: an orphan (double-forked, so reparented away) left by a
# previous tick; then a wrapper standing in for the self-heal-run.sh main PID, which
# lists itself in cgroup.procs and starts a tee-like sibling before running the
# watcher. The orphan predates the main PID and must die; the sibling does not and
# must be spared. The source records what it sees, proving the sweep ran before the
# source, not only at exit.
SUPROCS="$TR/startup-cgroup.procs"; SUORPH="$TR/su-orphan.pid"; SUSIB="$TR/su-sib.pid"
rm -f "$SUORPH" "$SUSIB" "$TR/su-seen"; : > "$SUPROCS"
setsid bash -c '(exec sleep 600) & echo $! > "'"$SUORPH"'"' &
for _ in $(seq 1 100); do [ -s "$SUORPH" ] && break; sleep 0.1; done
SUO="$(cat "$SUORPH" 2>/dev/null || true)"
echo "$SUO" >> "$SUPROCS"
sleep 0.2
cat > "$TR/bin/su-main" <<'EOF'
#!/usr/bin/env bash
echo $$ >> "$SUPROCS"
sleep 600 & echo $! > "$SUSIB"; echo $! >> "$SUPROCS"
"$@"
EOF
cat > "$TR/bin/startup-probe-source" <<'EOF'
#!/usr/bin/env bash
alive() { kill -0 "$1" 2>/dev/null && [ "$(awk '{ x=$0; sub(/^.*\) /,"",x); print substr(x,1,1) }' "/proc/$1/stat" 2>/dev/null || echo Z)" != Z ]; }
o=dead; s=dead
alive "$(cat "$SUORPH")" && o=alive
alive "$(cat "$SUSIB")" && s=alive
echo "orphan=$o sibling=$s" > "$SUSEEN"
EOF
chmod +x "$TR/bin/su-main" "$TR/bin/startup-probe-source"
rm -f "$STATE/gh-api-cooldown/marker"
export SUPROCS SUORPH SUSIB SUSEEN="$TR/su-seen"
WATCH_WRAP="$TR/bin/su-main" \
  run_watch kriscendobot-startup "$TR/startup-reap.err" "" "$TR/bin/startup-probe-source" 0 "$WATCH_CLONE" "$SUPROCS" || true
if grep -qx 'orphan=dead sibling=alive' "$TR/su-seen" 2>/dev/null \
   && grep -q "reaped prior-run cgroup straggler(s) at startup: $SUO\$" "$TR/startup-reap.err"; then
  ok "startup sweep fells a verified prior-run straggler before the source, sparing this run's processes"
else
  bad "startup sweep did not fell only the prior-run straggler before the source (seen: $(cat "$TR/su-seen" 2>/dev/null))"
fi
kill -KILL "$SUO" "$(cat "$SUSIB" 2>/dev/null)" 2>/dev/null || true

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

# A garden-worked completed PR is receipted by calling the deterministic generator
# DIRECTLY in-process (pr-receipt.sh <repo> <num> --dir <clone>) — NO LLM dispatch, NO
# fallback job — on the common (success) path. This is the whole point of the change:
# the old path burned an LLM claim to run a no-judgment script.
rm -f "$STATE/gh-api-cooldown/marker" "$TR/gen.log" "$TR/post.log"
run_watch_gen kriscendobot-gena "$TR/gen-ok.err" "$TR/bin/gen-ok" "$TR/bin/post-record" || true
if grep -q '^kriscendobot/gena 5 --dir ' "$TR/gen.log" 2>/dev/null \
   && [ ! -f "$TR/post.log" ] \
   && grep -q 'generated receipt in-process for #5' "$TR/gen-ok.err"; then
  ok "garden-worked completed PR is generated in-process (no LLM dispatch, no fallback post)"
else
  bad "in-process generate did not run direct, or wrongly posted a fallback job"
fi

# A STRUCTURAL generate failure (a genuine pr-receipt.sh bug, non-transient rc) falls
# back to a job-board post so the doom machinery surfaces it — and the generator stderr
# is preserved in the watcher log.
rm -f "$STATE/gh-api-cooldown/marker" "$TR/gen.log" "$TR/post.log"
run_watch_gen kriscendobot-genb "$TR/gen-struct.err" "$TR/bin/gen-structural-fail" "$TR/bin/post-record" || true
if grep -qx 'kriscendobot-genb-pr5-receipt' "$TR/post.log" 2>/dev/null \
   && grep -q 'failed structurally' "$TR/gen-struct.err" \
   && grep -q 'generate: pr-receipt.sh: BUG:' "$TR/gen-struct.err"; then
  ok "structural generate failure falls back to a job-board post with its diagnostic"
else
  bad "structural generate failure did not fall back to a post or lost its diagnostic"
fi

# A TRANSIENT generate failure (rc=124 / network) is NOT a bug: it cools down and
# retries next tick, posting NO wasteful fallback job.
rm -f "$STATE/gh-api-cooldown/marker" "$TR/gen.log" "$TR/post.log"
run_watch_gen kriscendobot-genc "$TR/gen-trans.err" "$TR/bin/gen-transient-fail" "$TR/bin/post-record" || true
if [ ! -f "$TR/post.log" ] \
   && [ -s "$STATE/gh-api-cooldown/marker" ] \
   && grep -q 'transient outage (rc=124)' "$TR/gen-trans.err"; then
  ok "transient generate failure cools down and retries, posting no fallback job"
else
  bad "transient generate failure posted a fallback or lost its cooldown"
fi

echo "TOTAL: $PASS passed, $FAIL failed"
[ "$FAIL" -eq 0 ]
