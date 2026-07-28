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
# Explicit positive test-context sentinel: protects this standalone suite even when
# invoked outside the test-tree entrypoint heuristic.
export GARDEN_TEST=1
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
#   STUB_MIRROR_RC      erights GitHub Pages mirror exit code (0 -> writes body)
#   STUB_MIRROR_BODY    body written on a successful mirror fetch
#   STUB_DIRECT_FILE    if set, a successful direct fetch copies this file to the
#                       output instead of writing STUB_DIRECT_BODY (for binary
#                       bodies like a real PDF that an env var would not survive)
#   STUB_DIRECT_CE      if set, a successful direct fetch dumps a response-header
#                       file (-D) carrying `Content-Encoding: <value>` — drives
#                       the gzip-decode path. STUB_ARCHIVE_CE / STUB_MIRROR_CE do
#                       the same for the archive / mirror fetches.
# It also records each requested URL to $STUB_LOG for assertions.
STUB="$TR/curl-stub.sh"
cat >"$STUB" <<'STUB_EOF'
#!/bin/bash
# Parse out `-o <path>`, `-D <hdrs>` and the trailing URL from a curl-shaped
# arg list.
out=""; url=""; hdrs=""
while [ $# -gt 0 ]; do
  case "$1" in
    -o) out="$2"; shift 2;;
    -D) hdrs="$2"; shift 2;;
    --connect-timeout|--max-time) shift 2;;
    -*) shift;;            # other flags (-fsSL etc.)
    *)  url="$1"; shift;;  # last non-flag wins = the URL
  esac
done
printf '%s\n' "$url" >>"$STUB_LOG"
# Write a minimal response-header dump (like curl -D) when a Content-Encoding is
# requested for this fetch path, so the script's header inspection has input.
emit_hdrs() {  # $1 = Content-Encoding value (empty -> no header file written)
  [ -n "$hdrs" ] && [ -n "$1" ] || return 0
  printf 'HTTP/1.1 200 OK\r\nContent-Encoding: %s\r\n\r\n' "$1" >"$hdrs"
}
case "$url" in
  *"/wayback/available"*)
    printf '%s' "${STUB_AVAIL_JSON:-}"; exit "${STUB_AVAIL_RC:-0}" ;;
  *"web.archive.org"*)
    if [ "${STUB_ARCHIVE_RC:-0}" = 0 ]; then
      printf '%s' "${STUB_ARCHIVE_BODY:-}" >"$out"; emit_hdrs "${STUB_ARCHIVE_CE:-}"
    fi
    exit "${STUB_ARCHIVE_RC:-0}" ;;
  *"erights.github.io"*)
    if [ "${STUB_MIRROR_RC:-0}" = 0 ]; then
      printf '%s' "${STUB_MIRROR_BODY:-}" >"$out"; emit_hdrs "${STUB_MIRROR_CE:-}"
    fi
    exit "${STUB_MIRROR_RC:-0}" ;;
  *)
    if [ "${STUB_DIRECT_RC:-0}" = 0 ]; then
      if [ -n "${STUB_DIRECT_FILE:-}" ]; then cp "$STUB_DIRECT_FILE" "$out"
      else printf '%s' "${STUB_DIRECT_BODY:-}" >"$out"; fi
      emit_hdrs "${STUB_DIRECT_CE:-}"
    fi
    exit "${STUB_DIRECT_RC:-0}" ;;
esac
STUB_EOF
chmod +x "$STUB"

export FETCH_SOURCE_CURL="$STUB"
export STUB_LOG="$TR/urls.log"

# A real, minimal, single-page PDF carrying the known text "Hello PDF body", so
# the PDF-text-extraction path can be exercised end to end against pypdf (the
# magic bytes alone would not parse). Pure-ASCII PDF structure, no binary stream.
SAMPLE_PDF="$TR/sample.pdf"
python3 - "$SAMPLE_PDF" <<'MKPDF'
import sys
objs = [
    b"<< /Type /Catalog /Pages 2 0 R >>",
    b"<< /Type /Pages /Kids [3 0 R] /Count 1 >>",
    b"<< /Type /Page /Parent 2 0 R /MediaBox [0 0 612 792] /Contents 4 0 R /Resources << /Font << /F1 5 0 R >> >> >>",
]
stream = b"BT /F1 24 Tf 72 700 Td (Hello PDF body) Tj ET"
objs.append(b"<< /Length %d >>\nstream\n%s\nendstream" % (len(stream), stream))
objs.append(b"<< /Type /Font /Subtype /Type1 /BaseFont /Helvetica >>")
out = b"%PDF-1.4\n"
offsets = []
for i, o in enumerate(objs, 1):
    offsets.append(len(out))
    out += b"%d 0 obj\n%s\nendobj\n" % (i, o)
xref = len(out)
out += b"xref\n0 %d\n0000000000 65535 f \n" % (len(objs) + 1)
for off in offsets:
    out += b"%010d 00000 n \n" % off
out += b"trailer\n<< /Size %d /Root 1 0 R >>\nstartxref\n%d\n%%%%EOF\n" % (len(objs) + 1, xref)
open(sys.argv[1], "wb").write(out)
MKPDF

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

# === 7. erights.org HTML page: direct fails -> GitHub Pages mirror 200 =======
# The mirror carries the HTML site and preserves the path, so the rewrite is
# `https://erights.org/<path>` -> `https://erights.github.io/erights-org-website/<path>`,
# and the archive is NOT consulted when the mirror serves the bytes.
hr; echo "CASE 7: erights.org HTML -> mirror 200 (archive untouched)"
: >"$STUB_LOG"
EURL="https://erights.org/elang/index.html"
OUT="$TR/case7.out"
MAN="$(STUB_DIRECT_RC=7 STUB_MIRROR_RC=0 STUB_MIRROR_BODY="mirror-html" \
       "$FETCH" "$EURL" "$OUT" 2>/dev/null)"; rc=$?
[ "$rc" = 0 ] && ok "exit 0" || bad "exit $rc"
[ "$(printf '%s' "$MAN" | field source_fetched_via)" = mirror ] && ok "via=mirror" || bad "via not mirror"
eff="$(printf '%s' "$MAN" | field source_effective_url)"
[ "$eff" = "https://erights.github.io/erights-org-website/elang/index.html" ] \
  && ok "path-preserving mirror rewrite" || bad "wrong mirror URL: $eff"
got="$(printf '%s' "$MAN" | field source_content_sha256)"
[ "$got" = "$(sha_of mirror-html)" ] && ok "sha matches mirror body" || bad "sha mismatch ($got)"
[ "$(cat "$OUT")" = "mirror-html" ] && ok "mirror bytes written" || bad "output body wrong"
grep -q "web.archive.org" "$STUB_LOG" && bad "archive contacted despite mirror 200" || ok "archive NOT contacted"

# === 8. erights.org PDF: direct fails, mirror 404 -> archive fallback ========
# The mirror does NOT carry PDFs / talk files (404), so a non-zero mirror fetch
# must drop through to the Internet-Archive original-bytes capture.
hr; echo "CASE 8: erights.org PDF -> mirror 404 -> archive fallback"
: >"$STUB_LOG"
PURL="https://erights.org/talks/asian03/paradigm.pdf"
OUT="$TR/case8.out"
AVAIL='{"archived_snapshots":{"closest":{"available":true,"url":"x","timestamp":"20180101000000","status":"200"}}}'
MAN="$(STUB_DIRECT_RC=7 STUB_MIRROR_RC=22 \
       STUB_AVAIL_RC=0 STUB_AVAIL_JSON="$AVAIL" \
       STUB_ARCHIVE_RC=0 STUB_ARCHIVE_BODY="archived-pdf" \
       "$FETCH" "$PURL" "$OUT" 2>/dev/null)"; rc=$?
[ "$rc" = 0 ] && ok "exit 0" || bad "exit $rc"
grep -q "erights.github.io" "$STUB_LOG" && ok "mirror was attempted first" || bad "mirror not attempted"
[ "$(printf '%s' "$MAN" | field source_fetched_via)" = wayback ] && ok "via=wayback after mirror 404" || bad "via not wayback"
[ "$(cat "$OUT")" = "archived-pdf" ] && ok "archived bytes written" || bad "output body wrong"

# === 9. non-erights URL: mirror is NOT attempted ============================
# The mirror rewrite is gated on the erights.org / caplet.com host; any other
# host must skip the mirror entirely and go straight to the archive.
hr; echo "CASE 9: non-erights URL skips the mirror"
: >"$STUB_LOG"
NURL="https://example.com/whatever.html"
OUT="$TR/case9.out"
STUB_DIRECT_RC=7 STUB_AVAIL_RC=0 STUB_AVAIL_JSON='{"archived_snapshots":{}}' \
  STUB_ARCHIVE_RC=0 STUB_ARCHIVE_BODY="arc" "$FETCH" "$NURL" "$OUT" >/dev/null 2>&1; rc=$?
[ "$rc" = 0 ] && ok "exit 0" || bad "exit $rc"
grep -q "erights.github.io" "$STUB_LOG" && bad "mirror attempted for non-erights URL" || ok "mirror NOT attempted"

# === 10. HTML stub page (placeholder marker) -> stub_suspect=true ===========
# The recurring trap: the erights mirror serves "***to be written, but see…" at
# HTTP 200. A reachable 200 must be flagged as a stub-suspect so the page is not
# counted as a usable source, WITHOUT changing the exit code.
hr; echo "CASE 10: HTML placeholder marker -> stub_suspect=true (exit still 0)"
: >"$STUB_LOG"
SURL="https://erights.org/elang/intro/object-lambda.html"
OUT="$TR/case10.out"
STUB_BODY='<html><head><title>Object as Lambda</title></head><body><h1>Object as Lambda</h1><p>***to be written, but see the related pages for now. This placeholder is long enough to clear the small-body threshold so the marker, not the size, is what flags it as a stub-suspect for the scholar consumer.</p></body></html>'
MAN="$(STUB_DIRECT_RC=7 STUB_MIRROR_RC=0 STUB_MIRROR_BODY="$STUB_BODY" \
       "$FETCH" "$SURL" "$OUT" 2>/dev/null)"; rc=$?
[ "$rc" = 0 ] && ok "exit 0 (advisory, not fatal)" || bad "exit $rc"
[ "$(printf '%s' "$MAN" | field source_stub_suspect)" = true ] && ok "stub_suspect=true" || bad "stub_suspect not true"
printf '%s' "$MAN" | grep -q '^source_stub_reason=' && ok "stub_reason emitted" || bad "stub_reason missing"

# === 11. tiny HTML body (under threshold) -> stub_suspect=true ===============
hr; echo "CASE 11: tiny HTML body under byte threshold -> stub_suspect=true"
: >"$STUB_LOG"
TURL="https://erights.org/elang/empty.html"
OUT="$TR/case11.out"
MAN="$(STUB_DIRECT_RC=7 STUB_MIRROR_RC=0 STUB_MIRROR_BODY="<html><body></body></html>" \
       "$FETCH" "$TURL" "$OUT" 2>/dev/null)"; rc=$?
[ "$rc" = 0 ] && ok "exit 0" || bad "exit $rc"
[ "$(printf '%s' "$MAN" | field source_stub_suspect)" = true ] && ok "stub_suspect=true (tiny body)" || bad "stub_suspect not true"

# === 12. full HTML page -> stub_suspect=false ===============================
# A real article must NOT be flagged: large enough body, no placeholder markers.
hr; echo "CASE 12: substantial HTML article -> stub_suspect=false"
: >"$STUB_LOG"
FURL="https://erights.org/elang/real-article.html"
OUT="$TR/case12.out"
BODY="<html><head><title>Real</title></head><body><h1>A Real Article</h1>"
for i in $(seq 1 40); do BODY="$BODY<p>Substantive paragraph number $i with enough prose to look like a genuine page of content rather than a placeholder.</p>"; done
BODY="$BODY</body></html>"
MAN="$(STUB_DIRECT_RC=7 STUB_MIRROR_RC=0 STUB_MIRROR_BODY="$BODY" \
       "$FETCH" "$FURL" "$OUT" 2>/dev/null)"; rc=$?
[ "$rc" = 0 ] && ok "exit 0" || bad "exit $rc"
[ "$(printf '%s' "$MAN" | field source_stub_suspect)" = false ] && ok "stub_suspect=false (real article)" || bad "real article wrongly flagged"
printf '%s' "$MAN" | grep -q '^source_stub_reason=' && bad "stub_reason emitted when not a stub" || ok "no stub_reason on a clean page"

# === 13. short PDF (non-HTML) -> NOT flagged, NOT blocked ====================
# A legitimately short, non-HTML source (a PDF) must never be flagged or blocked
# by the HTML-only advisory: byte size alone is not a stub signal off HTML.
hr; echo "CASE 13: short PDF is not HTML -> stub_suspect=false (never blocked)"
: >"$STUB_LOG"
PDFURL="https://erights.org/talks/tiny.pdf"
OUT="$TR/case13.out"
AVAIL='{"archived_snapshots":{"closest":{"available":true,"url":"x","timestamp":"20180101000000","status":"200"}}}'
MAN="$(STUB_DIRECT_RC=7 STUB_MIRROR_RC=22 STUB_AVAIL_RC=0 STUB_AVAIL_JSON="$AVAIL" \
       STUB_ARCHIVE_RC=0 STUB_ARCHIVE_BODY="%PDF-1.4 tiny" \
       "$FETCH" "$PDFURL" "$OUT" 2>/dev/null)"; rc=$?
[ "$rc" = 0 ] && ok "exit 0 (short PDF not blocked)" || bad "exit $rc"
[ "$(printf '%s' "$MAN" | field source_stub_suspect)" = false ] && ok "stub_suspect=false (PDF, not HTML)" || bad "short PDF wrongly flagged"

# === 14. near-empty <body> (above threshold) -> stub_suspect=true ===========
# A page large enough to clear the byte threshold (e.g. a big <head>) but whose
# <body> is whitespace-only is still a stub.
hr; echo "CASE 14: padded head + empty <body> -> stub_suspect=true"
: >"$STUB_LOG"
NURL2="https://erights.org/elang/padded-empty.html"
OUT="$TR/case14.out"
HEAD="<html><head><title>Padded</title>"
for i in $(seq 1 20); do HEAD="$HEAD<meta name=\"k$i\" content=\"padding to clear the small-body byte threshold so the empty-body check is what fires here\">"; done
NBODY="$HEAD</head><body>

</body></html>"
MAN="$(STUB_DIRECT_RC=7 STUB_MIRROR_RC=0 STUB_MIRROR_BODY="$NBODY" \
       "$FETCH" "$NURL2" "$OUT" 2>/dev/null)"; rc=$?
[ "$rc" = 0 ] && ok "exit 0" || bad "exit $rc"
[ "$(printf '%s' "$MAN" | field source_stub_suspect)" = true ] && ok "stub_suspect=true (empty body)" || bad "near-empty body not flagged"

# === 15. real PDF -> deterministic pypdf text extraction =====================
# The point of the PDF path: a detected PDF (here by the %PDF magic) gets an
# adjacent extracted-text artifact via pypdf, so a scholar no longer hand-runs
# pypdf to ingest a paper. The raw PDF bytes are kept alongside the text.
hr; echo "CASE 15: real PDF direct fetch -> adjacent extracted text"
: >"$STUB_LOG"
OUT="$TR/case15.pdf"
MAN="$(STUB_DIRECT_RC=0 STUB_DIRECT_FILE="$SAMPLE_PDF" "$FETCH" "$URL" "$OUT" 2>/dev/null)"; rc=$?
[ "$rc" = 0 ] && ok "exit 0" || bad "exit $rc"
[ "$(printf '%s' "$MAN" | field source_is_pdf)" = true ] && ok "source_is_pdf=true" || bad "PDF not detected"
TP="$(printf '%s' "$MAN" | field source_text_path)"
[ -n "$TP" ] && ok "source_text_path emitted ($TP)" || bad "source_text_path missing"
# Adjacent and the trailing .pdf is replaced with .txt, not appended.
[ "$TP" = "${OUT%.pdf}.txt" ] && ok "text path adjacent (.pdf -> .txt)" || bad "unexpected text path: $TP"
[ -f "$TP" ] && grep -q "Hello PDF body" "$TP" && ok "extracted text contains the page text" || bad "extracted text wrong/missing"
[ "$(head -c 4 "$OUT")" = "%PDF" ] && ok "raw PDF bytes kept at the output path" || bad "raw PDF bytes lost"
[ -n "$(printf '%s' "$MAN" | field source_text_bytes)" ] && ok "source_text_bytes emitted" || bad "source_text_bytes missing"

# === 16. non-PDF body -> no PDF fields =======================================
# A non-PDF source must not gain source_is_pdf / source_text_path.
hr; echo "CASE 16: non-PDF body emits no PDF fields"
: >"$STUB_LOG"
OUT="$TR/case16.out"
MAN="$(STUB_DIRECT_RC=0 STUB_DIRECT_BODY="just some plain text, not a pdf" "$FETCH" "$URL" "$OUT" 2>/dev/null)"; rc=$?
[ "$rc" = 0 ] && ok "exit 0" || bad "exit $rc"
printf '%s' "$MAN" | grep -q '^source_is_pdf=' && bad "source_is_pdf emitted for non-PDF" || ok "no source_is_pdf for non-PDF"
printf '%s' "$MAN" | grep -q '^source_text_path=' && bad "source_text_path emitted for non-PDF" || ok "no source_text_path for non-PDF"

# === 17. gzip Content-Encoding -> decoded in place before hashing ============
# The live failure mode (OpenAI Symphony ingest: openai.com 403 -> wayback id_
# fallback replaying stored `Content-Encoding: gzip`): the saved file is
# gzip-compressed. The script must decode it in place BEFORE hashing, so the
# stored bytes are the readable content and source_content_sha256 is the anchor
# over the DECODED form (transfer-encoding-invariant), with via unchanged.
hr; echo "CASE 17: Content-Encoding: gzip -> decoded before hashing"
: >"$STUB_LOG"
PLAIN="hello gzip decoded body — the readable content a scholar ingests"
GZ="$TR/sample.gz"
printf '%s' "$PLAIN" | gzip -c >"$GZ"
OUT="$TR/case17.out"
MAN="$(STUB_DIRECT_RC=0 STUB_DIRECT_FILE="$GZ" STUB_DIRECT_CE=gzip \
       "$FETCH" "$URL" "$OUT" 2>/dev/null)"; rc=$?
[ "$rc" = 0 ] && ok "exit 0" || bad "exit $rc"
[ "$(printf '%s' "$MAN" | field source_fetched_via)" = direct ] && ok "via=direct (unchanged)" || bad "via changed"
[ "$(cat "$OUT")" = "$PLAIN" ] && ok "output decoded in place" || bad "output not decoded"
got="$(printf '%s' "$MAN" | field source_content_sha256)"
[ "$got" = "$(sha_of "$PLAIN")" ] && ok "sha anchored over decoded bytes" || bad "sha over compressed bytes ($got)"
plain_bytes="$(printf '%s' "$PLAIN" | wc -c | tr -d ' ')"
[ "$(printf '%s' "$MAN" | field source_bytes)" = "$plain_bytes" ] && ok "bytes count decoded length" || bad "bytes not decoded length"

# === 18. gzip advertised but bytes are NOT gzip -> left untouched ============
# The decode is guarded by `gzip -t`: a mislabelled response (header says gzip,
# body is plain) must be hashed as-is, never mangled by a failed decode.
hr; echo "CASE 18: Content-Encoding: gzip but body not gzip -> untouched"
: >"$STUB_LOG"
BODY="this claims to be gzip but is plain text"
OUT="$TR/case18.out"
MAN="$(STUB_DIRECT_RC=0 STUB_DIRECT_BODY="$BODY" STUB_DIRECT_CE=gzip \
       "$FETCH" "$URL" "$OUT" 2>/dev/null)"; rc=$?
[ "$rc" = 0 ] && ok "exit 0" || bad "exit $rc"
[ "$(cat "$OUT")" = "$BODY" ] && ok "mislabelled body left untouched" || bad "body was mangled"
got="$(printf '%s' "$MAN" | field source_content_sha256)"
[ "$got" = "$(sha_of "$BODY")" ] && ok "sha over the raw (unchanged) bytes" || bad "sha mismatch ($got)"

# === 19. identity encoding (no Content-Encoding header) -> untouched =========
# An ordinary response with no Content-Encoding must never be gzip-touched, even
# if a header file was dumped for Content-Type detection.
hr; echo "CASE 19: no Content-Encoding header -> untouched"
: >"$STUB_LOG"
BODY19="plain identity-encoded content"
OUT="$TR/case19.out"
MAN="$(STUB_DIRECT_RC=0 STUB_DIRECT_BODY="$BODY19" "$FETCH" "$URL" "$OUT" 2>/dev/null)"; rc=$?
[ "$rc" = 0 ] && ok "exit 0" || bad "exit $rc"
[ "$(cat "$OUT")" = "$BODY19" ] && ok "identity body untouched" || bad "identity body changed"
[ "$(printf '%s' "$MAN" | field source_content_sha256)" = "$(sha_of "$BODY19")" ] && ok "sha over raw bytes" || bad "sha mismatch"

hr
echo "fetch-source-test: $PASS passed, $FAIL failed"
rm -rf "$TR"
[ "$FAIL" -eq 0 ]
