#!/bin/bash
# regenerate-topics-counts-test.sh — coverage for the deterministic topics
# Index-count reconciler (regenerate-topics-counts.sh).
#
# What it pins:
#   1. RECONCILIATION — each non-meta Index row's count column is rewritten to
#      the number of `## Sections` data rows in that topic page (a stale count is
#      corrected; a zero-row page projects to 0).
#   2. META PASSTHROUGH — a row whose count is the literal `(meta)` is preserved
#      verbatim and NEVER recounted, even when its topic page does not exist.
#   3. ABSTRACT PRESERVATION — the link + abstract columns are reproduced
#      byte-for-byte, including an abstract carrying an ESCAPED pipe (`\|`); only
#      the count column changes (regression for a naive `|`-split).
#   4. PRESERVATION — the preamble (through the table header) and the tail are
#      reproduced byte-for-byte; only the count cells change.
#   5. IDEMPOTENCE — feeding the reconciled README back in, --check reports
#      "current" (exit 0).
#   6. MISSING PAGE — a non-meta row naming a topic page that does not exist
#      fails --check (exit 1).
#   7. ANCHOR — a README missing the `## Index` anchor is refused (exit 2),
#      never silently clobbered.
#
# Hermetic: a throwaway library/ tree. No real journal, no network. --print and
# --check are pure (no clone), so the test exercises the generator directly.
#
# Usage: regenerate-topics-counts-test.sh
set -uo pipefail
# Explicit positive test-context sentinel: protects this standalone suite even when
# invoked outside the test-tree entrypoint heuristic.
export GARDEN_TEST=1
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
JOBS="$(cd "$HERE/.." && pwd)"
GEN="$JOBS/regenerate-topics-counts.sh"
PASS=0; FAIL=0
ok()  { echo "  PASS: $*"; PASS=$((PASS+1)); }
bad() { echo "  FAIL: $*"; FAIL=$((FAIL+1)); }
hr()  { echo "----------------------------------------------------------------"; }

# Scrub ambient fleet env so a live gardener invoking this test cannot splice its
# own GARDEN_*/JOURNAL_* state under the fixture (mirrors run-test.sh).
unset $(compgen -v 2>/dev/null | grep -E '^(GARDEN_|JOURNAL_|SELF_HEAL_|XDG_)' || true) 2>/dev/null || true

TR=/home/kris/.garden-regen-topics-test
rm -rf "$TR"; mkdir -p "$TR/library/topics"
LIB="$TR/library"
TOP="$LIB/topics"

# --- fixture -----------------------------------------------------------------
# alpha: a topic page with TWO section rows (its Index count is stale at 99).
cat > "$TOP/alpha.md" <<'EOF'
# Topic: alpha

> Abstract: a topic with a real sections table.

## Sections

| Section | Source | One-line abstract |
|---------|--------|-------------------|
| [alpha--one](../sections/alpha--one.md) | src a | first. |
| [alpha--two](../sections/alpha--two.md) | src b | second. |

## See also

- [`beta`](beta.md): a sibling.
EOF
# beta: ONE section row (its Index count of 1 is already current).
cat > "$TOP/beta.md" <<'EOF'
# Topic: beta

> Abstract: a topic with a single section.

## Sections

| Section | Source | One-line abstract |
|---------|--------|-------------------|
| [beta--lonely](../sections/beta--lonely.md) | src c | only. |
EOF
# NOTE: meta-axis.md is deliberately NOT created — a (meta) row must pass through
# without a MISSING failure, proving (meta) is never recounted.

# The README to reconcile: preamble + ## Index anchor + a table whose alpha count
# is STALE (99 vs the real 2), an already-current beta (1), and a (meta) axis
# whose page does not exist. alpha's abstract carries an escaped pipe.
cat > "$TOP/README.md" <<'EOF'
# Topics

Intro paragraph that must be preserved verbatim.

## Index

| Topic | Abstract | Sections |
|-------|----------|----------|
| [alpha](alpha.md) | An abstract with an escaped \| pipe inside. | 99 |
| [beta](beta.md) | Plain abstract. | 1 |
| [meta-axis](meta-axis.md) | A non-countable taxonomy axis. | (meta) |

## Seed-but-not-yet-populated topics

A hand-curated tail that must be preserved verbatim.
EOF

# --- 1. --print: reconciliation + meta passthrough + abstract preservation ---
hr; echo "reconciler --print"
out="$("$GEN" --print --library "$LIB" 2>/tmp/regen-topics-err)"; rc=$?
[ "$rc" = 0 ] && ok "--print exits 0 on a clean fixture" || { bad "--print exit $rc"; cat /tmp/regen-topics-err; }

# alpha's stale 99 is corrected to its real section-row count (2), abstract intact.
printf '%s\n' "$out" | grep -qF '| [alpha](alpha.md) | An abstract with an escaped \| pipe inside. | 2 |' \
  && ok "stale count corrected; link+abstract (with escaped pipe) preserved byte-for-byte" \
  || { bad "alpha row not reconciled correctly"; printf '%s\n' "$out" | grep -i alpha; }

# beta's already-current count stays 1.
printf '%s\n' "$out" | grep -qF '| [beta](beta.md) | Plain abstract. | 1 |' \
  && ok "already-current count left at 1" || bad "beta row changed unexpectedly"

# meta-axis passes through verbatim even though its page is absent.
printf '%s\n' "$out" | grep -qF '| [meta-axis](meta-axis.md) | A non-countable taxonomy axis. | (meta) |' \
  && ok "(meta) row passed through verbatim (never recounted)" || bad "(meta) row not preserved"

# --- 2. preservation: preamble + tail verbatim ------------------------------
hr; echo "preservation"
diff <(sed -n '1,/^## Index/p' "$TOP/README.md") \
     <(printf '%s\n' "$out" | sed -n '1,/^## Index/p') >/dev/null \
  && ok "preamble (through ## Index) preserved byte-for-byte" || bad "preamble changed"
diff <(sed -n '/^## Seed-but-not-yet-populated topics/,$p' "$TOP/README.md") \
     <(printf '%s\n' "$out" | sed -n '/^## Seed-but-not-yet-populated topics/,$p') >/dev/null \
  && ok "tail preserved byte-for-byte" || bad "tail changed"

# --- 3. idempotence ---------------------------------------------------------
hr; echo "idempotence"
printf '%s\n' "$out" > "$TOP/README.md"
"$GEN" --check --library "$LIB" >/dev/null 2>&1 && ok "--check on reconciled README reports current (idempotent)" || bad "--check not idempotent"

# --- 4. missing topic page detection ----------------------------------------
hr; echo "missing topic page"
# Add a non-meta Index row whose topic page does not exist.
cat > "$TOP/README.md" <<'EOF'
# Topics

Intro paragraph that must be preserved verbatim.

## Index

| Topic | Abstract | Sections |
|-------|----------|----------|
| [alpha](alpha.md) | An abstract. | 2 |
| [ghost](ghost.md) | A topic with no page. | 7 |

## Seed-but-not-yet-populated topics

tail
EOF
out2="$("$GEN" --check --library "$LIB" 2>&1)"; rc=$?
[ "$rc" = 1 ] && ok "missing topic page fails --check (exit 1)" || { bad "expected exit 1, got $rc"; echo "$out2"; }
printf '%s\n' "$out2" | grep -q 'MISSING topics/ghost.md' && ok "missing page named in the MISSING report" || bad "ghost page not reported"

# --- 5. missing anchor refusal ----------------------------------------------
hr; echo "missing anchor"
cat > "$TOP/README.md" <<'EOF'
# Topics

No Index anchor here at all.
EOF
"$GEN" --print --library "$LIB" >/dev/null 2>&1; rc=$?
[ "$rc" = 2 ] && ok "README without the ## Index anchor refused (exit 2)" || bad "expected exit 2 on missing anchor, got $rc"

# ============================================================================
hr
echo "RESULTS: $PASS passed, $FAIL failed"
[ "$FAIL" = 0 ] && { rm -rf "$TR"; exit 0; } || exit 1
