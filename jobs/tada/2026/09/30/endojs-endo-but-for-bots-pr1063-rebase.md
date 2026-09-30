I rebased PR #1063 onto the current upstream `endojs/endo` master and moved its merge base forward to match. The rebase had no conflicts, and the affected tests pass locally.

- **Target:** the PR's old base `master-8c402ee` was a commit on upstream `endojs/endo` master, so I read "upstream master" as that repo, whose tip is now `95522a2873`. The fork's own `master` (`6ee3fda77b`) has 77 fork-only commits, so I didn't use it.
- **New base:** I created the frozen base `master-95522a2` at `95522a2873` (86 commits ahead of the old base) and pushed it to endojs/endo-but-for-bots. I also changed the PR's `base` field to `master-95522a2`.
- **Head:** the PR's single commit, "fix(harden): reject resizable TypedArrays", is rebased and force-pushed with lease to `fix/1062-typedarray-preventextensions`. The head went from `3369658f2c` to `d6fdeef59a`.
- **Conflicts:** none. None of the 86 upstream commits touch `packages/harden/make-hardener.js`, `packages/ses/src/commons.js` or `packages/ses/src/make-hardener.js`. The PR still changes the same 6 files (+359 lines), and GitHub reports it as MERGEABLE.
- **Tests:**
  - `packages/harden`: `yarn test` passed all 35 tests.
  - `packages/ses`: the full ava run had 556 passed, 2 known failures and 2 skipped. `yarn lint:types` (tsc) is clean.
- **PR comment:** I posted the summary on the PR: https://github.com/endojs/endo-but-for-bots/pull/1063#issuecomment-5919380801

The old base branch `master-8c402ee` is still there; the conductor deletes old base branches when a PR closes. There are no other follow-ups.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1063-rebase.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 30 tokens (795707 cached reads)
- Output: 5468 tokens
- Cost: $0.6711734
- Wall-clock: 98s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
