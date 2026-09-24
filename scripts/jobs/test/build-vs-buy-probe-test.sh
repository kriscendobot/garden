#!/bin/bash
# build-vs-buy-probe-test.sh — the pre-push build-vs-buy probe
# (designs/export-index-build-vs-buy.md § Test plan), including a replay of the
# endojs/endo-but-for-bots PR #1336 copy that precipitated the design.
set -uo pipefail
ROOT=$(cd "$(dirname "$0")/../../.." && pwd)
PROBE="$ROOT/scripts/jobs/gardening/pre-push-gates/probes/build-vs-buy.sh"
T=$(mktemp -d "${TMPDIR:-/tmp}/build-vs-buy-test.XXXXXX"); trap 'rm -rf "$T"' EXIT
export GARDEN_STATE="$T/state" GARDEN_JOURNAL_DIR="$T/journal"
passes=0; failures=0
ok() { echo "ok - $1"; passes=$((passes + 1)); }
bad() { echo "not ok - $1"; failures=$((failures + 1)); }
# shellcheck source=build-vs-buy-fixture.sh
. "$ROOT/scripts/jobs/test/build-vs-buy-fixture.sh"

COPY='const makePromiseKit = () => {
  /** @type {(value: unknown) => void} */
  let resolve = () => {};
  const promise = new Promise(r => {
    resolve = r;
  });
  return { promise, resolve };
};'

run_case() {  # run_case <file-body> ; prints probe output, returns its rc
  local R base
  R=$(mktemp -d "$T/case.XXXXXX")
  make_fixture "$R"; base=$(git -C "$R" rev-parse HEAD)
  printf '%s\n' "$1" > "$R/packages/foo/test/mcp-adapter.test.js"
  git -C "$R" add -A && git -C "$R" commit -qm head
  (cd "$R" && PRE_PUSH_BASE_REF="$base" "$PROBE" .)
}

out=$(run_case "$COPY") && bad "PR #1336 shape passed: $out" || {
  printf '%s\n' "$out" | grep -Fq "fail: packages/foo/test/mcp-adapter.test.js:1 makePromiseKit -> import { makePromiseKit } from '@endo/promise-kit' (def packages/promise-kit/src/kit.js:2)" \
    && ok 'a local makePromiseKit in a test file fails as a strong hit' || bad "unexpected message: $out"; }

out=$(run_case "import { makePromiseKit } from '@endo/promise-kit';
const kit = makePromiseKit();") && [ "$out" = pass ] \
  && ok 'importing makePromiseKit passes' || bad "import case: $out"

out=$(run_case 'const parse = text => JSON.parse(text);') && [ "$out" = pass ] \
  && ok 'a local generic parse stays silent' || bad "generic case: $out"

out=$(run_case "// build-not-buy: a synchronous test double with no reject
$COPY") && [ "$out" = pass ] && ok 'a build-not-buy waiver passes' || bad "waiver case: $out"

out=$(run_case '// build-vs-buy-exempt: fixture
'"$COPY") && [ "$out" = pass ] && ok 'the per-file exempt marker passes' || bad "exempt case: $out"

# @endo/barrel depends on @endo/foo, so importing helperThing into foo is a cycle.
out=$(run_case 'export function helperThing(left, right) { return left + right; }') && [ "$out" = pass ] \
  && ok 'a cycle-blocked hit passes' || bad "cycle case: $out"

out=$(run_case 'export const privateHelperFn = () => 1;') && [ "$out" = pass ] \
  && ok 'a private, undeclared provider is blocked, not failed' || bad "private case: $out"

# No index (the base does not resolve): pre-push never blocks on infrastructure.
R="$T/noidx"; make_fixture "$R"
out=$(cd "$R" && PRE_PUSH_BASE_REF=no-such-ref "$PROBE" .) && printf '%s\n' "$out" | grep -q '^pass (build-vs-buy skipped' \
  && ok 'an unavailable index skips with a note' || bad "no-index case: $out"

# Replay: PR #1336 at a0cc8ba5 (review 5307103246) against its base 6726b0fb, using
# the real base index and the real test-file bytes. Skipped when the host has no
# endo-but-for-bots bare clone carrying both commits.
BARE="${GARDEN_ROOT:-$ROOT}/worktrees/endojs-endo-but-for-bots.git"
PR_BASE=6726b0fba2d3208ec10b05c2fa9fde2aff7e11cf
PR_HEAD=a0cc8ba5b74500637263acd4761cdabfc9fb1074
FILE=packages/agent-tools/test/mcp-adapter.test.js
if git -C "$BARE" cat-file -e "$PR_HEAD:$FILE" 2>/dev/null && git -C "$BARE" cat-file -e "$PR_BASE^{commit}" 2>/dev/null; then
  index=$("$ROOT/scripts/jobs/export-index/ensure-export-index.sh" "$BARE" "$PR_BASE" endojs/endo-but-for-bots)
  R="$T/replay"; mkdir -p "$R/packages/agent-tools/test"
  git -C "$R" init -q; git -C "$R" config user.name r; git -C "$R" config user.email r@example.invalid
  git -C "$BARE" show "$PR_BASE:packages/agent-tools/package.json" > "$R/packages/agent-tools/package.json"
  git -C "$R" add -A && git -C "$R" commit -qm base
  git -C "$BARE" show "$PR_HEAD:$FILE" > "$R/$FILE"
  git -C "$R" add -A && git -C "$R" commit -qm head
  stub="$T/ensure-stub.sh"
  printf '#!/bin/bash\n[ "$1" = --providers ] && exit 0\necho %q\n' "$index" > "$stub"; chmod +x "$stub"
  out=$(cd "$R" && PRE_PUSH_BASE_REF=HEAD~1 GARDEN_EXPORT_INDEX_ENSURE="$stub" "$PROBE" . 2>&1)
  # The provider source lives in the bare clone, not the replay repo.
  hits=$(cd "$R" && node "$ROOT/skills/build-vs-buy/detect.cjs" --base HEAD~1 --index "$index=$BARE" --passes name)
  printf '%s\n' "$out" | grep -q "^fail: $FILE:22 makePromiseKit -> import { makePromiseKit } from '@endo/promise-kit'" \
    && printf '%s\n' "$hits" | grep -q '"name":"makePromiseKit","strength":"strong"' \
    && ok 'PR #1336 replay: the precipitating helper fails at pre-push' || bad "PR #1336 replay: $out"
else
  echo "ok - # SKIP PR #1336 replay (no endo-but-for-bots bare clone with $PR_HEAD)"
fi

echo "$passes passing, $failures failing"
[ "$failures" -eq 0 ]
