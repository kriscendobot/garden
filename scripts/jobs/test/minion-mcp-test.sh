#!/bin/bash
# minion-mcp-test.sh — guard for the minion.town MCP standing order
# (context/operations/minion-town-mcp.md): the token cache, the stdio bridge's
# reconnect behavior, the handler attach gate, and the watchdog's edge-latched alerts.
#
# Hermetic: a local fake OAuth token endpoint + streamable-HTTP MCP server
# (minion-mcp-fake-server.py) stands in for Cognito and minion.town, and a
# GARDEN_MINION_MCP_CRED_CMD stands in for Secrets Manager. Nothing reaches AWS or
# production.
#
# Usage: minion-mcp-test.sh
set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
JOBS="$(cd "$HERE/.." && pwd)"
PASS=0; FAIL=0
ok()  { echo "  PASS: $*"; PASS=$((PASS+1)); }
bad() { echo "  FAIL: $*"; FAIL=$((FAIL+1)); }
check() { local d="$1"; shift; if "$@"; then ok "$d"; else bad "$d"; fi; }

T="$(mktemp -d "${TMPDIR:-/tmp}/minion-mcp-test.XXXXXX")"
SRV="$T/srv"; mkdir -p "$SRV"; : > "$SRV/control"
python3 "$HERE/minion-mcp-fake-server.py" "$SRV" & SRV_PID=$!
trap 'kill $SRV_PID 2>/dev/null; rm -rf "$T"' EXIT
for _ in $(seq 50); do [ -s "$SRV/port" ] && break; sleep 0.1; done
PORT="$(cat "$SRV/port")"

export GARDEN_TEST=1 GARDEN_STATE="$T/state" GARDEN=test-host-abc
export GARDEN_MINION_MCP_DIR="$T/state/minion-mcp"
export CODEX_HOME="$T/codex-home"   # never read the host's real ~/.codex/config.toml
export GARDEN_MINION_MCP_CRED_CMD="printf '%s' '{\"client_id\":\"cid\",\"client_secret\":\"sec\"}'"
export GARDEN_MINION_MCP_TOKEN_URL="http://127.0.0.1:$PORT/oauth2/token"
export GARDEN_MINION_MCP_URL="http://127.0.0.1:$PORT/mcp"
TOK="$JOBS/minion-mcp-token.sh"
BRIDGE="$JOBS/minion-mcp-bridge.py"
grants() { cat "$SRV/grants" 2>/dev/null || echo 0; }
inits()  { cat "$SRV/inits" 2>/dev/null || echo 0; }
mode()   { printf '%s\n' "$@" > "$SRV/control"; rm -f "$SRV/revoked_at"; }

echo "== token cache"
t1="$("$TOK" token 2>/dev/null)"
check "first token call grants once" [ "$(grants)" = 1 ]
t2="$("$TOK" token 2>/dev/null)"
check "second call is served from the cache" [ "$(grants)" = 1 ] && [ "$t1" = "$t2" ]
check "cache file is 0600" [ "$(stat -c %a "$GARDEN_MINION_MCP_DIR/token.json")" = 600 ]
check "cache dir is 0700" [ "$(stat -c %a "$GARDEN_MINION_MCP_DIR")" = 700 ]
check "status never prints the token" bash -c '! "$0" status | grep -q "$1"' "$TOK" "$t1"
"$TOK" token --force >/dev/null 2>&1
check "--force grants a fresh token" [ "$(grants)" = 2 ]
mode expires=30   # inside the 600s refresh margin: every call must refresh
"$TOK" token --force >/dev/null 2>&1; "$TOK" token >/dev/null 2>&1
check "a token inside the refresh margin is refreshed" [ "$(grants)" = 4 ]
mode
check "headers prints a Bearer Authorization object" bash -c '"$0" headers | jq -e ".Authorization | startswith(\"Bearer \")" >/dev/null' "$TOK"
check "a bad credential fails without printing a token" bash -c 'out="$(GARDEN_MINION_MCP_CRED_CMD="echo {}" "$0" token --force 2>/dev/null)"; [ $? -ne 0 ] && [ -z "$out" ]' "$TOK"

echo "== bridge"
INIT='{"jsonrpc":"2.0","id":1,"method":"initialize","params":{"protocolVersion":"2025-06-18","capabilities":{},"clientInfo":{"name":"t","version":"0"}}}'
NOTE='{"jsonrpc":"2.0","method":"notifications/initialized"}'
CALL='{"jsonrpc":"2.0","id":2,"method":"tools/call","params":{"name":"status","arguments":{}}}'
bridge_session() {  # feeds initialize, then runs "$@" between messages, then a call
  { printf '%s\n%s\n' "$INIT" "$NOTE"; sleep 0.5; "$@"; printf '%s\n' "$CALL"; } | timeout 30 python3 "$BRIDGE" 2>"$T/bridge.err"
}
out="$(bridge_session true)"
check "bridge relays initialize" grep -q '"id":1,"result"\|"result".*"id":1' <<<"$out"
check "bridge relays tools/call" grep -q 'guest holds 7' <<<"$out"
out="$(python3 "$BRIDGE" --probe 2>/dev/null)"
check "probe lists the tools" [ "$(jq -r '.tools | join(",")' <<<"$out")" = "status,list" ]

g0="$(grants)"
out="$(bridge_session mode revoke)"
check "401 mid-session: bridge refreshes the token and the call succeeds" grep -q 'guest holds 7' <<<"$out"
check "401 mid-session: exactly one fresh grant" [ "$(grants)" = $((g0 + 1)) ]
mode
i0="$(inits)"
out="$(bridge_session mode forget)"
check "404 session loss: bridge re-initializes and the call succeeds" grep -q 'guest holds 7' <<<"$out"
check "404 session loss: one replayed initialize" [ "$(inits)" = $((i0 + 2)) ]
mode
out="$(bridge_session mode down)"
check "server down: the pending call gets a JSON-RPC error, not a hang" bash -c 'jq -e "select(.id == 2) | .error.message | test(\"unreachable\")" <<<"$0" >/dev/null' "$out"
mode

echo "== attach gate (minion-mcp-lib.sh)"
gate() {  # gate <env...> -- verdict via a subshell so env stays scoped
  env "$@" bash -c 'source "$0/common.sh" >/dev/null 2>&1; source "$0/minion-mcp-lib.sh"; minion_mcp_enabled_here "${JOBF:-}" && echo on || echo "off:$MINION_MCP_SKIP_REASON"' "$JOBS"
}
CFG="$T/minion-mcp.cfg"
check "GARDEN_TEST=1 defaults off" [ "$(gate GARDEN_MINION_MCP= )" = "off:test context" ]
check "GARDEN_MINION_MCP=on forces on" [ "$(gate GARDEN_MINION_MCP=on)" = on ]
check "GARDEN_MINION_MCP=off opts the host out" bash -c '[[ "$0" == off:host\ opt-out* ]]' "$(gate GARDEN_MINION_MCP=off)"
check "absent config defaults ON (durable default)" [ "$(gate GARDEN_TEST=0 GARDEN_MINION_MCP_CONFIG="$T/none")" = on ]
printf 'enabled: false\n' > "$CFG"
check "enabled: false turns the fleet off" bash -c '[[ "$0" == off:fleet-wide* ]]' "$(gate GARDEN_TEST=0 GARDEN_MINION_MCP_CONFIG="$CFG")"
printf 'enabled: true\nhosts: other-host  # proving host\n' > "$CFG"
check "a host outside hosts: is skipped" bash -c '[[ "$0" == off:host\ test-host-abc\ not* ]]' "$(gate GARDEN_TEST=0 GARDEN_MINION_MCP_CONFIG="$CFG")"
printf 'hosts: other-host, test-host-abc\n' > "$CFG"
check "a host inside hosts: attaches" [ "$(gate GARDEN_TEST=0 GARDEN_MINION_MCP_CONFIG="$CFG")" = on ]
printf 'hosts: *\noptout-hosts: test-host-abc\n' > "$CFG"
check "optout-hosts: wins over hosts: *" bash -c '[[ "$0" == *optout-hosts ]]' "$(gate GARDEN_TEST=0 GARDEN_MINION_MCP_CONFIG="$CFG")"
printf -- '---\nrole: builder\nminion-mcp: off\n---\nbody\n' > "$T/job.md"
check "job header minion-mcp: off skips that job" bash -c '[[ "$0" == off:job\ opt-out* ]]' "$(gate GARDEN_TEST=0 GARDEN_MINION_MCP_CONFIG="$T/none" JOBF="$T/job.md")"

echo "== attach shapes"
lib() { GARDEN_MINION_MCP=on bash -c 'source "$0/common.sh" >/dev/null 2>&1; source "$0/minion-mcp-lib.sh"; '"$1" "$JOBS"; }
lib 'minion_mcp_prepare t' >/dev/null 2>&1 && ok "minion_mcp_prepare returns 0 when the token is obtainable" || bad "minion_mcp_prepare returns 0 when the token is obtainable"
err="$(GARDEN_MINION_MCP_CRED_CMD=false lib 'rm -f "$GARDEN_MINION_MCP_DIR/token.json"; minion_mcp_prepare t && echo ATTACHED' 2>&1 || true)"
check "prepare fails open: no attach, one WARN line" bash -c '! grep -q ATTACHED <<<"$0" && [ "$(grep -c "WARN minion-mcp" <<<"$0")" = 1 ]' "$err"
cfg="$(lib 'minion_mcp_claude_config')"
check "claude config is a stdio server running the bridge" bash -c 'jq -e ".mcpServers[\"minion-town\"] | .type == \"stdio\" and .command == \"python3\" and (.args[0] | endswith(\"minion-mcp-bridge.py\"))" <<<"$0" >/dev/null' "$cfg"
check "claude config carries no token or secret" bash -c '! grep -q "eyJ\|client_secret\|\"sec\"" <<<"$0"' "$cfg"
codex="$(lib 'minion_mcp_codex_args; printf "%s\n" "${MINION_MCP_CODEX_ARGS[@]}"')"
check "codex args are one complete server table for minion-town" bash -c '[ "$(grep -c "^mcp_servers\." <<<"$0")" = 1 ] && grep -q "^mcp_servers.minion-town={command=\"python3\",args=\[\".*minion-mcp-bridge.py\"\],env={.*GARDEN_STATE=.*},startup_timeout_sec=60,tool_timeout_sec=600}$" <<<"$0"' "$codex"
check "codex server table parses as TOML with exactly the stdio keys" bash -c 'python3 -c "import sys,tomllib; t=tomllib.loads(sys.argv[1])[\"mcp_servers\"][\"minion-town\"]; sys.exit(0 if sorted(t)==[\"args\",\"command\",\"env\",\"startup_timeout_sec\",\"tool_timeout_sec\"] and t[\"args\"][0].endswith(\"minion-mcp-bridge.py\") else 1)" "$(grep "^mcp_servers\." <<<"$0")"' "$codex"
CH="$CODEX_HOME"; mkdir -p "$CH"
codex_named() { CODEX_HOME="$CH" lib 'minion_mcp_codex_args '"${1:-}"' && echo "NAME=$MINION_MCP_CODEX_NAME" || echo "SKIP=$MINION_MCP_SKIP_REASON"; printf "%s\n" "${MINION_MCP_CODEX_ARGS[@]}"'; }
check "codex: no persisted entry keeps the minion-town name" grep -qx 'NAME=minion-town' <<<"$(codex_named)"
printf '[mcp_servers.minion-town]\nurl = "https://minion.town/mcp"\n\n[mcp_servers.minion-town.oauth]\nclient_id = "x"\n' > "$CH/config.toml"
codex="$(codex_named)"
check "codex: a persisted url entry is disabled, never merged into" bash -c 'grep -qx "mcp_servers.minion-town.enabled=false" <<<"$0" && ! grep -q "^mcp_servers.minion-town.command" <<<"$0"' "$codex"
check "codex: the bridge is attached under minion-town-garden" bash -c 'grep -qx "NAME=minion-town-garden" <<<"$0" && grep -q "^mcp_servers.minion-town-garden={command=\"python3\"," <<<"$0"' "$codex"
printf '[mcp_servers]\n"minion-town" = { url = "https://minion.town/mcp" }\n' > "$CH/config.toml"
check "codex: an inline-table spelling is detected too" grep -qx 'NAME=minion-town-garden' <<<"$(codex_named)"
printf '[mcp_servers.minion-town]\nurl = "u"\n[mcp_servers.minion-town-garden]\nurl = "u"\n' > "$CH/config.toml"
check "codex: both names persisted fails open (no args)" bash -c 'grep -q "^SKIP=codex config already declares" <<<"$0" && ! grep -q "^-c" <<<"$0"' "$(codex_named)"
rm -f "$CH/config.toml"; mkdir -p "$T/wt/.codex"; printf 'mcp_servers.minion-town.url = "u"\n' > "$T/wt/.codex/config.toml"
check "codex: a worktree project config entry is detected" grep -qx 'NAME=minion-town-garden' <<<"$(codex_named "$T/wt")"
if command -v codex >/dev/null 2>&1; then
  for persisted in 'url:[mcp_servers.minion-town]\nurl = "https://minion.town/mcp"\n' \
                   'url+bearer+headers:[mcp_servers.minion-town]\nurl = "https://minion.town/mcp"\nbearer_token_env_var = "MT_TOKEN"\nhttp_headers = { X-A = "b" }\n' \
                   'inline url table:[mcp_servers]\n"minion-town" = { url = "https://minion.town/mcp" }\n'; do
    printf '%b' "${persisted#*:}" > "$CH/config.toml"
    mapfile -t cargs < <(CODEX_HOME="$CH" lib 'minion_mcp_codex_args; printf "%s\n" "${MINION_MCP_CODEX_ARGS[@]}"')
    check "codex: the real CLI loads with a persisted ${persisted%%:*} entry" bash -c 'CODEX_HOME="$0" codex "$@" mcp list 2>/dev/null | grep -q "^minion-town-garden  *python3 .*minion-mcp-bridge.py"' "$CH" "${cargs[@]}"
  done
  # Why the rename exists: codex deep-merges even a complete table override, so
  # replacing the persisted entry in place is not possible. If a codex upgrade
  # makes this load, the rename can be retired.
  printf '[mcp_servers.minion-town]\nurl = "https://minion.town/mcp"\n' > "$CH/config.toml"
  if CODEX_HOME="$CH" codex -c 'mcp_servers.minion-town={command="python3",args=["x"]}' mcp list >/dev/null 2>&1; then
    echo "  NOTE: codex now replaces a table-valued -c override; the minion-town-garden rename is no longer required"
  fi
fi
lib "minion_mcp_kimi_write '$T' on" >/dev/null
check "kimi mcp.json is written 0600 with the bridge" bash -c '[ "$(stat -c %a "$0/mcp.json")" = 600 ] && jq -e ".mcpServers[\"minion-town\"].args[0] | endswith(\"minion-mcp-bridge.py\")" "$0/mcp.json" >/dev/null' "$T"
lib "minion_mcp_kimi_write '$T' off" >/dev/null
check "kimi mcp.json is removed when not attaching" [ ! -e "$T/mcp.json" ]
oc="$(lib "minion_mcp_opencode_config '{\"share\":\"disabled\"}'")"
check "opencode config keeps existing keys and adds a local mcp server" bash -c 'jq -e ".share == \"disabled\" and .mcp[\"minion-town\"].type == \"local\"" <<<"$0" >/dev/null' "$oc"

echo "== watchdog"
NOTICES="$T/notices"; : > "$NOTICES"
cat > "$T/notice.sh" <<EOF
#!/bin/bash
body="\$(cat)"; printf '%s|%s\n' "\$*" "\$(printf '%s' "\$body" | head -1)" >> "$NOTICES"
EOF
chmod +x "$T/notice.sh"
wd() { GARDEN_MINION_MCP=on GARDEN_MINION_MCP_NOTICE_CMD="$T/notice.sh" GARDEN_MINION_MCP_PROBE_TIMEOUT=20 "$JOBS/minion-mcp-watchdog.sh" >/dev/null 2>&1; }
hb() { jq -r ".$1" "$GARDEN_MINION_MCP_DIR/heartbeat.json"; }
wd
check "healthy tick: heartbeat ok with the tool count" [ "$(hb state)/$(hb tools)" = ok/2 ]
check "healthy tick: no notice" [ ! -s "$NOTICES" ]
chmod 644 "$GARDEN_MINION_MCP_DIR/token.json"; echo garbage > "$GARDEN_MINION_MCP_DIR/token.json"
wd
check "drift repair: a corrupt cache is replaced and the tick passes" bash -c '[ "$(jq -r .state "$0/heartbeat.json")" = ok ] && jq -e .access_token "$0/token.json" >/dev/null && [ "$(stat -c %a "$0/token.json")" = 600 ]' "$GARDEN_MINION_MCP_DIR"
mode down
wd
check "lost connection: heartbeat down" [ "$(hb state)" = down ]
check "lost connection: exactly one LOST notice" [ "$(grep -c 'LOST' "$NOTICES")" = 1 ]
check "the notice keys this host" grep -q "minion-mcp-connection-test-host-abc" "$NOTICES"
wd
check "still down: no second notice (edge-latched)" [ "$(wc -l < "$NOTICES")" = 1 ]
mode
wd
check "recovered: heartbeat ok" [ "$(hb state)" = ok ]
check "recovered: one --recovered notice" [ "$(grep -c -- '--recovered.*RECOVERED' "$NOTICES")" = 1 ]
check "recovered: latch cleared" [ ! -e "$GARDEN_MINION_MCP_DIR/watchdog.down" ]
GARDEN_MINION_MCP=off GARDEN_MINION_MCP_NOTICE_CMD="$T/notice.sh" "$JOBS/minion-mcp-watchdog.sh" >/dev/null 2>&1
check "disabled host: heartbeat disabled, no notice" bash -c '[ "$(jq -r .state "$0/heartbeat.json")" = disabled ] && [ "$(wc -l < "$1")" = 2 ]' "$GARDEN_MINION_MCP_DIR" "$NOTICES"
mode revoke
wd
check "revoked token: the watchdog reconnects with a fresh grant (no alert)" bash -c '[ "$(jq -r .state "$0/heartbeat.json")" = ok ] && [ "$(wc -l < "$1")" = 2 ]' "$GARDEN_MINION_MCP_DIR" "$NOTICES"

echo
echo "minion-mcp-test: $PASS passed, $FAIL failed"
[ "$FAIL" -eq 0 ]
