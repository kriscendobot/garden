#!/bin/bash
# render-daily-progress-summary-test.sh — fixed-window grouping and empty output.
set -euo pipefail
export GARDEN_TEST=1
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
RENDER="$HERE/../render-daily-progress-summary.sh"
TR="$(mktemp -d)"
trap 'rm -rf "$TR"' EXIT
PASS=0; FAIL=0
ok() { echo "  PASS: $*"; PASS=$((PASS + 1)); }
bad() { echo "  FAIL: $*"; FAIL=$((FAIL + 1)); }

mkdir -p "$TR/entries/2026/11/06" "$TR/entries/2026/11/07"
cat > "$TR/entries/2026/11/06/090000Z-progress-gardener-a.md" <<'EOF'
---
ts: 2026-11-06T09:00:00Z
kind: progress
project: endo
---
untrusted body is deliberately not rendered
EOF
cat > "$TR/entries/2026/11/06/100000Z-result-gardener-b.md" <<'EOF'
---
at: 2026-11-06T10:00:00Z
kind: result
project: endo
---
done
EOF
cat > "$TR/entries/2026/11/07/070000Z-tick-scheduler-c.md" <<'EOF'
---
ts: 2026-11-07T07:00:00Z
kind: tick
---
tick
EOF
cat > "$TR/entries/2026/11/07/080000Z-result-late-d.md" <<'EOF'
---
ts: 2026-11-07T08:00:00Z
kind: result
project: excluded
---
outside the exclusive end
EOF

"$RENDER" "$TR" 2026-11-06T08:00:00Z 2026-11-07T08:00:00Z journal/periodicals/2026/11/06.md
OUT="$TR/periodicals/2026/11/06.md"
grep -q '3 journal entries across 2 project streams' "$OUT" && ok "counts only entries in the half-open window" || bad "incorrect count"
grep -q '^## endo$' "$OUT" && grep -q '^### progress (1)$' "$OUT" && grep -q '^### result (1)$' "$OUT" \
  && ok "groups a project by activity kind" || bad "missing project/kind grouping"
grep -q '^## garden-meta$' "$OUT" && grep -q '^### tick (1)$' "$OUT" \
  && ok "puts untagged entries in garden-meta" || bad "missing garden-meta grouping"
grep -q 'entries/2026/11/06/090000Z-progress-gardener-a.md' "$OUT" && ! grep -q 'untrusted body' "$OUT" \
  && ok "cites relative sources without rendering entry bodies" || bad "source/body handling incorrect"
! grep -q 'excluded' "$OUT" && ok "excludes the end boundary" || bad "included end boundary"

mkdir -p "$TR/empty/entries"
"$RENDER" "$TR/empty" 2026-11-06T08:00:00Z 2026-11-07T08:00:00Z journal/periodicals/2026/11/06.md
grep -q '^Nothing moved in the journal from 2026-11-06T08:00:00Z to 2026-11-07T08:00:00Z\.$' "$TR/empty/periodicals/2026/11/06.md" \
  && ok "renders the minimal factual empty-window summary" || bad "incorrect empty summary"

echo "RESULT: $PASS passed, $FAIL failed"
[ "$FAIL" -eq 0 ]
