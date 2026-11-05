#!/bin/bash
set -euo pipefail
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../../.." && pwd)"
SECRETS="$ROOT/scripts/secrets"
TR="$(mktemp -d "${TMPDIR:-/tmp}/garden-secret-test.XXXXXX")"
trap 'rm -rf "$TR"' EXIT
PASS=0; FAIL=0
ok() { echo "  PASS: $*"; PASS=$((PASS+1)); }
bad() { echo "  FAIL: $*"; FAIL=$((FAIL+1)); }

ledger="$TR/ledger.sh"
cat > "$ledger" <<'EOF'
#!/bin/bash
set -e
body="$(cat)"
[ "${LEDGER_FAIL:-0}" != 1 ] || exit 1
for name in ANTHROPIC_API_KEY MOONSHOT_API_KEY FIREWORKS_API_KEY OPENROUTER_API_KEY OLLAMA_CLOUD_API_KEY TYPESAFE_API_KEY; do
  [ -z "${!name:-}" ] || exit 99
done
printf '%s\n' "$body" >> "$LEDGER_CAPTURE"
EOF
chmod +x "$ledger"
export GARDEN_ROOT="$ROOT" GARDEN_STATE="$TR/state" GARDEN_SECRETS_DIR="$TR/secrets"
export GARDEN_OUTBOUND_LEDGER_CMD="$ledger" LEDGER_CAPTURE="$TR/ledger.jsonl"
fake1='sk-ant-offline-fixture-000000000000'
fake2='sk-ant-offline-fixture-111111111111'
terminal_fake='typesafe-terminal-fixture-00000000'

grep -q -- '-v "${SECRETS_DIR}:${SECRETS_DIR}:ro"' "$ROOT/garden" \
  && grep -q 'chmod 0700 "$SECRETS_DIR"' "$ROOT/garden" \
  && ok "launcher creates and overlays the host store read-only" || bad "launcher secret mount"
grep -q -- '--unshare-pid' "$SECRETS/run-sandboxed.sh" \
  && grep -q 'GARDEN_SECRETS_DIR' "$SECRETS/run-sandboxed.sh" \
  && grep -q -- '--tmpfs "$path"' "$SECRETS/run-sandboxed.sh" \
  && grep -q 'printf -v "$secret_environment"' "$SECRETS/run-sandboxed.sh" \
  && ok "harness sandbox hides the store and parent PID namespace" || bad "sandbox boundary"

terminal_out="$(TERMINAL_FAKE="$terminal_fake" python3 - "$SECRETS/set-key.sh" <<'PY'
import os, pty, select, sys, time
pid, fd = pty.fork()
if pid == 0:
    os.execv(sys.argv[1], [sys.argv[1], "typesafe", "--authorized-by", "maintainer:test"])
time.sleep(0.2)
os.write(fd, os.environ["TERMINAL_FAKE"].encode() + b"\n")
output = bytearray()
while True:
    ready, _, _ = select.select([fd], [], [], 2)
    if not ready:
        break
    try:
        chunk = os.read(fd, 4096)
    except OSError:
        break
    if not chunk:
        break
    output.extend(chunk)
_, status = os.waitpid(pid, 0)
sys.stdout.buffer.write(output)
raise SystemExit(os.waitstatus_to_exitcode(status))
PY
)"
[ "$(cat "$TR/secrets/typesafe.key")" = "$terminal_fake" ] && [[ "$terminal_out" != *"$terminal_fake"* ]] \
  && ok "terminal placement uses silent input" || bad "terminal placement"

printf '%s' "$fake1" | "$SECRETS/set-key.sh" anthropic --stdin --authorized-by maintainer:test >/dev/null
[ "$(stat -c %a "$TR/secrets")" = 700 ] && [ "$(stat -c %a "$TR/secrets/anthropic.key")" = 600 ] \
  && ok "stdin placement creates 0700 store and 0600 key" || bad "placement modes"
[ "$(cat "$TR/secrets/anthropic.key")" = "$fake1" ] && ok "stdin placement writes the complete value" || bad "stdin value"

out="$(printf 'bad!' | "$SECRETS/set-key.sh" anthropic --stdin 2>&1 || true)"
[[ "$out" != *bad!* && "$(cat "$TR/secrets/anthropic.key")" = "$fake1" ]] \
  && ok "validator rejects without echoing the fixture or changing prior state" || bad "validator secrecy/rollback"

chmod 0644 "$TR/secrets/anthropic.key"
status_output="$("$SECRETS/status.sh")"
grep -q $'anthropic\tpresent\tinvalid' <<<"$status_output" \
  && ok "status detects wrong mode without printing a value" || bad "wrong-mode status"
chmod 0600 "$TR/secrets/anthropic.key"

set +e
printf '%s' "$fake2" | LEDGER_FAIL=1 "$SECRETS/set-key.sh" anthropic --stdin --authorized-by maintainer:test >/dev/null 2>&1
rc=$?
set -e
[ "$rc" -ne 0 ] && [ "$(cat "$TR/secrets/anthropic.key")" = "$fake1" ] \
  && ok "failed ledger restores the old file before unlock" || bad "ledger rollback"

printf '%s' "$fake2" | "$SECRETS/set-key.sh" anthropic --stdin --authorized-by maintainer:test >/dev/null
[ "$(cat "$TR/secrets/anthropic.key")" = "$fake2" ] && ok "replacement atomically exposes the new whole value" || bad "replacement"

launch_argv="$(GARDEN_TEST=1 "$SECRETS/run-sandboxed.sh" --worktree "$TR" --allow-home codex \
  --secret anthropic ANTHROPIC_API_KEY -- bash -c \
  'printf %s "$ANTHROPIC_API_KEY" > "$1"; tr "\0" "\n" < /proc/$$/cmdline' _ "$TR/launch-value")"
if [ "$(cat "$TR/launch-value")" = "$fake2" ] && [[ "$launch_argv" != *"$fake2"* ]]; then
  ok "next harness launch reads the replacement without placing it in argv"
else
  bad "live harness key rotation or argv isolation"
fi

# Race shared reads against atomic replacements. Every observation must be one
# complete registered value, never a temp-file prefix or mixed write.
bad_reads="$TR/bad-reads"; : > "$bad_reads"
(
  for _ in $(seq 1 8); do
    printf '%s' "$fake1" | "$SECRETS/set-key.sh" anthropic --stdin --authorized-by maintainer:test >/dev/null
    printf '%s' "$fake2" | "$SECRETS/set-key.sh" anthropic --stdin --authorized-by maintainer:test >/dev/null
  done
) & writer_pid=$!
# shellcheck source=../../../secrets/lib.sh
source "$SECRETS/lib.sh"
for _ in $(seq 1 80); do
  observed="$(secret_value anthropic)" || { echo read-failed >> "$bad_reads"; continue; }
  case "$observed" in "$fake1"|"$fake2") ;; *) echo partial >> "$bad_reads";; esac
done
wait "$writer_pid"
[ ! -s "$bad_reads" ] && ok "concurrent reads see only whole old or new values" || bad "concurrent atomicity"
"$SECRETS/set-key.sh" anthropic --remove --authorized-by maintainer:test >/dev/null
[ ! -e "$TR/secrets/anthropic.key" ] && ok "removal lands then deletes rollback" || bad "removal"

export ANTHROPIC_API_KEY="$fake1"
"$SECRETS/import-environment.sh" >/dev/null
export ANTHROPIC_API_KEY="$fake2"
"$SECRETS/import-environment.sh" >/dev/null 2>&1
[ "$(cat "$TR/secrets/anthropic.key")" = "$fake1" ] && ok "import refuses an existing file by default" || bad "import refusal"
"$SECRETS/import-environment.sh" --replace >/dev/null
[ "$(cat "$TR/secrets/anthropic.key")" = "$fake2" ] && ok "import --replace uses the same placement path" || bad "import replace"

all_output="$("$SECRETS/status.sh"; cat "$TR/ledger.jsonl")"
[[ "$all_output" != *offline-fixture* ]] && ok "status and ledger contain no fixture bytes" || bad "fixture leaked to output/ledger"

printf 'secret-management-test: %d passed, %d failed\n' "$PASS" "$FAIL"
[ "$FAIL" -eq 0 ]
