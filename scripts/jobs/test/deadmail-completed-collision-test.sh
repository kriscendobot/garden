#!/bin/bash
# deadmail-completed-collision-test.sh — rc=79 retires only a confirmed completion.
#
# post-job.sh exits GARDEN_COMPLETED_COLLISION_RC when the deterministic deadmail
# base already sits in tada/: an earlier tick promoted the entry and the job
# finished, but the retire never landed. deadmail must treat that as a terminal
# promotion (retire, no WARN) when the sharded tada/ completion is reachable on
# origin, and keep retrying when it is not.
set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
JOBS="$(cd "$HERE/.." && pwd)"
# shellcheck source=test-tmpdir.sh
source "$HERE/test-tmpdir.sh"

# shellcheck disable=SC2046 # variable names intentionally split into unset arguments
unset $(compgen -v 2>/dev/null | grep -E '^(GARDEN_|JOURNAL_|SELF_HEAL_|XDG_)' || true) 2>/dev/null || true
export GARDEN_TEST=1

TR="$(mktemp -d "$(garden_test_exec_tmpdir)/.garden-deadmail-collision.XXXXXXXX")"
trap 'rm -rf "$TR"' EXIT
git_id=(-c user.name=test -c user.email=test@localhost)
BRANCH=journal2
BARE="$TR/journal.git"
SEED="$TR/seed"
STATE="$TR/state"

git init -q "$SEED"
git -C "$SEED" checkout -q -b "$BRANCH"
mkdir -p "$SEED/inbox/dead" "$SEED/jobs/todo" "$SEED/jobs/doin" "$SEED/jobs/tada/2026/10/24"
for dir in inbox/dead jobs/todo jobs/doin; do touch "$SEED/$dir/.gitkeep"; done
for id in 01-done 02-unconfirmed; do
  printf 'from: peer\nto: finished-%s\nsent_at: 2026-10-24T11:00:00Z\n---\nfollow up\n' "$id" \
    > "$SEED/inbox/dead/$id.md"
done
# Only 01-done's promoted job is a confirmed, date-sharded completion.
printf -- '---\nstatus: done\n---\n' > "$SEED/jobs/tada/2026/10/24/deadmail-01-done.md"
git -C "$SEED" "${git_id[@]}" add -A
git -C "$SEED" "${git_id[@]}" commit -q -m seed
git init -q --bare "$BARE"
git -C "$SEED" remote add origin "$BARE"
git -C "$SEED" push -q -u origin "$BRANCH"

FAKE_POST="$TR/post-job"
cat > "$FAKE_POST" <<'FAKE'
#!/bin/bash
printf '%s\n' "$1" >> "$DEADMAIL_POST_CALLS"
echo "WARN: job '$1' collides with a COMPLETED job in tada/" >&2
exit 79
FAKE
chmod +x "$FAKE_POST"

fail=0
for tick in 1 2; do
  : > "$TR/calls"
  set +e
  env GARDEN=testhost GARDEN_STATE="$STATE" JOURNAL_REMOTE="$BARE" JOURNAL_BRANCH="$BRANCH" \
    GARDEN_DEADMAIL_POST_JOB="$FAKE_POST" DEADMAIL_POST_CALLS="$TR/calls" \
    "$JOBS/deadmail.sh" >"$TR/tick$tick.log" 2>&1
  rc=$?
  set -e
  remaining="$(git --git-dir="$BARE" ls-tree -r --name-only "$BRANCH" inbox/dead | grep '\.md$' | tr '\n' ' ')"
  warnings="$(grep -c 'WARN' "$TR/tick$tick.log" || true)"
  calls="$(wc -l < "$TR/calls")"
  # Tick 1 posts both and retires 01-done; tick 2 re-tries only 02-unconfirmed.
  want_calls=$((tick == 1 ? 2 : 1))
  if [ "$rc" -ne 0 ] || [ "$remaining" != "inbox/dead/02-unconfirmed.md " ] \
     || [ "$warnings" -ne 0 ] || [ "$calls" -ne "$want_calls" ]; then
    printf 'FAIL: tick %s: rc=%s remaining=[%s] warnings=%s calls=%s (wanted calls=%s)\n' \
      "$tick" "$rc" "$remaining" "$warnings" "$calls" "$want_calls"
    cat "$TR/tick$tick.log"
    fail=1
  else
    printf 'PASS: tick %s: rc=%s remaining=[%s] warnings=%s calls=%s\n' \
      "$tick" "$rc" "$remaining" "$warnings" "$calls"
  fi
done
if ! git --git-dir="$BARE" log --format=%s "$BRANCH" | grep -q 'deadmail: retired 01-done — deadmail-01-done already completed'; then
  echo "FAIL: missing retire commit for 01-done"; fail=1
fi
exit "$fail"
