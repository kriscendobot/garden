#!/bin/bash
# journal-clone-base-test.sh — container-local worker/producer clone selection.
set -euo pipefail

HERE="$(cd "$(dirname "$0")" && pwd)"
JOBS="$(cd "$HERE/.." && pwd)"
# shellcheck source=test-tmpdir.sh
source "$HERE/test-tmpdir.sh"
TR="$(mktemp -d "$(garden_test_exec_tmpdir)/journal-clone-base.XXXXXXXX")"
trap 'rm -rf "$TR"' EXIT

PASS=0
FAIL=0
ok() { echo "  PASS: $*"; PASS=$((PASS + 1)); }
bad() { echo "  FAIL: $*"; FAIL=$((FAIL + 1)); }
check_equal() {
  local label="$1" actual="$2" expected="$3"
  if [ "$actual" = "$expected" ]; then ok "$label"; else bad "$label (got '$actual', want '$expected')"; fi
}

BARE="$TR/journal.git"
SEED="$TR/seed"
git init -q --bare "$BARE"
git init -q "$SEED"
git -C "$SEED" checkout -q -b journal2
mkdir -p "$SEED/jobs/todo"
printf 'seed\n' > "$SEED/jobs/todo/seed.md"
git -C "$SEED" add jobs/todo/seed.md
git -C "$SEED" -c user.name=test -c user.email=test@localhost commit -q -m seed
git -C "$SEED" push -q "$BARE" journal2

STATE="$TR/shared-state"
LOCAL_BASE="$TR/container-local"
mkdir -p "$STATE"
export GARDEN_TEST=1 GARDEN_ROOT="$TR/root" GARDEN_STATE="$STATE"
export JOURNAL_REMOTE="$BARE" JOURNAL_BRANCH=journal2
export GARDEN_JOURNAL_CLONE_BASE="$LOCAL_BASE"
unset GARDEN_PRODUCER_CLONE GARDEN_WORKER_CLONE
# shellcheck source=../common.sh
source "$JOBS/common.sh"

check_equal "producer clone moves to the configured local base" \
  "$GARDEN_PRODUCER_CLONE" "$LOCAL_BASE/producer/journal"
check_equal "worker clone selector preserves the kind/id namespace" \
  "$(journal_clone_path monks/7/journal)" "$LOCAL_BASE/monks/7/journal"
check_equal "moved producer clone keeps its historical state lock" \
  "$(_clone_lockfile "$GARDEN_PRODUCER_CLONE")" "$STATE/producer/journal.lock"
check_equal "moved worker clone keeps its historical state lock" \
  "$(_clone_lockfile "$LOCAL_BASE/monks/7/journal")" "$STATE/monks/7/journal.lock"

ensure_clone "$GARDEN_PRODUCER_CLONE"
sync_clone "$GARDEN_PRODUCER_CLONE"
if [ -f "$GARDEN_PRODUCER_CLONE/jobs/todo/seed.md" ]; then
  ok "an empty container-local base is reseeded and synced"
else
  bad "empty container-local base was not reseeded"
fi
clone_unlock "$GARDEN_PRODUCER_CLONE"
if [ -f "$STATE/producer/journal.lock" ] && [ ! -e "$LOCAL_BASE/producer/journal.lock" ]; then
  ok "clone operations leave the lock in shared state, not beside the local clone"
else
  bad "clone operation put its lock in the wrong filesystem"
fi

default_path="$({
  unset GARDEN_JOURNAL_CLONE_BASE GARDEN_PRODUCER_CLONE
  export GARDEN_ROOT="$TR/default-root" GARDEN_STATE="$TR/default-state"
  source "$JOBS/common.sh"
  journal_clone_path clerics/3/journal
})"
check_equal "unset knob preserves the historical worker path" \
  "$default_path" "$TR/default-state/clerics/3/journal"

explicit="$TR/operator-explicit-producer"
explicit_result="$({
  export GARDEN_ROOT="$TR/explicit-root" GARDEN_STATE="$TR/explicit-state"
  export GARDEN_JOURNAL_CLONE_BASE="$TR/other-local" GARDEN_PRODUCER_CLONE="$explicit"
  source "$JOBS/common.sh"
  printf '%s\n' "$GARDEN_PRODUCER_CLONE"
})"
check_equal "an explicit producer-clone override still wins" "$explicit_result" "$explicit"

echo
echo "journal-clone-base-test: $PASS passed, $FAIL failed"
[ "$FAIL" -eq 0 ]
