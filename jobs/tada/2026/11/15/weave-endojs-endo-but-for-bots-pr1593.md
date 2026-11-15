I wove PR #1593 onto the current `llm` tip. The PR now sits on the new frozen base `llm-48d6f3e` with the same change it had before, and it reports as mergeable with 6 changed files.

**What moved**
- **Base:** the PR moved from `llm-9a14ddf` to `llm-48d6f3e`, which is the current `llm` tip (`48d6f3e08bcc`). That branch already existed on the fork at exactly that commit, so the push to create it had nothing to do.
- **Head:** `build/daemon-agent-tools-make-http-tool` went from `d1f1cc58d9` to `eca953f20c`. I pushed it with a lease pinned to the old head SHA, then ran `gh pr edit --base llm-48d6f3e`, so the head and base changed together.

**Rebase**
- I used `git rebase --onto 48d6f3e origin/llm-9a14ddf`. It finished with no conflicts: the 8 commits `llm` gained since the old base don't touch any of the PR's paths.
- All 4 commits came across, including the two `fixup!` commits. I didn't squash them, so the review history stays as it was.
- The PR's diff against the new base is byte-identical to its diff against the old one. It touches the same 6 files: the changeset, `designs/daemon-agent-tools.md`, and `packages/agent-tools/` `README.md`, `src/types.ts`, `src/workspace.js` and `test/workspace.test.js`.

**Tests in `packages/agent-tools`**
- `test/workspace.test.js`, the file this PR changes, passes. The type check (`tsc --project tsconfig.test-types.json`) is clean.
- The full suite has one failure: `git-flow › makeGitTool derives the rewriter-facet catalog against a real Git cap`. It fails the same way when run on bare `llm-48d6f3e` without the PR, so it's already broken on `llm` (or in this host's setup), not something the PR causes. It throws in `assertNoExecutableRepoConfig` in `packages/git/src/native-git-backend.js`.
- To get a working install for the tests I used the node-modules linker with build scripts disabled, because the default yarn install failed here.

**Follow-ups**
- The old base branch `llm-9a14ddf` stays until the PR closes.
- I posted no PR comment because the job didn't ask for one.
- The `git-flow` failure on `llm` is worth a separate look; it is outside this PR's scope.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/weave-endojs-endo-but-for-bots-pr1593.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 30 tokens (886629 cached reads)
- Output: 4500 tokens
- Cost: $0.7101738
- Wall-clock: 137s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
