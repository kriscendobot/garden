#!/bin/bash
# panel-llm.sh — provider-aware model resolution and CLI dispatch for panel.sh.
# Sourced by panel.sh and its cost-gated seat helpers; it has no main routine.

PANEL_LLM_HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
: "${GARDEN_PANEL_SEAT_TIERS:=$PANEL_LLM_HERE/seat-model-tiers.tsv}"
# Use the same model-specific reasoning ladders as the cleric handler. A panel's
# inherited ceiling can support a higher effort than a downshifted seat model.
# shellcheck source=../handlers/codex-provider-common.sh
source "$PANEL_LLM_HERE/../handlers/codex-provider-common.sh"

panel_provider() {
  if [ -n "${GARDEN_PANEL_PROVIDER:-}" ]; then
    printf '%s\n' "$GARDEN_PANEL_PROVIDER"
    return
  fi
  if [ -n "${GARDEN_JOB_PROVIDER:-}" ]; then
    printf '%s\n' "$GARDEN_JOB_PROVIDER"
    return
  fi
  case "${GARDEN_WORKER_KIND:-monk}" in
    cleric) printf '%s\n' openai ;;
    monk|gardener) printf '%s\n' anthropic ;;
    *) printf '%s\n' unsupported ;;
  esac
}

panel_llm_available() {
  case "$(panel_provider)" in
    anthropic) command -v claude >/dev/null 2>&1 ;;
    openai)    command -v codex >/dev/null 2>&1 ;;
    *)         return 1 ;;
  esac
}

panel_inventory_model() { # <provider> <tier> -> first inventory model
  local provider="$1" tier="$2"
  awk -v p="$provider" -v t="$tier" '
    /^[[:space:]]*#/ || /^[[:space:]]*$/ { next }
    $1 == p && $3 == t { print $2; exit }
  ' "${GARDEN_MODEL_TIER_INVENTORY:-$PANEL_LLM_HERE/../model-tier-inventory.tsv}" 2>/dev/null
}

# Resolve the panel's orthogonal opus/sonnet/haiku vocabulary for the provider
# that owns the running worker. Opus is represented by an empty value because it
# inherits the already-resolved job ceiling. Anthropic retains its historical
# aliases byte-for-byte; OpenAI downshifts through the closed fleet inventory.
seat_model_flag() { # <seat> -> model value or empty (inherit)
  local seat="$1" tier="" provider
  if [ -r "$GARDEN_PANEL_SEAT_TIERS" ]; then
    tier="$(awk -v s="$seat" '
      /^[[:space:]]*#/ || /^[[:space:]]*$/ { next }
      $1 == s { print $2; exit }' "$GARDEN_PANEL_SEAT_TIERS" 2>/dev/null)"
  fi
  provider="$(panel_provider)"
  case "$provider:$tier" in
    anthropic:sonnet) printf '%s\n' "${GARDEN_PANEL_MODEL_SONNET:-sonnet}" ;;
    anthropic:haiku)  printf '%s\n' "${GARDEN_PANEL_MODEL_HAIKU:-haiku}" ;;
    openai:sonnet)    panel_inventory_model openai minion ;;
    openai:haiku)     panel_inventory_model openai myrmidon ;;
    *:opus|*:"")      : ;;
    *)                : ;;
  esac
}

# panel_llm <model-or-empty> <json-schema-or-empty> [prompt]
#
# With a prompt argument, Anthropic keeps the established argv transport while
# Codex always receives the prompt on stdin. With no prompt argument both paths
# consume stdin (the large foreperson/appellate aggregate path).
panel_llm() {
  local model="${1:-}" schema="${2:-}" provider prompt_supplied=0 prompt=""
  shift 2 || true
  if [ "$#" -gt 0 ]; then prompt_supplied=1; prompt="$1"; fi
  provider="$(panel_provider)"

  case "$provider" in
    anthropic)
      command -v claude >/dev/null 2>&1 || {
        echo "panel: anthropic provider selected but claude is unavailable" >&2
        return 127
      }
      local -a model_args=() budget_args=() schema_args=()
      [ -n "$model" ] && model_args=(--model "$model")
      [[ "${GARDEN_CLAUDE_CALL_BUDGET_USD:-}" =~ ^[0-9]+([.][0-9]+)?$ ]] \
        && budget_args=(--max-budget-usd "$GARDEN_CLAUDE_CALL_BUDGET_USD")
      [ -n "$schema" ] && schema_args=(--output-format json --json-schema "$schema")
      if [ "$prompt_supplied" -eq 1 ]; then
        claude -p "${model_args[@]}" "${budget_args[@]}" "${schema_args[@]}" \
          --dangerously-skip-permissions "$prompt"
      else
        claude -p "${model_args[@]}" "${budget_args[@]}" "${schema_args[@]}" \
          --dangerously-skip-permissions
      fi
      ;;
    openai)
      command -v codex >/dev/null 2>&1 || {
        echo "panel: openai provider selected but codex is unavailable" >&2
        return 127
      }
      [ -n "$model" ] || model="${GARDEN_JOB_MODEL:-}"
      [ -n "$model" ] || {
        echo "panel: openai panel cannot inherit an unresolved job model" >&2
        return 2
      }
      local effort
      effort="$(codex_effort_for_model "$model" "${GARDEN_JOB_EFFORT:-medium}")"
      local -a codex_args=(
        --dangerously-bypass-approvals-and-sandbox
        --skip-git-repo-check
        -m "$model"
        -c "model_reasoning_effort=$effort"
      )
      local schema_file="" rc=0
      if [ -n "$schema" ]; then
        schema_file="$(mktemp "${TMPDIR:-/tmp}/garden-panel-schema.XXXXXX")" || return
        printf '%s\n' "$schema" >"$schema_file"
        codex_args+=(--output-schema "$schema_file")
      fi
      if [ "$prompt_supplied" -eq 1 ]; then
        printf '%s' "$prompt" | codex exec "${codex_args[@]}" - || rc=$?
      else
        codex exec "${codex_args[@]}" - || rc=$?
      fi
      [ -z "$schema_file" ] || rm -f "$schema_file"
      return "$rc"
      ;;
    *)
      echo "panel: unsupported worker provider '$provider' (requires anthropic or openai)" >&2
      return 2
      ;;
  esac
}
