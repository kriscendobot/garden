#!/bin/bash
# fit-quota-calibration.sh — the deterministic fit over the manual quota-checkpoint
# log (journal budget/manual-checkpoints/<host>.jsonl). It MEASURES a recommended
# weekly-token cap for a host and emits a confidence verdict; it does NOT actuate.
# Nothing here writes config/budget-pools or a worker count — promotion stays a
# separate deliberate act (set-budget-pool.sh). Design: designs/manual-quota-calibration.md.
#
# WHY a script and not an LLM judgment each time: the checkpoint log has three
# documented confounds that make a naive tokens-per-percent ratio unreliable (the
# ~3x implied-cap spread the log's README describes):
#   1. base mismatch — the local meter counts input+output+cache_creation and
#      EXCLUDES cache_read; the dashboard percent weights differently;
#   2. a temporary +50% weekly boost (through 2026-09-13) with an unknown start;
#   3. the local meter's window_start_epoch OSCILLATES between two anchors, so
#      meter_spend_tokens across a window change is not comparable at all.
# The deterministic response is to (a) SEGMENT the checkpoints into contiguous,
# comparable runs keyed on meter_window_start_epoch (the hard comparability
# boundary), (b)
# pick a GOVERNING segment by confidence+recency+count, (c) take the LOW end of the
# freshest highest-confidence point's rounding band as the conservative cap (cannot
# over-grant — the same policy config/budget-pools already uses), and (d) grade the
# result converged | provisional | insufficient so a shaky number is never mistaken
# for a trusted one. Fitting a richer cache-read-aware model is deferred until the
# checkpoint schema carries paired cache_read (see the design's staging).
#
#   fit-quota-calibration.sh <host> [--dry-run] [--json-only]
#
#   --dry-run    compute and print the verdict; do NOT write budget/quota-fit/<host>.json
#   --json-only  print only the verdict JSON (no human-readable recommendation line to stderr)
set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=common.sh
source "$HERE/common.sh"
export GARDEN_TAG=fit-quota-calibration

# Tunables (env-overridable). MIN_POINTS: same-window points a segment needs before
# its fit can be called converged. TOL: max acceptable max/min point-estimate ratio
# within the governing segment for `converged` (the observed 3x spread is ~3.0).
: "${GARDEN_QUOTA_FIT_MIN_POINTS:=3}"
: "${GARDEN_QUOTA_FIT_TOL:=1.20}"
[[ "$GARDEN_QUOTA_FIT_MIN_POINTS" =~ ^[1-9][0-9]*$ ]] || GARDEN_QUOTA_FIT_MIN_POINTS=3

host="${1:-}"; [ -n "$host" ] || { echo "usage: fit-quota-calibration.sh <host> [--dry-run] [--json-only]" >&2; exit 2; }
case "$host" in -*|*/*|'') echo "bad host" >&2; exit 2;; esac
shift
dry_run=false; json_only=false
while [ "$#" -gt 0 ]; do
  case "$1" in
    --dry-run) dry_run=true; shift;;
    --json-only) json_only=true; shift;;
    *) echo "unknown option: $1" >&2; exit 2;;
  esac
done
command -v jq >/dev/null 2>&1 || { echo "jq unavailable" >&2; exit 1; }

DIR="${GARDEN_PRODUCER_CLONE:-$GARDEN_STATE/producer/journal}"
ensure_clone "$DIR"
sync_clone "$DIR"

cp_file="$DIR/budget/manual-checkpoints/$host.jsonl"
[ -r "$cp_file" ] || { echo "no checkpoint log for host $host ($cp_file)" >&2; exit 1; }

now_epoch="$(date -u +%s)"
now_iso="$(date -u -d "@$now_epoch" +%FT%TZ)"

# The currently-live meter window anchor for this host, if published — used to decide
# whether the governing segment describes the window the fleet is metering against NOW.
live_win=""
lf="$DIR/budget/live/$host"
[ -r "$lf" ] && live_win="$(sed -n 's/^window_start_epoch:[[:space:]]*//p' "$lf" | head -1)"
[[ "$live_win" =~ ^[0-9]+$ ]] || live_win=""

# Optional boost-events file: rows {start,end,multiplier,note}. A boost whose interval
# covers `now` (or whose start is unknown/null while its end is still future) is an
# active confound that blocks `converged`. Absent file => no known boost.
boost_active=false; boost_unknown_start=false
bf="$DIR/budget/boost-events/$host.jsonl"
if [ -r "$bf" ]; then
  if jq -e --argjson now "$now_epoch" '
        select(((.start // "" | fromdateiso8601? // -1) as $s
              | (.end // "" | fromdateiso8601? // 9999999999) as $e
              | ($s <= $now and $now < $e) and $s >= 0))' "$bf" >/dev/null 2>&1; then
    boost_active=true
  fi
  if jq -e --argjson now "$now_epoch" '
        select(((.start // null) == null) and ((.end // "" | fromdateiso8601? // -1) as $e | $e > $now))' "$bf" >/dev/null 2>&1; then
    boost_active=true; boost_unknown_start=true
  fi
fi

# The whole fit is one jq pass over the usable rows. Usable = numeric spend, a
# pairing_confidence of high|medium|low, and weekly_percent > 0. Rows tagged none /
# flagged (no usable pairing) and null-spend rows are dropped. A segment is one
# contiguous run of a meter_window_start_epoch: A,B,A produces three segments, not
# two pooled anchor buckets. Per point we take the LOW end of the display-rounding
# band, spend / ((percent+0.5)/100), as the conservative cap.
verdict="$(jq -s \
  --arg host "$host" --arg now "$now_iso" \
  --arg live_win "$live_win" \
  --argjson min_points "$GARDEN_QUOTA_FIT_MIN_POINTS" \
  --argjson tol "$GARDEN_QUOTA_FIT_TOL" \
  --argjson boost_active "$boost_active" \
  --argjson boost_unknown "$boost_unknown_start" '
  def cw: {"high":3,"medium":2,"low":1}[.] // 0;
  def usable:
    ((.meter_window_start_epoch | type) == "number") and
    ((.meter_spend_tokens | type) == "number") and
    ((.weekly_percent // 0) > 0) and
    ((.pairing_confidence // "none") as $c | ($c=="high" or $c=="medium" or $c=="low"));
  def fit_point:
    { win: .meter_window_start_epoch,
      percent: .weekly_percent,
      spend: .meter_spend_tokens,
      confidence: .pairing_confidence,
      cw: (.pairing_confidence | cw),
      checked_at: .checked_at,
      t: (.checked_at // "" | fromdateiso8601? // 0),
      # conservative low-end cap over the +-0.5 display-rounding band
      cap_low:  (.meter_spend_tokens / ((.weekly_percent + 0.5) / 100)),
      cap_point:(.meter_spend_tokens / (.weekly_percent / 100)),
      cap_high: (.meter_spend_tokens / ((.weekly_percent - 0.5) / 100)) };
  # Observe every valid anchor transition before dropping unusable pairings. A
  # flagged B row in an A,B,A sequence still proves that the two A runs are not
  # temporally contiguous.
  (reduce .[] as $row
      ({runs:[], have_previous:false, previous_window:null, next_run_index:0};
       if (($row.meter_window_start_epoch | type) != "number") then .
       else
         if (.have_previous and ($row.meter_window_start_epoch == .previous_window)) then .
         else
           .runs += [{run_index:.next_run_index, window_start_epoch:$row.meter_window_start_epoch, points:[]}]
           | .next_run_index += 1
         end
         | .have_previous = true
         | .previous_window = $row.meter_window_start_epoch
         | if ($row | usable) then .runs[-1].points += [($row | fit_point)] else . end
       end)
    | .runs
    | map(select(.points | length > 0))
    | map(. as $run | $run.points | {
        segment_id: ("run-\($run.run_index)-anchor-\($run.window_start_epoch // "null")"),
        run_index: $run.run_index,
        window_start_epoch: $run.window_start_epoch,
        first_checked_at: .[0].checked_at,
        last_checked_at: .[-1].checked_at,
        n_points: length,
        total_weight: (map(.cw) | add),
        newest_t: (map(.t) | max),
        percent_min: (map(.percent) | min),
        percent_max: (map(.percent) | max),
        cap_point_min: (map(.cap_point) | min),
        cap_point_max: (map(.cap_point) | max),
        spread_ratio: ((map(.cap_point) | max) / ((map(.cap_point) | min) | if . == 0 then 1 else . end)),
        # governing point within the segment: highest confidence, then most recent
        best: (sort_by([.cw, .t]) | last)
      })) as $segs
  | ($segs | sort_by([.total_weight, .newest_t, .n_points]) | last) as $gov
  | if ($segs | length) == 0 then
      { host:$host, generated_at:$now, confidence:"insufficient",
        selected_cap_tokens:null, method:"segment-low-band",
        note:"no usable paired checkpoints (all rows none/flagged or null-spend)",
        segments:[], boost_active:$boost_active }
    else
      ( $gov.best ) as $bp
      | ($gov.spread_ratio <= $tol) as $tight
      | ($gov.n_points >= $min_points) as $enough
      | (($live_win != "") and (($gov.window_start_epoch|tostring) == $live_win)) as $is_live_window
      | (if ($enough and $tight and ($boost_active|not) and $is_live_window) then "converged"
         elif $enough then "provisional"
         else "insufficient" end) as $grade
      | { host:$host, generated_at:$now,
          confidence:$grade,
          method:"contiguous-segment-low-band (governing = max total-confidence-weight run, best = freshest highest-confidence point, cap = its low-end rounding band)",
          selected_cap_tokens: ($bp.cap_low | floor),
          selected_cap_band: { low: ($bp.cap_low|floor), point: ($bp.cap_point|floor), high: ($bp.cap_high|floor) },
          governing_point: { checked_at: $bp.checked_at, weekly_percent: $bp.percent, meter_spend_tokens: $bp.spend, pairing_confidence: $bp.confidence, window_start_epoch: $bp.win },
          governing_segment: { segment_id: $gov.segment_id, run_index: $gov.run_index, window_start_epoch: $gov.window_start_epoch, first_checked_at: $gov.first_checked_at, last_checked_at: $gov.last_checked_at, n_points: $gov.n_points, total_confidence_weight: $gov.total_weight, percent_range: [$gov.percent_min, $gov.percent_max], cap_point_spread: [$gov.cap_point_min|floor, $gov.cap_point_max|floor], spread_ratio: ($gov.spread_ratio*1000|round/1000), is_live_window: $is_live_window },
          checks: { enough_points: $enough, min_points: $min_points, spread_within_tolerance: $tight, tolerance: $tol, boost_active: $boost_active, boost_unknown_start: $boost_unknown, live_window_matches: $is_live_window, live_window_start_epoch: (if $live_win=="" then null else ($live_win|tonumber) end) },
          segments: ($segs | map({segment_id, run_index, window_start_epoch, first_checked_at, last_checked_at, n_points, total_weight, percent_range:[.percent_min,.percent_max], cap_point_low:(.cap_point_min|floor), cap_point_high:(.cap_point_max|floor), spread_ratio:(.spread_ratio*1000|round/1000)})),
          boost_active:$boost_active }
    end
' "$cp_file")" || { echo "fit failed" >&2; exit 1; }

printf '%s\n' "$verdict"

if [ "$json_only" = false ]; then
  grade="$(printf '%s' "$verdict" | jq -r '.confidence')"
  cap="$(printf '%s' "$verdict" | jq -r '.selected_cap_tokens // "none"')"
  case "$grade" in
    converged)   echo "RECOMMENDATION [$host]: cap=$cap is CONVERGED — promote with set-budget-pool.sh 'anthropic:$host' $cap manual-fit $(date -u +%F)." >&2 ;;
    provisional) echo "RECOMMENDATION [$host]: cap=$cap is PROVISIONAL — do NOT promote to a trusted cap; keep the current conservative cap or unblock by hand, and keep appending checkpoints. See .checks for what failed." >&2 ;;
    insufficient)echo "RECOMMENDATION [$host]: INSUFFICIENT data for a trustworthy fit — keep appending checkpoints; do not actuate on this." >&2 ;;
  esac
fi

if [ "$dry_run" = false ]; then
  out_dir="$DIR/budget/quota-fit"
  mkdir -p "$out_dir"
  printf '%s\n' "$verdict" | jq . > "$out_dir/$host.json"
  git -C "$DIR" add "budget/quota-fit/$host.json" 2>/dev/null || true
  rc=0
  commit_and_push "$DIR" "quota-fit($host) $(printf '%s' "$verdict" | jq -r '.confidence') cap=$(printf '%s' "$verdict" | jq -r '.selected_cap_tokens // "none"')" || rc=$?
  [ "$rc" -eq 0 ] || [ "$rc" -eq 2 ] || echo "WARN: could not persist quota-fit record (rc=$rc); verdict printed above is still valid" >&2
fi
