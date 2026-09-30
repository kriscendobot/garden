The fork-watch provisioner now logs one warning for a shared inconclusive GitHub condition instead of two warnings per fork every minute. The change is pushed to `main2` as commit `64dde114ce6`. The full provisioner test suite passes, 73 of 73, including a new case L that covers this behavior.

**What changed** (`scripts/jobs/fork-watch-provisioner.sh`)
- **No per-fork logging:** the upstream check no longer logs anything itself. When a check is inconclusive, it sorts the output into one of five classes: `rate-limit`, `auth`, `server`, `network` or `unclassified`. That replaces the old per-fork warnings (the two lines the job cited at :221 and :301).
- **Host-wide conditions stop probing:** the first inconclusive probe in a tick stops all further probes for that tick. It also starts a local cooldown on this host, keyed by the class. It lasts 300s by default, is capped at 3600s, and is set with `GARDEN_FORKWATCH_INCONCLUSIVE_COOLDOWN_SECS`. Later ticks skip probing silently until the cooldown expires, and an existing cooldown is never extended. Setting it to `0` keeps the one-warning-per-tick behavior without recording a cooldown.
- **One warning per cooldown:** only the tick that starts a cooldown logs a warning. It names the class, the first error line, and every fork that was deferred.
- **Forks are still left alone:** a deferred fork is not armed, tombstoned or retired, same as before.
- **Repo-specific refusals:** a plain 403 or 451 is treated as a problem with that one repo. It gets its own cooldown and defers only that fork; the other forks keep being probed.
- **One bad fork can't block the rest:** the fork that triggered the last host-wide cooldown is probed last on the next attempt.
- **Two decisions I made beyond the spec:**
  - A tick cut short by an inconclusive condition no longer retires armed forks, even one whose 404 was confirmed before the stop. Retirement waits for a clean tick. I did this because a partial read failure should not tear down a live watch.
  - An inconclusive result on the second check of a 404 now goes through the same cooldown, instead of logging its own warning.

**Other files**
- `scripts/jobs/test/fork-watch-provisioner-test.sh`: new case L covers one probe and one warning per condition, silent skipping while a cooldown is active, probing resuming after it expires, per-fork 403 cooldowns, halted ticks not retiring forks, and the `0` setting. The existing test runs default the cooldown to `0`.
- `designs/auto-provision-fork-watchers.md`: documents the cooldown.

**Follow-up: the test can fail on a garden host for reasons unrelated to this change**
On a garden host, this test only passes with `GARDEN_FETCH_MAX_AGE_OVERRIDE=0` set. Without it, the garden git wrapper serves the test's own `git fetch` of its throwaway journal from its fetch cache. The test then reads a stale branch tip and falsely fails cases G through L. That is environmental, not caused by this change. The test (or its runner) should set the override itself.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/improve-fork-watch-inconclusive-backoff.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 36 tokens (1429653 cached reads)
- Output: 19310 tokens
- Cost: $1.3881865999999998
- Wall-clock: 239s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
