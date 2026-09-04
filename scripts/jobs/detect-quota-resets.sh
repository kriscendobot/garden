#!/bin/bash
# detect-quota-resets.sh — the deterministic, no-LLM detector for quota RESET events
# over a host's manual quota-checkpoint log (journal budget/manual-checkpoints/<host>.jsonl).
# It MEASURES: given the (checked_at, weekly_percent, weekly_resets_at, meter_spend,
# meter_window_start_epoch) series, it finds brackets where usage necessarily crossed
# zero, interpolates the crossing time, cross-validates against the meter's own anchor
# transitions, and grades each finding. It does NOT actuate — nothing here writes
# config/budget-pools, a worker count, or a quota-backoff hold. Design + rationale:
# designs/reset-time-detection.md. Sibling MEASURE tool: fit-quota-calibration.sh.
#
# WHY the dashboard PERCENT, not the meter spend, is the primary sensor: weekly_percent
# is Anthropic's OWN reading and is independent of the local meter's window_start_epoch,
# which is known to OSCILLATE between two anchors (manual-checkpoints/README.md). Because
# usage-in-window only ever GROWS between resets, any genuine drop in weekly_percent
# (beyond the +-0.5% display-rounding band on each reading) means the window rolled over
# to zero in that bracket — a spend-only trajectory cannot lower the percent. The two
# confounds that also lower the percent WITHOUT a reset, and how the detector separates
# them:
#   * a mid-window CAP INCREASE (the +50% boost through 2026-09-13): the denominator
#     grew, so percent drops PROPORTIONALLY but stays well above zero, weekly_resets_at
#     does NOT advance, and meter spend is unchanged. Classified `cap-change-suspected`,
#     NOT a reset.
#   * the meter ANCHOR OSCILLATION: window_start_epoch flips, so meter_spend swings, but
#     the dashboard percent and weekly_resets_at do not move. An anchor transition with
#     roughly FLAT spend is evidence AGAINST a real reset (grade `refuted`), never for one.
# The definitive reset signal is weekly_resets_at ADVANCING (the window boundary itself
# rolled forward); a drop to near-zero percent is the strong secondary.
#
#   detect-quota-resets.sh <host> [--json-only] [--append] [--notify] [--since ISO]
#
#   --json-only  print only the findings JSON (no human-readable summary to stderr)
#   --append     append any newly CONFIRMED/LIKELY reset finding to the reset-events log
#                via append-reset-event.sh (idempotent by detector_key). Off by default:
#                the detector MEASURES; recording is opt-in.
#   --notify     on a newly detected ANOMALOUS (off-cadence) reset, surface a coalesced
#                maintainer notice via watchdog-notice.sh (key `quota-reset-<host>`). Off
#                by default. Never actuates config/budget-pools; it only informs.
#   --since ISO  ignore checkpoint rows before this time (default: all rows)
set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=common.sh
source "$HERE/common.sh"
export GARDEN_TAG=detect-quota-resets

# Tunables (env-overridable):
#   MARGIN: a weekly_percent drop must exceed this to count as real, not display
#     rounding. Each reading is +-0.5, so a true drop needs > 1.0 to be unambiguous.
#   NEAR_ZERO: a post-reset percent at/under this is "dropped to floor" (reset, not boost).
#   FLAT: |spend change|/max(spend) at/under this across an anchor transition is "flat
#     spend" => the oscillation artifact, evidence AGAINST a reset.
: "${GARDEN_RESET_MARGIN:=1.0}"
: "${GARDEN_RESET_NEAR_ZERO:=8}"
: "${GARDEN_RESET_FLAT:=0.15}"

host="${1:-}"; [ -n "$host" ] || { echo "usage: detect-quota-resets.sh <host> [--json-only] [--append] [--notify] [--since ISO]" >&2; exit 2; }
case "$host" in -*|*/*|'') echo "bad host" >&2; exit 2;; esac
shift
json_only=false; do_append=false; do_notify=false; since=""
while [ "$#" -gt 0 ]; do
  case "$1" in
    --json-only) json_only=true; shift;;
    --append) do_append=true; shift;;
    --notify) do_notify=true; shift;;
    --since) since="${2:?}"; shift 2;;
    *) echo "unknown option: $1" >&2; exit 2;;
  esac
done
command -v jq >/dev/null 2>&1 || { echo "jq unavailable" >&2; exit 1; }

DIR="${GARDEN_PRODUCER_CLONE:-$GARDEN_STATE/producer/journal}"
ensure_clone "$DIR"
sync_clone "$DIR"

cp_file="$DIR/budget/manual-checkpoints/$host.jsonl"
[ -r "$cp_file" ] || { echo "no checkpoint log for host $host ($cp_file)" >&2; exit 1; }

now_iso="$(date -u +%FT%TZ)"
since_epoch=0
[ -z "$since" ] || since_epoch="$(date -u -d "$since" +%s 2>/dev/null || echo 0)"

# The whole detection is one jq pass over the usable, time-sorted checkpoint rows.
# Usable = weekly_percent present and > 0 and a parseable checked_at. Spend/window are
# optional and used only for cross-validation. For each adjacent pair we classify; when
# a following same-anchor pair gives a post-reset token-spend rate we interpolate the
# crossing, else we report the bracket.
findings="$(jq -s \
  --arg host "$host" --arg now "$now_iso" \
  --argjson since "$since_epoch" \
  --argjson margin "$GARDEN_RESET_MARGIN" \
  --argjson near_zero "$GARDEN_RESET_NEAR_ZERO" \
  --argjson flat "$GARDEN_RESET_FLAT" '
  def num($x): ($x // null) | if type=="number" then . else null end;
  def epoch($x): ($x // "" | fromdateiso8601? // null);
  # usable, time-sorted rows carrying a numeric index
  ([ .[]
     | { t: epoch(.checked_at),
         checked_at: .checked_at,
         percent: num(.weekly_percent),
         resets_at: (.weekly_resets_at // null),
         resets_e: epoch(.weekly_resets_at),
         spend: num(.meter_spend_tokens),
         win: num(.meter_window_start_epoch) }
     | select(.t != null and .percent != null and .percent > 0)
     | select(.t >= $since) ]
   | sort_by(.t)) as $rows
  | ($rows | length) as $n
  | [ range(0; if $n>0 then $n-1 else 0 end) as $i
      | $rows[$i] as $a | $rows[$i+1] as $b
      | ($rows[$i+2] // null) as $c
      # --- signals ---
      | (($a.percent) - ($b.percent)) as $pdrop
      | (($b.resets_e != null) and ($a.resets_e != null) and ($b.resets_e > $a.resets_e)) as $resets_advanced
      | (($a.win != null) and ($b.win != null) and ($a.win != $b.win)) as $anchor_moved
      | (if ($a.spend != null and $b.spend != null and ([$a.spend,$b.spend]|max) > 0)
         then (($a.spend - $b.spend)|fabs) / ([$a.spend,$b.spend]|max) else null end) as $spend_delta_frac
      | (($b.percent) <= $near_zero) as $to_floor
      # --- classification ---
      | (if $resets_advanced then
            {event_type:"scheduled-weekly", grade:"confirmed",
             reason:"weekly_resets_at advanced (\($a.resets_at) -> \($b.resets_at)): the weekly window boundary rolled forward, so a reset necessarily occurred in this bracket."}
         elif ($pdrop > $margin and $to_floor) then
            {event_type:"anomalous-midweek", grade:(if $anchor_moved and ($spend_delta_frac != null) and ($spend_delta_frac > $flat) then "confirmed" else "likely" end),
             reason:("weekly_percent dropped \($a.percent)% -> \($b.percent)% (to floor, drop \(($pdrop*10|round)/10) > margin \($margin)) with no weekly_resets_at advance recorded; usage crossed zero in this bracket." + (if $anchor_moved then " Meter anchor also moved (\($a.win) -> \($b.win))" + (if $spend_delta_frac != null then " with spend change \((($spend_delta_frac)*1000|round)/10)% — " + (if $spend_delta_frac > $flat then "a sharp spend drop CORROBORATES the reset." else "roughly flat spend, which does NOT corroborate (see refuted rule)." end) else "." end) else "" end))}
         elif ($pdrop > $margin) then
            {event_type:"unknown", grade:"suspected",
             reason:"weekly_percent dropped \($a.percent)% -> \($b.percent)% but stayed well above the near-zero floor (\($near_zero)%) and weekly_resets_at did not advance — consistent with a mid-window CAP INCREASE (the +50% boost), not a reset. Recorded as cap-change-suspected, NOT a reset.", classification:"cap-change-suspected"}
         elif $anchor_moved then
            # We only reach here when the dashboard percent did NOT drop past the
            # margin. An anchor move with no percent drop is local-meter noise (the
            # window_start_epoch oscillation), never a reset — the dashboard is the
            # ground truth and it did not move. This catches BOTH shapes: a backward
            # reversion (spend roughly flat) AND a forward jump (spend collapses
            # because the summed window shortened), both hand-recorded as `unknown`.
            {event_type:"unknown", grade:"refuted", classification:"anchor-artifact",
             reason:("meter window_start_epoch moved (\($a.win) -> \($b.win)) but weekly_percent did NOT drop (\($a.percent)% -> \($b.percent)%)" + (if $spend_delta_frac != null then ", with spend change \((($spend_delta_frac)*1000|round)/10)% (" + (if $spend_delta_frac <= $flat then "roughly flat — a backward reversion" else "a sharp swing — a forward anchor jump shortening the window" end) + ")" else "" end) + " — this is the meter anchor-oscillation ARTIFACT, evidence AGAINST a real reset, not for one.")}
         else null end) as $cls
      | select($cls != null)
      # --- interpolation of the crossing time within the bracket ---
      # Prefer the meter token-spend rate from the FOLLOWING same-anchor pair (b,c):
      # rate = (c.spend-b.spend)/(c.t-b.t); crossing = b.t - b.spend/rate. Assumes a
      # constant burn rate across the reset boundary. Falls back to the dashboard
      # percent rate (anchor-independent), then to the bracket midpoint.
      | (if ($cls.grade == "confirmed" or $cls.grade == "likely") then
           (if ($c != null and $b.spend != null and $c.spend != null and $b.win != null and $c.win != null
                 and $b.win == $c.win and ($c.t > $b.t) and ($c.spend > $b.spend))
            then ((($c.spend - $b.spend) / ($c.t - $b.t)) as $rate
                  | ($b.t - ($b.spend / $rate)))
            elif ($c != null and ($c.t > $b.t) and ($c.percent > $b.percent))
            then ((($c.percent - $b.percent) / ($c.t - $b.t)) as $prate
                  | ($b.t - ($b.percent / $prate)))
            else null end) as $cross
           | { interp_epoch: $cross,
               interp_method: (if $cross == null then "none (bracket only; no post-reset rate available)"
                               elif ($c != null and $b.win != null and $c.win != null and $b.win == $c.win and $c.spend > $b.spend) then "meter-token-rate (constant-burn assumption over the following same-anchor segment)"
                               else "dashboard-percent-rate (constant-burn assumption; anchor-independent fallback)" end) }
         else { interp_epoch:null, interp_method:"n/a (not a confirmed/likely reset)" } end) as $ip
      | {
          bracket_lower: $a.checked_at,
          bracket_upper: $b.checked_at,
          event_type: $cls.event_type,
          grade: $cls.grade,
          classification: ($cls.classification // "reset"),
          weekly_percent_before: $a.percent,
          weekly_percent_after: $b.percent,
          reset_at: (if $ip.interp_epoch != null and ($ip.interp_epoch >= $a.t) and ($ip.interp_epoch <= $b.t)
                     then ($ip.interp_epoch | todateiso8601)
                     elif ($cls.grade == "confirmed" or $cls.grade == "likely")
                     then ((($a.t + $b.t)/2) | floor | todateiso8601)
                     else null end),
          reset_at_precision: (if $ip.interp_epoch != null and ($ip.interp_epoch >= $a.t) and ($ip.interp_epoch <= $b.t) then "extrapolated"
                               elif ($cls.grade == "confirmed" or $cls.grade == "likely") then "bracketed"
                               else "bracketed" end),
          interp_method: $ip.interp_method,
          detector_key: ("\($host)|\($a.checked_at)|\($b.checked_at)|\($cls.event_type)"),
          reason: $cls.reason
        }
    ] as $events
  | { host:$host, generated_at:$now, n_checkpoints:$n,
      params:{margin:$margin, near_zero:$near_zero, flat:$flat},
      events:$events,
      summary:{
        confirmed:  ([$events[]|select(.grade=="confirmed")]|length),
        likely:     ([$events[]|select(.grade=="likely")]|length),
        suspected:  ([$events[]|select(.grade=="suspected")]|length),
        refuted:    ([$events[]|select(.grade=="refuted")]|length)
      } }
' "$cp_file")" || { echo "detect failed" >&2; exit 1; }

printf '%s\n' "$findings"

if [ "$json_only" = false ]; then
  s_conf="$(printf '%s' "$findings" | jq -r '.summary.confirmed')"
  s_like="$(printf '%s' "$findings" | jq -r '.summary.likely')"
  s_susp="$(printf '%s' "$findings" | jq -r '.summary.suspected')"
  s_ref="$(printf '%s' "$findings" | jq -r '.summary.refuted')"
  echo "DETECT [$host]: confirmed=$s_conf likely=$s_like cap-change-suspected=$s_susp anchor-artifact-refuted=$s_ref (over $(printf '%s' "$findings" | jq -r '.n_checkpoints') checkpoints)" >&2
  printf '%s' "$findings" | jq -r '.events[] | "  [\(.grade)] \(.event_type) \(.bracket_lower)..\(.bracket_upper) reset_at=\(.reset_at // "n/a") (\(.reset_at_precision))"' >&2 || true
fi

# --append: record newly CONFIRMED/LIKELY reset findings (never suspected/refuted, and
# never cap-change/artifact) to the reset-events log, idempotent by detector_key.
if [ "$do_append" = true ]; then
  printf '%s' "$findings" | jq -c '.events[] | select(.grade=="confirmed" or .grade=="likely") | select(.classification=="reset")' | while IFS= read -r ev; do
    [ -n "$ev" ] || continue
    etype="$(printf '%s' "$ev" | jq -r '.event_type')"
    blo="$(printf '%s' "$ev" | jq -r '.bracket_lower')"
    bup="$(printf '%s' "$ev" | jq -r '.bracket_upper')"
    rat="$(printf '%s' "$ev" | jq -r '.reset_at // ""')"
    prec="$(printf '%s' "$ev" | jq -r '.reset_at_precision')"
    grd="$(printf '%s' "$ev" | jq -r '.grade')"
    dkey="$(printf '%s' "$ev" | jq -r '.detector_key')"
    reason="$(printf '%s' "$ev" | jq -r '.reason')"
    method="$(printf '%s' "$ev" | jq -r '.interp_method')"
    "$HERE/append-reset-event.sh" "$host" --type "$etype" --precision "$prec" \
      ${rat:+--at "$rat"} --bracket-lower "$blo" --bracket-upper "$bup" \
      --grade "$grd" --dedup-key "$dkey" \
      --evidence "detect-quota-resets.sh over budget/manual-checkpoints/$host.jsonl: $reason" \
      --note "interpolation: $method" \
      || echo "WARN: append-reset-event failed for $dkey" >&2
  done
fi

# --notify: coalesced maintainer notice for any newly detected ANOMALOUS (off-cadence)
# reset. Never touches config/budget-pools; it only informs, the way watchdog-notice.sh
# coalesces one condition into one entry.
if [ "$do_notify" = true ]; then
  anom="$(printf '%s' "$findings" | jq -c '[.events[] | select(.event_type=="anomalous-midweek") | select(.grade=="confirmed" or .grade=="likely")]')"
  n_anom="$(printf '%s' "$anom" | jq 'length')"
  if [ "${n_anom:-0}" -gt 0 ]; then
    body="$(mktemp "${TMPDIR:-/tmp}/reset-notice.XXXXXX")"
    {
      echo "An ANOMALOUS (off the scheduled Friday-8pm-Pacific cadence) quota reset was detected for host \`$host\`."
      echo
      echo "Detector: \`detect-quota-resets.sh $host\` over the manual quota-checkpoint log."
      echo "This is a NOTICE, not an action — no cap, worker count, or quota-backoff hold was changed."
      echo "If confirmed genuine, a fresh calibration checkpoint and clearing any stale weekly quota-backoff hold are safe to do sooner than the next scheduled Friday. See designs/reset-time-detection.md."
      echo
      printf '%s' "$anom" | jq -r '.[] | "- \(.grade): \(.bracket_lower)..\(.bracket_upper), reset_at≈\(.reset_at // "unknown") (\(.reset_at_precision)); \(.reason)"'
    } > "$body"
    "$HERE/watchdog-notice.sh" --count "$n_anom" "quota-reset-$host" "$body" \
      || echo "WARN: watchdog-notice failed for quota-reset-$host" >&2
    rm -f "$body"
  fi
fi
