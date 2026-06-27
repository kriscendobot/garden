#!/bin/bash
# fetch-source-test.sh — coverage for the deterministic primary-source fetcher
# (fetch-source.sh).
#
# fetch-source.sh encodes the archive-fallback + hashing recipe that scholar
# ingest cycles kept re-deriving in prose: try a direct curl, and on a
# connection failure fall back to the Internet Archive ORIGINAL-bytes capture
# (`web/<ts>id_/<url>` — the id_ form returns unmodified bytes so the SHA-256 is
# stable), then emit `source_content_sha256` as the citable idempotency anchor.
# This test pins all three behaviours plus the failure modes.
#
# Hermetic: FETCH_SOURCE_CURL points at a stub that simulates the network. The
# stub's per-case behaviour is driven by STUB_* env vars. No real network is
# touched, and curl/jq/sha256sum (the script's real deps) are the only host
# tools used (for the actual hashing).
#
# Usage: fetch-source-test.sh
set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
JOBS="$(cd "$HERE/.." && pwd)"
FETCH="$JOBS/fetch-source.sh"
PASS=0; FAIL=0
ok()  { echo "  PASS: $*"; PASS=$((PASS+1)); }
bad() { echo "  FAIL: $*"; FAIL=$((FAIL+1)); }
hr()  { echo "----------------------------------------------------------------"; }

# Scrub ambient fleet env so a live gardener invoking this test cannot splice its
# own GARDEN_*/JOURNAL_* state underneath the fixture (mirrors run-test.sh).
unset $(compgen -v 2>/dev/null | grep -E '^(GARDEN_|JOURNAL_|SELF_HEAL_|XDG_)' || true) 2>/dev/null || true

TR=/home/kris/.garden-fetch-source-test
rm -rf "$TR"; mkdir -p "$TR"

# --- the curl stub ----------------------------------------------------------
# Stands in for curl. Recognizes three request shapes by URL and is driven by
# STUB_* env vars set per case:
#   STUB_DIRECT_RC      direct-fetch exit code (0 -> writes STUB_DIRECT_BODY)
#   STUB_DIRECT_BODY    body written on a successful direct fetch
#   STUB_AVAIL_RC       availability-API exit code
#   STUB_AVAIL_JSON     availability-API JSON printed to stdout
#   STUB_ARCHIVE_RC     archive-fetch exit code (0 -> writes STUB_ARCHIVE_BODY)
#   STUB_ARCHIVE_BODY   body written on a successful archive fetch
# It also records each requested URL to $STUB_LOG for assertions.
STUB="$TR/curl-stub.sh"
cat >"$STUB" <<'STUB_EOF'
#!/bin/bash
# Parse out `-o <path>` and the trailing URL from a curl-shaped arg list.
out=""; url=""
while [ $# -gt 0 ]; do
  case "$1" in
    -o) out="$2"; shift 2;;
    --connect-timeout|--max-time) shift 2;;
    -*) shift;;            # other flags (-fsSL etc.)
    *)  url="$1"; shift;;  # last non-flag wins = the URL
  esac
done
printf '%s\n' "$url" >>"$STUB_LOG"
case "$url" in
  *"/wayback/available"*)
    printf '%s' "${STUB_AVAIL_JSON:-}"; exit "${STUB_AVAIL_RC:-0}" ;;
  *"web.archive.org"*)
    [ "${STUB_ARCHIVE_RC:-0}" = 0 ] && printf '%s' "${STUB_ARCHIVE_BODY:-}" >"$out"
    exit "${STUB_ARCHIVE_RC:-0}" ;;
  *)
    [ "${STUB_DIRECT_RC:-0}" = 0 ] && printf '%s' "${STUB_DIRECT_BODY:-}" >"$out"
    exit "${STUB_DIRECT_RC:-0}" ;;
esac
STUB_EOF
chmod +x "$STUB"

export FETCH_SOURCE_CURL="$STUB"
export STUB_LOG="$TR/urls.log"

sha_of() { printf '%s' "$1" | sha256sum | awk '{print $1}'; }
field()  { grep "^$1=" | sed "s/^$1=//"; }   # extract a manifest field from stdout

URL="http://erights.org/talks/asian03/paradigm.pdf"

# === 1. direct fetch succeeds ===============================================
hr; echo "CASE 1: direct fetch succeeds"
: >"$STUB_LOG"
OUT="$TR/case1.out"
MAN="$(STUB_DIRECT_RC=0 STUB_DIRECT_BODY="hello-direct" "$FETCH" "$URL" "$OUT" 2>/dev/null)"; rc=$?
[ "$rc" = 0 ] && ok "exit 0" || bad "exit $rc"
[ "$(printf '%s' "$MAN" | field source_fetched_via)" = direct ] && ok "via=direct" || bad "via not direct"
got="$(printf '%s' "$MAN" | field source_content_sha256)"
[ "$got" = "$(sha_of hello-direct)" ] && ok "sha matches direct body" || bad "sha mismatch ($got)"
[ "$(cat "$OUT")" = "hello-direct" ] && ok "bytes written to output path" || bad "output body wrong"
grep -q "web.archive.org" "$STUB_LOG" && bad "archive was contacted on a direct success" || ok "archive NOT contacted"

# === 2. direct fails -> wayback id_ fallback succeeds ========================
hr; echo "CASE 2: connection refused -> wayback original-bytes fallback"
: >"$STUB_LOG"
OUT="$TR/case2.out"
AVAIL='{"archived_snapshots":{"closest":{"available":true,"url":"http://web.archive.org/web/20180101000000/'"$URL"'","timestamp":"20180101000000","status":"200"}}}'
MAN="$(STUB_DIRECT_RC=7 STUB_AVAIL_RC=0 STUB_AVAIL_JSON="$AVAIL" \
       STUB_ARCHIVE_RC=0 STUB_ARCHIVE_BODY="archived-bytes" "$FETCH" "$URL" "$OUT" 2>/dev/null)"; rc=$?
[ "$rc" = 0 ] && ok "exit 0" || bad "exit $rc"
[ "$(printf '%s' "$MAN" | field source_fetched_via)" = wayback ] && ok "via=wayback" || bad "via not wayback"
eff="$(printf '%s' "$MAN" | field source_effective_url)"
case "$eff" in
  *"20180101000000id_/$URL") ok "effective URL uses the id_ original-bytes form" ;;
  *) bad "effective URL not the id_ form: $eff" ;;
esac
[ "$(printf '%s' "$MAN" | field source_wayback_timestamp)" = 20180101000000 ] && ok "timestamp recorded" || bad "timestamp missing"
got="$(printf '%s' "$MAN" | field source_content_sha256)"
[ "$got" = "$(sha_of archived-bytes)" ] && ok "sha matches archived body" || bad "sha mismatch ($got)"
[ "$(cat "$OUT")" = "archived-bytes" ] && ok "archived bytes written" || bad "output body wrong"

# === 3. direct fails, no capture timestamp -> redirect form =================
hr; echo "CASE 3: no availability timestamp -> bare redirect id_ form"
: >"$STUB_LOG"
OUT="$TR/case3.out"
MAN="$(STUB_DIRECT_RC=7 STUB_AVAIL_RC=0 STUB_AVAIL_JSON='{"archived_snapshots":{}}' \
       STUB_ARCHIVE_RC=0 STUB_ARCHIVE_BODY="redirect-bytes" "$FETCH" "$URL" "$OUT" 2>/dev/null)"; rc=$?
[ "$rc" = 0 ] && ok "exit 0" || bad "exit $rc"
eff="$(printf '%s' "$MAN" | field source_effective_url)"
case "$eff" in
  "http://web.archive.org/web/2id_/$URL") ok "fell back to the bare 2id_ redirect form" ;;
  *) bad "unexpected effective URL: $eff" ;;
esac

# === 4. direct fails AND archive fails -> exit 1 ============================
hr; echo "CASE 4: both direct and archive fail"
: >"$STUB_LOG"
OUT="$TR/case4.out"
set +e
STUB_DIRECT_RC=7 STUB_AVAIL_RC=0 STUB_AVAIL_JSON='{"archived_snapshots":{}}' \
  STUB_ARCHIVE_RC=7 "$FETCH" "$URL" "$OUT" >/dev/null 2>&1; rc=$?
set -e
[ "$rc" = 1 ] && ok "exit 1 when no bytes obtainable" || bad "exit $rc (expected 1)"
[ -e "$OUT" ] && bad "empty output left behind" || ok "no output file left behind"

# === 5. usage =================================================================
hr; echo "CASE 5: usage"
set +e
"$FETCH" -h >/dev/null 2>&1; rc=$?; [ "$rc" = 0 ] && ok "-h exits 0" || bad "-h exit $rc"
"$FETCH"    >/dev/null 2>&1; rc=$?; [ "$rc" = 2 ] && ok "no-arg exits 2" || bad "no-arg exit $rc"
set -e

# === 6. default output path (no out arg) =====================================
hr; echo "CASE 6: default temp output path"
: >"$STUB_LOG"
MAN="$(STUB_DIRECT_RC=0 STUB_DIRECT_BODY="tmp-body" "$FETCH" "$URL" 2>/dev/null)"
p="$(printf '%s' "$MAN" | field source_output_path)"
[ -n "$p" ] && [ "$(cat "$p")" = "tmp-body" ] && ok "default temp file holds the bytes" || bad "default output path wrong ($p)"
rm -f "$p"

hr
echo "fetch-source-test: $PASS passed, $FAIL failed"
rm -rf "$TR"
[ "$FAIL" -eq 0 ]
