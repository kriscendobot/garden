**Completion report: improve-deadline-nudge-ambiguous-push**

The deadline-nudge scanner now retries only push failures it recognizes as a lost race. Pushes that fail for an unrecognized reason are logged with their error output, cleaned up, and put off to the next tick. If they keep failing, the maintainer gets one alert. The full deadline-nudge test suite passes (61 passed, 0 failed), and the fix is pushed to `main2` as commit `41ad983ff42`.

**What changed in `scripts/jobs/deadline-nudge.sh`**
- **Push failures are now sorted:** a failed `commit_and_push` used to fall through to the "lost a race" retry unless it was a known rejection.
  - A recognized lost race (`cas`) still syncs again and retries, and it resets the ambiguous-failure count.
  - Known rejections (`definite-fail`, `server-reject`) are handled as before by `push_rejected`.
  - Anything else goes to a new `push_ambiguous` handler. There are two kinds:
    - **Unclassified:** the push failed with error output that no shared check recognizes.
    - **Unconfirmed:** the push reported success but did not show up on origin, either because the check fetch failed or because the push was silently lost.
- **What `push_ambiguous` does:**
  - Logs an `ERROR` line with the push's error output (or, for unconfirmed pushes, the check fetch's exit code) and adds it to the fault record.
  - Resets the private clone to `origin/journal2` and removes inbox writes, so the next tick recalculates every warning that is still due.
  - Puts the work off to the next tick without using up the retry budget.
  - Counts consecutive ambiguous ticks in a host-local file (`$GARDEN_STATE/deadline-nudge/ambiguous-push-streak`). When the count reaches `GARDEN_DEADLINE_NUDGE_AMBIGUOUS_ALERT_AFTER` (default 3), it sends one repair alert. That alert repeats only if the failure kind changes.
- **Recovery:** the next successful push resets the count and clears the alert with a recovery notice (`push_ambiguous_clear`).
- **Unchanged:** the "push stage exhausted" path now triggers only after repeated real lost races.

**Tests**
- `deadline-nudge-test.sh`: I replaced the old `/bin/false` push-failure case with three checks:
  - An unclassified failure is not retried, keeps its error output in the log, leaves the clone clean, and puts the work off.
  - Once the streak threshold is reached, exactly one alert fires and later failures stay silent.
  - The next successful push delivers the warning and clears the count and the alert.
- `deadline-nudge-race-push-stub.sh`: this test stub now prints git's real lost-race message (`[rejected] ... (fetch first)`). Without it, the stub's failure would now count as ambiguous rather than as a race.

**Follow-ups**
- The 16:22Z incident's error output was never recorded, so I couldn't tell what kind of failure it was. Once this is deployed, the alert and the `ERROR` log will show it. If it turns out to be a known kind of failure, add it to the `journal_push_is_*` checks in `common.sh`.
- Other users of `commit_and_push` that also lump unrecognized failures in with lost races were not changed.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/improve-deadline-nudge-ambiguous-push.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 40 tokens (1614237 cached reads)
- Output: 12635 tokens
- Cost: $1.2750194000000004
- Wall-clock: 2036s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
