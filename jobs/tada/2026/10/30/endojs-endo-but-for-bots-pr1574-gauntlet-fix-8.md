# Fix round 8 report: endojs/endo-but-for-bots PR #1574

The panel-8 fixes are pushed in one follow-up commit, `35c5dee4ca`, and CI is green (all 30 checks passed, `ci-wait-merge` rc 0). The job carried no pre-pass block, so I worked from the latest panel verdict, review 5712047148 (2026-10-30T12:11:50Z). The commit changes `designs/api-key-agent-workbench.md` and `designs/README.md`.

**Must-fix items applied:**
- **Model-supplied regexes (critic, skeptic):** a per-call clock cannot interrupt a synchronous `RegExp`, so the workbench no longer accepts regexes from the model. `grep` and `glorp` now take a plain literal string, escaped before it reaches the matcher. The clock now only bounds the walk across many files. Regex search is out of scope until there is a matcher that is linear-time or runs off the daemon's event loop. I added a Design Decision, a gating check and W2 tests that use `(a+)+$`.
- **Durable child file access (skeptic) and removing the bespoke workbench formula (decomplector):** the workbench is now an `EndoProvisionSpec` from `@endo/agentry`, limited to `mounts` and `gits` and stored on the `AgentRecord`. The workbench formula and its `narrow()` method are gone.
  - A parent gives a child file access through `spawn`'s new `workbench` option. That spec must be a subset of the parent's, or the call fails with `workbench-exceeds-parent`.
  - A `subView` passed as an endowment is refused with `endowment-not-durable`.
  - Other spec fields are refused with `workbench-field-refused`.
  - The new bounded-read and hashline operations go into the shared mount tool adapters.
  - The reuse table, ownership map, W1/W2/W4/W6 phases and gating checks were updated to match, plus a new Design Decision.
- **Who commits what (decomplector):** the owner's admission queue is now the single transaction owner for grant records, `OwnerInferenceLimits` and ledger rows. The provider design's per-datum owners stay as they were. The W3 gate now requires the provider design to put that data in the store those queue entries commit to.
- **How budgets work, stated up front (novice):** the opening and the Terms now say a child's budget is a limit checked against its ancestors' remaining budgets, not an amount set aside for it.
- **README counts (archivist):** the ledger now reads Proposed 34 → 35 and indexed records 253 → 254.

**Should-fix and copyedit items, also applied:**
- `spawn`'s `systemPrompt` is now optional; if omitted, the child runs on the prompt it inherits, as in Fae. There is a W4 test for this.
- A numeric pause example continues the earlier worked example, showing default `pause` versus `cancelInFlight`.
- All five copyeditor rewrites (design lines 11, 25, 413 and 579, and the README line at 677).
- The README now uses `SubagentControl` instead of `DelegationControl`.

**Follow-up:** the design now depends on a new unverified claim: that agentry's provisioning can build a spec's mounts underneath a mount the factory supplies. It is listed as a gating check that must pass before W2 starts. I did not re-run the panel; the driver posts panel-9.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1574-gauntlet-fix-8.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 54 tokens (2520804 cached reads)
- Output: 22723 tokens
- Cost: $1.8586767999999998
- Wall-clock: 907s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
