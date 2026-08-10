#!/bin/bash
# First invocation advances the fixture origin to a changed claim/completion and
# rejects the scanner's stale push. Later invocations perform the real push.

set -euo pipefail
: "${GARDEN_PUSH_DIR:?}"
: "${GARDEN_NUDGE_RACE_BARE:?}"
: "${GARDEN_NUDGE_RACE_MARKER:?}"
: "${GARDEN_NUDGE_RACE_BASE:?}"
: "${GARDEN_NUDGE_RACE_ACTION:?}"

if [ ! -e "$GARDEN_NUDGE_RACE_MARKER" ]; then
  update="${GARDEN_NUDGE_RACE_MARKER}.update"
  rm -rf "$update"
  git clone -q --branch journal2 "$GARDEN_NUDGE_RACE_BARE" "$update"
  case "$GARDEN_NUDGE_RACE_ACTION" in
    reclaim)
      : "${GARDEN_NUDGE_RACE_CLAIMED_AT:?}"
      sed -i "s/^  claimed_at:.*/  claimed_at: $GARDEN_NUDGE_RACE_CLAIMED_AT/" \
        "$update/jobs/doin/$GARDEN_NUDGE_RACE_BASE.md"
      rm -rf "$update/inbox/$GARDEN_NUDGE_RACE_BASE"
      mkdir -p "$update/inbox/$GARDEN_NUDGE_RACE_BASE/unread" \
               "$update/inbox/$GARDEN_NUDGE_RACE_BASE/read"
      touch "$update/inbox/$GARDEN_NUDGE_RACE_BASE/unread/.gitkeep" \
            "$update/inbox/$GARDEN_NUDGE_RACE_BASE/read/.gitkeep"
      ;;
    complete)
      git -C "$update" rm -q "jobs/doin/$GARDEN_NUDGE_RACE_BASE.md"
      git -C "$update" rm -qr "inbox/$GARDEN_NUDGE_RACE_BASE"
      ;;
    *) exit 2 ;;
  esac
  git -C "$update" add -A
  git -C "$update" -c user.name=test -c user.email=test@localhost \
    commit -q -m "race fixture: $GARDEN_NUDGE_RACE_ACTION $GARDEN_NUDGE_RACE_BASE"
  git -C "$update" push -q origin HEAD:journal2
  touch "$GARDEN_NUDGE_RACE_MARKER"
  exit 1
fi

git -C "$GARDEN_PUSH_DIR" push -q origin HEAD:journal2
