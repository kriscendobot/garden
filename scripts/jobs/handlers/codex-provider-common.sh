#!/bin/bash
# Shared Codex provider primitives for autonomous handlers.  The cleric and the
# foreman deliberately use the same authentication, local-endpoint and reasoning
# configuration so the provider choices do not grow incompatible command paths.

# shellcheck shell=bash

: "${GARDEN_LOCAL_OLLAMA_URL:=http://127.0.0.1:11434/v1}"

# codex_provider_preflight <provider> <kind> <base> <state-namespace>
#
# Match the worker handler's once-per-boot availability convention.  A caller
# may treat a nonzero result as a reason to try another configured provider.
codex_provider_preflight() {
  local provider="${1:?provider}" kind="${2:?kind}" base="${3:?base}" state_ns="${4:?state namespace}"
  command -v codex >/dev/null 2>&1 || {
    printf 'codex not on PATH; cannot run %s handler for %q\n' "$kind" "$base" >&2
    return 1
  }

  local auth_boot auth_marker
  auth_boot="$(tr -dc 'a-f0-9' < /proc/sys/kernel/random/boot_id 2>/dev/null || true)"
  auth_marker="$GARDEN_STATE/$state_ns/auth-ok-${auth_boot:-noboot}"
  [ -e "$auth_marker" ] && return 0

  if [ "$provider" = local ]; then
    if ! curl -fsS --max-time 5 "$GARDEN_LOCAL_OLLAMA_URL/models" >/dev/null 2>&1; then
      printf 'local inference endpoint %s not reachable; %s cannot run %q. Ensure ollama serve is running.\n' \
        "$GARDEN_LOCAL_OLLAMA_URL" "$kind" "$base" >&2
      return 1
    fi
  elif ! codex login status >/dev/null 2>&1; then
    printf 'codex is not authenticated on this host; %s cannot run %q. Run codex login as the bot user.\n' \
      "$kind" "$base" >&2
    return 1
  fi

  mkdir -p "$(dirname "$auth_marker")" 2>/dev/null || true
  : > "$auth_marker" 2>/dev/null || true
}

# codex_effort_for_model <model> <unified effort>
# Normalize Garden's common effort scale to Codex's model-specific ladder.
codex_effort_for_model() {
  local m="${1:?}" level="${2:-medium}" ladder
  case "$m" in
    gpt-5.6-terra) ladder="low medium high xhigh max ultra" ;;
    gpt-5.6-luna)  ladder="low medium high xhigh max" ;;
    gpt-5.5|gpt-5.4-mini) ladder="low medium high xhigh" ;;
    *)             ladder="low medium high xhigh" ;;
  esac
  case "$level" in minimal) level="low" ;; esac
  local axis="low medium high xhigh max ultra" want_rank=0 r=0 tok best=""
  for tok in $axis; do r=$((r + 1)); [ "$tok" = "$level" ] && want_rank=$r; done
  [ "$want_rank" -eq 0 ] && want_rank=2
  for tok in $ladder; do
    local ar=0 a
    for a in $axis; do ar=$((ar + 1)); [ "$a" = "$tok" ] && break; done
    [ "$ar" -le "$want_rank" ] && best="$tok"
  done
  printf '%s\n' "${best:-medium}"
}

# codex_provider_extra_args <provider>
# Set CODEX_PROVIDER_EXTRA_ARGS to the inline provider settings required by the
# existing hermit/Ollama route.  Keeping these settings here makes a foreman
# local attempt identical to a hermit local attempt.
codex_provider_extra_args() {
  local provider="${1:?provider}"
  # shellcheck disable=SC2034 # caller appends this shared array after invoking us
  CODEX_PROVIDER_EXTRA_ARGS=()
  [ "$provider" = local ] || return 0
  export OLLAMA_API_KEY="${OLLAMA_API_KEY:-ollama}"
  CODEX_PROVIDER_EXTRA_ARGS=(
    -c "model_provider=local"
    -c "model_providers.local.name=\"local-ollama\""
    -c "model_providers.local.base_url=\"$GARDEN_LOCAL_OLLAMA_URL\""
    -c "model_providers.local.env_key=\"OLLAMA_API_KEY\""
  )
}
