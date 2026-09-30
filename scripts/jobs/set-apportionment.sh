#!/bin/bash
# set-apportionment.sh — apply the week's arc apportionment in ONE journal CAS
# commit (designs/accountant-arc-apportionment.md § The arc).
#
# Writes, together, so the three never disagree:
#   config/apportionment        the week as a whole (total, ordered slate,
#                               authorized_by, source message id)
#   config/arc-budgets/<arc>    one schema-2 fixed-week slice per slate arc, plus
#                               the `unallocated` reserve (the remainder); schema-2
#                               arcs dropped from the slate become status=retired
#   config/foreman-mandate      regenerated prose of the slate, in rank order
# The accountant is the sole caller. Schema-1 rolling arcs not named in the slate
# are left alone; a named one becomes a weekly slice and keeps its
# press_interval_seconds.
#
# Usage:
#   set-apportionment.sh --authorized-by LOGIN [--message-id ID] [--week-start ISO]
#                        [--dry-run] <slate.json>
#   set-apportionment.sh --carry-forward [--week-start ISO] [--dry-run]
#
# slate.json (arc order is rank order; amounts are integers, 15M / 800K / 1.5G,
# or N% of total_tokens; the remainder funds the reserve; over-subscription is
# refused):
#   {"total_tokens":"120M", "planning_ceiling":0.9, "notes":"optional preamble",
#    "arcs":[{"arc":"minion-town-capabilities","tokens":"50%",
#             "summary":"Run Claude remotely","tracker":"https://…"}]}
#
# --carry-forward rolls the recorded slate to the current subscription week
# (Fri reset anchor) unchanged, keeping its authorization; a no-op when the
# recorded week is already current, and when no apportionment exists yet.
# --week-start overrides the anchor (ISO-8601 UTC). --dry-run prints the
# materialized apportionment and mandate without pushing.
set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$HERE/common.sh"
export GARDEN_TAG="set-apportionment"

authorized_by=""; message_id=""; week_start=""; dry_run=0; carry=0; slate_src=""
while [ $# -gt 0 ]; do
  case "$1" in
    --authorized-by) authorized_by="${2:?--authorized-by needs a login}"; shift 2 ;;
    --message-id) message_id="${2:?--message-id needs a value}"; shift 2 ;;
    --week-start) week_start="${2:?--week-start needs an ISO timestamp}"; shift 2 ;;
    --carry-forward) carry=1; shift ;;
    --dry-run) dry_run=1; shift ;;
    -h|--help) sed -n '2,33p' "$0"; exit 0 ;;
    -*) die "unknown option: '$1'" ;;
    *) [ -z "$slate_src" ] || die "exactly one slate file"; slate_src="$1"; shift ;;
  esac
done
command -v jq >/dev/null 2>&1 || die "set-apportionment.sh needs jq"
if [ "$carry" -eq 1 ]; then
  [ -z "$slate_src$authorized_by$message_id" ] \
    || die "--carry-forward takes no slate, --authorized-by, or --message-id"
else
  [ -n "$slate_src" ] && [ -f "$slate_src" ] || die "a readable slate.json is required"
  [ -n "$authorized_by" ] || die "--authorized-by LOGIN (a maintainers/allowlist login) is required"
  jq -e . "$slate_src" >/dev/null 2>&1 || die "slate '$slate_src' is not valid JSON"
fi

if [ -n "$week_start" ]; then
  ws_epoch="$(date -u -d "$week_start" +%s 2>/dev/null)" || die "--week-start is not a parseable timestamp"
else
  ws_epoch="$(meter_week_anchor_epoch "$(date -u +%s)")" || die "cannot resolve this week's reset anchor"
fi
ws_iso="$(date -u -d "@$ws_epoch" +%FT%TZ)"
by="${GARDEN_SENDER:-${GARDEN_JOB_BASE:-accountant}}"

# normalize <slate-json> — validate and resolve amounts into a normalized slate.
# shellcheck disable=SC2016
NORMALIZE='
  def amount($total):
    if type == "number" then
      (if floor == . and . >= 0 then . else error("amount \(.) is not a non-negative integer") end)
    elif type == "string" then
      ((capture("^(?<n>[0-9]+([.][0-9]+)?)(?<u>[KkMmGg%]?)$")) // error("unparseable amount \"\(.)\"")) as $m
      | ($m.n | tonumber) as $n
      | ($m.u | ascii_downcase) as $u
      | if $u == "%" then
          (if $total == null then error("a percentage needs total_tokens") else ($total * $n / 100 | floor) end)
        elif $u == "k" then ($n * 1000 | floor)
        elif $u == "m" then ($n * 1000000 | floor)
        elif $u == "g" then ($n * 1000000000 | floor)
        else ($n | floor) end
    else error("amount must be a number or string") end;
  (.total_tokens | amount(null)) as $total
  | if $total <= 0 then error("total_tokens must be positive") else . end
  | (.planning_ceiling // 0.9) as $ceiling
  | if ($ceiling | type) != "number" or $ceiling <= 0 or $ceiling > 1
    then error("planning_ceiling must be in (0, 1]") else . end
  | (.arcs // []) as $arcs
  | if ($arcs | type) != "array" then error("arcs must be an array") else . end
  | [ $arcs | to_entries[] | .value as $a
      | if ($a.arc | type) != "string" or ($a.arc | test("^[a-z0-9][a-z0-9-]*$") | not)
        then error("illegal arc name \($a.arc)") else . end
      | if $a.arc == "unallocated" then error("unallocated is the remainder; do not list it") else . end
      | {rank: (.key + 1), arc: $a.arc, summary: ($a.summary // ""),
         token_cap: ($a.tokens | amount($total))}
        + (if ($a.tracker // "") != "" then {tracker: $a.tracker} else {} end) ] as $slate
  | if ($slate | map(.arc) | unique | length) != ($slate | length)
    then error("an arc appears twice in the slate") else . end
  | ($slate | map(.token_cap) | add // 0) as $sum
  | if $sum > $total
    then error("over-subscribed: slices sum to \($sum) of a \($total) total (\($sum - $total) over)")
    else . end
  | {total_tokens: $total, planning_ceiling: $ceiling, slate: $slate,
     unallocated_tokens: ($total - $sum), notes: (.notes // "")}
'
HUMAN='def human: if . >= 1000000000 and (. % 100000000) == 0 then "\(. / 1000000000)G"
  elif . >= 1000000 and (. % 100000) == 0 then "\(. / 1000000)M"
  elif . >= 1000 and (. % 100) == 0 then "\(. / 1000)K" else tostring end;'

# materialize <root> <normalized-json> <authorized_by> <message_id> [carried_from]
materialize() {
  local root="$1" norm="$2" auth="$3" msg="$4" carried="${5:-}" at f arc
  at="$(date -u +%FT%TZ)"
  mkdir -p "$root/config/arc-budgets"
  jq -n --argjson n "$norm" --arg ws "$ws_iso" --arg auth "$auth" --arg msg "$msg" \
    --arg by "$by" --arg at "$at" --arg carried "$carried" '
    {schema:1, week_start:$ws} + $n
    + {authorized_by:$auth, message_id:$msg, set_by:$by, set_at:$at}
    + (if $carried != "" then {carried_forward_from:$carried} else {} end)
  ' > "$root/config/apportionment"
  # One slice per slate arc, plus the reserve ranked last.
  while IFS= read -r entry; do
    arc="$(jq -r '.arc' <<<"$entry")"
    f="$root/config/arc-budgets/$arc"
    local prior='{}'
    [ -f "$f" ] && prior="$(jq -c 'if type == "object" then . else {} end' "$f" 2>/dev/null || echo '{}')"
    jq -n --argjson e "$entry" --argjson prior "$prior" --arg ws "$ws_iso" \
      --arg by "$by" --arg at "$at" '
      {schema:2, status:"active", arc:$e.arc, rank:$e.rank, summary:$e.summary,
       token_cap:$e.token_cap, window:"week", window_start:$ws}
      + (if $e.tracker then {tracker:$e.tracker} else {} end)
      + (if $prior.press_interval_seconds then {press_interval_seconds:$prior.press_interval_seconds} else {} end)
      + {set_by:$by, set_at:$at}
    ' > "$f"
  done < <(jq -c --argjson n "$norm" -n '
    $n.slate[],
    {rank:(($n.slate | length) + 1), arc:"unallocated",
     summary:"reserve: foreman-drawn work outside the slate", token_cap:$n.unallocated_tokens}')
  # Retire schema-2 slices that fell off the slate.
  for f in "$root"/config/arc-budgets/*; do
    [ -f "$f" ] || continue
    arc="$(basename "$f")"
    [ "$arc" = unallocated ] && continue
    jq -e --arg a "$arc" '.slate | any(.arc == $a)' "$root/config/apportionment" >/dev/null && continue
    jq -e '.schema == 2 and .status == "active"' "$f" >/dev/null 2>&1 || continue
    jq --arg by "$by" --arg at "$at" '.status = "retired" | .retired_by = $by | .retired_at = $at' \
      "$f" > "$f.tmp" && mv "$f.tmp" "$f"
  done
  jq -nr --argjson n "$norm" --arg ws "$ws_iso" "$HUMAN"'
    "# Generated by set-apportionment.sh from config/apportionment; do not hand-edit.",
    "# Re-slice through the accountant (say \"apportion\" to the liaison).",
    "",
    "Week of \($ws): \($n.total_tokens | human) tokens for foreman-drawn work, apportioned",
    "across \($n.slate | length) arc(s). Draw from the highest-ranked arc with headroom.",
    "",
    (if $n.notes != "" then ($n.notes, "") else empty end),
    ($n.slate[] | "\(.rank). \(.arc): \(.summary) (\(.token_cap | human) tokens)"
       + (if .tracker then " \(.tracker)" else "" end)),
    "",
    "Reserve: unallocated, \($n.unallocated_tokens | human) tokens for work outside these arcs."
  ' > "$root/config/foreman-mandate"
}

authorized() {  # authorized <dir> <login>
  [ -f "$1/maintainers/allowlist" ] \
    && sed 's/#.*//; s/[[:space:]]//g' "$1/maintainers/allowlist" | grep -qxF "$2"
}

DIR="${GARDEN_PRODUCER_CLONE:-$GARDEN_STATE/producer/journal}"
ensure_clone "$DIR"
for attempt in $(seq 1 "${GARDEN_POST_ATTEMPTS:-50}"); do
  sync_clone "$DIR"
  carried=""
  if [ "$carry" -eq 1 ]; then
    rec="$DIR/config/apportionment"
    if [ ! -f "$rec" ]; then log "no apportionment on the journal; nothing to carry forward"; exit 0; fi
    old_ws="$(jq -r '.week_start // empty' "$rec")"
    old_epoch="$(date -u -d "$old_ws" +%s 2>/dev/null || echo 0)"
    if [ "$old_epoch" -ge "$ws_epoch" ]; then
      log "apportionment already covers the week of $old_ws; nothing to carry forward"
      exit 0
    fi
    norm="$(jq -c '{total_tokens, planning_ceiling:(.planning_ceiling // 0.9), slate,
      unallocated_tokens, notes:(.notes // "")}' "$rec")" || die "config/apportionment is unreadable"
    auth="$(jq -r '.authorized_by // ""' "$rec")"
    msg="$(jq -r '.message_id // ""' "$rec")"
    carried="$old_ws"
  else
    authorized "$DIR" "$authorized_by" || die "'$authorized_by' is not on maintainers/allowlist; refusing"
    norm="$(jq -c "$NORMALIZE" "$slate_src" 2>&1)" || die "slate rejected: ${norm#jq: error (at <unknown>): }"
    auth="$authorized_by"; msg="$message_id"
  fi
  if [ "$dry_run" -eq 1 ]; then
    tmp="$(mktemp -d "${TMPDIR:-/tmp}/apportion-dry.XXXXXX")"
    trap 'rm -rf "$tmp"' EXIT
    mkdir -p "$tmp/config"
    [ -d "$DIR/config/arc-budgets" ] && cp -r "$DIR/config/arc-budgets" "$tmp/config/"
    materialize "$tmp" "$norm" "$auth" "$msg" "$carried"
    jq . "$tmp/config/apportionment"
    echo; cat "$tmp/config/foreman-mandate"
    exit 0
  fi
  materialize "$DIR" "$norm" "$auth" "$msg" "$carried"
  git -C "$DIR" add -A config/apportionment config/arc-budgets config/foreman-mandate
  summary="$(jq -r '[.slate[] | "\(.arc)=\(.token_cap)"] + ["unallocated=\(.unallocated_tokens)"] | join(" ")' \
    "$DIR/config/apportionment")"
  rc=0; commit_and_push "$DIR" "apportion(week $ws_iso)${carried:+ carried forward} total=$(jq -r .total_tokens "$DIR/config/apportionment") $summary" || rc=$?
  [ "$rc" -eq 0 ] && { log "applied apportionment for the week of $ws_iso: $summary"; exit 0; }
  [ "$rc" -eq 2 ] && { log "apportionment unchanged"; exit 0; }
  backoff "$attempt"
done
die "could not apply the apportionment"
