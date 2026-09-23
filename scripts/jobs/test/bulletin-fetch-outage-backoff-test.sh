#!/bin/bash
# bulletin-fetch-outage-backoff-test.sh — a repeated bounded journal-fetch
# failure is one quiet outage episode with capped exponential retry delays, and a
# successful sync clears the episode without retaining the outage delay.
set -euo pipefail
export GARDEN_TEST=1
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
JOBS="$(cd "$HERE/.." && pwd)"
TR="$(mktemp -d "${TMPDIR:-/var/tmp}/garden-bulletin-fetch-backoff.XXXXXX")"
trap 'rm -rf "$TR"' EXIT
BARE="$TR/journal.git"; SEED="$TR/seed"; BIN="$TR/bin"
mkdir -p "$BIN" "$TR/state"

git init -q --bare "$BARE"
git init -q "$SEED"; git -C "$SEED" checkout -q -b journal2
mkdir -p "$SEED/jobs/todo" "$SEED/jobs/doin" "$SEED/jobs/tada" \
  "$SEED/jobs/plan" "$SEED/entries" "$SEED/inbox/maintainer/unread" \
  "$SEED/hosts" "$SEED/repos"
touch "$SEED/jobs/todo/.gitkeep" "$SEED/jobs/doin/.gitkeep" \
  "$SEED/jobs/tada/.gitkeep" "$SEED/entries/.gitkeep"
git -C "$SEED" add -A
git -C "$SEED" -c user.name=test -c user.email=test@localhost commit -q -m seed
git -C "$SEED" remote add origin "$BARE"; git -C "$SEED" push -q -u origin journal2

# Fail the first three bounded fetches with a recognized network-outage
# signature, then delegate every later fetch to real git so the bulletin can
# reconcile and prove that it immediately leaves the backoff path.
cat > "$TR/fetch" <<'EOF'
#!/bin/bash
n=0; read -r n < "$FETCH_COUNT" 2>/dev/null || true; n=$((n + 1)); printf '%s\n' "$n" > "$FETCH_COUNT"
if [ "$n" -le 3 ]; then
  echo 'fatal: unable to access: Could not resolve host: github.com' >&2
  exit 128
fi
exec git -C "$GARDEN_FETCH_DIR" fetch -q origin "+refs/heads/$JOURNAL_BRANCH:refs/remotes/origin/$JOURNAL_BRANCH"
EOF

# Record sleeps without waiting. With base=1/cap=2 the outage ladder must be
# exactly 1,2,2. A fifth (post-recovery idle) tick exits at MAX_ITERS before its
# normal idle sleep, so any fourth line means the outage delay leaked.
cat > "$BIN/sleep" <<'EOF'
#!/bin/sh
printf '%s\n' "$1" >> "$SLEEP_LOG"
EOF
cat > "$TR/handler" <<'EOF'
#!/bin/sh
echo 'Recovered bulletin narrative.'
EOF
chmod +x "$TR/fetch" "$BIN/sleep" "$TR/handler"

export FETCH_COUNT="$TR/fetch-count" SLEEP_LOG="$TR/sleeps"
LOG="$TR/bulletin.log"
env PATH="$BIN:$PATH" GARDEN=testhost GARDEN_LEADER=testhost \
  GARDEN_ROOT="$(cd "$JOBS/../.." && pwd)" GARDEN_STATE="$TR/state" \
  JOURNAL_REMOTE="$BARE" JOURNAL_BRANCH=journal2 GARDEN_FETCH_CMD="$TR/fetch" \
  GARDEN_FETCH_RETRIES=1 GARDEN_BULLETIN_MAX_ITERS=5 \
  GARDEN_BULLETIN_IDLE_SLEEP=99 GARDEN_BULLETIN_FETCH_BACKOFF_BASE=1 \
  GARDEN_BULLETIN_FETCH_BACKOFF_CAP=2 GARDEN_BULLETIN_HANDLER="$TR/handler" \
  GARDEN_BULLETIN_PARKED_CMD=/bin/true "$JOBS/bulletin.sh" >/dev/null 2>"$LOG"

[ "$(grep -c 'journal fetch outage started' "$LOG" || true)" -eq 1 ] \
  || { echo 'FAIL: outage did not produce exactly one opening warning'; cat "$LOG"; exit 1; }
[ "$(grep -c 'journal fetch outage cleared after 3 failed tick(s)' "$LOG" || true)" -eq 1 ] \
  || { echo 'FAIL: recovery did not close the three-failure episode once'; cat "$LOG"; exit 1; }
[ "$(grep -c 'journal fetch in .* failed after' "$LOG" || true)" -eq 0 ] \
  || { echo 'FAIL: repeated bounded-fetch diagnostics escaped episode suppression'; cat "$LOG"; exit 1; }
[ "$(paste -sd, "$SLEEP_LOG")" = '1,2,2' ] \
  || { echo "FAIL: expected capped retry sleeps 1,2,2; got $(paste -sd, "$SLEEP_LOG")"; exit 1; }
[ "$(cat "$FETCH_COUNT")" -ge 5 ] \
  || { echo 'FAIL: bulletin did not continue promptly after the recovering sync'; exit 1; }

echo 'PASS: bulletin coalesces a fetch outage, backs off exponentially to its cap, and resumes on sync recovery'
