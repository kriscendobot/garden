#!/bin/bash
# Hermetic integration coverage for the merge spine's rebase adapter. This uses
# real repositories and the production safe-rebase/safe-push helpers; only the
# GitHub metadata read is stubbed.

set -euo pipefail
export GARDEN_TEST=1
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
HELPER="$(cd "$HERE/.." && pwd)/gardening/rebase-pr-before-merge.sh"
TR="$(mktemp -d "${TMPDIR:-/var/tmp}/.garden-rebase-before-merge-test.XXXXXX")"
trap 'rm -rf "$TR"' EXIT

G=(-c user.name=test -c user.email=test@example.invalid -c commit.gpgsign=false)
git_c() { command git -C "$1" "${G[@]}" "${@:2}"; }
die() { echo "FAIL: $*" >&2; exit 1; }

GH="$TR/gh"
cat > "$GH" <<'STUB'
#!/bin/bash
if [ "$1 $2" = "pr view" ]; then
  oid="$(git --git-dir="$TEST_ORIGIN" rev-parse refs/heads/pr)"
  printf '{"state":"OPEN","baseRefName":"main","headRefName":"pr","headRefOid":"%s"}\n' "$oid"
  exit 0
fi
exit 1
STUB
chmod +x "$GH"
export GARDEN_GH="$GH"

new_fixture() { # new_fixture <name> <clean|conflict>
  local name="$1" shape="$2"
  local seed="$TR/$name-seed" origin="$TR/$name.git" wt="$TR/$name-wt"
  git init -q --bare "$origin"
  git init -q -b main "$seed"
  git -C "$seed" config user.name test
  git -C "$seed" config user.email test@example.invalid
  git -C "$seed" config commit.gpgsign false
  printf 'base v1\n' > "$seed/base.txt"
  printf 'code v1\n' > "$seed/code.txt"
  git -C "$seed" add -A; git_c "$seed" commit -q -m base
  git -C "$seed" remote add origin "$origin"
  git -C "$seed" push -q origin main
  git_c "$seed" checkout -q -b pr
  printf 'pr change\n' > "$seed/pr.txt"
  [ "$shape" = conflict ] && printf 'code from pr\n' > "$seed/code.txt"
  git -C "$seed" add -A; git_c "$seed" commit -q -m 'feat: pr change'
  git -C "$seed" push -q origin pr
  git_c "$seed" checkout -q main
  if [ "$shape" = conflict ]; then
    printf 'code from base\n' > "$seed/code.txt"
  else
    printf 'unrelated base move\n' > "$seed/other.txt"
  fi
  git -C "$seed" add -A; git_c "$seed" commit -q -m 'chore: move base'
  git -C "$seed" push -q origin main
  git clone -q --branch pr "$origin" "$wt"
  git -C "$wt" config user.name test
  git -C "$wt" config user.email test@example.invalid
  git -C "$wt" config commit.gpgsign false
  printf '%s|%s\n' "$origin" "$wt"
}

IFS='|' read -r ORIGIN WT < <(new_fixture clean clean)
export TEST_ORIGIN="$ORIGIN"
old="$(git --git-dir="$ORIGIN" rev-parse refs/heads/pr)"
out="$("$HELPER" o/r 1 "$WT")" || die "clean behind head was refused"
new="$(git --git-dir="$ORIGIN" rev-parse refs/heads/pr)"
[ "$out" = "$new" ] || die "helper did not return the published rebased OID"
[ "$new" != "$old" ] || die "behind clean head was not rewritten"
git --git-dir="$ORIGIN" merge-base --is-ancestor refs/heads/main refs/heads/pr \
  || die "published PR head does not contain the live base"
echo "PASS: behind-but-clean PR head is rebased with safe-rebase and lease-pushed"

IFS='|' read -r ORIGIN WT < <(new_fixture conflict conflict)
export TEST_ORIGIN="$ORIGIN"
old="$(git --git-dir="$ORIGIN" rev-parse refs/heads/pr)"
rc=0; "$HELPER" o/r 2 "$WT" >/dev/null 2>&1 || rc=$?
[ "$rc" -eq 3 ] || die "code conflict must fail closed with rc 3 (got $rc)"
[ "$(git --git-dir="$ORIGIN" rev-parse refs/heads/pr)" = "$old" ] \
  || die "conflicting head was pushed despite the refusal"
echo "PASS: conflicting PR head fails closed as needs-weave and is not pushed"
