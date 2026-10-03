#!/bin/bash
# minion-mcp-lib.sh — attach the minion.town MCP server to a worker harness launch.
# Sourced (after common.sh) by every worker handler; the standing order and its
# operator surface are context/operations/minion-town-mcp.md.
#
# Every harness gets the SAME stdio server, minion-mcp-bridge.py, which relays to
# https://minion.town/mcp and fetches a bearer per request from the host-local token
# cache (minion-mcp-token.sh). The harness never sees the client secret, and a token
# that expires mid-job is refreshed transparently (Cognito tokens live 3600s; handler
# budgets reach 14339s).
#
# FAIL-OPEN BY CONTRACT. Attaching is best-effort: if the gate says no, or the token
# preflight fails, the handler launches the job WITHOUT the server after ONE log line.
# Nothing here may block a claim or fail a job. The per-host watchdog
# (minion-mcp-watchdog.sh) is what notices and repairs a lost connection.
#
# THE GATE (minion_mcp_enabled_here), first match wins:
#   1. env GARDEN_MINION_MCP=off|0|false|no  → off (host-local opt-out);
#      =on|1|true|yes → on, skipping the journal check (tests, manual proofs).
#   2. GARDEN_TEST=1 with GARDEN_MINION_MCP unset → off (tests never reach prod).
#   3. job header `minion-mcp: off` → off for that job.
#   4. journal config/minion-mcp (fleet-wide, see below) → its verdict.
#   5. no config file → ON. The standing order is default-on, so a newly stood-up
#      host inherits the connection without a hand edit.
#
# config/minion-mcp on journal2 (plain `key: value` lines, '#' comments):
#   enabled: true|false           fleet-wide switch (default true)
#   hosts: * | <GARDEN> ...       hosts allowed (default *)
#   optout-hosts: <GARDEN> ...    hosts excluded even when `hosts` matches
# It is read from the worker's own synced journal clone (GARDEN_WORKER_CLONE), else
# the host's journal worktree; GARDEN_MINION_MCP_CONFIG overrides the path.

: "${GARDEN_MINION_MCP:=}"
: "${GARDEN_MINION_MCP_PREFLIGHT_TIMEOUT:=60}"
MINION_MCP_SERVER_NAME="minion-town"
MINION_MCP_LIB_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
MINION_MCP_BRIDGE="$MINION_MCP_LIB_DIR/minion-mcp-bridge.py"
MINION_MCP_TOKEN="$MINION_MCP_LIB_DIR/minion-mcp-token.sh"
MINION_MCP_SKIP_REASON=""

minion_mcp_config_file() {
  if [ -n "${GARDEN_MINION_MCP_CONFIG:-}" ]; then printf '%s\n' "$GARDEN_MINION_MCP_CONFIG"; return; fi
  if [ -n "${GARDEN_WORKER_CLONE:-}" ] && [ -f "$GARDEN_WORKER_CLONE/config/minion-mcp" ]; then
    printf '%s\n' "$GARDEN_WORKER_CLONE/config/minion-mcp"; return
  fi
  printf '%s\n' "${GARDEN_ROOT:-.}/journal/config/minion-mcp"
}

# minion_mcp_config_value <file> <key> — the value of `key:` (comments stripped).
minion_mcp_config_value() {
  sed -n "s/^[[:space:]]*$2:[[:space:]]*//p" "$1" 2>/dev/null | head -1 | sed 's/[[:space:]]*#.*$//; s/[[:space:]]*$//'
}

# minion_mcp_list_has <list> <host> — list is space/comma separated; `*` matches all.
minion_mcp_list_has() {
  local item items
  read -ra items <<<"${1//,/ }"   # read -a, not an unquoted expansion: `*` must not glob
  for item in "${items[@]}"; do
    [ "$item" = '*' ] || [ "$item" = "$2" ] && return 0
  done
  return 1
}

# minion_mcp_enabled_here [jobfile] — 0 if the server should be attached on this
# host (for this job); else 1 with MINION_MCP_SKIP_REASON set.
minion_mcp_enabled_here() {
  local jobfile="${1:-}" host="${GARDEN:-$(hostname -s 2>/dev/null || echo host)}" cfg v hosts optout
  MINION_MCP_SKIP_REASON=""
  case "$(printf '%s' "$GARDEN_MINION_MCP" | tr '[:upper:]' '[:lower:]')" in
    off|0|false|no) MINION_MCP_SKIP_REASON="host opt-out (GARDEN_MINION_MCP=$GARDEN_MINION_MCP)"; return 1 ;;
    on|1|true|yes)  return 0 ;;
  esac
  if [ "${GARDEN_TEST:-0}" = 1 ]; then MINION_MCP_SKIP_REASON="test context"; return 1; fi
  if [ -n "$jobfile" ] && [ -f "$jobfile" ]; then
    case "$(sed -n 's/^minion-mcp:[[:space:]]*//p' "$jobfile" | head -1 | tr '[:upper:]' '[:lower:]' | tr -d "'\" ")" in
      off|false|no|0) MINION_MCP_SKIP_REASON="job opt-out (minion-mcp: off)"; return 1 ;;
    esac
  fi
  cfg="$(minion_mcp_config_file)"
  [ -f "$cfg" ] || return 0
  v="$(minion_mcp_config_value "$cfg" enabled | tr '[:upper:]' '[:lower:]')"
  case "$v" in false|off|no|0) MINION_MCP_SKIP_REASON="fleet-wide disabled (config/minion-mcp enabled: $v)"; return 1 ;; esac
  hosts="$(minion_mcp_config_value "$cfg" hosts)"; hosts="${hosts:-*}"
  optout="$(minion_mcp_config_value "$cfg" optout-hosts)"
  if ! minion_mcp_list_has "$hosts" "$host"; then
    MINION_MCP_SKIP_REASON="host $host not in config/minion-mcp hosts ($hosts)"; return 1
  fi
  if [ -n "$optout" ] && minion_mcp_list_has "$optout" "$host"; then
    MINION_MCP_SKIP_REASON="host $host in config/minion-mcp optout-hosts"; return 1
  fi
  return 0
}

# minion_mcp_prepare <base> [jobfile] — gate + token preflight. 0 → attach the
# server; 1 → launch without it (one log line already written, unless the gate
# said no quietly because of a test context).
minion_mcp_prepare() {
  local base="${1:-job}" jobfile="${2:-}" err
  if ! minion_mcp_enabled_here "$jobfile"; then
    [ "$MINION_MCP_SKIP_REASON" = "test context" ] || log "minion-mcp: not attaching for '$base': $MINION_MCP_SKIP_REASON"
    return 1
  fi
  if ! command -v python3 >/dev/null 2>&1 || [ ! -f "$MINION_MCP_BRIDGE" ]; then
    log "WARN minion-mcp: python3 or $MINION_MCP_BRIDGE missing; job '$base' starts without minion.town MCP"
    return 1
  fi
  if ! err="$(timeout "$GARDEN_MINION_MCP_PREFLIGHT_TIMEOUT" "$MINION_MCP_TOKEN" token 2>&1 >/dev/null)"; then
    log "WARN minion-mcp: token preflight failed; job '$base' starts without minion.town MCP: $(printf '%s' "$err" | tail -1 | head -c 300)"
    return 1
  fi
  return 0
}

# minion_mcp_env_json — the environment the bridge needs (it may be spawned with a
# scrubbed env: codex passes only an allowlist to stdio servers). No secret is in it:
# GARDEN_MINION_MCP_CRED_CMD is deliberately NOT forwarded (it could embed one), and
# AWS config paths are passed so a mid-job refresh can read the credential itself.
minion_mcp_env_json() {
  local args=() k
  for k in GARDEN_ROOT GARDEN_STATE GARDEN GARDEN_MINION_MCP_DIR GARDEN_MINION_MCP_URL \
           GARDEN_MINION_MCP_SECRET_ID GARDEN_MINION_MCP_AWS_REGION GARDEN_MINION_MCP_TOKEN_URL \
           HOME PATH AWS_PROFILE AWS_CONFIG_FILE \
           AWS_SHARED_CREDENTIALS_FILE AWS_REGION AWS_DEFAULT_REGION; do
    [ -n "${!k:-}" ] && args+=(--arg "$k" "${!k}")
  done
  jq -cn '$ARGS.named' "${args[@]}"
}

# minion_mcp_claude_config — the JSON for `claude -p --mcp-config <json>`.
minion_mcp_claude_config() {
  jq -cn --arg name "$MINION_MCP_SERVER_NAME" --arg bridge "$MINION_MCP_BRIDGE" \
     --argjson env "$(minion_mcp_env_json)" \
     '{mcpServers:{($name):{type:"stdio", command:"python3", args:[$bridge], env:$env}}}'
}

# minion_mcp_codex_persisted <name> <file>... — 0 if any codex config.toml given
# already declares mcp_servers.<name> (in any TOML spelling). codex MERGES `-c`
# overrides into a persisted table rather than replacing it, so a persisted
# `url = ...` entry (e.g. from an interactive `codex mcp add --url`) plus our inline
# `command = ...` is a config-load error that kills codex before the job starts
# (2026-10-03: every cleric job died in ~10s). An unparseable file falls back to a
# grep; a missing file declares nothing.
minion_mcp_codex_persisted() {
  local name="$1" f; shift
  for f in "$@"; do
    [ -f "$f" ] || continue
    python3 - "$name" "$f" 2>/dev/null <<'PY' && return 0
import sys
name, path = sys.argv[1], sys.argv[2]
try:
    import tomllib
    with open(path, "rb") as fh:
        doc = tomllib.load(fh)
except Exception:
    import re
    text = open(path, encoding="utf-8", errors="replace").read()
    pat = r'(^|\n)\s*(\[\s*)?mcp_servers\s*\.\s*["\']?' + re.escape(name) + r'["\']?\s*[.=\]]'
    sys.exit(0 if re.search(pat, text) else 1)
servers = doc.get("mcp_servers")
sys.exit(0 if isinstance(servers, dict) and name in servers else 1)
PY
  done
  return 1
}

# minion_mcp_codex_args [worktree] — fill MINION_MCP_CODEX_ARGS with `-c` overrides
# that declare the bridge as a codex stdio MCP server (values are TOML), and set
# MINION_MCP_CODEX_NAME to the server name used. If the codex user config
# ($CODEX_HOME/config.toml) or the worktree's project config already declares
# minion-town, that entry is disabled with `enabled=false` (a key valid for both
# url and stdio servers, so the merge stays loadable) and the bridge is declared
# under minion-town-garden instead. Returns 1 (fail open: launch without the
# server) only if the alternate name is persisted too.
# shellcheck disable=SC2034  # MINION_MCP_CODEX_ARGS/_NAME are read by the sourcing handler
minion_mcp_codex_args() {
  local worktree="${1:-}" name="$MINION_MCP_SERVER_NAME" p env_toml
  local files=("${CODEX_HOME:-$HOME/.codex}/config.toml")
  [ -n "$worktree" ] && files+=("$worktree/.codex/config.toml")
  MINION_MCP_CODEX_ARGS=()
  if minion_mcp_codex_persisted "$name" "${files[@]}"; then
    MINION_MCP_CODEX_ARGS+=(-c "mcp_servers.$name.enabled=false")
    name="$name-garden"
    if minion_mcp_codex_persisted "$name" "${files[@]}"; then
      MINION_MCP_SKIP_REASON="codex config already declares mcp_servers.$MINION_MCP_SERVER_NAME and mcp_servers.$name"
      MINION_MCP_CODEX_ARGS=()
      return 1
    fi
    MINION_MCP_SKIP_REASON="codex config persists mcp_servers.$MINION_MCP_SERVER_NAME; disabled it and attached the bridge as $name"
  fi
  MINION_MCP_CODEX_NAME="$name"
  p="mcp_servers.$name"
  env_toml="$(minion_mcp_env_json | jq -r 'to_entries | map("\(.key)=\(.value | tojson)") | "{" + join(",") + "}"')"
  MINION_MCP_CODEX_ARGS+=(
    -c "$p.command=\"python3\""
    -c "$p.args=[$(jq -cn --arg b "$MINION_MCP_BRIDGE" '$b')]"
    -c "$p.env=$env_toml"
    -c "$p.startup_timeout_sec=60"
    -c "$p.tool_timeout_sec=600"
  )
}

# minion_mcp_kimi_write <kimi-home> <on|off> — Kimi Code reads MCP servers only from
# $KIMI_CODE_HOME/mcp.json (no CLI flag); the mystic's home is private per job.
minion_mcp_kimi_write() {
  local home="${1:?kimi home}" mode="${2:-on}" f
  f="$home/mcp.json"
  if [ "$mode" != on ]; then rm -f "$f"; return 0; fi
  jq -n --arg name "$MINION_MCP_SERVER_NAME" --arg bridge "$MINION_MCP_BRIDGE" \
     --argjson env "$(minion_mcp_env_json)" \
     '{mcpServers:{($name):{command:"python3", args:[$bridge], env:$env, toolTimeoutMs:600000}}}' > "$f"
  chmod 600 "$f" 2>/dev/null || true
}

# minion_mcp_opencode_config <config-json> — merge the bridge into an OpenCode
# OPENCODE_CONFIG_CONTENT document (OpenCode's `mcp` map, type local).
minion_mcp_opencode_config() {
  jq -c --arg name "$MINION_MCP_SERVER_NAME" --arg bridge "$MINION_MCP_BRIDGE" \
     --argjson env "$(minion_mcp_env_json)" \
     '.mcp[$name] = {type:"local", command:["python3", $bridge], environment:$env, enabled:true}' <<<"${1:-"{}"}"
}
