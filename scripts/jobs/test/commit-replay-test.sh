#!/bin/bash
# commit-replay-test.sh — after a lost CAS, commit_and_push carries the commit onto
# the fresh journal tip through a scratch index (journal_replay_head) instead of
# handing every loss back to the caller's sync_clone loop. That loop's reset --hard
# over ~68k files took ~90s per attempt on loaded virtiofs, so every retry left
# from a stale tip and lost again (oros 2026-10-12 22:00-23:00Z: a completion at
# attempt 26, an inbox read at 39). A peer write to the same path is refused, so
# the caller still re-derives that edit from the new tip.
set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
JOBS="$(cd "$HERE/.." && pwd)"
TR="$(mktemp -d "${TMPDIR:-/tmp}/garden-commit-replay.XXXXXX")"
trap 'rm -rf "$TR"' EXIT

export GARDEN_TEST=1
export GARDEN=testhost
export GARDEN_STATE="$TR/state"
export GARDEN_NO_MAINTAINER_ALERT=1

BARE="$TR/journal.git"; SEED="$TR/seed"; PEER="$TR/peer"; CLONE="$TR/clone"
COUNT="$TR/push-count"; PEER_PATH="$TR/peer-path"
export JOURNAL_REMOTE="$BARE" GARDEN_JOURNAL_REPLAY_ATTEMPTS=3
git_id=(-c user.name=test -c user.email=test@example.invalid)
fail() { echo "FAIL: $*"; exit 1; }

git init -q --bare "$BARE"
git init -q "$SEED"
git -C "$SEED" checkout -q -b journal2
mkdir -p "$SEED/jobs/doin" "$SEED/msgs"
printf 'job\n' > "$SEED/jobs/doin/a.md"; printf 'shared\n' > "$SEED/msgs/shared"
git -C "$SEED" add jobs msgs
git -C "$SEED" "${git_id[@]}" commit -qm seed
git -C "$SEED" push -q "$BARE" journal2
git clone -q --single-branch --branch journal2 "$BARE" "$PEER"

# shellcheck source=../common.sh
source "$JOBS/common.sh"

# A peer's write lands just before the first push: a genuine non-fast-forward.
_push_journal() {
  local dir="$1" n
  n="$(cat "$COUNT" 2>/dev/null || echo 0)"; n=$((n + 1)); printf '%s\n' "$n" > "$COUNT"
  if [ "$n" -eq 1 ]; then
    git -C "$PEER" pull -q --ff-only origin journal2
    printf 'peer %s\n' "$RANDOM" > "$PEER/$(cat "$PEER_PATH")"
    git -C "$PEER" add -A
    git -C "$PEER" "${git_id[@]}" commit -qm 'peer write'
    git -C "$PEER" push -q origin HEAD:journal2
  fi
  # shellcheck disable=SC2034 # journal_push_head classifies this after the stub returns.
  GARDEN_PUSH_STDERR="$(git -C "$dir" push origin HEAD:journal2 2>&1 1>/dev/null)"
}
contention_record() { :; }
( ensure_clone "$CLONE" ) >/dev/null 2>&1
git -C "$CLONE" config user.name test; git -C "$CLONE" config user.email test@example.invalid

# 1. Disjoint peer write: the completion lands on the first replay, both survive.
printf 'msgs/peer-write\n' > "$PEER_PATH"; : > "$COUNT"
sync_clone "$CLONE"
mkdir -p "$CLONE/jobs/tada"; printf 'report\n' > "$CLONE/jobs/tada/a.md"
git -C "$CLONE" add jobs/tada/a.md; git -C "$CLONE" rm -q jobs/doin/a.md
rc=0; commit_and_push "$CLONE" 'tada(a) done' || rc=$?
[ "$rc" -eq 0 ] || fail "commit_and_push returned $rc after one disjoint lost CAS"
[ "$(cat "$COUNT")" -eq 2 ] || fail "expected 2 push attempts, saw $(cat "$COUNT")"
git --git-dir="$BARE" cat-file -e journal2:msgs/peer-write || fail "the peer's winning write was lost"
git --git-dir="$BARE" cat-file -e journal2:jobs/tada/a.md || fail "the replayed completion did not land"
git --git-dir="$BARE" cat-file -e journal2:jobs/doin/a.md 2>/dev/null && fail "the replayed deletion did not land"
[ "$(git --git-dir="$BARE" log -1 --format=%s journal2)" = 'tada(a) done' ] || fail "replay lost the commit message"
[ "$(git --git-dir="$BARE" diff --name-only journal2~1 journal2 | paste -sd' ')" = 'jobs/doin/a.md jobs/tada/a.md' ] \
  || fail "the replayed commit touched more than its own paths"
[ -z "$(git -C "$CLONE" status --porcelain)" ] || fail "replay left the clone dirty: $(git -C "$CLONE" status --porcelain)"
[ -f "$CLONE/msgs/peer-write" ] || fail "replay did not bring the peer delta into the worktree"

# 2. Overlapping peer write: refused, returned to the caller as the lost CAS.
printf 'msgs/shared\n' > "$PEER_PATH"; : > "$COUNT"
sync_clone "$CLONE"
printf 'mine\n' > "$CLONE/msgs/shared"; git -C "$CLONE" add msgs/shared
rc=0; commit_and_push "$CLONE" 'overlap' || rc=$?
[ "$rc" -eq 1 ] || fail "an overlapping replay returned $rc, not the lost CAS"
[ "$GARDEN_COMMIT_PUSH_CLASS" = cas ] || fail "refused replay lost the cas class ($GARDEN_COMMIT_PUSH_CLASS)"
[ "$(cat "$COUNT")" -eq 1 ] || fail "an overlapping replay pushed ($(cat "$COUNT") attempts)"
git --git-dir="$BARE" show journal2:msgs/shared | grep -q '^peer ' || fail "the peer's overlapping write was clobbered"

# 3. Unset (the default for every caller that has not opted in): one attempt only.
printf 'msgs/peer-write2\n' > "$PEER_PATH"; : > "$COUNT"
sync_clone "$CLONE"
printf 'x\n' > "$CLONE/msgs/mine2"; git -C "$CLONE" add msgs/mine2
unset GARDEN_JOURNAL_REPLAY_ATTEMPTS
rc=0; commit_and_push "$CLONE" 'no replay' || rc=$?
[ "$rc" -eq 1 ] && [ "$(cat "$COUNT")" -eq 1 ] || fail "commit_and_push replayed for a caller that did not opt in"

# The path-owned writers that starved on oros opt in.
grep -qx ': "${GARDEN_JOURNAL_REPLAY_ATTEMPTS:=3}"' "$JOBS/complete-job.sh" || fail "complete-job.sh does not opt in"
grep -qx ': "${GARDEN_JOURNAL_REPLAY_ATTEMPTS:=3}"' "$JOBS/inbox-read.sh" || fail "inbox-read.sh does not opt in"
grep -qx ': "${GARDEN_JOURNAL_REPLAY_ATTEMPTS:=3}"' "$JOBS/send-msg.sh" || fail "send-msg.sh does not opt in"
grep -qx ': "${GARDEN_JOURNAL_REPLAY_ATTEMPTS:=3}"' "$JOBS/journal-entry.sh" || fail "journal-entry.sh does not opt in"

# A machine sender can durably correlate its posted message with the consumer's
# later audit record. The generated id is exposed before posting and is exactly the
# basename that landed in the journal.
printf 'probe: correlation\n' > "$TR/body"
GARDEN_MSGID_FILE="$TR/msgid" GARDEN_PRODUCER_CLONE="$TR/send-clone" \
  "$JOBS/send-msg.sh" broadcast "$TR/body" >/dev/null 2>&1
msgid="$(cat "$TR/msgid" 2>/dev/null)"
[ -n "$msgid" ] || fail "send-msg.sh did not write GARDEN_MSGID_FILE"
git --git-dir="$BARE" cat-file -e "journal2:msgs/broadcast/$msgid.md" \
  || fail "GARDEN_MSGID_FILE did not name the message that landed"

echo 'PASS: a lost journal CAS is replayed onto the fresh tip without the working tree'
