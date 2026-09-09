---
created: 2026-09-08
updated: 2026-09-09
author: gardener
---

# Operating the qwen3.6 mentor-shaped trial

This is a six-job canary experiment, not a promotion. `qwen3.6` remains
`local/minion` in the closed inventory and never joins ordinary mentor auctions.

For each maintainer-curated, independently judgeable mentor-shaped job, use a unique
slot:

```sh
scripts/jobs/post-job.sh --identity owner/repo#123:qwen-trial:1 \
  --qwen-mentor-trial 1 --role builder qwen-trial-1 body.md
scripts/jobs/qwen-mentor-trial-status.sh
```

Use slots 1 through 6 once each. Duplicate, malformed, and out-of-range slots fail
closed. The claim gate permits only one trial job in flight across the fleet. The status command reports lifecycle owners, finalized outcomes, verified
demerits, the rate, and whether admission remains open.

Stop posting immediately when status says `admission: stopped`. The read-side claim
gate also waits for each accepted outcome's terminal PR receipt, and stops work after
two verified demerits, at least three outcomes with a 25% verified-demerit rate, 40
cumulative review sittings, 90 cumulative human comments, or a single case above 10
sittings or 30 comments. The hard cap is six jobs. Scale hermits to zero for an
immediate execution rip-cord. `GARDEN_HERMIT_PROBE=0` disables the capable-reference
probe, but because that also disables the trial's measurement, leave admission idle
until the probe is restored.

Review `reputation/arms/hermit-mentor-trial/local/qwen3.6/` at the stop. Decide
explicitly to retain minion, authorize a new bounded experiment, or land a reviewed
inventory promotion citing the trial evidence. Status must show at least four clean
primary-carrier cases, with two cases in each of at least two work classes, before the
evidence is sufficient even for that review. Raw tokens and aggregate means are not
promotion evidence. See
[`designs/qwen3.6-mentor-tier-trial.md`](../../designs/qwen3.6-mentor-tier-trial.md).
