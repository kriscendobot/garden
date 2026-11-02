The worked end-to-end reference flow is now a regression test in draft PR https://github.com/endojs/endo-but-for-bots/pull/1638, and CI is fully green on head `72d4ef945`. A prior attempt had already opened the PR (commit `89ca89a11`, carrying this job's marker) before it was reaped. I checked that work again rather than redoing it, and made one fix.

**The test:** `packages/agent-tools/test/git-reference-flow.test.js` sends a prompt to a real `PiAgent` with a scripted model. The agent then:
- fetches and branches off the advanced `origin/llm`
- edits through the mount tools
- runs status, diff and commit
- has a push to `llm` refused under the Agent MVP policy, then pushes `agent/greeting`

A separate reviewer clone inspects the pushed ref through the `filesystemAt`-backed history tools. `advanceRemoteMain` in the fixture is generalized to `advanceRemoteBranch`, and existing callers don't change.

**The fix:** the earlier commit failed the `no-inline-import-jsdoc` gate, so I pushed `72d4ef945`, which moves the `ava` type to a top-of-file `@import` in both test files.

**Verification:**
- **Tests:** the new test and the four suites sharing the fixture pass locally (20 tests).
- **Gates:** the pre-push probes pass against the base. Prettier passes on both files, and eslint reported no findings.
- **Full gate and types:** I didn't run the full pre-push gate or repeat the prior attempt's `tsc` check; CI `lint` passed on the new head.
- **Mutation checks:** allowing `llm` in the policy fails the test, but at the `inspect` bounds assertion. Disabling the push check in `git-remote.js` fails it at the "pushing to the protected base is refused" assertion, so that assertion does real work. Both mutations are reverted.

**Things to know:**
- **Base:** the adapter PR isn't up yet. `build/daemon-git-tool-paths` has no PR because its open-PR relay job is still waiting in `todo`, so there was nothing to rebase onto. #1638 stays on `llm-48d6f3e`, which is still the current `llm` tip. That branch only changes `diff` and `stash` path handling, which this flow doesn't use.
- **Scope:** the job's flow, which I followed, leaves out the "shell build step" listed in the design's Phase 3 row. The job also cites § Open Work, but the flow is actually in § Phased Build Plan.
- **Stale PR text:** the PR body doesn't mention the source-level mutation check or the gate fix.
- **Tooling problems:**
  - `ensure-pr.sh --find-only` hung twice, so I confirmed the PR from its marker on GitHub instead.
  - `ensure-project-worktree.sh` failed its branch probe several times in a row while a plain `ls-remote` worked, then passed on a later run; its probe discards stderr, so the cause is unknown.
  - The checkout also needed `GARDEN_REPO_GIT_TIMEOUT=900` on this host.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/daemon-git-end-to-end-reference-flow-build.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 2 on 2 host(s)
- Input: 126 tokens (5381834 cached reads)
- Output: 38869 tokens
- Cost: $3.3835147999999995
- Wall-clock: 3551s
- Model(s): claude-opus-5-5 ×2

<!-- garden-usage-end -->
