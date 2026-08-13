#!/bin/bash
# cost.sh — the read side of the attributed per-job cost ledger (design
# designs/token-cost-ledger.md § "Read-time aggregation"). Plain code, jq + awk, NO
# LLM, NO leader gating: any host can ask. Aggregation happens ONLY at read time —
# attribution is captured once, immutably, at write time (usage/<base>.jsonl), and
# every question is a regrouping of the same rows, so a new axis is a new group key,
# never a schema change.
#
# Because the fleet bills through FLAT Claude Max subscriptions (two accounts, one per
# host), the per-record `host` is load-bearing: host ⇒ account ⇒ subscription, and a
# fleet total that cannot be split per account is not usable for the maintainer's
# purpose. `--by host` is that split; the Anthropic `total_cost_usd` figures are
# NOTIONAL API list-price (what the calls WOULD cost on metered billing), not money.
#
# COVERAGE is a first-class output, never hidden: every surface prints how many
# completed jobs carry a ledger record and how many engagements are unpriced /
# unmetered. A ledger that silently samples a fraction of the work and presents a
# total is worse than no ledger, so the fraction is always stated.
#
# Usage: cost.sh [--by job|role|model|day|host] [--since <date-prefix>] [--job <base>]
#                [--json] [--compute] [--dir <journal-clone>]
#   --by       group key (default: job). day = ts date prefix; job = base.
#   --since    lexicographic ts filter (RFC3339 sorts as strings; e.g. 2026-08).
#   --job      restrict to one base (the tada-stanza path).
#   --json     machine output.
#   --compute  swap the token/dollar columns for host CPU / peak-RSS.
#   --dir      read from an existing journal clone instead of syncing one.
set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=common.sh
source "$HERE/common.sh"

by=job since='' job='' json=0 compute=0 dir=''
while [ $# -gt 0 ]; do
  case "$1" in
    --by)      by="${2:?}"; shift 2 ;;
    --since)   since="${2:?}"; shift 2 ;;
    --job)     job="${2:?}"; shift 2 ;;
    --json)    json=1; shift ;;
    --compute) compute=1; shift ;;
    --dir)     dir="${2:?}"; shift 2 ;;
    -h|--help) sed -n '2,32p' "${BASH_SOURCE[0]}"; exit 0 ;;
    *) die "unknown argument: $1" ;;
  esac
done
case "$by" in job|role|model|day|host) ;; *) die "--by must be one of job|role|model|day|host (got '$by')";; esac
command -v jq >/dev/null 2>&1 || die "cost.sh needs jq"

# Resolve the ledger source. A caller may point --dir at any synced journal clone
# (tests, an already-synced reader); otherwise sync a private read clone.
if [ -z "$dir" ]; then
  dir="${GARDEN_COST_CLONE:-$GARDEN_STATE/cost/journal}"
  ensure_clone "$dir"; sync_clone "$dir" || true
fi
[ -d "$dir/usage" ] || { echo "no usage ledger under $dir/usage (nothing recorded yet)"; exit 0; }

# The row set: one file per base, or all of them.
files=()
if [ -n "$job" ]; then
  [ -f "$dir/usage/$job.jsonl" ] && files=("$dir/usage/$job.jsonl")
else
  shopt -s nullglob; files=("$dir/usage"/*.jsonl); shopt -u nullglob
fi
# Total completed jobs = the coverage denominator (tada reports outlive the board).
tada_total=0
if [ -d "$dir/$JOBS_TADA" ]; then
  tada_total="$(tada_list "$dir" | grep -c . || true)"
fi

if [ "${#files[@]}" -eq 0 ]; then
  echo "no usage rows$([ -n "$job" ] && echo " for base '$job'") (0 of $tada_total completed jobs metered)"
  exit 0
fi

# One jq pass: filter by --since, group by the chosen key, fold each group, and also
# accumulate a grand total plus the coverage counters. Peak RSS folds as a MAX (memory
# does not accumulate across sequential runs); everything else sums.
summary="$(jq -s -c \
  --arg by "$by" --arg since "$since" '
  def key($r):
    if   $by=="job"   then ($r.base  // "(none)")
    elif $by=="role"  then ($r.role  // "(none)")
    elif $by=="model" then ($r.model // "(none)")
    elif $by=="host"  then ($r.host  // "(none)")
    else ($r.ts // "")[0:10] end;
  def hastok($r): ($r.input_tokens // $r.output_tokens // $r.cache_creation_tokens // $r.cache_read_tokens) != null;
  [ .[] | select($since=="" or ((.ts // "") >= $since)) ] as $rows
  | reduce $rows[] as $r ({groups:{}, bases:{}, eng:0, unpriced:0, unmetered:0,
                           i:0,o:0,cc:0,cr:0,cost:0,wall:0,cpuu:0,cpus:0,rss:0};
      .eng += 1
      | .bases[$r.base // "(none)"] = true
      | .unpriced  += (if $r.total_cost_usd == null then 1 else 0 end)
      | .unmetered += (if hastok($r) then 0 else 1 end)
      | .i += ($r.input_tokens // 0) | .o += ($r.output_tokens // 0)
      | .cc += ($r.cache_creation_tokens // 0) | .cr += ($r.cache_read_tokens // 0)
      | .cost += ($r.total_cost_usd // 0) | .wall += ($r.elapsed_s // 0)
      | .cpuu += ($r.cpu_user_ms // 0) | .cpus += ($r.cpu_sys_ms // 0)
      | .rss = ([.rss, ($r.peak_rss_kb // 0)] | max)
      | (key($r)) as $k
      | .groups[$k] = ((.groups[$k] // {k:$k,eng:0,i:0,o:0,cc:0,cr:0,cost:0,wall:0,cpuu:0,cpus:0,rss:0,unpriced:0,unmetered:0,models:{}})
          | .eng += 1
          | .i += ($r.input_tokens // 0) | .o += ($r.output_tokens // 0)
          | .cc += ($r.cache_creation_tokens // 0) | .cr += ($r.cache_read_tokens // 0)
          | .cost += ($r.total_cost_usd // 0) | .wall += ($r.elapsed_s // 0)
          | .cpuu += ($r.cpu_user_ms // 0) | .cpus += ($r.cpu_sys_ms // 0)
          | .rss = ([.rss, ($r.peak_rss_kb // 0)] | max)
          | .unpriced  += (if $r.total_cost_usd == null then 1 else 0 end)
          | .unmetered += (if hastok($r) then 0 else 1 end)
          | (if $r.model then .models[$r.model] = ((.models[$r.model] // 0)+1) else . end)) )
  | { by:$by,
      groups: (.groups | to_entries | map(.value) | sort_by([-(.cost), .k])),
      totals: {eng:.eng, bases:(.bases|keys|length), unpriced:.unpriced, unmetered:.unmetered,
               i:.i,o:.o,cc:.cc,cr:.cr,cost:.cost,wall:.wall,cpuu:.cpuu,cpus:.cpus,rss:.rss} }
  ' "${files[@]}" 2>/dev/null)" || die "cost.sh: failed to read the ledger (a malformed usage line?)"
[ -n "$summary" ] || die "cost.sh: empty aggregation (unreadable ledger)"

if [ "$json" -eq 1 ]; then
  jq -c --argjson tada "$tada_total" '. + {coverage:{metered_bases:.totals.bases, completed_jobs:$tada}}' <<<"$summary"
  exit 0
fi

# Human table. Token counts abbreviate (k/M); dollars to cents; wall/CPU to h/m/s.
fmt_int() { awk -v n="${1:-0}" 'BEGIN{ if(n>=1e6) printf "%.1fM",n/1e6; else if(n>=1e3) printf "%.1fk",n/1e3; else printf "%d",n }'; }
fmt_dur() { awk -v s="${1:-0}" 'BEGIN{ s=int(s); h=int(s/3600); m=int((s%3600)/60); sec=s%60; if(h>0) printf "%dh %dm",h,m; else if(m>0) printf "%dm %ds",m,sec; else printf "%ds",sec }'; }

hdr_key="$(printf '%-30s' "$(echo "$by" | tr '[:lower:]' '[:upper:]')")"
if [ "$compute" -eq 1 ]; then
  printf '%s %5s  %-10s %-10s %-9s\n' "$hdr_key" ENG CPU-USER CPU-SYS PEAK-RSS
else
  printf '%s %5s  %-8s %-8s %-8s %-9s %s\n' "$hdr_key" ENG IN OUT CACHED COST WALL
fi
row_count="$(jq -r '.groups | length' <<<"$summary")"
for i in $(seq 0 $((row_count-1))); do
  g="$(jq -c ".groups[$i]" <<<"$summary")"
  k="$(jq -r '.k' <<<"$g")"; eng="$(jq -r '.eng' <<<"$g")"
  if [ "$compute" -eq 1 ]; then
    printf '%-30.30s %5s  %-10s %-10s %-9s\n' "$k" "$eng" \
      "$(fmt_dur "$(( $(jq -r '.cpuu' <<<"$g") / 1000 ))")" \
      "$(fmt_dur "$(( $(jq -r '.cpus' <<<"$g") / 1000 ))")" \
      "$(fmt_int "$(jq -r '.rss' <<<"$g")")KB"
  else
    cost="$(jq -r '.cost' <<<"$g")"
    printf '%-30.30s %5s  %-8s %-8s %-8s $%-8.2f %s\n' "$k" "$eng" \
      "$(fmt_int "$(jq -r '.i' <<<"$g")")" "$(fmt_int "$(jq -r '.o' <<<"$g")")" \
      "$(fmt_int "$(jq -r '.cc + .cr' <<<"$g")")" "$cost" \
      "$(fmt_dur "$(jq -r '.wall' <<<"$g")")"
  fi
done

# TOTAL + the always-present coverage line.
teng="$(jq -r '.totals.eng' <<<"$summary")"; tbases="$(jq -r '.totals.bases' <<<"$summary")"
tunpriced="$(jq -r '.totals.unpriced' <<<"$summary")"; tunmetered="$(jq -r '.totals.unmetered' <<<"$summary")"
if [ "$compute" -eq 1 ]; then
  printf '%-30s %5s  %-10s %-10s %-9s\n' TOTAL "$teng" \
    "$(fmt_dur "$(( $(jq -r '.totals.cpuu' <<<"$summary") / 1000 ))")" \
    "$(fmt_dur "$(( $(jq -r '.totals.cpus' <<<"$summary") / 1000 ))")" \
    "$(fmt_int "$(jq -r '.totals.rss' <<<"$summary")")KB"
else
  printf '%-30s %5s  %-8s %-8s %-8s $%-8.2f %s\n' TOTAL "$teng" \
    "$(fmt_int "$(jq -r '.totals.i' <<<"$summary")")" "$(fmt_int "$(jq -r '.totals.o' <<<"$summary")")" \
    "$(fmt_int "$(jq -r '.totals.cc + .totals.cr' <<<"$summary")")" \
    "$(jq -r '.totals.cost' <<<"$summary")" \
    "$(fmt_dur "$(jq -r '.totals.wall' <<<"$summary")")"
fi
pct="$(awk -v a="$tbases" -v b="$tada_total" 'BEGIN{ printf "%.1f", (b>0)? 100*a/b : 0 }')"
printf 'Coverage: %s of %s completed jobs metered (%s%%)' "$tbases" "$tada_total" "$pct"
[ "$tunpriced" -gt 0 ] && printf ' · %s engagement(s) unpriced' "$tunpriced"
[ "$tunmetered" -gt 0 ] && printf ' · %s unmetered' "$tunmetered"
printf '\n'
