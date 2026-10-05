**Viability: proceed.** endojs/endo-but-for-bots PR #1425, "fix(ses): sample XS compartment intrinsics at lockdown", may enter the gauntlet.

**PR state:** Open, unmerged and still a draft. It was opened today, 2026-10-05. The head is `2d7e3bbcc9` on `fix/ses-xs-lockdown-compartment-intrinsics`, with one commit. The base is the frozen snapshot `master-6ee3fda`. It has no comments or reviews yet.

**Deciding question:** On current `master` (and `llm`), does the post-lockdown XS `Compartment` adapter still use the `ShimStartCompartment` built when `ses` is imported, so that a global deleted or replaced before `lockdown()` still leaks into child compartments unhardened? **Yes.**

**Evidence:**
- **The base is current.** Comparing `6ee3fda...master` shows master is 0 commits ahead.
- **`master` still has the defect.** `packages/ses/src-xs/lockdown-shim.js` still calls `adaptCompartmentConstructors(NativeStartCompartment, ShimStartCompartment, …)` with the constructor built at import time. Nobody has changed that file since it was added in `f6c84566b` (2024-12-06). The last change to `src-xs/compartment.js` was `b4f598f11` (2025-06-05), and it added types only.
- **The `llm` branch has it too.** Its `lockdown-shim.js` still passes the import-time `ShimStartCompartment` (lines 12 and 24), so no reimplementation has landed there either.
- **No competing PR exists.** A search for `ShimStartCompartment` / `makeShimStartCompartment` across all PR states in the repo returns only #1425.
- **The motivating need still holds.** PR #1349 ("test(ses): XS smoke check for hardened TextEncoder/TextDecoder") is still open as a draft. It still carries the `_xs-delete-text-codecs.js` pre-import workaround that this fix lets it fold back into its fixture.

No follow-ups. One thing to know for later stages: the PR describes a separate, pre-existing XS defect that it deliberately leaves unfixed. Calling `new compartment.globalThis.Compartment()` throws "cannot be invoked without 'new'". Reviewers may want that tracked as its own job; this PR doesn't need to change for it.

<!-- gauntlet-stage-result: viability=proceed -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-ses-xs-compartment-import-time-intrinsics-gauntlet-viability.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 8 tokens (163402 cached reads)
- Output: 1750 tokens
- Cost: $0.39389640000000004
- Wall-clock: 26s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
