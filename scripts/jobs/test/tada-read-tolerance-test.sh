#!/bin/bash
# tada-read-tolerance-test.sh — common.sh tada path helpers over the date-sharded
# layout, with the stage-2 flat fallback retired (a stray flat entry is ignored).

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
printf 'stray flat\n' > "$TEST_ROOT/$JOBS_TADA/duplicate.md"
printf 'sharded duplicate\n' > "$TEST_ROOT/$JOBS_TADA/$today/duplicate.md"
printf 'old\n' > "$TEST_ROOT/$JOBS_TADA/$old_day/old.md"
yesterday="$(date -u -d '1 day ago' +%Y/%m/%d)"
mkdir -p "$TEST_ROOT/$JOBS_TADA/$yesterday"
printf 'yesterday\n' > "$TEST_ROOT/$JOBS_TADA/$yesterday/yday.md"
touch -d '1 hour ago' "$TEST_ROOT/$JOBS_TADA/$today/sharded.md"

[ "$(tada_path_for sample 2026/08/13)" = 'jobs/tada/2026/08/13/sample.md' ] \
  && ok "tada_path_for builds a supplied date shard" \
  || bad "tada_path_for returned $(tada_path_for sample 2026/08/13)"
[ "$(tada_write_path sample)" = "$JOBS_TADA/$today/sample.md" ] \
  && ok "tada_write_path builds today's UTC shard" \
  || bad "tada_write_path did not use today's UTC shard"
! tada_find "$TEST_ROOT" flat >/dev/null \
  && ok "tada_find ignores a stray flat entry (fallback retired)" \
  || bad "tada_find still resolves the retired flat layout"
[ "$(tada_find "$TEST_ROOT" sharded)" = "$JOBS_TADA/$today/sharded.md" ] \
  && ok "tada_find resolves a date-sharded report" \
  || bad "tada_find missed the date-sharded layout"
[ "$(tada_find "$TEST_ROOT" no-date)" = "$JOBS_TADA/undated/no-date.md" ] \
  && ok "tada_find resolves the undated bucket" \
  || bad "tada_find missed the undated bucket"
[ "$(tada_find "$TEST_ROOT" duplicate)" = "$JOBS_TADA/$today/duplicate.md" ] \
  && ok "tada_find resolves the sharded copy over a stray flat one" \
  || bad "tada_find did not resolve the sharded copy"
tada_exists "$TEST_ROOT" sharded && tada_exists "$TEST_ROOT" no-date \
  && ! tada_exists "$TEST_ROOT" flat && ! tada_exists "$TEST_ROOT" absent \
  && ok "tada_exists recognizes sharded/undated and rejects flat/absent basenames" \
  || bad "tada_exists returned the wrong result"

all_reports="$(tada_list "$TEST_ROOT")"
! printf '%s\n' "$all_reports" | grep -qxF "$JOBS_TADA/flat.md" \
  && printf '%s\n' "$all_reports" | grep -qxF "$JOBS_TADA/$today/sharded.md" \
  && printf '%s\n' "$all_reports" | grep -qxF "$JOBS_TADA/undated/no-date.md" \
  && [ "$(printf '%s\n' "$all_reports" | grep -c '/duplicate.md$')" -eq 1 ] \
  && ok "tada_list covers sharded/undated reports only, one per basename" \
  || bad "tada_list returned the wrong report set"

git -C "$TEST_ROOT" init -q
git -C "$TEST_ROOT" add -A
git -C "$TEST_ROOT" -c user.name=test -c user.email=test@localhost commit -q -m fixture
ref="$(git -C "$TEST_ROOT" rev-parse HEAD)"
! tada_find_tree "$TEST_ROOT" "$ref" flat >/dev/null \
  && [ "$(tada_find_tree "$TEST_ROOT" "$ref" duplicate)" = "$JOBS_TADA/$today/duplicate.md" ] \
  && [ "$(tada_find_tree "$TEST_ROOT" "$ref" sharded)" = "$JOBS_TADA/$today/sharded.md" ] \
  && [ "$(tada_find_tree "$TEST_ROOT" "$ref" no-date)" = "$JOBS_TADA/undated/no-date.md" ] \
  && ok "tada_find_tree resolves sharded and undated reports, ignoring flat" \
  || bad "tada_find_tree missed one of the supported layouts"

recent="$(tada_recent "$TEST_ROOT" 7)"
! printf '%s\n' "$recent" | grep -qxF "$JOBS_TADA/flat.md" \
  && printf '%s\n' "$recent" | grep -qxF "$JOBS_TADA/$today/sharded.md" \
  && ! printf '%s\n' "$recent" | grep -qxF "$JOBS_TADA/$old_day/old.md" \
  && ! printf '%s\n' "$recent" | grep -qxF "$JOBS_TADA/undated/no-date.md" \
  && ok "tada_recent lists only the recent date shards" \
  || bad "tada_recent returned the wrong window"
[ "$(printf '%s\n' "$recent" | sed -n 1p)" = "$JOBS_TADA/$today/duplicate.md" ] \
  && [ "$(printf '%s\n' "$recent" | sed -n 2p)" = "$JOBS_TADA/$today/sharded.md" ] \
  && [ "$(printf '%s\n' "$recent" | sed -n 3p)" = "$JOBS_TADA/$yesterday/yday.md" ] \
  && ok "tada_recent orders newest day first, newest-modified first within a day" \
  || bad "tada_recent order was: $(printf '%s ' $recent)"
[ "$("$JOBS/recent-completions.sh" --dir "$TEST_ROOT" --days 2 --limit 2)" = "$(printf '%s duplicate\n%s sharded' "${today//\//-}" "${today//\//-}")" ] \
  && [ "$("$JOBS/recent-completions.sh" --dir "$TEST_ROOT" --days 2 --paths | tail -1)" = "$JOBS_TADA/$yesterday/yday.md" ] \
  && ok "recent-completions.sh lists dated bases newest first and honors --limit/--paths" \
  || bad "recent-completions.sh output was wrong"

echo "tada-read-tolerance-test: PASS=$PASS FAIL=$FAIL"
[ "$FAIL" -eq 0 ]
