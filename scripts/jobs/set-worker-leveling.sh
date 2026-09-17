#!/bin/bash
# set-worker-leveling.sh — replace journal config/worker-leveling atomically.
# Usage: set-worker-leveling.sh <monk-fleet> <cleric-fleet> <host:monk-cap:cleric-cap>...
#
# Every calibrated Anthropic weekly-token pool participates in one fleet-wide monk
# allocation. Its account/host therefore needs a positive monk physical cap in the
# replacement config. Validate that coupling against the freshly synced budget-pool
# config on every push attempt, before staging the replacement. Otherwise one omitted
# host freezes all monk allocation on the next budget-level tick.
set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=common.sh
source "$HERE/common.sh"
export GARDEN_TAG=set-worker-leveling
usage(){ echo "usage: set-worker-leveling.sh <monk-fleet> <cleric-fleet> <host:monk-cap:cleric-cap>..." >&2;exit 2; }
mf="${1:-}";cf="${2:-}";shift "$(( $# >= 2 ? 2 : $# ))"
[[ "$mf" =~ ^[1-9][0-9]*$ ]]&&[[ "$cf" =~ ^[0-9]+$ ]]&&[ "$#" -gt 0 ]||usage
rows=();sum=0
for spec in "$@";do IFS=: read -r host mc cc extra <<<"$spec";[[ "$host" =~ ^[A-Za-z0-9._-]+$ ]]&&[[ "$mc" =~ ^[1-9][0-9]*$ ]]&&[[ "$cc" =~ ^[0-9]+$ ]]&&[ -z "${extra:-}" ]||usage;rows+=("$host"$'\t'"$mc"$'\t'"$cc");sum=$((sum+mc));done
[ "$mf" -ge "$#" ]&&[ "$mf" -le "$sum" ]||{ echo "monk fleet must fit between the one-per-host floor ($#) and physical capacity ($sum)" >&2;exit 2; }
DIR="${GARDEN_PRODUCER_CLONE:-$GARDEN_STATE/producer/journal}";ensure_clone "$DIR"

validate_pool_hosts() { # proposed-worker-leveling budget-pools
 local proposed="$1" pools="$2" pool provider host kind _cap provenance _rest monk_cap
 [ -f "$pools" ] || return 0
 while IFS=$'\t ' read -r pool provider host kind _cap provenance _rest; do
  case "$pool" in ''|'#'*)continue;;esac
  [ "$provider" = anthropic ]&&[ "$kind" = weekly-tokens ]||continue
  pool_provenance_uncalibrated "$provenance"&&continue
  monk_cap="$(awk -v h="$host" '$1=="host"&&$2==h{print $3;exit}' "$proposed")"
  if ! [[ "$monk_cap" =~ ^[1-9][0-9]*$ ]];then
   echo "set-worker-leveling: calibrated pool $pool host '$host' needs a positive monk physical cap in the replacement configuration" >&2
   return 2
  fi
 done <"$pools"
}

for attempt in $(seq 1 8);do
 sync_clone "$DIR";mkdir -p "$DIR/config";f="$DIR/config/worker-leveling";tmp="$(mktemp)"
 { printf '# Fleet envelopes and per-host physical caps. Tab-separated.\n';printf '# kind/value or host/host-id/monk-cap/cleric-cap\n';printf 'monk-fleet-ceiling\t%s\ncleric-fleet-ceiling\t%s\n' "$mf" "$cf";for row in "${rows[@]}";do printf 'host\t%s\n' "$row";done; } >"$tmp"
 vrc=0;validate_pool_hosts "$tmp" "$DIR/config/budget-pools"||vrc=$?
 if [ "$vrc" -eq 2 ];then rm -f "$tmp";exit 2;elif [ "$vrc" -ne 0 ];then rm -f "$tmp";backoff "$attempt";continue;fi
 mv "$tmp" "$f"
 git -C "$DIR" add config/worker-leveling
 rc=0;commit_and_push "$DIR" "worker-leveling monk=$mf cleric=$cf"||rc=$?;if [ "$rc" -eq 0 ]||[ "$rc" -eq 2 ];then exit 0;fi
 backoff "$attempt"
done
die "could not update worker-leveling configuration after retries"
