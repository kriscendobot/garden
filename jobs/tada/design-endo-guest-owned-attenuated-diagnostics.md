Done. PR #1266 is a draft, design-only PR against `llm`, which arms the completion machinery to auto-stage the design-panel gauntlet.

## Completion report

**Job:** `design-endo-guest-owned-attenuated-diagnostics` (designer role)
**Deliverable:** `designs/guest-owned-attenuated-diagnostics.md` on `endojs/endo-but-for-bots`, draft PR **#1266** against `llm`.

### What I did
- Traced the daemon's formula machinery to ground the design in the real code (treating the review text as untrusted, working only from the job's summary of it):
  - The host-only `diagnostics()` facet and `getFormula`/`getFormulaGraph`/`traces` (`packages/daemon/src/host.js`, `interfaces.js`); the guest facet has none (`guest.js`), and the test `the diagnostics facet is absent on the guest facet` (`test/endo.test.js:3190`) asserts that.
  - The key gap: **no formula records a creator.** Guest-created `eval`/`marshal` formulas are written on `localNodeNumber` (`manager.js` `formulateEval`, `formulateMarshalValue`); only agent formulas carry a node via their keypair, and a few relationship formulas carry an agent reference. So a guest-scoped facet has nothing to filter on.
  - The `formula` SQLite table keys rows by `number` with `node` a separate indexed column (`manager-database.js`), so a `creator` column is a cheap additive migration mirroring the prior `node`-column addition.
- Wrote the design: **mark by creator** (dedicated `creator` column, threaded through the `formulate*` chokepoint) rather than **partition by node** (rejected, because it would overload the identifier's routing/locality meaning); a self-attenuated `diagnostics()` on the guest facet bound to `guestId`, gated in the daemon core; grandfathering of existing formulas to host-scope; and its relationship to the host inspector / Chat formula-view. Includes a validated mermaid diagram, dependencies, phased plan, design decisions, and five open questions.
- Integrated it into `designs/README.md` (summary table, M9 notes + estimate rows, dependency-graph node/edge, M9 count 13→14).
- Validated all mermaid fences parse (design: `OK flowchart-v2`; README: `OK flowchart-v2`, `OK gantt`).
- Committed the two design files only, pushed `design/guest-owned-attenuated-diagnostics`, opened draft PR #1266 via `ensure-pr.sh` (marker-adopting), and confirmed it is draft and design-only.

### Left for others / follow-ups
- The design is a review surface; the auto-staged design panel will run against #1266. I left it **draft** and did not hand-post a gauntlet, per the designer completion contract.
- Implementation is a separate build against the implementation base once the design converges.
- The design's open questions (guest `traces()` scope, self-identity resolution, grandfather-vs-backfill, unconditional-vs-withholdable) are for maintainer decision in review.

Self-improvement: nothing this time.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/design-endo-guest-owned-attenuated-diagnostics.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 92 tokens (5409580 cached reads)
- Output: 31953 tokens
- Cost: $4.9197859999999975
- Wall-clock: 527s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
