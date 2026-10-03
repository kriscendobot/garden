## Gauntlet fix round 6: endojs/endo-but-for-bots PR #1390

I applied the round-6 panel's must-fix items and pushed them to `build/pet-name-path-only` (`5aa0056c02` → `6bbec13642`). CI finished green: 33 checks, 0 failed, and `ci-wait-merge` returned rc 0. I skipped one item, the commit regrouping (below).

**Commits pushed:**
- **`0d4bd188f1` fix(daemon), from breaker:** `makeDirectory` in `directory.js` now checks the name before it creates anything. Before this, `E(guest).makeDirectory('notes')` and `E(host).makeDirectory(['@main'])` left two orphan formulas behind when they were refused. A new test in `endo.test.js` confirms both calls are refused and the formula count does not change.
- **`83e7db8ba4` refactor(daemon), from stylist:** renamed the parameter `guestName` → `guestNamePath` in `formulateInvitation` and `makeInvitation` in `manager.js`, and in `types.d.ts`. The stored formula still uses the key `guestName`.
- **`f00824be2c` refactor(claude-sandbox), from stylist:** renamed `toPath` → `namePathOf` in `claude-sandbox-factory.js`, so the package uses one name for this helper.
- **`0137764655` test, from procurer and pruner:**
  - The test fakes in the chat `share-modal` test and the claude-sandbox `provision-claude-session` test now use the daemon's own `namePathFrom` instead of local look-alike checks.
  - In `pet-name.test.js` and `agent-tools/test/daemon.test.js`, the comment that listed example characters now says why it matters.
- **`6bbec13642` docs, from integrator:**
  - The examples in the lal and fae architecture docs (`LAL-ARCHITECTURE.md`, `FAE-ARCHITECTURE.md`, `COMPARISON-FAE-LAL.md`) and in `claude-sandbox/DESIGN.md` now pass names as arrays.
  - The code snippets in `designs/daemon-form-request.md` and `designs/daemon-value-message.md` now match the current API, with a note about the change.

**PR description edits:**
- The Compatibility section now lists all four packages with breaking changes, adding `@endo/sandbox` and `@endo/agentry` (integrator).
- I deleted the "Scaling Considerations: None." section and listed the specific updated docs under Documentation Considerations (pruner).

**Checks run locally:** the new and related daemon tests, `pet-name.test.js`, and the agent-tools, claude-sandbox and chat tests all pass. The daemon typecheck (`tsc`) and eslint report no errors. To run the daemon tests I had to rebuild `better-sqlite3` for Node 22 inside this job's own project checkout.

**Not done:**
- **Commit regrouping (integrator, should-fix):** the panel asked to squash the PR's ~100 commits into about one per package or concern. That means rewriting the branch's history, which doesn't belong in a fix round of follow-up commits. It's a job for the maintainer or a separate cleanup job before merge.
- **Coordination line about PR #1343 (integrator, comment-only):** I kept the line in the description because #1343 hasn't merged yet. Remove it once one PR is rebased onto the other.

The driver posts panel round 7 next.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/ebfb-petname-path-only-gauntlet-fix-6.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 108 tokens (4334092 cached reads)
- Output: 18529 tokens
- Cost: $2.014086399999999
- Wall-clock: 2427s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
