#!/usr/bin/env bash
# upstream-window.sh <dist.json> <schedule.json>
#
# Reads the Node.js dist index and the nodejs/Release schedule, computes the
# current LTS-window state, and emits a JSON blob describing it.
#
# Output shape:
# {
#   "today": "2026-05-19",
#   "active_lts": 22,
#   "maintenance_lts": [24],
#   "current": 25,
#   "window": [22, 24],
#   "latest_patch": {"20": "v20.18.1", "22": "v22.11.0", "24": "v24.0.3", "25": "v25.0.0"},
#   "lts_start_dates": {"22": "2024-10-29"}
# }

set -euo pipefail

DIST_JSON="$1"
SCHEDULE_JSON="$2"
TODAY="$(date -u +%F)"

jq --arg today "$TODAY" --slurpfile dist "$DIST_JSON" '
  to_entries
  | map(select(.key | startswith("v")))   # majors like "v20", "v22"
  | map({
      major: (.key | ltrimstr("v") | tonumber),
      start: .value.start,
      lts: .value.lts,
      maintenance: .value.maintenance,
      end: .value.end
    })
  | . as $sched
  |
  # active LTS: largest major with lts <= today < maintenance
  (
    [ $sched[]
      | select(.lts != null and .lts <= $today and (.maintenance == null or .maintenance > $today))
    ]
    | sort_by(.major) | last | (.major // null)
  ) as $active_lts
  |
  # maintenance LTS: majors that were LTS (i.e. have an lts start date),
  # are in their maintenance phase (maintenance <= today < end), and are NOT
  # the current active LTS. Odd-numbered majors never receive an `lts`
  # field, so a major with no `lts` date is excluded even if it has a
  # `maintenance` field (which odd majors do have, between the current
  # phase and EOL).
  (
    [ $sched[]
      | select(.lts != null
              and .maintenance != null
              and .maintenance <= $today
              and (.end == null or .end > $today))
    ]
    | map(.major) | sort
  ) as $maint_lts
  |
  # current major: largest with start <= today
  (
    [ $sched[] | select(.start <= $today) ]
    | sort_by(.major) | last | (.major // null)
  ) as $current
  |
  # latest patch per in-window major from dist.json
  (
    ($maint_lts + (if $active_lts then [$active_lts] else [] end) + (if $current then [$current] else [] end))
    | unique
    | map(. as $m
        | { (($m|tostring)): (
            [ $dist[0][] | .version | select(startswith("v\($m).")) ]
            | sort_by(. | sub("^v";"") | split(".") | map(tonumber))
            | last
            // null
          ) }
      )
    | add
  ) as $latest
  |
  {
    today: $today,
    active_lts: $active_lts,
    maintenance_lts: $maint_lts,
    current: $current,
    window: (($maint_lts + (if $active_lts then [$active_lts] else [] end)) | unique | sort),
    latest_patch: $latest,
    lts_start_dates: ([$sched[] | select(.lts != null) | {(.major|tostring): .lts}] | add)
  }
' "$SCHEDULE_JSON"
