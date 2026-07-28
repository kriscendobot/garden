#!/bin/bash
# kimi-provider-common.sh: credential and invocation isolation for Mystic.
#
# Kimi Code deliberately does not read ordinary provider credentials directly from
# the shell. The supported KIMI_MODEL_* environment channel is its explicit,
# temporary configuration path. The caller maps MOONSHOT_API_KEY into that channel
# only for the child process, never writes it to config.toml, and never logs it.

# shellcheck shell=bash

kimi_provider_preflight() { # <base>
  local base="${1:?base}"
  command -v kimi >/dev/null 2>&1 || {
    printf 'kimi not on PATH; mystic cannot run %q. Install the official Kimi Code CLI.\n' "$base" >&2
    return 1
  }
  if [ -z "${MOONSHOT_API_KEY:-}" ]; then
    printf 'MOONSHOT_API_KEY: absent; mystic cannot run %q. Export it before secret-safe recreation of the garden container so the tmpfs-only handoff seeds the lingering systemd manager.\n' \
      "$base" >&2
    return 1
  fi
}

# kimi_model_environment <kimi-home> <model> <command...>
# Execute a command with the official Kimi Code CLI's temporary-model variables.
# Keep this as a function rather than writing config.toml: a credential can never
# escape the per-process environment into a persisted config file or another job's
# KIMI_CODE_HOME. `kimi-k3` is both the garden routing id and Moonshot's documented
# wire model id. The K3 context size is the current public K3 window.
kimi_model_environment() {
  local kimi_home="${1:?kimi home}" model="${2:?model}"; shift 2
  KIMI_CODE_HOME="$kimi_home" \
  KIMI_DISABLE_TELEMETRY=1 \
  KIMI_CODE_NO_AUTO_UPDATE=1 \
  KIMI_CODE_BACKGROUND_KEEP_ALIVE_ON_EXIT=0 \
  KIMI_CODE_AGENT_SWARM_MAX_CONCURRENCY=1 \
  KIMI_SUBAGENT_TIMEOUT_MS=600000 \
  KIMI_DISABLE_CRON=1 \
  KIMI_MODEL_NAME="$model" \
  KIMI_MODEL_API_KEY="$MOONSHOT_API_KEY" \
  KIMI_MODEL_PROVIDER_TYPE=kimi \
  KIMI_MODEL_BASE_URL=https://api.moonshot.ai/v1 \
  KIMI_MODEL_MAX_CONTEXT_SIZE=1048576 \
  KIMI_MODEL_CAPABILITIES=thinking,tool_use \
  env -u GARDEN_USAGE_FILE -u GARDEN_ENGAGEMENT_USAGE "$@"
}
