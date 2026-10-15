#!/bin/bash
# retire-subscription.sh — remove a dead subscription (and optionally the hosts that
# billed to it) from the live budget registries in ONE atomic journal commit, and
# tombstone it so no setter re-adds it. The inverse of set-budget-pool.sh.
#
#   retire-subscription.sh <subscription_id> --authorized-by LOGIN --reason TEXT
#                          [--message-id ID] [--retire-host HOST]... [--dry-run]
#
# What one commit does:
#   config/budget-pools          drop the subscription's row
#   config/subscription-mapping  drop its rows, and every row of a retired host
#                                (a shared pool such as codex-endolin keeps its pool
#                                row and its living hosts' rows)
#   config/worker-leveling       drop each retired host's `host` physical-cap row
#   worker-derotate/<host>       drop the derotation ownership marker
#   hosts/<host>                 archive to hosts/.archived-<host> (the rolling-deploy
#                                convention: dot-prefixed records leave the follower
#                                set and are never unarchived automatically)
#   budget/live/<subscription>/  drop the pool's live snapshots, and every retired
#                                host's snapshot under any pool (a stale peer file
#                                otherwise poisons a shared pool's remote total)
#   config/retired-budget-sources  append a tombstone row per subscription and host;
#                                set-budget-pool.sh and set-worker-leveling.sh refuse
#                                a tombstoned id
# History stays: decisions, reset events, manual checkpoints, quota fits, usage
# ledgers, fleet/{health,deployed}, and subscriptions/<host>.md are records, not config.
#
# Fail-closed guards, checked on the synced tree before staging: the result must map
# no host to a missing pool (claim-job refuses an unknown pool), no living host may
# lose its last mapping, no surviving pool may lose its last mapped host, and the
# worker-leveling envelope must still fit (one-per-host floor <= monk ceiling <=
# physical capacity). A violation exits 2 and writes nothing.
set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=common.sh
source "$HERE/common.sh"
export GARDEN_TAG=retire-subscription

usage() { sed -n '5,6p' "$0" >&2; exit 2; }
sub="${1:-}"; [ -n "$sub" ] && [[ "$sub" != -* ]] || usage; shift
authorized_by=""; message_id=""; reason=""; dry_run=0; hosts=()
while [ $# -gt 0 ]; do
  case "$1" in
    --authorized-by) authorized_by="${2:?}"; shift 2 ;;
    --message-id) message_id="${2:?}"; shift 2 ;;
    --reason) reason="${2:?}"; shift 2 ;;
    --retire-host) hosts+=("${2:?}"); shift 2 ;;
    --dry-run) dry_run=1; shift ;;
    *) usage ;;
  esac
done
[[ "$sub" =~ ^[A-Za-z0-9._-]+$ ]] || die "invalid subscription id '$sub'"
for h in "${hosts[@]}"; do [[ "$h" =~ ^[A-Za-z0-9._-]+$ ]] && [[ "$h" != .* ]] || die "invalid host '$h'"; done
[ -n "$authorized_by" ] || die "--authorized-by LOGIN (a maintainers/allowlist login) is required"
[ -n "$reason" ] || die "--reason TEXT is required"
reason="${reason//$'\t'/ }"; reason="${reason//$'\n'/ }"

DIR="${GARDEN_PRODUCER_CLONE:-$GARDEN_STATE/producer/journal}"
ensure_clone "$DIR"

authorized() {
  [ -f "$1/maintainers/allowlist" ] \
    && sed 's/#.*//; s/[[:space:]]//g' "$1/maintainers/allowlist" | grep -qxF "$2"
}
is_retired_host() { local h; for h in "${hosts[@]}"; do [ "$h" = "$1" ] && return 0; done; return 1; }
rows() { [ -f "$1" ] && awk '!/^[[:space:]]*(#|$)/' "$1" || true; }

# _plan <dir> — validate and apply the retirement to the working tree, staging every
# change. Returns 0 staged, 3 hard reject (nothing written that matters: the caller
# never commits), 1 transient.
_plan() {
  local dir="$1" pools="$1/config/budget-pools" map="$1/config/subscription-mapping"
  local lv="$1/config/worker-leveling" tomb="$1/config/retired-budget-sources"
  authorized "$dir" "$authorized_by" || { echo "retire-subscription: '$authorized_by' is not on maintainers/allowlist; refusing" >&2; return 3; }
  awk -v p="$sub" '!/^[[:space:]]*#/ && $1==p {f=1} END{exit !f}' "$pools" 2>/dev/null \
    || { echo "retire-subscription: '$sub' has no row in config/budget-pools (already retired?)" >&2; return 3; }

  local hl; hl="$(printf '%s\n' "${hosts[@]}")"
  local new_pools new_map
  new_pools="$(mktemp)"; new_map="$(mktemp)"
  awk -v p="$sub" '/^[[:space:]]*#/ || $1!=p' "$pools" > "$new_pools"
  if [ -f "$map" ]; then
    awk -v p="$sub" -v hl="$hl" 'BEGIN{n=split(hl,a,"\n"); for(i=1;i<=n;i++) if(a[i]!="") r[a[i]]=1}
      /^[[:space:]]*(#|$)/ {print; next} $1==p || ($2 in r) {next} {print}' "$map" > "$new_map"
  fi

  # Guards. Every surviving mapping names a surviving pool; every living host that was
  # mapped stays mapped; every surviving pool that had a mapped host keeps one.
  local bad=""
  if [ -f "$map" ]; then
    bad="$(awk 'NR==FNR { if (!/^[[:space:]]*(#|$)/) pool[$1]=1; next }
      !/^[[:space:]]*(#|$)/ && !($1 in pool) { print "host " $2 " (" $3 ") maps to missing pool " $1 }' "$new_pools" "$new_map")"
    local h before after
    while read -r h; do
      is_retired_host "$h" && continue
      after="$(awk -v h="$h" '!/^[[:space:]]*(#|$)/ && $2==h' "$new_map" | wc -l)"
      [ "$after" -gt 0 ] || bad+="living host $h would lose its last subscription mapping"$'\n'
    done < <(rows "$map" | awk '{print $2}' | sort -u)
    local p
    while read -r p; do
      [ "$p" = "$sub" ] && continue
      before="$(rows "$map" | awk -v p="$p" '$1==p' | wc -l)"
      after="$(awk -v p="$p" '!/^[[:space:]]*(#|$)/ && $1==p' "$new_map" | wc -l)"
      [ "$before" -eq 0 ] || [ "$after" -gt 0 ] || bad+="pool $p would lose its last mapped host; retire the pool instead"$'\n'
    done < <(rows "$new_pools" | awk '{print $1}')
  fi
  local new_lv=""
  if [ -f "$lv" ]; then
    new_lv="$(mktemp)"
    awk -v hl="$hl" 'BEGIN{n=split(hl,a,"\n"); for(i=1;i<=n;i++) if(a[i]!="") r[a[i]]=1}
      $1=="host" && ($2 in r) {next} {print}' "$lv" > "$new_lv"
    local mf hc ss
    read -r mf hc ss < <(awk '$1=="monk-fleet-ceiling"{mf=$2} $1=="host"{h++; s+=$3} END{print mf+0, h+0, s+0}' "$new_lv")
    if [ "$mf" -gt 0 ]; then
      [ "$ss" -ge "$mf" ] || bad+="worker-leveling physical monk capacity ($ss) would fall below monk-fleet-ceiling ($mf); lower it with set-worker-leveling.sh first"$'\n'
      [ "$mf" -ge "$hc" ] || bad+="monk-fleet-ceiling ($mf) below the one-per-host floor ($hc)"$'\n'
    fi
  fi
  if [ -n "$bad" ]; then
    printf 'retire-subscription: refusing; the result would fail closed:\n%s' "$bad" >&2
    rm -f "$new_pools" "$new_map" "$new_lv"; return 3
  fi

  local now; now="$(date -u +%FT%TZ)"
  mv "$new_pools" "$pools"; git -C "$dir" add config/budget-pools
  if [ -f "$map" ]; then mv "$new_map" "$map"; git -C "$dir" add config/subscription-mapping; else rm -f "$new_map"; fi
  if [ -n "$new_lv" ]; then mv "$new_lv" "$lv"; git -C "$dir" add config/worker-leveling; fi
  [ -f "$tomb" ] || printf '# Retired budget sources: tombstones that keep a dead subscription or host out\n# of the live registries. Written by retire-subscription.sh. Tab-separated:\n# kind\tid\tretired_at\tauthorized_by\tmessage_id\treason\n' > "$tomb"
  printf 'subscription\t%s\t%s\t%s\t%s\t%s\n' "$sub" "$now" "$authorized_by" "${message_id:--}" "$reason" >> "$tomb"
  local f
  for h in "${hosts[@]}"; do
    printf 'host\t%s\t%s\t%s\t%s\t%s\n' "$h" "$now" "$authorized_by" "${message_id:--}" "$reason" >> "$tomb"
    [ ! -e "$dir/worker-derotate/$h" ] || git -C "$dir" rm -q -- "worker-derotate/$h"
    if [ -e "$dir/hosts/$h" ]; then
      [ ! -e "$dir/hosts/.archived-$h" ] || git -C "$dir" rm -q -- "hosts/.archived-$h"
      git -C "$dir" mv -- "hosts/$h" "hosts/.archived-$h"
    fi
    for f in "$dir"/budget/live/*/"$h"; do
      [ -e "$f" ] && git -C "$dir" rm -q -- "${f#"$dir"/}"
    done
  done
  git -C "$dir" add config/retired-budget-sources
  if [ -d "$dir/budget/live/$sub" ] && [ -n "$(git -C "$dir" ls-files -- "budget/live/$sub")" ]; then
    git -C "$dir" rm -q -r -- "budget/live/$sub"
  fi
  return 0
}

msg="retire subscription $sub${hosts[*]:+ and host(s) ${hosts[*]}} (authorized_by=$authorized_by)"
for attempt in 1 2 3 4 5 6 7 8; do
  [ "$attempt" -eq 1 ] || backoff "$((attempt - 1))"
  rc=0; sync_clone "$DIR" || rc=1
  [ "$rc" -eq 0 ] && { _plan "$DIR" || rc=$?; }
  [ "$rc" -eq 3 ] && { git -C "$DIR" reset -q --hard HEAD 2>/dev/null || true; clone_unlock "$DIR"; exit 2; }
  [ "$rc" -eq 0 ] || continue
  if [ "$dry_run" -eq 1 ]; then
    git -C "$DIR" diff --cached --stat -M
    git -C "$DIR" diff --cached -M -- config
    git -C "$DIR" reset -q --hard HEAD
    clone_unlock "$DIR"
    exit 0
  fi
  rc=0; commit_and_push "$DIR" "$msg" || rc=$?
  if [ "$rc" -eq 0 ]; then log "$msg"; exit 0; fi
done
echo "retire-subscription: exhausted journal-push attempts" >&2
exit 1
