#!/bin/bash
# Force one review-miss-record CAS loss, then pass subsequent pushes through.

set -euo pipefail
: "${GARDEN_PUSH_DIR:?}"
: "${GARDEN_RMR_RACE_BARE:?}"
: "${GARDEN_RMR_RACE_BRANCH:?}"
: "${GARDEN_RMR_RACE_MARKER:?}"
: "${GARDEN_RMR_RACE_COUNT:?}"

count="$(cat "$GARDEN_RMR_RACE_COUNT" 2>/dev/null || echo 0)"
count=$(( count + 1 ))
printf '%s\n' "$count" > "$GARDEN_RMR_RACE_COUNT"

if [ ! -e "$GARDEN_RMR_RACE_MARKER" ]; then
  competitor="${GARDEN_RMR_RACE_MARKER}.competitor"
  git clone -q --single-branch --branch "$GARDEN_RMR_RACE_BRANCH" \
    "$GARDEN_RMR_RACE_BARE" "$competitor"
  printf 'competitor\n' > "$competitor/cas-race-fixture"
  git -C "$competitor" add cas-race-fixture
  git -C "$competitor" -c user.name=test -c user.email=test@localhost \
    commit -q -m 'fixture: win review-miss CAS race'
  git -C "$competitor" push -q origin "HEAD:$GARDEN_RMR_RACE_BRANCH"
  touch "$GARDEN_RMR_RACE_MARKER"
  exit 1
fi

git -C "$GARDEN_PUSH_DIR" push -q origin "HEAD:$GARDEN_RMR_RACE_BRANCH"
