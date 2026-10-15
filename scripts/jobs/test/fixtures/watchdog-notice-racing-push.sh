#!/bin/bash
set -euo pipefail
real_git="${REAL_GIT:?}"
peer="${WATCHDOG_CAS_PEER:?}"
mark="${WATCHDOG_CAS_MARK:?}"
if [ ! -e "$mark" ]; then
  printf 'race\n' > "$mark"
  "$real_git" -C "$peer" pull -q --ff-only origin journal2
  sed -i 's/^notice_count: .*/notice_count: 7/' \
    "$peer/inbox/maintainer/unread/watchdog-race.md"
  "$real_git" -C "$peer" add inbox/maintainer/unread/watchdog-race.md
  "$real_git" -C "$peer" -c user.name=peer -c user.email=peer@example.invalid \
    commit -qm 'peer watchdog amend'
  "$real_git" -C "$peer" push -q origin HEAD:journal2
fi
exec "$real_git" -C "${GARDEN_PUSH_DIR:?}" push -q origin HEAD:journal2
