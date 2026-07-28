#!/bin/bash
# ollama-serve-backoff-test.sh — wrapper preflight and crash backoff behavior.
set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
JOBS="$(cd "$HERE/.." && pwd)"
PASS=0; FAIL=0
ok() { echo "  PASS: $*"; PASS=$((PASS + 1)); }
bad() { echo "  FAIL: $*"; FAIL=$((FAIL + 1)); }

TR="$(mktemp -d "${TMPDIR:-/tmp}/garden-ollama-serve.XXXXXX")"
trap 'rm -rf "$TR"' EXIT
BIN="$TR/bin"; CTL="$TR/ctl"
mkdir -p "$BIN" "$CTL"
ln -s "$HERE/ollama-serve-fake-command.sh" "$BIN/curl"
ln -s "$HERE/ollama-serve-fake-command.sh" "$BIN/ollama"
# A missing-binary case uses this deliberately tiny PATH. The wrapper and its mock
# only need these external commands; excluding every Ollama install directory makes
# the precondition deterministic even on a host that has Ollama installed.
ln -s /usr/bin/basename "$BIN/basename"
ln -s /usr/bin/dirname "$BIN/dirname"
ln -s /bin/date "$BIN/date"
ln -s /bin/sleep "$BIN/sleep"

run_wrapper() {
  env PATH="$BIN:$PATH" OLLAMA_TEST_CTL="$CTL" \
    GARDEN_LOCAL_OLLAMA_URL="http://127.0.0.1:11434/v1" \
    GARDEN_OLLAMA_RESTART_BACKOFF_SECONDS=0 \
    "$JOBS/ollama-serve.sh" >"$CTL/stdout" 2>"$CTL/stderr"
}

rm -f "$CTL"/*
: >"$CTL/endpoint-up"
if run_wrapper; then status=0; else status=$?; fi
[ "$status" -eq 0 ] && ok "reachable endpoint exits cleanly after its wrapper backoff" || bad "reachable endpoint status was $status"
[ ! -e "$CTL/ollama-calls" ] && ok "reachable endpoint does not start a duplicate ollama" || bad "duplicate ollama was started"
grep -q -- '--max-time 5 http://127.0.0.1:11434/v1/models' "$CTL/curl-calls" \
  && ok "endpoint preflight uses the bounded models probe" || bad "models probe arguments changed"

rm -f "$CTL"/*
: >"$CTL/endpoint-up"; : >"$CTL/endpoint-empty"
if run_wrapper; then status=0; else status=$?; fi
[ "$status" -ne 0 ] && ok "model-less endpoint does not stand down cleanly" || bad "model-less endpoint was treated as healthy"
grep -qx 'serve' "$CTL/ollama-calls" && ok "model-less endpoint starts garden's Ollama owner" || bad "model-less endpoint did not start Ollama"
grep -q 'serves no models; refusing to stand down' "$CTL/stderr" \
  && ok "model-less endpoint is logged loudly" || bad "model-less endpoint diagnostic missing"

rm -f "$CTL"/*
if OLLAMA_TEST_SERVE_STATUS=0 run_wrapper; then status=0; else status=$?; fi
[ "$status" -eq 0 ] && ok "an immediate successful ollama exit is returned after backoff" || bad "successful child status was $status"
grep -qx 'serve' "$CTL/ollama-calls" && ok "wrapper runs ollama serve as a child" || bad "ollama serve was not invoked"
grep -q 'exited with status 0; waiting 0s' "$CTL/stderr" \
  && ok "immediate successful exit receives wrapper backoff" || bad "successful exit did not log backoff"

rm -f "$CTL"/*
if OLLAMA_TEST_SERVE_STATUS=23 run_wrapper; then status=0; else status=$?; fi
[ "$status" -eq 23 ] && ok "failed child status is preserved after backoff" || bad "failed child status was $status"
grep -q 'exited with status 23; waiting 0s' "$CTL/stderr" \
  && ok "failed child receives wrapper backoff" || bad "failed exit did not log backoff"

rm -f "$CTL"/* "$BIN/ollama"
if env PATH="$BIN" OLLAMA_TEST_CTL="$CTL" GARDEN_ROOT="$TR/root" \
  GARDEN_LOCAL_OLLAMA_URL="http://127.0.0.1:11434/v1" \
  GARDEN_OLLAMA_RESTART_BACKOFF_SECONDS=0 "$JOBS/ollama-serve.sh" \
  >"$CTL/stdout" 2>"$CTL/stderr"; then status=0; else status=$?; fi
[ "$status" -eq 1 ] && ok "missing ollama returns failure only after wrapper backoff" || bad "missing ollama status was $status"
grep -q 'not on PATH.*waiting 0s' "$CTL/stderr" \
  && ok "missing ollama logs its wrapper backoff" || bad "missing ollama did not log backoff"
ln -s "$HERE/ollama-serve-fake-command.sh" "$BIN/ollama"

rm -f "$CTL"/*
OLLAMA_TEST_SERVE_SLEEP=30 run_wrapper & wrapper_pid=$!
for _ in $(seq 1 50); do
  [ -e "$CTL/ollama-calls" ] && break
  sleep 0.1
done
kill -TERM "$wrapper_pid"
if wait "$wrapper_pid"; then status=0; else status=$?; fi
[ "$status" -eq 143 ] && ok "SIGTERM exits cleanly with systemd's SuccessExitStatus" || bad "SIGTERM status was $status"

echo "RESULTS: $PASS passed, $FAIL failed"
[ "$FAIL" -eq 0 ]
