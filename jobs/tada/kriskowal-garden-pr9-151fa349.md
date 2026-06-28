Inbox empty. Work complete.

---

## Completion report — `kriskowal-garden-pr9-151fa349` (attention directive on garden#9)

**Directive routed** (kriskowal comment 4825122191): "continue this investigation; Agoric SDK is equally germane as Endo" + "verify `@agoric/internal/hex.js` changed between the betas, or it's a red herring."

**What I did:**

1. **Verified the hex.js question — decisively, inline.** `packages/internal/src/hex.js` has exactly **one commit in its entire history** (`5b3f4420c0`, 2025-04-09) and its git blob SHA `791b4d953bb5…` is **identical** at the file's creation, at the ses-2.x sync `3952deecd4` (between the betas), at the #12761 tree `9d518832d4`, and at master. So the file — and its `decodings = new Map(encodings.flatMap(...))` wide-frame builder — is **byte-identical across beta2↔beta3.** Conclusion: hex.js is a *pre-existing* co-resident wide frame, **not** the regression cause (confirms the maintainer's red-herring suspicion at root-cause level); it remains a valid *mitigation* target (PR #7's `flatMap`→loop buys back ~1,024 slots). The actual regression delta is the beta3 Endo libs widening the import path by the ~128 slots that tip it over 4096 — consistent with the thread's two-worktree experiment.

2. **Updated standing scope memory** to the maintainer's in-thread revision (comment 4825117452): `kriscendobot/agoric-sdk` **fork experimentation is now authorized**; the hard line narrows to *upstream* `agoric/agoric-sdk` only (no issue/PR links, no upstream comments). Edited `scope_bot_repo_and_forks_only_no_agoric_sdk.md` + its MEMORY.md index line.

3. **Posted two jobs** to the board (todo): `garden-continue-ymax0-xs-investigation` (export-free continuation — re-provision the instrumented xsnap-worker, finer bisection of the beta3 Endo libs against the real ymax0 import to name the specific package/function adding the width; fork-internal) and `garden-revise-agoric-fork-scope-instructions` (sweep the stale "agoric-sdk off-limits" wording in `CLAUDE.md:141`, `roles/COMMON.md`, and five role files to the fork-authorized/upstream-only form, in an isolated worktree off origin/main2 — I only grepped the deployed root, never edited it).

4. **Answered the maintainer on the thread** (issue-scoped comms): https://github.com/kriskowal/garden/issues/9#issuecomment-4825138209.

**Follow-ups / open:** the one remaining blocked path is a real-data swing-store **trace**, which still needs the v320 export only the maintainer can source — flagged, not attempted. The continuation job will report the Endo-lib attribution back on garden#9. The scope-revision job's main2 edits await a gardener claim.

**Scope discipline:** all proposed agoric-sdk work is fork-internal on `kriscendobot/agoric-sdk`; no upstream `agoric/agoric-sdk` links or comments anywhere.
