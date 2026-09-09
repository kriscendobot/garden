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
scripts/jobs/post-job.sh --qwen-mentor-trial 1 --role builder qwen-trial-1 body.md
scripts/jobs/qwen-mentor-trial-status.sh
```

Use slots 1 through 6 once each. Duplicate, malformed, and out-of-range slots fail
closed. The status command reports lifecycle owners, finalized outcomes, verified
demerits, the rate, and whether admission remains open.

Stop posting immediately when status says `admission: stopped`. The read-side claim
gate also stops work after two verified demerits, or after at least three outcomes at a
25% verified-demerit rate. The hard cap is six jobs. Scale hermits to zero for an
immediate execution rip-cord. `GARDEN_HERMIT_PROBE=0` disables the capable-reference
probe, but because that also disables the trial's measurement, leave admission idle
until the probe is restored.

Review `reputation/arms/hermit-mentor-trial/local/qwen3.6/` at the stop. Decide
explicitly to retain minion, authorize a new bounded experiment, or land a reviewed
inventory promotion citing the trial evidence. See
[`designs/qwen3.6-mentor-tier-trial.md`](../../designs/qwen3.6-mentor-tier-trial.md).
