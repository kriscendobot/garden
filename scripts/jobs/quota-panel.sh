#!/bin/bash
# quota-panel.sh — deterministic, per-provider spend & quota visibility for the
# bulletin. Source this; do not execute it. common.sh sources it (after
# usage-meter.sh) so the bulletin — and any other consumer — inherits the helpers.
#
# WHY this exists: usage-meter.sh already answers "how many Claude tokens has the
# fleet burned this window, and are we near the quota?" (the foreman's back-off
# gate). This file turns that single number into a MAINTAINER-FACING PANEL with a
# row per provider (Claude, Codex), each showing three columns:
#
#   1. TOKEN SPEND  — billable tokens over the trailing quota window.
#   2. DOLLAR SPEND — tokens × the provider-model-catalog rate card. Notional on a
#      subscription (no invoice), labeled as such; honest "n/a" on the Codex
#      ChatGPT/plan basis, which exposes NO per-token price.
#   3. % OF QUOTA   — spend / quota, or an honest "no quota set" when unconfigured.
#
# It is built ON the accepted cost substrate, not a fork of it:
#   - Claude tokens + quota reuse meter_window_total / meter_quota_status verbatim
#     (usage-meter.sh), the SAME numbers the foreman gates on.
#   - Claude dollars are priced from Claude Code's own session logs per model via
#     the rate card in designs/provider-model-catalog.md — the same per-class,
#     per-model tokens usage-meter already reads, run through the catalog's prices.
#   - Codex tokens + quota + the reasoning behind the "no per-token $" caveat are
#     read from codex's own per-session rollout logs (~/.codex/sessions/**), which
#     carry a `token_count` event per turn AND codex's self-reported
#     `rate_limits.primary.used_percent` for the active plan window. That
#     self-reported percentage is the HONEST quota signal for a ChatGPT/plan
#     account (which has no token quota the fleet can name).
#
# FUTURE (token-cost-ledger, designs/token-cost-ledger.md): when the attributed
# per-job dollar ledger (`usage/<base>.jsonl` with the CLI's `total_cost_usd`)
# lands, that becomes the AUTHORITATIVE dollar source and the multi-host fleet-wide
# sum (its § Feeding the gate, the max rule). Set GARDEN_QUOTA_LEDGER_DIR to a
# synced journal clone's root to prefer it; until then this prices from the local
# host's session logs, matching usage-meter's documented single-host assumption.
#
# FAIL-OPEN by construction: a missing/unreadable source for any cell renders that
# cell as "unavailable" (or "no quota set" / "n/a") and NEVER wedges the panel or
# the bulletin loop. Every helper is best-effort and returns 0.
#
# LEADER-ONLY / PER-HOST: like usage-meter, ~/.claude and ~/.codex are per-host.
# The bulletin that renders this panel is a leader-only singleton, so the panel
# reflects the leader host's local spend — the same single-host scope the meter
# documents. Fleet-wide sums arrive with the journal ledger (above).

# --- configuration (all overridable) ----------------------------------------

# The panel's trailing window (seconds). Defaults to the meter's window so the
# panel and the foreman gate reason over the SAME window. usage-meter.sh sets
# GARDEN_TOKEN_WINDOW_SECS (default 7 days); fall back to it, else 7 days.
: "${GARDEN_QUOTA_PANEL_WINDOW_SECS:=${GARDEN_TOKEN_WINDOW_SECS:-604800}}"

# Codex per-session rollout logs (per-host, like ~/.claude). Each rollout-*.jsonl
# carries `event_msg`/`token_count` payloads with per-turn `last_token_usage` and
# codex's self-reported `rate_limits`. Overridable for tests / a non-default home.
: "${GARDEN_CODEX_LOGDIR:=${HOME:-/home/$(id -un 2>/dev/null || echo kris)}/.codex/sessions}"

# Codex dollar basis. Codex authenticated via a ChatGPT plan exposes NO per-token
# price (designs/provider-model-catalog.md §2), so the default is honest: dollars
# are "n/a" and the plan's self-reported rate-limit % is the real cost signal.
# Set GARDEN_CODEX_PRICED=1 ONLY when codex runs against an OpenAI API KEY, where a
# per-token rate card applies; then GARDEN_CODEX_INPUT_RATE / _OUTPUT_RATE ($ per
# MTok) price it. Left unpriced by default so we never render a fake dollar figure.
: "${GARDEN_CODEX_PRICED:=0}"
: "${GARDEN_CODEX_INPUT_RATE:=0}"    # $ per MTok input  (API mode only)
: "${GARDEN_CODEX_OUTPUT_RATE:=0}"   # $ per MTok output (API mode only)

# Codex quota knobs, used ONLY when codex does not self-report a rate-limit % (no
# session logs, or an --oss/local run). A token ceiling for the window, or an
# API-mode dollar budget. Unset/0 => "no quota set" (spend shown, no bogus %).
: "${GARDEN_CODEX_WEEKLY_QUOTA:=0}"    # billable-token ceiling for the window
: "${GARDEN_CODEX_DOLLAR_BUDGET:=0}"   # $ budget for the window (API mode)

# Prefer the token-cost-ledger's authoritative dollars when built. A synced
# journal clone root holding usage/*.jsonl (per designs/token-cost-ledger.md).
# Empty => price from session logs (the working source until the ledger lands).
: "${GARDEN_QUOTA_LEDGER_DIR:=}"

# Standalone-safe logger: common.sh defines `log`; when sourced bare (tests) fall
# back to a no-op so the pure helpers never depend on the harness.
command -v log >/dev/null 2>&1 || log() { :; }

# qp_now — wall clock (epoch seconds), overridable for deterministic tests. Reuses
# the meter's clock override so a test can freeze both together.
qp_now() { printf '%s\n' "${GARDEN_USAGE_NOW:-$(date +%s)}"; }

# --- the rate card (designs/provider-model-catalog.md) -----------------------
#
# $ per MTok as (input output), matched by model-id PREFIX (longest-ish first via
# ordered cases). Notional: the fleet bills through a Max subscription, so these
# price the raw tokens for a cross-model comparable, not an invoice. cache_creation
# is billed at 1.25× the input rate and cache_read at 0.10× (standard Anthropic
# cache pricing); the panel prices all four Claude token classes accordingly.
# Unknown claude-* ids fall back to the Opus rate (the garden's default tier) so a
# newly-released id still prices rather than dropping to zero.
qp_claude_rate() {   # qp_claude_rate <model-id> -> "<input$/MTok> <output$/MTok>"
  case "$1" in
    claude-fable-5*|claude-mythos-5*) printf '10 50\n' ;;
    claude-sonnet-5*|claude-sonnet-4*) printf '3 15\n' ;;
    claude-haiku-4*|claude-haiku-5*)   printf '1 5\n' ;;
    claude-opus-*|claude-*)            printf '5 25\n' ;;   # Opus + unknown fallback
    *)                                 printf '5 25\n' ;;
  esac
}

# --- Claude: dollar spend from the session logs ------------------------------
#
# Prices Claude Code's own session JSONL over the trailing window, per model, via
# the rate card. Uses the SAME logs and the SAME per-message dedup usage-meter
# reads (first occurrence of a message id wins). Prints a decimal dollar total.
# Returns 1 (=> "unavailable") when the logs cannot be read (no jq, unreadable
# dir) so the caller degrades rather than printing a fake $0.00.
_qp_claude_session_dollars() {   # <logdir> <cutoff-epoch>
  local logdir="$1" cutoff="$2" listing rc
  command -v jq >/dev/null 2>&1 || return 1
  listing="$(find "$logdir" -maxdepth 6 -type f -name '*.jsonl' -newermt "@$cutoff" 2>/dev/null)"; rc=$?
  [ "$rc" -ne 0 ] && return 1
  [ -z "$listing" ] && { printf '0.00\n'; return 0; }

  # Per line: emit  <msgid>\t<epoch>\t<model>\t<in>\t<out>\t<cache_create>\t<cache_read>.
  # awk dedups by msgid, filters by cutoff, sums per model, applies the rate card,
  # and prints the grand dollar total. The rate card is passed in as a table so the
  # pricing lives in ONE place (qp_claude_rate) — awk mirrors its bands.
  printf '%s\n' "$listing" | tr '\n' '\0' | xargs -0 jq -Rr '
        fromjson? // empty
        | select(.type=="assistant" and (.message.usage != null))
        | [ (.message.id // .uuid // "noid"),
            ((.timestamp // "") | sub("\\.[0-9]+Z$";"Z") | (fromdateiso8601? // -1)),
            (.message.model // "unknown"),
            (.message.usage.input_tokens // 0),
            (.message.usage.output_tokens // 0),
            (.message.usage.cache_creation_input_tokens // 0),
            (.message.usage.cache_read_input_tokens // 0) ]
        | @tsv' 2>/dev/null \
    | awk -F'\t' -v c="$cutoff" '
        function rate(m,   r) {
          if (m ~ /^claude-fable-5/ || m ~ /^claude-mythos-5/) return "10 50"
          if (m ~ /^claude-sonnet-/) return "3 15"
          if (m ~ /^claude-haiku-/)  return "1 5"
          return "5 25"   # Opus + unknown claude-* fallback
        }
        !seen[$1]++ && ($2+0) >= c {
          split(rate($3), r, " ")
          inr = r[1]; outr = r[2]
          # input + cache_creation@1.25 + cache_read@0.10 priced at input rate;
          # output at output rate. $/MTok => divide token counts by 1e6.
          d += ( ($4 + $6*1.25 + $7*0.10) * inr + $5 * outr ) / 1000000.0
        }
        END { printf "%.2f\n", d + 0 }'
  return 0
}

# --- Codex: token spend, dollars, and self-reported quota --------------------
#
# One awk/jq pass over the codex rollout logs in the window. Emits four
# space-separated fields on stdout:
#   <billable-tokens> <cached-tokens> <used_percent|-1> <plan_type|->
# billable = (input - cached_input) + output, summed over per-turn last_token_usage
# for token_count events at/after the cutoff (mirrors usage-meter's cache-read
# exclusion: cached_input_tokens are re-reads, not fresh spend). used_percent and
# plan_type come from the LATEST token_count event's rate_limits.primary (codex's
# own plan-window accounting). Returns 1 => "unavailable" when nothing readable.
_qp_codex_scan() {   # <logdir> <cutoff-epoch>
  local logdir="$1" cutoff="$2" listing rc
  command -v jq >/dev/null 2>&1 || return 1
  [ -d "$logdir" ] && [ -r "$logdir" ] || return 1
  listing="$(find "$logdir" -maxdepth 6 -type f -name '*.jsonl' -newermt "@$cutoff" 2>/dev/null)"; rc=$?
  [ "$rc" -ne 0 ] && return 1
  [ -z "$listing" ] && { printf '0 0 -1 -\n'; return 0; }

  # Per line: keep token_count event_msgs; emit
  #   <epoch>\t<in>\t<cached_in>\t<out>\t<used_percent>\t<plan_type>
  # from last_token_usage (per-turn delta, so summing never double-counts the
  # cumulative) and rate_limits.primary. awk sums in-window tokens and keeps the
  # rate-limit fields from the row with the LARGEST epoch (the freshest reading).
  printf '%s\n' "$listing" | tr '\n' '\0' | xargs -0 jq -Rr '
        fromjson? // empty
        | select(.type=="event_msg" and .payload.type=="token_count")
        | [ ((.timestamp // "") | sub("\\.[0-9]+Z$";"Z") | (fromdateiso8601? // -1)),
            (.payload.info.last_token_usage.input_tokens // 0),
            (.payload.info.last_token_usage.cached_input_tokens // 0),
            (.payload.info.last_token_usage.output_tokens // 0),
            (.payload.rate_limits.primary.used_percent // -1),
            (.payload.rate_limits.plan_type // "-") ]
        | @tsv' 2>/dev/null \
    | awk -F'\t' -v c="$cutoff" '
        {
          ep=$1+0
          if (ep >= c) {
            bill += ($2+0) - ($3+0); if (bill < 0) bill = 0
            bill += ($4+0)
            cached += ($3+0)
          }
          # freshest rate-limit reading wins, regardless of the token window
          if (ep >= maxep) { maxep=ep; up=$5; plan=$6 }
        }
        END {
          printf "%d %d %s %s\n", bill+0, cached+0, (up=="" ? "-1" : up), (plan=="" ? "-" : plan)
        }'
  return 0
}

# --- helpers: humanize ------------------------------------------------------

# qp_human_tokens <int> — compact token count (12.8k, 41.2M). Best-effort.
qp_human_tokens() {
  awk -v n="${1:-0}" 'BEGIN{
    n=n+0
    if (n >= 1000000) printf "%.1fM", n/1000000
    else if (n >= 1000) printf "%.1fk", n/1000
    else printf "%d", n
  }'
}

# qp_pct <spent> <quota> — integer percentage, or empty when quota<=0.
qp_pct() {
  awk -v s="${1:-0}" -v q="${2:-0}" 'BEGIN{ if (q+0 <= 0) exit; printf "%d", (s/q)*100 + 0.5 }'
}

# --- the panel --------------------------------------------------------------
#
# render_quota_panel — emit the deterministic markdown panel body (a Markdown
# table plus a basis note). No `claude`/`codex` in the render path. Every cell
# degrades to "unavailable" / "no quota set" / "n/a" rather than a fake number.
render_quota_panel() {
  local win now cutoff window_label pool_row _pool _provider _account _kind pool_cap anchored_cutoff meter_arg
  win="$GARDEN_QUOTA_PANEL_WINDOW_SECS"
  now="$(qp_now)"; case "$now" in ''|*[!0-9]*) now=0 ;; esac
  cutoff=$(( now - win ))
  local wdays; wdays=$(( win / 86400 )); [ "$wdays" -ge 1 ] || wdays=1
  window_label="Trailing ${wdays}d"
  pool_row="$(budget_pool_row "anthropic:$GARDEN" 2>/dev/null || true)"
  if [ -n "$pool_row" ]; then
    IFS=$'\t' read -r _pool _provider _account _kind pool_cap <<<"$pool_row"
    anchored_cutoff="$(meter_window_cutoff anchor 2>/dev/null || true)"
    if [[ "$anchored_cutoff" =~ ^[0-9]+$ ]]; then
      cutoff="$anchored_cutoff"
      window_label="Since Friday 21:00 Pacific reset"
    fi
  fi

  # ---- Claude row ----
  local c_tok c_tok_disp c_dollars c_dollars_disp c_pct c_quota c_status
  if [ -n "$pool_row" ]; then meter_arg=anchor; else meter_arg="$win"; fi
  if c_tok="$(meter_window_total "$meter_arg" 2>/dev/null)"; then
    c_tok_disp="$(qp_human_tokens "$c_tok")"
  else
    c_tok=""; c_tok_disp="unavailable"
  fi
  if c_dollars="$(_qp_claude_session_dollars "$GARDEN_CCUSAGE_LOGDIR" "$cutoff" 2>/dev/null)"; then
    c_dollars_disp="\$${c_dollars} _(notional, rate-card)_"
  else
    c_dollars_disp="unavailable"
  fi
  c_quota="${pool_cap:-${GARDEN_TOKEN_WEEKLY_QUOTA:-0}}"
  c_status="$(meter_quota_status 2>/dev/null || echo unknown)"
  case "$c_quota" in
    ''|0|*[!0-9]*) c_pct="no quota set" ;;
    *)
      if [ -n "$c_tok" ]; then
        local p; p="$(qp_pct "$c_tok" "$c_quota")"
        c_pct="${p}% of $(qp_human_tokens "$c_quota") (${c_status})"
      else
        c_pct="unavailable (${c_status})"
      fi
      ;;
  esac

  # ---- Codex row ----
  local x_out x_bill x_cached x_used x_plan x_tok_disp x_dollars_disp x_pct
  if x_out="$(_qp_codex_scan "$GARDEN_CODEX_LOGDIR" "$cutoff" 2>/dev/null)"; then
    x_bill="$(printf '%s' "$x_out" | awk '{print $1}')"
    x_cached="$(printf '%s' "$x_out" | awk '{print $2}')"
    x_used="$(printf '%s' "$x_out" | awk '{print $3}')"
    x_plan="$(printf '%s' "$x_out" | awk '{print $4}')"
    x_tok_disp="$(qp_human_tokens "$x_bill") _(+$(qp_human_tokens "$x_cached") cached)_"
  else
    x_bill=""; x_used="-1"; x_plan="-"; x_tok_disp="unavailable"
  fi

  # Codex dollars: honest basis. API-key mode prices via the rate card; the
  # ChatGPT/plan default has NO per-token $ (never render a fake figure).
  case "$GARDEN_CODEX_PRICED" in
    1|true|yes|on)
      if [ -n "$x_bill" ]; then
        # We only have a billable aggregate here (uncached input + output), so
        # price it with a single blended pair; label it a rate-card estimate.
        local xd
        xd="$(awk -v t="$x_bill" -v ir="$GARDEN_CODEX_INPUT_RATE" -v orr="$GARDEN_CODEX_OUTPUT_RATE" \
              'BEGIN{ r=(ir+orr)/2.0; printf "%.2f", t*r/1000000.0 }')"
        x_dollars_disp="\$${xd} _(API rate-card est.)_"
      else
        x_dollars_disp="unavailable"
      fi
      ;;
    *)
      # Name the plan codex itself reported (free/plus/pro/…) when known, so the
      # basis is honest and specific rather than a hardcoded guess.
      local plan_label="ChatGPT plan"
      case "${x_plan:-}" in ''|'-'|null) : ;; *) plan_label="ChatGPT ${x_plan} plan" ;; esac
      x_dollars_disp="n/a _(${plan_label} — no per-token \$; plan-metered)_"
      ;;
  esac

  # Codex % of quota: prefer codex's OWN self-reported plan usage; else a
  # configured token/dollar budget; else "no quota set".
  if [ "${x_used:-".-1"}" != "-1" ] && [ "${x_used:-}" != "-" ] && [ -n "${x_used:-}" ]; then
    x_pct="$(awk -v u="$x_used" 'BEGIN{printf "%.0f", u+0}')% _(plan; codex-reported)_"
  elif [ "${GARDEN_CODEX_DOLLAR_BUDGET:-0}" != "0" ] && [ "$GARDEN_CODEX_PRICED" = "1" ] && [ -n "$x_bill" ]; then
    x_pct="budget-based _(see \$ column)_"
  elif [ "${GARDEN_CODEX_WEEKLY_QUOTA:-0}" != "0" ] && [ -n "$x_bill" ]; then
    local xp; xp="$(qp_pct "$x_bill" "$GARDEN_CODEX_WEEKLY_QUOTA")"
    x_pct="${xp}% of $(qp_human_tokens "$GARDEN_CODEX_WEEKLY_QUOTA")"
  elif [ -n "$x_bill" ]; then
    x_pct="no quota set"
  else
    x_pct="unavailable"
  fi

  # ---- render ----
  printf '_%s; billable tokens (cache reads excluded). Leader-host local spend._\n\n' "$window_label"
  printf '| Provider | Token spend | Dollar spend | %% of quota |\n'
  printf '| --- | --- | --- | --- |\n'
  printf '| Claude | %s | %s | %s |\n' "$c_tok_disp" "$c_dollars_disp" "$c_pct"
  printf '| Codex | %s | %s | %s |\n' "$x_tok_disp" "$x_dollars_disp" "$x_pct"
}
