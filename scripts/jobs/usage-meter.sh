#!/bin/bash
# usage-meter.sh — a deterministic weekly token meter for the fleet, sourced from
# Claude Code's own session logs (ccusage-style).
#
# Source this; do not execute it. common.sh sources it so every job-board script
# (and any `claude -p` handler) inherits the helpers.
#
# WHY this exists: the foreman is where the garden spends tokens autonomously — it
# promotes deferred plan jobs and generates new milestone steps via `claude -p`,
# each of which can ignite a full design/build/panel chain. Before that pump the
# foreman must check, in PLAIN CODE with NO LLM, whether the garden is at risk of
# hitting its weekly token quota, and back off if so.
#
# THE BILLING MODEL: each Anthropic host maps one-to-one to its own Claude Max x20
# subscription — NOT an API key. The Admin Usage & Cost API
# (/v1/organizations/usage_report) is API-key / Console-billing only and does NOT
# apply to a subscription, so it is deliberately NOT wired here.
#
# THE USAGE SOURCE (primary, authoritative):
#   Claude Code already records every assistant turn's token `usage` to its own
#   session logs at ~/.claude/projects/**/*.jsonl. Each assistant-turn line carries
#   a top-level `.timestamp` (ISO-8601) and a `.message.usage` object with
#   `input_tokens`, `output_tokens`, `cache_creation_input_tokens`, and
#   `cache_read_input_tokens`. meter_window_total sums BILLABLE tokens over the
#   trailing window from these logs — deterministically, in plain code (jq over the
#   JSONL). This is the same data ccusage reads; it needs no API key and no
#   external dashboard. The session logs are the SINGLE SOURCE OF TRUTH for "tokens
#   spent in the trailing window".
#
#   DEDUP: a single assistant message id appears on MULTIPLE log lines (one per
#   streamed content block), each repeating the message's final `usage`. We dedup
#   by message id (first occurrence wins) so re-reads never double-count.
#
#   BILLABLE definition: input + output + cache_creation (cache_read EXCLUDED — it
#   bills at a small fraction and would otherwise dominate the sum and trip the
#   back-off far too early). This matches how the Max plan's spend tracks most
#   closely. To adjust, set GARDEN_TOKEN_COUNT_CACHE_READ=1 to also fold in
#   cache_read_input_tokens (the most likely tuning knob); the formula itself lives
#   in _meter_session_total and is a one-line change otherwise.
#
# THE LEDGER (optional fallback ONLY):
#   The hand-/handler-appended TSV ledger (meter_record / meter_claude, below) is
#   retained as a FALLBACK consulted only when the session-log directory is missing
#   or unreadable. It is no longer the primary source. Ledger format (TSV,
#   append-only, host-local): <epoch-seconds>\t<billable-tokens>.
#
# MULTI-HOST: ~/.claude is PER-HOST and each current subscription belongs to one
# host, so the local sum is exactly the corresponding account's spend. Each host's
# scaler publishes a cadence-bucketed exact reading under budget/live/<host> for
# the leader's fleet-wide checks. If one subscription is ever shared by multiple
# hosts, its pool must aggregate those hosts before this one-host/account topology
# is changed.
#
# THE WEEK BOUNDARY: the subscription reset is known: Friday 20:00
# America/Los_Angeles. The default meter window begins at the most recent such
# anchor (DST-aware). The admission predicate requests that anchored view;
# meter_window_total itself retains its historical rolling-window interface for
# reports and compatibility callers.
#
# FAIL-OPEN: a missing or unreadable meter must NEVER wedge the pump. When the
# quota is unset the meter is simply OFF (gating disabled). When the quota is set
# but neither source can be read, meter_quota_status returns `unknown` and the
# caller proceeds with a logged warning — a broken meter can slow nothing to a
# halt. Only a CONFIRMED at/over-high-water reading backs the pump off.
#
# All helpers are best-effort and never abort their caller (callers run under
# `set -e`); recording failures are swallowed, reads degrade to `unknown`.

# --- configuration (all overridable) ----------------------------------------

# The weekly token ceiling. UNSET/0 means the meter is OFF (no gating) — the safe
# default until the maintainer sets the real Max x20 ceiling for this fleet (it is
# not machine-readable from the subscription; surface it as an open question and
# wire it via the foreman unit env / a journal-tracked config). See the foreman
# unit (scripts/systemd/garden-foreman.service) for where to set it.
: "${GARDEN_TOKEN_WEEKLY_QUOTA:=0}"
# High-water mark as a fraction of the quota; at/over this the foreman backs off.
: "${GARDEN_TOKEN_BACKOFF_FRACTION:=0.85}"
# The rolling-window compatibility/reporting default. The quota gate itself uses
# the anchor explicitly.
: "${GARDEN_TOKEN_WINDOW_SECS:=604800}"
: "${GARDEN_TOKEN_RESET_TZ:=America/Los_Angeles}"
: "${GARDEN_TOKEN_RESET_DOW:=5}"       # ISO weekday: Friday
: "${GARDEN_TOKEN_RESET_HHMM:=20:00}"
# PRIMARY SOURCE: Claude Code's session-log directory (per-host). Overridable for
# tests and for a non-default ~/.claude location.
: "${GARDEN_CCUSAGE_LOGDIR:=${HOME:-/home/$(id -un 2>/dev/null || echo kris)}/.claude/projects}"
# Set to 1 to also count cache_read_input_tokens as billable (default: excluded).
: "${GARDEN_TOKEN_COUNT_CACHE_READ:=0}"
# FALLBACK SOURCE: the host-local rolling ledger. Outside any reset-prone worktree.
: "${GARDEN_USAGE_LEDGER:=$GARDEN_STATE/usage/ledger}"
# Soft cap on ledger lines before an opportunistic prune of out-of-window rows.
: "${GARDEN_USAGE_LEDGER_MAXLINES:=20000}"
: "${GARDEN_BUDGET_SNAPSHOT_SECS:=900}"
: "${GARDEN_BUDGET_SNAPSHOT_MAX_AGE:=1800}"
: "${GARDEN_BUDGET_PUBLISH_ATTEMPTS:=3}"

# Wall clock in epoch seconds, overridable for deterministic tests.
meter_now() { printf '%s\n' "${GARDEN_USAGE_NOW:-$(date +%s)}"; }

# meter_week_anchor_epoch [now] — most recent Friday 20:00 Pacific at-or-before
# now. Local-date arithmetic, rather than subtracting 604800 seconds, preserves
# the wall-clock reset across DST changes. Parse/tooling failure is unknown
# upstream and therefore fail-open.
meter_week_anchor_epoch() {
  local now="${1:-$(meter_now)}" tz="$GARDEN_TOKEN_RESET_TZ"
  local dow="$GARDEN_TOKEN_RESET_DOW" hhmm="$GARDEN_TOKEN_RESET_HHMM"
  local cur today back day anchor
  [[ "$now" =~ ^[0-9]+$ ]] || return 1
  cur="$(TZ="$tz" date -d "@$now" +%u 2>/dev/null)" || return 1
  today="$(TZ="$tz" date -d "@$now" +%Y-%m-%d 2>/dev/null)" || return 1
  back=$(( (cur - dow + 7) % 7 ))
  day="$(TZ="$tz" date -d "$today $back days ago" +%Y-%m-%d 2>/dev/null)" || return 1
  anchor="$(TZ="$tz" date -d "$day $hhmm" +%s 2>/dev/null)" || return 1
  if [ "$anchor" -gt "$now" ]; then
    anchor="$(TZ="$tz" date -d "$day $hhmm 7 days ago" +%s 2>/dev/null)" || return 1
  fi
  printf '%s\n' "$anchor"
}

meter_next_reset_epoch() {
  local now="${1:-$(meter_now)}" anchor day
  anchor="$(meter_week_anchor_epoch "$now")" || return 1
  day="$(TZ="$GARDEN_TOKEN_RESET_TZ" date -d "@$anchor" +%Y-%m-%d 2>/dev/null)" || return 1
  TZ="$GARDEN_TOKEN_RESET_TZ" date -d "$day $GARDEN_TOKEN_RESET_HHMM 7 days" +%s 2>/dev/null
}

meter_window_cutoff() {
  local now window="${1:-$GARDEN_TOKEN_WINDOW_SECS}"
  now="$(meter_now)"; [[ "$now" =~ ^[0-9]+$ ]] || return 1
  if [ "$window" = anchor ]; then
    meter_week_anchor_epoch "$now"
  else
    [[ "$window" =~ ^[1-9][0-9]*$ ]] || return 1
    printf '%s\n' "$((now - window))"
  fi
}

# meter_record <billable-tokens> — append one usage event to the FALLBACK ledger.
# Ignores empty/non-integer/zero input. Atomic append; never fails the caller.
# (The ledger is a fallback only; the primary source is the session logs.)
meter_record() {
  local tokens="${1:-}" ledger="$GARDEN_USAGE_LEDGER" n
  case "$tokens" in ''|*[!0-9]*) return 0 ;; esac
  [ "$tokens" -gt 0 ] || return 0
  mkdir -p "$(dirname "$ledger")" 2>/dev/null || return 0
  printf '%s\t%s\n' "$(meter_now)" "$tokens" >> "$ledger" 2>/dev/null || true
  # Opportunistic prune so the ledger cannot grow without bound.
  n="$(wc -l < "$ledger" 2>/dev/null || echo 0)"
  [ "${n:-0}" -gt "$GARDEN_USAGE_LEDGER_MAXLINES" ] && meter_prune
  return 0
}

# meter_prune — drop ledger rows older than the window. Guarded by a non-blocking
# flock so a concurrent recorder is never disturbed (skip the prune rather than
# block); a rare lost prune just defers cleanup to a later append. Best-effort.
meter_prune() {
  local ledger="$GARDEN_USAGE_LEDGER" lf cutoff tmp fd
  [ -f "$ledger" ] || return 0
  lf="${ledger}.lock"
  exec {fd}>>"$lf" 2>/dev/null || return 0
  if flock -n "$fd"; then
    cutoff=$(( "$(meter_now)" - GARDEN_TOKEN_WINDOW_SECS ))
    tmp="$(mktemp "${ledger}.XXXXXX" 2>/dev/null)" || { exec {fd}>&- 2>/dev/null || true; return 0; }
    if awk -F'\t' -v c="$cutoff" '($1+0)>=c' "$ledger" > "$tmp" 2>/dev/null; then
      mv -f "$tmp" "$ledger" 2>/dev/null || rm -f "$tmp" 2>/dev/null
    else
      rm -f "$tmp" 2>/dev/null
    fi
  fi
  exec {fd}>&- 2>/dev/null || true
  return 0
}

# _meter_session_total <logdir> <cutoff-epoch> — sum BILLABLE tokens from Claude
# Code session JSONL under <logdir>, deduped by message id (first occurrence
# wins), counting only assistant turns whose timestamp epoch is >= <cutoff>.
# Prints the integer sum on stdout. Returns:
#   0 with <sum>  on a successful scan (sum may legitimately be 0),
#   1             on a tooling error (no jq, find failed) → unknown upstream.
# Resilient to individual malformed log lines (jq -R 'fromjson? // empty' skips
# them) so one corrupt line never blinds the meter.
_meter_session_total() {
  local logdir="$1" cutoff="$2" inccr listing rc sum
  command -v jq >/dev/null 2>&1 || return 1   # cannot parse JSON → unknown (fail open)

  # Normalize the cache_read toggle to a strict 0/1 for jq --argjson.
  case "${GARDEN_TOKEN_COUNT_CACHE_READ:-0}" in 1|true|yes|on) inccr=1 ;; *) inccr=0 ;; esac

  # Only files modified at/after the cutoff can hold in-window turns (logs are
  # append-only with monotonically increasing timestamps), so prune by mtime to
  # bound the scan over what may be thousands of session files. find exits non-zero
  # if the dir is unreadable or -newermt is unsupported → treat as unknown.
  listing="$(find "$logdir" -maxdepth 6 -type f -name '*.jsonl' -newermt "@$cutoff" 2>/dev/null)"; rc=$?
  [ "$rc" -ne 0 ] && return 1
  [ -z "$listing" ] && { printf '0\n'; return 0; }   # no in-window logs → genuine 0

  # Per-line: parse (skipping malformed), keep assistant turns carrying usage,
  # emit  <message-id>\t<epoch>\t<billable-tokens>. Strip fractional seconds before
  # fromdateiso8601 (jq 1.7 cannot parse ".506Z"); a missing/unparseable timestamp
  # yields -1 so it falls out of any positive-cutoff window.
  sum="$(printf '%s\n' "$listing" | tr '\n' '\0' | xargs -0 jq -Rr --argjson cr "$inccr" '
            fromjson? // empty
            | select(.type=="assistant" and (.message.usage != null))
            | [ (.message.id // .uuid // "noid"),
                ((.timestamp // "") | sub("\\.[0-9]+Z$";"Z") | (fromdateiso8601? // -1)),
                ( (.message.usage.input_tokens // 0)
                  + (.message.usage.output_tokens // 0)
                  + (.message.usage.cache_creation_input_tokens // 0)
                  + (if $cr == 1 then (.message.usage.cache_read_input_tokens // 0) else 0 end) ) ]
            | @tsv' 2>/dev/null \
        | awk -F'\t' -v c="$cutoff" '
            !seen[$1]++ { if (($2 + 0) >= c) s += ($3 + 0) }
            END { printf "%d\n", s + 0 }')"
  case "$sum" in ''|*[!0-9]*) return 1 ;; esac
  printf '%s\n' "$sum"
  return 0
}

# meter_window_total [<window-secs>] — sum billable tokens within the trailing
# window. Prefers Claude Code session logs (primary); falls back to the legacy
# ledger only if the log dir is missing/unreadable. Prints the integer total.
# Returns:
#   0 with <sum> when a source was read OK (sum may be 0),
#   1            when no source could be read (→ `unknown` upstream → fail open).
meter_window_total() {
  local window="${1:-$GARDEN_TOKEN_WINDOW_SECS}" cutoff ledger
  cutoff="$(meter_window_cutoff "$window")" || return 1

  # PRIMARY: Claude Code session logs.
  if [ -d "$GARDEN_CCUSAGE_LOGDIR" ] && [ -r "$GARDEN_CCUSAGE_LOGDIR" ] && [ -x "$GARDEN_CCUSAGE_LOGDIR" ]; then
    _meter_session_total "$GARDEN_CCUSAGE_LOGDIR" "$cutoff" && return 0
    # session scan failed (no jq / find error) → try the ledger, else unknown.
  fi

  # FALLBACK: the legacy handler-appended ledger.
  ledger="$GARDEN_USAGE_LEDGER"
  if [ -f "$ledger" ] && [ -r "$ledger" ]; then
    awk -F'\t' -v c="$cutoff" '($1+0)>=c { s += ($2+0) } END { printf "%d\n", s+0 }' "$ledger" 2>/dev/null && return 0
    return 1
  fi

  # Neither source available → unknown (fail open upstream).
  return 1
}

# budget_pool_file [journal-dir] — resolve journal config without performing a
# fetch. Admission callers pass their freshly-synced clone; handler backstops can
# discover one of the normal service clones. Missing config means meter-off.
budget_pool_file() {
  local dir="${1:-}" f
  if [ -n "${GARDEN_BUDGET_POOLS_FILE:-}" ]; then
    [ -r "$GARDEN_BUDGET_POOLS_FILE" ] && printf '%s\n' "$GARDEN_BUDGET_POOLS_FILE"
    return
  fi
  if [ -n "$dir" ]; then
    [ -r "$dir/config/budget-pools" ] && printf '%s\n' "$dir/config/budget-pools"
    return
  fi
  for f in "${GARDEN_WORKER_CLONE:-}" "${GARDEN_GARDENER_CLONE:-}" \
           "${GARDEN_PRODUCER_CLONE:-}" "$GARDEN_STATE"/*/journal; do
    [ -n "$f" ] && [ -r "$f/config/budget-pools" ] || continue
    printf '%s\n' "$f/config/budget-pools"; return
  done
  return 1
}

# budget_pool_row <pool> [journal-dir] — print the normalized five-column row.
budget_pool_row() {
  local pool="$1" file
  file="$(budget_pool_file "${2:-}")" || return 1
  awk -v want="$pool" '
    /^[[:space:]]*#/ || /^[[:space:]]*$/ { next }
    $1 == want { print $1 "\t" $2 "\t" $3 "\t" $4 "\t" $5; found=1; exit }
    END { if (!found) exit 1 }
  ' "$file" 2>/dev/null
}

budget_pool_for_provider_host() {
  local provider="$1" host="${2:-$GARDEN}" dir="${3:-}" candidate
  candidate="$provider:$host"
  if budget_pool_row "$candidate" "$dir" >/dev/null 2>&1; then printf '%s\n' "$candidate"; else printf '%s\n' "$provider"; fi
}

meter_verdict() {
  local total="$1" quota="$2" frac="${3:-$GARDEN_TOKEN_BACKOFF_FRACTION}"
  if awk -v t="$total" -v q="$quota" -v f="$frac" 'BEGIN { exit !(t >= q*f) }'; then
    printf 'backoff\n'
  else
    printf 'ok\n'
  fi
}

# Journal fallback for a remote Anthropic account. The local account always uses
# session logs; a leader cannot read another host's ~/.claude, so the immutable
# per-job ledger supplies the best available remote reading. Unmetered/malformed
# rows make the remote status unknown (fail-open), never an invented zero.
meter_journal_host_tokens() {
  local dir="$1" host="$2" cutoff="$3" files
  [ -d "$dir/usage" ] && command -v jq >/dev/null 2>&1 || return 1
  files=("$dir"/usage/*.jsonl)
  [ -e "${files[0]}" ] || { printf '0\n'; return 0; }
  jq -sre --arg host "$host" --argjson cutoff "$cutoff" '
    [ .[] | select(.host == $host)
      | select((.ts | fromdateiso8601? // -1) >= $cutoff) ] as $rows
    | if any($rows[];
        (.source? == "none") or
        ([.input_tokens?,.output_tokens?,.cache_creation_tokens?] | any(. == null or type != "number" or . < 0)))
      then error("unmetered")
      else reduce $rows[] as $r (0; . + $r.input_tokens + $r.output_tokens + $r.cache_creation_tokens)
      end
  ' "${files[@]}" 2>/dev/null
}

# meter_remote_snapshot_total <journal-dir> <pool> <cap> <cutoff> — consume the
# exact session-log reading published by that pool's owning host. Stale/mismatched
# snapshots are unknown, never trusted as a lower bound.
meter_remote_snapshot_total() {
  local dir="$1" pool="$2" cap="$3" cutoff="$4" host file p c w s at now max_age
  max_age="$GARDEN_BUDGET_SNAPSHOT_MAX_AGE"; [[ "$max_age" =~ ^[1-9][0-9]*$ ]] || max_age=1800
  host="${pool#*:}"; file="$dir/budget/live/$host"
  [ -r "$file" ] || return 1
  p="$(sed -n 's/^pool:[[:space:]]*//p' "$file" | head -1)"
  c="$(sed -n 's/^cap:[[:space:]]*//p' "$file" | head -1)"
  w="$(sed -n 's/^window_start_epoch:[[:space:]]*//p' "$file" | head -1)"
  s="$(sed -n 's/^spend:[[:space:]]*//p' "$file" | head -1)"
  at="$(sed -n 's/^sampled_at_epoch:[[:space:]]*//p' "$file" | head -1)"
  now="$(meter_now)"
  [ "$p" = "$pool" ] && [ "$c" = "$cap" ] && [ "$w" = "$cutoff" ] \
    && [[ "$s" =~ ^[0-9]+$ ]] && [[ "$at" =~ ^[0-9]+$ ]] && [[ "$now" =~ ^[0-9]+$ ]] \
    && [ "$at" -le $((now + 60)) ] && [ $((now - at)) -le "$max_age" ] \
    || return 1
  printf '%s\n' "$s"
}

# _budget_publish_local_pool_once <synced-journal-clone> — build and CAS-publish
# one snapshot attempt from the clone's current journal tip. A retry must call
# this again after sync_clone: pool configuration, the anchored meter reading,
# zone, and cadence bucket may all have changed while the first push raced.
_budget_publish_local_pool_once() {
  local dir="$1" pool="anthropic:$GARDEN" row _provider _account kind cap
  local cutoff spend now bucket file old_bucket old_status status rc snapshot_secs
  row="$(budget_pool_row "$pool" "$dir" 2>/dev/null)" || return 0
  IFS=$'\t' read -r _ _provider _account kind cap <<<"$row"
  [ "$kind" = weekly-tokens ] && [[ "$cap" =~ ^[1-9][0-9]*$ ]] || return 0
  cutoff="$(meter_window_cutoff anchor)" || return 0
  spend="$(meter_window_total anchor)" || return 0
  now="$(meter_now)"; [[ "$now" =~ ^[0-9]+$ ]] || return 0
  snapshot_secs="$GARDEN_BUDGET_SNAPSHOT_SECS"; [[ "$snapshot_secs" =~ ^[1-9][0-9]*$ ]] || snapshot_secs=900
  bucket=$((now / snapshot_secs))
  file="$dir/budget/live/$GARDEN"
  old_bucket="$(sed -n 's/^sample_bucket:[[:space:]]*//p' "$file" 2>/dev/null | head -1)"
  [ "$old_bucket" != "$bucket" ] || return 0
  old_status="$(sed -n 's/^status:[[:space:]]*//p' "$file" 2>/dev/null | head -1)"
  status="$(meter_verdict "$spend" "$cap")"
  mkdir -p "$(dirname "$file")"
  {
    printf 'pool: %s\n' "$pool"
    printf 'host: %s\n' "$GARDEN"
    printf 'window_start_epoch: %s\n' "$cutoff"
    printf 'spend: %s\n' "$spend"
    printf 'cap: %s\n' "$cap"
    printf 'status: %s\n' "$status"
    printf 'sampled_at_epoch: %s\n' "$now"
    printf 'sampled_at: %s\n' "$(date -u -d "@$now" +%FT%TZ)"
    printf 'sample_bucket: %s\n' "$bucket"
  } > "$file"
  git -C "$dir" add "budget/live/$GARDEN"
  rc=0; commit_and_push "$dir" "budget-live($GARDEN) $status spend=$spend/$cap" || rc=$?
  if [ "$rc" -eq 0 ] || [ "$rc" -eq 2 ]; then
    if [ "$old_status" != "$status" ] && { [ -n "$old_status" ] || [ "$status" = backoff ]; }; then
      alert_maintainer "budget-zone-$GARDEN-$status" \
        "budget pool $pool changed zone ${old_status:-unpublished} -> $status at spend=$spend of cap=$cap (high-water $GARDEN_TOKEN_BACKOFF_FRACTION; Friday $GARDEN_TOKEN_RESET_HHMM Pacific window)."
    fi
    return 0
  fi
  return 1
}

# budget_publish_local_pool <synced-journal-clone> — every host's existing scaler
# timer publishes a cadence-bucketed exact session-log reading. This is the small
# cross-host bridge the leader needs for fleet admission/leveling; at most one
# journal commit per host per snapshot bucket. A lost journal CAS is retried
# boundedly in the same scaler tick: re-sync, rebuild from the winning journal
# tip, then try publication again. Exhaustion merely leaves the remote verdict
# unknown (fail-open); worker reconciliation still proceeds.
budget_publish_local_pool() {
  local dir="$1" attempts="$GARDEN_BUDGET_PUBLISH_ATTEMPTS" attempt rc
  [[ "$attempts" =~ ^[1-9][0-9]*$ ]] || attempts=3

  if _budget_publish_local_pool_once "$dir"; then rc=0; else rc=$?; fi
  [ "$rc" -eq 0 ] && return 0

  for attempt in $(seq 2 "$attempts"); do
    backoff "$((attempt - 1))"
    # sync_clone exits with EX_TEMPFAIL for an offline journal. Contain that exit
    # so snapshot publication remains fail-open and the scaler reaches its normal
    # warning latch plus worker reconciliation path.
    if ( sync_clone "$dir"; _budget_publish_local_pool_once "$dir" ); then
      return 0
    fi
  done
  return 1
}

# The scaler runs every minute, but publication is deliberately fail-open: a
# failed push changes only remote budget visibility, never worker reconciliation.
# Keep that recurring controller failure edge-triggered so one outage reads as
# one incident rather than a minute-scale stream of identical WARNs. The latch is
# host-local (like the scaler itself); a successful publisher call claims and
# clears it, emitting one summary before the next outage is re-armed.
budget_publish_note_failure() {
  local latch="${GARDEN_BUDGET_PUBLISH_OUTAGE_LATCH:-$GARDEN_STATE/gardener-scaler/budget-publish-outage}"
  local count tmp
  mkdir -p "$(dirname "$latch")" 2>/dev/null || true
  if mkdir "$latch" 2>/dev/null; then
    date -u +%FT%TZ > "$latch/since" 2>/dev/null || true
    date -u +%s > "$latch/since_epoch" 2>/dev/null || true
    printf '1\n' > "$latch/failures" 2>/dev/null || true
    log "WARN: could not publish live budget snapshot; remote admission remains fail-open (further repeats suppressed until recovery)"
    return 0
  fi
  if [ -d "$latch" ]; then
    count="$(cat "$latch/failures" 2>/dev/null || true)"
    [[ "$count" =~ ^[1-9][0-9]*$ ]] || count=1
    count=$((count + 1))
    tmp="$latch/failures.$$"
    if printf '%s\n' "$count" > "$tmp" 2>/dev/null; then
      mv "$tmp" "$latch/failures" 2>/dev/null || true
    fi
    return 0
  fi
  # If local state is unwritable, preserve the diagnostic instead of silently
  # losing every failure; only the deduplication degrades.
  log "WARN: could not publish live budget snapshot; remote admission remains fail-open (warning latch unavailable)"
  return 0
}

budget_publish_note_success() {
  local latch="${GARDEN_BUDGET_PUBLISH_OUTAGE_LATCH:-$GARDEN_STATE/gardener-scaler/budget-publish-outage}"
  local claimed since since_epoch now elapsed count
  [ -d "$latch" ] || return 0
  claimed="$latch.recovered.$$"
  if mv "$latch" "$claimed" 2>/dev/null; then
    since="$(cat "$claimed/since" 2>/dev/null || true)"
    since_epoch="$(cat "$claimed/since_epoch" 2>/dev/null || true)"
    count="$(cat "$claimed/failures" 2>/dev/null || true)"
    [[ "$count" =~ ^[1-9][0-9]*$ ]] || count=1
    now="$(date -u +%s)"
    elapsed=""
    if [[ "$since_epoch" =~ ^[0-9]+$ ]] && [ "$now" -ge "$since_epoch" ]; then
      elapsed=$((now - since_epoch))
    fi
    rm -rf "$claimed" 2>/dev/null || true
    log "live budget snapshot publication recovered after $count failed scaler tick(s)${elapsed:+ over ${elapsed}s}${since:+ (outage since $since)}; remote admission visibility restored"
  fi
  return 0
}

meter_journal_provider_usd() {
  local dir="$1" provider="$2" cutoff="$3" files
  [ -d "$dir/usage" ] && command -v jq >/dev/null 2>&1 || return 1
  files=("$dir"/usage/*.jsonl)
  [ -e "${files[0]}" ] || { printf '0\n'; return 0; }
  jq -sre --arg provider "$provider" --argjson cutoff "$cutoff" '
    [ .[] | select(.provider? == $provider)
      | select((.ts | fromdateiso8601? // -1) >= $cutoff) ] as $rows
    | if any($rows[]; (.total_cost_usd? | type) != "number" or .total_cost_usd < 0)
      then error("unpriced")
      else reduce $rows[] as $r (0; . + $r.total_cost_usd)
      end
  ' "${files[@]}" 2>/dev/null
}

# meter_quota_status [pool [journal-dir]] — the deterministic admission verdict.
# With no pool it preserves the historical current-host interface, deriving that
# host's quota from config/budget-pools when the environment did not set one.
# exactly one word and always returns 0:
#   off      — no quota configured; gating disabled (proceed silently).
#   unknown  — quota set but the meter could not be read (proceed, but WARN).
#   ok       — under the high-water mark (proceed).
#   backoff  — at/over the high-water mark (pause the pump).
meter_quota_status() {
  local pool="${1:-}" dir="${2:-}" quota="${GARDEN_TOKEN_WEEKLY_QUOTA:-0}"
  local row provider account kind total cutoff
  if [ -z "$pool" ]; then
    pool="anthropic:$GARDEN"
    if row="$(budget_pool_row "$pool" "$dir" 2>/dev/null)"; then
      IFS=$'\t' read -r _ provider account kind quota <<<"$row"
      export GARDEN_TOKEN_WEEKLY_QUOTA="$quota"
    else
      case "$quota" in ''|0|*[!0-9]*) printf 'off\n'; return 0 ;; esac
      # The environment-only compatibility path retains its historical explicit
      # rolling window. Journal-configured pools below use the fixed reset anchor.
      total="$(meter_window_total "$GARDEN_TOKEN_WINDOW_SECS")" || { printf 'unknown\n'; return 0; }
      meter_verdict "$total" "$quota"; return 0
    fi
  else
    row="$(budget_pool_row "$pool" "$dir" 2>/dev/null)" || { printf 'off\n'; return 0; }
    IFS=$'\t' read -r _ provider account kind quota <<<"$row"
  fi

  case "$kind" in
    unmetered) printf 'ok\n'; return 0 ;;
    weekly-tokens)
      case "$quota" in ''|0|*[!0-9]*) printf 'off\n'; return 0 ;; esac
      if [ "$provider" != anthropic ]; then printf 'unknown\n'; return 0; fi
      if [ "$account" = "$GARDEN" ]; then
        export GARDEN_TOKEN_WEEKLY_QUOTA="$quota"
        total="$(meter_window_total anchor)" || { printf 'unknown\n'; return 0; }
      else
        cutoff="$(meter_window_cutoff anchor)" || { printf 'unknown\n'; return 0; }
        total="$(meter_remote_snapshot_total "$dir" "$pool" "$quota" "$cutoff" 2>/dev/null || true)"
        if ! [[ "$total" =~ ^[0-9]+$ ]]; then
          total="$(meter_journal_host_tokens "$dir" "$account" "$cutoff")" || { printf 'unknown\n'; return 0; }
        fi
      fi
      ;;
    weekly-usd)
      [[ "$quota" =~ ^[0-9]+([.][0-9]+)?$ ]] || { printf 'off\n'; return 0; }
      cutoff="$(meter_window_cutoff anchor)" || { printf 'unknown\n'; return 0; }
      total="$(meter_journal_provider_usd "$dir" "$provider" "$cutoff")" || { printf 'unknown\n'; return 0; }
      ;;
    *) printf 'unknown\n'; return 0 ;;
  esac
  meter_verdict "$total" "$quota"
}

# pool_admits <pool> [journal-dir] — print the verdict and return false only for
# confirmed backoff. Unknown/off are deliberately true: every caller fails open.
pool_admits() {
  local status
  status="$(meter_quota_status "$1" "${2:-}")"
  printf '%s\n' "$status"
  [ "$status" != backoff ]
}

# budget_fleet_status [journal-dir] — backoff only when every configured bounded
# pool is confirmed backoff. A missing/unreadable/off pool keeps admission open.
budget_fleet_status() {
  local dir="${1:-}" file pool _provider _account kind _cap status seen=0
  file="$(budget_pool_file "$dir")" || { printf 'off\n'; return 0; }
  while IFS=$'\t ' read -r pool _provider _account kind _cap _rest; do
    case "$pool" in ''|'#'*) continue ;; esac
    [ "$kind" != unmetered ] || continue
    seen=1
    status="$(meter_quota_status "$pool" "$dir")"
    [ "$status" = backoff ] || { printf '%s\n' "$status"; return 0; }
  done < "$file"
  [ "$seen" -eq 1 ] && printf 'backoff\n' || printf 'off\n'
}

# meter_claude [<claude-args>...] — run `claude` in print mode, RECORD the call's
# billable token usage to the FALLBACK ledger, and print the model's result text on
# stdout (a drop-in for `claude -p <args>`: same stdout contract).
#
# NOTE: the primary meter source is now Claude Code's own session logs, which
# `claude -p` writes regardless of whether the call goes through meter_claude. So
# meter_claude's ledger append is now BELT-AND-SUSPENDERS for the fallback path,
# not the load-bearing record. It remains a safe drop-in.
#
# Fail-open by construction: if `jq` is absent we cannot parse the JSON envelope,
# so we fall back to plain `claude -p` (text output, no recording) rather than
# break the handler. A non-zero claude exit is passed through unrecorded.
#
# Caveat: do not pass your own --output-format; meter_claude sets json itself.
meter_claude() {
  # Resolve the CLI through the shared resolver (PATH, then the known install
  # locations — common.sh § agent-CLI resolution) rather than trusting the
  # inherited PATH; a single probe, since every caller here already treats an
  # unavailable provider as a soft skip. Falls back to the bare name if this file
  # is ever sourced without common.sh.
  local cli; cli="$(claude_bin_now 2>/dev/null || true)"; : "${cli:=claude}"
  if ! command -v jq >/dev/null 2>&1; then
    log "usage-meter: jq absent; running claude UNMETERED (fail-open)"
    "$cli" -p "$@"
    return $?
  fi
  local json rc toks result
  # Capture the rc through an `if`: a bare `json="$(claude …)"; rc=$?` dies AT
  # THE ASSIGNMENT under a caller's `set -e` when claude exits non-zero, so the
  # documented pass-through-with-log branch below was dead code and the caller
  # (foreman-claude.sh) crashed with no output and no diagnostic instead.
  if json="$("$cli" -p --output-format json "$@")"; then rc=0; else rc=$?; fi
  if [ "$rc" -ne 0 ]; then
    log "usage-meter: claude exited rc=$rc; usage not recorded"
    printf '%s' "$json"
    return "$rc"
  fi
  toks="$(printf '%s' "$json" \
    | jq -r '((.usage.input_tokens // 0) + (.usage.output_tokens // 0) + (.usage.cache_creation_input_tokens // 0)) | floor' \
      2>/dev/null || true)"
  meter_record "${toks:-}"
  result="$(printf '%s' "$json" | jq -r '.result // empty' 2>/dev/null || true)"
  printf '%s\n' "$result"
}

# --- per-engagement cost ledger ---------------------------------------------
# The weekly meter above remains the quota gate.  These helpers are deliberately
# separate: they record immutable, job-attributed measurements in journal2.

# job_session_dirs <base> — print Claude project-log directories belonging to a
# job's private garden/project worktrees.  This is intentionally not a time-window
# scan: snapshots before and after one handler invocation form the engagement delta.
job_session_dirs() {
  local base="${1:?}" base_key legacy_key root p enc
  local roots=()
  base_key="$(project_worktree_base_key "$base")"
  legacy_key="${base//[^A-Za-z0-9._-]/-}"
  roots+=("$GARDEN_SCRATCH/gardener-wt-$base")
  roots+=("$GARDEN_SCRATCH"/project-wt-"$base_key"-*)
  [ "$legacy_key" = "$base_key" ] || roots+=("$GARDEN_SCRATCH"/project-wt-"$legacy_key"-*)
  for root in "${roots[@]}"; do
    [ -n "$root" ] || continue
    for enc in "$(printf '%s' "$root" | sed 's#/#-#g')" "$(printf '%s' "$root" | sed 's#[/.]#-#g')"; do
      p="$GARDEN_CCUSAGE_LOGDIR/$enc"
      printf '%s\n' "$p"
    done
  done | awk '!seen[$0]++'
}

# meter_job_session_usage <base> — four cumulative classes, tab-separated:
# input, output, cache-creation, cache-read.  Dedupe by Claude message id across
# all candidate job dirs.  Missing dirs are a genuine zero; an unreadable existing
# dir or absent jq is unknown (return 1), so callers fail open rather than inventing
# a zero measurement.
meter_job_session_usage() {
  local base="${1:?}" d files out
  command -v jq >/dev/null 2>&1 || return 1
  files=""
  while IFS= read -r d; do
    [ -e "$d" ] || continue
    [ -r "$d" ] && [ -x "$d" ] || return 1
    files+="$(find "$d" -type f -name '*.jsonl' -print 2>/dev/null)"$'\n'
  done < <(job_session_dirs "$base")
  [ -n "${files//$'\n'/}" ] || { printf '0\t0\t0\t0\n'; return 0; }
  out="$(printf '%s' "$files" | tr '\n' '\0' | xargs -0 jq -Rr '
      fromjson? // empty | select(.type=="assistant" and (.message.usage != null))
      | [(.message.id // .uuid // "noid"), (.message.usage.input_tokens // 0),
         (.message.usage.output_tokens // 0), (.message.usage.cache_creation_input_tokens // 0),
         (.message.usage.cache_read_input_tokens // 0)] | @tsv' 2>/dev/null |
    awk -F'\t' '!seen[$1]++ {i+=$2;o+=$3;c+=$4;r+=$5} END {printf "%d\\t%d\\t%d\\t%d\\n",i,o,c,r}')" || return 1
  case "$out" in *$'\t'*$'\t'*$'\t'*) printf '%s\n' "$out" ;; *) return 1 ;; esac
}

meter_job_session_total() {
  local u
  u="$(meter_job_session_usage "$1")" || return 1
  awk -F'\t' -v cr="${GARDEN_TOKEN_COUNT_CACHE_READ:-0}" '{print $1+$2+$3+((cr==1)?$4:0)}' <<<"$u"
}

# usage_capture_result <file> <model> <provider-envelope-json>
# Store only the provider's terminal, cumulative fields.  The handoff is outside
# the worktree and is never disclosed to the agent prompt.
usage_capture_result() {
  local file="$1" model="$2" envelope="$3" row
  command -v jq >/dev/null 2>&1 || return 1
  row="$(jq -ce --arg model "$model" '
    {source:"result"}
    + (if $model != "" then {model:$model} else {} end)
    + (if .num_turns != null then {num_turns:.num_turns} else {} end)
    + (if .duration_ms != null then {elapsed_s:(.duration_ms / 1000 | floor)} else {} end)
    + (if .usage.input_tokens != null then {input_tokens:.usage.input_tokens} else {} end)
    + (if .usage.output_tokens != null then {output_tokens:.usage.output_tokens} else {} end)
    + (if .usage.cache_creation_input_tokens != null then {cache_creation_tokens:.usage.cache_creation_input_tokens} else {} end)
    + (if .usage.cache_read_input_tokens != null then {cache_read_tokens:.usage.cache_read_input_tokens} else {} end)
    + (if .total_cost_usd != null then {total_cost_usd:.total_cost_usd} else {} end)' <<<"$envelope" 2>/dev/null)" || return 1
  printf '%s\n' "$row" > "$file" 2>/dev/null
}

# usage_capture_rusage <file> <time-output> — merge GNU time's user/sys seconds
# and maximum resident set into an already captured provider result, best-effort.
usage_capture_rusage() {
  local file="$1" timefile="$2" u s rss
  [ -s "$file" ] && [ -s "$timefile" ] && command -v jq >/dev/null 2>&1 || return 1
  IFS=$'\t' read -r u s rss < "$timefile" || return 1
  [[ "$u" =~ ^[0-9]+([.][0-9]+)?$ ]] && [[ "$s" =~ ^[0-9]+([.][0-9]+)?$ ]] && [[ "$rss" =~ ^[0-9]+$ ]] || return 1
  jq --argjson u "$(awk -v n="$u" 'BEGIN{printf "%d",n*1000}')" \
     --argjson s "$(awk -v n="$s" 'BEGIN{printf "%d",n*1000}')" --argjson rss "$rss" \
     '. + {cpu_user_ms:$u,cpu_sys_ms:$s,peak_rss_kb:$rss}' "$file" > "$file.tmp" 2>/dev/null \
    && mv "$file.tmp" "$file" || { rm -f "$file.tmp"; return 1; }
}

# usage_ledger_stage_row <clone> <base> <elapsed> <outcome> <measurement-json>
# Stage one append-only CostRecord.  This is stage-only so a completion can carry
# its row on the existing completion push while failures use usage-append.sh.
usage_ledger_stage_row() {
  local dir="$1" base="$2" elapsed="$3" outcome="$4" measurement="${5:-}" jf tada_path role provider row
  mkdir -p "$dir/usage" || return 1
  jf="$dir/$JOBS_DOIN/$base.md"
  if [ ! -f "$jf" ]; then
    tada_path="$(tada_find "$dir" "$base" || true)"
    [ -z "$tada_path" ] || jf="$dir/$tada_path"
  fi
  role="$(plan_role "$jf" 2>/dev/null || true)"
  provider="$(sed -n 's/^[[:space:]]*provider:[[:space:]]*//p' "$jf" 2>/dev/null | tail -1)"
  case "$elapsed" in ''|*[!0-9]*) elapsed=0 ;; esac
  if command -v jq >/dev/null 2>&1 && [ -n "$measurement" ] && jq -e . >/dev/null 2>&1 <<<"$measurement"; then
    row="$(jq -cn --arg ts "$(date -u +%FT%TZ)" --arg base "$base" --arg host "$GARDEN" --arg provider "$provider" \
      --arg gardener "${GARDEN_GARDENER_ID:-}" --arg role "$role" --arg outcome "$outcome" --argjson elapsed "$elapsed" \
      --argjson measurement "$measurement" '
        $measurement + {ts:$ts,base:$base,host:$host,outcome:$outcome,elapsed_s:$elapsed}
        + (if $gardener!="" then {gardener:($gardener|tonumber)} else {} end)
        + (if $role!="" then {role:$role} else {} end)
        + (if $provider!="" then {provider:$provider} else {} end)' 2>/dev/null)" || return 1
  else
    row="{\"ts\":\"$(date -u +%FT%TZ)\",\"base\":\"$base\",\"host\":\"$GARDEN\",\"outcome\":\"$outcome\",\"source\":\"none\",\"elapsed_s\":$elapsed}"
  fi
  printf '%s\n' "$row" >> "$dir/usage/$base.jsonl" || return 1
  git -C "$dir" add "usage/$base.jsonl"
}

# usage_footer <clone> <base> — authoritative, strip-and-regenerate report view.
usage_footer() {
  local f="$1/usage/$2.jsonl" summary
  [ -f "$f" ] || return 0
  command -v jq >/dev/null 2>&1 || return 1
  summary="$(jq -sce '
    reduce .[] as $r ({eng:0, hosts:{}, unmetered:0, unpriced:0, i:0, o:0, cc:0, cr:0, cost:0, wall:0, cpuu:0, cpus:0, rss:0, models:{}};
      .eng += 1 | .hosts[$r.host] = true |
      .unmetered += (if (($r.input_tokens? // $r.output_tokens? // $r.cache_creation_tokens? // $r.cache_read_tokens?) == null) then 1 else 0 end) |
      .unpriced += (if $r.total_cost_usd == null then 1 else 0 end) |
      .i += ($r.input_tokens // 0) | .o += ($r.output_tokens // 0) | .cc += ($r.cache_creation_tokens // 0) | .cr += ($r.cache_read_tokens // 0) |
      .cost += ($r.total_cost_usd // 0) | .wall += ($r.elapsed_s // 0) | .cpuu += ($r.cpu_user_ms // 0) | .cpus += ($r.cpu_sys_ms // 0) |
      .rss = ([.rss, ($r.peak_rss_kb // 0)]|max) | if $r.model then .models[$r.model] = ((.models[$r.model] // 0)+1) else . end)' "$f" 2>/dev/null)" || return 1
  printf '<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/%s.jsonl; not agent-authored — do not edit -->\n\n' "$2"
  jq -r '"## Cost\n- Engagements: \(.eng) on \((.hosts|keys|length)) host(s)" + (if .unmetered>0 then " (\(.unmetered) unmetered)" else "" end) +
    "\n- Input: \(.i) tokens (\(.cr) cached reads)\n- Output: \(.o) tokens\n- Cost: $\(.cost)" + (if .unpriced>0 then " (\(.unpriced) engagement(s) unpriced)" else "" end) +
    "\n- Wall-clock: \(.wall)s" + (if (.models|length)>0 then "\n- Model(s): \(.models|to_entries|map(.key + " ×" + (.value|tostring))|join(", "))" else "" end)' <<<"$summary"
  printf '\n<!-- garden-usage-end -->\n'
}
