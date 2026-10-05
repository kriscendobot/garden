#!/bin/bash
# ci-pr-source-cache-test.sh - guard the shared open-PR snapshot cache in
# handlers/ci-pr-source-gh.sh.
#
# The ci- and dependabot-watchers enumerated the same complete REST PR list
# independently and both hit primary-quota exhaustion (2026-10-05T03:54:21Z). The
# handler now single-flights the enumeration per repository and reuses a short-lived
# snapshot. This test pins: concurrent consumers issue one walk; a failed, refused,
# or malformed enumeration never populates the cache; a tampered or expired snapshot
# is a miss; the cache is per repository and lives below GARDEN_ROOT.

set -euo pipefail
export GARDEN_TEST=1
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
JOBS="$(cd "$HERE/.." && pwd)"
SRC="$JOBS/handlers/ci-pr-source-gh.sh"
PASS=0; FAIL=0
ok()  { echo "  PASS: $*"; PASS=$((PASS + 1)); }
bad() { echo "  FAIL: $*"; FAIL=$((FAIL + 1)); }

unset GARDEN_API_COOLDOWN_DIR GARDEN_API_COOLDOWN_MARKER GARDEN_API_COOLDOWN_LOCK \
  GARDEN_CI_PR_SOURCE_CACHE_DIR GARDEN_CI_PR_SOURCE_CACHE_SECS GARDEN_GH
TR="$(mktemp -d "${TMPDIR:-/tmp}/ci-pr-source-cache.XXXXXX")"
trap 'rm -rf "$TR"' EXIT
ROOT="$TR/root"; mkdir -p "$ROOT" "$TR/bin"
CACHE="$ROOT/.garden-state/ci-pr-source-cache"
COUNT="$TR/count"; MODE="$TR/mode"

# gh stub: counts calls, sleeps briefly so concurrent consumers overlap, and emits
# according to $MODE: ok (two pages), fail (rc 1), quota (primary-quota refusal),
# empty (rc 0, no pages), object (rc 0, a non-array page).
cat > "$TR/bin/gh" <<STUB
#!/bin/bash
[ "\$1" = api ] || exit 0
( flock 9; n=\$(( \$(cat "$COUNT" 2>/dev/null || echo 0) + 1 )); echo "\$n" > "$COUNT" ) 9>"$COUNT.lock"
sleep 0.3
case "\$(cat "$MODE")" in
  ok) printf '%s' '[{"number":1,"user":{"login":"kriscendobot"},"head":{"repo":{"full_name":"a/b"}},"updated_at":"t1","title":"one"}]'
      printf '%s' '[{"number":2,"user":{"login":"dependabot[bot]"},"head":{"repo":{"full_name":"a/b"}},"updated_at":"t2","title":"Bump x from 1 to 2"}]' ;;
  fail) echo "gh: Not Found (HTTP 404)" >&2; exit 1 ;;
  quota) echo "gh: API rate limit exceeded for user ID 1. (HTTP 403)" >&2; exit 1 ;;
  empty) : ;;
  object) printf '%s' '{"message":"oops"}' ;;
esac
STUB
chmod +x "$TR/bin/gh"

run_src() {  # run_src <repo> [env…] — stdout of the handler; rc preserved
  local repo="$1"; shift
  env PATH="$TR/bin:$PATH" GARDEN_ROOT="$ROOT" GARDEN_STATE="$TR/state" \
    GARDEN_API_COOLDOWN_SECS=0 GARDEN_GH_API_ATTEMPTS=1 "$@" \
    bash "$SRC" "$repo" kriscendobot 2>>"$TR/err"
}
calls() { cat "$COUNT" 2>/dev/null || echo 0; }
reset() { rm -rf "$CACHE"; echo 0 > "$COUNT"; echo "$1" > "$MODE"; }

echo "1. concurrent consumers single-flight one enumeration"
reset ok
for i in 1 2 3 4; do run_src endojs/repo > "$TR/out.$i" & done; wait
[ "$(calls)" = 1 ] && ok "four concurrent consumers issued one paginated walk" \
  || bad "expected 1 gh call, saw $(calls)"
same=1; for i in 2 3 4; do cmp -s "$TR/out.1" "$TR/out.$i" || same=0; done
[ "$same" = 1 ] && [ "$(wc -l < "$TR/out.1")" = 2 ] \
  && ok "every consumer received the same complete two-PR list" || bad "outputs differ or incomplete"
grep -q $'^2\tdependabot\\[bot\\]\ta/b\tt2\tBump x from 1 to 2$' "$TR/out.1" \
  && ok "TSV shape unchanged" || bad "TSV shape wrong: $(cat "$TR/out.1")"
[ ! -e "$TR/state/ci-pr-source-cache" ] && ls "$CACHE"/*.tsv >/dev/null 2>&1 \
  && ok "snapshot lives below GARDEN_ROOT, not GARDEN_STATE" || bad "cache location wrong"

echo "2. a later consumer inside the window reuses; another repo does not"
run_src endojs/repo > /dev/null
[ "$(calls)" = 1 ] && ok "sequential reuse within TTL" || bad "re-enumerated within TTL ($(calls))"
run_src ENDOJS/Repo > /dev/null
[ "$(calls)" = 1 ] && ok "repo key is case-insensitive" || bad "case variant missed ($(calls))"
run_src other/repo > /dev/null
[ "$(calls)" = 2 ] && ok "a different repository enumerates on its own" || bad "cross-repo reuse ($(calls))"

echo "3. expiry, tampering, and disable are misses"
for snap in "$CACHE"/*.tsv; do
  read -r m e l s < "$snap"; { echo "$m $((e - 120)) $l $s"; tail -n +2 "$snap"; } > "$snap.x"; mv "$snap.x" "$snap"
done
run_src endojs/repo > /dev/null
[ "$(calls)" = 3 ] && ok "expired snapshot re-enumerates" || bad "expired snapshot served ($(calls))"
for snap in "$CACHE"/*.tsv; do sed -i '2s/one/forged/' "$snap"; done
out="$(run_src endojs/repo)"
[ "$(calls)" = 4 ] && ! grep -q forged <<<"$out" && ok "hash mismatch is a miss" \
  || bad "tampered snapshot served ($(calls))"
run_src endojs/repo GARDEN_CI_PR_SOURCE_CACHE_SECS=0 > /dev/null
[ "$(calls)" = 5 ] && ok "TTL 0 disables the cache" || bad "TTL 0 still cached ($(calls))"

for mode in fail quota empty object; do
  echo "4. a '$mode' enumeration fails loud and never populates the cache"
  reset "$mode"; rc=0
  out="$(run_src endojs/repo)" || rc=$?
  [ "$rc" -ne 0 ] && [ -z "$out" ] && ok "$mode: nonzero exit with no output" \
    || bad "$mode: rc=$rc out=$out"
  ls "$CACHE"/*.tsv >/dev/null 2>&1 && bad "$mode: snapshot written" || ok "$mode: no snapshot written"
  echo ok > "$MODE"
  out="$(run_src endojs/repo)"
  [ "$(calls)" = 2 ] && [ "$(wc -l <<<"$out")" = 2 ] \
    && ok "$mode: the next consumer enumerates afresh" || bad "$mode: recovery wrong ($(calls))"
done

echo "5. a failure does not evict a still-valid snapshot for others"
reset ok; run_src endojs/repo > /dev/null
echo fail > "$MODE"
out="$(run_src endojs/repo)"
[ "$(calls)" = 1 ] && [ "$(wc -l <<<"$out")" = 2 ] \
  && ok "valid snapshot served without a doomed call" || bad "($(calls))"

echo
echo "ci-pr-source-cache-test: $PASS passed, $FAIL failed"
[ "$FAIL" -eq 0 ]
