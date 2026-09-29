#!/bin/bash
# minion-mcp-token.sh — host-local OAuth access-token cache for the minion.town MCP
# server (https://minion.town/mcp), the credential half of the standing order in
# context/operations/minion-town-mcp.md.
#
# Usage:
#   minion-mcp-token.sh token [--force]  print a valid access token on stdout
#                                        (refreshed when within the margin of expiry;
#                                        --force discards the cache first)
#   minion-mcp-token.sh headers          print {"Authorization":"Bearer …"} (the shape
#                                        a Claude Code headersHelper expects)
#   minion-mcp-token.sh invalidate       discard the cached token
#   minion-mcp-token.sh status           print cache metadata as JSON (client id, scope,
#                                        seconds to expiry), NEVER the token itself
#
# THE GRANT. OAuth client_credentials at the Cognito token endpoint, scope
# `mcp/tools mcp/guest`. The client id and secret live in AWS Secrets Manager
# (`minion/test-cc-client`, us-west-1), read with the host's ambient `garden-fleet`
# AWS credentials at REFRESH time only. The secret is never written to disk, never
# put on a command line (curl reads it from a stdin config), and never reaches a
# worker's environment: workers see only the stdio bridge (minion-mcp-bridge.py),
# which asks this script for a bearer token.
#
# THE CACHE. $GARDEN_STATE/minion-mcp/token.json, mode 0600 in a 0700 directory,
# host-local (never the repo, never the journal). Cognito access tokens live 3600s,
# far shorter than a handler budget (up to 14339s), so a cached token is only half
# the answer: the bridge re-asks per request and this script refreshes whenever the
# token is inside GARDEN_MINION_MCP_REFRESH_MARGIN seconds of expiry. A flock
# serializes refreshes so N concurrent workers cause one token request, not N.
#
# Overrides (tests and operators): GARDEN_MINION_MCP_CRED_CMD (a command printing
# the credential JSON {client_id, client_secret, scopes?, token_endpoint?}),
# GARDEN_MINION_MCP_SECRET_ID, GARDEN_MINION_MCP_AWS_REGION,
# GARDEN_MINION_MCP_TOKEN_URL, GARDEN_MINION_MCP_SCOPE, GARDEN_MINION_MCP_DIR.

set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=common.sh
source "$HERE/common.sh"
export GARDEN_TAG="${GARDEN_TAG:-minion-mcp-token}"

: "${GARDEN_MINION_MCP_DIR:=$GARDEN_STATE/minion-mcp}"
: "${GARDEN_MINION_MCP_SECRET_ID:=minion/test-cc-client}"
: "${GARDEN_MINION_MCP_AWS_REGION:=us-west-1}"
: "${GARDEN_MINION_MCP_TOKEN_URL:=}"
: "${GARDEN_MINION_MCP_SCOPE:=}"
: "${GARDEN_MINION_MCP_REFRESH_MARGIN:=600}"
: "${GARDEN_MINION_MCP_HTTP_TIMEOUT:=20}"
: "${GARDEN_MINION_MCP_CRED_CMD:=}"
DEFAULT_TOKEN_URL="https://minion-town.auth.us-west-1.amazoncognito.com/oauth2/token"
DEFAULT_SCOPE="mcp/tools mcp/guest"
CACHE="$GARDEN_MINION_MCP_DIR/token.json"
LOCK="$GARDEN_MINION_MCP_DIR/token.lock"

ensure_dir() {
  umask 077
  mkdir -p "$GARDEN_MINION_MCP_DIR"
  chmod 700 "$GARDEN_MINION_MCP_DIR" 2>/dev/null || true
  [ ! -e "$CACHE" ] || chmod 600 "$CACHE" 2>/dev/null || true
}

# cache_remaining — seconds until the cached token expires (negative/absent → 0).
cache_remaining() {
  local exp
  exp="$(jq -r '.expires_at // 0' "$CACHE" 2>/dev/null || echo 0)"
  case "$exp" in ''|*[!0-9]*) exp=0 ;; esac
  echo $(( exp - $(date +%s) ))
}

cache_valid() {
  [ -s "$CACHE" ] && jq -e '.access_token | type == "string" and length > 0' "$CACHE" >/dev/null 2>&1 \
    && [ "$(cache_remaining)" -gt "$GARDEN_MINION_MCP_REFRESH_MARGIN" ]
}

read_credential() {
  if [ -n "$GARDEN_MINION_MCP_CRED_CMD" ]; then
    bash -c "$GARDEN_MINION_MCP_CRED_CMD"
  else
    timeout "$GARDEN_MINION_MCP_HTTP_TIMEOUT" aws secretsmanager get-secret-value \
      --region "$GARDEN_MINION_MCP_AWS_REGION" --secret-id "$GARDEN_MINION_MCP_SECRET_ID" \
      --query SecretString --output text
  fi
}

refresh() {
  local cred cid secret scope url resp tmp now expires_in
  cred="$(read_credential 2>/dev/null)" || { echo "credential read failed (secret $GARDEN_MINION_MCP_SECRET_ID in $GARDEN_MINION_MCP_AWS_REGION; are this host's AWS credentials able to read it?)" >&2; return 1; }
  cid="$(jq -r '.client_id // empty' <<<"$cred" 2>/dev/null)"
  secret="$(jq -r '.client_secret // empty' <<<"$cred" 2>/dev/null)"
  [ -n "$cid" ] && [ -n "$secret" ] || { echo "credential is missing client_id/client_secret" >&2; return 1; }
  scope="${GARDEN_MINION_MCP_SCOPE:-$(jq -r '.scopes // empty' <<<"$cred")}"; scope="${scope:-$DEFAULT_SCOPE}"
  url="${GARDEN_MINION_MCP_TOKEN_URL:-$(jq -r '.token_endpoint // empty' <<<"$cred")}"; url="${url:-$DEFAULT_TOKEN_URL}"
  # The secret goes to curl through a stdin config, never argv (visible in ps).
  resp="$(printf 'user = "%s:%s"\n' "$cid" "$secret" \
    | curl -sS --fail-with-body --max-time "$GARDEN_MINION_MCP_HTTP_TIMEOUT" -K - \
        --data-urlencode grant_type=client_credentials --data-urlencode "scope=$scope" "$url" 2>&1)" \
    || { echo "token request failed: $(jq -r '.error // empty' <<<"$resp" 2>/dev/null || true)$(printf '%s' "$resp" | head -c 200 | tr -d '\n' | sed 's/eyJ[A-Za-z0-9._-]*/<redacted>/g')" >&2; return 1; }
  expires_in="$(jq -r '.expires_in // 3600' <<<"$resp" 2>/dev/null || echo 3600)"
  case "$expires_in" in ''|*[!0-9]*) expires_in=3600 ;; esac
  now="$(date +%s)"
  tmp="$(mktemp "$GARDEN_MINION_MCP_DIR/.token.XXXXXX")"
  jq -e --argjson exp "$(( now + expires_in ))" --arg cid "$cid" --arg scope "$scope" \
     '{access_token, expires_at:$exp, client_id:$cid, scope:(.scope // $scope)} | select(.access_token | type == "string" and length > 0)' \
     <<<"$resp" > "$tmp" 2>/dev/null || { rm -f "$tmp"; echo "token response carried no access_token" >&2; return 1; }
  chmod 600 "$tmp"; mv -f "$tmp" "$CACHE"
}

get_token() {
  local force="${1:-}"
  ensure_dir
  if [ -z "$force" ] && cache_valid; then jq -r .access_token "$CACHE"; return 0; fi
  exec 9>"$LOCK"
  flock -w 60 9 || { echo "timed out waiting for the token refresh lock" >&2; return 1; }
  # Re-check under the lock: a peer may have refreshed while we waited.
  if [ -n "$force" ]; then rm -f "$CACHE"; elif cache_valid; then jq -r .access_token "$CACHE"; return 0; fi
  refresh || return 1
  jq -r .access_token "$CACHE"
}

cmd="${1:-token}"; shift || true
case "$cmd" in
  token)
    force=""; [ "${1:-}" = --force ] && force=1
    get_token "$force" ;;
  headers)
    t="$(get_token)"; jq -cn --arg t "$t" '{Authorization:("Bearer " + $t)}' ;;
  invalidate)
    ensure_dir; rm -f "$CACHE" ;;
  status)
    ensure_dir
    if [ -s "$CACHE" ]; then
      jq -c --argjson rem "$(cache_remaining)" '{cached:true, client_id, scope, expires_in:$rem}' "$CACHE"
    else
      jq -cn '{cached:false}'
    fi ;;
  *) die "usage: minion-mcp-token.sh token [--force] | headers | invalidate | status" ;;
esac
