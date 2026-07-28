#!/bin/bash
# check-source-children-test.sh — coverage for the deterministic hub-child
# reachability probe (check-source-children.sh).
#
# check-source-children.sh fetches a hub/nav page through fetch-source.sh,
# extracts its child hrefs, probes each one through the same fetch-source.sh
# logic, and emits a one-line-per-child reachable/dead manifest so a scholar
# plans sections from a scripted list instead of hand-probing each link. This
# test pins href extraction + relative-URL resolution, same-host filtering, the
# reachable/dead classification, the www/no-www retry before `dead`, and the
# failure modes.
#
# Hermetic: CHECK_SOURCE_FETCH points at a stub standing in for fetch-source.sh.
# The stub serves the hub HTML fixture and a per-URL reachable/dead map driven
# by env. No real network is touched.
#
# Usage: check-source-children-test.sh
set -uo pipefail
# Explicit positive test-context sentinel: protects this standalone suite even when
# invoked outside the test-tree entrypoint heuristic.
export GARDEN_TEST=1
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
JOBS="$(cd "$HERE/.." && pwd)"
CHECK="$JOBS/check-source-children.sh"
PASS=0; FAIL=0
ok()  { echo "  PASS: $*"; PASS=$((PASS+1)); }
bad() { echo "  FAIL: $*"; FAIL=$((FAIL+1)); }
hr()  { echo "----------------------------------------------------------------"; }

# Scrub ambient fleet env so a live gardener invoking this test cannot splice its
# own GARDEN_*/JOURNAL_* state underneath the fixture (mirrors fetch-source-test).
unset $(compgen -v 2>/dev/null | grep -E '^(GARDEN_|JOURNAL_|SELF_HEAL_|XDG_)' || true) 2>/dev/null || true

TR=/home/kris/.garden-check-source-children-test
rm -rf "$TR"; mkdir -p "$TR"

# --- the fetch-source.sh stub ----------------------------------------------
# Mimics fetch-source.sh's contract: `stub <url> <out>` writes bytes to <out>
# and prints a manifest with `source_fetched_via=...`; exit 0 on success, 1 on
# "no bytes". Behaviour per URL is table-driven:
#   STUB_HUB_URL / STUB_HUB_FILE  the hub URL and the file whose bytes it serves
#   STUB_REACHABLE                newline list of "<url> <via>" rows that succeed
# Any URL not the hub and not listed in STUB_REACHABLE exits 1 (dead). Every
# requested URL is appended to $STUB_LOG for assertions.
STUB="$TR/fetch-stub.sh"
cat >"$STUB" <<'STUB_EOF'
#!/bin/bash
url="$1"; out="$2"
printf '%s\n' "$url" >>"$STUB_LOG"
if [ "$url" = "$STUB_HUB_URL" ]; then
  cat "$STUB_HUB_FILE" >"$out"
  printf 'source_fetched_via=mirror\nsource_content_sha256=deadbeef\n'
  exit 0
fi
# Look the URL up in the reachable table.
while IFS=' ' read -r ru rv; do
  [ -z "$ru" ] && continue
  if [ "$ru" = "$url" ]; then
    printf 'served' >"$out"
    printf 'source_fetched_via=%s\n' "$rv"
    exit 0
  fi
done <<< "${STUB_REACHABLE:-}"
: >"$out"
exit 1
STUB_EOF
chmod +x "$STUB"

export CHECK_SOURCE_FETCH="$STUB"
export STUB_LOG="$TR/urls.log"

# --- the hub HTML fixture ---------------------------------------------------
# A nav map with: a relative dir link, a relative file link, a ../ parent link,
# a host-absolute link, a fragment-only link (skipped), a mailto: (skipped), an
# off-site link (different host -> filtered), and a dead child.
HUB_URL="https://erights.org/elang/index.html"
HUB_FILE="$TR/hub.html"
cat >"$HUB_FILE" <<'HTML_EOF'
<html><body>
<a href="kernel/index.html">Kernel</a>
<a href='guarding/index.html'>Guarding</a>
<a href=guarding/style.html>Style (dead)</a>
<a href="../data/index.html">Data</a>
<a href="/intro.html">Intro</a>
<a href="kernel/index.html#section">Kernel anchor (dedup)</a>
<a href="#top">Top of page</a>
<a href="mailto:mark@erights.org">Mail</a>
<a href="https://example.com/external.html">External</a>
</body></html>
HTML_EOF

export STUB_HUB_URL="$HUB_URL"
export STUB_HUB_FILE="$HUB_FILE"

field_lines() { grep -c "child_status=$1" || true; }

# === 1. full run: classification, resolution, filtering, dedup ==============
hr; echo "CASE 1: classify children, resolve relatives, filter off-host, dedup"
: >"$STUB_LOG"
# Everything reachable EXCEPT guarding/style.html (the never-written dead link).
export STUB_REACHABLE="https://erights.org/elang/kernel/index.html mirror
https://erights.org/elang/guarding/index.html wayback
https://erights.org/data/index.html mirror
https://erights.org/intro.html direct"
MAN="$("$CHECK" "$HUB_URL" 2>/dev/null)"; rc=$?
[ "$rc" = 0 ] && ok "exit 0" || bad "exit $rc"

echo "$MAN" | grep -q "child_url=https://erights.org/elang/kernel/index.html child_status=reachable child_via=mirror" \
  && ok "relative dir link resolved + reachable(mirror)" || bad "kernel row wrong"
echo "$MAN" | grep -q "child_url=https://erights.org/elang/guarding/index.html child_status=reachable child_via=wayback" \
  && ok "single-quoted href resolved + reachable(wayback)" || bad "guarding row wrong"
echo "$MAN" | grep -q "child_url=https://erights.org/data/index.html child_status=reachable child_via=mirror" \
  && ok "../ parent link normalized + reachable" || bad "data row wrong"
echo "$MAN" | grep -q "child_url=https://erights.org/intro.html child_status=reachable child_via=direct" \
  && ok "host-absolute /intro.html resolved + reachable" || bad "intro row wrong"
echo "$MAN" | grep -q "child_url=https://erights.org/elang/guarding/style.html child_status=dead child_via=-" \
  && ok "unquoted dead link classified dead" || bad "style.html not dead"

# off-host + fragment-only + mailto must NOT appear
echo "$MAN" | grep -q "example.com" && bad "off-host link leaked into manifest" || ok "off-host link filtered"
echo "$MAN" | grep -q "mailto" && bad "mailto leaked into manifest" || ok "mailto filtered"
echo "$MAN" | grep -q "#top\|#section" && bad "fragment leaked into manifest" || ok "fragments stripped"

# dedup: kernel/index.html appears twice (plain + #section) -> one manifest row
n="$(echo "$MAN" | grep -c "child_url=https://erights.org/elang/kernel/index.html ")"
[ "$n" = 1 ] && ok "duplicate href deduped to one row" || bad "kernel appears $n times"

reach="$(echo "$MAN" | field_lines reachable)"
deadn="$(echo "$MAN" | field_lines dead)"
[ "$reach" = 4 ] && ok "4 reachable rows" || bad "reachable=$reach (expected 4)"
[ "$deadn" = 1 ] && ok "1 dead row" || bad "dead=$deadn (expected 1)"

# === 2. www / no-www retry before declaring dead ============================
hr; echo "CASE 2: dead under the given host but reachable under the www form"
: >"$STUB_LOG"
# style.html is dead at erights.org but a capture exists under www.erights.org;
# the probe must toggle and find it rather than report dead.
export STUB_REACHABLE="https://erights.org/elang/kernel/index.html mirror
https://erights.org/elang/guarding/index.html mirror
https://erights.org/data/index.html mirror
https://erights.org/intro.html mirror
https://www.erights.org/elang/guarding/style.html wayback"
MAN="$("$CHECK" "$HUB_URL" 2>/dev/null)"; rc=$?
[ "$rc" = 0 ] && ok "exit 0" || bad "exit $rc"
echo "$MAN" | grep -q "child_url=https://erights.org/elang/guarding/style.html child_status=reachable child_via=wayback" \
  && ok "www-form retry rescued the otherwise-dead child" || bad "www retry did not rescue"
grep -q "https://www.erights.org/elang/guarding/style.html" "$STUB_LOG" \
  && ok "the www-toggled URL was actually probed" || bad "www form never probed"
deadn="$(echo "$MAN" | field_lines dead)"
[ "$deadn" = 0 ] && ok "no dead rows once the www form resolves" || bad "dead=$deadn (expected 0)"

# === 3. hub itself unreachable -> exit 1 ====================================
hr; echo "CASE 3: hub page unreachable"
: >"$STUB_LOG"
export STUB_REACHABLE=""
set +e
"$CHECK" "https://erights.org/nonexistent/hub.html" >/dev/null 2>&1; rc=$?
set -e
[ "$rc" = 1 ] && ok "exit 1 when the hub cannot be fetched" || bad "exit $rc (expected 1)"

# === 4. usage ===============================================================
hr; echo "CASE 4: usage"
set +e
"$CHECK" -h >/dev/null 2>&1; rc=$?; [ "$rc" = 0 ] && ok "-h exits 0" || bad "-h exit $rc"
"$CHECK"    >/dev/null 2>&1; rc=$?; [ "$rc" = 2 ] && ok "no-arg exits 2" || bad "no-arg exit $rc"
set -e

# === 5. mirror-URL hub form (erights.github.io children, same-host) =========
hr; echo "CASE 5: mirror-URL hub keeps same-host children"
: >"$STUB_LOG"
MHUB="https://erights.github.io/erights-org-website/elang/index.html"
MHUB_FILE="$TR/mhub.html"
cat >"$MHUB_FILE" <<'HTML_EOF'
<html><body>
<a href="kernel/index.html">Kernel</a>
<a href="https://erights.org/elsewhere.html">canonical off-host</a>
</body></html>
HTML_EOF
export STUB_HUB_URL="$MHUB"; export STUB_HUB_FILE="$MHUB_FILE"
export STUB_REACHABLE="https://erights.github.io/erights-org-website/elang/kernel/index.html direct"
MAN="$("$CHECK" "$MHUB" 2>/dev/null)"; rc=$?
[ "$rc" = 0 ] && ok "exit 0" || bad "exit $rc"
echo "$MAN" | grep -q "child_url=https://erights.github.io/erights-org-website/elang/kernel/index.html child_status=reachable child_via=direct" \
  && ok "mirror-host child resolved + reachable" || bad "mirror child row wrong"
echo "$MAN" | grep -q "erights.org/elsewhere" && bad "canonical-host link leaked (wrong host)" || ok "different-host link filtered"

hr
echo "check-source-children-test: $PASS passed, $FAIL failed"
rm -rf "$TR"
[ "$FAIL" -eq 0 ]
