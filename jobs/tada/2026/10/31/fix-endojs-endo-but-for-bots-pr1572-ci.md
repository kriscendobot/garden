PR #1572's red `cover (22.x/24.x)` checks aren't caused by the PR, so I didn't push any code change to it. The fix for the failure is PR #1566, which is still an open draft. I diagnosed the failure, checked the PR's own packages locally, and posted the findings on the PR.

**Cause:** Both cover legs fail in `@endo/sandbox:test:c8` on two bwrap tests:
- `prlimit nproc cap is enforced inside the slice` fails with `/bin/sh: ulimit: Illegal option -u` on the CI runner's shell.
- `bwrap parent death leaves no owned process group` ends with "Test finished without running any assertions".

PR #1572 doesn't touch `packages/sandbox`, and the same failure shows up on unrelated branches. #1566 makes these tests work on the CI runner; its checks were passing.

**Local checks at head `15507c93bf`:** CI stopped at the sandbox failure, so it never ran the PR's own packages (`@endo/daemon` and `@endo/exo-git`). I ran them myself in an isolated project checkout:
- **Type checks:** `tsc` and `tsc -p tsconfig.test-types.json` are clean in both packages, including the new type tests.
- **Daemon tests:** `ava test/endo.test.js --match '*provideGit*'` passed 8 of 8, including the new read-only tests.
- **exo-git tests:** `ava` passed 59 of 59.

**Comment posted:** https://github.com/endojs/endo-but-for-bots/pull/1572#issuecomment-6539305872. It gives the diagnosis and the local results, and notes one unrelated change in the PR.

**Follow-ups:**
- **Land #1566:** it needs review and a merge. There's no board job for it yet. After it lands, rebase this stack onto it (base `build-daemon-git-next-steps-structured-stash-9e885d3`) and the cover checks should pass. At my last check `test` and `sandbox-drivers` were still pending; they'll probably hit the same bwrap failure.
- **Stray mode change:** the PR's commit changes `packages/relay-server/src/index.js` from 100644 to 100755, probably because a local install made the bin executable. It has nothing to do with the PR, so the gauntlet's clean step should revert it before the PR leaves draft.

No garden files changed, so nothing was pushed to `main2`.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/fix-endojs-endo-but-for-bots-pr1572-ci.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 46 tokens (1459429 cached reads)
- Output: 7619 tokens
- Cost: $0.9673138000000001
- Wall-clock: 244s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
