CI on kriscendobot/minion.town#118 is green again. The failure was a flaky test unrelated to this PR, so I re-ran the failed job and didn't change any code.

**Why it was red:** in run 36275725649 at head `e71dd2e12`, one test failed in the `test` job. It was `test/endo-daemon-integration.test.ts` › "B2 tool layer: writeText -> readText -> restart -> read (self-healing)". The failing check was at line 212 of that file: `read2.isError` came back `true`. That read happens right after the test restarts the Endo daemon on the same state directory, when the service has to reconnect and retry.

**Why I called it a flake:**
- The PR only touches `src/web/guest-web-router.ts`, `test/web/guest-web-http.test.ts` and `deploy/aws/scripts/deploy-app.sh`. None of these are in the daemon or tool code this test exercises.
- The other 4 daemon tests in that file passed, and this workflow passed on `main` and every other branch in the recent runs.
- The failing step is a timing-sensitive reconnect right after the daemon restarts.

**What I did:** ran `gh run rerun --failed` and waited for it to finish. The `test` job now passes, and both Claude harness jobs (amd64, arm64) had already passed. The PR is still a draft and mergeable.

**Verdict:** `next: none`. If this test goes red again after a daemon restart, it's worth giving someone a job to make the reconnect-and-retry path reliable.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr118-shepherd.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 16 tokens (394891 cached reads)
- Output: 1952 tokens
- Cost: $0.5065702
- Wall-clock: 169s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
