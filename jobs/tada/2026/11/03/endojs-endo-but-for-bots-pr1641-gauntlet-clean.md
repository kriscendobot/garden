## Clean stage: endojs/endo-but-for-bots #1641

**Result:** clean is done with no changes. CI is green at head `c3baa8c6e`, nothing was pushed, and the PR is still a draft.

**Coverage, run with `c8` on oros:**
- **`packages/exo-git/src/git.js`:** the two lines this PR changed are both exercised: `diff` at line 713 and `stashPush` at line 929. `designatorsToRepoPaths`' worktree-root refusal is also hit.
- **Other uncovered lines nearby:** these are all existing code the PR doesn't change, so I added no tests for them:
  - the non-array and non-string guards at lines 501–507
  - the `GitRef`-object arm of `head` at line 707
  - parts of the `stashPush` option handling at lines 923–927
- **`packages/agent-tools/src/json-tools/git.js`:** no uncovered statements. The new `DIFF_OPTIONS_PROPERTY` schema is checked by the new tests.
- **Scope:** I ran only `git-flow` and `git-tool` in agent-tools, and only the tests matching `stashPush` or `diff` in `packages/daemon/test/git.test.js` (9 passed). These are not whole-package figures.

**Dead code:** the change orphaned nothing.
- No references to the old `PATHS_PROP` or `CONFLICT_SIDE_PROP` names remain.
- `OPTIONS_PROP` is still used by other tools.
- No non-test code in `packages/` passes `paths` to `Git.diff` or `Git.stashPush`, so the new refusal of `.` breaks no in-repo caller.

**CI:** `ci-wait-merge.sh` returned rc 0 with 36 checks and 0 failed. The first bounded wait timed out (rc 4) on `test (22.x, macos-15)`, and the second reached green.

**For the panel or a later stage (not changed here):**
- **Local test failure:** `git-flow › makeGitTool derives the rewriter-facet catalog against a real Git cap` fails on oros with "Git repository identity changed…". It fails the same way with the PR's `git.js` change reverted to the base version, and CI is green, so the PR's source change isn't the cause.
- **Naming:** the PR renames two constants to `*_PROPERTY` and adds a third, while the rest of `git.js` still uses `*_PROP`. That leaves one file with mixed naming.

<!-- gauntlet-stage-result: clean=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1641-gauntlet-clean.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 2 on 1 host(s)
- Input: 76 tokens (2871748 cached reads)
- Output: 26404 tokens
- Cost: $2.3535096
- Wall-clock: 7412s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
