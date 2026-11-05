#!/bin/bash
# receipt-defaults.sh — shared helpers for the PR completion receipt generator
# (pr-receipt.sh). Sourced, not run.
#
# The maintainer-review-effort (MRE) constants (a, b, r, and the maintainer hourly
# rate H) and their receipts/config/<key> override reader were RETIRED 2026-11-05:
# receipts measure (tokens, time, words of human feedback) and never estimate a human
# cost. See designs/pr-completion-receipts.md § Human-effort estimation retired.

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
