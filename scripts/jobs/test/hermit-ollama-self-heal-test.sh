#!/bin/bash
# hermit-ollama-self-heal-test.sh — the hermit (provider: local) preflight self-heal.
#
# A `model: qwen3.6` hermit tick must never fail merely because the on-box Ollama
# /v1 endpoint is down: codex_provider_preflight (codex-provider-common.sh), when the
# caller requests self-heal, (re)starts garden-ollama.service and polls /v1/models for
# readiness before dying. This test drives that branch with PATH-injected mock
# `codex`/`curl`/`systemctl` (no real endpoint, no systemd), asserting:
#
#   REACHABLE   — endpoint up → return 0, NO systemctl start (fast path).
#   RECOVER     — endpoint down, self_heal=1, garden-ollama start brings it up →
#                 return 0 after the poll sees it, systemctl start WAS issued.
#   GIVE-UP     — endpoint down, self_heal=1, start does NOT help → return 1 with the
#                 host-defect diagnostic after the bounded poll.
#   NO-HEAL     — endpoint down, self_heal=0 (the foreman's probe) → return 1
#                 IMMEDIATELY, NO systemctl start (it advances to the next provider).
#   PER-JOB     — the local branch consults NO once-per-boot auth marker: a first call
#                 that succeeds writes no marker, so a later call with the endpoint now
#                 DOWN re-probes (and self-heals) instead of being masked for the boot.
#   NO-MODEL    — a reachable endpoint with an empty /v1/models list is rejected with
#                 an actionable `ollama pull` host-defect diagnostic.
#   HOST DERIVE — ollama_serve_host strips scheme + /v1 from GARDEN_LOCAL_OLLAMA_URL,
#                 so the served OLLAMA_HOST and the client URL cannot drift.
#
# Usage: hermit-ollama-self-heal-test.sh
set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
JOBS="$(cd "$HERE/.." && pwd)"
PASS=0; FAIL=0
ok()  { echo "  PASS: $*"; PASS=$((PASS+1)); }
bad() { echo "  FAIL: $*"; FAIL=$((FAIL+1)); }
hr()  { echo "----------------------------------------------------------------"; }

# Scrub ambient fleet env (this test is often run BY a live gardener whose process
# exports the fleet's GARDEN_*/JOURNAL_*), so only the fixture below is authoritative.
unset $(compgen -v 2>/dev/null | grep -E '^(GARDEN_|JOURNAL_|SELF_HEAL_|XDG_)' || true) 2>/dev/null || true
export GARDEN_TEST=1

TR="$(mktemp -d "${TMPDIR:-/tmp}/garden-hermit-heal.XXXXXX")"
trap 'rm -rf "$TR"' EXIT
BIN="$TR/bin"; mkdir -p "$BIN"
export GARDEN_STATE="$TR/state"; mkdir -p "$GARDEN_STATE"
export GARDEN_LOCAL_OLLAMA_URL=http://127.0.0.1:11434/v1
export GARDEN_OLLAMA_HEAL_TIMEOUT=2          # keep the give-up poll short
# The mocks share this control dir (passed by env so the subprocesses see it).
export HEAL_CTL="$TR/ctl"; mkdir -p "$HEAL_CTL"

# --- PATH-injected mocks (symlinks to committed repo scripts) ----------------
# The mocks are COMMITTED scripts symlinked into $BIN (not written to /tmp): the same
# pattern foreman-provider-order-test.sh uses, so the executed file lives in the repo
# tree (portable across a noexec /tmp / a sandboxed runner). $BIN goes first on PATH so
# the fake curl/systemctl/codex shadow the host's real ones (a real on-box Ollama must
# NOT mask the probe). The mocks share $HEAL_CTL for control + call logs.
ln -s "$HERE/hermit-heal-fake-codex.sh"     "$BIN/codex"
ln -s "$HERE/hermit-heal-fake-curl.sh"      "$BIN/curl"
ln -s "$HERE/hermit-heal-fake-systemctl.sh" "$BIN/systemctl"
export PATH="$BIN:$PATH"

# shellcheck source=../common.sh
source "$JOBS/common.sh"
# shellcheck source=../handlers/codex-provider-common.sh
source "$JOBS/handlers/codex-provider-common.sh"

reset_ctl() { rm -rf "$HEAL_CTL"; mkdir -p "$HEAL_CTL"; }
called_systemctl() { [ -s "$HEAL_CTL/systemctl-calls" ]; }
curl_call_count() { [ -f "$HEAL_CTL/curl-calls" ] && wc -l < "$HEAL_CTL/curl-calls" | tr -d ' ' || echo 0; }

# ============================================================================
hr; echo "HOST DERIVE — ollama_serve_host strips scheme + /v1 path"; hr
[ "$(ollama_serve_host)" = "127.0.0.1:11434" ] && ok "default URL → 127.0.0.1:11434" || bad "default derive ($(ollama_serve_host))"
( export GARDEN_LOCAL_OLLAMA_URL=http://gpu-box.local:9999/v1; [ "$(ollama_serve_host)" = "gpu-box.local:9999" ] ) \
  && ok "non-default host:port derived (no drift)" || bad "non-default derive"
( export GARDEN_LOCAL_OLLAMA_URL=http://127.0.0.1:11434/v1/; [ "$(ollama_serve_host)" = "127.0.0.1:11434" ] ) \
  && ok "trailing-slash path stripped" || bad "trailing slash derive"

# ============================================================================
hr; echo "REACHABLE — endpoint up → return 0, no self-heal"; hr
reset_ctl; : > "$HEAL_CTL/up"
if codex_provider_preflight local hermit job-a hermits 1 qwen3.6 >/dev/null 2>&1; then ok "reachable endpoint → preflight 0"; else bad "reachable endpoint failed preflight"; fi
called_systemctl && bad "systemctl start issued for a reachable endpoint" || ok "no systemctl start when reachable (fast path)"

# ============================================================================
hr; echo "NO-MODEL — reachable endpoint with no pulled model → host-defect fail"; hr
reset_ctl; : > "$HEAL_CTL/up"; : > "$HEAL_CTL/empty-models"
err="$(codex_provider_preflight local hermit job-empty hermits 1 qwen3.6 2>&1)" && rc=0 || rc=$?
[ "$rc" -ne 0 ] && grep -Fq "local endpoint reachable but model 'qwen3.6' not pulled; run 'ollama pull qwen3.6'" <<<"$err" \
  && ok "empty model list fails with the pull diagnostic" \
  || bad "empty model list did not produce the pull diagnostic: $err"

# ============================================================================
hr; echo "RECOVER — down, self_heal=1, garden-ollama start brings it up"; hr
reset_ctl                       # no 'up' file → down initially
if GARDEN_TEST_HEAL_SUCCEEDS=1 codex_provider_preflight local hermit job-b hermits 1 qwen3.6 >/dev/null 2>&1; then
  ok "self-heal recovered the endpoint → preflight 0"
else
  bad "self-heal did not recover a startable endpoint"
fi
grep -q 'start garden-ollama.service' "$HEAL_CTL/systemctl-calls" 2>/dev/null \
  && ok "garden-ollama.service was started during recovery" || bad "garden-ollama start not issued"

# ============================================================================
hr; echo "GIVE-UP — down, self_heal=1, start does not help → host-defect die"; hr
reset_ctl                       # start will NOT create 'up' (GARDEN_TEST_HEAL_SUCCEEDS unset)
err="$(codex_provider_preflight local hermit job-c hermits 1 qwen3.6 2>&1)" && rc=0 || rc=$?
[ "$rc" -ne 0 ] && ok "unrecoverable endpoint → preflight non-zero (host defect)" || bad "give-up path returned 0"
grep -q 'self-heal' <<<"$err" && grep -q 'garden-ollama.service' <<<"$err" \
  && ok "diagnostic names the failed self-heal + garden-ollama.service" || bad "diagnostic missing self-heal detail: $err"
called_systemctl && ok "systemctl start was attempted before giving up" || bad "no start attempt on the give-up path"

# ============================================================================
hr; echo "NO-HEAL — down, self_heal=0 (foreman probe) → immediate fail, no start"; hr
reset_ctl
before="$(date +%s)"
codex_provider_preflight local hermit job-d hermits 0 qwen3.6 >/dev/null 2>&1 && rc=0 || rc=$?
after="$(date +%s)"
[ "$rc" -ne 0 ] && ok "self_heal=0 down endpoint → immediate non-zero" || bad "self_heal=0 returned 0"
called_systemctl && bad "self_heal=0 still started garden-ollama (should just advance)" || ok "self_heal=0 issues NO systemctl start (foreman advances providers)"
[ "$(curl_call_count)" = 1 ] && ok "self_heal=0 probes exactly once (no poll loop)" || bad "self_heal=0 probed $(curl_call_count) times (expected 1)"
[ $((after - before)) -lt "$GARDEN_OLLAMA_HEAL_TIMEOUT" ] && ok "self_heal=0 returns without waiting the heal window" || bad "self_heal=0 blocked on the heal poll"

# ============================================================================
hr; echo "PER-JOB — local branch consults NO once-per-boot auth marker"; hr
reset_ctl; : > "$HEAL_CTL/up"
codex_provider_preflight local hermit job-e hermits 1 qwen3.6 >/dev/null 2>&1 || true
# The local branch must NOT have written an auth-ok-<boot> marker (that would mask a
# later mid-life crash for the rest of the boot — the gap this change closes).
if find "$GARDEN_STATE" -name 'auth-ok-*' 2>/dev/null | grep -q .; then
  bad "local success wrote a per-boot auth marker (mid-life crash would be masked)"
else
  ok "local success wrote no per-boot marker"
fi
# Now the endpoint dies mid-boot: a fresh call must re-probe (self_heal=0, no recovery
# so it simply reports down) rather than short-circuiting on a stale marker.
reset_ctl                       # down again, no 'up'
codex_provider_preflight local hermit job-f hermits 0 qwen3.6 >/dev/null 2>&1 && rc=0 || rc=$?
[ "$rc" -ne 0 ] && [ "$(curl_call_count)" -ge 1 ] \
  && ok "a later call re-probes the endpoint (mid-life crash re-triggers, not masked)" \
  || bad "later call did not re-probe (rc=$rc probes=$(curl_call_count))"

hr
echo "RESULTS: $PASS passed, $FAIL failed"
[ "$FAIL" -eq 0 ]
