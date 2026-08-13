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
GARDEN_TAG="deadline-nudge"

: "${GARDEN_DEADLINE_NUDGE_INTERVAL:=60}"
: "${GARDEN_DEADLINE_NUDGE_FRACTION:=4}"
: "${GARDEN_DEADLINE_NUDGE_CAP:=900}"
: "${GARDEN_DEADLINE_NUDGE_PUSH_ATTEMPTS:=5}"

DIR="${GARDEN_DEADLINE_NUDGE_CLONE:-$GARDEN_STATE/deadline-nudge/journal}"

positive_integer() { [[ "${1:-}" =~ ^[1-9][0-9]*$ ]]; }

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
  local total status quota remaining
  quota="${GARDEN_TOKEN_WEEKLY_QUOTA:-0}"
  status="$(meter_quota_status)"
  total="$(meter_window_total 2>/dev/null || true)"
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
  local quota_status quota_spend quota_budget quota_remaining quota_refresh_at
  local provider_quota provider_quota_type provider_quota_reset
  local job_quota_status job_quota_refresh

  IFS=$'\t' read -r quota_status quota_spend quota_budget quota_remaining < <(quota_facts)
  quota_refresh_at="$(date -u -d "@$((now + GARDEN_TOKEN_WINDOW_SECS))" +%FT%TZ)"

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
      git -C "$DIR" add "$message_path"
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
      git -C "$DIR" add "$checkpoint_path"
      staged=$((staged + 1))
    fi
  done < <(list_jobs "$DIR" "$JOBS_DOIN")

  STAGED_NUDGES="$staged"
}

deadline_nudge_tick() {
  local now attempt rc
  for value in "$GARDEN_DEADLINE_NUDGE_INTERVAL" "$GARDEN_DEADLINE_NUDGE_FRACTION" \
               "$GARDEN_DEADLINE_NUDGE_CAP" "$GARDEN_DEADLINE_NUDGE_PUSH_ATTEMPTS"; do
    if ! positive_integer "$value"; then
      log "invalid deadline-nudge timing/retry value '$value'; disabling this tick"
      return 0
    fi
  done
  now="${GARDEN_DEADLINE_NUDGE_NOW:-$(date -u +%s)}"
  if ! [[ "$now" =~ ^[0-9]+$ ]]; then
    log "invalid deadline-nudge clock '$now'; disabling this tick"
    return 0
  fi

  ensure_clone "$DIR"
  for attempt in $(seq 1 "$GARDEN_DEADLINE_NUDGE_PUSH_ATTEMPTS"); do
    sync_clone "$DIR"
    if ! nudge_enabled; then
      clone_unlock "$DIR"
      return 0
    fi
    STAGED_NUDGES=0
    stage_due_messages "$now"
    if [ "$STAGED_NUDGES" -eq 0 ]; then
      clone_unlock "$DIR"
      return 0
    fi
    rc=0
    commit_and_push "$DIR" "deadline-nudge: queue $STAGED_NUDGES warning(s) from $GARDEN" || rc=$?
    case "$rc" in
      0) log "queued $STAGED_NUDGES deadline nudge(s)"; return 0 ;;
      2) return 0 ;;
    esac
    log "deadline-nudge push lost a race (attempt $attempt); recomputing claims"
    [ "$attempt" -ge "$GARDEN_DEADLINE_NUDGE_PUSH_ATTEMPTS" ] || backoff "$attempt"
  done
  return 1
}

# Courtesy delivery fails open. Clone, fetch, parse, commit, and exhausted-push
# failures stay local and the oneshot exits successfully for the next timer tick.
tick_rc=0
( deadline_nudge_tick ) || tick_rc=$?
if [ "$tick_rc" -ne 0 ]; then
  log "WARN: deadline nudge tick failed locally (rc=$tick_rc); next timer tick will retry"
fi
exit 0
