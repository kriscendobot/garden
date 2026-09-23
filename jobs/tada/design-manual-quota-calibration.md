The review PR is correct: **draft**, base = frozen `main2-d5a2071`, head = `design/manual-quota-calibration`, diff = the design file only, with both the job marker and the `<!-- garden-design-open-questions -->` marker in the body (so the completion machinery treats it as a maintainer answer-surface, not a panel-gated design PR). The earlier `b3ec6jul0` failure was just the first short retry loop exhausting against the rate limit before the long loop succeeded.

Everything is landed and the review surface is open. Report follows.

---

## Completion report — `design-manual-quota-calibration`

**What I did.** Designed and implemented how the fleet uses the manual quota-checkpoint log to ground its rate-limiting cybernetics, per kriskowal's 2026-09-03 directive.

**Landed bare on `main2`** (commit `d5a2071`, per CLAUDE.md § Conventions — the garden repo is push-direct):
- `scripts/jobs/append-quota-checkpoint.sh` — the durable ingestion point. `append-quota-checkpoint.sh <host> <weekly_percent> [session_percent]` auto-fills `meter_spend_tokens`/`meter_sampled_at`/`meter_window_start_epoch`/`pairing_confidence` from `budget/live/<host>`, computes `implied_weekly_cap_tokens`, flags a window-anchor change inline, and CAS-races the row onto the journal. Replaces the bespoke hand-edit.
- `scripts/jobs/fit-quota-calibration.sh` — the deterministic, no-LLM fit. **Segments** checkpoints by `meter_window_start_epoch` (the hard comparability boundary), picks a governing segment by confidence+recency+count, takes the conservative low-end rounding band of the freshest highest-confidence point, and **grades** the result `converged | provisional | insufficient`. Writes `budget/quota-fit/<host>.json`; never touches `config/budget-pools`. Tested against the real seed: it independently reproduces the maintainer's 595M choice **and** correctly grades it `provisional` because the governing segment's spread is 3.868× (the documented ~3× spread).
- `scripts/jobs/set-budget-pool.sh` — the deliberate ACTUATE half: promotes a measured cap into `config/budget-pools` with provenance columns, preserving header comments (replace-in-place / append-if-absent, both smoke-tested).

**Design** `designs/manual-quota-calibration.md` (commit `7c9d05e`, also on `main2`), which decides all four scope items: (1) segmented graded fit, not a single ratio, with the cache-read two-coefficient model reserved behind a schema field until `usage-meter.sh` publishes cache-read; (2) human-in-the-loop promotion only, never auto-actuation, wiring through the existing provenance/uncalibrated convention; (3) a separate composing document rather than a section of `recurring-budget-calibration.md`, with the reasoning; (4) the append helper as the ingestion point.

**Review surface:** because the design carries a non-empty `## Open questions` section with real maintainer-facing forks, it took the open-questions-PR carve-out — **PR kriscendobot/garden#80** (draft, base = frozen `main2-d5a2071`, diff = the design file only), body carrying `<!-- garden-job: ... -->` and `<!-- garden-design-open-questions -->` so no design panel is staged. Left draft as required.

**Key finding surfaced for the maintainer:** the uncalibrated-cap guard (`budget_level_uncalibrated`) disarms only worker *leveling*; the *claim gate* (`pool_admits`/`meter_quota_status`) reads only the ceiling column and ignores provenance — so a provisional cap still throttles admission at full authority. That asymmetry is the sharpest open question in the design; the current stance is "never promote a below-`converged` fit," and `set-budget-pool.sh`'s header states it so nobody promotes a shaky number expecting the marker to neuter it.

**Follow-ups (in the design's Open questions, for maintainer decision):** whether the claim gate should honor provenance; whether a `converged` fit should ever auto-promote; whether the fit should also split a segment on temporal contiguity (current behavior fails safe toward `provisional`); the reserved cache-read-aware fit mode, triggered when `usage-meter.sh` publishes cache-read in `budget/live`.

**Note:** PR opening was delayed ~5 min by a transient fleet-wide GitHub secondary rate limit; a poll-retry opened it once the limit cleared. All deliverables are durably committed.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/design-manual-quota-calibration.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 2 on 1 host(s)
- Input: 110 tokens (6142809 cached reads)
- Output: 56284 tokens
- Cost: $5.428085750000002
- Wall-clock: 1245s
- Model(s): claude-opus-4-8 ×2

<!-- garden-usage-end -->
