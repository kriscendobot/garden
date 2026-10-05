#!/bin/bash
# post-gauntlet-dedup-test.sh — distinct gauntlet bases racing for one PR must
# converge on one PR-keyed record.

set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
JOBS="$(cd "$HERE/.." && pwd)"
TR="$(mktemp -d "${TMPDIR:-/tmp}/post-gauntlet-dedup.XXXXXXXX")"
trap 'rm -rf "$TR"' EXIT
BRANCH=journal2
BARE="$TR/journal.git"
git_id=(-c user.name=test -c user.email=test@localhost)

git init -q --bare "$BARE"
git init -q "$TR/seed"
git -C "$TR/seed" checkout -q -b "$BRANCH"
mkdir -p "$TR/seed/jobs/gauntlet" "$TR/seed/jobs/tada"
touch "$TR/seed/jobs/gauntlet/.gitkeep" "$TR/seed/jobs/tada/.gitkeep"
git -C "$TR/seed" add jobs
git -C "$TR/seed" "${git_id[@]}" commit -q -m seed
git -C "$TR/seed" remote add origin "$BARE"
git -C "$TR/seed" push -q -u origin "$BRANCH"

run_racer() {
  local id="$1" base="$2"
  env \
    GARDEN_TEST=1 \
    GARDEN="test-$id" \
    GARDEN_STATE="$TR/state-$id" \
    GARDEN_PRODUCER_CLONE="$TR/clone-$id" \
    GARDEN_PUSH_CMD="$HERE/post-gauntlet-race-push-stub.sh" \
    GARDEN_RACE_READY_DIR="$TR/ready" \
    GARDEN_RACER_ID="$id" \
    GARDEN_POST_ATTEMPTS=5 \
    JOURNAL_REMOTE="$BARE" \
    JOURNAL_BRANCH="$BRANCH" \
    GIT_AUTHOR_NAME=test GIT_AUTHOR_EMAIL=test@localhost \
    GIT_COMMITTER_NAME=test GIT_COMMITTER_EMAIL=test@localhost \
    "$JOBS/post-gauntlet.sh" "$base" testowner/testrepo#160 \
    >"$TR/$id.out" 2>"$TR/$id.err"
}

run_racer a divergent-a & pid_a=$!
run_racer b divergent-b & pid_b=$!
rc=0
wait "$pid_a" || rc=1
wait "$pid_b" || rc=1
if [ "$rc" -ne 0 ]; then
  cat "$TR/a.err" "$TR/b.err" >&2
  exit 1
fi

git clone -q --single-branch --branch "$BRANCH" "$BARE" "$TR/verify"
mapfile -t records < <(find "$TR/verify/jobs/gauntlet" -maxdepth 1 -type f -name '*.md' -printf '%f\n' | sort)

if [ "${#records[@]}" -ne 1 ]; then
  printf 'FAIL: divergent-base race created %s records: %s\n' \
    "${#records[@]}" "${records[*]:-none}" >&2
  exit 1
fi
case "${records[0]}" in
  divergent-a.md|divergent-b.md) ;;
  *) printf 'FAIL: unexpected gauntlet record: %s\n' "${records[0]}" >&2; exit 1;;
esac
grep -qx 'repo: testowner/testrepo' "$TR/verify/jobs/gauntlet/${records[0]}"
grep -qx 'pr_number: 160' "$TR/verify/jobs/gauntlet/${records[0]}"

# The losing writer must have exercised the CAS retry, then discovered the
# winner by PR identity instead of committing its divergent base.
grep -q 'lost a push race' "$TR/a.err" "$TR/b.err"
grep -q 'DUPLICATE GAUNTLET REFUSED' "$TR/a.err" "$TR/b.err"

echo 'PASS: divergent-base race converged on one PR-keyed gauntlet record'
