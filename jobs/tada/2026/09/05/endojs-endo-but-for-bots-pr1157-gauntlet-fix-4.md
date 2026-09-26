CI is GREEN (rc 0). The fix is complete.

## Completion report

Applied the round-4 design panel's must-fix items to PR #1157 (`docs: design indelible registry in every guest inventory`, head branch `design/npm-registry-indelible-guest-inventory` on `endojs/endo-but-for-bots`). The PR touches only `designs/npm-registry-indelible-guest-inventory.md`.

**Fixes applied (one follow-up commit `e8613aa60`):**
- **pedant (must-fix):** replaced all six em-dashes in prose with parentheses/colon (lines around the `@none`-adjacency aside, the aggregate-exposure obligation, the prerequisite note, and the alive-but-registry-dead clause). Verified zero `—` remain.
- **orthographer:** `cancelled`→`canceled`, `cancelling`→`canceling`. Verified zero British `cancell(ed|ing)` remain (`cancellation`, correct in American English, left alone).
- **copyeditor:** gave the Summary's dangling clause a verb (`and adds the inventory projection…`); split the overpacked Authority-and-attenuation sentence at the colon into two; rejoined the Indelibility comma-splice as its own sentence; added the `Updated | 2026-09-05` metadata row.
- **ergonomist:** added an inline comment at `GuestFormula.registry`'s declaration flagging its GC-reachability-only (no `thisDiesIfThatDies`) divergence from `HostFormula.registry`; explicitly marked the per-guest attenuating-root formulation mechanism as build-time/unspecified.
- **decomplector:** stated that "shared" means copy-at-formulation (not a live alias) with the named reconvergence path (a fresh Phase-2 migration) as a deliberate limitation; named the repair path (accepted dead-end → formulate fresh guest + hand-migrate pet names) for a permanently-broken 1:1 root.
- **skeptic (should-fix):** stated the migration transactional boundary is per-guest (a permanently-unmigratable formula quarantines only itself) and added the matching permanent-failure isolation test to the catalog.

Approve/comment-only seats (critic approve; skeptic/novice comment-only aggregate-bound and grounding notes) were non-blocking; the aggregate-exposure bound is already tracked in prose as a required backend property and left as-is.

**Push & CI:** pushed via `safe-push-pr-head.sh` (advance mode, `c30031a43…→e8613aa601…`, no peer rewind). Bounded CI wait returned **rc 0 — CI GREEN** (5 checks, 0 failed) at ~7m.

No follow-ups. The driver re-posts panel-5.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1157-gauntlet-fix-4.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 58 tokens (1882435 cached reads)
- Output: 15235 tokens
- Cost: $2.0370355
- Wall-clock: 728s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
