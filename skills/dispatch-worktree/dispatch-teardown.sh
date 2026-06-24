#!/bin/bash
# dispatch-teardown.sh — remove a per-dispatch worktree triple.
#
# Usage: dispatch-teardown.sh <dispatch-root>
#
# Removes garden/, journal/, and (if present) project/ worktrees and the
# dispatch root directory itself. Idempotent: missing pieces are tolerated.
#
# `git worktree remove` is preferred over `rm -rf` because git tracks
# each worktree in its admin tree; a bare rm would leak that entry and
# require a follow-up `git worktree prune`.

set -euo pipefail

if [ "$#" -ne 1 ]; then
  echo "usage: $0 <dispatch-root>" >&2
  exit 64
fi

ROOT=$1
GARDEN_ROOT="$(cd "$(dirname "$0")/../.." && pwd)"

if [ ! -d "$ROOT" ]; then
  echo "dispatch-teardown: $ROOT does not exist; nothing to do" >&2
  exit 0
fi

# Garden + journal worktrees live in the garden repo's admin tree.
[ -e "$ROOT/garden" ]  && git -C "$GARDEN_ROOT" worktree remove --force "$ROOT/garden"  >/dev/null 2>&1 || true
[ -e "$ROOT/journal" ] && git -C "$GARDEN_ROOT" worktree remove --force "$ROOT/journal" >/dev/null 2>&1 || true

# Project worktree (if present) lives in a separate bare clone's admin
# tree. We don't store which bare; ask each bare clone in turn.
if [ -e "$ROOT/project" ]; then
  for bare in "$GARDEN_ROOT"/worktrees/*.git; do
    [ -d "$bare" ] || continue
    if git --git-dir="$bare" worktree list 2>/dev/null | grep -q -F "$ROOT/project"; then
      git --git-dir="$bare" worktree remove --force "$ROOT/project" >/dev/null 2>&1 || true
      break
    fi
  done
fi

# Best-effort cleanup. If the worktree-remove succeeded the directory is
# already gone; if anything was left behind we sweep it.
rmdir "$ROOT" 2>/dev/null || rm -rf "$ROOT"
