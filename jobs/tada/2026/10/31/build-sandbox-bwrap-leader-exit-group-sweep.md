I opened draft PR **endojs/endo-but-for-bots#1591**. It carries only the bwrap leader-exit fix (plus the optional cleanup-diagnostics commit), and its `sandbox-drivers` CI check passed on the first run.

**What's in it**
- **Base:** the frozen snapshot `llm-9a14ddf`. It already existed at the current `llm` tip (9a14ddf660), so I reused it rather than creating a new one.
- **Head:** branch `fix/sandbox-bwrap-leader-exit-group-sweep` on endojs/endo-but-for-bots, two cherry-picked commits that both applied cleanly:
  1. `fca70454ec` — the fix, from 17c61dd8e4 on #1504. When the bwrap leader process exits, the driver now SIGKILLs its whole process group before reporting the exit. This stops an orphaned inner bwrap from surviving. It changes `packages/sandbox/src/drivers/bwrap.js` (+19/−1).
  2. `2c3ab02213` — the diagnostics commit, from 2696934af6 on #1566. It raises the test's cleanup timeout to 10s and lists the state of any surviving process. It changes `packages/sandbox/test/bwrap.test.js`.
- The PR body follows the repo's PR template and includes the `garden-job` marker. No changeset is needed because `@endo/sandbox` is private.

**Verification**
- eslint passes on both files.
- Locally, `ava test/bwrap.test.js` passed 41 tests, but this host has no `bwrap`, so the live sandbox cases were skipped.
- On CI, the `sandbox-drivers` job (run 41208456439), which includes the flaky test, passed. When I stopped checking: 13 checks passed, 2 were still pending, 20 were skipped, and none had failed.

**Follow-ups**
- The automatic review chain (clean → panel → fix-loop → un-draft) should pick up #1591 from here.
- Once #1591 merges, red PRs on older frozen bases need a weave to pick up the fix, starting with #1571.
- After that, #1504 and #1566 still contain these commits and should be rebased so they drop them.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/build-sandbox-bwrap-leader-exit-group-sweep.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 34 tokens (993285 cached reads)
- Output: 6756 tokens
- Cost: $0.7778250000000001
- Wall-clock: 700s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
