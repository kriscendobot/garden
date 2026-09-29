#!/bin/bash
# set-minion-mcp.sh — set or report the fleet-wide minion.town MCP standing order
# (journal2 config/minion-mcp; context/operations/minion-town-mcp.md).
#
# Usage:
#   set-minion-mcp.sh status                 print the committed config and this host's verdict
#   set-minion-mcp.sh on | off               fleet-wide switch (enabled: true|false)
#   set-minion-mcp.sh hosts '*' | <GARDEN>...    which hosts attach (default *)
#   set-minion-mcp.sh optout <GARDEN>... | none  hosts excluded even when `hosts` matches
#
# The file is fleet-wide journal state, so a newly stood-up host inherits it; every
# handler and the per-host watchdog read it through minion-mcp-lib.sh. Deleting the
# file restores the default: ON for every host. A single host can also opt out
# locally with GARDEN_MINION_MCP=off in its unit environment.

set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=common.sh
source "$HERE/common.sh"
# shellcheck source=minion-mcp-lib.sh
source "$HERE/minion-mcp-lib.sh"
export GARDEN_TAG="set-minion-mcp"
PATHREL="config/minion-mcp"

cmd="${1:?usage: set-minion-mcp.sh status | on | off | hosts <list> | optout <list>|none}"; shift || true
DIR="${GARDEN_PRODUCER_CLONE:-$GARDEN_STATE/producer/journal}"
ensure_clone "$DIR"

if [ "$cmd" = status ]; then
  sync_clone "$DIR"
  if [ -f "$DIR/$PATHREL" ]; then cat "$DIR/$PATHREL"; else echo "(no $PATHREL: default ON for every host)"; fi
  if GARDEN_MINION_MCP_CONFIG="$DIR/$PATHREL" minion_mcp_enabled_here; then
    echo "this host ($GARDEN): attach"
  else
    echo "this host ($GARDEN): skip ($MINION_MCP_SKIP_REASON)"
  fi
  hb="$GARDEN_STATE/minion-mcp/heartbeat.json"
  [ -f "$hb" ] && echo "heartbeat: $(jq -c . "$hb")"
  exit 0
fi

case "$cmd" in
  on|off) key=enabled; val=$([ "$cmd" = on ] && echo true || echo false) ;;
  hosts)  key=hosts; val="${*:?hosts: give '*' or one or more GARDEN identities}" ;;
  optout) key=optout-hosts; val="${*:?optout: give GARDEN identities or none}"; [ "$val" = none ] && val="" ;;
  *) die "unknown subcommand '$cmd'" ;;
esac

render() {  # render <file> — rewrite key=val, keeping the header and other keys
  local f="$1" tmp
  tmp="$(mktemp)"
  if [ ! -f "$f" ]; then
    cat > "$f" <<'EOF'
# minion.town MCP standing order (context/operations/minion-town-mcp.md).
# Read by every worker handler and the per-host watchdog via
# scripts/jobs/minion-mcp-lib.sh. Edit with scripts/jobs/set-minion-mcp.sh.
enabled: true
hosts: *
optout-hosts:
EOF
  fi
  awk -v k="$key" -v v="$val" '
    BEGIN { done = 0 }
    $0 ~ "^[[:space:]]*" k ":" { print k ": " v; done = 1; next }
    { print }
    END { if (!done) print k ": " v }' "$f" > "$tmp"
  mv -f "$tmp" "$f"
}

for attempt in $(seq 1 20); do
  sync_clone "$DIR"
  mkdir -p "$DIR/config"
  render "$DIR/$PATHREL"
  git -C "$DIR" add "$PATHREL"
  rc=0
  commit_and_push "$DIR" "config: minion-mcp $key -> ${val:-<empty>}" || rc=$?
  case "$rc" in
    0) log "set $PATHREL $key=${val:-<empty>}"; exit 0 ;;
    2) log "no change ($key already ${val:-<empty>})"; exit 0 ;;
    *) [ "$attempt" -lt 20 ] && continue ;;
  esac
done
echo "FAILED to write $PATHREL after 20 attempts" >&2
exit 1
