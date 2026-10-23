#!/bin/bash
# Gauntlet clean/fix follow-ups retain the CI-sized stage wall instead of
# falling back to the ordinary 2400-second handler budget.
set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
HANDLER="$HERE/../handlers/follow-up-claude.sh"
TR="$(mktemp -d "${TMPDIR:-/tmp}/follow-up-gauntlet-budget.XXXXXX")"
trap 'rm -rf "$TR"' EXIT

cat > "$TR/digest" <<'EOF'
===== REPORT endojs-endo-but-for-bots-pr1538-gauntlet-fix-2 =====
## Follow-ups
- Continue the staged fix.
===== END REPORT endojs-endo-but-for-bots-pr1538-gauntlet-fix-2 =====
EOF

cat > "$TR/blocks" <<'EOF'
JOB fu-endojs-endo-but-for-bots-pr1538-gauntlet-fix-2-1
Continue the staged fix and its bounded CI wait.
ENDJOB
JOB fu-demo-pr9-gauntlet-clean-1
---
role: gardener
---
Continue the staged clean and its bounded CI wait.
ENDJOB
JOB fu-demo-pr9-gauntlet-fix-3-2
---
handler-timeout: 9000
---
Continue with an explicit larger wall.
ENDJOB
JOB fu-demo-pr9-gauntlet-clean-4
---
handler-timeout: invalid
---
Continue despite malformed classifier metadata.
ENDJOB
JOB fu-demo-pr9-gauntlet-fix-3-extra-3
A lookalike, not an exact gauntlet stage report base.
ENDJOB
JOB fu-ordinary-report-1
An ordinary follow-up.
ENDJOB
EOF

: > "$TR/calls"
env GARDEN_ROOT="$(cd "$HERE/../../.." && pwd)" \
  GARDEN_STATE="$TR/state" GARDEN=test GARDEN_TEST=1 \
  GARDEN_SHEPHERD_HANDLER_TIMEOUT=6543 \
  GARDEN_FOLLOWUP_CLAUDE="$HERE/fake-claude.sh" \
  FAKE_CLAUDE_BLOCKS="$TR/blocks" FDB_LOG="$TR/calls" \
  GARDEN_FOLLOWUP_POST_JOB="$HERE/follow-up-design-build-producer-stub.sh" \
  "$HANDLER" "$TR/digest"

body_for() {
  awk -v call="CALL follow-up-design-build-producer-stub.sh <$1>" '
    $0 == call { in_call=1; next }
    in_call && $0 == "BODY" { in_body=1; next }
    in_body && $0 == "ENDBODY" { exit }
    in_body {
      if (sub(/ENDBODY$/, "")) { print; exit }
      print
    }
  ' "$TR/calls"
}

fix_body="$(body_for fu-endojs-endo-but-for-bots-pr1538-gauntlet-fix-2-1)"
clean_body="$(body_for fu-demo-pr9-gauntlet-clean-1)"
explicit_body="$(body_for fu-demo-pr9-gauntlet-fix-3-2)"
invalid_body="$(body_for fu-demo-pr9-gauntlet-clean-4)"
lookalike_body="$(body_for fu-demo-pr9-gauntlet-fix-3-extra-3)"
ordinary_body="$(body_for fu-ordinary-report-1)"

grep -q '^handler-timeout: 6543$' <<< "$fix_body"
[ "$(grep -c '^handler-timeout:' <<< "$fix_body")" -eq 1 ]
grep -q '^handler-timeout: 6543$' <<< "$clean_body"
grep -q '^role: gardener$' <<< "$clean_body"
[ "$(grep -c '^handler-timeout:' <<< "$clean_body")" -eq 1 ]
grep -q '^handler-timeout: 9000$' <<< "$explicit_body"
! grep -q '^handler-timeout: 6543$' <<< "$explicit_body"
grep -q '^handler-timeout: 6543$' <<< "$invalid_body"
[ "$(sed -n '2p' <<< "$invalid_body")" = 'handler-timeout: 6543' ]
[ "$(grep -c '^handler-timeout:' <<< "$invalid_body")" -eq 1 ]
! grep -q '^handler-timeout:' <<< "$lookalike_body"
! grep -q '^handler-timeout:' <<< "$ordinary_body"

echo 'PASS: clean/fix follow-ups inherit the gauntlet stage budget unless a valid timeout is explicit'
