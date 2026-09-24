#!/bin/bash
# export-index-test.sh — the export-name index generator and its per-commit cache
# (designs/export-index-build-vs-buy.md § Test plan): a fixture workspace with a
# barrel `export *`, a subpath export, a private package, and a dependency cycle.
set -uo pipefail
ROOT=$(cd "$(dirname "$0")/../../.." && pwd)
BUILD="$ROOT/scripts/jobs/export-index/build-export-index.sh"
ENSURE="$ROOT/scripts/jobs/export-index/ensure-export-index.sh"
T=$(mktemp -d "${TMPDIR:-/tmp}/export-index-test.XXXXXX"); trap 'rm -rf "$T"' EXIT
export GARDEN_STATE="$T/state" GARDEN_JOURNAL_DIR="$T/journal"
passes=0; failures=0
ok() { echo "ok - $1"; passes=$((passes + 1)); }
bad() { echo "not ok - $1"; failures=$((failures + 1)); }

# shellcheck source=build-vs-buy-fixture.sh
. "$ROOT/scripts/jobs/test/build-vs-buy-fixture.sh"
make_fixture "$T/repo"
R="$T/repo"; sha=$(git -C "$R" rev-parse HEAD)

"$BUILD" "$R" HEAD owner/repo > "$T/one.tsv" && "$BUILD" "$R" HEAD owner/repo > "$T/two.tsv"
cmp -s "$T/one.tsv" "$T/two.tsv" && ok 'two runs are byte-identical' || bad 'index output is not deterministic'
head -1 "$T/one.tsv" | grep -qx "# repo=owner/repo commit=$sha generator=export-index/1" \
  && ok 'header names repo, full commit, and generator' || bad "bad header: $(head -1 "$T/one.tsv")"

row() { grep -P "^$1\t" "$T/one.tsv"; }
row makePromiseKit | grep -qP '\t@endo/promise-kit\t@endo/promise-kit\tpackages/promise-kit/src/kit.js:2\tconst-function\t0\t' \
  && ok 'barrel export * is attributed to the defining declaration' || bad "makePromiseKit row: $(row makePromiseKit)"
row helperThing | grep -qP '\t@endo/barrel/sub.js\t@endo/barrel\tpackages/barrel/src/sub.js:1\tfunction\t2\t' \
  && ok 'subpath export carries its subpath specifier' || bad "helperThing row: $(row helperThing)"
row renamedHelper | grep -qP '\tpackages/barrel/src/sub.js:1\t' \
  && ok 'a renamed re-export resolves to the original definition' || bad "renamedHelper row: $(row renamedHelper)"
row privateHelperFn | grep -qP '\t1$' && ok 'private package rows are marked' || bad "privateHelperFn row: $(row privateHelperFn)"
grep -qP '^#dep\t@endo/barrel\t@endo/foo$' "$T/one.tsv" && ok 'runtime dependency edges are recorded (cycle input)' \
  || bad 'missing #dep edge for the cycle'
! grep -qP '^default\t' "$T/one.tsv" && ok 'default exports are not indexed' || bad 'default export indexed'

out=$("$ENSURE" "$R" HEAD owner/repo)
[ "$out" = "$GARDEN_STATE/export-index/owner-repo/$sha.tsv" ] && cmp -s "$out" "$T/one.tsv" \
  && ok 'ensure fills the content-addressed cache' || bad "ensure path/content wrong: $out"
compgen -G "$GARDEN_STATE/export-index/owner-repo/.*.tmp.*" >/dev/null && bad 'a temp file survived the atomic fill' \
  || ok 'no partial temp file left behind'
# A cache hit never rebuilds: a failing builder still returns the cached path.
out2=$(GARDEN_EXPORT_INDEX_BUILD=/bin/false "$ENSURE" "$R" HEAD owner/repo) && [ "$out2" = "$out" ] \
  && ok 'a cache hit does not rebuild' || bad 'cache hit rebuilt the index'
# A failed build leaves no index behind.
git -C "$R" commit -q --allow-empty -m second
GARDEN_EXPORT_INDEX_BUILD=/bin/false "$ENSURE" "$R" HEAD owner/repo >/dev/null 2>&1 \
  && bad 'a failed build reported success' \
  || { [ ! -e "$GARDEN_STATE/export-index/owner-repo/$(git -C "$R" rev-parse HEAD).tsv" ] \
       && ok 'a failed build publishes nothing' || bad 'a failed build published a partial index'; }
# GC keeps the newest N per repo.
for n in 1 2 3; do git -C "$R" commit -q --allow-empty -m "gc $n"; GARDEN_EXPORT_INDEX_KEEP=2 "$ENSURE" "$R" HEAD owner/repo >/dev/null; done
[ "$(ls "$GARDEN_STATE/export-index/owner-repo"/*.tsv | wc -l)" -eq 2 ] && ok 'GC keeps the newest N indexes' \
  || bad "GC left $(ls "$GARDEN_STATE/export-index/owner-repo"/*.tsv | wc -l) indexes"

echo "$passes passing, $failures failing"
[ "$failures" -eq 0 ]
