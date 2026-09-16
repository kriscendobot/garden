#!/bin/bash
# Fail the staging-stage `git add` of an inbox nudge so the test can exercise the
# tick's staging-stage isolation (explicit status + stage-named diagnostic +
# fail-open with clone-lock release). Every other git call delegates to real git,
# so clone/fetch/reset/commit/push are untouched.
set -eu

if [ "${GARDEN_NUDGE_STAGE_FAIL:-}" = 1 ]; then
  saw_add=0
  saw_inbox=0
  for a in "$@"; do
    [ "$a" = add ] && saw_add=1
    case "$a" in inbox/*) saw_inbox=1 ;; esac
  done
  if [ "$saw_add" = 1 ] && [ "$saw_inbox" = 1 ]; then
    printf '%s\n' 'injected staging failure' >&2
    exit 1
  fi
fi

exec "$GARDEN_NUDGE_REAL_GIT" "$@"
