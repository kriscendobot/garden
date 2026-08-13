#!/bin/bash
# tada-read-tolerance-test.sh — common.sh tada path helpers across both layouts.

set -uo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
JOBS="$(cd "$HERE/.." && pwd)"
TEST_ROOT="$(mktemp -d "${TMPDIR:-/var/tmp}/tada-read-tolerance.XXXXXX")"
PASS=0; FAIL=0
ok() { echo "  PASS: $*"; PASS=$((PASS + 1)); }
bad() { echo "  FAIL: $*"; FAIL=$((FAIL + 1)); }
trap 'rm -rf "$TEST_ROOT"' EXIT

# shellcheck source=../common.sh
source "$JOBS/common.sh"

today="$(date -u +%Y/%m/%d)"
old_day="$(date -u -d '30 days ago' +%Y/%m/%d)"
mkdir -p "$TEST_ROOT/$JOBS_TADA/$today" \
  "$TEST_ROOT/$JOBS_TADA/$old_day" "$TEST_ROOT/$JOBS_TADA/undated"
printf 'flat\n' > "$TEST_ROOT/$JOBS_TADA/flat.md"
printf 'sharded\n' > "$TEST_ROOT/$JOBS_TADA/$today/sharded.md"
printf 'undated\n' > "$TEST_ROOT/$JOBS_TADA/undated/no-date.md"
printf 'flat wins\n' > "$TEST_ROOT/$JOBS_TADA/duplicate.md"
printf 'sharded duplicate\n' > "$TEST_ROOT/$JOBS_TADA/$today/duplicate.md"
printf 'old\n' > "$TEST_ROOT/$JOBS_TADA/$old_day/old.md"

[ "$(tada_path_for sample 2026/08/13)" = 'jobs/tada/2026/08/13/sample.md' ] \
  && ok "tada_path_for builds a supplied date shard" \
  || bad "tada_path_for returned $(tada_path_for sample 2026/08/13)"
[ "$(tada_write_path sample)" = "$JOBS_TADA/$today/sample.md" ] \
  && ok "tada_write_path builds today's UTC shard" \
  || bad "tada_write_path did not use today's UTC shard"
[ "$(tada_find "$TEST_ROOT" flat)" = "$JOBS_TADA/flat.md" ] \
  && ok "tada_find resolves the legacy flat layout" \
  || bad "tada_find missed the flat layout"
[ "$(tada_find "$TEST_ROOT" sharded)" = "$JOBS_TADA/$today/sharded.md" ] \
  && ok "tada_find resolves a date-sharded report" \
  || bad "tada_find missed the date-sharded layout"
[ "$(tada_find "$TEST_ROOT" no-date)" = "$JOBS_TADA/undated/no-date.md" ] \
  && ok "tada_find resolves the undated bucket" \
  || bad "tada_find missed the undated bucket"
[ "$(tada_find "$TEST_ROOT" duplicate)" = "$JOBS_TADA/duplicate.md" ] \
  && ok "tada_find prefers the flat copy during rollout" \
  || bad "tada_find did not prefer the flat copy"
tada_exists "$TEST_ROOT" flat && tada_exists "$TEST_ROOT" sharded \
  && ! tada_exists "$TEST_ROOT" absent \
  && ok "tada_exists recognizes both layouts and absent basenames" \
  || bad "tada_exists returned the wrong result"

all_reports="$(tada_list "$TEST_ROOT")"
printf '%s\n' "$all_reports" | grep -qxF "$JOBS_TADA/flat.md" \
  && printf '%s\n' "$all_reports" | grep -qxF "$JOBS_TADA/$today/sharded.md" \
  && printf '%s\n' "$all_reports" | grep -qxF "$JOBS_TADA/undated/no-date.md" \
  && [ "$(printf '%s\n' "$all_reports" | grep -c '/duplicate.md$')" -eq 1 ] \
  && ok "tada_list covers both layouts and deduplicates a basename" \
  || bad "tada_list returned the wrong report set"

git -C "$TEST_ROOT" init -q
git -C "$TEST_ROOT" add -A
git -C "$TEST_ROOT" -c user.name=test -c user.email=test@localhost commit -q -m fixture
ref="$(git -C "$TEST_ROOT" rev-parse HEAD)"
[ "$(tada_find_tree "$TEST_ROOT" "$ref" flat)" = "$JOBS_TADA/flat.md" ] \
  && [ "$(tada_find_tree "$TEST_ROOT" "$ref" sharded)" = "$JOBS_TADA/$today/sharded.md" ] \
  && [ "$(tada_find_tree "$TEST_ROOT" "$ref" no-date)" = "$JOBS_TADA/undated/no-date.md" ] \
  && ok "tada_find_tree resolves flat, sharded, and undated reports" \
  || bad "tada_find_tree missed one of the supported layouts"

recent="$(tada_recent "$TEST_ROOT" 7)"
printf '%s\n' "$recent" | grep -qxF "$JOBS_TADA/flat.md" \
  && printf '%s\n' "$recent" | grep -qxF "$JOBS_TADA/$today/sharded.md" \
  && ! printf '%s\n' "$recent" | grep -qxF "$JOBS_TADA/$old_day/old.md" \
  && ! printf '%s\n' "$recent" | grep -qxF "$JOBS_TADA/undated/no-date.md" \
  && ok "tada_recent includes flat compatibility entries and only recent date shards" \
  || bad "tada_recent returned the wrong window"

echo "tada-read-tolerance-test: PASS=$PASS FAIL=$FAIL"
[ "$FAIL" -eq 0 ]
