Inbox empty. This job is complete by way of a **duplicate skip** — the builder norm mandates skipping and surfacing an existing PR rather than opening a competing one.

## Completion report

**Outcome: duplicate — work already done; no new PR opened.**

The requested change (apply the inter-package plain-re-exports recipe, design #548/#543, to `@endo/spaces-util`'s `assertValidLocator` re-export) is **already implemented by open draft PR #685** — `refactor(spaces-util): deprecate + repoint the assertValidLocator plain re-export`, head `refactor/inter-package-spaces-util-repoint-deprecate`, base `llm`, authored by peer instance `kriscendobot`. It was created at 04:23–04:24Z, ~9 minutes **before** I claimed this job (04:33Z), so this job and #685 raced to the same work.

**What I did:**
- Set up an isolated project worktree, read design `designs/inter-package-plain-re-exports.md`, and independently implemented the recipe to verify correctness.
- Enumerated importers: exactly one in-repo consumer reaches `assertValidLocator` via `@endo/spaces-util` — `packages/chat/add-space-modal.js`; nothing imports it via the bare `@endo/spaces-util` barrel.
- Confirmed the **dependency-direction concern is a non-issue**: `@endo/spaces-util` already depends on `@endo/daemon` (and `src/locator.js` already imports `parseLocator` from it), and `@endo/chat` already depends on `@endo/daemon`. No new inter-package edge is introduced — the repoint actually reduces coupling. No layering inversion; no `@erights` flag needed.
- On finding my implementation matched #685 file-for-file (`spaces-util/src/locator.js` +7 deprecation JSDoc, `chat/add-space-modal.js` import repoint, a `@endo/spaces-util: patch` changeset), I stopped rather than push a competing PR #686.

**Verification of #685 (the surviving PR):** MERGEABLE, correct scope (intra-package `index.js` barrel correctly left to #544), all completed CI checks green (state UNSTABLE only because some checks are still running; none failed). Its supervising gardener is running the gauntlet.

**Changes to garden/main2:** none. My project-worktree edits were discarded (uncommitted); the worktree tears down.

**Follow-ups:** none required — #685 covers the ask from @erights (#660 comment). No maintainer or peer message needed; per standing guidance, kriscendobot is a sibling instance and its PR already carries the intent. If desired, the two racing jobs point at a minor de-dup gap (the board posted this slice while a kriscendobot gardener was already on it), but no action is needed for this job.
