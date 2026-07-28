#!/bin/bash
# regenerate-sections-index-test.sh — coverage for the deterministic sections
# index regenerator (regenerate-sections-index.sh).
#
# What it pins:
#   1. COMPLETENESS — every sections/*.md (bar README.md) appears exactly once,
#      including a section whose source page carries NO `## Sections` table
#      (the filename-derived source-slug grouping reaches it anyway).
#   2. NESTING — a `kind: index` parent renders `(index)` with its children
#      nested and sorted by filename; the child title is the one the parent gave.
#   3. PARENS-IN-TITLE — a child whose title contains parentheses parses to the
#      correct target (regression for the greedy-`(` bug: the `](` split).
#   4. PRESERVATION — the preamble (through the AUTO-INDEX anchor) and the
#      HISTORICAL-LOG tail are reproduced byte-for-byte; only the middle changes.
#   5. IDEMPOTENCE — feeding the regenerated README back in, --check reports
#      "current" (exit 0).
#   6. DANGLING — a parent `Sections:` row pointing at a missing child fails
#      --check (exit 1).
#   7. ANCHORS — a README missing a splice anchor is refused (exit 2), never
#      silently clobbered.
#
# Hermetic: a throwaway library/ tree. No real journal, no network. --print and
# --check are pure (no clone), so the test exercises the generator directly.
#
# Usage: regenerate-sections-index-test.sh
set -uo pipefail
# Explicit positive test-context sentinel: protects this standalone suite even when
# invoked outside the test-tree entrypoint heuristic.
export GARDEN_TEST=1
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
JOBS="$(cd "$HERE/.." && pwd)"
GEN="$JOBS/regenerate-sections-index.sh"
PASS=0; FAIL=0
ok()  { echo "  PASS: $*"; PASS=$((PASS+1)); }
bad() { echo "  FAIL: $*"; FAIL=$((FAIL+1)); }
hr()  { echo "----------------------------------------------------------------"; }

# Scrub ambient fleet env so a live gardener invoking this test cannot splice its
# own GARDEN_*/JOURNAL_* state under the fixture (mirrors run-test.sh).
unset $(compgen -v 2>/dev/null | grep -E '^(GARDEN_|JOURNAL_|SELF_HEAL_|XDG_)' || true) 2>/dev/null || true

TR=/home/kris/.garden-regen-sections-test
rm -rf "$TR"; mkdir -p "$TR/library/sources" "$TR/library/sections"
LIB="$TR/library"
SEC="$LIB/sections"; SRC="$LIB/sources"

# --- fixture -----------------------------------------------------------------
# Source pages. `alpha` has a real ## Sections table; `beta` has NONE (its
# sections must still be reached by the filename-derived grouping).
cat > "$SRC/alpha.md" <<'EOF'
---
source: a.md
---
## Sections

| Section | Topics | Status |
|---------|--------|--------|
| [overview](../sections/alpha--overview.md) | x | current |
| [guide](../sections/alpha--guide.md) | x | current |
EOF
cat > "$SRC/beta.md" <<'EOF'
---
source: b.md
---
> Abstract: a source page deliberately WITHOUT a ## Sections table.
EOF

# alpha: a leaf + a kind:index parent with two children (one title has parens).
cat > "$SEC/alpha--overview.md" <<'EOF'
---
title: Overview
status: current
---
Body.
EOF
cat > "$SEC/alpha--guide.md" <<'EOF'
---
title: Guide
status: current
kind: index
---

Sections:

- [Quickstart](alpha--guide--quickstart.md)
- [Routers (not dumb pipes)](alpha--guide--routers.md)

Source: [a.md](https://x/a.md) at commit `abc`.
EOF
cat > "$SEC/alpha--guide--quickstart.md" <<'EOF'
---
title: Quickstart
parent: alpha--guide
---
Body.
EOF
cat > "$SEC/alpha--guide--routers.md" <<'EOF'
---
title: Routers (not dumb pipes)
parent: alpha--guide
---
Body.
EOF
# beta: a leaf whose source page has no table — grouping must still place it.
cat > "$SEC/beta--lonely.md" <<'EOF'
---
title: Lonely
status: current
---
Body.
EOF

# The README to splice around: preamble + AUTO-INDEX anchor + a STALE middle +
# HISTORICAL-LOG anchor + a hand-curated tail.
cat > "$SEC/README.md" <<'EOF'
# Sections

Intro paragraph that must be preserved verbatim.

## Current sections (auto-generated index, alphabetical by source)

Total section files: 1 (0 parent indexes + 1 children).

### stale--block

- [stale--block--gone](stale--block--gone.md)

## Historical ingest log (preserved for chronological context)

### From somewhere (hand-curated; must be preserved verbatim)

- a narrative line that the regenerator must never touch.
EOF

# --- 1. --print: completeness + nesting + parens ----------------------------
hr; echo "regenerator --print"
out="$("$GEN" --print --library "$LIB" 2>/tmp/regen-test-err)"; rc=$?
[ "$rc" = 0 ] && ok "--print exits 0 on a clean fixture" || { bad "--print exit $rc"; cat /tmp/regen-test-err; }

# Every section file linked exactly once.
links="$(printf '%s\n' "$out" | awk '/^## Current sections/{p=1} /^## Historical ingest log/{p=0} p' \
          | grep -oE '\]\([^)]+\.md\)' | sed 's#^](##; s#)$##; s#.*/##' | sort)"
disk="$(cd "$SEC" && ls -1 *.md | grep -vxF README.md | sort)"
[ "$links" = "$disk" ] && ok "every section file appears exactly once (complete, no dupes)" \
  || { bad "index link set != disk set"; diff <(printf '%s\n' "$disk") <(printf '%s\n' "$links"); }

# beta--lonely is grouped under ### beta even though beta.md has no table.
printf '%s\n' "$out" | awk '/^### beta$/{f=1;next} /^### /{f=0} f' | grep -qF 'beta--lonely.md' \
  && ok "section under a table-less source page still grouped (### beta)" || bad "beta--lonely not grouped under ### beta"

# alpha--guide renders (index) with its two children nested.
printf '%s\n' "$out" | grep -qF -- '- [alpha--guide](alpha--guide.md) (index)' \
  && ok "kind:index parent rendered (index)" || bad "index parent not marked (index)"
printf '%s\n' "$out" | grep -qE '^  - \[Quickstart\]\(alpha--guide--quickstart.md\)' \
  && ok "child nested + indented under its parent" || bad "child not nested"

# The parenthetical-title child resolves to the RIGHT target (the ]( split bug).
printf '%s\n' "$out" | grep -qF '  - [Routers (not dumb pipes)](alpha--guide--routers.md)' \
  && ok "child title with parentheses parses to the correct target" || { bad "parens-in-title mis-parsed"; printf '%s\n' "$out" | grep -i router; }

# --- 2. preservation: preamble + historical tail verbatim -------------------
hr; echo "preservation"
diff <(sed -n '1,/^## Current sections/p' "$SEC/README.md") \
     <(printf '%s\n' "$out" | sed -n '1,/^## Current sections/p') >/dev/null \
  && ok "preamble preserved byte-for-byte" || bad "preamble changed"
diff <(sed -n '/^## Historical ingest log/,$p' "$SEC/README.md") \
     <(printf '%s\n' "$out" | sed -n '/^## Historical ingest log/,$p') >/dev/null \
  && ok "historical ingest log preserved byte-for-byte" || bad "historical log changed"

# --- 3. idempotence ---------------------------------------------------------
hr; echo "idempotence"
printf '%s\n' "$out" > "$SEC/README.md"
"$GEN" --check --library "$LIB" >/dev/null 2>&1 && ok "--check on regenerated README reports current (idempotent)" || bad "--check not idempotent"

# --- 4. dangling child detection --------------------------------------------
hr; echo "dangling child"
cat >> "$SEC/alpha--guide.md" <<'EOF'
EOF
# Rewrite alpha--guide to list a child that does not exist.
cat > "$SEC/alpha--guide.md" <<'EOF'
---
title: Guide
kind: index
---

Sections:

- [Quickstart](alpha--guide--quickstart.md)
- [Routers (not dumb pipes)](alpha--guide--routers.md)
- [Ghost](alpha--guide--ghost.md)

Source: [a.md](https://x/a.md) at commit `abc`.
EOF
out2="$("$GEN" --check --library "$LIB" 2>&1)"; rc=$?
[ "$rc" = 1 ] && ok "dangling child fails --check (exit 1)" || { bad "expected exit 1, got $rc"; echo "$out2"; }
printf '%s\n' "$out2" | grep -q 'DANGLING.*alpha--guide--ghost.md' && ok "missing child named in the DANGLING report" || bad "ghost child not reported"

# --- 5. missing anchor refusal ----------------------------------------------
hr; echo "missing anchor"
cat > "$SEC/README.md" <<'EOF'
# Sections

No anchors here at all.
EOF
"$GEN" --print --library "$LIB" >/dev/null 2>&1; rc=$?
[ "$rc" = 2 ] && ok "README without splice anchors refused (exit 2)" || bad "expected exit 2 on missing anchor, got $rc"

# ============================================================================
hr
echo "RESULTS: $PASS passed, $FAIL failed"
[ "$FAIL" = 0 ] && { rm -rf "$TR"; exit 0; } || exit 1
