#!/bin/bash
# minion-mcp-watchdog.sh — per-host, no-LLM health check for the minion.town MCP
# connection every worker harness attaches (standing order:
# context/operations/minion-town-mcp.md). Driven by garden-minion-mcp-watchdog.timer
# on EVERY host (not leader-gated: each host holds its own token cache and its own
# AWS credential path, so each host can lose the connection independently).
#
# One tick:
#   1. Gate. The same gate the handlers use (minion-mcp-lib.sh). When the connection is
#      off for this host, record a `disabled` heartbeat, close any open alert, and stop.
#   2. Repair drift. Re-assert the 0700 cache directory and 0600 token file, and
#      discard a cache that is not valid JSON.
#   3. Probe. Token acquisition + MCP initialize + tools/list through the SAME stdio
#      bridge the workers spawn (minion-mcp-bridge.py --probe), so a pass means a
#      worker launched now would get the tools.
#   4. Reconnect. On failure, discard the cached token, force a fresh grant, and
#      probe again.
#   5. Alert, edge-latched. The first failed tick posts ONE watchdog-notice.sh notice;
#      later failures are silent while the latch is set; the first passing tick after
#      that posts the --recovered close-out and clears the latch.
#   6. Heartbeat. $GARDEN_MINION_MCP_DIR/heartbeat.json records the time, state
#      (ok|down|disabled), tool count, and detail, so a stale watchdog is visible.
#
# Always exits 0 on a completed tick (the alert is the signal, not the unit state), so
# a lost connection never trips self-heal into spawning an agent.
#
# Test overrides: GARDEN_MINION_MCP_NOTICE_CMD (default watchdog-notice.sh),
# GARDEN_MINION_MCP_PROBE_TIMEOUT.

set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=common.sh
source "$HERE/common.sh"
# shellcheck source=minion-mcp-lib.sh
source "$HERE/minion-mcp-lib.sh"
export GARDEN_TAG="${GARDEN_TAG:-minion-mcp-watchdog}"

: "${GARDEN_MINION_MCP_DIR:=$GARDEN_STATE/minion-mcp}"
: "${GARDEN_MINION_MCP_NOTICE_CMD:=$HERE/watchdog-notice.sh}"
: "${GARDEN_MINION_MCP_PROBE_TIMEOUT:=90}"
export GARDEN_MINION_MCP_DIR
LATCH="$GARDEN_MINION_MCP_DIR/watchdog.down"
HEARTBEAT="$GARDEN_MINION_MCP_DIR/heartbeat.json"
KEY="minion-mcp-connection-$GARDEN"
now_iso() { date -u +%Y-%m-%dT%H:%M:%SZ; }

umask 077
mkdir -p "$GARDEN_MINION_MCP_DIR"

heartbeat() {  # heartbeat <state> <tools> <detail>
  local tmp
  tmp="$(mktemp "$GARDEN_MINION_MCP_DIR/.heartbeat.XXXXXX")"
  jq -n --arg at "$(now_iso)" --arg host "$GARDEN" --arg state "$1" --argjson tools "${2:-0}" \
        --arg detail "$3" --arg since "$(cat "$LATCH" 2>/dev/null || true)" \
     '{at:$at, host:$host, state:$state, tools:$tools, detail:$detail} + (if $since == "" then {} else {down_since:$since} end)' > "$tmp"
  mv -f "$tmp" "$HEARTBEAT"
}

notice() {  # notice <body> [--recovered]
  local body="$1"; shift
  printf '%s\n' "$body" | "$GARDEN_MINION_MCP_NOTICE_CMD" "$@" "$KEY" \
    || log "WARN could not deliver the $KEY notice (will retry on the next edge)"
}

# --- 1. gate --------------------------------------------------------------------
if ! minion_mcp_enabled_here; then
  if [ -e "$LATCH" ]; then
    notice "minion.town MCP on $GARDEN: the connection was turned off ($MINION_MCP_SKIP_REASON) while it was down; closing the alert." --recovered
    rm -f "$LATCH"
  fi
  heartbeat disabled 0 "$MINION_MCP_SKIP_REASON"
  log "minion.town MCP disabled here: $MINION_MCP_SKIP_REASON"
  exit 0
fi

# --- 2. drift repair ------------------------------------------------------------
chmod 700 "$GARDEN_MINION_MCP_DIR" 2>/dev/null || true
if [ -e "$GARDEN_MINION_MCP_DIR/token.json" ]; then
  chmod 600 "$GARDEN_MINION_MCP_DIR/token.json" 2>/dev/null || true
  jq -e . "$GARDEN_MINION_MCP_DIR/token.json" >/dev/null 2>&1 \
    || { log "repair: discarding a corrupt token cache"; rm -f "$GARDEN_MINION_MCP_DIR/token.json"; }
fi

# --- 3/4. probe, reconnect once -------------------------------------------------
probe() {
  timeout "$GARDEN_MINION_MCP_PROBE_TIMEOUT" python3 "$MINION_MCP_BRIDGE" --probe 2>"$GARDEN_MINION_MCP_DIR/probe.err"
}
summary=""
if ! summary="$(probe)"; then
  log "probe failed ($(jq -r '.error // empty' <<<"$summary" 2>/dev/null || true)); forcing a fresh token and re-probing"
  "$MINION_MCP_TOKEN" token --force >/dev/null 2>>"$GARDEN_MINION_MCP_DIR/probe.err" || true
  summary="$(probe)" || true
  [ -n "$summary" ] || summary='{"ok":false}'
fi

ok="$(jq -r '.ok // false' <<<"$summary" 2>/dev/null || echo false)"
tools="$(jq -r '(.tools // []) | length' <<<"$summary" 2>/dev/null || echo 0)"
if [ "$ok" = true ]; then
  if [ -e "$LATCH" ]; then
    notice "minion.town MCP on $GARDEN RECOVERED at $(now_iso) (down since $(cat "$LATCH")); tools/list returns $tools tools." --recovered
    rm -f "$LATCH"
    log "RECOVERED: $tools tools"
  fi
  heartbeat ok "$tools" "tools/list returned $tools tools"
  exit 0
fi

detail="$(jq -r '.error // "probe produced no summary"' <<<"$summary" 2>/dev/null || echo "probe produced no summary")"
err_tail="$(tail -n 3 "$GARDEN_MINION_MCP_DIR/probe.err" 2>/dev/null | sed 's/eyJ[A-Za-z0-9._-]*/<redacted>/g' | head -c 600 || true)"
if [ ! -e "$LATCH" ]; then
  now_iso > "$LATCH"
  notice "$(printf 'minion.town MCP connection LOST on %s at %s.\n\nThe per-host watchdog could not complete token acquisition + MCP initialize + tools/list against %s, even after forcing a fresh token. Worker jobs on this host still run, without the minion.town tools, until it recovers.\n\nDetail: %s\n%s\n\nRunbook: context/operations/minion-town-mcp.md (\"When the watchdog alerts\"). One recovery notice will follow when it reconnects.' \
    "$GARDEN" "$(now_iso)" "${GARDEN_MINION_MCP_URL:-https://minion.town/mcp}" "$detail" "$err_tail")"
  log "LOST: $detail"
else
  log "still down since $(cat "$LATCH"): $detail"
fi
heartbeat down 0 "$detail"
exit 0
