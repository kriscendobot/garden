#!/bin/bash
# Re-litigate the filler-phrase-concision review-miss cluster against the
# historical comment artifacts from endojs/endo-but-for-bots #825, #1281, and
# #1304. The controls distinguish a broad dispatch signal from a finding: the
# pruner judges information value, and a short invariant does not fire merely
# because it is a comment.
set -uo pipefail

ROOT=$(cd "$(dirname "$0")/../../.." && pwd)
PROBE="$ROOT/skills/panel-hints/probes/C-pruner.sh"
PRE_PUSH="$ROOT/scripts/jobs/gardening/pre-push-gates.sh"

passes=0
failures=0
ok() { echo "ok - $1"; passes=$((passes + 1)); }
bad() { echo "not ok - $1"; failures=$((failures + 1)); }

fires() { # <name>, with the source artifact on stdin
  local name="$1" out
  out=$("$PROBE" --scan-stdin 2>&1)
  case "$out" in
    "fire pruner"*) ok "$name — $out" ;;
    *) bad "$name did not fire: $out" ;;
  esac
}

abstains() { # <name>, with source lines on stdin
  local name="$1" out
  out=$("$PROBE" --scan-stdin 2>&1)
  case "$out" in
    "skip pruner") ok "$name abstains" ;;
    *) bad "$name should abstain: $out" ;;
  esac
}

# #825, reviewed head 74f71d55bc78: module comment in
# packages/daemon/src/collection-store.js. The empty emphasis occurs in the
# first prose line; the concrete explanation that follows is the useful part.
fires 'pr825 module-comment padding (74f71d55bc78)' <<'EOF'
/**
 * 2. The store's I/O is synchronous, and that is load-bearing rather than
 *    incidental. Entry rows move through the daemon's in-process
 *    `better-sqlite3` handle, so `collectWeakEntries` can delete the rows for
 *    a collected weak key and report the retention edges to remove before the
 *    collecting turn completes.
EOF

# #1281, reviewed head 8e31b55afce3: test comment in
# packages/ses/test/url.test.js. This is the comment containing the filler later
# removed at the linked review line; the existing thesaurus remains available
# for curated stock phrases, while this broad comment shape routes to pruner.
fires 'pr1281 test-comment filler (8e31b55afce3)' <<'EOF'
// This pins a pre-existing invariant, not the warning-suppression the
// `fnWithUndeletablePrototype` permit introduces. `cauterizeProperty` already
// set the undeletable `.prototype` slot to `undefined` before this permit
// existed; the permit only silences the report for that fallback. So this
// test stays green even with the change reverted. The load-bearing regression
// pin for the warning-suppression lives in another test.
EOF

# #1304, reviewed head ca11576479b: the exact five-line explanation immediately
# above Object.hasOwn in packages/helpdown/src/make-help.js.
fires 'pr1304 Object.hasOwn narration (ca11576479b)' <<'EOF'
    // Own-property lookup, never `in`: `in` walks the prototype chain, so on an
    // ordinary-prototype help record `help('constructor')` / `help('toString')`
    // would resolve to an inherited `Object.prototype` value and, through the
    // `help(method?) -> string` return guard every capability shares, trip
    // "Remotables must be explicitly declared" instead of documenting a method.
    if (Object.hasOwn(helpText, methodName)) {
EOF

# A compact, non-obvious invariant or rationale is not a candidate merely
# because it is a comment. If such a rationale spans enough lines to fire the
# loose signal, the pruner brief still requires a content judgment, not deletion.
abstains 'short non-obvious invariant' <<'EOF'
// INVARIANT: preserve insertion order; the first shadowing match wins.
EOF

abstains 'JSDoc tags without padded prose' <<'EOF'
/**
 * @param {string} name
 * @returns {boolean}
 */
EOF

fires 'multi-line rationale is routed for judgment, not automatically faulted' <<'EOF'
// Keep insertion order here because the first shadowing match wins.
// Sorting would change which authority is selected for duplicate names.
// This order is established by the signed manifest.
EOF

# The same signal reaches builders/fixers before push as a non-blocking warning.
temporary_directory=$(mktemp -d "${TMPDIR:-/tmp}/comment-concision-test.XXXXXX")
trap 'rm -rf "$temporary_directory"' EXIT
git -C "$temporary_directory" init -q
git -C "$temporary_directory" config user.name probe
git -C "$temporary_directory" config user.email probe@example.invalid
printf '%s\n' 'export const value = 1;' >"$temporary_directory/example.js"
git -C "$temporary_directory" add example.js
git -C "$temporary_directory" commit -qm base
cat >>"$temporary_directory/example.js" <<'EOF'
// This operation reads the value from the object.
// It then returns the value to the caller.
// The caller consequently receives the value.
EOF
git -C "$temporary_directory" add example.js
if output=$("$PRE_PUSH" --no-auto-fix --probes-only "$temporary_directory" 2>&1); then
  if printf '%s\n' "$output" | grep -Eq 'advisory comment concision +warn \(non-blocking\)'; then
    ok 'pre-push author receives a non-blocking concision warning'
  else
    bad "pre-push gate omitted the concision warning: $output"
  fi
else
  bad "pre-push advisory incorrectly failed the gate: $output"
fi

base=$(git -C "$temporary_directory" rev-parse HEAD)
git -C "$temporary_directory" commit -qm comment-candidate
if output=$("$ROOT/skills/panel-hints/panel-hints.sh" --base "$base" "$temporary_directory" 2>&1); then
  if printf '%s\n' "$output" | grep -Eq '^Content-triggered .*pruner' \
    && printf '%s\n' "$output" | grep -Fq 'pruner  example.js:2 (+3-line prose comment)'; then
    ok 'panel-hints routes a code diff with multi-line prose comments to pruner'
  else
    bad "panel-hints omitted the pruner comment signal: $output"
  fi
else
  bad "panel-hints failed on the comment fixture: $output"
fi

echo "1..$((passes + failures))"
echo "# passes=$passes failures=$failures"
[ "$failures" -eq 0 ]
