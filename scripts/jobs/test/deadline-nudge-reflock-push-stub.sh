#!/bin/bash
# First invocation lands a legitimate concurrent journal push (a new due claim)
# and then refuses the scanner's push the way the receiver's own ref transaction
# does when it loses that race: `[remote rejected] ... (cannot lock ref ...: is
# at <new> but expected <old>)`. Later invocations perform the real push.

set -euo pipefail
: "${GARDEN_PUSH_DIR:?}"
: "${GARDEN_NUDGE_REFLOCK_BARE:?}"
: "${GARDEN_NUDGE_REFLOCK_MARKER:?}"
: "${GARDEN_NUDGE_REFLOCK_CLAIM:?}"

if [ ! -e "$GARDEN_NUDGE_REFLOCK_MARKER" ]; then
  expected="$(git -C "$GARDEN_NUDGE_REFLOCK_BARE" rev-parse journal2)"
  update="${GARDEN_NUDGE_REFLOCK_MARKER}.update"
  rm -rf "$update"
  git clone -q --branch journal2 "$GARDEN_NUDGE_REFLOCK_BARE" "$update"
  base="${GARDEN_NUDGE_REFLOCK_CLAIM##*/}"
  base="${base%.md}"
  mkdir -p "$update/jobs/doin" "$update/inbox/$base/unread" "$update/inbox/$base/read"
  cp "$GARDEN_NUDGE_REFLOCK_CLAIM" "$update/jobs/doin/$base.md"
  touch "$update/inbox/$base/unread/.gitkeep" "$update/inbox/$base/read/.gitkeep"
  git -C "$update" add -A
  git -C "$update" -c user.name=test -c user.email=test@localhost \
    commit -q -m "reflock fixture: concurrent claim $base"
  git -C "$update" push -q origin HEAD:journal2
  actual="$(git -C "$GARDEN_NUDGE_REFLOCK_BARE" rev-parse journal2)"
  touch "$GARDEN_NUDGE_REFLOCK_MARKER"
  printf '%s\n' \
    'To github.com:kriscendobot/garden.git' \
    " ! [remote rejected]       HEAD -> journal2 (cannot lock ref 'refs/heads/journal2': is at $actual but expected $expected)" \
    "error: failed to push some refs to 'github.com:kriscendobot/garden.git'" >&2
  exit 1
fi

git -C "$GARDEN_PUSH_DIR" push -q origin HEAD:journal2
