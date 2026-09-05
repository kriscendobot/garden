#!/bin/bash
# receipt-defaults.sh — the tracked SEED constants for the PR completion receipt
# generator (pr-receipt.sh), plus the journal-config override reader. Sourced, not run.
#
# Journal-data-outranks-seed (the reputation/rate-card.md pattern): the values here are
# the committed defaults, and a journal file receipts/config/<key> OUTRANKS the seed —
# a retune (a different maintainer hourly rate, a recalibrated MRE constant) is a
# journal write, no deploy. See designs/pr-completion-receipts.md § The MRE heuristic
# and § Open questions (the constants are deliberately tunable).
#
# The maintainer-review-effort (MRE) heuristic estimates the human reviewer's minutes:
#   M = S·a + C·b + L/r        (S sittings, C human comments, L human comment chars)
# and prices them at H dollars/hour. All four constants are seeds here, overridable.

# Seeded defaults (directionally validated in the design § Validation; NOT empirically
# calibrated against timed maintainer sessions — see § Open questions).
: "${GARDEN_RECEIPT_MRE_A:=8}"        # a: minutes of fixed per-sitting page-in cost
: "${GARDEN_RECEIPT_MRE_B:=1.5}"      # b: minutes to author one pointed comment
: "${GARDEN_RECEIPT_MRE_R:=750}"      # r: chars/min read-and-comprehend throughput
: "${GARDEN_RECEIPT_HOURLY_USD:=150}" # H: maintainer hourly rate, dollars

# receipt_config <clone-dir> <journal-key> <seed-value>
# Echo the journal override (receipts/config/<key>) when present and numeric, else the
# seed. Non-numeric/absent journal content falls back to the seed (fail-safe: a garbled
# config never zeroes a constant). Keys:
#   maintainer-hourly-usd      -> H
#   mre-a-min-per-sitting      -> a
#   mre-b-min-per-comment      -> b
#   mre-r-chars-per-min        -> r
receipt_config() {
  local dir="${1:-}" key="${2:?receipt_config <dir> <key> <seed>}" seed="${3:?}" v=""
  if [ -n "$dir" ] && [ -f "$dir/receipts/config/$key" ]; then
    v="$(head -1 "$dir/receipts/config/$key" 2>/dev/null | tr -d '[:space:]')"
  fi
  case "$v" in ''|*[!0-9.]*) printf '%s' "$seed" ;; *) printf '%s' "$v" ;; esac
}

# receipt_harness <provider> — map the garden's provider axis to the worker-kind
# harness (agent_bin) the receipt reports, matching comment-provenance.sh's axis.
receipt_harness() {
  case "${1:-}" in
    anthropic)    echo claude ;;
    openai)       echo codex ;;
    moonshot)     echo kimi ;;
    fireworks)    echo fireworks ;;
    openrouter)   echo openrouter ;;
    ollama-cloud) echo ollama ;;
    local)        echo local ;;
    ''|unknown)   echo '—' ;;
    *)            echo "${1}" ;;
  esac
}

# receipt_provider_of_model <model> — last-resort provider inference when neither the
# usage row nor the reputation event names a provider. Deterministic prefix match.
receipt_provider_of_model() {
  case "${1:-}" in
    claude-*|*claude*) echo anthropic ;;
    kimi-*|*kimi*)     echo moonshot ;;
    gpt-*|o[0-9]*|*gpt*) echo openai ;;
    *)                 echo unknown ;;
  esac
}
