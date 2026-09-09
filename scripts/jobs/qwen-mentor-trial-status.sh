#!/bin/bash
# qwen-mentor-trial-status.sh — read-only review of the bounded qwen3.6 trial.
set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=common.sh
source "$HERE/common.sh"
export GARDEN_TAG=qwen-mentor-trial-status

DIR="${GARDEN_PRODUCER_CLONE:-$GARDEN_STATE/producer/journal}"
ensure_clone "$DIR"
sync_clone "$DIR"

read -r finals demerits < <(qwen_mentor_trial_score "$DIR")
attempts="$(qwen_mentor_trial_attempts "$DIR")"
read -r measured sittings comments max_s max_c breached clean balanced \
  < <(qwen_mentor_trial_measurement "$DIR")
slots=""
for f in "$DIR"/jobs/{plan,todo,doin,tada}/*.md; do
  [ -f "$f" ] || continue
  [ "$(plan_field "$f" trial)" = "$QWEN_MENTOR_TRIAL_ID" ] || continue
  slot="$(plan_field "$f" trial-slot)"
  base="${f##*/}"; base="${base%.md}"
  state="${f%/*}"; state="${state##*/}"
  slots="${slots}${slot:-?}:${state}:${base}\n"
done
for f in "$DIR"/reputation/{events,pending,probes}/*.md; do
  [ -f "$f" ] || continue
  [ "$(plan_field "$f" trial)" = "$QWEN_MENTOR_TRIAL_ID" ] || continue
  slot="$(plan_field "$f" trial-slot)"
  base="$(plan_field "$f" base)"
  state="${f%/*}"; state="${state##*/}"
  slots="${slots}${slot:-?}:${state}:${base:-unknown}\n"
done
clone_unlock "$DIR" 2>/dev/null || true

printf 'trial: %s\nmodel: %s\nclassification: local/minion (unchanged)\ncap: %s distinct jobs\n' \
  "$QWEN_MENTOR_TRIAL_ID" "$QWEN_MENTOR_TRIAL_MODEL" "$QWEN_MENTOR_TRIAL_CAP"
printf 'finalized_attributable_outcomes: %s\nverified_demerits: %s\n' "$finals" "$demerits"
printf 'consumed_attempt_slots: %s\n' "$attempts"
printf 'receipt_measured_acceptances: %s\n' "$measured"
printf 'human_review_sittings: %s/%s (largest case %s/%s)\n' \
  "$sittings" "$QWEN_MENTOR_TRIAL_SITTINGS_CAP" "$max_s" "$QWEN_MENTOR_TRIAL_CASE_SITTINGS_CAP"
printf 'human_comments: %s/%s (largest case %s/%s)\n' \
  "$comments" "$QWEN_MENTOR_TRIAL_COMMENTS_CAP" "$max_c" "$QWEN_MENTOR_TRIAL_CASE_COMMENTS_CAP"
printf 'clean_primary_carrier_cases: %s/%s\n' "$clean" "$QWEN_MENTOR_TRIAL_CLEAN_CASE_MIN"
printf 'work_classes_with_two_clean_cases: %s/2\n' "$balanced"
if qwen_mentor_trial_promotion_reviewable "$DIR"; then
  printf 'promotion_evidence: reviewable (never automatic)\n'
else
  printf 'promotion_evidence: insufficient\n'
fi
if [ "$finals" -gt 0 ]; then
  awk -v d="$demerits" -v n="$finals" 'BEGIN { printf "verified_demerit_rate: %.1f%%\n", 100*d/n }'
else
  printf 'verified_demerit_rate: n/a\n'
fi
printf 'slots:\n'
printf '%b' "$slots" | sort -t: -k1,1n
if qwen_mentor_trial_admits "$DIR"; then
  printf 'admission: open (unused unique slots only)\n'
else
  printf 'admission: stopped (review required; do not post or claim more trial work)\n'
fi
