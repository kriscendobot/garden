#!/bin/bash
# Regression coverage for the identity-keyed authorization arm of
# skills/panel-hints/probes/C-locksmith.sh. The historical lines come from the
# reviewed minion.town #85 head, ce9a8dc7206f53accf55e767c93549a4a859b0e9.
# The owner equality was inherited from the parent rather than added in that one
# commit, so the test covers both the real added rejection-test signal and a
# faithful added-hunk reconstruction of the gate that controlled upgrade.
set -uo pipefail

ROOT=$(cd "$(dirname "$0")/../../.." && pwd)
PROBE="$ROOT/skills/panel-hints/probes/C-locksmith.sh"

passes=0
failures=0
ok() { echo "ok - $1"; passes=$((passes + 1)); }
bad() { echo "not ok - $1"; failures=$((failures + 1)); }

fires() { # <name> <line>
  local name="$1" line="$2" out
  out=$(printf '%s\n' "$line" | "$PROBE" --scan-stdin 2>&1)
  case "$out" in
    "fire locksmith identity-keyed authorization signal:"*) ok "$name - $out" ;;
    *) bad "$name did not fire: $out" ;;
  esac
}

abstains() { # <name> <line>
  local name="$1" line="$2" out
  out=$(printf '%s\n' "$line" | "$PROBE" --scan-stdin 2>&1)
  case "$out" in
    "skip locksmith") ok "$name abstains" ;;
    *) bad "$name should abstain: $out" ;;
  esac
}

# Historical #85 added test title at the reviewed head. The test encoded denial
# in terms of caller identity rather than possession of upgrade authority.
fires 'pr85 identity-titled rejection test (ce9a8dc7206)' \
  'it("rejects an owner who does not own the clip, without re-interning", async () => {'

# Faithful reconstruction of the gate in src/endo/gateway/publish.ts at that head.
fires 'pr85 record owner-equality gate fixture' \
  'if (!record || record.owner !== owner || !record.directoryId) {'

fires 'caller equality' 'if (caller === principal) return performAction();'
fires 'owner helper' 'assertOwner(record, caller);'
fires 'subject allowlist' 'if (!allowedSubs.has(sub)) throw new Error("forbidden");'
fires 'iss allowlist' 'if (issAllowlist.includes(iss)) return operation();'

# Identity remains valid for coarse authentication, accounting, and billing.
abstains 'authentication lookup only' 'const account = accountsBySubject.get(sub);'
abstains 'billing key only' 'await chargeAccount(owner, operationCost);'
abstains 'capability possession' 'await E(upgradeCapability).replaceContent(content);'

# Exercise the actual diff scanner and panel-hints routing, not only --scan-stdin.
temporary_directory=$(mktemp -d "${TMPDIR:-/tmp}/identity-gate-test.XXXXXX")
trap 'rm -rf "$temporary_directory"' EXIT
git -C "$temporary_directory" init -q
git -C "$temporary_directory" config user.name test
git -C "$temporary_directory" config user.email test@example.invalid
printf '%s\n' 'export const perform = () => undefined;' >"$temporary_directory/authority.js"
git -C "$temporary_directory" add authority.js
git -C "$temporary_directory" commit -qm base
base=$(git -C "$temporary_directory" rev-parse HEAD)
printf '%s\n' \
  'export const upgrade = (record, owner) => {' \
  "  if (record.owner !== owner) throw new Error('not the owner');" \
  '};' >>"$temporary_directory/authority.js"
git -C "$temporary_directory" add authority.js
git -C "$temporary_directory" commit -qm identity-gate

if output=$("$ROOT/skills/panel-hints/panel-hints.sh" --base "$base" "$temporary_directory" 2>&1); then
  if printf '%s\n' "$output" | grep -Eq '^Content-triggered .*locksmith' \
    && printf '%s\n' "$output" | grep -Eq '^  locksmith  +identity-keyed authorization signal:'; then
    ok 'panel-hints routes an owner-equality diff to locksmith'
  else
    bad "panel-hints omitted the locksmith identity signal: $output"
  fi
else
  bad "panel-hints failed on the identity-gate fixture: $output"
fi

echo "1..$((passes + failures))"
echo "# passes=$passes failures=$failures"
[ "$failures" -eq 0 ]
