#!/bin/bash
# dispatch-prepare.sh — create a per-dispatch worktree triple.
#
# Usage:
#   dispatch-prepare.sh <role> <purpose-slug> [<owner>/<repo> <branch>]
#
# Prints the absolute path of the dispatch root on stdout. The orchestrator
# (liaison or steward) passes that path into the subagent's dispatch prompt
# and tears the root down via `dispatch-teardown.sh` once the subagent
# returns.
#
# Layout:
#   dispatches/<role>--<short-id>/
#     garden/    detached worktree of the garden's `main` branch
#     journal/   detached worktree of the garden's `journal` branch
#     project/   (only when a project repo is named) detached worktree of
#                worktrees/<owner>-<repo>.git at <branch>
#
# The dispatch-root name is kept short on purpose: deep paths under
# `project/` (notably endo daemon UNIX sockets under
# `packages/daemon/tmp/<slug>/endo.sock`) push past the 108-char
# `sockaddr_un` limit when the dispatch-root name includes the purpose
# slug and a UTC timestamp. The full role, purpose, and timestamp live
# in the matching `dispatch` journal entry, which is the authoritative
# index. The directory name is just a unique handle; the short-id is
# enough.
#
# All three worktrees are checked out in detached-HEAD so a subagent can
# `git fetch origin <branch>`, rebase, and `git push origin HEAD:<branch>`
# without competing for branch ownership with the orchestrator's checkout.
#
# Identity pinning: each sub-worktree's local `core.<scope>` is set to
# the bot identity at prepare time so a subagent's commits cannot drift
# to the parent shell's `~/.gitconfig` (which on the maintainer's host
# is `kriskowal`, the maintainer identity reserved for upstream pushes
# via the boatman). The bot identity is read from the garden repo's
# local config (`<garden-root>/.git/config`'s `user.name` and
# `user.email`); each host configures the bot identity there once.
# Boatman overrides at commit-time via `git -c user.name=<human-name>
# -c user.email=<human-email> commit ...` (or equivalent
# `GIT_AUTHOR_*` / `GIT_COMMITTER_*` env vars) when its dispatch
# carries `identity_switch_authorized: true`; the per-worktree pin
# remains the default for every non-overriding commit in the dispatch.

set -euo pipefail

if [ "$#" -lt 2 ] || [ "$#" -eq 3 ]; then
  echo "usage: $0 <role> <purpose-slug> [<owner>/<repo> <branch>]" >&2
  exit 64
fi

ROLE=$1
PURPOSE=$2  # carried only into the dispatch journal entry; not in the dirname
GARDEN_ROOT="$(cd "$(dirname "$0")/../.." && pwd)"

ID=$(openssl rand -hex 3)
NAME="${ROLE}--${ID}"
ROOT="${GARDEN_ROOT}/dispatches/${NAME}"

# Resolve the bot identity from the garden repo's local config. Each
# host configures its bot identity there once (e.g. `kriscendobot` on
# the docker-hosted bot, `endolinbot` on alternative bot hosts). If
# either field is missing in the local config, fall back to whatever
# `git config --get` resolves at the garden root (which may inherit
# from `~/.gitconfig`) and warn so the operator can repair the
# host setup.
bot_name=$(git -C "$GARDEN_ROOT" config --local --get user.name  2>/dev/null || true)
bot_email=$(git -C "$GARDEN_ROOT" config --local --get user.email 2>/dev/null || true)
if [ -z "$bot_name" ] || [ -z "$bot_email" ]; then
  echo "dispatch-prepare: warning: garden repo at $GARDEN_ROOT has no local user.name/user.email; falling back to inherited config" >&2
  bot_name=${bot_name:-$(git -C "$GARDEN_ROOT" config --get user.name  2>/dev/null || true)}
  bot_email=${bot_email:-$(git -C "$GARDEN_ROOT" config --get user.email 2>/dev/null || true)}
fi
if [ -z "$bot_name" ] || [ -z "$bot_email" ]; then
  echo "dispatch-prepare: error: no git user.name/user.email configured anywhere; cannot pin identity" >&2
  exit 1
fi

mkdir -p "$ROOT"

# Garden + journal worktrees both come from the garden repo's admin tree
# at $GARDEN_ROOT/.git. `git worktree add --detach <path> <ref>` puts the
# new worktree at the named ref in detached-HEAD state.
git -C "$GARDEN_ROOT" worktree add --detach "$ROOT/garden"  main    >/dev/null
git -C "$GARDEN_ROOT" worktree add --detach "$ROOT/journal" journal >/dev/null

# Pin the bot identity in each sub-worktree's local config so commits
# cannot drift to the parent shell's global git identity.
git -C "$ROOT/garden"  config user.name  "$bot_name"
git -C "$ROOT/garden"  config user.email "$bot_email"
git -C "$ROOT/journal" config user.name  "$bot_name"
git -C "$ROOT/journal" config user.email "$bot_email"

if [ "$#" -ge 4 ]; then
  REPO=$3
  BRANCH=$4
  OWNER=${REPO%/*}
  NAME_=${REPO#*/}
  BARE="${GARDEN_ROOT}/worktrees/${OWNER}-${NAME_}.git"
  if [ ! -d "$BARE" ]; then
    echo "dispatch-prepare: bare clone not found at $BARE" >&2
    echo "                  clone first via: git clone --bare https://github.com/${REPO}.git $BARE" >&2
    echo "                  then set the fetch refspec (a bare clone has none, so" >&2
    echo "                  git fetch would leave origin/* tracking refs frozen):" >&2
    echo "                  git -C $BARE config remote.origin.fetch '+refs/heads/*:refs/remotes/origin/*'" >&2
    # roll back partial state
    git -C "$GARDEN_ROOT" worktree remove --force "$ROOT/garden"  >/dev/null 2>&1 || true
    git -C "$GARDEN_ROOT" worktree remove --force "$ROOT/journal" >/dev/null 2>&1 || true
    rmdir "$ROOT" 2>/dev/null || rm -rf "$ROOT"
    exit 1
  fi
  # Resolve the target branch into the bare clone's refs/heads/ before the
  # worktree add. Since the `+refs/heads/*:refs/remotes/origin/*` fetch
  # refspec (set per WORKTREES.md § Adding a fork worktree) routes every
  # post-clone branch into refs/remotes/origin/* rather than refs/heads/,
  # a bare branch name like `ci/cache-playwright-browsers` would not
  # resolve against a remote-tracking-only ref and `worktree add --detach
  # <path> <BRANCH>` would fail. Fetching the branch explicitly into
  # refs/heads/ makes the bare name resolve; the `+` forces an update if
  # the local head already exists (original-clone branches like `master`).
  # If the branch exists on neither side the fetch is a no-op and the
  # worktree add below surfaces the clear "invalid reference" error.
  git --git-dir="$BARE" fetch --quiet origin \
    "+refs/heads/${BRANCH}:refs/heads/${BRANCH}" 2>/dev/null || true
  git --git-dir="$BARE" worktree add --detach "$ROOT/project" "$BRANCH" >/dev/null
  git -C "$ROOT/project" config user.name  "$bot_name"
  git -C "$ROOT/project" config user.email "$bot_email"
fi

echo "$ROOT"
