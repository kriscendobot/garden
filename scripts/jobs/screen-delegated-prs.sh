#!/bin/bash
# screen-delegated-prs.sh — proxy pre-pass 1d: screen and merge kriscendobot/minion.town
# pull requests under the maintainer's screening delegation (no LLM).
#
# Design: designs/minion-town-pr-screening.md; operations:
# context/operations/minion-town-screening.md. Inert (exit 0, quiet) until the
# delegation record config/delegations/minion-town-pr-screening is seeded with
# scripts/jobs/minion-town-screening.sh seed; revoked, paused, or tampered records
# deny it. One tick (scripts/jobs/screening/driver.py):
#   - post-merge validation of attested merges: deploy.yml + the MCP watchdog; a
#     failure pauses the delegation, posts a heal fixer, and notifies the maintainer;
#   - auto-resume of a screener-made pause after a green main deploy + healthy watchdog;
#   - the screen: gates 1–8 on each open PR's exact head, writing an attestation under
#     screenings/ and posting a conductor that runs
#     ci-wait-merge.sh --screened-delegated-merge.
# Reads only GitHub metadata, CI rollups, diff paths, and journal records (the body is
# matched only against exact heal and fixed gap-revealing markers), so it widens no surveillance.
#
# Journal writes land in ONE CAS commit on a dedicated clone; the driver's actions
# (deterministically named posts and gauntlet records) run only after
# that commit lands, and each is idempotent across ticks.
#
# Consecutive driver failures (including host-wide GitHub quota deferrals) are
# tracked in host-local state. The third failed tick raises one coalesced watchdog
# notice; the first completed tick closes it.
#
# Test seams: GARDEN_SCREEN_CLONE, GARDEN_SCREEN_HEARTBEAT, GARDEN_GH,
# GARDEN_SCREEN_GITHUB_READ, GARDEN_SCREEN_POST_JOB, GARDEN_SCREEN_POST_GAUNTLET,
# GARDEN_SCREEN_FAILURE_THRESHOLD, GARDEN_SCREEN_JOURNAL_ATTEMPTS.
set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=common.sh
source "$HERE/common.sh"
export GARDEN_TAG="${GARDEN_TAG:-proxy-screen}"

journal="${GARDEN_SCREEN_CLONE:-$GARDEN_STATE/screening/journal}"
: "${GARDEN_SCREEN_HEARTBEAT:=${GARDEN_MINION_MCP_DIR:-$GARDEN_STATE/minion-mcp}/heartbeat.json}"
: "${GARDEN_SCREEN_POST_JOB:=$HERE/post-job.sh}"
: "${GARDEN_SCREEN_POST_GAUNTLET:=$HERE/post-gauntlet.sh}"
export GARDEN_SCREEN_HEARTBEAT
ensure_clone "$journal"
out="$(mktemp)"; err="$(mktemp)"; trap 'rm -f "$out" "$err"' EXIT

: "${GARDEN_SCREEN_FAILURE_THRESHOLD:=3}"
[[ "$GARDEN_SCREEN_FAILURE_THRESHOLD" =~ ^[1-9][0-9]*$ ]] \
  || GARDEN_SCREEN_FAILURE_THRESHOLD=3
: "${GARDEN_SCREEN_JOURNAL_ATTEMPTS:=20}"
[[ "$GARDEN_SCREEN_JOURNAL_ATTEMPTS" =~ ^[1-9][0-9]*$ ]] \
  || GARDEN_SCREEN_JOURNAL_ATTEMPTS=20
failure_dir="$GARDEN_STATE/screening/tick-failure"
failure_key="minion-town-screening-tick-failed-$GARDEN"

record_screen_failure() { # record_screen_failure <class> <detail>
  local class="$1" detail="$2" count=0 first now tmp item
  mkdir -p "$failure_dir"
  count="$(cat "$failure_dir/count" 2>/dev/null || echo 0)"
  [[ "$count" =~ ^[0-9]+$ ]] || count=0
  count=$(( count + 1 ))
  now="$(date -u +%FT%TZ)"
  first="$(cat "$failure_dir/first" 2>/dev/null || true)"
  [ -n "$first" ] || first="$now"
  for item in "class:$class" "count:$count" "first:$first" "detail:$detail"; do
    tmp="$(mktemp "$failure_dir/.state.XXXXXX")"
    printf '%s\n' "${item#*:}" > "$tmp"
    mv -f "$tmp" "$failure_dir/${item%%:*}"
  done
  if [ "$count" -ge "$GARDEN_SCREEN_FAILURE_THRESHOLD" ]; then
    log "WARN: minion.town screening tick $class for $count consecutive ticks: $detail"
    alert_maintainer "$failure_key" "minion.town screening on $GARDEN has not completed for $count consecutive proxy ticks (first failure $first).

Failure class: $class
Latest detail: $detail

No screening gate was bypassed and the delegation was not resumed. The proxy will retry on its next tick and post a recovery update after a completed screen.
Runbook: context/operations/minion-town-screening.md"
  fi
}

clear_screen_failure() {
  [ -d "$failure_dir" ] || return 0
  local count
  count="$(cat "$failure_dir/count" 2>/dev/null || echo unknown)"
  rm -f "$failure_dir/class" "$failure_dir/count" "$failure_dir/first" "$failure_dir/detail"
  rmdir "$failure_dir" 2>/dev/null || true
  alert_maintainer_clear "$failure_key" \
    "minion.town screening on $GARDEN completed after a $count-tick failure streak."
}

last_push_class=""
for attempt in $(seq 1 "$GARDEN_SCREEN_JOURNAL_ATTEMPTS"); do
  sync_clone "$journal"
  rc=0
  : > "$err"
  python3 "$HERE/screening/driver.py" "$journal" > "$out" 2> "$err" || rc=$?
  if [ "$rc" -eq "${GARDEN_TRANSIENT_RC:-75}" ]; then
    # driver.py may have prepared validation records before a later GitHub read
    # met the quota latch. Discard the whole tentative tick: a deferred tick has
    # no journal effect and will recompute from fresh inputs after cooldown.
    git -C "$journal" reset --hard -q HEAD
    git -C "$journal" clean -qfd -- \
      config/delegations/minion-town-pr-screening \
      screenings/kriscendobot-minion.town \
      inbox/maintainer/unread
    detail="$(tail -n 4 "$err" | tr '\n' ' ')"; detail="${detail:0:1000}"
    [ -n "$detail" ] || detail="transient GitHub read refusal (rc=$rc)"
    record_screen_failure github-deferred "$detail"
    clone_unlock "$journal"
    exit 0
  fi
  if [ "$rc" -ne 0 ]; then
    detail="$(tail -n 4 "$err" | tr '\n' ' ')"; detail="${detail:0:1000}"
    [ -n "$detail" ] || detail="driver exited rc=$rc without a diagnostic"
    record_screen_failure driver-error "$detail"
    cat "$err" >&2
    clone_unlock "$journal"
    die "screener tick failed (GitHub read or journal parse); no state written"
  fi
  # One pathspec per add: a not-yet-created path would abort a combined add.
  for path in config/delegations/minion-town-pr-screening screenings/kriscendobot-minion.town; do
    [ -e "$journal/$path" ] && git -C "$journal" add -A -- "$path"
  done
  for notice in "$journal"/inbox/maintainer/unread/minion-town-pr-screening-*.md; do
    [ -f "$notice" ] && git -C "$journal" add -- "${notice#"$journal/"}"
  done
  rc=0
  if git -C "$journal" diff --cached --quiet; then
    clone_unlock "$journal"
  else
    commit_and_push "$journal" "proxy screen: kriscendobot/minion.town" || rc=$?
    [ "$rc" = 0 ] && clone_unlock "$journal"
  fi
  if [ "$rc" = 0 ] || [ "$rc" = 2 ]; then
    if [ "$rc" = 2 ]; then
      record_screen_failure journal-local \
        "git commit failed after screening state was staged"
      die "could not commit staged screening state"
    fi
    jq -r '.notes[]' "$out" | while IFS= read -r line; do log "$line"; done
    jq -c '.actions[]' "$out" | while IFS= read -r action; do
      kind="$(jq -r .kind <<<"$action")"
      case "$kind" in
        post)
          body="$(mktemp)"; jq -r .body <<<"$action" > "$body"
          GARDEN_SENDER=proxy:screen "$GARDEN_SCREEN_POST_JOB" "$(jq -r .base <<<"$action")" "$body" >/dev/null \
            || log "WARN: post $(jq -r .base <<<"$action") failed; retrying next tick"
          rm -f "$body" ;;
        gauntlet)
          GARDEN_SENDER=proxy:screen "$GARDEN_SCREEN_POST_GAUNTLET" --by proxy:screen \
            --max-iterations "$(jq -r .max_iterations <<<"$action")" \
            "$(jq -r .base <<<"$action")" "$(jq -r .url <<<"$action")" >/dev/null \
            || log "WARN: gauntlet $(jq -r .base <<<"$action") failed; retrying next tick" ;;
      esac
    done
    clear_screen_failure
    exit 0
  fi
  last_push_class="${GARDEN_COMMIT_PUSH_CLASS:-}"
  if journal_push_is_definite_failure "${GARDEN_PUSH_STDERR:-}" \
      || journal_diagnostic_is_definite_failure "${GARDEN_FETCH_STDERR:-}"; then
    detail="${GARDEN_PUSH_STDERR:-${GARDEN_FETCH_STDERR:-journal write failed without a diagnostic}}"
    detail="$(printf '%s' "$detail" | tail -n 4 | tr '\n' ' ')"; detail="${detail:0:1000}"
    record_screen_failure journal-local "$detail"
    die "could not commit screening state: unrecoverable journal failure"
  fi
  backoff "$attempt"
done
if [ "$last_push_class" = cas ]; then
  failure_class="journal-cas"
  detail="journal CAS contention exhausted $GARDEN_SCREEN_JOURNAL_ATTEMPTS attempts"
else
  failure_class="journal-deferred"
  detail="transient or unclassified journal write failure exhausted $GARDEN_SCREEN_JOURNAL_ATTEMPTS attempts"
fi
record_screen_failure "$failure_class" "$detail"
# The watchdog owns this retryable failure streak. Keep the dedicated systemd
# unit healthy so its timer schedules a fresh tick instead of recording a unit
# failure for ordinary journal weather.
exit 0
