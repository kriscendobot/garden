#!/bin/bash
# The deployed root's store never auto-gcs through fleet git (root-repo-guard.sh
# owns its gc); every other repository keeps foreground auto-gc. All repositories
# live outside the garden root.
set -euo pipefail
JOBS="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
TR="$(mktemp -d /var/tmp/garden-root-store-gc.XXXXXX)"
trap 'rm -rf "$TR"' EXIT
export GARDEN_TEST=1 GARDEN_ROOT="$TR/root" GARDEN_STATE="$TR/state" GARDEN_REPO_LOCK_WAIT=5
REAL_GIT="$(command -v git)"
case "$REAL_GIT" in */scripts/jobs/bin/git) REAL_GIT=/usr/bin/git ;; esac
export GARDEN_REAL_GIT="$REAL_GIT"
fail() { echo "FAIL: $*" >&2; exit 1; }
for r in "$GARDEN_ROOT" "$TR/other"; do
  "$REAL_GIT" init -q "$r"
  "$REAL_GIT" -C "$r" -c user.name=t -c user.email=t@example.invalid commit -q --allow-empty -m seed
done
"$REAL_GIT" -C "$GARDEN_ROOT" worktree add -q --detach "$TR/root-wt"
"$REAL_GIT" -C "$TR/other" worktree add -q --detach "$TR/other-wt"
ln -s "$GARDEN_ROOT" "$TR/root-alias"
source "$JOBS/common.sh"

for r in "$GARDEN_ROOT" "$TR/root-wt" "$TR/root-alias"; do
  [ "$(git -C "$r" config --get gc.auto)" = 0 ] || fail "root store auto-gc enabled: $r"
  [ "$(git -C "$r" config --get maintenance.auto)" = false ] || fail "root store auto-maintenance enabled: $r"
done
echo 'PASS: root store, its worktrees and aliases never auto-gc'

for r in "$TR/other" "$TR/other-wt"; do
  [ -z "$(git -C "$r" config --get gc.auto || true)" ] || fail "non-root auto-gc disabled: $r"
  [ "$(git -C "$r" config --get gc.autoDetach)" = false ] || fail "non-root gc must stay attached: $r"
done
echo 'PASS: other repositories keep foreground auto-gc'
echo 'All root-store auto-gc tests passed.'
