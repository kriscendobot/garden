#!/bin/bash
# classify-foreign-content-test.sh — hermetic coverage for the Jev
# foreign-content pre-classification gate (classify-foreign-content.sh).
#
# Pins: the credential-absent fallback (proceed_unclassified, exit 0), the
# API-failure and bad-shape fallbacks, the request shape (both questions, the
# untrusted-data boundary, content as JSON data), and the deterministic policy
# table across both axes — clean, gray-zone injection (uncertainty fails
# toward escalation), flagged injection, advocacy caveat, confident and
# uncertain covert persuasion, uncertain neutral, and head+tail sampling of an
# oversized body. No real network is touched.
set -euo pipefail
# An ambient strict mode (a typesafe-requiring job running this test) would
# turn the fail-open cases into exit 4; each strict case sets it explicitly.
unset CLASSIFY_REQUIRE
export GARDEN_TEST=1

HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT="$(cd "$HERE/../../.." && pwd)"
CLASSIFY="$ROOT/scripts/jobs/classify-foreign-content.sh"
FAKE_CURL="$HERE/classify-foreign-content-fake-curl.sh"
TEST_DIRECTORY="$(mktemp -d /tmp/garden-classify-foreign-test.XXXXXX)"
trap 'rm -rf "$TEST_DIRECTORY"' EXIT

PASS=0
FAIL=0
ok() { printf '  PASS: %s\n' "$*"; PASS=$((PASS + 1)); }
bad() { printf '  FAIL: %s\n' "$*"; FAIL=$((FAIL + 1)); }

content="$TEST_DIRECTORY/content.txt"
printf 'A perfectly ordinary technical document about capability security.\n' >"$content"

request="$TEST_DIRECTORY/request.json"
response="$TEST_DIRECTORY/response.json"

# Canned response builder: $1=injection noul, $2=slant choice, $3=slant confidence.
respond() {
  jq -n --argjson p "$1" --arg choice "$2" --argjson c "$3" '{
    model: "jev-test",
    answers: {
      injection: { type: "noul", noul: $p },
      slant: { type: "choice", choice: $choice, confidence: $c }
    },
    usage: { input_tokens: 321, output_tokens: 12 }
  }' >"$response"
}

run() {  # runs the classifier against the canned response; echoes manifest
  TYPESAFE_API_KEY=synthetic-test-key \
  CLASSIFY_TEST_REQUEST="$request" \
  CLASSIFY_TEST_RESPONSE="$response" \
  CLASSIFY_FOREIGN_CURL="$FAKE_CURL" \
  "$CLASSIFY" "$@"
}

# --- 1. credential-absent fallback ------------------------------------------
out="$(env -u TYPESAFE_API_KEY "$CLASSIFY" "$content")" && rc=0 || rc=$?
if [ "$rc" -eq 0 ] && grep -q 'classify_policy=proceed_unclassified' <<<"$out" \
  && grep -q 'classify_status=unavailable' <<<"$out"; then
  ok "missing credential yields explicit proceed_unclassified, exit 0"
else
  bad "missing credential fallback broken (rc=$rc): $out"
fi

# --- 2. API failure fallback -------------------------------------------------
respond 0.01 neutral 0.9
out="$(CLASSIFY_TEST_RC=22 run "$content")" && rc=0 || rc=$?
if [ "$rc" -eq 0 ] && grep -q 'classify_policy=proceed_unclassified' <<<"$out"; then
  ok "API failure yields explicit proceed_unclassified, exit 0"
else
  bad "API failure fallback broken (rc=$rc): $out"
fi

# --- 3. invalid response shape fallback --------------------------------------
printf '{"answers":{"injection":{"noul":"not-a-number"}}}\n' >"$response"
out="$(run "$content")" && rc=0 || rc=$?
if [ "$rc" -eq 0 ] && grep -q 'classify_policy=proceed_unclassified' <<<"$out" \
  && grep -q 'unexpected response shape' <<<"$out"; then
  ok "invalid response shape yields explicit proceed_unclassified"
else
  bad "invalid-shape fallback broken (rc=$rc): $out"
fi

# --- 4. clean content proceeds -----------------------------------------------
respond 0.02 neutral 0.92
out="$(run "$content" 'https://example.org/doc.html' 'Ingest into the library')" && rc=0 || rc=$?
if [ "$rc" -eq 0 ] && grep -q 'classify_policy=proceed$' <<<"$out" \
  && grep -q 'classify_injection_verdict=clean' <<<"$out"; then
  ok "clean neutral content -> proceed, exit 0"
else
  bad "clean-content path broken (rc=$rc): $out"
fi

# request-shape assertions ride on the last successful call
if jq -e '
  (.questions.injection.type == "noul") and
  (.questions.slant.type == "choice") and
  (.questions.slant.criteria | has("covert_persuasion")) and
  (.state.safety | contains("untrusted data")) and
  (.state.source_url == "https://example.org/doc.html") and
  (.state.content | contains("capability security"))
' "$request" >/dev/null; then
  ok "request carries both typed questions, the boundary framing, and the content as data"
else
  bad "request shape is incomplete"
fi

# --- 5. flagged injection escalates (exit 3) ----------------------------------
respond 0.87 neutral 0.9
out="$(run "$content")" && rc=0 || rc=$?
if [ "$rc" -eq 3 ] && grep -q 'classify_policy=halt_and_escalate' <<<"$out" \
  && grep -q 'classify_injection_verdict=flagged' <<<"$out"; then
  ok "flagged injection -> halt_and_escalate, exit 3"
else
  bad "flagged-injection path broken (rc=$rc): $out"
fi

# --- 6. gray-zone injection escalates too (uncertainty fails toward caution) ---
respond 0.35 neutral 0.9
out="$(run "$content")" && rc=0 || rc=$?
if [ "$rc" -eq 3 ] && grep -q 'classify_injection_verdict=uncertain' <<<"$out" \
  && grep -q 'classify_policy=halt_and_escalate' <<<"$out"; then
  ok "injection equipoise -> halt_and_escalate (fails toward caution)"
else
  bad "gray-zone injection path broken (rc=$rc): $out"
fi

# --- 7. advocacy -> proceed_with_caveat ---------------------------------------
respond 0.03 advocacy 0.8
out="$(run "$content")" && rc=0 || rc=$?
if [ "$rc" -eq 0 ] && grep -q 'classify_policy=proceed_with_caveat' <<<"$out" \
  && grep -q 'classify_caveat=.*attribution' <<<"$out"; then
  ok "advocacy -> proceed_with_caveat with an attribution caveat"
else
  bad "advocacy path broken (rc=$rc): $out"
fi

# --- 8. confident covert persuasion escalates ---------------------------------
respond 0.03 covert_persuasion 0.74
out="$(run "$content")" && rc=0 || rc=$?
if [ "$rc" -eq 3 ] && grep -q 'classify_policy=halt_and_escalate' <<<"$out"; then
  ok "confident covert persuasion -> halt_and_escalate, exit 3"
else
  bad "confident covert-persuasion path broken (rc=$rc): $out"
fi

# --- 9. uncertain covert persuasion carries the flag as a caveat --------------
respond 0.03 covert_persuasion 0.31
out="$(run "$content")" && rc=0 || rc=$?
if [ "$rc" -eq 0 ] && grep -q 'classify_policy=proceed_with_caveat' <<<"$out" \
  && grep -q 'classify_caveat=.*covert persuasion' <<<"$out"; then
  ok "uncertain covert persuasion -> caveat carrying the suspicion"
else
  bad "uncertain covert-persuasion path broken (rc=$rc): $out"
fi

# --- 10. uncertain neutral never passes silently ------------------------------
respond 0.03 neutral 0.2
out="$(run "$content")" && rc=0 || rc=$?
if [ "$rc" -eq 0 ] && grep -q 'classify_policy=proceed_with_caveat' <<<"$out"; then
  ok "low-confidence neutral -> proceed_with_caveat, not a silent pass"
else
  bad "uncertain-neutral path broken (rc=$rc): $out"
fi

# --- 11. oversized content is head+tail sampled -------------------------------
big="$TEST_DIRECTORY/big.txt"
{ printf 'HEAD-MARKER\n'; head -c 400000 /dev/zero | tr '\0' 'a'; printf '\nTAIL-MARKER\n'; } >"$big"
respond 0.02 neutral 0.9
out="$(run "$big")" && rc=0 || rc=$?
if [ "$rc" -eq 0 ] && grep -q 'classify_truncated=true' <<<"$out" \
  && jq -e '(.state.content | contains("HEAD-MARKER")) and (.state.content | contains("TAIL-MARKER")) and (.state.content | contains("elided by the sampler")) and (.state.content_sampled == true)' "$request" >/dev/null; then
  ok "oversized body sampled head+tail with the elision marked"
else
  bad "sampling path broken (rc=$rc)"
fi

# --- 12. strict mode refuses instead of proceeding unclassified ----------------
out="$(env -u TYPESAFE_API_KEY CLASSIFY_REQUIRE=1 "$CLASSIFY" "$content")" && rc=0 || rc=$?
if [ "$rc" -eq 4 ] && grep -q 'classify_policy=halt_unclassified' <<<"$out" \
  && grep -q 'classify_status=unavailable' <<<"$out"; then
  ok "strict mode without credential exits 4 with halt_unclassified"
else
  bad "strict mode credential-absent path broken (rc=$rc): $out"
fi
respond 0.01 neutral 0.9
out="$(CLASSIFY_REQUIRE=1 CLASSIFY_TEST_RC=22 run "$content")" && rc=0 || rc=$?
if [ "$rc" -eq 4 ] && grep -q 'classify_policy=halt_unclassified' <<<"$out"; then
  ok "strict mode API failure exits 4"
else
  bad "strict mode API-failure path broken (rc=$rc): $out"
fi
out="$(CLASSIFY_REQUIRE=1 run "$content")" && rc=0 || rc=$?
if [ "$rc" -eq 0 ] && grep -q 'classify_policy=proceed$' <<<"$out"; then
  ok "strict mode with a working classifier proceeds normally"
else
  bad "strict mode classified path broken (rc=$rc): $out"
fi

# --- 13. usage errors ----------------------------------------------------------
if ! "$CLASSIFY" "$TEST_DIRECTORY/absent-file" >/dev/null 2>&1; then
  ok "missing content file is a usage error"
else
  bad "missing content file accepted"
fi

printf 'classify-foreign-content: %d passed, %d failed\n' "$PASS" "$FAIL"
[ "$FAIL" -eq 0 ]
