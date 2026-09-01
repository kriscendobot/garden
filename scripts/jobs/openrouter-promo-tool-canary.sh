#!/bin/bash
# openrouter-promo-tool-canary.sh -- exercise one cloaked id through a complete
# client-side tool-call round trip without exposing response content.
#
# Usage: openrouter-promo-tool-canary.sh <wire-id>
# Exit 0 means the model requested the forced canary tool and accepted its result.
# Exit 2 means the probe could not run because the key or a local dependency is
# absent. Exit 44 is a definitive model 404. Other failures are non-definitive.
set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=common.sh
source "$HERE/common.sh"
export GARDEN_TAG="openrouter-promo-tool-canary"

wire="${1:?usage: openrouter-promo-tool-canary.sh <wire-id>}"
key="${OPENROUTER_API_KEY:-}"
[ -n "$key" ] || { log "OPENROUTER_API_KEY absent; tool canary skipped"; exit 2; }
command -v curl >/dev/null 2>&1 || { log "curl absent; tool canary skipped"; exit 2; }
command -v jq >/dev/null 2>&1 || { log "jq absent; tool canary skipped"; exit 2; }

base="${GARDEN_OPENROUTER_BASE_URL:-https://openrouter.ai/api/v1}"
base="${base%/}"
case "$base" in
  https://*) ;;
  http://127.0.0.1:*|http://localhost:*|http://\[::1\]:*)
    [ "${GARDEN_TEST:-}" = 1 ] || die "OpenRouter tool canary requires HTTPS"
    ;;
  *) die "OpenRouter tool canary requires HTTPS" ;;
esac

tmp_root="${GARDEN_STATE:-$GARDEN_ROOT/scratch}/openrouter-promo-canary"
mkdir -p "$tmp_root"
work="$(mktemp -d "$tmp_root/run.XXXXXX")"
cleanup() { rm -rf "$work"; }
trap cleanup EXIT

# Stable per-id nonce: this is a capability canary, not an authentication token.
# Keeping it deterministic makes the HTTP transcript hermetically testable.
nonce="$(printf '%s' "$wire" | (sha256sum 2>/dev/null || shasum -a 256) | cut -c1-16)"
request1="$work/request-1.json"; response1="$work/response-1.json"
request2="$work/request-2.json"; response2="$work/response-2.json"

jq -n --arg model "$wire" --arg nonce "$nonce" '{
  model: $model,
  messages: [{role:"user", content:("Call garden_canary_nonce with nonce " + $nonce + ". Do not answer in text before calling it.")}],
  tools: [{type:"function", function:{
    name:"garden_canary_nonce",
    description:"Return the exact nonce supplied by the user.",
    parameters:{type:"object", properties:{nonce:{type:"string"}}, required:["nonce"], additionalProperties:false}
  }}],
  tool_choice:{type:"function", function:{name:"garden_canary_nonce"}},
  provider:{data_collection:"deny", zdr:true},
  stream:false,
  max_tokens:64
}' > "$request1"

call_openrouter() { # <request-file> <response-file> -> prints status only
  curl -sS -o "$2" -w '%{http_code}' --connect-timeout 10 --max-time 60 \
    -H "Authorization: Bearer $key" -H 'Content-Type: application/json' \
    -X POST "$base/chat/completions" --data-binary "@$1" 2>/dev/null
}

status="$(call_openrouter "$request1" "$response1")" || { log "tool canary request failed for $wire"; exit 1; }
[ "$status" != 404 ] || { log "tool canary got 404 for $wire"; exit 44; }
case "$status" in 2*) ;; *) log "tool canary got HTTP $status for $wire"; exit 1;; esac

call_id="$(jq -er --arg nonce "$nonce" '
  [.choices[0].message.tool_calls[]?
    | select(.function.name == "garden_canary_nonce")
    | select((.function.arguments | if type == "string" then fromjson else . end).nonce == $nonce)
    | .id][0] // empty
' "$response1" 2>/dev/null)" || { log "model $wire did not issue the required tool call"; exit 1; }

jq -n --arg model "$wire" --arg nonce "$nonce" --arg call_id "$call_id" \
  --slurpfile first "$response1" '{
    model: $model,
    messages: [
      {role:"user", content:("Call garden_canary_nonce with nonce " + $nonce + ". Do not answer in text before calling it.")},
      $first[0].choices[0].message,
      {role:"tool", tool_call_id:$call_id, content:("nonce accepted: " + $nonce)}
    ],
    tools: [{type:"function", function:{
      name:"garden_canary_nonce",
      description:"Return the exact nonce supplied by the user.",
      parameters:{type:"object", properties:{nonce:{type:"string"}}, required:["nonce"], additionalProperties:false}
    }}],
    provider:{data_collection:"deny", zdr:true},
    stream:false,
    max_tokens:64
  }' > "$request2"

status="$(call_openrouter "$request2" "$response2")" || { log "tool-result continuation failed for $wire"; exit 1; }
[ "$status" != 404 ] || { log "tool-result continuation got 404 for $wire"; exit 44; }
case "$status" in 2*) ;; *) log "tool-result continuation got HTTP $status for $wire"; exit 1;; esac
jq -e '.choices[0].message | type == "object"' "$response2" >/dev/null 2>&1 \
  || { log "tool-result continuation for $wire was malformed"; exit 1; }

log "live tool canary passed for $wire (forced tool call plus result continuation)"
