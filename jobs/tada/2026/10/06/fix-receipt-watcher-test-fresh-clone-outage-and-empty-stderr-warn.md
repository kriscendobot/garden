## Completion report: fix-receipt-watcher-test-fresh-clone-outage-and-empty-stderr-warn

`scripts/jobs/test/receipt-watcher-test.sh` now passes all 20 checks (it failed 2 before; I ran it twice after the change). The fix is on `main2` as **bc3fbff12df**. The two failures had different causes, and the second one hid a real bug in the watcher.

**1. "fresh-clone outage lost its warning/cooldown": the test was out of date.**
- Since commit 08966639b0e, an offline clone exits with code 75 (EX_TEMPFAIL, "temporary failure"). The test still looked for the old code, 1.
- The watcher's warning and cooldown were unchanged, so the check now accepts code 1 or 75. It still requires both the warning and the cooldown marker.

**2. "empty-stderr prerequisite exit lost its WARN": broken by 9090b2685be.**
- That commit added a fleet `git` wrapper (`scripts/jobs/bin/git`) that comes before the test's fake `git` on PATH.
- The fake `git` simulates an outside interruption by killing its parent process. It was killing the wrapper instead of the watcher's setup step (the prerequisite subshell). The fake now skips past the wrapper and kills the setup step itself.

**The watcher bug this exposed (`scripts/jobs/receipt-watcher.sh`):**
- Every setup step exits still holding its repo lock. On the next tick, the lock code reports that it "cleared dead-holder metadata" for the old holder, and that line lands in the captured error output.
- So in production the captured output was almost never empty. The "no diagnostic output, check disk space and process limits" warning could practically never fire. Failures instead pointed to "stderr above", which held only that lock line.
- The watcher now treats output that contains only that lock line as empty. It still prints the line, then gives the warning with "no diagnostic captured". Any other content still takes the "see prerequisite stderr above" path, so the cooldown and warning behavior is no weaker.

**Checks:** no new shellcheck findings in either file. I removed my temporary bisect worktree and test temp directories. My inbox was empty.

**Follow-up worth considering:** the setup step never releases its repo lock, so a stale holder record is left behind after every tick. Other callers of the same setup functions (`ensure_clone`/`sync_clone` in subshells) probably produce the same noise. Making `ensure_clone` release the repo lock would remove it at the source. I left that out because it touches shared locking code used well beyond this watcher.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/fix-receipt-watcher-test-fresh-clone-outage-and-empty-stderr-warn.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 50 tokens (1730600 cached reads)
- Output: 13238 tokens
- Cost: $1.2105360000000005
- Wall-clock: 268s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
