CI is GREEN (rc 0). The fix stage is complete.

## Completion report

**Job:** Gauntlet FIX round 2 for endojs/endo-but-for-bots PR #1158 (`design(exo-db): define portable passable databases`).

**Re-derived state on clean start:** PR head `kriscendobot:design/exo-db` had commit `8993aa637` (round-1 fixes) as its tip; the round-2 panel (posted 08:55:56Z, disposition **must-fix**) ran against it and no round-2 fix commit existed yet. So this attempt owned applying round 2.

**Round-2 request-changes findings addressed** (critic ×2, skeptic ×2, ergonomist ×3):
- **critic (signed zero):** float64 order-preserving byte transform now canonicalizes `-0`→`+0` first, matching `makeEncodePassable`'s own `-0`→`0` rule (verified in `packages/marshal/src/encodePassable.js:125`), so `keyEQ`-equal keys encode identically — the "equal keys, equal bytes" invariant now holds for signed zero.
- **critic (unbounded reconciliation):** added a pending-mutation intent committed atomically with the retain+ledger (step 2), cleared in step 4; startup step 5 replays only surviving intents, so reconciliation costs O(mutations in flight at crash time), not O(table size). Full scan demoted to an explicit offline fsck.
- **skeptic (float64 rationale):** corrected Motivation + verification plan — the real failure mode is exponent-range overflow at the extremes (`1e300`, `5e-324`), not precision loss; `0.1` round-trips through DynamoDB `N` exactly (≤17 significant digits).
- **skeptic (concurrency test gap):** added verification-plan items for same-key serial ordering under the per-database queue and non-blocking concurrent writes to different database formulas.
- **ergonomist (delete signaling):** stated delete's boolean-vs-throw is deliberately idempotent, contrasted with insert/update's `ConflictError`.
- **ergonomist (KeyError conflation):** split out `UndurableReferenceError` from `KeyError` (errors list + passable-cell write prose).
- **ergonomist (update contract):** restated update's whole-row (not partial-merge) requirement at the method-semantics bullets.

Also folded the two cheapest copyeditor comment-only slips (`retains`→`retention` noun; "write to be rejected" transitivity). Verified pure ASCII, no em-dashes/`--`, no over-long lines.

**Push:** `8993aa637..7355bdd63` to `origin/design/exo-db` via `safe-push-pr-head.sh` (advance mode).

**CI:** GREEN — `total=5 failed=0`, rc 0.

Stopped without re-running the panel (the driver re-posts panel-3).

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1158-gauntlet-fix-2.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 2 on 2 host(s)
- Input: 70 tokens (2995491 cached reads)
- Output: 23087 tokens
- Cost: $3.0599625
- Wall-clock: 840s
- Model(s): claude-opus-4-8 ×2

<!-- garden-usage-end -->
