#!/bin/bash
# accountant-statement.sh — the deterministic numbers behind the accountant's
# weekly statement (designs/accountant-arc-apportionment.md § The weekly
# engagement, step 2). No LLM: every figure comes from the journal's config,
# immutable usage ledgers, the plan board, and the maintainer inbox. The
# accountant adds the proposed slate and its reasons; it never estimates spend
# by hand.
#
# Usage: accountant-statement.sh [--dir SYNCED-JOURNAL] [--now-epoch EPOCH]
# Prints markdown on stdout.
set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$HERE/common.sh"
export GARDEN_TAG="accountant-statement"

dir=""; now="$(date -u +%s)"
while [ $# -gt 0 ]; do
  case "$1" in
    --dir) dir="${2:?--dir needs a journal directory}"; shift 2 ;;
    --now-epoch) now="${2:?--now-epoch needs an epoch}"; shift 2 ;;
    -h|--help) sed -n '2,10p' "$0"; exit 0 ;;
    *) die "unknown argument: '$1'" ;;
  esac
done
case "$now" in ''|*[!0-9]*) die "invalid now epoch: '$now'" ;; esac
command -v jq >/dev/null 2>&1 || die "accountant-statement.sh needs jq"
if [ -z "$dir" ]; then
  dir="${GARDEN_ACCOUNTANT_CLONE:-$GARDEN_STATE/accountant/journal}"
  ensure_clone "$dir"
  sync_clone "$dir"
fi

rec="$dir/config/apportionment"
now_iso="$(date -u -d "@$now" +%FT%TZ)"
week_start=""; week_epoch=""
if [ -f "$rec" ]; then
  week_start="$(jq -r '.week_start // empty' "$rec")"
fi
# The statement covers the current fixed week: the recorded week_start rolled
# forward in whole weeks, exactly as arc-spend.sh sums it.
if [ -n "$week_start" ] && week_epoch="$(date -u -d "$week_start" +%s 2>/dev/null)"; then
  while [ $(( week_epoch + 604800 )) -le "$now" ]; do week_epoch=$(( week_epoch + 604800 )); done
  while [ "$week_epoch" -gt "$now" ]; do week_epoch=$(( week_epoch - 604800 )); done
else
  week_epoch="$(meter_week_anchor_epoch "$now" "$dir" 2>/dev/null || echo $(( now - 604800 )))"
fi
week_iso="$(date -u -d "@$week_epoch" +%FT%TZ)"
human() { jq -rn --argjson v "${1:-0}" 'def h: if . >= 1000000 then "\((. / 100000 | floor) / 10)M"
  elif . >= 1000 then "\((. / 100 | floor) / 10)K" else tostring end; $v | h'; }

printf '# Accountant statement: week of %s\n\n' "$week_iso"
printf 'As of %s.\n\n' "$now_iso"
if [ -f "$rec" ]; then
  jq -r '"Total for foreman-drawn work: \(.total_tokens) tokens (planning ceiling \((.planning_ceiling // 0.9) * 100 | floor)%). Authorized by \(.authorized_by // "?")\(if (.message_id // "") != "" then " (message \(.message_id))" else "" end); set by \(.set_by // "?") at \(.set_at // "?")\(if .carried_forward_from then ", carried forward from the week of \(.carried_forward_from)" else "" end)."' "$rec"
  [ "$(jq -r '.week_start' "$rec")" = "$week_iso" ] \
    || printf '\n**The recorded slate is for the week of %s; it has not been carried forward.**\n' "$(jq -r '.week_start' "$rec")"
else
  printf 'No apportionment is recorded yet (config/apportionment is absent). Foreman-drawn work is unbudgeted.\n'
fi

# Held plans per arc, from the same admission the foreman applies.
skipped="$(GARDEN_PLAN_NOW="$now" plan_deferred_skipped "$dir" 2>/dev/null || true)"
held_for() {  # held_for <arc> — count deferred plans parked on that arc's budget
  awk -F'\t' -v a="$1" '{ split($2, r, ":"); if (r[2] == a && r[1] ~ /^arc-/) n++ } END { print n + 0 }' <<<"$skipped"
}

printf '\n## Arcs\n\n'
headroom="$(arc_headroom_lines "$dir" "$now" 2>/dev/null || true)"
if [ -z "$headroom" ]; then
  printf 'No active weekly arc slices.\n'
else
  printf '| rank | arc | slice | spend | %% | remaining | held plans | completions | overshoot |\n'
  printf '| ---: | --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: |\n'
  while IFS=$'\t' read -r rank arc cap spend remaining status _summary; do
    comp="-"; pct="-"; over="-"
    if [ "$status" != untrusted ]; then
      snap="$("$HERE/arc-spend.sh" --dir "$dir" --now-epoch "$now" "$arc" 2>/dev/null || echo '{}')"
      comp="$(jq -r '.completions // 0' <<<"$snap")"
      [ "$cap" -gt 0 ] && pct="$(( spend * 100 / cap ))%"
      [ "$spend" -gt "$cap" ] && over="$(human $(( spend - cap )))"
      spend="$(human "$spend")"
    else
      spend="untrusted ledger"
    fi
    printf '| %s | %s | %s | %s | %s | %s | %s | %s | %s |\n' "$rank" "$arc" "$(human "$cap")" \
      "$spend" "$pct" "$(human "$remaining")" "$(held_for "$arc")" "$comp" "$over"
  done <<<"$headroom"
fi
# Arcs outside the weekly pie: rolling schema-1 arcs, and slices retired from
# the slate whose plans stay parked.
others=""
for f in "$dir"/config/arc-budgets/*; do
  [ -f "$f" ] || continue
  arc="$(basename "$f")"
  line="$(jq -r 'if .schema == 1 then "rolling (schema 1, \(.window_seconds)s window, cap \(.token_cap))"
    elif .status == "retired" then "retired from the slate" else empty end' "$f" 2>/dev/null || true)"
  [ -n "$line" ] && others+="- $arc: $line; held plans $(held_for "$arc")"$'\n'
done
if [ -n "$others" ]; then printf '\nOutside the weekly pie:\n\n%s' "$others"; fi

printf '\n## Pools\n\n'
pool_file="$(budget_pool_file "$dir" 2>/dev/null || true)"
if [ -z "$pool_file" ] || [ ! -f "$pool_file" ]; then
  printf 'No bounded pools are configured.\n'
else
  printf '| pool | status | used %% |\n| --- | --- | ---: |\n'
  while IFS=$'\t ' read -r pool _rest; do
    case "$pool" in ''|'#'*) continue ;; esac
    printf '| %s | %s | %s |\n' "$pool" "$(meter_quota_status "$pool" "$dir" 2>/dev/null || echo unknown)" \
      "$(subscription_used_percent "$pool" "$dir" 2>/dev/null || echo '?')"
  done < "$pool_file"
  reset="$(meter_next_reset_epoch "$now" "$dir" 2>/dev/null || true)"
  [[ "$reset" =~ ^[0-9]+$ ]] && printf '\nNext subscription reset: %s (%sh away).\n' \
    "$(date -u -d "@$reset" +%FT%TZ)" "$(( (reset - now) / 3600 ))"
fi

printf '\n## Foreman decisions since the week began (this host)\n\n'
decisions="${GARDEN_STATE}/foreman/decisions.log"
if [ -f "$decisions" ]; then
  counts="$(awk -v since="$week_iso" '$1 >= since { for (i = 2; i <= NF; i++) if ($i ~ /^guard=/) { sub(/^guard=/, "", $i); n[$i]++ } }
    END { for (g in n) printf "- %s: %d\n", g, n[g] }' "$decisions" | sort)"
  printf '%s\n' "${counts:-No decisions logged this week.}"
else
  printf 'No foreman decision log on this host (the foreman runs on the leader).\n'
fi

printf '\n## Budget watchdog notices this week\n\n'
notices=""
for f in "$dir"/inbox/maintainer/unread/*.md "$dir"/inbox/maintainer/read/*.md; do
  [ -f "$f" ] || continue
  from="$(plan_field "$f" from)"
  case "$from" in *budget*|*quota*) ;; *) continue ;; esac
  sent="$(plan_field "$f" last_seen)"; [ -n "$sent" ] || sent="$(plan_field "$f" sent_at)"
  [[ "$sent" > "$week_iso" || "$sent" = "$week_iso" ]] || continue
  notices+="- $sent $from: $(awk 'f && NF { print; exit } /^---$/ { c++; if (c == 2) f = 1 }' "$f" | cut -c1-160)"$'\n'
done
if [ -n "$notices" ]; then printf '%s' "$(sort <<<"$notices")"; printf '\n'; else printf 'None.\n'; fi

printf '\n## Held plans\n\n'
held="$(awk -F'\t' '$2 ~ /^arc-/ { printf "- %s: %s\n", $1, $2 }' <<<"$skipped")"
printf '%s\n' "${held:-No deferred plan is held on an arc budget.}"
