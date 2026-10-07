#!/bin/bash
# Regression (2026-10-07): an unanchored quota read — no journal-dir argument —
# discovered its clone with the glob "$GARDEN_STATE"/*/journal and took the
# alphabetically first one. The accountant's clone was 36h stale and still held
# a retired config/token-backoff-fraction pin, so the foreman's anthropic verdict
# read `backoff` at ~10% use and it pumped nothing for 90 minutes.
#
# Contract pinned here: a stale sibling clone carrying an old pin cannot change
# a verdict. Discovery picks the clone whose journal2 commit is newest; a caller's
# own clone (explicit dir, GARDEN_PRODUCER_CLONE) still wins; a clone whose HEAD
# cannot be read never wins; with no readable candidate the read fails closed.
set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
JOBS="$(cd "$HERE/.." && pwd)"
TEST_ROOT="$(mktemp -d "${TMPDIR:-/tmp}/garden-stale-sibling.XXXXXX")"
trap 'rm -rf "$TEST_ROOT"' EXIT
export GARDEN=endolin-garden2-5bcdff64 GARDEN_STATE="$TEST_ROOT/state"
unset GARDEN_TOKEN_BACKOFF_FRACTION GARDEN_BUDGET_POOLS_FILE GARDEN_TOKEN_WEEKLY_QUOTA \
      GARDEN_WORKER_CLONE GARDEN_PRODUCER_CLONE
export GARDEN_CCUSAGE_LOGDIR="$TEST_ROOT/no-ccusage" GARDEN_USAGE_LEDGER="$TEST_ROOT/ledger.tsv"
# shellcheck source=../common.sh
source "$JOBS/common.sh"

fail=0
ok()  { printf 'ok   %s\n' "$1"; }
bad() { printf 'FAIL %s\n' "$1"; fail=1; }
check() { if [ "$2" = "$3" ]; then ok "$1"; else bad "$1: expected '$3', got '$2'"; fi; }

POOL=claude-endolin2
# <clone> <commit-date> — a journal clone whose checked-out commit has that date.
mkclone() {
  local d="$1" when="$2"
  printf '%s\tanthropic\tweekly-tokens\t100\tfixture\t2026-09-20\n' "$POOL" > "$d/config/budget-pools"
  printf '%s\t%s\tmonk\n' "$POOL" "$GARDEN" > "$d/config/subscription-mapping"
  _garden_real_git init -q -b journal2 "$d"
  _garden_real_git -C "$d" add -A
  GIT_AUTHOR_DATE="$when" GIT_COMMITTER_DATE="$when" \
    _garden_real_git -C "$d" -c user.name=t -c user.email=t@t commit -q -m fixture
}
STALE="$GARDEN_STATE/accountant/journal"   # sorts first, as on 2026-10-07
FRESH="$GARDEN_STATE/producer/journal"
mkdir -p "$STALE/config" "$STALE/budget/reset-events" "$FRESH/config" "$FRESH/budget/reset-events"
printf '0.05\n' > "$STALE/config/token-backoff-fraction"   # the retired pin
# Friday 20:00 PT resets, identical in both clones; only the pin differs.
for d in "$STALE" "$FRESH"; do
  printf '{"subscription_id":"%s","event_type":"declared-schedule","cadence":"calendar","schedule_weekday":5,"schedule_time":"20:00","timezone":"America/Los_Angeles","reset_at_precision":"exact","reset_at":null}\n' "$POOL" \
    > "$d/budget/reset-events/$POOL.jsonl"
done
mkclone "$STALE" 2026-10-06T02:02:00Z
mkclone "$FRESH" 2026-10-07T14:00:00Z
# ~10% of the 100-token pool used just now.
printf '%s\t10\n' "$(date +%s)" > "$GARDEN_USAGE_LEDGER"

check "discovery prefers the fresher clone over the alphabetically-first stale one" \
  "$(budget_pool_file "")" "$FRESH/config/budget-pools"
check "the backoff config is read from that same fresh clone" \
  "$(_token_backoff_journal_dir "")" "$FRESH"
check "reset events come from the fresh clone" \
  "$(subscription_reset_file "$POOL" "")" "$FRESH/budget/reset-events/$POOL.jsonl"
src="$(token_backoff_fraction_for "$POOL" "" | cut -f2)"
[ "$src" != override ] && ok "the stale clone's pin is not the fraction source ($src)" \
  || bad "the stale clone's retired pin supplied the backoff fraction"
check "unanchored verdict at 10% use is ok, not the stale pin's backoff" \
  "$(meter_quota_status "" "")" ok
check "anchored to the stale clone the pin still applies (explicit dirs are authoritative)" \
  "$(meter_quota_status "" "$STALE")" backoff

# A caller's own clone wins outright, even over a fresher sibling.
check "GARDEN_PRODUCER_CLONE beats discovery" \
  "$(GARDEN_PRODUCER_CLONE="$STALE" budget_pool_file "")" "$STALE/config/budget-pools"

# Re-sync the stale clone forward: freshness, not name, decides.
GIT_AUTHOR_DATE=2026-10-07T15:00:00Z GIT_COMMITTER_DATE=2026-10-07T15:00:00Z \
  _garden_real_git -C "$STALE" -c user.name=t -c user.email=t@t commit -q --allow-empty -m sync
check "the newest commit wins regardless of directory order" \
  "$(budget_pool_file "")" "$STALE/config/budget-pools"

# A clone whose HEAD cannot be read never wins.
rm -rf "$STALE/.git"
mkdir -p "$GARDEN_STATE/aaa/journal/config"
cp "$FRESH/config/budget-pools" "$GARDEN_STATE/aaa/journal/config/"
check "a clone without a readable HEAD is skipped" \
  "$(budget_pool_file "")" "$FRESH/config/budget-pools"

# No readable candidate at all: fail closed rather than trust an unknown clone.
rm -rf "$FRESH/.git"
if out="$(budget_pool_file "")"; then bad "discovery with no readable clone returned '$out'"
else ok "discovery with no readable clone fails closed"; fi

exit "$fail"
