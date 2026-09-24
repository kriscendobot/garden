#!/bin/bash
# seat-gate-procurer-test.sh — the cost-gated procurer seat
# (designs/export-index-build-vs-buy.md § Test plan). Hermetic: a throwaway git
# repo, a hand-written export index, and a stub `claude` on PATH that logs calls.
#   no hits -> APPROVE, zero model calls; nine hits -> eight dispatched, one
#   capped; malformed reply -> comment-only; cache hit -> zero calls on a re-run;
#   `buy` on a strong hit -> must-fix; blocked -> listed, never dispatched.
# shellcheck disable=SC2015
set -uo pipefail
ROOT=$(cd "$(dirname "$0")/../../.." && pwd)
GATE="$ROOT/scripts/jobs/gardening/seat-gate-procurer.sh"
T=$(mktemp -d "${TMPDIR:-/tmp}/procurer-test.XXXXXX"); trap 'rm -rf "$T"' EXIT
export GARDEN_STATE="$T/state" STUB_LOG="$T/calls"
passes=0; failures=0
ok() { echo "ok - $1"; passes=$((passes + 1)); }
bad() { echo "not ok - $1"; failures=$((failures + 1)); }

mkdir -p "$T/bin"
cat > "$T/bin/claude" <<'STUB'
#!/bin/bash
echo call >> "$STUB_LOG"
printf '%s\n' "${STUB_OUT:-}"
STUB
chmod +x "$T/bin/claude"
export PATH="$T/bin:$PATH"

# Nine distinctive exports from one public package, plus one from a package that
# depends on the local one (a cycle, so blocked).
INDEX="$T/index.tsv"
{
  echo '# repo=owner/repo commit=HEAD generator=test'
  for n in One Two Three Four Five Six Seven Eight Nine; do
    printf 'makeWidget%s\t@endo/widgets\t@endo/widgets\tpackages/widgets/index.js:1\tconst-function\t0\tnoshape\t5\t0\n' "$n"
  done
  printf 'makeCycleThing\t@endo/cycle\t@endo/cycle\tpackages/cycle/index.js:1\tconst-function\t0\tnoshape\t5\t0\n'
  printf '#dep\t@endo/cycle\t@endo/local\n'
} > "$INDEX"
printf '#!/bin/bash\n[ "$1" = --providers ] && exit 0\necho %q\n' "$INDEX" > "$T/ensure"; chmod +x "$T/ensure"
export GARDEN_EXPORT_INDEX_ENSURE="$T/ensure"

R="$T/repo"; mkdir -p "$R/packages/local"
git -C "$R" init -q; git -C "$R" config user.name t; git -C "$R" config user.email t@example.invalid
echo '{"name":"@endo/local"}' > "$R/packages/local/package.json"
echo 'export const unrelated = 1;' > "$R/packages/local/index.js"
git -C "$R" add -A; git -C "$R" commit -qm base

gate() { : > "$STUB_LOG"; "$GATE" procurer 1 "$R" "$1"; }
calls() { wc -l < "$STUB_LOG" | tr -d ' '; }

base=$(git -C "$R" rev-parse HEAD)
echo 'export const alsoUnrelated = 2;' >> "$R/packages/local/index.js"; git -C "$R" commit -qam clean
out=$(gate "$base")
printf '%s\n' "$out" | grep -q '^\*\*Verdict:\*\* approve' && [ "$(calls)" = 0 ] \
  && ok 'no hits: approve with zero model calls' || bad "no-hit case ($(calls) calls): $out"

base=$(git -C "$R" rev-parse HEAD)
for n in One Two Three Four Five Six Seven Eight Nine; do
  printf 'const makeWidget%s = () => ({ kind: "%s" });\n' "$n" "$n" >> "$R/packages/local/index.js"
done
echo 'const makeCycleThing = () => 1;' >> "$R/packages/local/index.js"
git -C "$R" commit -qam hits
out=$(STUB_OUT='{"verdict":"buy","confidence":0.9,"reason":"Same thing."}' gate "$base")
[ "$(calls)" = 8 ] && ok 'nine hits: eight dispatched' || bad "expected 8 calls, got $(calls)"
[ "$(printf '%s\n' "$out" | grep -c 'not judged (cap)')" = 1 ] && ok 'the ninth hit is listed as capped' || bad "cap line missing: $out"
printf '%s\n' "$out" | grep -q 'makeCycleThing.*blocked (dependency-cycle)' && ok 'a cycle-blocked hit is listed, not dispatched' \
  || bad "blocked line missing: $out"
printf '%s\n' "$out" | grep -q '^\*\*Verdict:\*\* request-changes' && printf '%s\n' "$out" | grep -q 'should-fix' \
  && ok 'buy on a weak hit is should-fix (request-changes)' || bad "disposition: $out"

out=$(STUB_OUT='{"verdict":"buy","confidence":0.9,"reason":"cached"}' gate "$base")
[ "$(calls)" = 0 ] && ok 'a cache hit makes zero calls on the second run' || bad "cache re-run made $(calls) calls"

rm -rf "$GARDEN_STATE/build-vs-buy"
out=$(STUB_OUT='I refuse to answer in JSON' gate "$base")
printf '%s\n' "$out" | grep -q '^\*\*Verdict:\*\* comment-only' && printf '%s\n' "$out" | grep -q 'no usable verdict' \
  && ok 'a malformed reply falls back to comment-only' || bad "malformed case: $out"
[ -z "$(ls -A "$GARDEN_STATE/build-vs-buy" 2>/dev/null)" ] && ok 'a malformed reply is never cached' || bad 'malformed reply was cached'

# A strong hit: the local body has the provider's exact shape.
R2="$T/strong"; mkdir -p "$R2/packages/local" "$R2/packages/kit"
git -C "$R2" init -q; git -C "$R2" config user.name t; git -C "$R2" config user.email t@example.invalid
echo '{"name":"@endo/local"}' > "$R2/packages/local/package.json"
echo 'export const makeKitThing = (value) => ({ value });' > "$R2/packages/kit/index.js"
git -C "$R2" add -A; git -C "$R2" commit -qm base; base2=$(git -C "$R2" rev-parse HEAD)
shape=$(cd "$ROOT/skills/build-vs-buy" && node -e "const l=require('./lib.cjs');const p=l.parse(require('fs').readFileSync(process.argv[1],'utf8'),'x.js');console.log(l.shapeOf(l.localFunctionDeclarations(p)[0].fn))" "$R2/packages/kit/index.js")
printf '# repo=o/r commit=%s generator=test\nmakeKitThing\t@endo/kit\t@endo/kit\tpackages/kit/index.js:1\tconst-function\t1\t%s\t9\t0\n' "$base2" "$shape" > "$T/strong.tsv"
printf '#!/bin/bash\n[ "$1" = --providers ] && exit 0\necho %q\n' "$T/strong.tsv" > "$T/ensure2"; chmod +x "$T/ensure2"
echo 'const makeKitThing = (item) => ({ item });' > "$R2/packages/local/index.js"; git -C "$R2" add -A; git -C "$R2" commit -qm head
: > "$STUB_LOG"
out=$(GARDEN_EXPORT_INDEX_ENSURE="$T/ensure2" STUB_OUT='{"verdict":"buy","confidence":0.95,"reason":"Identical."}' "$GATE" procurer 1 "$R2" "$base2")
printf '%s\n' "$out" | grep -q 'must-fix.*makeKitThing' && ok 'buy on a strong hit is must-fix' || bad "strong case: $out"

out=$(GARDEN_EXPORT_INDEX_ENSURE=/bin/false "$GATE" procurer 1 "$R2" "$base2")
printf '%s\n' "$out" | grep -q '^\*\*Verdict:\*\* comment-only' && printf '%s\n' "$out" | grep -q 'could not be checked' \
  && ok 'an unavailable index is surfaced as comment-only' || bad "no-index case: $out"

grep -Eq '(^|[[:space:]])procurer[[:space:]}]' "$ROOT/scripts/jobs/gardening/panel.sh" \
  && grep -qP '^procurer\thaiku$' "$ROOT/scripts/jobs/gardening/seat-model-tiers.tsv" \
  && ok 'procurer is a code-panel seat on the haiku tier' || bad 'procurer is not wired into panel.sh / seat-model-tiers.tsv'

echo "$passes passing, $failures failing"
[ "$failures" -eq 0 ]
