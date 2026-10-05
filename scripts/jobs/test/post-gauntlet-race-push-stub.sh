#!/bin/bash
# Barrier push stub for post-gauntlet-dedup-test.sh. Both divergent-base writers
# reach the push before either proceeds, forcing the journal CAS retry path.

set -euo pipefail

ready_dir="${GARDEN_RACE_READY_DIR:?}"
racer="${GARDEN_RACER_ID:?}"
mkdir -p "$ready_dir"
touch "$ready_dir/$racer"

for _ in $(seq 1 200); do
  [ "$(find "$ready_dir" -maxdepth 1 -type f | wc -l)" -ge 2 ] && break
  sleep 0.05
done
[ "$(find "$ready_dir" -maxdepth 1 -type f | wc -l)" -ge 2 ] || {
  echo "timed out waiting for the other post-gauntlet racer" >&2
  exit 1
}

git -C "${GARDEN_PUSH_DIR:?}" push -q origin "HEAD:${JOURNAL_BRANCH:?}"
