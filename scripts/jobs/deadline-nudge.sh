#!/bin/bash
# deadline-nudge.sh - queue one deadline-approaching warning per live claim.
#
# A leader-only systemd timer runs this deterministic scanner once per minute.
# Delivery is an inbox append only: the running agent observes it when it next
# calls inbox-read.sh. Every push is conditional on the same committed claim
# attempt still occupying jobs/doin/, so a stale sender cannot warn a later claim.

set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=common.sh
source "$HERE/common.sh"
export GARDEN_TAG="deadline-nudge"

: "${GARDEN_DEADLINE_NUDGE_INTERVAL:=60}"
: "${GARDEN_DEADLINE_NUDGE_FRACTION:=4}"
: "${GARDEN_DEADLINE_NUDGE_CAP:=900}"
: "${GARDEN_DEADLINE_NUDGE_PUSH_ATTEMPTS:=5}"
: "${GARDEN_DEADLINE_NUDGE_CLONE_ATTEMPTS:=3}"
: "${GARDEN_DEADLINE_NUDGE_SYNC_ATTEMPTS:=3}"

DIR="${GARDEN_DEADLINE_NUDGE_CLONE:-$GARDEN_STATE/deadline-nudge/journal}"
# Host-local, reconstructible record of the current tick's stage and, on a
# failing exit, its command and breadcrumbs. The tick subshell writes it; the
# parent reads it into the final WARN (see tick_stage / tick_fault_summary).
FAULT="${GARDEN_DEADLINE_NUDGE_FAULT:-$GARDEN_STATE/deadline-nudge/tick-fault}"

positive_integer() { [[ "${1:-}" =~ ^[1-9][0-9]*$ ]]; }

# ensure_clone and sync_clone deliberately exit from several failure paths. Run
# them in contained subshells so this courtesy timer can absorb a short-lived
# prerequisite failure instead of abandoning the whole tick on the first try.
# A successful sync normally leaves the clone lock held for the following
# write/push transaction; the subshell closes that fd, so reacquire it before
# returning to the caller.
prepare_clone() {
  local attempt rc=1
  for attempt in $(seq 1 "$GARDEN_DEADLINE_NUDGE_CLONE_ATTEMPTS"); do
    rc=0
    ( ensure_clone "$DIR" ) || rc=$?
    [ "$rc" -eq 0 ] && return 0
    if [ "$rc" -eq "$GARDEN_OFFLINE_RC" ]; then
      log "deadline-nudge clone stage skipped: journal offline (rc=$rc); deferring to next timer tick"
      return "$rc"
    fi
    log "deadline-nudge clone stage failed (attempt $attempt/$GARDEN_DEADLINE_NUDGE_CLONE_ATTEMPTS, rc=$rc)"
    [ "$attempt" -ge "$GARDEN_DEADLINE_NUDGE_CLONE_ATTEMPTS" ] || backoff "$attempt"
  done
  log "ERROR: deadline-nudge clone stage exhausted after $GARDEN_DEADLINE_NUDGE_CLONE_ATTEMPTS attempt(s) (last rc=$rc); deferring to next timer tick"
  return "$rc"
}

sync_journal() {
  local attempt rc=1
  for attempt in $(seq 1 "$GARDEN_DEADLINE_NUDGE_SYNC_ATTEMPTS"); do
    rc=0
    ( sync_clone "$DIR" ) || rc=$?
    if [ "$rc" -eq 0 ]; then
      clone_lock "$DIR"
      return 0
    fi
    # A connectivity blip is a routine transient, not a stage fault to retry or
    # surface as exhausted: sync_clone already logged the outage and exits
    # EX_TEMPFAIL. Defer this tick cleanly rather than spinning the retry bound.
    if [ "$rc" -eq "$GARDEN_OFFLINE_RC" ]; then
      log "deadline-nudge journal-sync stage skipped: journal offline (rc=$rc); deferring to next timer tick"
      return "$rc"
    fi
    log "deadline-nudge journal-sync stage failed (attempt $attempt/$GARDEN_DEADLINE_NUDGE_SYNC_ATTEMPTS, rc=$rc)"
    [ "$attempt" -ge "$GARDEN_DEADLINE_NUDGE_SYNC_ATTEMPTS" ] || backoff "$attempt"
  done
  log "ERROR: deadline-nudge journal-sync stage exhausted after $GARDEN_DEADLINE_NUDGE_SYNC_ATTEMPTS attempt(s) (last rc=$rc); deferring to next timer tick"
  return "$rc"
}

claim_field() {
  local job_file="$1" field="$2"
  awk -v field="$field" '
    /^---$/ { in_claim=0; next }
    /^claim:$/ { in_claim=1; next }
    in_claim && index($0, "  " field ":") == 1 {
      value=$0
      sub("^  " field ":[[:space:]]*", "", value)
    }
    END { print value }
  ' "$job_file"
}

claim_attempt_digest() {
  local base="$1" claimed_at="$2" host="$3" worker_kind="$4" gardener="$5"
  printf '%s\037%s\037%s\037%s\037%s' \
    "$base" "$claimed_at" "$host" "$worker_kind" "$gardener" \
    | sha256sum | cut -c1-16
}

campaign_for_child() {
  local child="$1" record children c
  shopt -s nullglob
  for record in "$DIR/$JOBS_ORCH"/*.md; do
    children="$(orch_children "$record")"
    for c in $children; do
      if [ "$c" = "$child" ]; then
        basename "$record" .md
        shopt -u nullglob
        return 0
      fi
    done
  done
  shopt -u nullglob
  return 1
}

quota_facts() {
  local total status quota remaining row subscription _pool _provider _kind
  quota="${GARDEN_TOKEN_WEEKLY_QUOTA:-0}"
  subscription="$(budget_pool_for_provider_host anthropic "$GARDEN" "$DIR" 2>/dev/null || true)"
  if [ -n "$subscription" ] && row="$(budget_pool_row "$subscription" "$DIR" 2>/dev/null)"; then
    IFS=$'\t' read -r _pool _provider _kind quota _ <<<"$row"
  fi
  status="$(meter_quota_status "$subscription" "$DIR")"
  total="$(meter_subscription_window_total "$subscription" "$DIR" 2>/dev/null || true)"
  case "$quota" in ''|*[!0-9]*) quota=0 ;; esac
  case "$total" in ''|*[!0-9]*) total=unknown ;; esac
  remaining=unknown
  if [ "$quota" -gt 0 ] && [ "$total" != unknown ]; then
    remaining=$(( quota - total )); [ "$remaining" -ge 0 ] || remaining=0
    if [ "$total" -ge "$quota" ]; then status=exhausted
    elif [ "$status" = backoff ]; then status=near
    fi
  fi
  printf '%s\t%s\t%s\t%s\n' "$status" "$total" "$quota" "$remaining"
}

nudge_enabled() {
  local value="${GARDEN_DEADLINE_NUDGE_ENABLED:-}"
  if [ -z "$value" ] && [ -s "$DIR/$GARDEN_DEADLINE_NUDGE_CONFIG_PATH" ]; then
    value="$(head -1 "$DIR/$GARDEN_DEADLINE_NUDGE_CONFIG_PATH" 2>/dev/null || true)"
  fi
  value="$(printf '%s' "${value:-on}" | tr '[:upper:]' '[:lower:]' | tr -d '[:space:]')"
  case "$value" in
    on|1|true|yes) return 0 ;;
    off|0|false|no) return 1 ;;
    *) log "invalid deadline-nudge enablement '$value'; disabling this tick"; return 1 ;;
  esac
}

stage_due_messages() {
  local now="$1" staged=0 file_name job_file base claimed_at claim_epoch
  local host worker_kind gardener budget deadline remaining fractional_lead
  local two_tick_floor lead digest message_id deadline_at minutes message_path
  local checkpoint_id checkpoint_path primary_missing checkpoint_missing
  local attempt_billable job_billable job_output token_budget token_remaining budget_source budget_epoch
  local campaign campaign_budget campaign_spend campaign_remaining campaign_json
  local quota_status quota_spend quota_budget quota_remaining quota_refresh_at quota_reset_epoch
  local provider_quota provider_quota_type provider_quota_reset
  local job_quota_status job_quota_refresh add_rc

  IFS=$'\t' read -r quota_status quota_spend quota_budget quota_remaining < <(quota_facts)
  local_subscription="$(budget_pool_for_provider_host anthropic "$GARDEN" "$DIR" 2>/dev/null || true)"
  quota_reset_epoch="$(subscription_next_reset_epoch "$local_subscription" "$DIR" "$now" 2>/dev/null || true)"
  if [[ "$quota_reset_epoch" =~ ^[0-9]+$ ]]; then
    quota_refresh_at="$(date -u -d "@$quota_reset_epoch" +%FT%TZ)"
  else
    quota_refresh_at="$(date -u -d "@$((now + GARDEN_TOKEN_WINDOW_SECS))" +%FT%TZ)"
  fi

  while IFS= read -r file_name; do
    [ -n "$file_name" ] || continue
    job_file="$DIR/$JOBS_DOIN/$file_name"
    [ -f "$job_file" ] || continue
    base="${file_name%.md}"

    # A reap-now claim has no running handler left to warn. The reaper owns its
    # next transition and all cycle-marker accounting.
    grep -qxF "$REAP_NOW_MARKER" "$job_file" 2>/dev/null && continue

    claimed_at="$(claim_field "$job_file" claimed_at)"
    host="$(claim_field "$job_file" host)"
    worker_kind="$(claim_field "$job_file" worker_kind)"
    gardener="$(claim_field "$job_file" gardener)"
    if [ -z "$claimed_at" ] || [ -z "$host" ] || [ -z "$worker_kind" ] || [ -z "$gardener" ]; then
      log "skipping '$base': incomplete claim tuple"
      continue
    fi
    claim_epoch="$(date -u -d "$claimed_at" +%s 2>/dev/null || true)"
    if ! [[ "$claim_epoch" =~ ^[0-9]+$ ]]; then
      log "skipping '$base': malformed claimed_at '$claimed_at'"
      continue
    fi

    budget="$(applied_handler_budget "$job_file")"
    positive_integer "$budget" || { log "skipping '$base': invalid applied budget '$budget'"; continue; }
    deadline=$(( claim_epoch + budget ))
    remaining=$(( deadline - now ))
    [ "$remaining" -gt 0 ] || continue

    fractional_lead=$(( budget / GARDEN_DEADLINE_NUDGE_FRACTION ))
    two_tick_floor=$(( 2 * GARDEN_DEADLINE_NUDGE_INTERVAL ))
    if [ "$fractional_lead" -gt "$two_tick_floor" ]; then
      lead="$fractional_lead"
    else
      lead="$two_tick_floor"
    fi
    [ "$lead" -le "$GARDEN_DEADLINE_NUDGE_CAP" ] || lead="$GARDEN_DEADLINE_NUDGE_CAP"
    [ "$remaining" -le "$lead" ] || continue

    job_quota_status="$quota_status"
    job_quota_refresh="$quota_refresh_at"
    provider_quota_type=none; provider_quota_reset=none
    provider_quota="$(provider_quota_backoff_fields "$job_file" 2>/dev/null || true)"
    if [ -n "$provider_quota" ]; then
      read -r provider_quota_type provider_quota_reset <<< "$provider_quota"
      job_quota_status="provider-${provider_quota_type}-exhausted"
      job_quota_refresh="$provider_quota_reset"
    fi

    digest="$(claim_attempt_digest "$base" "$claimed_at" "$host" "$worker_kind" "$gardener")"
    message_id="deadline-nudge-$digest"
    checkpoint_id="deadline-checkpoint-$digest"
    primary_missing=0; checkpoint_missing=0
    if [ ! -e "$DIR/inbox/$base/unread/$message_id.md" ] \
       && [ ! -e "$DIR/inbox/$base/read/$message_id.md" ]; then
      primary_missing=1
    fi
    if [ "$remaining" -le "$two_tick_floor" ] \
       && [ ! -e "$DIR/inbox/$base/unread/$checkpoint_id.md" ] \
       && [ ! -e "$DIR/inbox/$base/read/$checkpoint_id.md" ]; then
      checkpoint_missing=1
    fi
    [ "$primary_missing" -eq 1 ] || [ "$checkpoint_missing" -eq 1 ] || continue
    # Do not create a mailbox for a completed, reaped, or otherwise changed
    # attempt. A CAS loss after this check forces a full sync and recomputation.
    if [ ! -d "$DIR/inbox/$base/unread" ] || [ ! -d "$DIR/inbox/$base/read" ]; then
      continue
    fi

    deadline_at="$(date -u -d "@$deadline" +%FT%TZ)"
    minutes=$(( (remaining + 59) / 60 ))
    attempt_billable="$(usage_tokens_since "$DIR" "$base" "$claimed_at" billable 2>/dev/null || true)"
    budget_epoch="$(plan_field "$job_file" token-budget-epoch)"
    job_billable="$(usage_tokens_since "$DIR" "$base" "${budget_epoch:--}" billable 2>/dev/null || true)"
    job_output="$(usage_tokens_since "$DIR" "$base" "${budget_epoch:--}" output 2>/dev/null || true)"
    [ -n "$attempt_billable" ] || attempt_billable=unknown
    [ -n "$job_billable" ] || job_billable=unknown
    [ -n "$job_output" ] || job_output=unknown
    token_budget="$(applied_token_budget "$job_file")"
    if [[ "$job_output" =~ ^[0-9]+$ ]]; then
      token_remaining=$(( token_budget - job_output )); [ "$token_remaining" -ge 0 ] || token_remaining=0
    else
      token_remaining=unknown
    fi
    if [[ "$(plan_field "$job_file" token-budget)" =~ ^[1-9][0-9]*$ ]]; then
      budget_source=declared
    else
      budget_source=role-default
    fi
    campaign="$(campaign_for_child "$base" 2>/dev/null || true)"
    campaign_budget=none; campaign_spend=none; campaign_remaining=none
    if [ -n "$campaign" ]; then
      campaign_json="$("$HERE/campaign-spend.sh" --dir "$DIR" "$campaign" 2>/dev/null || true)"
      if [ -n "$campaign_json" ] && command -v jq >/dev/null 2>&1; then
        campaign_budget="$(jq -r '.budget_tokens // "unknown"' <<<"$campaign_json")"
        campaign_spend="$(jq -r '.spend_tokens // "unknown"' <<<"$campaign_json")"
        campaign_remaining="$(jq -r '.unspent_tokens // "unknown"' <<<"$campaign_json")"
      else
        campaign_budget="$(orch_budget_tokens "$DIR/$JOBS_ORCH/$campaign.md")"
        [ -n "$campaign_budget" ] || campaign_budget=unbudgeted
        campaign_spend=unknown; campaign_remaining=unknown
      fi
    else
      campaign=none
    fi
    message_path="inbox/$base/unread/$message_id.md"
    if [ "$primary_missing" -eq 1 ]; then {
      printf 'from_host: %s\n' "$GARDEN"
      printf 'from: deadline-nudge\n'
      printf 'sent_at: %s\n' "$(date -u -d "@$now" +%FT%TZ)"
      printf 'kind: deadline-nudge\n'
      printf 'claim_attempt: %s\n' "$digest"
      printf 'deadline_at: %s\n' "$deadline_at"
      printf 'remaining_seconds: %s\n' "$remaining"
      printf 'attempt_billable_tokens: %s\n' "$attempt_billable"
      printf 'job_billable_tokens_spent: %s\n' "$job_billable"
      printf 'job_output_tokens_spent: %s\n' "$job_output"
      printf 'job_token_budget: %s\n' "$token_budget"
      printf 'job_token_budget_source: %s\n' "$budget_source"
      printf 'job_token_budget_epoch: %s\n' "${budget_epoch:-lifetime}"
      printf 'job_token_budget_remaining: %s\n' "$token_remaining"
      printf 'campaign: %s\n' "$campaign"
      printf 'campaign_budget_tokens: %s\n' "$campaign_budget"
      printf 'campaign_spend_tokens: %s\n' "$campaign_spend"
      printf 'campaign_budget_remaining: %s\n' "$campaign_remaining"
      printf 'quota_window_status: %s\n' "$job_quota_status"
      printf 'provider_quota_limit: %s\n' "$provider_quota_type"
      printf 'provider_quota_resets_at: %s\n' "$provider_quota_reset"
      printf 'quota_window_spend_tokens: %s\n' "$quota_spend"
      printf 'quota_window_budget_tokens: %s\n' "$quota_budget"
      printf 'quota_window_remaining_tokens: %s\n' "$quota_remaining"
      printf 'quota_window_seconds: %s\n' "$GARDEN_TOKEN_WINDOW_SECS"
      printf 'quota_window_reevaluate_at: %s\n' "$job_quota_refresh"
      printf '%s\n' '---'
      printf 'Deadline nudge: about %s minutes remain in this attempt. Wrap up now. ' "$minutes"
      printf 'Use the budget fields above to choose: continue only if the remaining unit fits; post a parked successor with `post-plan.sh --budget-hold` for quota refresh, `post-plan.sh --go-ahead` for maintainer authorization, or `post-plan.sh --deferred` for priority parking. '
      printf 'For one continuous, sequential unit, commit and push safe progress, post one successor with `post-job.sh <successor-base>` and an appropriate `handler-timeout:`, and do not fan it out across agents; then declare the evidenced handoff. '
      printf 'For separable stages, park children with `post-plan.sh --orchestrated --orchestrated-by <orch>` and record them with `post-orchestration.sh`; use `--budget-tokens` to distribute a campaign cap. '
      printf 'An unfinished deliverable must never claim clean completion. After the successor or orchestration is durably posted, report what is complete and what remains, then end with `<<<GARDEN-JOB-HANDED-OFF: <successor-base-or-orch>>>` immediately before the completion signal. '
      printf '%s\n' 'That records `handed-off:` and `deliverable-complete: false`; without a durable named successor the handoff is rejected.'
    } > "$DIR/$message_path"
      add_rc=0
      git -C "$DIR" add "$message_path" || add_rc=$?
      if [ "$add_rc" -ne 0 ]; then
        log "deadline-nudge staging stage failed: git add '$message_path' (rc=$add_rc)"
        return 1
      fi
      staged=$((staged + 1))
    fi
    if [ "$checkpoint_missing" -eq 1 ]; then
      checkpoint_path="inbox/$base/unread/$checkpoint_id.md"
      {
        printf 'from_host: %s\n' "$GARDEN"
        printf 'from: deadline-nudge\n'
        printf 'sent_at: %s\n' "$(date -u -d "@$now" +%FT%TZ)"
        printf 'kind: deadline-checkpoint\n'
        printf 'claim_attempt: %s\n' "$digest"
        printf 'deadline_at: %s\n' "$deadline_at"
        printf 'remaining_seconds: %s\n' "$remaining"
        printf '%s\n' '---'
        printf 'Final checkpoint: %s second(s) remain. Commit and push safe WIP NOW; uncommitted work is invisible across a cross-host requeue. ' "$remaining"
        printf '%s\n' 'Then either finish honestly or use the evidenced handoff disposition from the earlier nudge. Never claim clean completion for unfinished work.'
      } > "$DIR/$checkpoint_path"
      add_rc=0
      git -C "$DIR" add "$checkpoint_path" || add_rc=$?
      if [ "$add_rc" -ne 0 ]; then
        log "deadline-nudge staging stage failed: git add '$checkpoint_path' (rc=$add_rc)"
        return 1
      fi
      staged=$((staged + 1))
    fi
  done < <(list_jobs "$DIR" "$JOBS_DOIN")

  STAGED_NUDGES="$staged"
}

# push_rejected <class>: the push was refused for a reason a retry cannot fix.
# Drop the local nudge commit and any inbox writes so the clone does not carry an
# unpushable commit into the next tick (the next tick recomputes every still-due
# warning from the synced tip), then raise ONE edge-latched repair alert: it
# fires when the rejection begins or changes class, stays silent while the same
# rejection persists, and clears on the next successful push.
PUSH_REJECT_ALERT_KEY="deadline-nudge-push-rejected:$GARDEN"
push_rejected() {
  local class="$1" detail
  detail="$(tick_trace_squash "${GARDEN_PUSH_STDERR:-}")"
  log "ERROR: deadline-nudge push stage rejected ($class, not a lost race); discarding staged nudges without retry: ${detail:-no push diagnostic}"
  clone_lock "$DIR"
  git -C "$DIR" reset -q --hard "origin/$JOURNAL_BRANCH" 2>/dev/null || true
  git -C "$DIR" clean -qfd inbox 2>/dev/null || true
  clone_unlock "$DIR"
  if alert_maintainer_edge "$PUSH_REJECT_ALERT_KEY" "$class" \
      "deadline-nudge on $GARDEN cannot push to $JOURNAL_BRANCH: $class rejection (${detail:-no push diagnostic}). Deadline warnings are not being delivered; this needs repair (credentials, upstream, or a receive-side policy), not a retry."; then
    log "deadline-nudge raised push-rejection repair alert ($class)"
  fi
}

deadline_nudge_tick() {
  local now attempt rc stage_rc
  for value in "$GARDEN_DEADLINE_NUDGE_INTERVAL" "$GARDEN_DEADLINE_NUDGE_FRACTION" \
               "$GARDEN_DEADLINE_NUDGE_CAP" "$GARDEN_DEADLINE_NUDGE_PUSH_ATTEMPTS" \
               "$GARDEN_DEADLINE_NUDGE_CLONE_ATTEMPTS" "$GARDEN_DEADLINE_NUDGE_SYNC_ATTEMPTS"; do
    if ! positive_integer "$value"; then
      log "invalid deadline-nudge timing/retry value '$value'; disabling this tick"
      return 0
    fi
  done
  tick_stage init
  now="${GARDEN_DEADLINE_NUDGE_NOW:-$(date -u +%s)}"
  if ! [[ "$now" =~ ^[0-9]+$ ]]; then
    log "invalid deadline-nudge clock '$now'; disabling this tick"
    return 0
  fi

  # Each stage below captures its own status explicitly rather than running bare
  # under `set -e`. A bare stage call lets a single transient failure escape the
  # courtesy-timer retry path, aborting the whole tick with only an opaque
  # top-level rc and no indication of WHICH stage broke — the "repeated rc=1
  # without the failing stage" symptom. The clone lock that sync_journal leaves
  # held for the write/push transaction is released on every exit path (each
  # early return here plus the subshell's EXIT trap backstop below).

  # Clone stage. prepare_clone runs its own bounded retry and logs the
  # stage-specific outcome; a failure here means no usable clone, so defer.
  tick_stage clone
  if ! prepare_clone; then
    return 0
  fi

  for attempt in $(seq 1 "$GARDEN_DEADLINE_NUDGE_PUSH_ATTEMPTS"); do
    # Journal-sync stage. sync_journal reacquires the clone lock on success and
    # logs its own stage-specific failure; defer the tick when it cannot sync.
    tick_stage journal-sync "attempt $attempt/$GARDEN_DEADLINE_NUDGE_PUSH_ATTEMPTS"
    if ! sync_journal; then
      return 0
    fi
    if ! nudge_enabled; then
      clone_unlock "$DIR"
      return 0
    fi
    # Staging stage. stage_due_messages checks the status of every fallible
    # write itself (the git-add of each queued warning) and returns non-zero
    # with a stage-named diagnostic rather than leaning on `set -e` — which is
    # unreliable that deep inside the function (nested command substitutions
    # suspend it). Capture that status explicitly so a transient staging fault
    # fails the tick open instead of silently under-staging or surfacing only an
    # opaque top-level rc.
    tick_stage staging "attempt $attempt/$GARDEN_DEADLINE_NUDGE_PUSH_ATTEMPTS"
    STAGED_NUDGES=0
    stage_rc=0
    stage_due_messages "$now" || stage_rc=$?
    if [ "$stage_rc" -ne 0 ]; then
      log "ERROR: deadline-nudge staging stage failed (rc=$stage_rc); discarding partial writes and deferring to next timer tick"
      # A mid-loop failure can leave earlier warnings written+staged (uncommitted)
      # and the failed one written-but-untracked. Left behind, next tick's
      # existence check would treat those files as already delivered and skip
      # them forever. Reset the private clone to its synced tip and sweep the
      # untracked inbox writes so the next tick recomputes and re-delivers every
      # still-due warning cleanly. This clone is the scanner's own and lock-held.
      git -C "$DIR" reset -q --hard 2>/dev/null || true
      git -C "$DIR" clean -qfd inbox 2>/dev/null || true
      clone_unlock "$DIR"
      return 0
    fi
    if [ "$STAGED_NUDGES" -eq 0 ]; then
      clone_unlock "$DIR"
      return 0
    fi
    # Push stage. commit_and_push releases the clone lock on every path.
    tick_stage push "attempt $attempt/$GARDEN_DEADLINE_NUDGE_PUSH_ATTEMPTS"
    rc=0
    commit_and_push "$DIR" "deadline-nudge: queue $STAGED_NUDGES warning(s) from $GARDEN" || rc=$?
    case "$rc" in
      0)
        log "queued $STAGED_NUDGES deadline nudge(s)"
        alert_maintainer_edge_clear "$PUSH_REJECT_ALERT_KEY" \
          "deadline-nudge on $GARDEN pushed to $JOURNAL_BRANCH again; the push rejection has cleared." \
          && log "deadline-nudge push rejection cleared"
        return 0 ;;
      2) return 0 ;;
    esac
    # Only a lost CAS (or an unclassified, ambiguous failure) is worth another
    # sync-and-retry. A definite or server-side rejection (auth drift, a gone
    # upstream, a hook/policy wall) fails identically on every attempt, so
    # retrying only repeats the same "exhausted" warning; give up at once.
    case "${GARDEN_COMMIT_PUSH_CLASS:-}" in
      definite-fail|server-reject)
        push_rejected "$GARDEN_COMMIT_PUSH_CLASS"
        return 0 ;;
    esac
    log "deadline-nudge push stage lost a race (attempt $attempt/$GARDEN_DEADLINE_NUDGE_PUSH_ATTEMPTS); recomputing claims"
    [ "$attempt" -ge "$GARDEN_DEADLINE_NUDGE_PUSH_ATTEMPTS" ] || backoff "$attempt"
  done
  log "ERROR: deadline-nudge push stage exhausted after $GARDEN_DEADLINE_NUDGE_PUSH_ATTEMPTS attempt(s); deferring to next timer tick"
  tick_fault_detail "push stage exhausted after $GARDEN_DEADLINE_NUDGE_PUSH_ATTEMPTS attempt(s) (last commit_and_push rc=$rc)"
  return 1
}

# Failure diagnostics for the tick subshell. A bare "tick failed (rc=1)" names
# no stage or command, so the subshell carries two breadcrumbs:
#   - an ERR trap (inherited into functions via `set -E`) remembers the most
#     recent failed simple commands with their lines and call stacks; and
#   - the EXIT trap, on a non-zero exit, logs the command executing at exit (an
#     `exit` from a sourced helper, or the tick's final `return 1`) and its stack,
#     together with those breadcrumbs.
# Commands whose failure is already handled (`if`/`||`/`&&`/`!`) never fire ERR,
# so each breadcrumb is an unhandled failure — usually the culprit.
tick_trace_squash() {
  local text="${1//$'\n'/ }"
  text="${text//$'\t'/ }"
  [ "${#text}" -le 240 ] || text="${text:0:237}..."
  printf '%s' "$text"
}

# tick_trace_stack [innermost-line]: "fn@file:line < caller@file:line < ...",
# skipping this helper and its trap-handler caller (frames 0 and 1). The EXIT
# trap passes no line: bash does not report where an `exit` ran, only where each
# enclosing frame was called from.
tick_trace_stack() {
  local line="${1:-}" i out=""
  for (( i = 2; i < ${#FUNCNAME[@]}; i++ )); do
    [ "$i" -eq 2 ] || line="${BASH_LINENO[i-1]}"
    out+="${out:+ < }${FUNCNAME[i]}@${BASH_SOURCE[i]##*/}${line:+:$line}"
  done
  printf '%s' "${out:-main}"
}

# Keep the last three breadcrumbs: a failing `return 1` fires ERR again at each
# caller up the stack (named by the `return` and its call site), so the
# innermost, usually the real cause, would otherwise be overwritten.
tick_on_err() {
  local rc="$1" cmd="$2" crumb
  crumb="rc=$rc \`$(tick_trace_squash "$cmd")\` at $(tick_trace_stack "${BASH_LINENO[0]}")"
  TICK_ERR_TRAIL=("${TICK_ERR_TRAIL[@]: -2}" "$crumb")
}

tick_err_trail() {
  local out="" crumb
  for crumb in "${TICK_ERR_TRAIL[@]}"; do out+="${out:+; }$crumb"; done
  printf '%s' "${out:-none recorded}"
}

# The fault record. Each stage overwrites it with its name as it begins, so a
# failure that fires no trap (SIGKILL, an OOM kill) still leaves the stage; an
# explicit-status failure appends a detail line before its `return 1`; the EXIT
# trap appends rc, command, and breadcrumbs on a non-zero exit. Every write is
# best-effort: diagnostics must never fail the tick.
tick_stage() {
  TICK_STAGE="$1${2:+ ($2)}"
  { mkdir -p "${FAULT%/*}" && printf 'stage: %s\n' "$TICK_STAGE" > "$FAULT"; } 2>/dev/null || true
}

tick_fault_detail() {
  printf 'detail: %s\n' "$(tick_trace_squash "$1")" >> "$FAULT" 2>/dev/null || true
}

tick_on_signal() {
  printf 'signal: %s\n' "$1" >> "$FAULT" 2>/dev/null || true
  exit "$2"
}

tick_on_exit() {
  local rc="$1" cmd="$2" command
  if [ "$rc" -ne 0 ]; then
    command="\`$(tick_trace_squash "$cmd")\` at $(tick_trace_stack)"
    log "ERROR: deadline-nudge tick exited rc=$rc in stage ${TICK_STAGE:-unknown} during $command; recent failed commands (oldest first): $(tick_err_trail)"
    printf 'rc: %s\ncommand: %s\ntrail: %s\n' "$rc" "$command" "$(tick_err_trail)" >> "$FAULT" 2>/dev/null || true
  fi
  clone_unlock "$DIR"
}

# tick_fault_summary <rc>: one line for the parent's WARN, built from the fault
# record the subshell left behind. No `command:` means the subshell died before
# its EXIT trap ran (a fatal signal), so say so and infer what the rc can tell.
tick_fault_summary() {
  local rc="$1" stage="" detail="" signal="" command="" trail="" out
  if [ -r "$FAULT" ]; then
    stage="$(sed -n 's/^stage: //p' "$FAULT" | tail -1)"
    detail="$(sed -n 's/^detail: //p' "$FAULT" | tail -1)"
    signal="$(sed -n 's/^signal: //p' "$FAULT" | tail -1)"
    command="$(sed -n 's/^command: //p' "$FAULT" | tail -1)"
    trail="$(sed -n 's/^trail: //p' "$FAULT" | tail -1)"
  fi
  out="stage=${stage:-unknown}"
  [ -z "$signal" ] || out+="; signal=$signal"
  [ -z "$detail" ] || out+="; detail=$detail"
  if [ -n "$command" ]; then
    out+="; command=$command; recent failed commands: ${trail:-none recorded}"
  else
    out+="; no fault record — failure bypassed the traps"
    [ "$rc" -le 128 ] || out+=" (rc=$rc suggests signal $((rc - 128)))"
  fi
  printf '%s' "$out"
}

# Courtesy delivery fails open. Clone, fetch, parse, commit, and exhausted-push
# failures stay local and the oneshot exits successfully for the next timer tick.
# The EXIT trap guarantees the clone lock is released whichever path (a clean
# return or an `exit` from a helper) ends the tick subshell; clone_unlock is a
# no-op when no lock is held, so it is safe on every exit.
#
# The subshell deliberately does NOT run as `( ... ) || tick_rc=$?`: bash
# suppresses both `set -e` and the ERR trap for everything inside the left side
# of `||`, which is what left earlier failures as an opaque rc. It runs as a
# plain command with errexit off on both sides instead, which keeps the tick's
# effective semantics (no errexit inside, as before) while letting ERR fire.
TICK_ERR_TRAIL=()
TICK_STAGE=""
rm -f "$FAULT" 2>/dev/null || true
set +e
(
  set -E
  trap 'tick_on_err "$?" "$BASH_COMMAND"' ERR
  trap 'tick_on_exit "$?" "$BASH_COMMAND"' EXIT
  trap 'tick_on_signal TERM 143' TERM
  trap 'tick_on_signal INT 130' INT
  trap 'tick_on_signal HUP 129' HUP
  deadline_nudge_tick
)
tick_rc=$?
set -e
if [ "$tick_rc" -ne 0 ]; then
  log "WARN: deadline nudge tick failed locally (rc=$tick_rc; $(tick_fault_summary "$tick_rc"); fault record $FAULT); next timer tick will retry"
fi
exit 0
