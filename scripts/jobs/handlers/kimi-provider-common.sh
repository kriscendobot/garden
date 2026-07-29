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

# meter_kimi_home_usage <kimi-home> — the moonshot/kimi lane's cost-ledger capture
# source (designs/token-cost-ledger.md § Capture).  Kimi Code does NOT write Claude
# Code's ~/.claude session logs and its `--output-format` streams carry no usage, so
# neither the ladder's layer-1 (CLI result envelope) nor layer-2 (~/.claude delta)
# reaches this lane — it needs this lane-specific capture.  Kimi records each turn's
# provider usage to its own session wire log under KIMI_CODE_HOME as a
# `{"type":"usage.record","usageScope":"turn","usage":{inputOther,output,
# inputCacheRead,inputCacheCreation}}` line; we sum those, mapping Kimi's field names
# onto the ledger's four token classes.  Kimi reports no provider dollars (like
# codex), so rows on this lane are measured-but-unpriced — never a guessed rate.
#
# Prints  <input>\t<output>\t<cache_creation>\t<cache_read>  and returns 0 (a sum of
# 0 is a genuine zero: no home, or a home with no turn records yet).  Returns 1 when
# the measurement is UNKNOWN (jq absent, or the home exists but is unreadable) so the
# caller omits the file and the engagement is honestly recorded source:none rather
# than a fabricated zero.  The handler snapshots this before/after one invocation so
# the delta is exactly that invocation's turns, correct across a persisted --continue
# resume home.
meter_kimi_home_usage() { # <kimi-home>
  local home="${1:?kimi home}" files out
  command -v jq >/dev/null 2>&1 || return 1
  [ -e "$home" ] || { printf '0\t0\t0\t0\n'; return 0; }   # no home yet → genuine 0
  [ -r "$home" ] && [ -x "$home" ] || return 1              # present but unreadable → unknown
  files="$(find "$home" -type f -name 'wire.jsonl' -print 2>/dev/null)" || return 1
  [ -n "$files" ] || { printf '0\t0\t0\t0\n'; return 0; }   # no turn logs → genuine 0
  out="$(printf '%s' "$files" | tr '\n' '\0' | xargs -0 jq -Rr '
      fromjson? // empty
      | select(.type=="usage.record" and .usageScope=="turn" and (.usage != null))
      | [ (.usage.inputOther // 0), (.usage.output // 0),
          (.usage.inputCacheCreation // 0), (.usage.inputCacheRead // 0) ] | @tsv' 2>/dev/null |
    awk -F'\t' '{i+=$1;o+=$2;c+=$3;r+=$4} END {printf "%d\t%d\t%d\t%d\n",i,o,c,r}')" || return 1
  case "$out" in *$'\t'*$'\t'*$'\t'*) printf '%s\n' "$out" ;; *) return 1 ;; esac
}
