#!/bin/bash
# Hermetic checks for OpenRouter status classification and Codex provider isolation.
# Mirror of fireworker-harness-test.sh: OpenRouter rides the SAME custom
# OpenAI-compatible Codex path, so this asserts the shared preflight/adapter behave
# for the openrouter provider, that every request body is forced through the fleet
# privacy policy, and that the reviewed ZDR-capable NAMED-free selector reaches the
# wire unchanged while cloaked/unreviewed ids fail closed.
set -euo pipefail
# Explicit positive test-context sentinel: protects this standalone suite even when
# invoked outside the test-tree entrypoint heuristic.
export GARDEN_TEST=1
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
JOBS="$(cd "$HERE/.." && pwd)"
ROOT="$(cd "$JOBS/../.." && pwd)"
# Route assertions exercise this checkout's reviewed seed, not a potentially stale
# per-instance journal override on the host running the test.
export GARDEN_MODEL_ROUTING_FILE="$JOBS/model-routing-defaults.tsv"
export GARDEN_MODEL_TIER_INVENTORY_FILE="$JOBS/model-tier-inventory.tsv"
PASS=0; FAIL=0
ok() { echo "  PASS: $*"; PASS=$((PASS + 1)); }
bad() { echo "  FAIL: $*"; FAIL=$((FAIL + 1)); }
mkdir -p "$ROOT/scratch"
TR="$(mktemp -d "$ROOT/scratch/garden-openrouter.XXXXXX")"
UPSTREAM_PID=""
cleanup() {
  declare -F openrouter_privacy_proxy_stop >/dev/null && openrouter_privacy_proxy_stop
  [ -z "$UPSTREAM_PID" ] || { kill "$UPSTREAM_PID" 2>/dev/null || true; wait "$UPSTREAM_PID" 2>/dev/null || true; }
  rm -rf "$TR"
}
trap cleanup EXIT
BIN="$TR/bin"; mkdir -p "$BIN"

cat > "$BIN/codex" <<'EOF'
#!/bin/bash
exit 0
EOF
cat > "$BIN/curl" <<'EOF'
#!/bin/bash
set -euo pipefail
: "${FAKE_CURL_RECORD:?}"
printf '%s\n' called > "$FAKE_CURL_RECORD"
printf '%s' "${FAKE_OPENROUTER_STATUS:-200}"
EOF
chmod +x "$BIN/codex" "$BIN/curl"

probe() { # <HTTP status>; output and rc become PROBE_OUT/PROBE_RC
  set +e
  PROBE_OUT="$(env GARDEN_TEST_BIN="$BIN" GARDEN_STATE="$TR/state" OPENROUTER_API_KEY='offline-fixture-not-a-credential' \
    GARDEN_OPENROUTER_BASE_URL=https://example.invalid/v1 FAKE_CURL_RECORD="$TR/curl" FAKE_OPENROUTER_STATUS="$1" \
    bash -c 'source "$1"; PATH="$GARDEN_TEST_BIN:$PATH"; hash -r; source "$2"; openrouter_provider_preflight openrouter canary' _ "$JOBS/common.sh" "$JOBS/handlers/codex-provider-common.sh" 2>&1)"
  PROBE_RC=$?
  set -e
}

echo 'PREFLIGHT — status-only and secret-safe'
probe 200
[ "$PROBE_RC" -eq 0 ] && ok "2xx allows worker" || bad "2xx rejected"
[ -f "$TR/curl" ] && ok "models probe invoked" || bad "models probe skipped"
[[ "$PROBE_OUT" != *offline-fixture-not-a-credential* ]] && ok "credential not printed" || bad "credential leaked"
probe 429
[ "$PROBE_RC" -ne 0 ] && [[ "$PROBE_OUT" == *'adaptive capacity/quota'* ]] && ok "429 is capacity/quota" || bad "429 classification"
probe 503
[ "$PROBE_RC" -ne 0 ] && [[ "$PROBE_OUT" == *'load shed'* ]] && ok "503 is load shedding" || bad "503 classification"
probe 401
[ "$PROBE_RC" -ne 0 ] && [[ "$PROBE_OUT" == *'authentication/authorization'* ]] && ok "401 is auth failure" || bad "401 classification"

set +e
missing="$(env -u OPENROUTER_API_KEY GARDEN_TEST_BIN="$BIN" GARDEN_STATE="$TR/state" bash -c 'source "$1"; PATH="$GARDEN_TEST_BIN:$PATH"; hash -r; source "$2"; openrouter_provider_preflight openrouter canary' _ "$JOBS/common.sh" "$JOBS/handlers/codex-provider-common.sh" 2>&1)"
missing_rc=$?
set -e
[ "$missing_rc" -ne 0 ] && [[ "$missing" == *'OPENROUTER_API_KEY: absent'* ]] && ok "missing key is presence-only" || bad "missing key handling"

echo 'ADAPTER — configured endpoint and retry classes'
adapter="$(env GARDEN_OPENROUTER_BASE_URL=https://example.invalid/v1 OPENROUTER_API_KEY='offline-fixture-not-a-credential' bash -c 'source "$1"; codex_provider_extra_args openrouter; printf "%s\n" "${CODEX_PROVIDER_EXTRA_ARGS[@]}"' _ "$JOBS/handlers/codex-provider-common.sh")"
[[ "$adapter" == *'model_provider=openrouter'* && "$adapter" == *'env_key="OPENROUTER_API_KEY"'* ]] && ok "custom provider uses key name" || bad "adapter missing provider settings"
[[ "$adapter" != *offline-fixture-not-a-credential* ]] && ok "adapter does not embed key value" || bad "adapter leaked key"
# The promo lane reuses the SAME OpenRouter endpoint, key, and Codex provider block —
# it inherits the ZDR/deny-collection privacy proxy unconditionally; it must NOT grow
# a divergent wire config.
promo_adapter="$(env GARDEN_OPENROUTER_BASE_URL=https://example.invalid/v1 OPENROUTER_API_KEY='offline-fixture-not-a-credential' bash -c 'source "$1"; codex_provider_extra_args openrouter-promo; printf "%s\n" "${CODEX_PROVIDER_EXTRA_ARGS[@]}"' _ "$JOBS/handlers/codex-provider-common.sh")"
[ "$promo_adapter" = "$adapter" ] && ok "openrouter-promo shares the stable lane's Codex provider block (same endpoint/key)" || bad "openrouter-promo adapter diverged from openrouter"
promo_probe="$(env GARDEN_TEST_BIN="$BIN" GARDEN_STATE="$TR/state" OPENROUTER_API_KEY='offline-fixture-not-a-credential' GARDEN_OPENROUTER_BASE_URL=https://example.invalid/v1 FAKE_CURL_RECORD="$TR/curl-promo" FAKE_OPENROUTER_STATUS=200 bash -c 'source "$1"; PATH="$GARDEN_TEST_BIN:$PATH"; hash -r; source "$2"; openrouter_provider_preflight openrouter-promo canary' _ "$JOBS/common.sh" "$JOBS/handlers/codex-provider-common.sh" 2>&1)"; promo_probe_rc=$?
{ [ "$promo_probe_rc" -eq 0 ] && [[ "$promo_probe" != *offline-fixture-not-a-credential* ]]; } && ok "openrouter-promo preflight probes OpenRouter and never prints the key" || bad "openrouter-promo preflight"
printf 'HTTP 429 rate limit\n' > "$TR/429"; printf 'HTTP 503 service unavailable\n' > "$TR/503"; printf 'HTTP 400 invalid request\n' > "$TR/400"
source "$JOBS/handlers/codex-provider-common.sh"
openai_compat_retryable_failure "$TR/429" && ok "429 diagnostic retries" || bad "429 retry classifier"
openai_compat_retryable_failure "$TR/503" && ok "503 diagnostic retries" || bad "503 retry classifier"
openai_compat_retryable_failure "$TR/400" && bad "400 diagnostic retried" || ok "400 diagnostic not retried"

echo 'PRIVACY — loopback adapter overwrites both controls on every JSON request'
cat > "$TR/upstream.mjs" <<'EOF'
import fs from 'node:fs';
import http from 'node:http';
const [ready, record] = process.argv.slice(2);
const server = http.createServer((request, response) => {
  const chunks = [];
  request.on('data', chunk => chunks.push(chunk));
  request.on('end', () => {
    const body = Buffer.concat(chunks).toString('utf8');
    fs.writeFileSync(record, JSON.stringify({ method: request.method, url: request.url, body: JSON.parse(body) }));
    response.writeHead(200, { 'content-type': 'application/json' });
    response.end('{"ok":true}');
  });
});
server.listen(0, '127.0.0.1', () => {
  const address = server.address();
  fs.writeFileSync(ready, `http://127.0.0.1:${address.port}/api/v1\n`);
});
EOF
node "$TR/upstream.mjs" "$TR/upstream-ready" "$TR/upstream-record" >/dev/null 2>&1 &
UPSTREAM_PID=$!
for _ in $(seq 1 50); do [ -s "$TR/upstream-ready" ] && break; sleep 0.1; done
UPSTREAM_BASE="$(head -n 1 "$TR/upstream-ready" 2>/dev/null || true)"
[ -n "$UPSTREAM_BASE" ] || bad "fixture upstream did not start"
export GARDEN_TEST=1
openrouter_privacy_proxy_start "$UPSTREAM_BASE" && ok "privacy proxy starts on loopback" || bad "privacy proxy failed to start"
unset GARDEN_TEST
curl -fsS "$OPENROUTER_PRIVACY_PROXY_BASE_URL/responses" \
  -H 'Content-Type: application/json' \
  -d '{"model":"z-ai/glm-5.2:free","provider":{"order":["decart"],"data_collection":"allow","zdr":false}}' >/dev/null
jq -e '.method == "POST" and .url == "/api/v1/responses" and
  .body.provider.order == ["decart"] and
  .body.provider.data_collection == "deny" and .body.provider.zdr == true' \
  "$TR/upstream-record" >/dev/null \
  && ok "request preserves routing preferences but forces data_collection=deny and zdr=true" \
  || bad "request privacy fields were not forced"
GARDEN_OPENROUTER_BASE_URL="$OPENROUTER_PRIVACY_PROXY_BASE_URL"
codex_provider_extra_args openrouter
[[ "${CODEX_PROVIDER_EXTRA_ARGS[*]}" == *"base_url=\"$OPENROUTER_PRIVACY_PROXY_BASE_URL\""* ]] \
  && ok "Codex adapter targets only the enforcing loopback endpoint" \
  || bad "Codex adapter bypasses privacy proxy"
openrouter_privacy_proxy_stop

echo 'ROUTES — reviewed ZDR-capable named-free selector reaches the wire; stealth fails closed'
# The handler strips the garden-only `openrouter/` namespace before sending the wire
# id (handlers/cleric-codex.sh, `model="${model#"$provider"/}"`). These assert the
# exact wire id each reviewed route sends and that a cloaked/unreviewed id produces
# no wire id (context/operations/openrouter.md § Registered routes).
source "$JOBS/common.sh"
wire_of() { local resolved; resolved="$(resolve_model_tier openrouter "$1")"; [ -n "$resolved" ] || return 1; printf '%s\n' "${resolved#openrouter/}"; }
[ "$(wire_of openrouter/z-ai/glm-5.2:free)" = "z-ai/glm-5.2:free" ] && ok "GLM-5.2-free wire id = z-ai/glm-5.2:free" || bad "GLM-5.2-free wire id"
wire_of openrouter/stealth/ox-alpha:free >/dev/null 2>&1 && bad "a cloaked/stealth selector produced a wire id" || ok "cloaked/stealth selector fails closed (no wire id)"
wire_of openrouter/z-ai/glm-5.2 >/dev/null 2>&1 && bad "an unreviewed non-free id produced a wire id" || ok "unreviewed non-:free id fails closed (no wire id)"

echo 'PROMO ROUTES — a freshly-attested cloaked id reaches the wire; stale/absent fails closed'
# The promo lane admits a cloaked id ONLY while its journal-ledger attestation is fresh.
PROMO_LEDGER="$TR/promos"
{
  printf 'openrouter/horizon-beta\tminion\t%s\ttester\n' "$(date -u +%FT%TZ)"
  printf 'openrouter/old-ghost\tminion\t%s\ttester\n' "$(date -u -d '3 days ago' +%FT%TZ)"
} > "$PROMO_LEDGER"
export GARDEN_OPENROUTER_PROMOS_FILE="$PROMO_LEDGER"
promo_wire_of() { local r; r="$(resolve_model_tier openrouter-promo "$1")"; [ -n "$r" ] || return 1; printf '%s\n' "${r#openrouter-promo/}"; }
[ "$(promo_wire_of openrouter-promo/openrouter/horizon-beta)" = "openrouter/horizon-beta" ] && ok "fresh cloaked id wire = openrouter/horizon-beta (namespace stripped)" || bad "fresh cloaked wire id"
promo_wire_of openrouter-promo/openrouter/old-ghost >/dev/null 2>&1 && bad "a STALE cloaked id produced a wire id" || ok "stale cloaked id fails closed (cadence auto-disable)"
promo_wire_of openrouter-promo/openrouter/never >/dev/null 2>&1 && bad "an un-attested cloaked id produced a wire id" || ok "un-attested cloaked id fails closed"
# The two OpenRouter lanes never cross-bind, so a cloaked arm never pools with the named one.
resolve_model_tier openrouter openrouter-promo/openrouter/horizon-beta | grep -q . && bad "stable lane bound a promo selector" || ok "stable openrouter lane cannot bind a promo selector"
resolve_model_tier openrouter-promo openrouter/z-ai/glm-5.2:free | grep -q . && bad "promo lane bound a stable selector" || ok "promo lane cannot bind a stable selector"
unset GARDEN_OPENROUTER_PROMOS_FILE

echo "openrouter-harness-test: $PASS passed, $FAIL failed"
[ "$FAIL" -eq 0 ]
