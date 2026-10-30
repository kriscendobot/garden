minion.town CI is still on the self-hosted runner. GitHub refused the hosted test runs on billing again on 2026-10-30, so I switched back and rescheduled the move for 2026-10-31T22:10Z.

**What happened**
- I set `CI_RUNS_ON` to `"ubuntu-latest"` and dispatched `ci-runner-selftest.yml` (run 41135758294). It passed, but on the self-hosted box: that workflow hard-codes `[self-hosted, ci-minion-town]` and ignores `CI_RUNS_ON`, so it is no hosted probe.
- I then reran a recent `test.yml` run, 41030164479 (`build/shell-captp-session`). Its jobs went to `ubuntu-latest` and failed without starting. The annotation was: "The job was not started because recent account payments have failed or your spending limit needs to be increased." The billing block has not cleared yet.

**Reverted**
- I deleted `CI_RUNS_ON`, so CI and the deploy are back on the self-hosted default. Only `PROBE_RUNS_ON` is left set, as it was before.
- I reran 41030164479 on the self-hosted runner. All four jobs passed (changes, test, Claude harness arm64 and amd64), so the probe left nothing red.
- No other runs were triggered while the variable was set.
- The `ci.minion.town` runner is untouched.

**Rescheduled**
- One-time schedule `minion-town-ci-runner-to-hosted-202610-retry1` fires at 2026-10-31T22:10:00Z. Its body uses the `test.yml` rerun as the probe and explains how to read the billing refusal.
- Further retries will be numbered `retry<N+1>`.

**Skill fix (pushed to main2)**
- `skills/minion-town-ci-runner-switch/SKILL.md` § To GitHub-hosted now says to probe with a `test.yml` rerun and check for the `ubuntu-latest` label. It warns against using the self-test as the probe and shows where the billing refusal appears.

**Follow-ups**
- I didn't message the maintainer, because the job only asks for that once the move succeeds.
- If the block lasts much past this billing cycle, the "recent account payments have failed" wording may mean a payment problem rather than just a usage cap. The maintainer would need to check that in billing settings.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/minion-town-ci-runner-to-hosted-202610.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 34 tokens (952154 cached reads)
- Output: 5658 tokens
- Cost: $0.7232948000000001
- Wall-clock: 1112s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
