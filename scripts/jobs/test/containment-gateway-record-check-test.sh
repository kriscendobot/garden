#!/bin/bash
# containment-gateway-record-check-test.sh — hermetic coverage for
# containment-gateway-record-check.sh in --local-root mode (no SSM, no AWS).
#
# The check is the scheduler preflight for the daily minion.town gateway record
# containment schedule: exit 2 = clean (silent), exit 0 = findings or scan failure
# written to stdout and $GARDEN_PREFLIGHT_CONTEXT_FILE.
#
# Usage: containment-gateway-record-check-test.sh
set -uo pipefail
export GARDEN_TEST=1
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CHECK="$(cd "$HERE/.." && pwd)/containment-gateway-record-check.sh"
PASS=0; FAIL=0
ok()  { echo "  PASS: $*"; PASS=$((PASS+1)); }
bad() { echo "  FAIL: $*"; FAIL=$((FAIL+1)); }

TR="$(mktemp -d)"; trap 'rm -rf "$TR"' EXIT
DEREG=09201a316203e9d99e3c906b12c9466d8f0ae8dc8baf8db484c918d6698f657f
DCKC='https://cognito-idp.us-west-1.amazonaws.com/us-west-1_x/8929a9ae-b001-709d-02ea-e94df6225c0a'
BASE=806fc2eae36981df79664c85fc58629e0e790ffe9ed9276ff5d586dd912b5a9f

fresh() {
  rm -rf "$TR/store"; mkdir -p "$TR/store/vhosts/sub" "$TR/store/vhosts-revoked-20260812"
  printf '{"contentRoot":"aa","owner":"%s","powers":"counter"}\n' "$DCKC" > "$TR/store/vhosts/$BASE.json"
  printf '{\n  "contentRoot": "bb",\n  "owner": "someone-else"\n}\n' > "$TR/store/vhosts/sub/$(printf 'b%.0s' {1..64}).json"
}
run() { CTX="$TR/ctx"; rm -f "$CTX"; OUT="$(GARDEN_PREFLIGHT_CONTEXT_FILE="$CTX" "$CHECK" "$@")"; RC=$?; }

echo "== clean store is silent and exits 2"
fresh; run --local-root "$TR/store/vhosts"
[ "$RC" = 2 ] && ok "rc=2" || bad "rc=$RC"
[ -z "$OUT" ] && ok "no output" || bad "output: $OUT"
[ ! -s "$TR/ctx" ] && ok "no context" || bad "context written"

echo "== reappeared record in a SUBDIRECTORY is moved back and reported"
fresh; printf '{ "owner" : "%s", "powers" : "@agent" }\n' "$DCKC" > "$TR/store/vhosts/sub/$DEREG.json"
run --local-root "$TR/store/vhosts"
[ "$RC" = 0 ] && ok "rc=0" || bad "rc=$RC"
[ ! -e "$TR/store/vhosts/sub/$DEREG.json" ] && ok "removed from active" || bad "still active"
[ -e "$TR/store/vhosts-revoked-20260812/$DEREG.json" ] && ok "in revoked store" || bad "not in revoked"
grep -q '^- REMEDIATED ' "$TR/ctx" && ok "context reports remediation" || bad "ctx: $(cat "$TR/ctx" 2>/dev/null)"
grep -q 'FINDING' <<<"$OUT" && bad "rescan left findings: $OUT" || ok "rescan clean"

echo "== an existing revoked copy is not clobbered"
fresh; echo old > "$TR/store/vhosts-revoked-20260812/$DEREG.json"; echo '{}' > "$TR/store/vhosts/$DEREG.json"
run --local-root "$TR/store/vhosts"
[ "$(cat "$TR/store/vhosts-revoked-20260812/$DEREG.json")" = old ] && ok "original kept" || bad "clobbered"
ls "$TR/store/vhosts-revoked-20260812/" | grep -q "$DEREG.json.reappeared-" && ok "suffixed copy" || bad "no suffixed copy"

echo "== --no-remediate reports without moving"
fresh; echo '{}' > "$TR/store/vhosts/$DEREG.json"
run --no-remediate --local-root "$TR/store/vhosts"
[ "$RC" = 0 ] && [ -e "$TR/store/vhosts/$DEREG.json" ] && ok "reported, not moved" || bad "rc=$RC"
grep -q 'ACTIVE again' <<<"$OUT" && ok "finding text" || bad "$OUT"

echo "== whitespace-split content reference is a finding, not moved"
fresh; printf '{"contentRoot":"cc","note":"%s %s"}\n' "${DEREG:0:30}" "${DEREG:30}" > "$TR/store/vhosts/sub/$(printf 'c%.0s' {1..64}).json"
run --local-root "$TR/store/vhosts"
[ "$RC" = 0 ] && grep -q 'referenced by active record' <<<"$OUT" && ok "content match" || bad "rc=$RC $OUT"

echo "== unexpected dckc-owned record is a finding"
fresh; printf '{"owner":"%s","powers":"@host"}\n' "$DCKC" > "$TR/store/vhosts/sub/$(printf 'd%.0s' {1..64}).json"
run --local-root "$TR/store/vhosts"
[ "$RC" = 0 ] && grep -q "unexpected active dckc-owned record sub/dddd.*'@host'" <<<"$OUT" && ok "flagged" || bad "rc=$RC $OUT"

echo "== unparseable record is a scan failure"
fresh; echo '{nope' > "$TR/store/vhosts/sub/bad.json"
run --local-root "$TR/store/vhosts"
[ "$RC" = 0 ] && grep -q 'scan-failure: unparseable record sub/bad.json' <<<"$OUT" && ok "flagged" || bad "rc=$RC $OUT"

echo "== missing active store is a scan failure, never a quiet pass"
fresh; run --local-root "$TR/store/nope"
[ "$RC" = 0 ] && grep -q 'SCAN FAILURE' <<<"$OUT" && ok "failure reported" || bad "rc=$RC $OUT"
grep -q 'SCAN FAILURE' "$TR/ctx" && ok "failure in context" || bad "no context"

echo
echo "containment-gateway-record-check-test: $PASS passed, $FAIL failed"
[ "$FAIL" = 0 ]
