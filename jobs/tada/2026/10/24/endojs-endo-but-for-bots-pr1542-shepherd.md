**PR #1542 shepherd: CI is green.**

The failure was a flake, not a bug in the PR. Rerunning the failed job turned CI green; I pushed nothing.

**What was failing:** on run 40072659149 (head `64c61697f5`), `test (22.x, macos-15)` failed in `@endo/claude-sandbox#test`. The log only says "Uncaught exception in test/restore-context.test.js … exited with a non-zero exit code: 1", with no stack trace.

**Why it's a flake:**
- The PR only changes `packages/sandbox` bwrap code (the driver, its tests and a changeset). The bwrap driver never runs on macOS, and `restore-context.test.js` doesn't use it.
- The last change between `77845960f9` (green) and `64c61697f5` (red) only rewrites type-annotation imports.
- The same restore-context failure appears on macOS legs of two unrelated branches: run 40064188261 (`gardener/fu-design-recursive-dynamodb-capabilities-1`) and run 39766349850 (`build/sturdyref-shim-first-wins`).

**What I did:**
- Ran `gh run rerun 40072659149 --failed`. The run then finished `success`.
- Confirmed every check on `64c61697f5` is now SUCCESS or SKIPPED.
- Saved a memory note (`endo-claude-sandbox-restore-context-macos-flake.md`) so future shepherds rerun this failure instead of debugging it.
- I posted no PR comment, since the job body didn't authorize one.

**next: none.** The PR is still a draft. The halted gauntlet can resume (panel → un-draft), and that unblocks #1537 and #1538 in the sandbox-shell stack.

**Follow-up (optional):** someone could find out why `restore-context.test.js` sometimes throws an uncaught exception on macOS. It's a pre-existing problem shared across PRs, not part of #1542.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1542-shepherd.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 28 tokens (924991 cached reads)
- Output: 4143 tokens
- Cost: $0.7987542000000001
- Wall-clock: 508s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
