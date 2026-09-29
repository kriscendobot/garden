#!/bin/bash
# Regression coverage for skills/panel-hints/probes/C-platform-arm.sh, the sensing
# half of the `cross-platform-test-coverage` review-miss cluster (test-gap;
# endojs/endo-but-for-bots #836, #475, #1290). Each member case feeds the probe
# the lines of the real historical PR diff that carried the platform arm, and
# checks the seat(s) the miss belonged to fire. Controls check that a node/default-only
# exports change, a real (non-stub) test:xs, and platform-looking names without
# a delimiter abstain.

set -uo pipefail

ROOT=$(cd "$(dirname "$0")/../../.." && pwd)
PROBE="$ROOT/skills/panel-hints/probes/C-platform-arm.sh"
TMP=$(mktemp -d "${TMPDIR:-/tmp}/platform-arm-test.XXXXXX")
trap 'rm -rf "$TMP"' EXIT

passes=0
failures=0
ok() { echo "ok - $1"; passes=$((passes + 1)); }
bad() { echo "not ok - $1"; failures=$((failures + 1)); }

# expect <name> <seat> fire|skip [probe args...]  (diff on stdin)
expect() {
  local name="$1" seat="$2" want="$3"; shift 3
  local out line
  out=$("$PROBE" --diff-stdin "$@" 2>&1)
  line=$(printf '%s\n' "$out" | grep -E "^(fire|skip) $seat( |$)" | head -1)
  case "$line" in
    "$want $seat"*) ok "$name: $line" ;;
    *) bad "$name expected $want $seat, got: $out" ;;
  esac
}

# --- Member re-litigation (lines from the real historical diffs) ---

# #836 (gh pr diff 836): @endo/sha256 lands with xs/browser/node export arms and
# per-platform sources; missed_by coverage-auditor.
pr836='+++ b/packages/sha256/package.json
+    ".": {
+      "xs": "./src/sha256-xs.js",
+      "browser": "./src/sha256-browser.js",
+      "node": "./src/sha256-node.js",
+      "default": "./src/sha256-browser.js"
+++ b/packages/sha256/src/sha256-xs.js
+export const sha256 = bytes => {'
expect 'pr836 coverage-auditor' coverage-auditor fire <<< "$pr836"
expect 'pr836 engine-realist' engine-realist fire <<< "$pr836"

# #1290 at review time (before browser-test/ was added): the new ./async arm with
# a WebCrypto `browser` condition, tested only by Node-side spies.
pr1290='+++ b/packages/sha256/package.json
+    "./async": {
+      "xs": "./src/sha256-endor-async.js",
+      "browser": "./src/sha256-browser-async.js",
+      "node": "./src/sha256-node-async.js",
+      "default": "./src/sha256-browser-async.js"
+++ b/packages/sha256/src/sha256-browser-async.js
+  const digest = await globalThis.crypto.subtle.digest('SHA-256', bytes);
+++ b/packages/sha256/test/sha256-async.test.js
+test("browser arm uses crypto.subtle", async t => {'
expect 'pr1290 coverage-auditor' coverage-auditor fire <<< "$pr1290"
# A browser-only arm (no xs key) still fires coverage-auditor via the file signal.
pr1290_browser_only='+++ b/packages/sha256/src/sha256-browser-async.js
+  const digest = await globalThis.crypto.subtle.digest('"'"'SHA-256'"'"', bytes);'
expect 'pr1290 browser source file alone' coverage-auditor fire <<< "$pr1290_browser_only"

# #475: shim-only assertions in immutable-arraybuffer tests, a package whose
# test:xs is an `exit 0` stub at the PR head (28957b81d0); missed_by engine-realist.
mkdir -p "$TMP/root/packages/immutable-arraybuffer"
cat > "$TMP/root/packages/immutable-arraybuffer/package.json" <<'EOF'
{
  "scripts": {
    "test": "ava",
    "test:xs": "exit 0"
  }
}
EOF
pr475='+++ b/packages/immutable-arraybuffer/test/shim-typedarray.test.js
+// Shim-level integration tests for the freezable-TypedArray emulation.
+import { emulatedOnlyTest } from '"'"'./_emulated-only.js'"'"';
+  t.is(ArrayBuffer.isView(view), false);'
expect 'pr475 engine-realist (stub test:xs)' engine-realist fire --root "$TMP/root" <<< "$pr475"
expect 'pr475 coverage-auditor (stub test:xs)' coverage-auditor fire --root "$TMP/root" <<< "$pr475"
# Even without the package.json lookup the shim-shape assertion alone fires engine-realist.
mkdir -p "$TMP/empty"
expect 'pr475 engine-realist (shim assertion alone)' engine-realist fire --root "$TMP/empty" <<< "$pr475"

# A stub test:xs added in the diff itself.
stub_added='+++ b/packages/foo/package.json
+    "test:xs": "exit 0",'
expect 'added test:xs stub' engine-realist fire --root "$TMP/empty" <<< "$stub_added"

# --- Controls ---

node_only='+++ b/packages/foo/package.json
+    ".": {
+      "types": "./index.d.ts",
+      "node": "./src/node.js",
+      "default": "./index.js"
+++ b/packages/foo/src/node.js
+export const x = 1;'
expect 'node/default-only exports' coverage-auditor skip --root "$TMP/empty" <<< "$node_only"
expect 'node/default-only exports' engine-realist skip --root "$TMP/empty" <<< "$node_only"

real_xs='+++ b/packages/foo/package.json
+    "test:xs": "node scripts/generate-test-xs.js && xst tmp/test-xs.js",'
expect 'real test:xs script' coverage-auditor skip --root "$TMP/empty" <<< "$real_xs"

names='+++ b/packages/foo/src/boxes.js
+export const boxes = [];
+++ b/packages/foo/docs/browser-notes.md
+Browser notes.'
expect 'undelimited / docs-only platform names' coverage-auditor skip --root "$TMP/empty" <<< "$names"

# --- Gate: seat-gate-coverage-auditor.sh must not approve a c8-clean platform arm ---
# (the #1290 shape: Node-side spies cover the browser arm, so c8 is clean).
GATE="$ROOT/scripts/jobs/gardening/seat-gate-coverage-auditor.sh"
repo="$TMP/repo"
mkdir -p "$repo/packages/sha256/src" "$TMP/bin"
git -C "$repo" init -q
git -C "$repo" -c user.name=t -c user.email=t@t commit -q --allow-empty -m base
cat > "$TMP/bin/claude" <<'EOF'
#!/bin/sh
exit 0
EOF
cat > "$TMP/clean-diff" <<'EOF'
#!/bin/sh
exit 1
EOF
chmod +x "$TMP/bin/claude" "$TMP/clean-diff"
gate() { PATH="$TMP/bin:$PATH" GARDEN_COVERAGE_DIFF="$TMP/clean-diff" "$GATE" coverage-auditor 1 "$repo" HEAD~1 2>&1; }

printf 'export const x = 1;\n' > "$repo/packages/sha256/src/plain.js"
git -C "$repo" add -A && git -C "$repo" -c user.name=t -c user.email=t@t commit -q -m plain
out=$(gate)
case "$out" in *"**Verdict:** approve"*) ok 'gate approves a c8-clean change with no platform arm' ;;
  *) bad "gate should approve plain change: $out" ;; esac

git -C "$repo" reset -q --hard HEAD~1 && mkdir -p "$repo/packages/sha256/src"
printf 'export const d = globalThis.crypto.subtle;\n' > "$repo/packages/sha256/src/sha256-browser-async.js"
git -C "$repo" add -A && git -C "$repo" -c user.name=t -c user.email=t@t commit -q -m arm
out=$(gate)
case "$out" in
  *"**Verdict:** comment-only"*"platform-conditional arm"*"sha256-browser-async.js"*) ok 'gate surfaces a c8-clean browser arm instead of approving' ;;
  *) bad "gate should surface platform arm: $out" ;; esac

echo "1..$((passes + failures))"
echo "# passes=$passes failures=$failures"
[ "$failures" -eq 0 ]
