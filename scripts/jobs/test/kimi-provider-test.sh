#!/bin/bash
# kimi-provider-test.sh — offline checks for the hosted Moonshot Kimi path.
# No network call or credential is used. The Docker stub records only env names,
# never values, so this test also guards the launcher's no-disclosure contract.
set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
JOBS="$(cd "$HERE/.." && pwd)"
ROOT="$(cd "$JOBS/../.." && pwd)"
PASS=0; FAIL=0
ok() { echo "  PASS: $*"; PASS=$((PASS + 1)); }
bad() { echo "  FAIL: $*"; FAIL=$((FAIL + 1)); }
hr() { echo "----------------------------------------------------------------"; }
TR="$(mktemp -d "$ROOT/scratch/garden-kimi-provider.XXXXXX")"
trap 'rm -rf "$TR"' EXIT

hr; echo "PROVIDER CONFIG — Moonshot args are explicit and value-free"; hr
source "$JOBS/handlers/codex-provider-common.sh"
codex_provider_extra_args moonshot
args="${CODEX_PROVIDER_EXTRA_ARGS[*]}"
[[ "$args" == *'model_provider=moonshot'* ]] && ok "selects moonshot provider" || bad "provider selection missing"
[[ "$args" == *'https://api.moonshot.ai/v1'* ]] && ok "uses Moonshot /v1 endpoint" || bad "endpoint missing"
[[ "$args" == *'env_key="MOONSHOT_API_KEY"'* ]] && ok "uses MOONSHOT_API_KEY env key" || bad "env key missing"

hr; echo "MISSING KEY — fails before any Codex authentication or network"; hr
BIN="$TR/bin"; mkdir -p "$BIN"
cat > "$BIN/codex" <<'EOF'
#!/bin/bash
exit 0
EOF
chmod +x "$BIN/codex"
set +e
missing_out="$(env -u MOONSHOT_API_KEY PATH="$BIN:$PATH" GARDEN_STATE="$TR/state" bash -c '
  source "$1"; codex_provider_preflight moonshot kimi canary kimis
' _ "$JOBS/handlers/codex-provider-common.sh" 2>&1)"
missing_rc=$?
set -e
[ "$missing_rc" -ne 0 ] && ok "missing key rejects Kimi worker" || bad "missing key was accepted"
[[ "$missing_out" == *'MOONSHOT_API_KEY is not set'* ]] && ok "missing-key diagnostic identifies setup action" || bad "missing-key diagnostic absent"

hr; echo "LAUNCHER — forwards only env names into a newly created container"; hr
LAUNCH="$TR/garden"; cp "$ROOT/garden" "$LAUNCH"; chmod +x "$LAUNCH"
cat > "$BIN/docker" <<'EOF'
#!/bin/bash
set -euo pipefail
record="${DOCKER_STUB_RECORD:?}"
case "${1:-}" in
  image) exit 0 ;;
  container) exit 1 ;;
  run)
    shift
    while [ "$#" -gt 0 ]; do
      if [ "$1" = -e ]; then
        printf '%s\n' "${2%%=*}" >> "$record"
        shift 2
      else
        shift
      fi
    done
    exit 0 ;;
  *) exit 0 ;;
esac
EOF
chmod +x "$BIN/docker"
record="$TR/env-names"; : > "$record"
PATH="$BIN:$PATH" DOCKER_STUB_RECORD="$record" MOONSHOT_API_KEY='fixture-value-not-a-credential' \
  GARDEN_CONTAINER=kimi-test GARDEN_HOSTNAME=kimi-test bash "$LAUNCH" create >/dev/null
grep -qx 'MOONSHOT_API_KEY' "$record" && ok "launcher forwards Moonshot key name" || bad "launcher did not forward key name"
if grep -q 'fixture-value-not-a-credential' "$record"; then
  bad "launcher test recorded a key value"
else
  ok "launcher test records no key value"
fi

hr
echo "kimi-provider-test: $PASS passed, $FAIL failed"
[ "$FAIL" -eq 0 ]
