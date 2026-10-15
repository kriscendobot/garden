#!/bin/bash
# watchdog-notice-cas-test.sh — a same-key lost race is re-derived from the
# winning journal tip through plumbing, without changing the producer worktree.
set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
JOBS="$(cd "$HERE/.." && pwd)"
# shellcheck source=test-tmpdir.sh
source "$HERE/test-tmpdir.sh"
TEST_TMPDIR="$(garden_test_exec_tmpdir)"
TR="$(mktemp -d "$TEST_TMPDIR/.garden-watchdog-cas-test.XXXXXX")"
trap 'rm -rf "$TR"' EXIT

# shellcheck disable=SC2046 # unset consumes the generated variable names as words.
unset $(compgen -v 2>/dev/null | grep -E '^(GARDEN_|JOURNAL_|SELF_HEAL_)' || true) 2>/dev/null || true
export GARDEN_TEST=1 GARDEN=testhost GARDEN_STATE="$TR/state"
export JOURNAL_BRANCH=journal2 GARDEN_POST_ATTEMPTS=3 GARDEN_NO_MAINTAINER_ALERT=1
BARE="$TR/journal.git"; SEED="$TR/seed"; PEER="$TR/peer"; CLONE="$TR/producer"
REL=inbox/maintainer/unread/watchdog-race.md
REAL_GIT="$(command -v git)"
git_id=(-c user.name=test -c user.email=test@example.invalid)
fail() { echo "FAIL: $*"; exit 1; }

"$REAL_GIT" init -q --bare "$BARE"
"$REAL_GIT" init -q "$SEED"
"$REAL_GIT" -C "$SEED" checkout -q -b journal2
mkdir -p "$SEED/$(dirname "$REL")"
printf '%s\n' \
  'from_host: first' 'from: watchdog:test' 'sent_at: 2026-10-15T00:00:00Z' \
  'watchdog_key: race' 'notice_count: 4' 'first_seen: 2026-10-15T00:00:00Z' \
  'last_seen: 2026-10-15T00:00:00Z' '---' 'old detail' > "$SEED/$REL"
"$REAL_GIT" -C "$SEED" add "$REL"
"$REAL_GIT" -C "$SEED" "${git_id[@]}" commit -qm seed
"$REAL_GIT" -C "$SEED" remote add origin "$BARE"
"$REAL_GIT" -C "$SEED" push -q origin HEAD:journal2
"$REAL_GIT" clone -q --single-branch --branch journal2 "$BARE" "$PEER"
"$REAL_GIT" clone -q --single-branch --branch journal2 "$BARE" "$CLONE"

# The push hook lands an overlapping peer amend immediately before watchdog's
# first push. The first CAS must lose; the second must read count 7 and publish 8.
before_file="$(sha256sum "$CLONE/$REL")"
before_index="$(sha256sum "$CLONE/.git/index")"
printf 'latest detail\n' | env REAL_GIT="$REAL_GIT" WATCHDOG_CAS_PEER="$PEER" \
  WATCHDOG_CAS_MARK="$TR/raced" GARDEN_PUSH_CMD="$HERE/fixtures/watchdog-notice-racing-push.sh" \
  JOURNAL_REMOTE="$BARE" GARDEN_PRODUCER_CLONE="$CLONE" \
  "$JOBS/watchdog-notice.sh" race > "$TR/output" 2>&1

[ -e "$TR/raced" ] || fail "the injected competing push did not run"
[ "$("$REAL_GIT" --git-dir="$BARE" show journal2:"$REL" | sed -n 's/^notice_count: *//p')" = 8 ] \
  || fail "the retry did not re-derive count 8 from the peer's count 7"
"$REAL_GIT" --git-dir="$BARE" show journal2:"$REL" | grep -q 'latest detail' \
  || fail "the replayed notice lost its latest body"
[ "$(sha256sum "$CLONE/$REL")" = "$before_file" ] \
  || fail "the producer worktree notice was modified"
[ "$(sha256sum "$CLONE/.git/index")" = "$before_index" ] \
  || fail "the producer index was modified"
grep -q 'replaying from the fresh tip' "$TR/output" \
  || fail "the lost CAS was not reported as a replay"

echo 'PASS: watchdog notice replayed a lost same-key CAS without touching the worktree'
