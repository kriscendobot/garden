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

    digest="$(claim_attempt_digest "$base" "$claimed_at" "$host" "$worker_kind" "$gardener")"
    message_id="deadline-nudge-$digest"
    [ ! -e "$DIR/inbox/$base/unread/$message_id.md" ] || continue
    [ ! -e "$DIR/inbox/$base/read/$message_id.md" ] || continue
    # Do not create a mailbox for a completed, reaped, or otherwise changed
    # attempt. A CAS loss after this check forces a full sync and recomputation.
    if [ ! -d "$DIR/inbox/$base/unread" ] || [ ! -d "$DIR/inbox/$base/read" ]; then
      continue
    fi

    deadline_at="$(date -u -d "@$deadline" +%FT%TZ)"
    minutes=$(( (remaining + 59) / 60 ))
    message_path="inbox/$base/unread/$message_id.md"
    {
      printf 'from_host: %s\n' "$GARDEN"
      printf 'from: deadline-nudge\n'
      printf 'sent_at: %s\n' "$(date -u -d "@$now" +%FT%TZ)"
      printf 'kind: deadline-nudge\n'
      printf 'claim_attempt: %s\n' "$digest"
      printf 'deadline_at: %s\n' "$deadline_at"
      printf 'remaining_seconds: %s\n' "$remaining"
      printf '%s\n' '---'
      printf 'Deadline nudge: about %s minutes remain in this attempt. Wrap up now. ' "$minutes"
      printf 'If the remaining work is separable, finish the current unit honestly and record the next job under `## Follow-ups`; garden-follow-up consumes that section. '
      printf 'Preserve and commit safe progress before the wall. '
      printf '%s\n' "Do not emit the completion signal while the current job's core deliverable is unfinished."
    } > "$DIR/$message_path"
    git -C "$DIR" add "$message_path"
    staged=$((staged + 1))
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
