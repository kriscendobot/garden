All work complete. The job worktree has no garden-infra changes to commit (this was external fork work). Writing the completion report.

---

## Completion report — `issue-kriskowal-garden-17`

**Issue:** kriskowal/garden#17 — "Please dispatch a builder to propose a PR against our fork of moddable/xs that constructs its result on the heap instead of spreading the input over slots in the stack."

**What I did**

Acted as the builder. The defect is in `fx_Array_prototype_flatAux` (`xs/sources/xsArray.c`): `flat`/`flatMap` define each element into the heap result array but never pop the spent value-stack slot, so peak value-stack use is **O(flattened output length)** rather than O(depth) — the exact mechanism behind the ymax0 v320 overflow tracked on #9.

- **Fix (one line):** added a per-iteration `mxPop()` at the end of the `flatAux` loop, mirroring `fx_Array_prototype_forEach` (which already pops every iteration → O(1)). GC-safe: each slot is popped only after its value is heap-rooted in the result array (or, for a nested array, after the recursion has copied its leaves in, during which it stays on the stack as the recursion source). Result is now built entirely on the heap without spreading inputs over the stack.
- **A/B build-verified at the stock on-chain stack** using the surviving from-source xsnap harness (`~/.cache/garden-scratch/exp6-ymax0`, XS 13.3.0 / agoric-labs moddable `f6c5951`, `stackCount=4096`): stock `flatAux` → real v320 bundle import **exit 12 STACK_OVERFLOW**; patched → **OK, import completes**. The engine fix alone clears the overflow with no contract-side change. A `flat`/`flatMap` semantics suite (nested `flat`, `flat(Infinity)`, array/scalar mappers, sparse holes, `thisArg`, 2000→4000 `flatMap`) passes identically.

**What changed**

- **PR opened:** kriscendobot/moddable#1 — *xs: flat/flatMap accumulate on the heap, not the value stack*. Branch `flatmap-flat-heap-result` off `agoric-labs/moddable@f6c5951`, **base+head both on the bot fork** `kriscendobot/moddable` (created the fork for this; respects the bot-fork-only autonomous scope — no upstream interaction). Single-line diff, full mechanism/GC-safety/verification writeup in the PR body.
- **Replied on issue #17** (comment 4840067072) with the PR link, the one-line fix, the A/B table, and linked communications: #9 (the root-cause arc, incl. the native-`flatMap`-source comments 4839285776/4839300009 that this issue follows from) and the complementary contract-side kriscendobot/agoric-sdk#7. Left the issue **open** for the submitter to close.
- Verified the new fork has **no `contributors_only` interaction-limit** ({}), so the maintainer can review the PR directly.
- Appended the shipped engine-fix outcome to the durable `reference_xs_flatmap_spreads_onto_value_stack` memory and its index hook.

**Follow-ups**

- Carrying this engine fix **upstream to `agoric-labs/moddable`** (and ultimately Moddable-OpenSource) is a separate, credentialed step (boatman/ferry from the kriskowal-credentialed host) — out of an autonomous gardener's scope; flagged in both the PR and the issue comment.
- This addresses the *class* (any wide `flatMap`/`flat`); the agoric-sdk#7 hex.js loop addresses the specific *instance*. Both can land independently.

No garden `main2` changes were needed (external fork work only); the job worktree is clean.
