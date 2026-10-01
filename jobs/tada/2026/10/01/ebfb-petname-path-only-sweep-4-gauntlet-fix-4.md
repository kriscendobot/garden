## Fix round 4 — endojs/endo-but-for-bots#1390 (gauntlet `ebfb-petname-path-only-sweep-4-gauntlet`)

I applied all six must-fix items from the round-4 panel and pushed them to the PR head. CI is green: `ci-wait-merge` returned rc 0, with all 33 checks passing and none failing at head `e8097d6deb`.

**The round-4 verdict was not on the PR.** The panel-4 stage couldn't post it: its host's token was refused when posting reviews on endojs. It left the review text in a successor job pinned to this host, `ebfb-1390-post-panel-r4-sweep4-verdict`. I checked that no round-4 sweep-4 review existed, then posted the text word for word as a comment review. That successor job will now find the review and skip.

**Commits pushed** with `safe-push-pr-head.sh` (`fa544951bc..e8097d6deb`):
1. `7d62a995cd` **fix(spaces-util)**: the chat command line now uses one path grammar. Typed text such as `dir/foo` is split on `/` in every command (`adopt`, `resolve`, `endow`, `js`/`eval`, `invite`, host/guest creation), the same as `ls`/`show`/copy/move/send. Before this, a slash name passed to those commands was always refused. The tests now expect `['feature','foo']`. I also corrected the PR body's "never split it on `/`" claim.
2. `b696236a40` **fix(daemon)**: `makeUnconfinedFromTree` now checks the powers name, the result name, and the derived scratch name before it stages anything. Three new tests cover `powersName: ['@bogus']`, `resultName: ['@x']`, and a result path too long for a scratch name. Each one checks that no `scratch-*` entry is left behind.
3. `019bc0e63e` **docs(lal)**: the system prompt and primer examples now use path form.
4. `9de4366ecd` **fix(lal)**: `readText`, `writeText` and `editText` now accept `fileName` as an array of path components as well as a string, so they can reach a daemon directory. A new test, `test/fs-tools-directory.test.js`, runs them against a stub that uses the daemon's own `namePathFrom`.
5. `5b18ba33e1` **fix(agent-tools)**: `LookupPowers.lookup` now takes `string[]`, and `makeDaemonEvaluate`'s powers type is taken from `EndoHost['evaluate']` instead of being hand-copied.
6. `e8097d6deb` **docs(changeset)**:
   - Restored the note that `NameShape`/`NamePathShape` are now exported.
   - Explained that the argument guards accept a string only so the method can raise the retry hint.
   - Documented the agent-tools change: a string `'a/b'` is now one name, not a path.
   - Bumped the 0.x packages `@endo/lal`, `@endo/agentry`, `@endo/sandbox` and `@endo/agent-tools` to `minor` instead of `major`, so none of them jumps to 1.0.0. The panel asked whether that jump was intended and nobody had confirmed it, so the maintainer should check this choice.

**Local checks before pushing:**
- Tests passed: chat executor (69), lal (24), and all five daemon `makeUnconfinedFromTree` cases.
- Type checks were clean for daemon, lal, agent-tools, agentry, chat and the repo-root `tsc`.
- Prettier is clean, and ESLint reported only warnings that were already there.

**CI:**
- The first run failed three jobs:
  - Both macOS test legs failed on `daemon-teardown › an orphaned daemon shuts itself down instead of lingering`. This PR doesn't touch that test, and it fails the same way on three unrelated PRs (runs 36918843472, 36916382867 and 36913967827).
  - `test-hermes` failed at its "Install dependencies" step.
- I re-ran the failed jobs and they all passed.
- I posted a fix-summary comment on the PR (issuecomment-5941850035).

**Follow-ups:**
- The should-fix items were not addressed this round: the stylist's renames (`ctx`, `toPetNamePath`, and others), the `→` glyphs, the design-doc divergence table, regrouping the 80-commit history, and more edge-case tests.
- The macOS `daemon-teardown` orphan test is flaky across PRs. It may deserve its own fix job.
- The other gauntlet still open on this PR, `sweep-3`, asked for the opposite of item 1 (wrap names as `[name]`). Item 1 follows the newer round-4 review, so the next panel may flag the split again.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/ebfb-petname-path-only-sweep-4-gauntlet-fix-4.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 180 tokens (10474634 cached reads)
- Output: 36359 tokens
- Cost: $4.005346800000001
- Wall-clock: 5260s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
