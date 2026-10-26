---
orchestration-failed: true
---
orchestration-failed: true

# Clean stage report: endojs/endo-but-for-bots#1569

CI came back red (`ci-wait-merge` rc 3) at the new head `c497ec6efd`, so this stage failed. None of the red checks are in packages the PR touches.

**Coverage pass.** I reviewed the structured `Git.merge` / `mergeText` change in `packages/git/src/native-git-backend.js` and the `packages/exo-git` files. Two paths in the native merge had no tests:
- `readHeadRef` when HEAD is detached.
- The rethrow when a merge fails without leaving a `MERGE_HEAD` (for example `--ff-only` on branches that have diverged).

I added the test `NativeGitBackend.merge reports a detached head and rethrows non-conflict failures` to `packages/git/test/native-git-backend.test.js`. Locally the merge tests pass, prettier is clean, eslint shows nothing new (two old warnings), and the repo-root `tsc` reports no errors in that file. The change didn't leave any dead code behind. I pushed it with `safe-push-pr-head.sh` as commit `c497ec6efd` (`f866574b0a..c497ec6efd`, adding to the branch without rewriting it).

**CI result: rc 3, red.**
- **`test (22.x/24.x, ubuntu-latest)`, `sandbox-drivers`, `cover (22.x/24.x, ubuntu-latest)`:** all fail in `@endo/sandbox` bwrap tests:
  - `prlimit nproc cap is enforced inside the slice`, with `/bin/sh: 1: ulimit: Illegal option -u`.
  - `bwrap parent death leaves no owned process group`, which finished without running any assertions.

  This is a runner-environment problem, not something in this PR. It also failed the same way on the earlier head `f866574b0a`, before my push. Open PRs #1566 ("make bwrap tests runner-portable") and #1542 address it.
- **`test (24.x, macos-15)`:** `@endo/floot` `test/factory-system-prompt.test.js` exited 1. This is also outside the PR's packages and looks like a flake; I did not rerun it.
- `lint` and `test (22.x, macos-15)` passed.

**Follow-ups**
- Once #1566 or #1542 lands, weave #1569 onto a base that includes it, or re-run CI after the base moves. Until then every ubuntu leg will stay red.
- Rerun the macOS floot leg to confirm it's a flake.

<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1569-gauntlet-clean.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 62 tokens (2166652 cached reads)
- Output: 10030 tokens
- Cost: $1.2325063999999997
- Wall-clock: 2705s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
