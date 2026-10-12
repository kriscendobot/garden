#!/bin/bash
# namespace-clone-orphan-sweep-test.sh - namespace-clone-maintenance removes
# clone siblings stranded by a killed clone/swap (dead pid, aged), and keeps
# live or fresh ones.

set -euo pipefail
export GARDEN_TEST=1
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
JOBS="$(cd "$HERE/.." && pwd)"
TR="$(mktemp -d "${TMPDIR:-/tmp}/garden-ns-orphan.XXXXXX")"
trap 'rm -rf "$TR"' EXIT

sleep 0 & dead=$!; wait "$dead"
live=$$
S="$TR/state"
mkdir -p "$S/alpha" "$S/scaler" "$S/inbox/job-x"
git init -q "$S/alpha/journal"
mkdir -p "$S/alpha/journal.reclone.$dead.1/objects" \
         "$S/inbox/job-x/journal.reclone.$dead.2" \
         "$S/scaler/journal.budget-stale.$live" \
         "$S/scaler/journal.budget-reclone.$dead.reclone.$dead.1"

run() {
  GARDEN_STATE="$S" GARDEN_NS_CLONE_JITTER=0 GARDEN_NS_CLONE_PACK_THRESHOLD=999 \
    GARDEN_NS_CLONE_NOTICE=/bin/true GARDEN_CONTENTION_INSTRUMENT=0 \
    "$@" "$JOBS/namespace-clone-maintenance.sh" 2>>"$TR/err"
}
fail() { echo "FAIL: $*"; cat "$TR/err"; exit 1; }

# Fresh dead-pid orphans are kept (a just-killed clone may still be settling).
run env GARDEN_NS_CLONE_TMP_MAX_AGE_MIN=999
[ -d "$S/alpha/journal.reclone.$dead.1" ] || fail 'fresh dead-pid orphan removed'

# Aged dead-pid orphans go, at depth 2 and 3; a live pid keeps its dir.
run env GARDEN_NS_CLONE_TMP_MAX_AGE_MIN=0 GARDEN_NS_CLONE_ORPHAN_MAX_AGE_MIN=999
[ ! -e "$S/alpha/journal.reclone.$dead.1" ] || fail 'depth-2 dead-pid orphan kept'
[ ! -e "$S/inbox/job-x/journal.reclone.$dead.2" ] || fail 'depth-3 dead-pid orphan kept'
[ ! -e "$S/scaler/journal.budget-reclone.$dead.reclone.$dead.1" ] || fail 'budget-reclone orphan kept'
[ -d "$S/scaler/journal.budget-stale.$live" ] || fail 'live-pid sibling removed'
[ -d "$S/alpha/journal/.git" ] || fail 'real namespace clone removed'

# Past the orphan max age, even a (reused) live pid no longer protects it.
run env GARDEN_NS_CLONE_TMP_MAX_AGE_MIN=0 GARDEN_NS_CLONE_ORPHAN_MAX_AGE_MIN=0
[ ! -e "$S/scaler/journal.budget-stale.$live" ] || fail 'over-age live-pid sibling kept'
[ -d "$S/alpha/journal/.git" ] || fail 'real namespace clone removed'
grep -q 'removed 3 orphaned clone sibling(s)' "$TR/err" || fail 'no coalesced removal summary'

echo 'PASS: orphaned clone siblings are swept by pid liveness and ctime age'
