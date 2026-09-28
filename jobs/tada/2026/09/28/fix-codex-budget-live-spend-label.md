I fixed the misleading label: codex budget-live commits now read `spend=95.0%/100% tokens=48285769` instead of `spend=48285769/100`. It landed on `main2` as `f52b3e51589` and is waiting on the normal rolling deploy.

**Who reads `spend:`.** `quota-panel.sh` adds up the codex `spend:` token counts across hosts to build its fleet total (through `meter_remote_snapshot_total`, with cap `-`). Renaming `spend:` would have broken that and made the snapshot fail validation (rc 9), so `spend:` stays the raw token count. `budget-level.sh` and `triager-pace.sh` only read weekly-tokens pools. `append-quota-checkpoint.sh`, `fit-quota-calibration.sh` and `rolling-deploy.sh` don't read `cap:` at all, and `subscription_used_percent` only reads `used_percent:`.

**What changed** (`scripts/jobs/usage-meter.sh`, the per-pool publisher):
- **Percent pools (codex):**
  - The commit message and the zone-change alert print `spend=<used_percent>%/<cap>% tokens=<raw>`. When codex reports no rate-limit reading (`used_percent: -1`), they print `spend=unknown%/100%`.
  - The snapshot file keeps `spend: <tokens>`, adds `spend_unit: tokens`, and writes the ceiling as `cap_percent: 100` instead of `cap:`. So `spend:` and `cap:` can no longer be read side by side in different units.
  - The backoff decision is unchanged: it still compares `used_percent` against 100.
- **Weekly-tokens pools:** unchanged.

**Live example, re-derived from the current `journal2`:** both codex snapshots show `used_percent: -1` right now (codex reported no rate-limit reading), status `ok`:
- endolin-garden-ece02cb4, `spend: 48768757` — today's commit reads `budget-live(endolin-garden-ece02cb4) ok spend=48768757/100`. After deploy it will read `… ok spend=unknown%/100% tokens=48768757`.
- endolin-garden2-5bcdff64, `spend: 12227218` — after deploy it will read `… ok spend=unknown%/100% tokens=12227218`.

The 95% backoff case from the job is covered by the new test, which asserts the exact message `budget-live(endolin-garden-ece02cb4) backoff spend=95.0%/100% tokens=48285769`.

**Tests:** I added `scripts/jobs/test/budget-live-percent-label-test.sh`. It checks the percent-pool commit message, alert and snapshot fields, and the weekly-tokens output. It also checks that the quota-panel token total and `subscription_used_percent` still read the new snapshot, and covers the `unknown%` case. It fails on the old code and passes now.

These also pass: budget-snapshot-publish-retry, budget-snapshot-warning-dedup, subscription-budget-model, quota-panel, quota-calibration, triager-pacing, meter-journal-cutoff, set-budget-pool-physical-cap, rolling-deploy.

`live-budget-admission-test.sh` has 3 failures (55 passed). They were already there: the same three fail on unmodified `main2`. They are in budget-level monk steering and the raise-dwell hold, which this change doesn't touch.

**Follow-ups:**
- The live `used_percent: -1` means codex has stopped reporting a rate-limit reading. That still gives status `ok` (the gate lets work through when the reading is unknown), so for now the codex pool can't trigger backoff. It's worth checking whether codex rollouts still include `rate_limits.primary`.
- The `live-budget-admission-test.sh` failures need their own fix.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/fix-codex-budget-live-spend-label.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 40 tokens (1455006 cached reads)
- Output: 13845 tokens
- Cost: $1.2333092
- Wall-clock: 188s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
