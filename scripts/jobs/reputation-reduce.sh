#!/bin/bash
# reputation-reduce.sh - incrementally maintain the reputation arm projections.
#
# The journal event log is authoritative, but a timer tick no longer walks all of
# it. A local cursor discovers changed inputs, a durable-on-this-host queue names
# the affected arms, and an active arm scan checkpoints after a bounded number of
# event files. A leader restart resumes that scan. A new leader bootstraps the same
# queue in bounded discovery batches instead of attempting one full-history pass.
#
# Usage: reputation-reduce.sh
set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=common.sh
source "$HERE/common.sh"
# shellcheck source=auction.sh
source "$HERE/auction.sh"
export GARDEN_TAG="rep-reduce"

DIR="${GARDEN_REDUCER_CLONE:-$GARDEN_STATE/reducer/journal}"
STATE="${GARDEN_REDUCER_STATE:-$GARDEN_STATE/reducer/checkpoint}"
DISCOVERY_BATCH="${GARDEN_REP_REDUCE_DISCOVERY_BATCH:-250}"
EVENT_BUDGET="${GARDEN_REP_REDUCE_EVENT_BUDGET:-500}"
PENDING_BATCH="${GARDEN_REP_REDUCE_PENDING_BATCH:-100}"

case "$DISCOVERY_BATCH:$EVENT_BUDGET:$PENDING_BATCH" in
  *[!0-9:]*|0:*|*:0:*|*:0) die "reducer batch limits must be positive integers" ;;
esac

mkdir -p "$STATE"
ensure_clone "$DIR"
sync_clone "$DIR"
HEAD_SHA="$(git -C "$DIR" rev-parse HEAD)"
QUEUE="$STATE/arms.queue"
touch "$QUEUE"

atomic_line() {
  local file="$1" value="$2"
  local tmp="$file.tmp.$$"
  printf '%s\n' "$value" > "$tmp"
  mv "$tmp" "$file"
}

state_value() {
  if [ -f "$1" ]; then head -1 "$1" 2>/dev/null || true; fi
}

event_arm_record() {
  local ef="$1" kind provider model tht wc tgt rel
  kind="$(plan_field "$ef" kind)"; provider="$(plan_field "$ef" provider)"
  model="$(plan_field "$ef" model)"; tht="$(plan_field "$ef" thoughtfulness)"
  wc="$(plan_field "$ef" work_class)"; tgt="$(plan_field "$ef" target)"
  [ -n "$kind" ] && [ -n "$provider" ] && [ -n "$model" ] && [ -n "$tht" ] \
    && [ -n "$wc" ] && [ -n "$tgt" ] || return 0
  kind="$(canonical_worker_kind "$kind" "$(plan_field "$ef" worker_kind_schema)" 2>/dev/null || printf '%s' "$kind")"
  rel="$(rep_arm_relpath "$kind" "$provider" "$model" "$tht" "$wc" "$tgt")"
  printf '%s\t%s\t%s\t%s\t%s\t%s\t%s\n' \
    "$kind" "$provider" "$model" "$tht" "$wc" "$tgt" "$rel"
}

queue_record() {
  local rec="$1" reset_active="${2:-0}" rel tmp
  [ -n "$rec" ] || return 0
  rel="${rec##*$'\t'}"
  if [ "$reset_active" -eq 1 ] && [ "$(state_value "$STATE/active-rel")" = "$rel" ]; then
    rm -f "$STATE/active-head" "$STATE/active-rel" "$STATE/active-record" \
      "$STATE/active-cursor" "$STATE/active.dat"
  fi
  awk -F '\t' -v r="$rel" '$NF == r { found=1 } END { exit !found }' "$QUEUE" \
    && return 0
  tmp="$QUEUE.tmp.$$"
  { cat "$QUEUE"; printf '%s\n' "$rec"; } | LC_ALL=C sort -t $'\t' -k7,7 -u > "$tmp"
  mv "$tmp" "$QUEUE"
}

record_from_revision() {
  local rev="$1" path="$2" tmp="$STATE/event.$$"
  git -C "$DIR" show "$rev:$path" > "$tmp" 2>/dev/null || { rm -f "$tmp"; return 0; }
  event_arm_record "$tmp"
  rm -f "$tmp"
}

schedule_rescan() {
  local head="$1" signature="$2" force="${3:-0}"
  # Projection commits advance HEAD while this scan is running. The policy
  # signature, not HEAD, identifies the same in-flight scan and prevents those
  # derived commits from repeatedly restarting discovery at the beginning.
  if [ "$force" -eq 1 ] || [ ! -f "$STATE/rescan-head" ] \
     || [ "$(state_value "$STATE/rescan-signature")" != "$signature" ]; then
    atomic_line "$STATE/rescan-head" "$head"
    atomic_line "$STATE/rescan-signature" "$signature"
    : > "$STATE/rescan-cursor"
    rm -f "$STATE/active-head" "$STATE/active-rel" "$STATE/active-record" \
      "$STATE/active-cursor" "$STATE/active.dat"
  fi
}

POLICY_SIGNATURE="$({ sha256sum "$0" "$HERE/reputation.sh" "$HERE/rate-card-defaults.md" 2>/dev/null || true; printf 'flat=%s\ndefault-rate=%s\n' "${GARDEN_REP_FLAT_PROVIDERS:-}" "${GARDEN_REP_DEFAULT_RATE_PER_SEC:-}"; } | sha256sum | cut -d' ' -f1)"

# Finalization is its own commit. Projection work resumes next tick, where the
# accepted push appears as an ordinary changed event.
finalize_pending() {
  local cursor paths=() pf base tgt accepted rounds words human agentic aggregate seen=0 last=""
  [ -d "$DIR/$REP_PENDING" ] || return 1
  cursor="$(state_value "$STATE/pending-cursor")"
  mapfile -t paths < <(find "$DIR/$REP_PENDING" -maxdepth 1 -type f -name '*.md' -printf '%f\n' \
    | LC_ALL=C sort | awk -v c="$cursor" -v n="$PENDING_BATCH" '$0>c && k<n { print; k++ }')
  if [ "${#paths[@]}" -eq 0 ] && [ -n "$cursor" ]; then
    : > "$STATE/pending-cursor"
    mapfile -t paths < <(find "$DIR/$REP_PENDING" -maxdepth 1 -type f -name '*.md' -printf '%f\n' \
      | LC_ALL=C sort | awk -v n="$PENDING_BATCH" 'k<n { print; k++ }')
  fi
  [ "${#paths[@]}" -gt 0 ] || return 1
  for base in "${paths[@]}"; do
    seen=$((seen+1)); last="$base"; pf="$DIR/$REP_PENDING/$base"; base="${base%.md}"
    tgt="$(plan_field "$pf" target)"; tgt="${tgt:-main2}"; accepted=""
    if [ -f "$DIR/$REP_VERDICTS/$base" ]; then
      accepted="$(sed -n 's/^accepted:[[:space:]]*//p' "$DIR/$REP_VERDICTS/$base" 2>/dev/null | head -1)"
    fi
    if [ -z "$accepted" ] && [ "$tgt" = main2 ]; then accepted=true; fi
    [ -n "$accepted" ] || continue
    rounds=""; words=""
    if [ -f "$DIR/$REP_ROOT/reviews/$base" ]; then
      rounds="$(sed -n 's/^rounds:[[:space:]]*//p' "$DIR/$REP_ROOT/reviews/$base" 2>/dev/null | head -1 | tr -dc '0-9')"
      words="$(sed -n 's/^comment_words:[[:space:]]*//p' "$DIR/$REP_ROOT/reviews/$base" 2>/dev/null | head -1 | tr -dc '0-9')"
    fi
    human="$(rep_human_dollars "${rounds:-0}" "${words:-0}")"
    agentic="$(plan_field "$pf" agentic_dollars)"; agentic="${agentic:-censored}"
    if [ "$agentic" = censored ]; then aggregate=censored; else
      aggregate="$(awk -v a="$agentic" -v h="$human" 'BEGIN{printf "%.6f", a+h}')"
    fi
    mkdir -p "$DIR/$REP_EVENTS"
    awk -v acc="$accepted" -v hum="$human" -v agg="$aggregate" '
      /^accepted:/ { print "accepted: " acc; next }
      /^human_dollars:/ { print "human_dollars: " hum; next }
      /^aggregate_dollars:/ { print "aggregate_dollars: " agg; next }
      { print }
    ' "$pf" > "$DIR/$REP_EVENTS/$base.md"
    git -C "$DIR" add "$REP_EVENTS/$base.md"
    git -C "$DIR" rm -q "$REP_PENDING/$base.md"
    log "finalized pending event '$base' -> accepted=$accepted"
  done
  [ "$seen" -gt 0 ] && atomic_line "$STATE/pending-cursor" "$last"
  git -C "$DIR" diff --cached --quiet 2>/dev/null && return 1
  local rc=0
  commit_and_push "$DIR" "reputation: finalize pending events ($GARDEN)" || rc=$?
  if [ "$rc" -eq 0 ]; then
    log "pending events finalized; continuing from the accepted checkpoint"
    return 0
  else
    log "pending finalize push failed (rc=$rc); next tick retries"
    return 2
  fi
}

finalize_rc=0; finalize_pending || finalize_rc=$?
[ "$finalize_rc" -ne 2 ] || exit 0
HEAD_SHA="$(git -C "$DIR" rev-parse HEAD)"

# Discover changed inputs into the affected-arm queue.
CURSOR="$(state_value "$STATE/cursor")"
if [ -z "$CURSOR" ] || ! git -C "$DIR" cat-file -e "$CURSOR^{commit}" 2>/dev/null; then
  schedule_rescan "$HEAD_SHA" "$POLICY_SIGNATURE"
  atomic_line "$STATE/cursor" "$HEAD_SHA"
  CURSOR="$HEAD_SHA"
fi
if [ "$(state_value "$STATE/policy-signature")" != "$POLICY_SIGNATURE" ]; then
  schedule_rescan "$HEAD_SHA" "$POLICY_SIGNATURE"
fi

if [ ! -f "$STATE/changes" ] && [ "$CURSOR" != "$HEAD_SHA" ]; then
  git -C "$DIR" diff --name-status --no-renames "$CURSOR..$HEAD_SHA" > "$STATE/changes"
  atomic_line "$STATE/changes-head" "$HEAD_SHA"
  : > "$STATE/changes-cursor"
fi

if [ -f "$STATE/changes" ]; then
  changes_head="$(state_value "$STATE/changes-head")"
  changes_cursor="$(state_value "$STATE/changes-cursor")"
  mapfile -t changed < <(awk -v c="${changes_cursor:-0}" -v n="$DISCOVERY_BATCH" 'NR>c && k<n { print NR "\t" $0; k++ }' "$STATE/changes")
  last_line="${changes_cursor:-0}"
  for row in "${changed[@]}"; do
    line_no="${row%%$'\t'*}"; rest="${row#*$'\t'}"; path="${rest#*$'\t'}"
    last_line="$line_no"
    case "$path" in
      "$REP_EVENTS"/*.md)
        queue_record "$(record_from_revision "$CURSOR" "$path")" 1
        queue_record "$(record_from_revision "$changes_head" "$path")" 1 ;;
      "$REP_ADJUSTMENTS"/*)
        base="${path#"$REP_ADJUSTMENTS"/}"; base="${base%%/*}"; base="${base%.md}"
        queue_record "$(record_from_revision "$changes_head" "$REP_EVENTS/$base.md")" 1 ;;
      "$GARDEN_REP_RATE_CARD") schedule_rescan "$changes_head" "$POLICY_SIGNATURE" 1 ;;
    esac
  done
  atomic_line "$STATE/changes-cursor" "$last_line"
  total_changes="$(wc -l < "$STATE/changes")"
  if [ "$last_line" -ge "$total_changes" ]; then
    atomic_line "$STATE/cursor" "$changes_head"; CURSOR="$changes_head"
    rm -f "$STATE/changes" "$STATE/changes-head" "$STATE/changes-cursor"
  fi
fi

# A rescan reads only a bounded batch of event headers, then checkpoints.
if [ -f "$STATE/rescan-head" ]; then
  rescan_head="$(state_value "$STATE/rescan-head")"
  rescan_cursor="$(state_value "$STATE/rescan-cursor")"
  mapfile -t events < <(git -C "$DIR" ls-tree -r --name-only "$rescan_head" -- "$REP_EVENTS" \
    | awk -v c="$rescan_cursor" -v n="$DISCOVERY_BATCH" '$0>c && k<n { print; k++ }')
  for path in "${events[@]}"; do
    queue_record "$(record_from_revision "$rescan_head" "$path")"
    atomic_line "$STATE/rescan-cursor" "$path"
  done
  if [ "${#events[@]}" -lt "$DISCOVERY_BATCH" ]; then
    atomic_line "$STATE/policy-signature" "$(state_value "$STATE/rescan-signature")"
    rm -f "$STATE/rescan-head" "$STATE/rescan-signature" "$STATE/rescan-cursor"
    log "affected-arm discovery checkpoint complete"
  else
    log "affected-arm discovery checkpoint saved (${#events[@]} events examined)"
  fi
fi

# Resumably recompute one queued arm. The event-file budget is a hard bound for
# this tick; wallclock history is queried only for matching censored events.
start_active_arm() {
  local rec
  rec="$(head -1 "$QUEUE" 2>/dev/null || true)"; [ -n "$rec" ] || return 1
  printf '%s\n' "$rec" > "$STATE/active-record"
  atomic_line "$STATE/active-rel" "${rec##*$'\t'}"
  atomic_line "$STATE/active-head" "$(git -C "$DIR" rev-parse HEAD)"
  : > "$STATE/active-cursor"; : > "$STATE/active.dat"
}

event_sample() {
  local ef="$1" base="$2" provider="$3" model="$4" tht="$5"
  local accepted agg adjusted dur hum span secs estd
  accepted="$(plan_field "$ef" accepted)"; agg="$(plan_field "$ef" aggregate_dollars)"
  adjusted="$(rep_adjusted_agentic_dollars "$DIR" "$base")"
  if [ -n "$adjusted" ]; then printf '%s %s adjustment\n' "${accepted:-false}" "$adjusted"; return; fi
  if [ "$agg" != censored ] && rep_provider_is_flat "$provider" \
     && [ -z "$(plan_field "$ef" demerit)" ]; then agg=censored; fi
  case "$agg" in
    ''|censored)
      dur="$(plan_field "$ef" duration_secs)"; hum="$(plan_field "$ef" human_dollars)"
      span="$(rep_wallclock_index "$DIR" "$base" 2>/dev/null | awk -v b="$base" '$1==b {v=$2} END{print v}')"
      secs="$(rep_proxy_secs "${span:-}" "${dur:-0}")"
      estd="$(rep_estimated_dollars "$DIR" "$provider" "$model" "$tht" "$secs" "${hum:-0}")"
      if [ "$estd" = censored ]; then printf '%s CENSORED none\n' "${accepted:-false}"
      else printf '%s %s wallclock\n' "${accepted:-false}" "$estd"; fi ;;
    *) printf '%s %s ledger\n' "${accepted:-false}" "$agg" ;;
  esac
}

write_active_projection() {
  local rec kind provider model tht wc tgt rel stats att acc cen est mean m2 ar spell srel
  rec="$(cat "$STATE/active-record")"
  IFS=$'\t' read -r kind provider model tht wc tgt rel <<<"$rec"
  [ -s "$STATE/active.dat" ] || { log "arm '$rel' has no events; leaving its prior projection untouched"; return; }
  stats="$(awk '
    { af=$1; d=$2; src=$3; att++; if (af=="true") acc++;
      if (src!="ledger") cen++; if (src=="wallclock") est++;
      if (d=="CENSORED") next;
      n++; delta=d-mean; mean+=delta/n; m2+=delta*(d-mean); sumd+=d }
    END { rate=(att>0)?acc/att:0;
      md=(acc>0 && n>0)?((n==att)?sumd/acc:(sumd/n)/rate):0;
      printf "%d %d %d %d %.6f %.6f\n", att+0,acc+0,cen+0,est+0,md,m2+0 }' "$STATE/active.dat")"
  read -r att acc cen est mean m2 <<<"$stats"
  ar="$(awk -v a="$acc" -v t="$att" 'BEGIN{printf "%.4f",(t>0)?a/t:0}')"
  local -a spellings=("$kind"); case "$kind" in monk) spellings+=(gardener);; gardener) spellings+=(monk);; esac
  for spell in "${spellings[@]}"; do
    srel="$(rep_arm_relpath "$spell" "$provider" "$model" "$tht" "$wc" "$tgt")"
    mkdir -p "$DIR/$(dirname "$srel")"
    {
      printf 'kind: %s\nprovider: %s\nmodel: %s\nthoughtfulness: %s\n' "$spell" "$provider" "$model" "$tht"
      printf 'work_class: %s\ntarget: %s\nattempts: %s\naccepts: %s\n' "$wc" "$tgt" "$att" "$acc"
      printf 'censored: %s\nestimated: %s\nmean_dollars: %s\nm2: %s\nacceptance_rate: %s\n' "$cen" "$est" "$mean" "$m2" "$ar"
    } > "$DIR/$srel"
    git -C "$DIR" add "$srel"
  done
}

remaining="$EVENT_BUDGET"
while [ "$remaining" -gt 0 ]; do
  if [ ! -f "$STATE/active-record" ]; then start_active_arm || break; fi
  active_head="$(state_value "$STATE/active-head")"; active_cursor="$(state_value "$STATE/active-cursor")"
  mapfile -t batch < <(git -C "$DIR" ls-tree -r --name-only "$active_head" -- "$REP_EVENTS" \
    | awk -v c="$active_cursor" -v n="$remaining" '$0>c && k<n { print; k++ }')
  IFS=$'\t' read -r _ ap am at _ _ arl < "$STATE/active-record"
  for path in "${batch[@]}"; do
    tmp="$STATE/event.$$"
    if git -C "$DIR" show "$active_head:$path" > "$tmp" 2>/dev/null; then
      rec="$(event_arm_record "$tmp")"
      if [ -n "$rec" ] && [ "${rec##*$'\t'}" = "$arl" ]; then
        base="$(basename "$path" .md)"
        event_sample "$tmp" "$base" "$ap" "$am" "$at" >> "$STATE/active.dat"
      fi
    fi
    rm -f "$tmp"; atomic_line "$STATE/active-cursor" "$path"
  done
  examined="${#batch[@]}"; remaining=$((remaining - examined))
  if [ "$examined" -lt "$((remaining + examined))" ]; then
    write_active_projection
    rc=0
    if git -C "$DIR" diff --cached --quiet 2>/dev/null; then rc=2
    else commit_and_push "$DIR" "reputation: update affected arm projection ($GARDEN)" || rc=$?; fi
    if [ "$rc" -eq 0 ] || [ "$rc" -eq 2 ]; then
      tmp="$QUEUE.tmp.$$"; tail -n +2 "$QUEUE" > "$tmp"; mv "$tmp" "$QUEUE"
      rm -f "$STATE/active-head" "$STATE/active-rel" "$STATE/active-record" \
        "$STATE/active-cursor" "$STATE/active.dat"
      log "affected arm projection checkpoint committed"
    else
      log "projection push failed (rc=$rc); active arm checkpoint retained"
      break
    fi
  else
    log "active arm scan checkpoint saved ($examined events examined; more deferred)"
    break
  fi
done

clone_unlock "$DIR"
if [ -s "$QUEUE" ] || [ -f "$STATE/rescan-head" ] || [ -f "$STATE/changes" ]; then
  log "reputation reduction deferred with resumable work remaining"
else
  log "reputation projections current at $(state_value "$STATE/cursor")"
fi
