Implemented and pushed `5a0bc3f435` to `main2`.

- Automatic routing now uses durable `tier: minion` with `model: gpt-5.6-terra`.
- Disabled Mystic/Kimi claiming and nonzero worker activation.
- Added safe stale-Kimi requeue to Codex/minion.
- CAS-migrated 235 queued/parked jobs; updated the weekly effectiveness schedule.
- Verified focused routing, scheduler, and model-routing tests.

Follow-up: normal fleet upgrade monitor will detect the new `main2` commit.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/garden-kimi-credit-exhaustion-routing.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s) (1 unmetered)
- Input: 0 tokens (0 cached reads)
- Output: 0 tokens
- Cost: $0 (1 engagement(s) unpriced)
- Wall-clock: 407s

<!-- garden-usage-end -->
