#!/bin/bash
# inbox-qualified-refs-test.sh — a bare #N handoff is qualified from the
# recipient directive only when that directive identifies one GitHub repository.

set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
JOBS="$(cd "$HERE/.." && pwd)"
# shellcheck source=test-tmpdir.sh
source "$HERE/test-tmpdir.sh"

TR="$(mktemp -d "$(garden_test_exec_tmpdir)/garden-inbox-qualified.XXXXXXXX")"
trap 'rm -rf "$TR"' EXIT
BARE="$TR/journal.git"
SEED="$TR/seed"
BRANCH=journal2

git init -q --bare "$BARE"
git init -q "$SEED"
git -C "$SEED" checkout -q -b "$BRANCH"
mkdir -p "$SEED/jobs/doin" \
  "$SEED/inbox/unique/unread" "$SEED/inbox/unique/read" \
  "$SEED/inbox/ambiguous/unread" "$SEED/inbox/ambiguous/read"
printf '%s\n' \
  '# One-project recipient' \
  'Continue the handoff for https://github.com/acme/widgets/pull/1596.' \
  > "$SEED/jobs/doin/unique.md"
printf '%s\n' \
  '# Ambiguous recipient' \
  'Compare https://github.com/acme/widgets/pull/1 with https://github.com/acme/gadgets/pull/2.' \
  > "$SEED/jobs/doin/ambiguous.md"
touch "$SEED/inbox/unique/unread/.gitkeep" "$SEED/inbox/unique/read/.gitkeep" \
  "$SEED/inbox/ambiguous/unread/.gitkeep" "$SEED/inbox/ambiguous/read/.gitkeep"
git -C "$SEED" add .
git -C "$SEED" -c user.name=test -c user.email=test@localhost commit -qm seed
git -C "$SEED" remote add origin "$BARE"
git -C "$SEED" push -q origin "HEAD:$BRANCH"

common_env=(
  GARDEN_TEST=1
  GARDEN=test-host
  JOURNAL_REMOTE="$BARE"
  JOURNAL_BRANCH="$BRANCH"
  GIT_AUTHOR_NAME=test
  GIT_AUTHOR_EMAIL=test@localhost
  GIT_COMMITTER_NAME=test
  GIT_COMMITTER_EMAIL=test@localhost
)

printf 'Address #1596, but preserve the example `rebase #8`.\n' \
  | env "${common_env[@]}" GARDEN_STATE="$TR/state-unique" \
      GARDEN_MSG_ID=qualified-success "$JOBS/inbox-send.sh" unique >/dev/null

delivered="$(git --git-dir="$BARE" show "$BRANCH:inbox/unique/unread/qualified-success.md")"
grep -qF 'Address acme/widgets#1596' <<<"$delivered" \
  || { echo 'FAIL: bare #1596 was not qualified from the unique recipient directive' >&2; exit 1; }
grep -qF '`rebase #8`' <<<"$delivered" \
  || { echo 'FAIL: inline-code reference was rewritten' >&2; exit 1; }

set +e
ambiguous_out="$(printf 'Address #1596.\n' \
  | env "${common_env[@]}" GARDEN_STATE="$TR/state-ambiguous" \
      GARDEN_MSG_ID=ambiguous-rejected "$JOBS/inbox-send.sh" ambiguous 2>&1)"
ambiguous_rc=$?
set -e
[ "$ambiguous_rc" -ne 0 ] \
  || { echo 'FAIL: ambiguous recipient accepted a bare reference' >&2; exit 1; }
grep -qF "has no unique canonical GitHub repository" <<<"$ambiguous_out" \
  || { echo 'FAIL: ambiguous rejection did not explain the repository ambiguity' >&2; exit 1; }
if git --git-dir="$BARE" cat-file -e "$BRANCH:inbox/ambiguous/unread/ambiguous-rejected.md" 2>/dev/null; then
  echo 'FAIL: ambiguous bare reference was posted despite rejection' >&2
  exit 1
fi

echo 'PASS: unique recipient refs normalize; ambiguous recipient refs fail closed'
