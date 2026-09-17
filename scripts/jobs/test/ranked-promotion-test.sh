#!/bin/bash
# ranked-promotion-test.sh — the leaf-first (omega-ranked) deferred promotion order
# (slice 5 of designs/cybernetics-economic-resilience.md, reconciled with
# designs/omega-task-rank-and-foreman-retirement.md and designs/cnf-backlog-triple.md).
#
# The promoter admits the LOWEST omega rank first: a leaf is R0, a parent that has
# spawned children derives 1 + max(child rank) capped at 2 (the realized floor), and
# rank is DERIVED from `role:` + realized children, never a declared field. This
# pins:
#
#   1. ORDER — plan_deferred_ranked_omega floats R0 leaves ahead of the R1 designer
#      and the R2 orchestrator; the emitted rank column is non-decreasing.
#   2. GATE — only gate=deferred is selected; a gate=blocked job never appears
#      (unchanged from plan_deferred_ranked, whose gate filter is reused).
#   3. TIE-BREAK — within one omega rank the existing priority order is preserved
#      (high before normal), so the ranked key is a NEW primary, not a replacement
#      of the deterministic tie-breaks.
#   4. REALIZED FLOOR — a deferred job that has spawned a child is lifted above its
#      leaf child by the derivation, not by any role signal (a builder parent with a
#      child ranks R1, above its R0 builder child).
#   5. FAIL-OPEN — when the omega derivation is unavailable the order collapses to
#      exactly plan_deferred_ranked's priority+FIFO order, every base at rank 0.
#
# Deterministic, no systemd, no LLM: sources the real common.sh and drives seeded
# journal-shaped dirs. python3 is required for the derivation; absent, only the
# fail-open subtest is meaningful, so the suite skips (matching cnf-backlog-triple-test.sh).
set -euo pipefail
export GARDEN_TEST=1
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
JOBS="$(cd "$HERE/.." && pwd)"
PASS=0; FAIL=0
ok()  { echo "  PASS: $*"; PASS=$((PASS+1)); }
bad() { echo "  FAIL: $*"; FAIL=$((FAIL+1)); }
hr()  { echo "----------------------------------------------------------------"; }
command -v python3 >/dev/null 2>&1 || { echo "ranked-promotion-test: python3 absent, skipping"; exit 0; }

# Scrub ambient fleet env so a live gardener running this as a board job does not
# splice its own GARDEN_ROOT (which points at the DEPLOYED root, whose deriver may
# predate --ranks) underneath the fixture — GARDEN_ROOT must derive from this
# worktree's common.sh so the deriver beside it (with --ranks) is the one used.
# shellcheck disable=SC2046
unset $(compgen -v 2>/dev/null | grep -E '^(GARDEN_|JOURNAL_|SELF_HEAL_|XDG_)' || true) 2>/dev/null || true
export GARDEN_TEST=1

# shellcheck source=../common.sh
source "$JOBS/common.sh"

TR="$(mktemp -d "${TMPDIR:-/tmp}/garden-ranked.XXXXXX")"; trap 'rm -rf "$TR"' EXIT

# seed_job <dir> <board> <base> <role> <gate> <priority> — write a job file with a
# heading (so cnf's line-scan finds a title) after the frontmatter. Empty role/gate/
# priority are omitted so defaults apply (gate defaults to deferred).
seed_job() {
  local dir="$1" board="$2" base="$3" role="$4" gate="$5" prio="$6"
  local f="$dir/jobs/$board/$base.md"
  mkdir -p "$dir/jobs/$board"
  {
    printf -- '---\n'
    [ -n "$role" ] && printf 'role: %s\n' "$role"
    [ -n "$gate" ] && printf 'gate: %s\n' "$gate"
    [ -n "$prio" ] && printf 'priority: %s\n' "$prio"
    printf -- '---\n\n'
    printf '# %s\n\nbody for %s\n' "$base" "$base"
  } > "$f"
}

new_board() {
  local dir="$1"; mkdir -p "$dir/jobs/todo" "$dir/jobs/doin" "$dir/jobs/plan" \
    "$dir/jobs/tada" "$dir/jobs/orch"
}

# ============================================================================
hr; echo "SUBTEST 1 — leaf R0 admitted before R1 before R2; rank column non-decreasing"; hr
D1="$TR/order"; new_board "$D1"
seed_job "$D1" plan bld-a       builder      deferred normal
seed_job "$D1" plan bld-b       builder      deferred normal
seed_job "$D1" plan dsn-c       designer     deferred normal
seed_job "$D1" plan orch-d      orchestrator deferred normal
seed_job "$D1" plan blk-e       builder      blocked  normal   # must be excluded

OUT="$(plan_deferred_ranked_omega "$D1")"
RANKS="$(printf '%s\n' "$OUT" | cut -f1)"
BASES="$(printf '%s\n' "$OUT" | cut -f2)"

# non-decreasing rank column
if printf '%s\n' "$RANKS" | awk 'NR>1 && $1<prev{bad=1} {prev=$1} END{exit bad?1:0}'; then
  ok "omega rank column is non-decreasing (leaves first): [$(printf '%s' "$RANKS" | tr '\n' ' ')]"
else
  bad "rank column not non-decreasing: [$(printf '%s' "$RANKS" | tr '\n' ' ')]"
fi
# the blocked job never appears
if printf '%s\n' "$BASES" | grep -qx blk-e; then
  bad "gate=blocked job blk-e was selected (must be excluded)"
else
  ok "gate=blocked job blk-e is excluded from the ranked order"
fi
# the R2 orchestrator is last, both builders precede the designer
last="$(printf '%s\n' "$BASES" | tail -1)"
[ "$last" = orch-d ] && ok "R2 orchestrator (orch-d) is admitted last" || bad "last was '$last', want orch-d"
pos_dsn="$(printf '%s\n' "$BASES" | grep -nx dsn-c | cut -d: -f1)"
pos_a="$(printf '%s\n' "$BASES" | grep -nx bld-a | cut -d: -f1)"
pos_b="$(printf '%s\n' "$BASES" | grep -nx bld-b | cut -d: -f1)"
if [ "$pos_a" -lt "$pos_dsn" ] && [ "$pos_b" -lt "$pos_dsn" ]; then
  ok "both R0 builders precede the R1 designer"
else
  bad "a builder did not precede the designer (a=$pos_a b=$pos_b dsn=$pos_dsn)"
fi

# ============================================================================
hr; echo "SUBTEST 2 — priority tie-break preserved WITHIN one omega rank"; hr
D2="$TR/tiebreak"; new_board "$D2"
seed_job "$D2" plan low-prio  builder deferred normal
seed_job "$D2" plan high-prio builder deferred high    # same rank R0, higher priority
OUT2="$(plan_deferred_ranked_omega "$D2" | cut -f2)"
first="$(printf '%s\n' "$OUT2" | head -1)"
[ "$first" = high-prio ] \
  && ok "within R0, the higher-priority job is admitted first (tie-break preserved)" \
  || bad "priority tie-break lost: first was '$first', want high-prio"

# ============================================================================
hr; echo "SUBTEST 3 — realized floor lifts a spawned parent above its leaf child"; hr
D3="$TR/floor"; new_board "$D3"
# floor-parent is a BUILDER (role ⇒ R0) but has spawned a child, so the realized
# floor derives 1+max(child)=1 — above its R0 child. Rank is derived, not role-read.
seed_job "$D3" plan floor-parent builder deferred normal
seed_job "$D3" plan floor-child  builder deferred normal
printf -- '---\nchildren: floor-child\n---\n\n# floor-parent orch record\n' \
  > "$D3/jobs/orch/floor-parent.md"
OUT3="$(plan_deferred_ranked_omega "$D3")"
r_parent="$(printf '%s\n' "$OUT3" | awk -F'\t' '$2=="floor-parent"{print $1}')"
r_child="$(printf '%s\n' "$OUT3" | awk -F'\t' '$2=="floor-child"{print $1}')"
pos_parent="$(printf '%s\n' "$OUT3" | cut -f2 | grep -nx floor-parent | cut -d: -f1)"
pos_child="$(printf '%s\n' "$OUT3" | cut -f2 | grep -nx floor-child | cut -d: -f1)"
if [ "$r_child" = 0 ] && [ "$r_parent" = 1 ] && [ "$pos_child" -lt "$pos_parent" ]; then
  ok "realized floor: leaf child (R0) admitted before its spawned parent (R1)"
else
  bad "realized floor wrong: child rank=$r_child parent rank=$r_parent (child pos $pos_child, parent pos $pos_parent)"
fi

# ============================================================================
hr; echo "SUBTEST 4 — FAIL-OPEN: no deriver ⇒ exactly plan_deferred_ranked order, rank 0"; hr
D4="$TR/failopen"; new_board "$D4"
seed_job "$D4" plan fo-orch  orchestrator deferred normal   # would be R2 with a deriver
seed_job "$D4" plan fo-bld   builder      deferred high     # higher priority
seed_job "$D4" plan fo-dsn   designer     deferred normal
# Force the derivation unavailable via the GARDEN_CNF_TRIPLE seam (a missing deriver),
# without disturbing the coreutils the function itself needs.
EXPECT="$(plan_deferred_ranked "$D4")"
GOT="$(GARDEN_CNF_TRIPLE="$TR/no-such-deriver.py" plan_deferred_ranked_omega "$D4" | cut -f2)" || true
GOT_RANKS="$(GARDEN_CNF_TRIPLE="$TR/no-such-deriver.py" plan_deferred_ranked_omega "$D4" | cut -f1 | sort -u | tr '\n' ' ')" || true
if [ "$GOT" = "$EXPECT" ]; then
  ok "fail-open order equals plan_deferred_ranked (priority+FIFO): [$(printf '%s' "$GOT" | tr '\n' ' ')]"
else
  bad "fail-open order diverged: got [$(printf '%s' "$GOT" | tr '\n' ' ')] want [$(printf '%s' "$EXPECT" | tr '\n' ' ')]"
fi
[ "$GOT_RANKS" = "0 " ] \
  && ok "fail-open assigns every base rank 0 (no derived rank)" \
  || bad "fail-open ranks were '$GOT_RANKS', want '0 '"

hr
echo "RESULTS: $PASS passed, $FAIL failed"
[ "$FAIL" -eq 0 ]
