I fixed the repeated "journal fetch failed" warning in `scripts/jobs/approval-reconciler.sh`. One journal outage now produces one warning for the whole host and one recovery notice, instead of a warning from every repo's reconciler. The reconciler test suite passes 39/39 (including 5 new checks), and the change is pushed to `main2` as commit `2ca57e9fd1e`.

**What changed in `approval-reconciler.sh`:**
- **Capture:** the tick-start journal fetch now keeps its exit code and error text instead of discarding them.
- **Classify:** a failure counts as a temporary outage when the code is 75, the fetch timed out (124/137), or the error matches the shared offline patterns from `common.sh`. A definite fault (bad credentials, upstream gone, corruption, local fault) is never treated as an outage. It still warns on every tick, with its code and error text.
- **Host-scoped latch:** the first reconciler to see an outage warns once, with the exit code and a short error excerpt, and opens a latch at `$GARDEN_ROOT/.garden-state/approval-reconciler/journal-outage`. That location is shared by every repo's reconciler on the host. It also sets the host's existing shared journal-outage cooldown.
- **Quiet skips:** while that cooldown is active, a tick exits before trying the fetch. Once it expires, further failures in the same outage retry the fetch but log nothing.
- **Recovery once:** the first successful fetch logs "journal reachable again (outage since …)" and removes the latch.

The 15-minute cadence and the "skip the tick rather than guess the board state" rule are unchanged.

**Test:** I added case U to `scripts/jobs/test/approval-reconciler-test.sh`. It covers one warning on the first code-75 failure, a silent skip with no fetch while the cooldown is active, a quiet retry after it expires, exactly one recovery notice, and an authentication failure that warns every tick without setting the latch.

**Follow-ups:**
- When a second reconciler confirms that a new job post landed, its fetch still isn't classified. A failure there only marks the confirmation as failed and never logged the "journal fetch failed" warning, so I left it alone.
- The deployed checkout picks this up at the next rolling deploy.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/improve-approval-reconciler-fetch-latch.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 44 tokens (1813016 cached reads)
- Output: 15576 tokens
- Cost: $1.4767312
- Wall-clock: 251s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
