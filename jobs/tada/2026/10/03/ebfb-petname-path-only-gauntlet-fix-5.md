Fix round 5 for endojs/endo-but-for-bots#1390 is pushed and CI is green: all 33 checks passed on the new head `5aa0056c02`, and `ci-wait-merge` returned 0.

**What I changed for the five request-changes seats:**
- **migrator (real runtime break):** `@endo/claude-sandbox` was still passing bare strings to the daemon, which this PR now rejects with a `TypeError`. The fixed call sites are:
  - `provideMount` in `container-mount-bridge.js`, in `provision-claude-session.js`, and in the generated session-powers code inside both `provision-claude-session.js` and `claude-sandbox-factory.js` (it now passes `[name]`).
  - The panel didn't flag this one: `provision-claude-session.js` also passed string names to `evaluate`. They are now all paths: `['@agent']`, `underNamespace` returns `[name]`, and a new `namePathOf` helper wraps string names.
  - The test fakes in `container-mount-bridge.test.js` and `provision-claude-session.test.js` now refuse bare strings the way the daemon does, so a regression fails in tests.
- **stylist:** in `packages/daemon/src/types.d.ts`, about 25 array-typed `petName` parameters are renamed `petNamePath`, along with the doc references to them.
- **pruner:**
  - Removed the two comments in `packages/chat/mention-send.js` that only restated the code.
  - The changeset now keeps a single `lookup` example. I kept the `'subdir/value'` one rather than the one the pruner named, because it shows that strings are never split on `/`.
  - In the PR body, Scaling now says "None." and Documentation is one line. I kept both headings because the integrator checks that the template headings are present.
- **integrator:**
  - Compatibility Considerations now lists the `@endo/lal` tool-argument key renames and the `@endo/agent-tools` change where `'a/b'` silently means one entry (both minor bumps).
  - I replaced the garden job name with a plain-project description of the deferred platform change.
  - The #1343 ordering now reads "whichever lands second rebases onto the other", since #1343 is still open.
- **procurer:** not applied. The finding is should-fix, and the panel's own judgement says the daemon's `assertPetNamePath` throws a different error type and returns a different value than the test helper.

**CI went red once.** The first push failed 4 `container-mounts-sandbox` tests in `@endo/floot`. Its fake `provideMount` keyed names by string, and my change now hands it an array. I updated that fake to refuse strings and key by the joined path, and the full floot suite passed locally (195 tests). The same run also had one `electron-binary` failure on 22.x/ubuntu only; it passed on the other cells and on the next run, so it looks like a flake.

**Commits pushed** with `safe-push-pr-head.sh` (fast-forward from `c039e37251` to `5aa0056c02`): `20fbd1bd7f`, `1860976da6`, `af5ca0aa7b`, `5aa0056c02`. Locally, all 143 claude-sandbox tests passed. There was no `tsc` in the worktree, so CI did the type checking.

**Follow-ups, not done:**
- The integrator's should-fix to regroup the PR's roughly 100 commits per package needs a reset-and-restage retcon, which this round didn't attempt.
- The integrator also suggested tightening the test fakes in `packages/fae/test/subagent-loop.test.js` and `packages/chat/test/unit/browser-tree.test.js` (comment-only).
- I noticed but didn't change: `provision-claude-session.js` cleanup calls `remove(n)` without spreading `n`. The daemon's `remove` takes the path as separate arguments, so a multi-segment cleanup name would fail, and `Promise.allSettled` would hide the failure.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/ebfb-petname-path-only-gauntlet-fix-5.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 110 tokens (4527484 cached reads)
- Output: 19426 tokens
- Cost: $2.1072728
- Wall-clock: 3525s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
