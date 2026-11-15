I wove endojs/endo-but-for-bots PR #1591 onto the current `llm` tip, and the bwrap process-group fix came through unchanged. The rebase had no conflicts, but I did not run the sandbox tests locally because this checkout has no installed dependencies.

- **New base:** PR #1591 had been on `llm-9a14ddf`, 8 commits behind `llm`. It now sits on `llm-48d6f3e`, which matches the current `llm` tip `48d6f3e08b`. That frozen branch already existed on the remote, so I didn't create it.
- **Rebase:** both commits rebased cleanly with `git rebase --onto` and none were dropped:
  - `a543dbd3b9` fix(sandbox): sweep the bwrap process group when the leader exits
  - `ffc226fb58` test(sandbox): bound bwrap process-group cleanup for CI teardown latency

  The only change on the new base inside `packages/sandbox` is a one-line edit to `podman-policy.test.js`, which doesn't touch the PR's files.
- **Diff check:** comparing `llm-48d6f3e` with the new head shows only `packages/sandbox/src/drivers/bwrap.js` and `packages/sandbox/test/bwrap.test.js` (+73/−7). That is the same diff as before the weave.
- **Push:** I force-pushed with `--force-with-lease` (`2c3ab02213` → `ffc226fb58`) and moved the PR's base to `llm-48d6f3e` with `gh pr edit`. GitHub reports the PR as MERGEABLE, and it is still a draft.
- **Tests:** the new CI run on head `ffc226fb58` is the first check of the woven head.
- **Comments:** I didn't post a PR comment because the job body didn't authorize one.

Follow-up: once CI is green, the PR is ready for its gauntlet or un-draft. The old `llm-9a14ddf` base branch stays until the PR closes, when the conductor sweeps it.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/weave-endojs-endo-but-for-bots-pr1591.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 14 tokens (373990 cached reads)
- Output: 2570 tokens
- Cost: $0.548702
- Wall-clock: 58s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
