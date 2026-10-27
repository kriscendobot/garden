#!/bin/bash
# budget-road.sh — the budget road (designs/budget-road.md): one function,
# budget_road, that every budget reader consumes. Sourced by common.sh beside
# usage-meter.sh; not executable on its own.
#
# The road is allocation/road.json on journal2: a pinned head in the maintainer's
# order, then every other arc by recency of activity. Two lanes (primary,
# secondary) follow the road to the first arcs with planned work. Each
# subscription pool's week below the fixed 0.90 ceiling is split between the
# maintainer's decaying reserve (k, config/maintainer-reserve) and the lanes;
# whatever nobody has reserved is the foreman's discretion.
#
#   budget_road <journal-dir> [<subscription>]
#
# TSV out, `-` for an unknown number:
#   pool   sub t u P P_from kris_u R_k sum_R_l D verdict subtype D_at_reset c k fleet_u W_fleet W_kris resets_at
#   arc    sub rank arc lane share spend_u R admit W planned pinned last summary
#   alias  from to
#
# Without allocation/road.json there are no lanes: the arcs' part is all
# discretion and no arc row is lane-held. The pool verdict is consulted by
# meter_quota_status only when the road is armed (road_armed): road.json exists
# or config/maintainer-reserve is set. Otherwise the standing ramp stays in charge.

# The ceiling is a constant, not a road.json field, so no road edit can raise it
# (designs/budget-road.md § Decisions 2).
GARDEN_ROAD_CEILING="0.90"
: "${GARDEN_MAINTAINER_RESERVE_DEFAULT:=0.50}"
: "${GARDEN_ROAD_CACHE_SECS:=120}"
GARDEN_ROAD_PATH="allocation/road.json"

# road_file <dir> — print the road's path when it exists.
road_file() {
  [ -f "${1:?}/$GARDEN_ROAD_PATH" ] && printf '%s\n' "$1/$GARDEN_ROAD_PATH"
}

# road_armed <dir> — rc 0 when the road's verdict governs reserve-eligible pools.
road_armed() {
  local dir="${1:-}"
  [ -n "$dir" ] || return 1
  [ -f "$dir/$GARDEN_ROAD_PATH" ] || [ -f "$dir/config/maintainer-reserve" ]
}

# road_maintainer_reserve <dir> — k, the maintainer's share at window start.
road_maintainer_reserve() {
  local dir="${1:-}" file raw
  file="${dir:+$dir/config/maintainer-reserve}"
  if [ -n "$file" ] && [ -e "$file" ]; then
    raw="$(grep -v '^[[:space:]]*#' "$file" 2>/dev/null | grep -v '^[[:space:]]*$' | head -1 | awk '{$1=$1; print}')"
    if [[ "$raw" =~ ^(0([.][0-9]+)?|[.][0-9]+)$ ]] && awk -v k="$raw" -v c="$GARDEN_ROAD_CEILING" 'BEGIN { exit !(k >= 0 && k < c) }'; then
      printf '%s\n' "$raw"; return 0
    fi
    log "WARN: invalid maintainer reserve in $file (expected one number in [0, $GARDEN_ROAD_CEILING)); using $GARDEN_MAINTAINER_RESERVE_DEFAULT"
  fi
  printf '%s\n' "$GARDEN_MAINTAINER_RESERVE_DEFAULT"
}

# road_alias_target <dir> <arc> — the arc after folding aliases (empty = unarced).
road_alias_target() {
  local f arc="${2:-}"
  f="$(road_file "$1")" || { printf '%s\n' "$arc"; return 0; }
  jq -r --arg a "$arc" '
    def fold($x; $n): if $n > 8 then $x
      elif (.aliases // {} | has($x)) then (.aliases[$x]) as $t | if $t == null then "" else fold($t; $n + 1) end
      else $x end;
    if $a == "" then "" else fold($a; 0) end' "$f" 2>/dev/null || printf '%s\n' "$arc"
}

# road_arc_known <dir> <arc> — rc 0 when the arc is on the road or an alias, or
# no road exists yet (post-job.sh/post-plan.sh warn otherwise).
road_arc_known() {
  local f
  f="$(road_file "$1")" || return 0
  jq -e --arg a "$2" '(.arcs // [] | any(.arc == $a)) or (.aliases // {} | has($a))' "$f" >/dev/null 2>&1
}

# _road_epoch <iso> — epoch seconds, or empty.
_road_epoch() { [ -n "${1:-}" ] && date -u -d "$1" +%s 2>/dev/null || true; }

# road_planned_work <dir> [now] — one line per planned item: arc<TAB>posted-epoch.
# Planned work is a job in todo/ or doin/, or a plan whose gate is deferred and
# whose not_before has passed (designs/budget-road.md § Planned work). The arc is
# folded through aliases; unarced items print an empty arc.
road_planned_work() {
  local dir="${1:?}" now="${2:-$(meter_now)}" f slice arc posted due raw
  for slice in "$JOBS_TODO" "$JOBS_DOIN" "$JOBS_PLAN"; do
    [ -d "$dir/$slice" ] || continue
    for f in "$dir/$slice"/*.md; do
      [ -f "$f" ] || continue
      if [ "$slice" = "$JOBS_PLAN" ]; then
        [ "$(plan_gate "$f")" = deferred ] || continue
        if grep -q '^not_before:' "$f" 2>/dev/null; then
          raw="$(plan_field "$f" not_before)"
          due="$(_road_epoch "$raw")"
          [[ "$due" =~ ^[0-9]+$ ]] && [ "$now" -ge "$due" ] || continue
        fi
      fi
      arc="$(job_arc "$f")"
      posted="$(_road_epoch "$(plan_field "$f" posted_at 2>/dev/null || true)")"
      [[ "$posted" =~ ^[0-9]+$ ]] || posted="$(stat -c %Y "$f" 2>/dev/null || echo 0)"
      printf '%s\t%s\n' "$arc" "$posted"
    done
  done | _road_fold_aliases "$dir"
}

# _road_fold_aliases <dir> — rewrite column 1 (an arc) through the road's
# aliases (a null target folds to unarced, the empty arc). Chains fold up to 8 deep.
_road_fold_aliases() {
  local f map=""
  f="$(road_file "$1" || true)"
  [ -n "$f" ] && map="$(jq -r '.aliases // {} | to_entries[] | [.key, (.value // "")] | @tsv' "$f" 2>/dev/null || true)"
  awk -F'\t' -v OFS='\t' -v map="$map" '
    BEGIN { n = split(map, M, "\n"); for (i = 1; i <= n; i++) if (split(M[i], f, "\t") >= 1 && f[1] != "") to[f[1]] = f[2] }
    { a = $1; for (d = 0; d < 8 && a != "" && (a in to); d++) a = to[a]; $1 = a; print }'
}

# road_usage_weights <dir> <cutoff-epoch> <hosts-json|null> — one line per arc
# (aliases NOT folded; empty arc = unarced): arc<TAB>weighted<TAB>last-epoch, plus
# a total line `*<TAB>weighted<TAB>last`. Weights follow list-price ratios: input
# 1, output 5, cache creation 1.25, cache read 0.1.
road_usage_weights() {
  local dir="${1:?}" cutoff="${2:?}" hosts="${3:-null}"
  [ -d "$dir/usage" ] || { printf '*\t0\t0\n'; return 0; }
  find "$dir/usage" -maxdepth 1 -type f -name '*.jsonl' -print0 2>/dev/null \
    | xargs -0 -r cat 2>/dev/null \
    | jq -Rr --argjson cutoff "$cutoff" --argjson hosts "$hosts" '
        fromjson? // empty
        | select(type == "object")
        | select(.provider == null or .provider == "anthropic")
        | select($hosts == null or (.host as $h | any($hosts[]; . == $h)))
        | ((.ts // "") | fromdateiso8601? // -1) as $e
        | select($e >= $cutoff)
        | [(.arc // .["ratchet-arc"] // ""),
           ((.input_tokens // 0) + 5 * (.output_tokens // 0)
            + 1.25 * (.cache_creation_tokens // 0) + 0.1 * (.cache_read_tokens // 0)),
           $e] | @tsv' 2>/dev/null \
    | _road_fold_aliases "$dir" \
    | awk -F'\t' '{ w[$1] += $2; if ($3 > l[$1]) l[$1] = $3; t += $2; if ($3 > tl) tl = $3 }
        END { for (a in w) printf "%s\t%.0f\t%.0f\n", a, w[a], l[a]; printf "*\t%.0f\t%.0f\n", t, tl + 0 }'
}

# road_maintainer_weighted <cutoff-epoch> — the maintainer's weighted tokens on
# THIS host since <cutoff>: interactive Claude sessions only. Every session
# under a job scratch worktree and every `sdk-*` (claude -p) turn is excluded:
# those are the fleet's (jobs, the foreman), already in the usage rows. Reads
# token counts, message ids, and timestamps only, never content. Prints the sum,
# or fails when the session logs are unreadable.
road_maintainer_weighted() {
  local cutoff="${1:?}" logdir="$GARDEN_CCUSAGE_LOGDIR" scratch_key listing
  command -v jq >/dev/null 2>&1 || return 1
  [ -d "$logdir" ] && [ -r "$logdir" ] || return 1
  scratch_key="$(printf '%s' "${GARDEN_SCRATCH:-/nonexistent}" | sed 's#[/.]#-#g')"
  listing="$(find "$logdir" -maxdepth 6 -type f -name '*.jsonl' -newermt "@$cutoff" 2>/dev/null \
    | grep -v -F -- "/$scratch_key" || true)"
  [ -n "$listing" ] || { printf '0\n'; return 0; }
  printf '%s\n' "$listing" | tr '\n' '\0' | xargs -0 jq -Rr '
      fromjson? // empty
      | select(.type == "assistant" and (.message.usage != null))
      | select(((.entrypoint // "cli") | startswith("sdk")) | not)
      | [(.message.id // .uuid // "noid"),
         ((.timestamp // "") | sub("\\.[0-9]+Z$"; "Z") | (fromdateiso8601? // -1)),
         ((.message.usage.input_tokens // 0) + 5 * (.message.usage.output_tokens // 0)
          + 1.25 * (.message.usage.cache_creation_input_tokens // 0)
          + 0.1 * (.message.usage.cache_read_input_tokens // 0))] | @tsv' 2>/dev/null \
    | awk -F'\t' -v c="$cutoff" '!seen[$1]++ { if (($2 + 0) >= c) s += $3 } END { printf "%.0f\n", s + 0 }'
}

# _road_state_file <sub> — host-local calibration state.
_road_state_file() { printf '%s/budget/road/%s\n' "$GARDEN_STATE" "${1//[^A-Za-z0-9._-]/_}"; }

# road_maintainer_figure <dir> <sub> <cutoff> — W_kris for <sub>: counted here
# when this host owns the subscription, else the freshest published snapshot
# figure for the same window. Prints the number or `-`.
road_maintainer_figure() {
  local dir="$1" sub="$2" cutoff="$3" own="" file best_e=-1 best="-" e w ws
  own="$(budget_pool_for_provider_host anthropic "$GARDEN" "$dir" 2>/dev/null || true)"
  if [ -n "${GARDEN_ROAD_W_KRIS:-}" ]; then printf '%s\n' "$GARDEN_ROAD_W_KRIS"; return 0; fi
  if [ "$own" = "$sub" ] && w="$(road_maintainer_weighted "$cutoff")"; then
    printf '%s\n' "$w"; return 0
  fi
  [ -d "$dir/budget/live/$sub" ] || { printf -- '-\n'; return 0; }
  for file in "$dir/budget/live/$sub"/*; do
    [ -r "$file" ] || continue
    w="$(sed -n 's/^road_w_kris:[[:space:]]*//p' "$file" | head -1)"
    ws="$(sed -n 's/^window_start_epoch:[[:space:]]*//p' "$file" | head -1)"
    e="$(sed -n 's/^sampled_at_epoch:[[:space:]]*//p' "$file" | head -1)"
    [[ "$w" =~ ^[0-9]+$ && "$e" =~ ^[0-9]+$ ]] || continue
    [ "$ws" = "$cutoff" ] || continue
    [ "$e" -gt "$best_e" ] && { best_e="$e"; best="$w"; }
  done
  printf '%s\n' "$best"
}

# road_snapshot_lines <sub> <window-start> — the road lines an owning host adds
# to its budget/live snapshot. Best-effort: prints nothing it cannot measure.
road_snapshot_lines() {
  local sub="$1" ws="$2" w state p from
  if w="$(road_maintainer_weighted "$ws" 2>/dev/null)" && [[ "$w" =~ ^[0-9]+$ ]]; then
    printf 'road_w_kris: %s\n' "$w"
  fi
  state="$(_road_state_file "$sub")"
  if [ -r "$state" ] && [ "$(sed -n 's/^window_start:[[:space:]]*//p' "$state" | head -1)" = "$ws" ]; then
    p="$(sed -n 's/^p:[[:space:]]*//p' "$state" | head -1)"
    [[ "$p" =~ ^[0-9]+$ ]] && printf 'road_p: %s\nroad_p_from: current\n' "$p"
  fi
  return 0
}

# road_calibration <sub> <window-start> <u|-> <W_fleet> <W_kris|-> — print
# "P<TAB>P_from". The current week's P once u >= 0.10; otherwise last week's
# closing P from host-local state; otherwise `-<TAB>-`. Records the current
# figure so the next window can read it as last week's.
road_calibration() {
  local sub="$1" ws="$2" u="$3" wf="$4" wk="$5" state p="" from="-" st_ws st_p st_prev
  state="$(_road_state_file "$sub")"
  st_ws=""; st_p=""; st_prev=""
  if [ -r "$state" ]; then
    st_ws="$(sed -n 's/^window_start:[[:space:]]*//p' "$state" | head -1)"
    st_p="$(sed -n 's/^p:[[:space:]]*//p' "$state" | head -1)"
    st_prev="$(sed -n 's/^prev_p:[[:space:]]*//p' "$state" | head -1)"
  fi
  # A new window: the stored current-week figure becomes last week's closing P.
  if [ -n "$st_ws" ] && [ "$st_ws" != "$ws" ] && [ -n "$st_p" ] && [ "$st_p" != "-" ]; then
    st_prev="$st_p"; st_p="-"
  fi
  [ "$wk" = "-" ] && wk=0
  if [ "$u" != "-" ] && awk -v u="$u" 'BEGIN { exit !(u >= 0.10) }'; then
    p="$(awk -v a="$wf" -v b="$wk" -v u="$u" 'BEGIN { printf "%.0f", (a + b) / u }')"
    from=current
    [ "$p" -gt 0 ] 2>/dev/null || { p=""; from="-"; }
  fi
  if [ -z "$p" ] && [[ "$st_prev" =~ ^[0-9]+$ ]] && [ "$st_prev" -gt 0 ]; then p="$st_prev"; from=last-week; fi
  if [ -n "$GARDEN_STATE" ] && [ "${GARDEN_ROAD_STATE_WRITE:-1}" = 1 ]; then
    mkdir -p "$(dirname "$state")" 2>/dev/null \
      && printf 'window_start: %s\np: %s\nprev_p: %s\n' "$ws" "$([ "$from" = current ] && echo "$p" || echo "${st_p:--}")" "${st_prev:--}" \
           > "$state.tmp.$$" 2>/dev/null && mv -f "$state.tmp.$$" "$state" 2>/dev/null || rm -f "$state.tmp.$$" 2>/dev/null
  fi
  printf '%s\t%s\n' "${p:--}" "$from"
}

# road_used_fraction <dir> <sub> — u, the pool's newest seven-day utilization
# (0..1), or `-`. subscription_used_percent (ledger, live, fresher manual
# checkpoint) first, then the token/cap ratio.
road_used_fraction() {
  local dir="$1" sub="$2" pct row quota cutoff total
  if [ -n "${GARDEN_ROAD_U:-}" ]; then printf '%s\n' "$GARDEN_ROAD_U"; return 0; fi
  pct="$(subscription_used_percent "$sub" "$dir" 2>/dev/null || true)"
  if [[ "$pct" =~ ^[0-9]+([.][0-9]+)?$ ]]; then awk -v p="$pct" 'BEGIN { printf "%.4f\n", p / 100 }'; return 0; fi
  row="$(budget_pool_row "$sub" "$dir" 2>/dev/null)" || { printf -- '-\n'; return 0; }
  IFS=$'\t' read -r _ _ _ quota _ <<<"$row"
  [[ "$quota" =~ ^[1-9][0-9]*$ ]] || { printf -- '-\n'; return 0; }
  cutoff="$(subscription_window_start_epoch "$sub" "$dir" 2>/dev/null || true)"
  [[ "$cutoff" =~ ^[0-9]+$ ]] || { printf -- '-\n'; return 0; }
  total="$(meter_remote_snapshot_total "$dir" "$sub" "$quota" "$cutoff" 2>/dev/null || true)"
  [[ "$total" =~ ^[0-9]+$ ]] || { printf -- '-\n'; return 0; }
  awk -v t="$total" -v q="$quota" 'BEGIN { printf "%.4f\n", t / q }'
}

# road_order <dir> <planned-lines> <weights-lines> — the road: one line per arc,
# rank<TAB>arc<TAB>pinned<TAB>last-activity<TAB>planned-count<TAB>summary<TAB>on-road.
# Pinned arcs first in the maintainer's order; then every other road arc by
# recency of activity (newest first), ties in stored order; then arcs with work
# that are off the road (dropped or never added), then unarced work (arc "").
road_order() {
  local dir="$1" planned="$2" weights="$3" f
  f="$(road_file "$dir" || true)"
  {
    if [ -n "$f" ]; then
      jq -r '(.pinned // []) as $p
        | (.arcs // []) | to_entries[]
        | .value.arc as $a
        | ["R", $a, (($p | index($a)) // -1), .key, (.value.summary // "")] | @tsv' "$f" 2>/dev/null
      # A pinned arc missing from arcs[] is still on the road.
      jq -r '(.arcs // [] | map(.arc)) as $a | (.pinned // []) | to_entries[]
        | select(.value as $v | $a | index($v) | not) | ["R", .value, .key, 1000000, ""] | @tsv' "$f" 2>/dev/null
      jq -r '.aliases // {} | to_entries[] | ["A", .key] | @tsv' "$f" 2>/dev/null
    fi
    printf '%s\n' "$planned" | awk -F'\t' 'NF { print "P\t" $1 "\t" $2 }'
    printf '%s\n' "$weights" | awk -F'\t' 'NF && $1 != "*" { print "W\t" $1 "\t" $3 }'
  } | awk -F'\t' '
    $1 == "R" { if (!($2 in on)) { on[$2] = 1; pin[$2] = $3; pos[$2] = $4; sum[$2] = $5; order[++n] = $2 } next }
    $1 == "A" { alias[$2] = 1; next }
    $1 == "P" { cnt[$2]++; if ($3 > last[$2]) last[$2] = $3; seen[$2] = 1; next }
    $1 == "W" { if ($3 > last[$2]) last[$2] = $3; next }
    END {
      for (i = 1; i <= n; i++) {
        a = order[i]
        if (pin[a] >= 0) key = sprintf("0\t%08d\t0\t%08d", pin[a], pos[a])
        else key = sprintf("1\t%08d\t%012.0f\t%08d", 0, 9999999999 - (last[a] + 0), pos[a])
        printf "%s\t%s\t%s\t%.0f\t%d\t%s\t1\n", key, a, (pin[a] >= 0 ? "pinned" : "-"), last[a] + 0, cnt[a] + 0, sum[a]
      }
      for (a in seen) if (!(a in on) && a != "" && !(a in alias))
        printf "2\t%08d\t%012.0f\t%08d\t%s\t-\t%.0f\t%d\t\t0\n", 0, 9999999999 - (last[a] + 0), 0, a, last[a] + 0, cnt[a] + 0
      if ("" in seen) printf "3\t0\t0\t0\t\t-\t%.0f\t%d\t\t0\n", last[""] + 0, cnt[""] + 0
    }' | sort -t"$(printf '\t')" -k1,1n -k2,2n -k3,3n -k4,4n \
     | awk -F'\t' '{ printf "%d\t%s\t%s\t%s\t%s\t%s\t%s\n", NR, $5, $6, $7, $8, $9, $10 }'
}

# road_lanes <dir> — "primary<TAB>share" / "secondary<TAB>share" in order.
road_lanes() {
  local f
  if f="$(road_file "$1")"; then
    jq -r '(.lanes // {primary: 0.6, secondary: 0.4}) | to_entries[] | [.key, .value] | @tsv' "$f" 2>/dev/null && return 0
  fi
  return 0
}

# budget_road <journal-dir> [<subscription>] — see the header.
budget_road() {
  local dir="${1:?usage: budget_road <journal-dir> [subscription]}" only="${2:-}" now cache key
  now="$(meter_now)"
  if [ "${GARDEN_ROAD_CACHE_SECS:-0}" -gt 0 ] 2>/dev/null && [ -n "${GARDEN_STATE:-}" ]; then
    key="$(printf '%s|%s' "$dir" "$only" | cksum | cut -d' ' -f1)"
    cache="$GARDEN_STATE/budget/road-cache/$key.tsv"
    if [ -s "$cache" ] && [ $(( now - $(stat -c %Y "$cache" 2>/dev/null || echo 0) )) -lt "$GARDEN_ROAD_CACHE_SECS" ]; then
      cat "$cache"; return 0
    fi
    mkdir -p "$(dirname "$cache")" 2>/dev/null || true
    _budget_road_compute "$dir" "$only" "$now" > "$cache.tmp.$$" 2>/dev/null \
      && mv -f "$cache.tmp.$$" "$cache" && cat "$cache" && return 0
    rm -f "$cache.tmp.$$"
  fi
  _budget_road_compute "$dir" "$only" "$now"
}

# road_pools <dir> — reserve-eligible pools: Anthropic weekly-tokens pools with a
# resolvable reset window. Others keep a flat verdict (meter_quota_status).
road_pools() {
  local dir="$1" file
  file="$(budget_pool_file "$dir")" || return 0
  awk '/^[[:space:]]*#/ || /^[[:space:]]*$/ { next }
       ($3 == "weekly-tokens" && $2 == "anthropic") { print $1 }' "$file" 2>/dev/null
}

_budget_road_compute() {
  local dir="$1" only="$2" now="$3" sub pools planned c k lanes window start deadline t u hosts weights
  local wf wk pc p pfrom kris_u fleet_u rk resets order pin_frac
  c="$GARDEN_ROAD_CEILING"
  k="$(road_maintainer_reserve "$dir")"
  lanes="$(road_lanes "$dir")"
  planned="$(road_planned_work "$dir" "$now")"
  if [ -n "$only" ]; then pools="$only"; else pools="$(road_pools "$dir")"; fi
  pin_frac=""
  if pin_frac="$(token_backoff_override "$dir" "$now" 2>/dev/null)"; then pin_frac="${pin_frac%%$'\t'*}"; else pin_frac=""; fi
  [ "${_GARDEN_TOKEN_BACKOFF_FRACTION_FROM_ENV:-0}" -eq 1 ] && pin_frac="$GARDEN_TOKEN_BACKOFF_FRACTION"
  if [ -f "$dir/$GARDEN_ROAD_PATH" ]; then
    jq -r '.aliases // {} | to_entries[] | ["alias", .key, (.value // "-")] | @tsv' "$dir/$GARDEN_ROAD_PATH" 2>/dev/null
  fi
  for sub in $pools; do
    t="-"; start=""; deadline=""; resets="-"
    if window="$(token_backoff_ramp_window "$sub" "$dir" "$now" 2>/dev/null)"; then
      IFS=$'\t' read -r start _ deadline _ <<<"$window"
      t="$(awk -v s="$start" -v d="$deadline" -v n="$now" 'BEGIN { x = (n - s) / (d - s); if (x < 0) x = 0; if (x > 1) x = 1; printf "%.4f", x }')"
      resets="$(date -u -d "@$deadline" +%FT%TZ)"
    fi
    u="$(road_used_fraction "$dir" "$sub")"
    hosts="$(subscription_ledger_hosts "$sub" "$dir" 2>/dev/null || true)"
    [ -n "$hosts" ] || hosts=null
    weights=""; wf="-"; wk="-"; p="-"; pfrom="-"
    if [ -n "$start" ]; then
      weights="$(road_usage_weights "$dir" "$start" "$hosts")"
      wf="$(awk -F'\t' '$1 == "*" { print $2 }' <<<"$weights")"
      wk="$(road_maintainer_figure "$dir" "$sub" "$start")"
      pc="$(road_calibration "$sub" "$start" "$u" "${wf:-0}" "$wk")"
      IFS=$'\t' read -r p pfrom <<<"$pc"
    fi
    order="$(road_order "$dir" "$planned" "$weights")"
    awk -F'\t' -v OFS='\t' -v sub_="$sub" -v t="$t" -v u="$u" -v P="$p" -v Pf="$pfrom" \
      -v c="$c" -v k="$k" -v wf="${wf:--}" -v wk="${wk:--}" -v resets="$resets" \
      -v pin="$pin_frac" -v lanes="$lanes" -v weights="$weights" -v armed="$([ -f "$dir/$GARDEN_ROAD_PATH" ] && echo 1 || echo 0)" '
      function num(x) { return x != "-" && x != "" }
      BEGIN {
        nl = split(lanes, L, "\n"); nlane = 0
        for (i = 1; i <= nl; i++) if (split(L[i], f, "\t") == 2) { nlane++; lname[nlane] = f[1]; lshare[nlane] = f[2] }
        nw = split(weights, W, "\n")
        for (i = 1; i <= nw; i++) if (split(W[i], f, "\t") >= 2 && f[1] != "*") aw[f[1]] = f[2]
      }
      { n++; rank[n] = $1; arc[n] = $2; pinned[n] = $3; last[n] = $4; planned[n] = $5; summary[n] = $6; onroad[n] = $7 }
      END {
        known = num(t) && num(u)
        calib = num(P) && P > 0
        # Laning: the first road arcs (on the road, named) with planned work.
        li = 1
        for (i = 1; i <= n && li <= nlane; i++)
          if (armed && onroad[i] == 1 && arc[i] != "" && planned[i] > 0) { lane[i] = lname[li]; share[i] = lshare[li]; holder[li] = i; li++ }
        fleet_u = (calib && num(wf)) ? wf / P : "-"
        if (calib && num(u) && num(fleet_u)) { kris = u - fleet_u; if (kris < 0) kris = 0 } else kris = (num(u) ? 0 : "-")
        rk = "-"; if (num(t)) { rk = k * (1 - t) - (num(kris) ? kris : 0); if (rk < 0) rk = 0 }
        sum_rl = 0
        for (i = 1; i <= n; i++) {
          w = (arc[i] in aw) ? aw[arc[i]] : 0
          wt[i] = w
          sp[i] = calib ? w / P : 0
          R[i] = 0
          if (lane[i] != "" && num(t)) { R[i] = share[i] * (c - k) * (1 - t) - sp[i]; if (R[i] < 0) R[i] = 0 }
          sum_rl += R[i]
        }
        if (known) { D = c - u - rk - sum_rl; Dr = c - u } else { D = "-"; Dr = "-" }
        verdict = "unknown"; subtype = "-"
        if (num(u)) {
          bound = c - (num(rk) ? rk : 0)
          anyres = 0; for (i = 1; i <= n; i++) if (R[i] > 0) anyres = 1
          # Below c - R_k some arc always has reservation or D > 0. At or past it,
          # the reserve of the maintainer holds the fleet while a lane still has
          # reservation (reserve, silent), else everything is spent.
          if (u >= c) { verdict = "backoff"; subtype = "ceiling" }
          else if (u >= bound) { verdict = "backoff"; subtype = (anyres ? "reserve" : "spent") }
          else if (pin != "" && u >= pin) { verdict = "backoff"; subtype = "pin" }
          else { verdict = "ok" }
        }
        printf "pool\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\n", sub_, t, u,
          (calib ? sprintf("%.0f", P) : "-"), Pf, (num(kris) ? sprintf("%.4f", kris) : "-"),
          (num(rk) ? sprintf("%.4f", rk) : "-"), sprintf("%.4f", sum_rl), (num(D) ? sprintf("%.4f", D) : "-"),
          verdict, subtype, (num(Dr) ? sprintf("%.4f", Dr) : "-"), c, k,
          (num(fleet_u) ? sprintf("%.4f", fleet_u) : "-"), wf, wk, resets
        for (i = 1; i <= n; i++) {
          if (verdict == "unknown") adm = "open"
          else if (u >= c - (num(rk) ? rk : 0) || (pin != "" && u >= pin)) adm = "held"
          else if (lane[i] != "" && R[i] > 0) adm = "reserved"
          else if (!num(t) || D > 0) adm = "discretion"
          else adm = "held"
          printf "arc\t%s\t%d\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%d\t%s\t%s\t%s\n", sub_, rank[i],
            (arc[i] == "" ? "-" : arc[i]), (lane[i] == "" ? "-" : lane[i]), (share[i] == "" ? "-" : share[i]),
            (calib ? sprintf("%.4f", sp[i]) : "-"), sprintf("%.4f", R[i]), adm, wt[i], planned[i],
            (onroad[i] == 1 ? pinned[i] : "off-road"),
            (last[i] > 0 ? sprintf("%.0f", last[i]) : "-"), summary[i]
        }
      }' <<<"$order"
  done
}

# road_pool_verdict <dir> <sub> — print "<verdict>\t<subtype>" from budget_road.
road_pool_verdict() {
  budget_road "$1" "$2" | awk -F'\t' '$1 == "pool" { print $11 "\t" $12; exit }'
}

# road_arc_admission <dir> [sub] — the road-wide admission per arc, merged across
# pools (an arc is admitted when any pool admits it; reserved beats discretion):
# rank<TAB>arc<TAB>lane<TAB>admit<TAB>planned<TAB>summary, in road order. With no
# reserve-eligible pool, every arc is `discretion`. A last row with arc `*` is the
# admission for an arc the road has not seen (no planned work): discretion while
# some pool admits with D > 0, else held.
road_arc_admission() {
  local dir="${1:?}" sub="${2:-}" out
  out="$(budget_road "$dir" "$sub")"
  if ! grep -q '^arc' <<<"$out"; then
    road_order "$dir" "$(road_planned_work "$dir")" "" \
      | awk -F'\t' -v OFS='\t' '{ print $1, ($2 == "" ? "-" : $2), "-", "discretion", $5, $6 }
          END { print NR + 1, "*", "-", "discretion", 0, "" }'
    return 0
  fi
  awk -F'\t' -v OFS='\t' '
    $1 == "pool" { if ($11 == "unknown" || ($11 == "ok" && ($10 == "-" || $10 > 0))) other = "discretion"; next }
    $1 == "arc" {
      a = $4
      if (!(a in rank)) { rank[a] = $3; lane[a] = $5; adm[a] = $9; pl[a] = $11; sm[a] = $14; order[++n] = a; next }
      if ($9 == "reserved" || ($9 == "discretion" && adm[a] == "held")) adm[a] = $9
    }
    END { for (i = 1; i <= n; i++) { a = order[i]; print rank[a], a, lane[a], adm[a], pl[a], sm[a] }
          print n + 1, "*", "-", (other == "" ? "held" : other), 0, "" }' <<<"$out"
}
