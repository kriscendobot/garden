# Gauntlet fix round 1: endojs/endo-but-for-bots PR #1348

I applied the panel's round-1 must-fix items in four follow-up commits and pushed them to `build/daemon-agent-tools-explicit-harness`. The head moved from `8d91250074` to `e8cb2d2941`, and CI is green: all 33 checks passed with 0 failures (`ci-wait-merge` rc 0).

**Fixes applied**

- **Changeset (changeset-auditor):**
  - `@endo/agent-tools` is now `major`, because renaming the composed-catalog `inspect` tools breaks existing callers. This matches the repo's earlier `agent-tools-code-mode-subpaths` changeset. `@endo/agentry` stays `minor`.
  - The body is now one sentence per line and opens with the breaking change.
- **Phase 4 overclaim and premature status (integrator):**
  - `designs/daemon-agent-tools.md` is back to **In Progress**.
  - The Phase 4 "wire end to end for one agent harness (lal first; fae follows)" wording is restored and the item is **unchecked**. It now carries a progress note saying the explicit harness exists but no lal or fae agent uses it yet, so nothing shows daemon-provisioned grants reaching an agent.
  - The worked-loop item stays checked. It is now annotated as landed in #707 and noted to drive the provisioned catalog directly, not through a harness.
  - The status sweep was fixed in six places:
    - the header table and the "Remaining" bullet in the design;
    - the Phase 3.6 intro and the network-tier text around line 391, which said `makeHttpTool` and `@endo/fetch` were still to come (both have landed, #661);
    - `designs/README.md` status row, status line 1113 and estimates row, which are back to In Progress with the remaining work listed;
    - `designs/README.md` line 1143 (endo-fetch), which now says `makeHttpTool` landed.
  - The mermaid `IN PROGRESS` node is correct again now that the status is In Progress.
- **Missing phase/evidence ledger (integrator):** I added the machine-readable ledger to the PR body.
  - Its disposition is scoped to this slice and lists Phases 0–6. Phases 2, 4, 5 and 6 are marked as not claimed by this PR.
  - I also removed the body's "marks the M3 pillar complete" claim.
  - `phase-evidence-gate.sh panel` now returns "attention" (rc 10) instead of "blocked", which means the integrator seat has a ledger to compare against the design.
- **reexport-auditor (inferred):** I removed the plain root re-export of `defineWorkspaceAgent` from `packages/agentry/src/index.js`, along with its line in `types-index.types.d.ts` and the root expectation in `exports.test.js`. Its single source is now the `@endo/agentry/workspace-agent` subpath, which is what the README already documents.
- **purist (inferred):** In `packages/agent-tools/src/workspace.js`, the name tables are now `Map`s instead of plain objects. Before, a tool or group named `constructor` or `toString` would have picked up a value inherited from `Object.prototype`.

The panel record did not keep the purist's or the reexport-auditor's must-fix text, so those two fixes are my best reading of what each seat would flag, not their stated items. The re-export fix follows the policy's no-barrel-exemption rule. Panel round 2 should confirm both.

**Verification before push:**
- agent-tools `workspace` and `git-worked-loop` tests: 11 passed.
- agentry `exports` and `workspace-agent` tests: 3 passed.
- `tsc --noEmit` is clean for both packages.
- eslint reports 0 errors and 2 warnings.

**Follow-ups**
- The curator's should-fix (the renaming in `nameWorkspaceTools` applies unconditionally) was not changed.
- The design's open work is recorded there: Phase 4 end-to-end provisioning into a lal or fae agent, and the Phase 2c sandbox shell engine.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1348-gauntlet-fix-1.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 72 tokens (2984379 cached reads)
- Output: 17135 tokens
- Cost: $1.7275517999999999
- Wall-clock: 972s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
