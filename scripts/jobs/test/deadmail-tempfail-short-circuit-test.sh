#!/bin/bash
# deadmail-tempfail-short-circuit-test.sh — transient post failures stop a tick.
set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
JOBS="$(cd "$HERE/.." && pwd)"
# shellcheck source=test-tmpdir.sh
source "$HERE/test-tmpdir.sh"

# shellcheck disable=SC2046 # variable names intentionally split into unset arguments
unset $(compgen -v 2>/dev/null | grep -E '^(GARDEN_|JOURNAL_|SELF_HEAL_|XDG_)' || true) 2>/dev/null || true
export GARDEN_TEST=1

TR="$(mktemp -d "$(garden_test_exec_tmpdir)/.garden-deadmail-tempfail.XXXXXXXX")"
lock_holder=""
trap '[ -z "$lock_holder" ] || kill "$lock_holder" 2>/dev/null || true; rm -rf "$TR"' EXIT
git_id=(-c user.name=test -c user.email=test@localhost)
BRANCH=journal2
BARE="$TR/journal.git"
SEED="$TR/seed"
STATE="$TR/state"

git init -q "$SEED"
git -C "$SEED" checkout -q -b "$BRANCH"
mkdir -p "$SEED/inbox/dead" "$SEED/jobs/todo" "$SEED/jobs/doin" "$SEED/jobs/tada"
for dir in inbox/dead jobs/todo jobs/doin jobs/tada; do touch "$SEED/$dir/.gitkeep"; done
for id in 01-first 02-second 03-third; do
  printf 'from: peer\nto: finished-%s\nsent_at: 2026-10-06T18:00:00Z\n---\nfollow up\n' "$id" \
    > "$SEED/inbox/dead/$id.md"
done
git -C "$SEED" "${git_id[@]}" add -A
git -C "$SEED" "${git_id[@]}" commit -q -m seed
git init -q --bare "$BARE"
git -C "$SEED" remote add origin "$BARE"
git -C "$SEED" push -q -u origin "$BRANCH"

FAKE_POST="$TR/post-job"
cat > "$FAKE_POST" <<'EOF'
#!/bin/bash
printf '%s\n' "$1" >> "$DEADMAIL_POST_CALLS"
exit "$DEADMAIL_POST_RC"
EOF
chmod +x "$FAKE_POST"

run_case() { # expected-rc post-rc expected-calls expected-warnings label
  local expected_rc="$1" post_rc="$2" expected_calls="$3" expected_warnings="$4" label="$5" rc calls warnings
  : > "$TR/calls"
  set +e
  env GARDEN=testhost GARDEN_STATE="$STATE" JOURNAL_REMOTE="$BARE" JOURNAL_BRANCH="$BRANCH" \
    GARDEN_DEADMAIL_POST_JOB="$FAKE_POST" DEADMAIL_POST_CALLS="$TR/calls" \
    DEADMAIL_POST_RC="$post_rc" "$JOBS/deadmail.sh" >"$TR/$label.log" 2>&1
  rc=$?
  set -e
  calls="$(wc -l < "$TR/calls")"
  warnings="$(grep -c 'WARN post of' "$TR/$label.log" || true)"
  if [ "$rc" -ne "$expected_rc" ] || [ "$calls" -ne "$expected_calls" ] || [ "$warnings" -ne "$expected_warnings" ]; then
    printf 'FAIL: %s: rc=%s calls=%s warnings=%s (wanted rc=%s calls=%s warnings=%s)\n' \
      "$label" "$rc" "$calls" "$warnings" "$expected_rc" "$expected_calls" "$expected_warnings"
    cat "$TR/$label.log"
    return 1
  fi
  printf 'PASS: %s: rc=%s calls=%s warnings=%s\n' "$label" "$rc" "$calls" "$warnings"
}

run_case 75 124 1 1 timeout-short-circuits
run_case 0 75 1 0 ex-tempfail-quietly-defers
run_case 0 2 3 3 item-failures-continue

# Exercise the real post-job lock path. A live producer holds the shared clone
# lock, so deadmail must use its short soft wait, retain every queued entry, and
# finish cleanly without waiting for the outer 120-second timeout.
PRODUCER_LOCK="$STATE/producer/journal.lock"
mkdir -p "$(dirname "$PRODUCER_LOCK")"
: > "$PRODUCER_LOCK"
flock "$PRODUCER_LOCK" sleep 60 &
lock_holder=$!
sleep 0.1
start=$SECONDS
set +e
env GARDEN=testhost GARDEN_STATE="$STATE" JOURNAL_REMOTE="$BARE" JOURNAL_BRANCH="$BRANCH" \
  GARDEN_DEADMAIL_POST_LOCK_WAIT=1 "$JOBS/deadmail.sh" >"$TR/live-lock.log" 2>&1
rc=$?
set -e
elapsed=$((SECONDS - start))
kill "$lock_holder" 2>/dev/null || true
wait "$lock_holder" 2>/dev/null || true
lock_holder=""
remaining="$(git --git-dir="$BARE" ls-tree -r --name-only "$BRANCH" inbox/dead | grep -c '\.md$' || true)"
warnings="$(grep -c 'WARN post of' "$TR/live-lock.log" || true)"
if [ "$rc" -ne 0 ] || [ "$elapsed" -ge 10 ] || [ "$remaining" -ne 3 ] || [ "$warnings" -ne 0 ]; then
  printf 'FAIL: live-lock: rc=%s elapsed=%ss remaining=%s warnings=%s\n' \
    "$rc" "$elapsed" "$remaining" "$warnings"
  cat "$TR/live-lock.log"
  exit 1
fi
printf 'PASS: live-lock: rc=%s elapsed=%ss remaining=%s warnings=%s\n' \
  "$rc" "$elapsed" "$remaining" "$warnings"
