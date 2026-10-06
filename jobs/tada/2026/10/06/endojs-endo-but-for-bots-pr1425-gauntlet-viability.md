Viability is **proceed** for endojs/endo-but-for-bots PR #1425. It is still needed and nothing newer has replaced it.

**PR facts:** The PR is OPEN, a draft, and unmerged. Its head is `fix/ses-xs-lockdown-compartment-intrinsics` at `2d7e3bbcc`, and its frozen base is `master-6ee3fda`. The fix makes SES on XS build `Compartment` from the globals as they stand at `lockdown()`, not as they were when `ses` was imported. Today a global replaced or deleted between `import 'ses'` and `lockdown()` leaks into every child compartment unhardened. It touches four files: `src-xs/compartment.js`, `src-xs/lockdown-shim.js`, `test/_xs.js` and a changeset. There are no reviews yet.

**Deciding question:** Do current `master` and `llm` still build the post-lockdown XS `Compartment` from the import-time `ShimStartCompartment`, so the hardening hole is still open and no other change has fixed it?

**Evidence:** Yes on both counts.
- **Bug still present:** On both `master` and `llm`, `packages/ses/src-xs/lockdown-shim.js` (lines 9–24) still calls `adaptCompartmentConstructors(NativeStartCompartment, ShimStartCompartment, …)` with the import-time constructor. There is no `makeShimStartCompartment` or anything equivalent.
- **No newer change to the code:** The newest commit under `packages/ses/src-xs` on either branch is `b4f598f11` from 2025-06-05, and it is unrelated.
- **Base is current:** `master` is 0 commits ahead of the PR's base `6ee3fda`.
- **No competing PR:** A search of related PRs found none that fixes this. #1349, which motivated this fix, is still open and still relies on the workaround this PR would let it fold back in.

**Earlier gauntlet:** A previous gauntlet on this PR stopped at its clean stage, with CI red and a note that the maintainer needs to act. That is a quality problem the gauntlet loop exists to work through, not a sign the PR has been replaced.

**Follow-ups:** None from this gate. I made no edits and no commits.

<!-- gauntlet-stage-result: viability=proceed -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1425-gauntlet-viability.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 6 tokens (109062 cached reads)
- Output: 1443 tokens
- Cost: $0.38546440000000004
- Wall-clock: 21s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
