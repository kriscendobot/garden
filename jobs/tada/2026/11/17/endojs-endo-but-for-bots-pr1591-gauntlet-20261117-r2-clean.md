# Clean stage report: endojs/endo-but-for-bots PR #1591 (gauntlet r2)

The clean stage is done. I added tests for the one untested branch in the PR, pushed them, and CI is green at the new head `91d79c5672`.

**Starting state:** the PR (draft, open, head `endojs:fix/sandbox-bwrap-leader-exit-group-sweep`) had CI green at `31aeb19c01`. Earlier rounds had already tested the exit-sweep paths (ESRCH is tolerated, other errors are passed on, the anchor is swept on a normal exit).

**Coverage gap:** in `packages/sandbox/src/drivers/bwrap.js`, the new code that reads the daemon's own process identity from `/proc/<pid>/stat` had no test for its two failure branches:
- the file can't be read (`could not read /proc/<pid>/stat: …`);
- the stat line is malformed (`could not read daemon process identity`).

**Change:** commit `91d79c5672`, "test(sandbox): cover bwrap daemon /proc identity read failures (#1591)", touching only `packages/sandbox/test/bwrap.test.js`.
- It adds a small `makeStatOverrideFs` helper, which feeds the driver a fake stat file through the existing `fs` injection point.
- It adds two tests, one per failure branch. Each checks the error message and that no child process is started. Both are skipped on non-Linux, as the code is.
- Locally, the new tests and the existing exit-sweep tests passed (5/5). Prettier and eslint are clean on the file. I didn't find any dead code left behind by the change.

**Push:** `safe-push-pr-head.sh` in advance mode moved the head from `31aeb19c01` to `91d79c5672`.

**CI:** `ci-wait-merge.sh --no-merge` returned rc 0: 35 checks, 0 failed, GREEN.

**Follow-ups:** none.

<!-- gauntlet-stage-result: clean=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1591-gauntlet-20261117-r2-clean.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 40 tokens (1299359 cached reads)
- Output: 6298 tokens
- Cost: $0.8731598
- Wall-clock: 776s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
