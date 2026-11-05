#!/bin/bash
set -euo pipefail
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../../.." && pwd)"
TR="$(mktemp -d "${TMPDIR:-/tmp}/garden-broker-test.XXXXXX")"
broker_pid=""
cleanup() { [ -z "$broker_pid" ] || kill "$broker_pid" 2>/dev/null || true; [ -z "$broker_pid" ] || wait "$broker_pid" 2>/dev/null || true; rm -rf "$TR"; }
trap cleanup EXIT
PASS=0; FAIL=0
ok() { echo "  PASS: $*"; PASS=$((PASS+1)); }
bad() { echo "  FAIL: $*"; FAIL=$((FAIL+1)); }
mkdir -p "$TR/secrets" "$TR/state"; chmod 0700 "$TR/secrets"
fake='typesafe-offline-fixture-0000000000'
printf '%s' "$fake" > "$TR/secrets/typesafe.key"; chmod 0600 "$TR/secrets/typesafe.key"
marker="$TR/ledger-before-send"
ledger="$TR/ledger.sh"
cat > "$ledger" <<'EOF'
#!/bin/bash
for name in ANTHROPIC_API_KEY MOONSHOT_API_KEY FIREWORKS_API_KEY OPENROUTER_API_KEY OLLAMA_CLOUD_API_KEY TYPESAFE_API_KEY; do
  [ -z "${!name:-}" ] || exit 99
done
cat > "$LEDGER_BODY"
touch "$LEDGER_MARKER"
EOF
chmod +x "$ledger"
curl="$TR/curl.sh"
cat > "$curl" <<'EOF'
#!/bin/bash
config="$(cat)"
[ -e "$LEDGER_MARKER" ] || exit 77
for name in ANTHROPIC_API_KEY MOONSHOT_API_KEY FIREWORKS_API_KEY OPENROUTER_API_KEY OLLAMA_CLOUD_API_KEY TYPESAFE_API_KEY; do
  [ -z "${!name:-}" ] || exit 99
done
printf '%s\n--request--\n' "$config" >> "$CURL_CONFIG"
out=""; while [ "$#" -gt 0 ]; do case "$1" in --output) out="$2"; shift 2;; *) shift;; esac; done
printf '{"answers":{}}' > "$out"
printf '200'
EOF
chmod +x "$curl"
export GARDEN_ROOT="$ROOT" GARDEN_STATE="$TR/state" GARDEN_SECRETS_DIR="$TR/secrets"
export GARDEN_SECRET_BROKER_SOCKET="$TR/state/broker.sock" GARDEN_OUTBOUND_LEDGER_CMD="$ledger"
export GARDEN_OUTBOUND_CURL="$curl" LEDGER_MARKER="$marker" LEDGER_BODY="$TR/ledger.json" CURL_CONFIG="$TR/curl.config"
export ANTHROPIC_API_KEY='sk-ant-unrelated-fixture-00000000' MOONSHOT_API_KEY='sk-unrelated-fixture-000000000'
python3 "$ROOT/scripts/outbound/broker.py" & broker_pid=$!
for _ in $(seq 1 50); do [ -S "$GARDEN_SECRET_BROKER_SOCKET" ] && break; sleep 0.05; done
printf '{"state":{"classified":"fixture text"},"questions":{"injection":{}}}' > "$TR/request.json"
status="$TR/status"
"$ROOT/scripts/outbound/typesafe.sh" --authorized-by test-job --operation classify \
  --body-file "$TR/request.json" --status-file "$status" > "$TR/response.json"
[ "$(cat "$status")" = 200 ] && [ -e "$marker" ] && ok "accepted ledger lands before broker egress" || bad "ledger ordering"
grep -q 'Authorization: Bearer' "$TR/curl.config" && ok "broker gives authentication to curl on config stdin" || bad "curl config auth"
! grep -q 'offline-fixture' "$TR/ledger.json" && ok "ledger projection omits key and classified source" || bad "ledger leaked sensitive content"

replacement='typesafe-offline-replacement-1111111'
printf '%s' "$replacement" > "$TR/secrets/.replacement"; chmod 0600 "$TR/secrets/.replacement"
mv "$TR/secrets/.replacement" "$TR/secrets/typesafe.key"
"$ROOT/scripts/outbound/typesafe.sh" --authorized-by test-job --operation classify \
  --body-file "$TR/request.json" --status-file "$status" > "$TR/response.json"
if kill -0 "$broker_pid" 2>/dev/null && grep -q "$fake" "$TR/curl.config" && grep -q "$replacement" "$TR/curl.config"; then
  ok "running broker uses an atomically replaced key without restart"
else
  bad "live broker key rotation"
fi

if "$ROOT/scripts/outbound/typesafe.sh" --authorized-by test-job --operation arbitrary --body-file "$TR/request.json" >/dev/null 2>&1; then
  bad "wrapper accepted arbitrary operation"
else
  ok "wrapper rejects arbitrary operation before egress"
fi
if "$ROOT/scripts/outbound/typesafe.sh" --authorized-by 'bad label' --operation classify --body-file "$TR/request.json" >/dev/null 2>&1; then
  bad "wrapper accepted invalid authorization"
else
  ok "broker rejects invalid authorization"
fi
if "$ROOT/scripts/outbound/typesafe.sh" --authorized-by test-job --operation classify --body-file "$TR/request.json" --header 'Authorization: bad' >/dev/null 2>&1; then
  bad "wrapper accepted a caller authentication header"
else
  ok "wrapper rejects caller authentication headers"
fi
[[ "$(tr '\n' ' ' < "$TR/ledger.json")" != *"fixture text"* ]] && ok "TypeSafe record carries question names and input hash only" || bad "source projection"

printf 'secret-broker-test: %d passed, %d failed\n' "$PASS" "$FAIL"
[ "$FAIL" -eq 0 ]
