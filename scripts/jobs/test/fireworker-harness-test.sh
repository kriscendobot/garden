#!/bin/bash
# Hermetic checks for Fireworks status classification and Codex provider isolation.
set -euo pipefail
# Explicit positive test-context sentinel: protects this standalone suite even when
# invoked outside the test-tree entrypoint heuristic.
export GARDEN_TEST=1
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
JOBS="$(cd "$HERE/.." && pwd)"
ROOT="$(cd "$JOBS/../.." && pwd)"
PASS=0; FAIL=0
ok() { echo "  PASS: $*"; PASS=$((PASS + 1)); }
bad() { echo "  FAIL: $*"; FAIL=$((FAIL + 1)); }
mkdir -p "$ROOT/scratch"
TR="$(mktemp -d "$ROOT/scratch/garden-fireworker.XXXXXX")"
trap 'rm -rf "$TR"' EXIT
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
printf '%s' "${FAKE_FIREWORKS_STATUS:-200}"
EOF
chmod +x "$BIN/codex" "$BIN/curl"

probe() { # <HTTP status>; output and rc become PROBE_OUT/PROBE_RC
  set +e
  PROBE_OUT="$(env GARDEN_TEST_BIN="$BIN" GARDEN_STATE="$TR/state" FIREWORKS_API_KEY='offline-fixture-not-a-credential' \
    GARDEN_FIREWORKS_BASE_URL=https://example.invalid/v1 FAKE_CURL_RECORD="$TR/curl" FAKE_FIREWORKS_STATUS="$1" \
    bash -c 'source "$1"; PATH="$GARDEN_TEST_BIN:$PATH"; hash -r; source "$2"; fireworks_provider_preflight fireworker canary' _ "$JOBS/common.sh" "$JOBS/handlers/codex-provider-common.sh" 2>&1)"
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
missing="$(env -u FIREWORKS_API_KEY GARDEN_TEST_BIN="$BIN" GARDEN_STATE="$TR/state" bash -c 'source "$1"; PATH="$GARDEN_TEST_BIN:$PATH"; hash -r; source "$2"; fireworks_provider_preflight fireworker canary' _ "$JOBS/common.sh" "$JOBS/handlers/codex-provider-common.sh" 2>&1)"
missing_rc=$?
set -e
[ "$missing_rc" -ne 0 ] && [[ "$missing" == *'FIREWORKS_API_KEY: absent'* ]] && ok "missing key is presence-only" || bad "missing key handling"

echo 'ADAPTER — configured endpoint and retry classes'
adapter="$(env GARDEN_FIREWORKS_BASE_URL=https://example.invalid/v1 FIREWORKS_API_KEY='offline-fixture-not-a-credential' bash -c 'source "$1"; codex_provider_extra_args fireworks; printf "%s\n" "${CODEX_PROVIDER_EXTRA_ARGS[@]}"' _ "$JOBS/handlers/codex-provider-common.sh")"
[[ "$adapter" == *'model_provider=fireworks'* && "$adapter" == *'env_key="FIREWORKS_API_KEY"'* ]] && ok "custom provider uses key name" || bad "adapter missing provider settings"
[[ "$adapter" != *offline-fixture-not-a-credential* ]] && ok "adapter does not embed key value" || bad "adapter leaked key"
printf 'HTTP 429 rate limit\n' > "$TR/429"; printf 'HTTP 503 service unavailable\n' > "$TR/503"; printf 'HTTP 400 invalid request\n' > "$TR/400"
source "$JOBS/handlers/codex-provider-common.sh"
fireworks_retryable_failure "$TR/429" && ok "429 diagnostic retries" || bad "429 retry classifier"
fireworks_retryable_failure "$TR/503" && ok "503 diagnostic retries" || bad "503 retry classifier"
fireworks_retryable_failure "$TR/400" && bad "400 diagnostic retried" || ok "400 diagnostic not retried"

echo 'ROUTES — the reviewed GLM 5.2 and K3 selectors reach the wire unchanged'
# The handler strips the garden-only `fireworks/` namespace before sending the wire
# id (handlers/cleric-codex.sh, `model="${model#fireworks/}"`). These assert the
# exact wire id each reviewed route sends, verified against the Fireworks model
# pages (context/operations/fireworks.md § Registered routes). A change to either
# resolved id — or to the strip contract — fails here rather than silently sending
# a bogus model name that would 400 at the provider.
source "$JOBS/common.sh"
wire_of() { local resolved; resolved="$(resolve_model_tier fireworks "$1")"; [ -n "$resolved" ] || return 1; printf '%s\n' "${resolved#fireworks/}"; }
[ "$(wire_of fireworks/accounts/fireworks/models/glm-5p2)" = "accounts/fireworks/models/glm-5p2" ] && ok "GLM 5.2 wire id = accounts/fireworks/models/glm-5p2" || bad "GLM 5.2 wire id"
[ "$(wire_of fireworks/accounts/fireworks/models/kimi-k3)" = "accounts/fireworks/models/kimi-k3" ] && ok "K3 wire id = accounts/fireworks/models/kimi-k3" || bad "K3 wire id"
wire_of fireworks/accounts/fireworks/models/example >/dev/null 2>&1 && bad "an unreviewed selector produced a wire id" || ok "unreviewed selector fails closed (no wire id)"

echo "fireworker-harness-test: $PASS passed, $FAIL failed"
[ "$FAIL" -eq 0 ]
