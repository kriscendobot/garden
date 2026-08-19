#!/bin/bash
# worker-ensure-worktree-test.sh — prove worker_ensure_worktree() (the shared
# per-job worktree factory in handlers/worker-common.sh) no longer swallows the
# worktree-add's stderr, and self-heals a lock-contention race.
#
# The defect (job improve-worker-ensure-worktree-swallowed-stderr): the add ran
# `... worktree add ... >/dev/null 2>&1`, so ANY failure — most plausibly
# `index.lock`/"already registered" contention from the gardener pool's
# concurrent same-host adds — surfaced to gardener.sh as a bare rc=1 with no
# diagnostic text (the "empty/transient-signature output" bucket), which drove the
# 08-15..08-19 unattributable retry storm. The fix: keep stdout on /dev/null,
# CAPTURE stderr and re-emit it on terminal failure, and retry-with-backoff when
# the captured stderr matches a lock-contention signature.
#
# This suite exercises worker_ensure_worktree DIRECTLY (sourcing common.sh +
# worker-common.sh) against a throwaway garden root, with a fake `git` shim that
# can inject a lock-contention failure for the first N `worktree add` calls.
#
# shellcheck disable=SC2015
set -uo pipefail
export GARDEN_TEST=1
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
JOBS_SRC="$(cd "$HERE/.." && pwd)"

# This suite PATH-execs a fake `git`, so its temp tree must live on an
# exec-allowed filesystem. The sandbox mounts /tmp noexec, which would make bash
# reject the shim; probe for an exec-allowed base (standard temp dirs first, then
# the garden scratch tree) exactly as gardener-worktree-test.sh does.
pick_exec_base() {
  local c probe rc
  for c in "${TMPDIR:-}" /tmp "${GARDEN_SCRATCH:-}" "${GARDEN_ROOT:+$GARDEN_ROOT/scratch}"; do
    [ -n "$c" ] && [ -d "$c" ] && [ -w "$c" ] || continue
    probe="$(mktemp -d "$c/wewt-probe.XXXXXX" 2>/dev/null)" || continue
    printf '#!/bin/sh\nexit 7\n' > "$probe/x"; chmod +x "$probe/x" 2>/dev/null
    "$probe/x" >/dev/null 2>&1; rc=$?
    rm -rf "$probe"
    [ "$rc" -eq 7 ] && { printf '%s\n' "$c"; return 0; }
  done
  return 1
}
EXEC_BASE="$(pick_exec_base)" || { echo "  SKIP: no exec-allowed temp base (needed to run a fake git shim)"; exit 0; }

TR="$(mktemp -d "$EXEC_BASE/worker-ensure-wt-test.XXXXXX")"
PASS=0; FAIL=0
ok()  { echo "  PASS: $*"; PASS=$((PASS+1)); }
bad() { echo "  FAIL: $*"; FAIL=$((FAIL+1)); }
trap 'rm -rf "$TR"' EXIT

REAL_GIT="$(command -v git)"

# --- a throwaway garden root with an origin/main2 tracking ref ----------------
ORIGIN="$TR/origin.git"
GROOT="$TR/garden"
"$REAL_GIT" init -q --bare "$ORIGIN"
mkdir -p "$GROOT"
"$REAL_GIT" init -q "$GROOT"
"$REAL_GIT" -C "$GROOT" config user.email t@localhost
"$REAL_GIT" -C "$GROOT" config user.name test
printf '/scratch/\n' > "$GROOT/.gitignore"
"$REAL_GIT" -C "$GROOT" add -A
"$REAL_GIT" -C "$GROOT" commit -qm init
"$REAL_GIT" -C "$GROOT" branch -M main2
"$REAL_GIT" -C "$GROOT" remote add origin "$ORIGIN"
"$REAL_GIT" -C "$GROOT" push -q -u origin main2
"$REAL_GIT" -C "$GROOT" fetch -q origin

export GARDEN_ROOT="$GROOT"
export GARDEN_SCRATCH="$GROOT/scratch"
export GARDEN_MAIN_BRANCH=main2

# common.sh + worker-common.sh supply die/scratch_cleanup/GARDEN_* and the SUT.
# shellcheck source=/dev/null
source "$JOBS_SRC/common.sh"
# shellcheck source=/dev/null
source "$JOBS_SRC/handlers/worker-common.sh"

# --- fake git shim: forwards to real git, but can fail `worktree add` ----------
# GIT_FAKE_LOCK_FAILS=<n>  → the first n `worktree add` invocations print a
#   realistic index.lock message to stderr and exit 1 (a lock-contention race).
# GIT_FAKE_HARD_FAIL=1     → every `worktree add` prints a NON-lock error and
#   exits 1 (a terminal error that must NOT be retried and MUST be re-emitted).
# A per-run counter file makes the "first n" deterministic across the retry loop.
SHIM="$TR/bin"; mkdir -p "$SHIM"
cat > "$SHIM/git" <<SHIMEOF
#!/bin/bash
REAL_GIT="$REAL_GIT"
SHIMEOF
cat >> "$SHIM/git" <<'SHIMEOF'
is_worktree_add=0
seen_worktree=0
for a in "$@"; do
  [ "$a" = worktree ] && seen_worktree=1 && continue
  [ "$seen_worktree" = 1 ] && [ "$a" = add ] && is_worktree_add=1
  [ "$seen_worktree" = 1 ] && break
done
if [ "$is_worktree_add" = 1 ]; then
  if [ "${GIT_FAKE_HARD_FAIL:-0}" = 1 ]; then
    printf 'fatal: invalid reference: bogus-ref-nonexistent\n' >&2
    exit 128
  fi
  if [ -n "${GIT_FAKE_LOCK_FAILS:-}" ] && [ -n "${GIT_FAKE_COUNTER:-}" ]; then
    n=0; [ -f "$GIT_FAKE_COUNTER" ] && n="$(cat "$GIT_FAKE_COUNTER")"
    n=$((n+1)); printf '%s' "$n" > "$GIT_FAKE_COUNTER"
    if [ "$n" -le "$GIT_FAKE_LOCK_FAILS" ]; then
      printf 'fatal: Unable to create '\''%s/worktrees/x/index.lock'\'': File exists.\n' "$PWD" >&2
      exit 128
    fi
  fi
fi
exec "$REAL_GIT" "$@"
SHIMEOF
chmod +x "$SHIM/git"
export PATH="$SHIM:$PATH"
hash -r   # bash caches command paths; force re-resolution so the shim wins

# === 1: clean success path — a fresh add returns 0 and creates the worktree ====
WT1="$GARDEN_SCRATCH/gardener-wt-case-clean"
if worker_ensure_worktree "$WT1" main2 false 2>"$TR/e1"; then
  [ -e "$WT1/.git" ] && ok "clean add creates the worktree and returns 0" \
    || bad "clean add returned 0 but no worktree at $WT1"
else
  bad "clean add unexpectedly failed: $(cat "$TR/e1")"
fi

# === 2: lock-contention race self-heals — fail twice, then succeed ============
WT2="$GARDEN_SCRATCH/gardener-wt-case-lock"
export GIT_FAKE_COUNTER="$TR/lockctr"; : > "$GIT_FAKE_COUNTER"
GIT_FAKE_LOCK_FAILS=2 worker_ensure_worktree "$WT2" main2 false 2>"$TR/e2"; rc=$?
if [ "$rc" -eq 0 ] && [ -e "$WT2/.git" ]; then
  ok "lock-contention add retries and eventually succeeds (rc=0)"
else
  bad "lock-contention add did not self-heal (rc=$rc): $(cat "$TR/e2")"
fi
tries="$(cat "$GIT_FAKE_COUNTER")"
[ "${tries:-0}" -ge 3 ] \
  && ok "the add was actually retried after the injected lock failures (attempts=$tries)" \
  || bad "expected >=3 add attempts (2 failures + success), saw ${tries:-0}"
unset GIT_FAKE_COUNTER

# === 3: a terminal (non-lock) error is NOT retried and IS re-emitted ==========
# worker_ensure_worktree calls die() on total failure; die() exits, so run it in a
# subshell and capture BOTH the exit and the combined output.
WT3="$GARDEN_SCRATCH/gardener-wt-case-hard"
out="$( GIT_FAKE_HARD_FAIL=1 bash -c '
  set -uo pipefail
  export GARDEN_TEST=1
  export GARDEN_ROOT="'"$GROOT"'" GARDEN_SCRATCH="'"$GROOT/scratch"'"
  source "'"$JOBS_SRC"'/common.sh"
  source "'"$JOBS_SRC"'/handlers/worker-common.sh"
  worker_ensure_worktree "'"$WT3"'" main2 false
' 2>&1 )"; rc=$?
if [ "$rc" -ne 0 ]; then
  ok "terminal add failure surfaces a non-zero exit (rc=$rc)"
else
  bad "terminal add failure did NOT fail the call (rc=0)"
fi
if printf '%s' "$out" | grep -q 'invalid reference: bogus-ref-nonexistent'; then
  ok "the real git stderr is re-emitted in the failure message (not swallowed)"
else
  bad "the git stderr was swallowed; message was: $out"
fi

# === 4: resume with an existing dir is left untouched =========================
WT4="$GARDEN_SCRATCH/gardener-wt-case-resume"
mkdir -p "$WT4"; printf 'in-flight\n' > "$WT4/marker"
worker_ensure_worktree "$WT4" main2 true 2>"$TR/e4"; rc=$?
if [ "$rc" -eq 0 ] && [ -f "$WT4/marker" ]; then
  ok "resume=true preserves an existing worktree as-is"
else
  bad "resume path clobbered or failed (rc=$rc)"
fi

echo
echo "worker-ensure-worktree-test: $PASS passed, $FAIL failed"
[ "$FAIL" -eq 0 ]
