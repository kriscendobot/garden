#!/bin/bash
# usage-meter.sh — a deterministic, host-local weekly token meter for the fleet.
#
# Source this; do not execute it. common.sh sources it so every job-board script
# (and any `claude -p` handler) inherits the helpers.
#
# WHY this exists: the foreman is where the garden spends tokens autonomously — it
# promotes deferred plan jobs and generates new milestone steps via `claude -p`,
# each of which can ignite a full design/build/panel chain. Before that pump the
# foreman must check, in PLAIN CODE with NO LLM, whether the garden is at risk of
# hitting its weekly token quota, and back off if so. There was no usage signal
# anywhere in scripts/ before this; this module establishes one.
#
# THE USAGE SOURCE (the chosen, documented signal):
#   The most reliable spend signal available in this environment is the token
#   `usage` block the `claude` CLI emits with `--output-format json`. So spend is
#   recorded at the point it happens: a handler runs its model call through
#   `meter_claude` (below), which asks for JSON, extracts the billable token
#   count, and appends one line to a host-local rolling ledger. Nothing depends on
#   an external dashboard or on parsing ~/.claude internals. The ledger is the
#   single source of truth for "tokens spent in the trailing window".
#
#   Ledger format (TSV, append-only, host-local, outside any reset-prone worktree):
#     <epoch-seconds>\t<billable-tokens>
#   Billable tokens = input + output + cache_creation (cache_read is excluded: it
#   bills at a small fraction and would otherwise dominate the sum and trip the
#   back-off far too early). One line per metered `claude -p` call.
#
# THE WEEK BOUNDARY: a rolling trailing window (default 7 days), NOT a fixed
# calendar reset, because the maintainer's actual quota-reset cadence is not known
# to the fleet (OPEN QUESTION — surface it; if the real reset is, say, a fixed
# weekly UTC boundary, set GARDEN_TOKEN_WINDOW_SECS and/or teach meter_window_total
# a calendar cutoff). A trailing window is the safe default: it can only
# OVER-count relative to a fixed reset (an event 6 days before a reset still counts
# for one more day), so it errs toward backing off slightly early, never late.
#
# FAIL-OPEN: a missing or unreadable meter must NEVER wedge the pump. When the
# quota is unset the meter is simply OFF (gating disabled). When the quota is set
# but the ledger cannot be read, meter_quota_status returns `unknown` and the
# caller proceeds with a logged warning — a broken meter can slow nothing to a
# halt. Only a CONFIRMED at/over-high-water reading backs the pump off.
#
# All helpers are best-effort and never abort their caller (callers run under
# `set -e`); recording failures are swallowed, reads degrade to `unknown`.

# --- configuration (all overridable) ----------------------------------------

# The weekly token ceiling. UNSET/0 means the meter is OFF (no gating) — the safe
# default until the maintainer sets the real ceiling for this fleet.
: "${GARDEN_TOKEN_WEEKLY_QUOTA:=0}"
# High-water mark as a fraction of the quota; at/over this the foreman backs off.
: "${GARDEN_TOKEN_BACKOFF_FRACTION:=0.85}"
# The rolling window, in seconds (default 7 days). See "THE WEEK BOUNDARY" above.
: "${GARDEN_TOKEN_WINDOW_SECS:=604800}"
# The host-local rolling ledger. Outside any reset-prone worktree, like other state.
: "${GARDEN_USAGE_LEDGER:=$GARDEN_STATE/usage/ledger}"
# Soft cap on ledger lines before an opportunistic prune of out-of-window rows.
: "${GARDEN_USAGE_LEDGER_MAXLINES:=20000}"

# Wall clock in epoch seconds, overridable for deterministic tests.
meter_now() { printf '%s\n' "${GARDEN_USAGE_NOW:-$(date +%s)}"; }

# meter_record <billable-tokens> — append one usage event to the ledger.
# Ignores empty/non-integer/zero input. Atomic append; never fails the caller.
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

# meter_window_total [<window-secs>] — sum billable tokens within the trailing
# window. Prints the integer total on stdout. Returns:
#   0 with "0"   when the ledger does not exist yet (no spend → genuinely zero),
#   0 with <sum> when read OK,
#   1            when the ledger exists but cannot be read (→ `unknown` upstream).
meter_window_total() {
  local ledger="$GARDEN_USAGE_LEDGER" window="${1:-$GARDEN_TOKEN_WINDOW_SECS}" now cutoff
  [ -e "$ledger" ] || { printf '0\n'; return 0; }            # no spend recorded yet
  { [ -f "$ledger" ] && [ -r "$ledger" ]; } || return 1      # exists but unusable → unknown
  now="$(meter_now)"; case "$now" in ''|*[!0-9]*) return 1 ;; esac
  cutoff=$(( now - window ))
  awk -F'\t' -v c="$cutoff" '($1+0)>=c { s += ($2+0) } END { printf "%d\n", s+0 }' "$ledger" 2>/dev/null || return 1
}

# meter_quota_status — the one deterministic verdict the foreman gates on. Prints
# exactly one word and always returns 0:
#   off      — no quota configured; gating disabled (proceed silently).
#   unknown  — quota set but the meter could not be read (proceed, but WARN).
#   ok       — under the high-water mark (proceed).
#   backoff  — at/over the high-water mark (pause the pump).
meter_quota_status() {
  local quota="${GARDEN_TOKEN_WEEKLY_QUOTA:-0}" frac="${GARDEN_TOKEN_BACKOFF_FRACTION:-0.85}" total
  case "$quota" in ''|0|*[!0-9]*) printf 'off\n'; return 0 ;; esac
  total="$(meter_window_total)" || { printf 'unknown\n'; return 0; }
  if awk -v t="$total" -v q="$quota" -v f="$frac" 'BEGIN { exit !(t >= q*f) }'; then
    printf 'backoff\n'
  else
    printf 'ok\n'
  fi
}

# meter_claude [<claude-args>...] — run `claude` in print mode, RECORD the call's
# billable token usage to the ledger, and print the model's result text on stdout
# (a drop-in for `claude -p <args>`: same stdout contract). This is the seam by
# which fleet handlers feed the meter; adopt it in place of a bare `claude -p`.
#
# Fail-open by construction: if `jq` is absent we cannot parse the JSON envelope,
# so we fall back to plain `claude -p` (text output, no recording) rather than
# break the handler. A non-zero claude exit is passed through unrecorded.
#
# Caveat: do not pass your own --output-format; meter_claude sets json itself.
meter_claude() {
  if ! command -v jq >/dev/null 2>&1; then
    log "usage-meter: jq absent; running claude UNMETERED (fail-open)"
    claude -p "$@"
    return $?
  fi
  local json rc toks result
  json="$(claude -p --output-format json "$@")"; rc=$?
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
