#!/bin/bash
# cost-by-pr.sh — roll the garden's per-JOB true cost up to the MERGED PULL REQUEST,
# the "Gimix escrow oracle": the unit of delivered value the garden can be priced by.
# Plain code, jq + awk + git-log, NO LLM. Design: designs/token-cost-ledger.md
# (§ read-time aggregation) extended one axis — job -> PR — past cost.sh's job/role/
# model/day/host axes.
#
# WHY A SEPARATE SCRIPT, NOT `cost.sh --by pr`. cost.sh groups the usage LEDGER
# (usage/*.jsonl) whose `total_cost_usd` is NOTIONAL API list price — on a flat Claude
# Max subscription that is what the tokens WOULD cost metered, not money charged
# (overstates ~8.7x; see reputation/rate-card.md). This script instead prices on the
# TRUE-COST basis the auction actually uses: each reputation event's CAPPED PROXY
# WALLCLOCK times the journal rate card (reputation.sh § rep_estimated_dollars). That
# is child 1's basis (garden-budget-ratecard) and the honest one for a flat plan.
#
# THE JOIN IS THE HARD PART. Report prose cites a PR URL only ~16% of the time, so we
# do not regex prose. Two deterministic edges, most-reliable first:
#   1. jobs/index/<hash>: a comment/CI directive's `identity: owner/repo#PR:...` mapped
#      to the `base:` it minted — authoritative, the watcher built it.
#   2. the job BASE NAME's embedded number, VALIDATED against the real PR set for the
#      repo the base names (gh, cached). Validation kills false positives (a date, an
#      issue number, a gate id that merely looks like a PR).
# Join coverage is MEASURED and always printed. A base that joins to no PR is real cost
# too (scholar cycles, presses, watchdogs, garden-internal main2 builds) and goes to an
# explicit UNATTRIBUTED bucket — never silently dropped, which would understate every
# per-PR figure.
#
# TWO COST COLUMNS, because two providers are not truly measured. `openai` (ChatGPT
# plan meters no per-token dollars) and any arm with no rate row are priced at the rate
# card's deliberately-HIGH provisional fleet default ($0.005154/s) so a never-measured
# arm cannot win the auction on false cheapness. That figure is a modelling CEILING,
# not money, so it is reported in a separate `CEILING` column and kept OUT of the
# measured-basis headline total. anthropic/moonshot/fireworks/local are the measured
# rows.
#
# Usage: cost-by-pr.sh [--dir <journal-clone>] [--pr-cache <tsv>] [--no-fetch]
#                      [--top N] [--merged-only] [--json]
#   --dir         read an existing synced journal clone instead of syncing one.
#   --pr-cache    a TSV of `repo<TAB>number<TAB>state` (state: merged|open|closed) to
#                 use as the known-PR + merged-state oracle, instead of calling gh.
#   --no-fetch    do not call gh; resolve only jobs/index edges (base-name edges need
#                 the PR set). Deterministic + offline.
#   --top N       show the top N merged PRs by measured cost (default 30).
#   --merged-only restrict the PR table to merged PRs (the escrow-oracle view).
#   --json        machine output (full per-PR + buckets + coverage).
set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=common.sh
source "$HERE/common.sh"
# shellcheck source=reputation.sh
source "$HERE/reputation.sh"   # rep_wallclock_index / rep_proxy_secs / rep_rate_per_second

dir='' prcache='' fetch=1 top=30 merged_only=0 json=0
while [ $# -gt 0 ]; do
  case "$1" in
    --dir)         dir="${2:?}"; shift 2 ;;
    --pr-cache)    prcache="${2:?}"; shift 2 ;;
    --no-fetch)    fetch=0; shift ;;
    --top)         top="${2:?}"; shift 2 ;;
    --merged-only) merged_only=1; shift ;;
    --json)        json=1; shift ;;
    -h|--help)     sed -n '2,60p' "${BASH_SOURCE[0]}"; exit 0 ;;
    *) die "unknown argument: $1" ;;
  esac
done
command -v jq >/dev/null 2>&1 || die "cost-by-pr.sh needs jq"

# Resolve the journal source (same shape as cost.sh): a caller-supplied clone or a
# private read clone we sync. git-log for the wallclock proxy runs against THIS dir,
# never the deployed root repo.
if [ -z "$dir" ]; then
  dir="${GARDEN_COST_CLONE:-$GARDEN_STATE/cost/journal}"
  ensure_clone "$dir"; sync_clone "$dir" || true
fi
[ -d "$dir/reputation/events" ] || die "no reputation/events under $dir (nothing to price)"

TMP="$(mktemp -d "${TMPDIR:-/tmp}/cost-by-pr.XXXXXX")"; trap 'rm -rf "$TMP"' EXIT

# --- 1. wallclock proxy index for every completed base (one git-log pass) ----
rep_wallclock_index "$dir" > "$TMP/wc.idx" 2>/dev/null || : > "$TMP/wc.idx"
# collapse to the LAST span per base (a re-posted base's final run wins)
awk '{ v[$1]=$2 } END{ for (b in v) printf "%s\t%s\n", b, v[b] }' "$TMP/wc.idx" > "$TMP/wc.map"

# --- 2. price every reputation event on the true-cost basis -------------------
# Row: base \t provider \t proxy_secs \t rate \t cost. Demerit events are probe
# accounting, not delivered work, and are skipped.
declare -A WC; while IFS=$'\t' read -r b s; do WC["$b"]="$s"; done < "$TMP/wc.map"
declare -A RATE   # memoize per (provider|model|tht) arm
: > "$TMP/base_cost.tsv"
shopt -s nullglob
for ev in "$dir/reputation/events"/*.md; do
  base="$(sed -n 's/^base:[[:space:]]*//p' "$ev" | head -1)"
  [ -n "$base" ] || continue
  [ "$(sed -n 's/^demerit:[[:space:]]*//p' "$ev" | head -1)" = "true" ] && continue
  prov="$(sed -n 's/^provider:[[:space:]]*//p' "$ev" | head -1)"
  model="$(sed -n 's/^model:[[:space:]]*//p' "$ev" | head -1)"
  tht="$(sed -n 's/^thoughtfulness:[[:space:]]*//p' "$ev" | head -1)"
  dur="$(sed -n 's/^duration_secs:[[:space:]]*//p' "$ev" | head -1)"
  psecs="$(rep_proxy_secs "${WC[$base]:-}" "${dur:-0}")"
  armkey="${prov:-?}|${model:-?}|${tht:-?}"
  rate="${RATE[$armkey]:-}"
  if [ -z "$rate" ]; then rate="$(rep_rate_per_second "$dir" "$prov" "$model" "$tht")"; rate="${rate:-0}"; RATE["$armkey"]="$rate"; fi
  cost="$(awk -v s="$psecs" -v r="$rate" 'BEGIN{ printf "%.6f", (s+0)*(r+0) }')"
  printf '%s\t%s\t%s\t%s\t%s\n' "$base" "${prov:-unknown}" "$psecs" "$rate" "$cost" >> "$TMP/base_cost.tsv"
done
shopt -u nullglob
priced_total="$(wc -l < "$TMP/base_cost.tsv" | tr -d ' ')"
[ "$priced_total" -gt 0 ] || die "no reputation events priced"

# --- 3. build the base -> PR join --------------------------------------------
# 3a. authoritative jobs/index edges.
: > "$TMP/b2pr.tsv"
declare -A B2PR
if [ -d "$dir/jobs/index" ]; then
  for f in "$dir/jobs/index"/*; do
    [ -f "$f" ] || continue
    b="$(sed -n 's/^base:[[:space:]]*//p' "$f" | head -1)"
    id="$(sed -n 's/^identity:[[:space:]]*//p' "$f" | head -1)"
    pr="$(printf '%s' "$id" | grep -oE '^[A-Za-z0-9._-]+/[A-Za-z0-9._-]+#[0-9]+' | head -1 || true)"
    [ -n "$b" ] && [ -n "$pr" ] && B2PR["$b"]="$pr"
  done
fi

# 3b. the known-PR + merged-state oracle. From --pr-cache, else gh over the repos the
# jobs/index identities name. state: merged|open|closed. PRSTATE[repo#num]=state.
declare -A PRSTATE
load_prcache() { while IFS=$'\t' read -r repo num state; do [ -n "$repo" ] && PRSTATE["$repo#$num"]="$state"; done < "$1"; }
if [ -n "$prcache" ]; then
  [ -f "$prcache" ] || die "--pr-cache not found: $prcache"
  load_prcache "$prcache"
elif [ "$fetch" -eq 1 ] && command -v gh >/dev/null 2>&1; then
  # repos named by any jobs/index identity, plus any repo a base name implies.
  { for f in "$dir/jobs/index"/*; do sed -n 's/^identity:[[:space:]]*//p' "$f" 2>/dev/null; done; } \
    | grep -oE '^[A-Za-z0-9._-]+/[A-Za-z0-9._-]+' | sort -u > "$TMP/repos.txt" || true
  : > "$TMP/prcache.tsv"
  while read -r repo; do
    [ -n "$repo" ] || continue
    gh pr list -R "$repo" --state all --limit 3000 --json number,state,mergedAt 2>/dev/null \
      | jq -r --arg r "$repo" '.[] | [$r,(.number|tostring),(if .mergedAt then "merged" else (.state|ascii_downcase) end)] | @tsv' \
      >> "$TMP/prcache.tsv" 2>/dev/null || true
  done < "$TMP/repos.txt"
  load_prcache "$TMP/prcache.tsv"
fi

# 3c. validated base-name edges for bases jobs/index missed. The number must be
# PR-SHAPED, not any stray digit: a bare token false-joins wildly (a garden-internal
# `xs2rust-endor-stage10-...` base contains "endo" and a "10" that is a real PR #10 in
# the 2000+-PR endo repo). We accept a number ONLY when it is written as a PR
# reference — `pr<N>`, `#<N>`, `pull-request-<N>`, or DIRECTLY adjacent to the repo's
# slug (`endo-but-for-bots-<N>`, `ebfb-<N>`, `finbot-<N>`, ...) — AND it is a real PR
# of that repo. The dense `endojs/endo` repo is deliberately NOT classified from base
# names at all (its near-contiguous number space makes any small token "valid"); its
# edges come only from the authoritative jobs/index. Ambiguous (>1 distinct real PR)
# -> leave unattributed rather than guess.
repo_of_base() {
  case "$1" in
    *endo-but-for-bots*|*ebfb*) echo "endojs/endo-but-for-bots" ;;
    *agoric-sdk*)               echo "Agoric/agoric-sdk" ;;
    *minion*)                   echo "kriscendobot/minion.town" ;;
    *finbot*)                   echo "kriscendobot/finbot" ;;
    *)                          echo "" ;;
  esac
}
# pr_candidates <base> <repo> — emit PR-shaped number tokens (one per line).
pr_candidates() {
  local b="$1" repo="$2"
  # generic explicit PR references, any repo
  printf '%s\n' "$b" | grep -oE '(pr|pull-request-|pull_request_|#)[0-9]{2,6}' | grep -oE '[0-9]{2,6}'
  # slug-adjacent number: the repo's short name immediately followed by -<N>
  case "$repo" in
    endojs/endo-but-for-bots)  printf '%s\n' "$b" | grep -oE '(endo-but-for-bots|ebfb)-[0-9]{2,6}' | grep -oE '[0-9]{2,6}$' ;;
    Agoric/agoric-sdk)         printf '%s\n' "$b" | grep -oE 'agoric-sdk-[0-9]{2,6}' | grep -oE '[0-9]{2,6}$' ;;
    kriscendobot/minion.town)  printf '%s\n' "$b" | grep -oE 'minion(\.town)?-[0-9]{2,6}' | grep -oE '[0-9]{2,6}$' ;;
    kriscendobot/finbot)       printf '%s\n' "$b" | grep -oE 'finbot-[0-9]{2,6}' | grep -oE '[0-9]{2,6}$' ;;
  esac
}
# NB: guard with the `+x` form, not `${#PRSTATE[@]}` — bash treats an EMPTY declared
# associative array as unset under `set -u`, so `${#PRSTATE[@]}` traps when neither
# --pr-cache nor gh populated it (the --no-fetch path).
if [ -n "${PRSTATE[*]+x}" ]; then
  cut -f1 "$TMP/base_cost.tsv" | while read -r b; do
    [ -n "${B2PR[$b]:-}" ] && continue
    repo="$(repo_of_base "$b")"; [ -n "$repo" ] || continue
    m=''; seen=''
    for num in $(pr_candidates "$b" "$repo"); do
      [ -n "${PRSTATE[$repo#$num]:-}" ] || continue
      case " $seen " in *" $num "*) : ;; *) seen="$seen $num"; m="$num" ;; esac
    done
    # exactly one distinct real-PR token -> accept
    if [ "$(printf '%s' "$seen" | wc -w)" = "1" ]; then printf '%s\t%s#%s\n' "$b" "$repo" "$m"; fi
  done > "$TMP/name_edges.tsv"
  while IFS=$'\t' read -r b pr; do [ -n "${B2PR[$b]:-}" ] || B2PR["$b"]="$pr"; done < "$TMP/name_edges.tsv"
fi

# --- 4. aggregate -------------------------------------------------------------
# emit per-base joined rows: base pr state jobs-flag measured ceiling
: > "$TMP/joined.tsv"
while IFS=$'\t' read -r base prov psecs rate cost; do
  # ceiling = openai OR the provisional fleet-default rate (no measured row for the arm)
  ceil=0
  case "$prov" in openai) ceil=1 ;; esac
  case "$rate" in 0.005154|0.005154000) ceil=1 ;; esac
  pr="${B2PR[$base]:-}"
  state=''; [ -n "$pr" ] && state="${PRSTATE[$pr]:-unknown}"
  printf '%s\t%s\t%s\t%d\t%s\n' "${pr:-__UNATTRIBUTED__}" "$state" "$base" "$ceil" "$cost" >> "$TMP/joined.tsv"
done < "$TMP/base_cost.tsv"

# fold in awk: per-PR measured/ceiling/jobs, unattributed bucket, coverage counters.
summary="$(awk -F'\t' '
  {
    pr=$1; st=$2; ceil=$4+0; c=$5+0;
    total_priced++;
    if (ceil) tot_ceil+=c; else tot_meas+=c;
    if (pr=="__UNATTRIBUTED__") { un_jobs++; if (ceil) un_ceil+=c; else un_meas+=c; next }
    joined_priced++;
    jobs[pr]++; state[pr]=st;
    if (ceil) ceilc[pr]+=c; else measc[pr]+=c;
  }
  END{
    printf "PRICED\t%d\n", total_priced;
    printf "JOINED\t%d\n", joined_priced;
    printf "TOTMEAS\t%.6f\n", tot_meas;
    printf "TOTCEIL\t%.6f\n", tot_ceil;
    printf "UNATT\t%d\t%.6f\t%.6f\n", un_jobs, un_meas, un_ceil;
    for (p in jobs) printf "PR\t%s\t%s\t%d\t%.6f\t%.6f\n", p, state[p], jobs[p], measc[p], ceilc[p];
  }' "$TMP/joined.tsv")"

get() { printf '%s\n' "$summary" | awk -F'\t' -v k="$1" '$1==k{print; exit}'; }
priced="$(get PRICED | cut -f2)"; joined="$(get JOINED | cut -f2)"
totmeas="$(get TOTMEAS | cut -f2)"; totceil="$(get TOTCEIL | cut -f2)"
read -r _ un_jobs un_meas un_ceil <<<"$(get UNATT)"
distinct_pr="$(printf '%s\n' "$summary" | awk -F'\t' '$1=="PR"' | wc -l | tr -d ' ')"
merged_pr="$(printf '%s\n' "$summary" | awk -F'\t' '$1=="PR" && $3=="merged"' | wc -l | tr -d ' ')"
covpct="$(awk -v a="$joined" -v b="$priced" 'BEGIN{ printf "%.1f", (b>0)?100*a/b:0 }')"

if [ "$json" -eq 1 ]; then
  printf '%s\n' "$summary" | awk -F'\t' '$1=="PR"' \
    | jq -R -s --argjson priced "$priced" --argjson joined "$joined" \
        --arg totmeas "$totmeas" --arg totceil "$totceil" \
        --argjson unj "$un_jobs" --arg unm "$un_meas" --arg unc "$un_ceil" '
      split("\n") | map(select(length>0) | split("\t") | {
        pr:.[1], state:.[2], jobs:(.[3]|tonumber),
        measured_usd:(.[4]|tonumber), ceiling_usd:(.[5]|tonumber) }) as $prs
      | { basis:"capped-proxy-wallclock x reputation/rate-card.md (true cost, child 1)",
          coverage:{ priced_bases:$priced, joined_bases:$joined,
                     join_pct:(if $priced>0 then (10000*$joined/$priced|floor)/100 else 0 end),
                     distinct_prs:($prs|length),
                     merged_prs:([$prs[]|select(.state=="merged")]|length) },
          totals:{ measured_usd:($totmeas|tonumber), ceiling_usd:($totceil|tonumber) },
          unattributed:{ jobs:$unj, measured_usd:($unm|tonumber), ceiling_usd:($unc|tonumber) },
          prs:($prs | sort_by(-.measured_usd)) }'
  exit 0
fi

# --- human report ------------------------------------------------------------
echo "Per-merged-PR cost — true-cost basis (capped proxy wallclock x reputation/rate-card.md)"
echo "Population: $priced priced reputation events (the auction cost population)."
echo
printf '%-36s %-8s %5s %11s %11s\n' 'PULL REQUEST' STATE JOBS MEASURED 'CEILING*'
printf '%s\n' "$summary" | awk -F'\t' '$1=="PR"{print}' \
  | awk -F'\t' -v mo="$merged_only" '(mo==0)||($3=="merged")' \
  | sort -t$'\t' -k5 -rn | head -n "$top" \
  | while IFS=$'\t' read -r _ pr st jobs meas ceil; do
      printf '%-36.36s %-8s %5s %10.2f %10.2f\n' "$pr" "$st" "$jobs" "$meas" "$ceil"
    done
echo
printf 'UNATTRIBUTED (no PR: scholar/press/watchdog/garden-internal)  %5s %10.2f %10.2f\n' \
  "$un_jobs" "$un_meas" "$un_ceil"
echo
printf 'Measured-basis total: $%.2f   |   Ceiling* (openai/unknown, provisional — NOT money): $%.2f\n' "$totmeas" "$totceil"
printf 'Join coverage: %s of %s priced bases mapped to a PR (%s%%) across %s PRs (%s merged).\n' \
  "$joined" "$priced" "$covpct" "$distinct_pr" "$merged_pr"
echo   '  * CEILING = openai (ChatGPT plan meters $0) + any arm with no measured rate,'
echo   '    priced at the rate card'\''s deliberately-high $0.005154/s floor. A modelling'
echo   '    ceiling, kept out of the measured total. Per-PR JOBS is a LOWER BOUND — at 29%'
echo   '    join coverage most contributing jobs of an older PR were never joined.'
