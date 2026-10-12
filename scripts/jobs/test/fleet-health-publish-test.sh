#!/bin/bash
# fleet-health-publish-test.sh — publish_fleet_health grafts this host's records
# onto the fresh journal tip through a scratch index, never the working tree. The
# worktree path (sync_clone's reset --hard over ~68k files) took 63-105s per attempt
# on loaded virtiofs, so every post-deploy `deployed` push left from a stale tip and
# lost the CAS (oros 2026-10-12 19:49-20:10Z: 15/15 attempts lost, leader kept
# reading roll-drained).
set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
JOBS="$(cd "$HERE/.." && pwd)"
TR="$(mktemp -d "${TMPDIR:-/tmp}/garden-fleet-health-publish.XXXXXX")"
trap 'rm -rf "$TR"' EXIT

export GARDEN_TEST=1
export GARDEN=testhost
export GARDEN_STATE="$TR/state"
export GARDEN_NO_MAINTAINER_ALERT=1

BARE="$TR/journal.git"; SEED="$TR/seed"; PEER="$TR/peer"
CLONE="$TR/fleet-health"; COUNT="$TR/push-count"; CLASSES="$TR/push-classes"
export JOURNAL_REMOTE="$BARE" GARDEN_FLEET_HEALTH_CLONE="$CLONE"
git_id=(-c user.name=test -c user.email=test@example.invalid)
fail() { echo "FAIL: $*"; exit 1; }

git init -q --bare "$BARE"
git init -q "$SEED"
git -C "$SEED" checkout -q -b journal2
mkdir -p "$SEED/msgs"; printf 'seed\n' > "$SEED/msgs/seed"
git -C "$SEED" add msgs/seed
git -C "$SEED" "${git_id[@]}" commit -qm seed
git -C "$SEED" push -q "$BARE" journal2
git clone -q --single-branch --branch journal2 "$BARE" "$PEER"

# shellcheck source=../common.sh
source "$JOBS/common.sh"

fleet_unit_health() { echo '0 7 - 0'; }
is_main_host() { return 1; }
# A peer's write lands just before the first push: a genuine non-fast-forward.
_push_journal() {
  local dir="$1" n
  n="$(cat "$COUNT" 2>/dev/null || echo 0)"; n=$((n + 1)); printf '%s\n' "$n" > "$COUNT"
  if [ "$n" -eq 1 ]; then
    printf 'peer\n' > "$PEER/msgs/peer-write"
    git -C "$PEER" add msgs/peer-write
    git -C "$PEER" "${git_id[@]}" commit -qm 'peer write'
    git -C "$PEER" push -q origin HEAD:journal2
  fi
  # shellcheck disable=SC2034 # journal_push_head classifies this after the stub returns.
  GARDEN_PUSH_STDERR="$(git -C "$dir" push origin HEAD:journal2 2>&1 1>/dev/null)"
}
contention_record() { [ "$2" != push-class ] || printf '%s\n' "$3" >> "$CLASSES"; }
backoff() { :; }
SYNCS="$TR/syncs"; : > "$SYNCS"
eval "_orig_sync_clone() $(declare -f sync_clone | tail -n +2)"
sync_clone() { echo sync >> "$SYNCS"; _orig_sync_clone "$@"; }
( ensure_clone "$CLONE" ) >/dev/null 2>&1
: > "$CLASSES"

publish_fleet_health abc123def4567890 deployed || fail "publish exhausted after one lost CAS"

[ "$(cat "$COUNT")" -eq 2 ] || fail "expected 2 push attempts, saw $(cat "$COUNT")"
[ "$(paste -sd' ' "$CLASSES")" = cas ] || fail "first push was not classified as a lost CAS"
[ ! -s "$SYNCS" ] || fail "publish re-synced the working tree ($(wc -l < "$SYNCS") sync_clone call(s))"
git --git-dir="$BARE" cat-file -e journal2:msgs/peer-write || fail "the peer's winning write was lost"
rec="$(git --git-dir="$BARE" show "journal2:$GARDEN_FLEET_HEALTH_PATH/testhost")"
grep -qx 'roll_status: deployed' <<<"$rec" || fail "health record missing roll_status: $rec"
grep -qx 'unit_total: 7' <<<"$rec" || fail "health record missing unit_total: $rec"
[ "$(git --git-dir="$BARE" show "journal2:$GARDEN_FLEET_DEPLOYED_PATH/testhost")" = abc123def4567890 ] \
  || fail "deployed sha record wrong"
[ "$(git --git-dir="$BARE" diff --name-only journal2~1 journal2 | sort | paste -sd' ')" \
  = "$(printf '%s\n' "$GARDEN_FLEET_DEPLOYED_PATH/testhost" "$GARDEN_FLEET_HEALTH_PATH/testhost" | sort | paste -sd' ')" ] \
  || fail "the publish commit touched more than this host's records"
git --git-dir="$BARE" cat-file -e "journal2:$GARDEN_DEPLOY_LEADER_SHA_PATH" 2>/dev/null \
  && fail "a follower wrote deploy/leader-sha"

# The leader also records deploy/leader-sha on a `deployed` publish.
is_main_host() { return 0; }
publish_fleet_health 0123456789abcdef deployed || fail "leader publish failed"
[ "$(git --git-dir="$BARE" show "journal2:$GARDEN_DEPLOY_LEADER_SHA_PATH")" = 0123456789abcdef ] \
  || fail "leader publish did not record deploy/leader-sha"

# A fetch failure falls back to the self-healing sync_clone once.
: > "$SYNCS"
GARDEN_FETCH_CMD=false GARDEN_FETCH_RETRIES=1 publish_fleet_health 0123456789abcdef roll-drained \
  && fail "publish succeeded with every fetch failing"
[ -s "$SYNCS" ] || fail "a fetch failure did not fall back to sync_clone"

# The next ordinary sync leaves a clean checkout at the published tip.
_orig_sync_clone "$CLONE"; clone_unlock "$CLONE"
[ -z "$(git -C "$CLONE" status --porcelain)" ] || fail "clone left dirty after publish"

echo 'PASS: fleet health publishes onto the fresh tip without touching the working tree'
