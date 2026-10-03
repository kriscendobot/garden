#!/bin/bash
# Real Git + flock integration; all repositories live outside the garden root.
set -euo pipefail
JOBS="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
TR="$(mktemp -d /var/tmp/garden-repo-locks.XXXXXX)"
trap 'rm -rf "$TR"' EXIT
export GARDEN_TEST=1 GARDEN_ROOT="$TR/root" GARDEN_STATE="$TR/state"
export GARDEN_FETCH_RETRIES=1 GARDEN_FETCH_MAX_AGE=30 GARDEN_REPO_LOCK_WAIT=5
export GARDEN_LEADER_TTL=0
mkdir -p "$GARDEN_ROOT" "$TR/bin"
REAL_GIT="$(command -v git)"
# Resolve an inherited fleet wrapper for fixture setup.
case "$REAL_GIT" in */scripts/jobs/bin/git) REAL_GIT=/usr/bin/git ;; esac
export REAL_GIT TR
"$REAL_GIT" init -q --bare "$TR/upstream.git"
"$REAL_GIT" init -q -b journal2 "$TR/repo"
"$REAL_GIT" -C "$TR/repo" config user.name test
"$REAL_GIT" -C "$TR/repo" config user.email test@example.invalid
mkdir -p "$TR/repo/jobs/todo"
echo seed > "$TR/repo/seed"
"$REAL_GIT" -C "$TR/repo" add seed
"$REAL_GIT" -C "$TR/repo" commit -qm seed
"$REAL_GIT" -C "$TR/repo" remote add origin "$TR/upstream.git"
"$REAL_GIT" -C "$TR/repo" push -qu origin journal2
"$REAL_GIT" -C "$TR/repo" push -q origin HEAD:main2
"$REAL_GIT" -C "$TR/repo" worktree add -q --detach "$TR/linked"
ln -s "$TR/repo" "$TR/alias"
cat > "$TR/bin/real-git" <<'SHIM'
#!/bin/bash
for arg do
  if [ "$arg" = fetch ]; then
    echo fetch >> "$TR/fetches"
    [ ! -f "$TR/fail" ] || { echo 'test fetch failure' >&2; exit 19; }
    [ ! -f "$TR/hang" ] || sleep 20
    sleep "${TEST_FETCH_DELAY:-0.15}"
  fi
 done
exec "$REAL_GIT" "$@"
SHIM
chmod +x "$TR/bin/real-git"
export GARDEN_REAL_GIT="$TR/bin/real-git" JOURNAL_REMOTE="$TR/upstream.git"
source "$JOBS/common.sh"
fail() { echo "FAIL: $*" >&2; exit 1; }
count() { wc -l < "$TR/fetches"; }
assert_count() { [ "$(count)" = "$1" ] || fail "$2 (fetches=$(count), expected=$1)"; }
[ "$(garden_repo_key "$TR/repo")" = "$(garden_repo_key "$TR/linked")" ] || fail 'worktree identity'
[ "$(garden_repo_key "$TR/repo")" = "$(garden_repo_key "$TR/alias")" ] || fail 'symlink identity'
echo 'PASS: common git-dir identity'

pids=()
for n in {1..12}; do git -C "$TR/repo" fetch -q origin journal2 & pids+=("$!"); done
for pid in "${pids[@]}"; do wait "$pid" || fail 'parallel fetch'; done
assert_count 1 'parallel fetchers must coalesce'
git -C "$TR/linked" fetch -q origin journal2
# FETCH_HEAD is worktree-local, so the first linked-worktree fetch must run.
assert_count 2 'worktree FETCH_HEAD must be populated'
git -C "$TR/repo" fetch -q origin journal2
assert_count 2 'freshness acceptance'
GARDEN_FETCH_MAX_AGE_OVERRIDE=0 git -C "$TR/repo" fetch -q origin journal2
assert_count 3 'demand-fresh must refetch'
key="$(garden_repo_key "$TR/repo")"
for cache in "$GARDEN_STATE/repo-locks/$key"/fetch-*; do
  read -r _ oid < "$cache"
  printf '1 %s\n' "$oid" > "$cache"
done
git -C "$TR/repo" fetch -q origin journal2
assert_count 4 'expired timestamp must refetch'
echo 'PASS: 12 parallel requests -> 1 fetch (91.7% reduction); freshness and demand-fresh'

touch "$TR/fail"
if GARDEN_FETCH_MAX_AGE_OVERRIDE=0 git -C "$TR/repo" fetch -q origin journal2; then fail 'failed fetch passed'; fi
rm "$TR/fail"
git -C "$TR/repo" fetch -q origin journal2
assert_count 6 'failed fetch must invalidate old success'
echo 'PASS: failure never refreshes or preserves a stale cache'

before="$(count)"
pids=()
for n in {1..8}; do
  TEST_FETCH_DELAY=1 GARDEN_FETCH_MAX_AGE_OVERRIDE=0 git -C "$TR/repo" fetch -q origin journal2 & pids+=("$!")
done
for pid in "${pids[@]}"; do wait "$pid" || fail 'demand-fresh waiter'; done
assert_count "$((before + 1))" 'demand-fresh callers may share a fetch completed after arrival'
echo 'PASS: demand-fresh waiters coalesce an in-flight fetch'

touch "$TR/hang"
rc=0
GARDEN_REPO_GIT_TIMEOUT=0.3 GARDEN_FETCH_MAX_AGE_OVERRIDE=0 git -C "$TR/repo" fetch -q origin journal2 >/dev/null 2>&1 || rc=$?
[ "$rc" = 124 ] || fail "hung Git timeout rc=$rc"
rm "$TR/hang"
GARDEN_REPO_LOCK_WAIT=0.5 git -C "$TR/repo" fetch -q origin journal2 || fail 'timeout retained lock'
echo 'PASS: hung Git is terminated and its repository lock released'


# Separate clone-lock paths on linked worktrees still share one repository
# transaction from sync through push; the older clone lock alone cannot do this.
pids=()
for n in 1 2 3; do
  (
    case "$n" in 1) writer_repo="$TR/repo" ;; 2) writer_repo="$TR/linked" ;; 3) writer_repo="$TR/alias" ;; esac
    sync_clone "$writer_repo"
    mkdir "$TR/active-writer" || fail 'overlapping CAS writers'
    sleep 0.5
    echo "$n" > "$writer_repo/writer-$n"
    git -C "$writer_repo" add "writer-$n"
    rmdir "$TR/active-writer"
    commit_and_push "$writer_repo" "writer $n" || fail 'CAS writer rejected'
  ) & pids+=("$!")
done
for pid in "${pids[@]}"; do wait "$pid" || fail 'CAS writer process'; done
for n in 1 2 3; do "$REAL_GIT" --git-dir="$TR/upstream.git" cat-file -e "journal2:writer-$n" || fail 'lost writer'; done
"$REAL_GIT" -C "$TR/repo" reset -q --hard origin/journal2
echo 'PASS: parallel journal CAS writers across worktrees serialize and all writes land'

# Exercise the actual verify_fetch function from every watcher with a `fresh`
# argument. Its ordinary read is warm before another clone publishes a commit.
VERIFY="$TR/verify"
for watcher in dependabot-watcher comment-watcher ci-watcher issue-inbox-watcher pages-watcher approval-reconciler; do
  # shellcheck disable=SC1090 # load each production function verbatim
  source <(sed -n '/^verify_fetch() {/,/^}/p' "$JOBS/$watcher.sh")
  _VERIFY_FETCHED=''
  verify_fetch
  echo "$watcher" > "$TR/repo/verification"
  "$REAL_GIT" -C "$TR/repo" add verification
  "$REAL_GIT" -C "$TR/repo" commit -qm "verify $watcher"
  "$REAL_GIT" -C "$TR/repo" push -q origin journal2
  verify_fetch fresh
  [ "$("$REAL_GIT" -C "$VERIFY" rev-parse origin/journal2)" = "$("$REAL_GIT" -C "$TR/repo" rev-parse HEAD)" ] || fail "$watcher post-confirm reused a cached ref"
done
echo 'PASS: all six watcher post-confirm paths demand a fresh fetch'


# Shared readers overlap, exclusive writers time out, and another repo progresses.
(
  garden_repo_lock "$TR/repo" shared
  touch "$TR/held"
  sleep 1
) & holder=$!
for n in {1..100}; do [ -f "$TR/held" ] && break; sleep 0.01; done
GARDEN_REPO_LOCK_WAIT=0.1 git -C "$TR/linked" rev-parse HEAD >/dev/null || fail 'shared readers blocked'
rc=0
GARDEN_REPO_LOCK_WAIT=0.1 git -C "$TR/linked" update-ref refs/heads/blocked HEAD 2>"$TR/timeout" || rc=$?
[ "$rc" = 124 ] || fail "lock timeout rc=$rc"
grep -q 'garden repo lock: timeout' "$TR/timeout" || fail 'missing timeout diagnostic'
GARDEN_REPO_LOCK_WAIT=0.1 git --git-dir="$TR/upstream.git" rev-parse journal2 >/dev/null || fail 'unrelated repo blocked'
wait "$holder"
git -C "$TR/linked" update-ref refs/heads/unblocked HEAD
# Prove inherited descriptors borrow safely across an exec.
(garden_repo_lock "$TR/repo" exclusive; GARDEN_REPO_LOCK_WAIT=0.1 git -C "$TR/linked" rev-parse HEAD >/dev/null) || fail 'nested lock deadlocked'
echo 'PASS: shared reads, exclusive timeout, independent repos, release and reentrancy'

# A live repository-lock holder is ordinary fleet contention for clone users.
# Both acquisition sites must translate only rc=124 to EX_TEMPFAIL; any other
# repository-lock failure remains fatal.
rm -f "$TR/held"
(
  garden_repo_lock "$TR/repo" exclusive
  touch "$TR/held"
  sleep 2
) & holder=$!
for n in {1..100}; do [ -f "$TR/held" ] && break; sleep 0.01; done
rc=0
( GARDEN_REPO_LOCK_WAIT=0.1 clone_lock "$TR/linked" ) 2>"$TR/clone-lock-timeout" || rc=$?
[ "$rc" = "$GARDEN_OFFLINE_RC" ] || fail "clone_lock repository timeout rc=$rc"
grep -q 'repository lock for .* busy; skipping tick' "$TR/clone-lock-timeout" \
  || fail 'clone_lock repository timeout missing skip diagnostic'
! grep -q 'FATAL: repository lock unavailable' "$TR/clone-lock-timeout" \
  || fail 'clone_lock repository timeout escalated to fatal'
wait "$holder"

rc=0
(
  clone_lock() { :; }
  clone_unlock() { :; }
  garden_repo_lock() { return 124; }
  ensure_clone "$TR/repo"
) 2>"$TR/ensure-lock-timeout" || rc=$?
[ "$rc" = "$GARDEN_OFFLINE_RC" ] || fail "ensure_clone repository timeout rc=$rc"
grep -q 'repository lock for .* busy; skipping tick' "$TR/ensure-lock-timeout" \
  || fail 'ensure_clone repository timeout missing skip diagnostic'
! grep -q 'FATAL: repository lock unavailable' "$TR/ensure-lock-timeout" \
  || fail 'ensure_clone repository timeout escalated to fatal'

for site in clone_lock ensure_clone; do
  rc=0
  (
    garden_repo_lock() { return 23; }
    if [ "$site" = ensure_clone ]; then
      clone_lock() { :; }
      clone_unlock() { :; }
      ensure_clone "$TR/repo"
    else
      clone_lock "$TR/linked"
    fi
  ) 2>"$TR/$site-repo-error" || rc=$?
  [ "$rc" = 1 ] || fail "$site genuine repository error rc=$rc"
  grep -q 'FATAL: repository lock unavailable' "$TR/$site-repo-error" \
    || fail "$site genuine repository error was not fatal"
done
echo 'PASS: clone_lock and ensure_clone treat only repository-lock timeout as transient'

# An authorized maintenance request must report a refused operation, not
# 'applied', when its guard cannot acquire the repository.
rm "$TR/held"
(
  garden_repo_lock "$TR/repo" exclusive
  touch "$TR/held"
  sleep 2
) & holder=$!
for n in {1..100}; do [ -f "$TR/held" ] && break; sleep 0.01; done
GARDEN_ROOT_GUARD_REPO="$TR/repo" GARDEN_REPO_LOCK_WAIT=0.1 \
  GARDEN_SYSOP_MAINT_STATE="$TR/maintenance" bash "$JOBS/root-maintenance.sh" >"$TR/maintenance.log" 2>&1
grep -q '^outcome: refused$' "$TR/maintenance/result" || fail 'blocked maintenance reported success'
wait "$holder"
echo 'PASS: maintenance lock timeout reports refused, never applied'


# Dead-holder diagnostics never replace the flock inode.
rm "$TR/held"
(
  garden_repo_lock "$TR/repo" exclusive
  printf '99999999 1\n' > "$GARDEN_STATE/repo-locks/$key/repo.lock.holder.fake"
  touch "$TR/held"
  sleep 1
) & holder=$!
for n in {1..100}; do [ -f "$TR/held" ] && break; sleep 0.01; done
inode="$(stat -c %i "$GARDEN_STATE/repo-locks/$key/repo.lock")"
rc=0
GARDEN_REPO_LOCK_WAIT=0.1 git -C "$TR/repo" rev-parse HEAD 2>"$TR/stale" || rc=$?
[ "$rc" = 124 ] || fail 'stale metadata bypassed exclusion'
grep -q 'dead-holder pid=99999999' "$TR/stale" || fail 'stale holder not logged'
[ "$(stat -c %i "$GARDEN_STATE/repo-locks/$key/repo.lock")" = "$inode" ] || fail 'lock inode replaced'
wait "$holder"
echo 'PASS: stale holder detected without stealing the lock'

# A leader fetch failure must not stamp stale remote refs into a fresh cache.
export GARDEN_LEADER_CLONE="$TR/repo" GARDEN_LEADER_CACHE="$TR/leader-cache" GARDEN_LEADER=''
echo old-leader > "$GARDEN_LEADER_CACHE"
touch -d @1 "$GARDEN_LEADER_CACHE"
touch "$TR/fail"
[ "$(leader_host 2>"$TR/leader-error")" = old-leader ] || fail 'leader fallback changed'
[ "$(stat -c %Y "$GARDEN_LEADER_CACHE")" = 1 ] || fail 'stale leader marked fresh'
grep -q 'not fresh' "$TR/leader-error" || fail 'leader fallback not logged'
rm "$TR/fail"
echo 'PASS: leader outage retains fallback without refreshing its age'
echo 'All repository lock tests passed.'
