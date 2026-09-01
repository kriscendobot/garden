#!/bin/bash
# api-key-handoff-test.sh -- regression coverage for the tmpfs API-key bridge.

set -euo pipefail
# Explicit positive test-context sentinel: protects this standalone suite even when
# invoked outside the test-tree entrypoint heuristic.
export GARDEN_TEST=1
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT="$(cd "$HERE/../../.." && pwd)"
SEED="$ROOT/scripts/systemd/seed-api-key-handoff.sh"
TR="$(mktemp -d /tmp/garden-api-key-handoff.XXXXXX)"
PASS=0
FAIL=0
ok() { printf '  PASS: %s\n' "$*"; PASS=$((PASS + 1)); }
bad() { printf '  FAIL: %s\n' "$*"; FAIL=$((FAIL + 1)); }
cleanup() { rm -rf "$TR"; }
trap cleanup EXIT

run_seed() {
    env -u ANTHROPIC_API_KEY -u MOONSHOT_API_KEY -u FIREWORKS_API_KEY -u OPENROUTER_API_KEY -u OLLAMA_CLOUD_API_KEY \
        GARDEN_TEST=1 GARDEN_API_KEY_HANDOFF_DIR="$TR/run/environment.d" \
        GARDEN_USER="$(id -un)" "$@" "$SEED"
}

bash -n "$ROOT/entrypoint.sh" "$SEED" "$ROOT/garden" \
    && ok "entrypoint, handoff seeder, and launcher parse" \
    || bad "shell syntax failure"

run_seed env ANTHROPIC_API_KEY=synthetic-anthropic MOONSHOT_API_KEY=synthetic-moonshot FIREWORKS_API_KEY=synthetic-fireworks OPENROUTER_API_KEY=synthetic-openrouter OLLAMA_CLOUD_API_KEY=synthetic-ollama-cloud
handoff="$TR/run/environment.d/60-garden-api-keys.conf"
expected=$'ANTHROPIC_API_KEY=synthetic-anthropic\nMOONSHOT_API_KEY=synthetic-moonshot\nFIREWORKS_API_KEY=synthetic-fireworks\nOPENROUTER_API_KEY=synthetic-openrouter\nOLLAMA_CLOUD_API_KEY=synthetic-ollama-cloud'
actual="$(cat "$handoff")"
[[ "$actual" = "$expected" ]] \
    && ok "all allowlisted keys reach the environment.d generator input" \
    || bad "allowlist handoff differs"
[[ "$(stat -c '%a' "$handoff")" = 640 ]] \
    && ok "handoff file is group-readable only by the user manager" \
    || bad "handoff file permissions are not 0640"
[[ ! -e "$ROOT/.config/environment.d/60-garden-api-keys.conf" ]] \
    && ok "no handoff file is written into the bind-mounted home" \
    || bad "handoff file escaped into the bind-mounted home"

run_seed env ANTHROPIC_API_KEY=synthetic-anthropic
actual="$(cat "$handoff")"
[[ "$actual" = 'ANTHROPIC_API_KEY=synthetic-anthropic' ]] \
    && ok "absent keys are omitted rather than synthesized" \
    || bad "absent key was retained or synthesized"

run_seed env ANTHROPIC_API_KEY=synthetic-anthropic UNRELATED_SECRET=synthetic-unrelated
if grep -q '^UNRELATED_SECRET=' "$handoff"; then
    bad "non-allowlisted environment value was copied"
else
    ok "non-allowlisted environment values are never copied"
fi

if run_seed env ANTHROPIC_API_KEY='synthetic.invalid' >/dev/null 2>&1; then
    bad "syntax-bearing key was accepted"
else
    ok "syntax-bearing key is rejected without output"
fi

printf 'api-key-handoff: %d passed, %d failed\n' "$PASS" "$FAIL"
[[ "$FAIL" -eq 0 ]]
