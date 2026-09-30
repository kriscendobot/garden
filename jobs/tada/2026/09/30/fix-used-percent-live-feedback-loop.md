## Completion report: fix-used-percent-live-feedback-loop

The feedback loop is fixed, and the fix is pushed direct to main2 as `8c7db642fe9`.

**The cause is as described in the job.** The meter writer (`_budget_publish_local_pool_once`) called `subscription_used_percent`. It then republished the result as `used_percent:` in `budget/live/<sub>/<host>`, stamped with a fresh `sampled_at_epoch`. `subscription_used_percent` reads those live files and the newest epoch wins. So the echoed value always outranked the ledger row it came from, and the pre-3d65d01c figure of 78 kept recomputing itself for both subscriptions.

**Fix (`scripts/jobs/usage-meter.sh`):**
- **Reader:** `subscription_used_percent` now skips live `used_percent` for anthropic pools. For those pools the value is always derived from the ledger or manual checkpoints, both of which are read directly, so skipping it loses nothing. Because the check goes by pool provider, the old untagged snapshots already in the journal are ignored straight away, with no journal cleanup needed. It also skips any live file tagged `used_percent_source: derived`, whatever the provider.
- **Writer:** anthropic snapshots now include `used_percent_source: derived`.
- **Codex percent pools** still use their live `used_percent`, which is observed independently from codex rate limits.

**Regression test (`scripts/jobs/test/subscription-used-percent-per-subscription-test.sh`, 10/10 pass):**
- Two subscriptions, each with a stale live value of 78 that is newer than any ledger row: one file untagged, one tagged derived.
- Fresh per-host ledger rows of 0.80 and 0.64. Each subscription reads its own value (80 and 64).
- A real meter publish writes 80 tagged derived, and reading it back still gives 80, so the value stays stable instead of drifting.
- Codex live percent is still read.
- The old assertion "fresher live used_percent still overrides" described the bug, so I replaced it.

**Other tests:**
- These pass: budget-live-percent-label, claude-stream-signal, quota-panel, budget-*-dedup, budget-snapshot-publish-retry, meter-journal-cutoff, subscription-budget-model and set-budget-pool-physical-cap.
- live-budget-admission (5 failures) and handler-budget fail both with and without this change, with the same failures on baseline main2. This change did not cause them, but they are unrelated failures that someone should look at.

**Follow-ups:**
- Once hosts deploy this commit, the claim gate should read about 80 for claude-endolin1 and about 64 for claude-endolin2, the newest ledger rows as of ~07:02Z; the job put the dashboards at about 80 and 65. The liaison's meter backstop can be retired after that is confirmed.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/fix-used-percent-live-feedback-loop.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 26 tokens (697635 cached reads)
- Output: 7572 tokens
- Cost: $0.7278629999999999
- Wall-clock: 1016s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
