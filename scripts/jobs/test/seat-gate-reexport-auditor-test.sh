#!/bin/bash
# seat-gate-reexport-auditor-test.sh — validate the cost-gated dispatch for the
# reexport-auditor jury seat (gardening/seat-gate-reexport-auditor.sh). The gate
# runs the no-plain-reexport probe as its deterministic pre-pass and drives the
# same three branches the orthographer gate has:
#   1. APPROVE: a clean change -> approve block, claude is NEVER invoked.
#   2. CANNOT-DETERMINE: the pre-pass cannot run (no parser) -> comment-only block
#      surfacing the reason, claude is NEVER invoked (never a silent approve).
#   3. SPEND-LLM: a newly-introduced plain re-export -> exactly one `claude -p`,
#      whose block is emitted verbatim, with the candidate digest in the prompt.
#   4. FALLBACK: claude returns nothing -> deterministic request-changes block
#      listing the candidate, so the finding still reaches the fix pass.
#   5. REGRESSION: a compliant `@deprecated` shim is NOT a candidate (approve).
#
# Hermetic: throwaway git repos and a stub `claude` on PATH that records its
# invocations; no live claude, no network.

# The ok/bad idiom is the intended A && pass || fail (SC2015, safe: ok never fails).
# shellcheck disable=SC2015
set -uo pipefail
export GARDEN_TEST=1
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT="$(cd "$HERE/../../.." && pwd)"
GATE="$ROOT/scripts/jobs/gardening/seat-gate-reexport-auditor.sh"
export GARDEN_ROOT="$ROOT"
TR="$(mktemp -d "${TMPDIR:-/tmp}/sgra-test.XXXXXX")"
PASS=0; FAIL=0
ok()  { echo "  PASS: $*"; PASS=$((PASS+1)); }
bad() { echo "  FAIL: $*"; FAIL=$((FAIL+1)); }
trap 'rm -rf "$TR"' EXIT

# Stub claude: log each call (and its prompt) and print $STUB_CLAUDE_OUT.
mkdir -p "$TR/bin"
cat > "$TR/bin/claude" <<'EOF'
#!/bin/bash
echo call >> "$STUB_CLAUDE_LOG"
printf '%s\n' "${@: -1}" > "$STUB_CLAUDE_PROMPT"
[ -n "${STUB_CLAUDE_OUT:-}" ] && printf '%s\n' "$STUB_CLAUDE_OUT"
exit 0
EOF
chmod +x "$TR/bin/claude"
export PATH="$TR/bin:$PATH"
export STUB_CLAUDE_LOG="$TR/claude.log" STUB_CLAUDE_PROMPT="$TR/claude.prompt"
calls() { [ -f "$STUB_CLAUDE_LOG" ] && wc -l < "$STUB_CLAUDE_LOG" | tr -d ' ' || echo 0; }
reset_stub() { rm -f "$STUB_CLAUDE_LOG" "$STUB_CLAUDE_PROMPT"; }

# make_change <dir> <line...> — repo with a base commit, then a commit writing m.js.
BASE=""
make_change() {
  local dir="$1"; shift
  mkdir -p "$dir"; git -C "$dir" init -q
  git -C "$dir" config user.email t@localhost; git -C "$dir" config user.name test
  printf 'export const seed = 1;\n' > "$dir/m.js"
  git -C "$dir" add -A; git -C "$dir" commit -qm base >/dev/null
  BASE="$(git -C "$dir" rev-parse HEAD)"
  printf '%s\n' "$@" > "$dir/m.js"
  git -C "$dir" add -A; git -C "$dir" commit -qm change >/dev/null
}

# --- 1: APPROVE on a clean change --------------------------------------------
reset_stub
R="$TR/clean"; make_change "$R" 'export const seed = 2;'
out="$(bash "$GATE" reexport-auditor 7 "$R" "$BASE")"
{ echo "$out" | grep -q '^### reexport-auditor' && echo "$out" | grep -q '\*\*Verdict:\*\* approve'; } \
  && ok "1 APPROVE block on a clean change" || bad "1 APPROVE ($out)"
[ "$(calls)" -eq 0 ] && ok "1 APPROVE spends no claude -p" || bad "1 APPROVE invoked claude $(calls)x"

# --- 2: CANNOT-DETERMINE when the pre-pass cannot run -----------------------
reset_stub
R="$TR/noparser"; make_change "$R" "export { x } from './y.js';"
out="$(GARDEN_REEXPORT_PARSER="$TR/missing.cjs" bash "$GATE" reexport-auditor 7 "$R" "$BASE")"
{ echo "$out" | grep -q '\*\*Verdict:\*\* comment-only' && echo "$out" | grep -q 'could not be checked'; } \
  && ok "2 CANNOT-DETERMINE surfaces a comment-only block" || bad "2 CANNOT-DETERMINE ($out)"
[ "$(calls)" -eq 0 ] && ok "2 CANNOT-DETERMINE spends no claude -p" || bad "2 CANNOT-DETERMINE invoked claude"

# --- 3: SPEND-LLM on a candidate ---------------------------------------------
reset_stub
R="$TR/candidate"; make_change "$R" "export { x } from './y.js';"
out="$(STUB_CLAUDE_OUT=$'### reexport-auditor\n\n**Verdict:** request-changes\n\nSTUB-JUROR-BLOCK' \
  bash "$GATE" reexport-auditor 7 "$R" "$BASE")"
[ "$(calls)" -eq 1 ] && ok "3 SPEND-LLM invokes claude exactly once" || bad "3 SPEND-LLM calls=$(calls)"
echo "$out" | grep -q 'STUB-JUROR-BLOCK' && ok "3 SPEND-LLM emits the juror block verbatim" || bad "3 SPEND-LLM output ($out)"
{ grep -q "m.js:1 new plain named re-export from './y.js'" "$STUB_CLAUDE_PROMPT" \
    && grep -q 'REEXPORT-CANDIDATE-DATA' "$STUB_CLAUDE_PROMPT"; } \
  && ok "3 SPEND-LLM prompt carries the candidate digest as fenced DATA" || bad "3 SPEND-LLM prompt missing digest"

# --- 4: FALLBACK when claude declines ----------------------------------------
reset_stub
out="$(STUB_CLAUDE_OUT='' bash "$GATE" reexport-auditor 7 "$R" "$BASE")"
{ echo "$out" | grep -q '\*\*Verdict:\*\* request-changes' && echo "$out" | grep -q "  - m.js:1 new plain named re-export"; } \
  && ok "4 FALLBACK deterministic request-changes lists the candidate" || bad "4 FALLBACK ($out)"

# --- 5: REGRESSION — a compliant deprecated shim is not a candidate ---------
reset_stub
R="$TR/shim"; make_change "$R" \
  "/** @deprecated Import { x } from './y.js' directly. */" \
  "export { x } from './y.js';"
out="$(bash "$GATE" reexport-auditor 7 "$R" "$BASE")"
{ echo "$out" | grep -q '\*\*Verdict:\*\* approve' && [ "$(calls)" -eq 0 ]; } \
  && ok "5 REGRESSION deprecated shim approved with no claude -p" || bad "5 REGRESSION ($out)"

# --- 6: the seat is wired into the code panel --------------------------------
grep -Eq '^reexport-auditor\}"|[[:space:]]reexport-auditor[[:space:]}]' "$ROOT/scripts/jobs/gardening/panel.sh" \
  && ok "6 reexport-auditor is listed in GARDEN_CODE_SEATS" || bad "6 panel.sh wiring missing"

echo
echo "seat-gate-reexport-auditor-test: $PASS passed, $FAIL failed"
[ "$FAIL" -eq 0 ]
