PR #1070 is now un-drafted and ready for review.

## Completion report

**Stage:** UNDRAFT — endojs/endo-but-for-bots PR #1070 (gauntlet `endojs-endo-but-for-bots-pr1070-gauntlet-20260828`)

**What I did:**
1. **Idempotence check** — PR was `isDraft: true`, `state: OPEN`, so the stage was live (not a no-op).
2. **Advisory appellate pass** — reviewed the diff. It's a strictly additive, test-only change: two new test262 intrinsic-metadata cases (`IteratorPrototype/intrinsic-metadata.js` pinning the shared `%IteratorPrototype%` sharing invariant + `[Symbol.iterator]` metadata + `-> %Object.prototype%` link; `AsyncIteratorPrototype/intrinsic-metadata.js` pinning `[Symbol.asyncIterator]` metadata + the async prototype chain) plus regenerated baselines across all six host×lockdown modes. Both cases assert only host-coherent relationships, so they hold identically in shim and native columns. No correctness concerns, nothing systematically missed by the panel. Advisory only — did not gate.
3. **Un-drafted** — `gh pr ready` succeeded; confirmed `isDraft: false`, `state: OPEN`.

**Changed:** PR #1070 draft → ready for review. No code/garden changes.

**Follow-ups:** none.

<!-- gauntlet-stage-result: undraft=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1070-gauntlet-20260828-undraft.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 12 tokens (269094 cached reads)
- Output: 1616 tokens
- Cost: $0.6305449999999999
- Wall-clock: 35s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
