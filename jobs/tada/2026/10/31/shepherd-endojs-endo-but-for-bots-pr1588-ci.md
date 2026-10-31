PR #1588 is now green: all 26 checks pass on head `d75874efbc` (10 more were skipped, none failed). I didn't change any code. Re-running the one failed job was enough.

**What was failing:** `cover (22.x, ubuntu-latest)` in run 41199884858. One test failed: `@endo/sandbox` › `bwrap › bwrap timeout and repeated cancellation reap process groups`, with "process group 12966 survived bounded cleanup" (`packages/sandbox/test/bwrap.test.js:266`, called from line 1099). Turbo then stopped with `Failed: @endo/sandbox#test:c8`. The other 147 packages passed.

**Why it's the known sandbox flake, not a problem in this PR:**
- The PR's diff touches only `packages/{confined-fetch,fetch,http-confine,exo-http-client}`, one daemon test file (`packages/daemon/test/http-client.test.js`), designs, a changeset and `yarn.lock`. Nothing under `packages/sandbox`.
- It's the same failure, at the same line, that the fleet has already cleared by re-running on #1543 (2026-10-31), #1573, and #1565/#1575 (2026-10-29/30). The #1543 shepherd also found it on `llm` pushes and other PRs' branches.
- The real fix is open as PR #1566, the bwrap runner-portability fix.

**What I did:** ran `gh run rerun 41199884858 --failed` and waited for it in the foreground. It finished `completed success`.

Verdict: `next: none`. It was a flake and cleared on re-run, so the halted gauntlet can resume. I posted no PR comment, since the job didn't authorize one, and left the PR as a draft. Until #1566 lands, this test will keep turning other PRs red.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/shepherd-endojs-endo-but-for-bots-pr1588-ci.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 26 tokens (929006 cached reads)
- Output: 3152 tokens
- Cost: $0.8327532000000002
- Wall-clock: 1359s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
