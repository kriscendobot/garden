#!/bin/bash
# api-cooldown-test.sh - guard the host-shared GitHub API watcher cooldown.
#
# Systemd watcher instances share GARDEN_ROOT but may use independently namespaced
# GARDEN_STATE directories. The cooldown must therefore resolve below GARDEN_ROOT,
# serialize concurrent detectors on one lock inode, and remain visible to later ticks.

set -euo pipefail
export GARDEN_TEST=1
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
JOBS="$(cd "$HERE/.." && pwd)"
PASS=0; FAIL=0
ok()  { echo "  PASS: $*"; PASS=$((PASS + 1)); }
bad() { echo "  FAIL: $*"; FAIL=$((FAIL + 1)); }

unset GARDEN_API_COOLDOWN_DIR GARDEN_API_COOLDOWN_MARKER GARDEN_API_COOLDOWN_LOCK
TR="$(mktemp -d "${TMPDIR:-/tmp}/api-cooldown.XXXXXX")"
trap 'rm -rf "$TR"' EXIT
ROOT="$TR/rendered-root"
mkdir -p "$ROOT"
MARKER="$ROOT/.garden-state/gh-api-cooldown/marker"

run_common() {  # run_common <state-namespace> <shell-body>
  # shellcheck disable=SC2016
  env GARDEN_ROOT="$ROOT" GARDEN_STATE="$TR/state/$1" GARDEN_API_COOLDOWN_SECS=300 \
    bash -c 'source "$1"; eval "$2"' _ "$JOBS/common.sh" "$2"
}

# A detector in one service namespace must publish into the host root, not its own
# GARDEN_STATE. A sibling namespace must see the same live marker.
run_common ci 'start_api_cooldown "ci:first"'
if [ -s "$MARKER" ]; then
  ok "detector writes the cooldown below the shared GARDEN_ROOT"
else
  bad "detector did not write $MARKER"
fi
if [ ! -e "$TR/state/ci/gh-api-cooldown/marker" ]; then
  ok "cooldown is not stranded in the invocation-local GARDEN_STATE"
else
  bad "cooldown leaked into an invocation-local state namespace"
fi
if run_common comment 'api_cooldown_active'; then
  ok "a sibling watcher namespace sees the host cooldown"
else
  bad "a sibling watcher namespace missed the host cooldown"
fi

# Remove the first episode, then race independent unit-shaped ticks. flock must
# allow exactly one detector to open the episode while every process uses a distinct
# GARDEN_STATE directory. The resulting marker must survive after all ticks exit.
rm -f "$MARKER"
RESULTS="$TR/results"
mkdir -p "$RESULTS"
for n in 1 2 3 4 5 6 7 8; do
  (
    if run_common "race-$n" "start_api_cooldown race-$n"; then
      printf 'opened\n' > "$RESULTS/$n"
    else
      printf 'observed\n' > "$RESULTS/$n"
    fi
  ) &
done
wait
opened="$(grep -l '^opened$' "$RESULTS"/* | wc -l)"
if [ "$opened" -eq 1 ]; then
  ok "eight concurrent watcher ticks produce one cooldown-opening transition"
else
  bad "concurrent ticks produced $opened cooldown-opening transitions"
fi
if [ -s "$MARKER" ]; then
  ok "the shared marker survives all concurrent detector processes"
else
  bad "the shared marker disappeared after concurrent ticks"
fi

misses=0
for n in 1 2 3 4 5 6 7 8; do
  run_common "next-$n" 'api_cooldown_active' || misses=$((misses + 1))
done
if [ "$misses" -eq 0 ]; then
  ok "every next-tick namespace is suppressed by the concurrent episode"
else
  bad "$misses next-tick namespaces missed the concurrent episode"
fi

echo "TOTAL: $PASS passed, $FAIL failed"
[ "$FAIL" -eq 0 ]
