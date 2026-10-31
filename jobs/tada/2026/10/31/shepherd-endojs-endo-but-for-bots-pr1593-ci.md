PR #1593's CI is green again: 16 checks passed, 20 were skipped and none failed, on the new head `32ee836524`. The PR is still a draft.

**What was wrong:** the `lint` job's root TypeScript check (`yarn tsc -p tsconfig.json --noEmit`) failed on a test the PR added. At `packages/agent-tools/test/workspace.test.js:172`, the test "provisionWorkspaceTools combines http with a git-derived filesystem" passed a bare `Far('Git', { worktree })` stand-in as the `git` grant. The type checker didn't accept it as the expected Git capability type, so it failed with TS2322.

**Fix:** I added a `/** @type {any} */` annotation to that stand-in. The file's existing `grant()` helper uses the same convention for its inert stand-ins. No production code changed, and no test was skipped or removed.
- I committed it as `fixup! docs(agent-tools): record landed makeHttpTool, tighten changeset, pin composition`, aimed at `2e6118cff9`, the commit that introduced the test line (checked with git blame), so it can be autosquashed at merge.
- I first pushed it as `fd32dcc49b` aimed at the wrong commit (`c85ead3775`), then corrected the message and force-pushed `32ee836524` with a lease pinned to that SHA. The branch history has no other changes.

**Checked locally before pushing:**
- The root `tsc` run is clean. It needed `--max-old-space-size=8192` to avoid running out of memory here.
- Prettier is clean.
- ESLint shows no errors. One warning about an unused `eslint-disable` comment on line 4 was already in the base file.
- `workspace.test.js` passes all 14 tests.

**Follow-ups:** none. The PR stayed draft as the job asked, ready for the gauntlet or maintainer review. I didn't post a summary comment on the PR.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/shepherd-endojs-endo-but-for-bots-pr1593-ci.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 44 tokens (1371075 cached reads)
- Output: 6702 tokens
- Cost: $0.8833509999999999
- Wall-clock: 1921s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
