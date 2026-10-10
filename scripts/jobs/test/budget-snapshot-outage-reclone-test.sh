#!/bin/bash
# budget-snapshot-outage-reclone-test.sh — a publication outage older than the
# snapshot max-age gets exactly one fresh-clone retry; a failed retry escalates
# once (edge-latched) and never removes the clone worker reconciliation reads.
set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
JOBS="$(cd "$HERE/.." && pwd)"
TR="$(mktemp -d "${TMPDIR:-/tmp}/garden-budget-reclone.XXXXXX")"
trap 'rm -rf "$TR"' EXIT

export GARDEN_TEST=1
export GARDEN=testhost
export GARDEN_STATE="$TR/state"
export GARDEN_BUDGET_PUBLISH_OUTAGE_LATCH="$TR/state/publish-outage"
export GARDEN_BUDGET_SNAPSHOT_MAX_AGE=1800
export GARDEN_BUDGET_PUBLISH_ATTEMPTS=2
export GARDEN_CCUSAGE_LOGDIR="$TR/logs"
export GARDEN_BACKOFF_BASE_MS=0
export GARDEN_BACKOFF_CAP_MS=0
export GARDEN_BUDGET_PUBLISH_BACKOFF_BASE_MS=0
export GARDEN_BUDGET_PUBLISH_BACKOFF_CAP_MS=0
export GARDEN_ALERT_CMD="$TR/alert"
ALERTS="$TR/alerts"
printf '#!/bin/sh\nprintf "%%s|%%s\\n" "$1" "$2" >> "%s"\n' "$ALERTS" > "$GARDEN_ALERT_CMD"
chmod +x "$GARDEN_ALERT_CMD"
GARDEN_USAGE_NOW="$(date -u -d 2026-08-22T12:00:00Z +%s)"; export GARDEN_USAGE_NOW

BARE="$TR/journal.git"
SEED="$TR/seed"
CLONE="$TR/scaler/journal"
export JOURNAL_REMOTE="$BARE"
git init -q --bare "$BARE"
git init -q "$SEED"
git -C "$SEED" checkout -q -b journal2
mkdir -p "$SEED/config"
printf '%s\n' 'anthropic:testhost anthropic testhost weekly-tokens 1000' > "$SEED/config/budget-pools"
git -C "$SEED" add config/budget-pools
git -C "$SEED" -c user.name=t -c user.email=t@example.invalid commit -qm seed
git -C "$SEED" push -q "$BARE" journal2
mkdir -p "$GARDEN_CCUSAGE_LOGDIR/p"
printf '%s\n' \
  '{"type":"assistant","timestamp":"2026-08-22T03:00:01Z","message":{"id":"live","usage":{"input_tokens":900,"output_tokens":0,"cache_creation_input_tokens":0,"cache_read_input_tokens":0}}}' \
  > "$GARDEN_CCUSAGE_LOGDIR/p/session.jsonl"

# shellcheck source=../common.sh
source "$JOBS/common.sh"
LOG="$TR/log"
log() { printf '%s\n' "$*" >> "$LOG"; }

# A clone marked .git/wedged refuses every push (the stuck clone); a fresh clone
# pushes unless ALWAYS_FAIL is set (a genuine journal outage).
_push_journal() {
  if [ -e "$1/.git/wedged" ] || [ "${ALWAYS_FAIL:-0}" = 1 ]; then
    # shellcheck disable=SC2034 # consumed by commit_and_push
    GARDEN_PUSH_STDERR=' ! [remote rejected] HEAD -> journal2 (pre-receive hook declined)'
    return 1
  fi
  git -C "$1" push -q origin HEAD:journal2 2>/dev/null
}
open_outage() {  # open_outage <age-secs>
  rm -rf "$GARDEN_BUDGET_PUBLISH_OUTAGE_LATCH"
  budget_publish_note_failure anthropic:testhost 1 server-reject
  printf '%s\n' "$(( $(date -u +%s) - $1 ))" > "$GARDEN_BUDGET_PUBLISH_OUTAGE_LATCH/since_epoch"
}
snapshots() { git --git-dir="$BARE" log --oneline journal2 -- budget/live | wc -l; }

ensure_clone "$CLONE"; sync_clone "$CLONE"
touch "$CLONE/.git/wedged"
budget_publish_local_pool "$CLONE" && { echo "FAIL: wedged clone published"; exit 1; }

# 1. An outage younger than the max-age is left to the ordinary retry path.
open_outage 60
budget_publish_outage_recover "$CLONE" && { echo "FAIL: recovered before max-age"; exit 1; }
[ -e "$CLONE/.git/wedged" ] || { echo "FAIL: re-cloned before max-age"; exit 1; }

# 2. Past the max-age: one fresh clone replaces the wedged one and publishes.
open_outage 1900
budget_publish_outage_recover "$CLONE" || { echo "FAIL: fresh-clone retry did not publish"; cat "$LOG"; exit 1; }
[ ! -e "$CLONE/.git/wedged" ] || { echo "FAIL: wedged clone was not replaced"; exit 1; }
[ "$(snapshots)" -eq 1 ] || { echo "FAIL: expected one published snapshot"; exit 1; }
budget_publish_note_success
[ ! -e "$GARDEN_BUDGET_PUBLISH_OUTAGE_LATCH" ] || { echo "FAIL: recovery left the latch"; exit 1; }
[ ! -s "$ALERTS" ] || { echo "FAIL: a successful retry escalated"; cat "$ALERTS"; exit 1; }
for leak in "$CLONE".budget-*; do [ ! -e "$leak" ] || { echo "FAIL: temp clone dir leaked: $leak"; exit 1; }; done

# 3. A genuine outage: the one retry fails, escalates once, and is not repeated.
GARDEN_USAGE_NOW=$((GARDEN_USAGE_NOW + 3600)); export ALWAYS_FAIL=1
open_outage 1900
budget_publish_outage_recover "$CLONE" && { echo "FAIL: failed retry reported success"; exit 1; }
budget_publish_outage_recover "$CLONE" && { echo "FAIL: second call reported success"; exit 1; }
[ "$(grep -c "re-cloning" "$LOG")" -eq 2 ] || { echo "FAIL: expected exactly one re-clone for this outage"; cat "$LOG"; exit 1; }
[ "$(grep -c '^budget-publish-stale-testhost|' "$ALERTS")" -eq 1 ] \
  || { echo "FAIL: escalation did not fire exactly once"; cat "$ALERTS"; exit 1; }
[ -d "$CLONE/.git" ] || { echo "FAIL: clone missing after failed retry"; exit 1; }
unset ALWAYS_FAIL
budget_publish_note_success
grep -q '^budget-publish-stale-testhost|RECOVERED' "$ALERTS" \
  || { echo "FAIL: recovery did not clear the escalation"; cat "$ALERTS"; exit 1; }

# 4. An unreachable journal: the re-clone fails and the old clone survives.
export JOURNAL_REMOTE="$TR/missing.git"
touch "$CLONE/.git/wedged"
open_outage 1900
budget_publish_outage_recover "$CLONE" 2>/dev/null && { echo "FAIL: unreachable re-clone succeeded"; exit 1; }
[ -e "$CLONE/.git/wedged" ] || { echo "FAIL: failed re-clone replaced the clone"; exit 1; }

echo "PASS: stale snapshot outage re-clones once, escalates once on failure, keeps the clone"
