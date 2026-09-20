Implemented and pushed the subscription-keyed budget model.

- Added the four canonical subscriptions and explicit host/worker-kind mapping, including shared `codex-endolin`.
- Migrated live snapshots, checkpoints, and reset history on `journal2` without dropping observations.
- Added independent reset facts; Codex remains manual-only and never projects a calendar reset.
- Added geometric rate inference (`alpha=0.25`), fresh baselines at discontinuities, and a fleet-wide lower-bound pace. Current known rate is ~37.95M tokens/day; Codex remains unknown pending a token-paired sample.
- Added spend-down pacing. Migrated Oros state produces a 0.946 pacing bias and sufficient allocation weight to raise it toward its four-worker cap automatically.
- Added real code gates refusing unknown token sources in claims, provider handlers, and configuration; the liaison policy now requires asking the maintainer for token count and target spend date.
- Pushed garden commits through `6c7e49cab6` to `main2`; pushed migration commit `baaf0c022a` to `journal2`.
- Verification: full suite passed 386/386; subscription, admission, leveling, reset, quota-panel, snapshot, and gauntlet tests also passed.
- Follow-up: record Oros’s precise Tuesday reset time when known and collect a Codex token/percentage pairing to complete its rate estimate.

Self-improvement: nothing this time.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/subscription-based-budget-model.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s) (1 unmetered)
- Input: 0 tokens (0 cached reads)
- Output: 0 tokens
- Cost: $0 (1 engagement(s) unpriced)
- Wall-clock: 2324s

<!-- garden-usage-end -->
