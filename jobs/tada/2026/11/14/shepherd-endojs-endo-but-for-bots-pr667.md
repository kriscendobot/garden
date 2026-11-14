---
handed-off: weave-endojs-endo-but-for-bots-pr667-after-pr1646
deliverable-complete: false
---
# Shepherd report: endojs/endo-but-for-bots #667 (stdio JSONL RPC bridge)

CI on #667 is still red, but neither failure comes from its diff. Both come from the frozen base `llm-48d6f3e` (same as current `llm`) and already have open fix PRs. I pushed nothing to #667 and parked a weave job that runs once the Node pin lands.

**Head:** `9b70df7f8e4`, base `llm-48d6f3e`. The PR is mergeable and not a draft. The many cancelled checks are just a duplicate set of runs GitHub started a second earlier and then cancelled. Each workflow has a separate completed run for this head.

**The two failures:**
1. **`CI / test-xs`.** The `@endo/hardened262` baseline check flipped `sesNode/module … test/intrinsics/ThrowTypeError/intrinsic-metadata.js` from passed to failed.
   - **Cause:** the base's `.node-version` is `lts/*`, which now resolves to **Node 26**.
   - **Evidence:** #1588 has the same base and the same turbo task hash (`c9559e7ff0ecb778`), but pins Node 24 and passes. #1359 (based on `llm`) and a dependabot PR fail the same way.
   - **Not a flake:** I reran the failed job once and it failed identically.
   - **Fix:** #1646 (`chore(ci): pin .node-version to 24`) is green and waiting for maintainer review. Other jobs are already parked waiting on it.
2. **`zizmor`.** The pin comment `# v8` on `peter-evans/create-pull-request` in `update-action-pins{,-major}.yml:49` no longer matches, because the `v8` tag moved to v8.1.3. This red shows up on every PR right now.
   - **Fix:** #1659 is green and waiting for maintainer review.

I didn't copy either base fix into #667. That would put unrelated changes into a feature PR, and they'd duplicate the dedicated fix PRs once those land.

**Follow-up posted:** `weave-endojs-endo-but-for-bots-pr667-after-pr1646`, parked in `plan/` with `gate: blocked` on #1646. Once #1646 lands, it weaves #667 onto the new `llm` tip and drives CI to green. If zizmor is still red only because #1659 hasn't landed yet, it reports that instead of fixing it inside #667.

**Classification:** `next: weaver`, gated on #1646. The maintainer needs to review and merge #1646 and #1659; nothing in #667 itself needs changing.

<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/shepherd-endojs-endo-but-for-bots-pr667.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 52 tokens (1920587 cached reads)
- Output: 10831 tokens
- Cost: $1.2483214
- Wall-clock: 1049s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
