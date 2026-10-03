# FIX round 4 — endojs/endo-but-for-bots PR #1419: fixes pushed, CI green

I applied all six must-fix items from the round-4 panel review and pushed them as one follow-up commit, `30221e5252`, to `llm-confined-application-makers-p2`. CI is green: `ci-wait-merge` returned rc 0 with 33 checks and 0 failures.

**Must-fix items addressed:**
- **engine-realist (XS manager):** the `node_modules` capture is now passed to the manager like the git and shell tools, instead of being loaded with a dynamic `import()` of `@endo/compartment-mapper`. That package is left out of the XS bundle, so under the XS supervisor these layouts now refuse with a message that points to the `'archive'` layout.
  - The six `node_modules` cases in `endo.test.js` are skipped when `ENDO_BIN` is set without `ENDO_MANAGER_NODE`.
  - A new XS-only test checks the refusal, and a unit test in `host-tool-powers.test.js` checks the refusal message.
  - The changeset now says this.
- **saboteur:** the bare `catch {}` around the `treeKind` lookup in `host.js` now covers only `getFormulaForId`. A missing tree formula leaves `treeKind` unknown; any other read error is rethrown, naming the tree.
- **curator:** `getTreeLayoutRunningAs` is declared on `DaemonCore` in `types.d.ts`, and `host.js`'s JSDoc refers to it as `DaemonCore['getTreeLayoutRunningAs']`.
- **prover:** the "names a file outside the tree" test now checks that a failed incarnation records no `runningAs`.
  - The test fails if the layout is recorded before the worker runs and never cleaned up.
  - Reverting `c09443ee33` alone would not make it fail: a failed incarnation is cancelled, and the old cleanup removed the entry anyway. So the prover's claim that the original fix was untested-but-load-bearing was only partly right.
- **integrator:** the PR body now describes this as a partial slice of Phase 2 and lists what is still open:
  - Node and XS parity across npm, pnpm and Yarn trees
  - a pre-generated map running on an XS worker
  - `node_modules` layouts under the XS supervisor
  - pnpm workspace-link refusal
- **scribe:** I posted a summary comment covering the round-3 and round-4 pushes (issuecomment-5970504687).

**Should-fix item also addressed:** the `runningAs` cleanup is now registered before the first `await` in `makeFromTree`, so a cancel during the worker run no longer leaves a stale entry.

**Local checks (Node 24, Node supervisor):** `host-tool-powers.test.js` passed 4 of 4. The `makeFromTree*` tests passed 8, with 1 skipped (the XS-only test). `tsc` and eslint report no errors. I did not run the XS supervisor locally; CI's `test:rust` job covers it.

**Follow-ups (should-fix, not done):**
- Fold the `fix(daemon):` commits into the `feat` commits they correct, and drop the `(#1339)` suffix from the commit subject. Both need a history rewrite.
- `maybeLookupRoot` in `tree-layout.js` should tell a missing marker file apart from one it cannot read.
- Several comment-only notes from the panel remain.

**Local test quirk:** the linked-tree test fails if it is re-run without clearing `packages/daemon/tmp/` first, because the symlink already exists (EEXIST). This doesn't affect CI, which starts from a clean checkout.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/build-confined-application-makers-p2-makefromtree-20261003-gauntlet-fix-4.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 114 tokens (5280740 cached reads)
- Output: 26126 tokens
- Cost: $2.5146600000000006
- Wall-clock: 2347s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
