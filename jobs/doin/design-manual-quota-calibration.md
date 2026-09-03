---
role: designer
tier: mentor
fallback-tier: minion
dispatch: automatic
---
Design (garden's own repo, land per CLAUDE.md § Conventions — bare to main2, or the open-questions-PR carve-out if real open questions remain) how the fleet should **use** the new manual quota-checkpoint log to ground its rate-limiting cybernetics, per kriskowal's directive 2026-09-03: *"create or obtain a record for all of my manually verified quota checkpoints, against a record of token usage over time, so we can gradually increase our confidence in our tokens per quota ratio, to ground our cybernetics around rate limiting jobs."*

## What already exists (read first)

1. **The log itself, already created and seeded**: `journal/budget/manual-checkpoints/<host>.jsonl` + its `README.md` — an append-only record pairing a human-read Claude dashboard weekly-limit percentage against the simultaneous `usage-meter.sh` billable-token spend, with a `pairing_confidence` field and an `implied_weekly_cap_tokens` derivation. Seeded with 4 checkpoints from 2026-09-03 on `endolin-garden-ece02cb4` (16%/17%/19%/28%) and one qualitative entry on `endolin-garden2-5bcdff64`.
2. **`designs/cybernetics-audit.md`** § 2.1, § 2.3, § 7 rec 2 — already diagnoses `config/budget-pools`' single-point calibration as a wrong-sensor problem and calls for provenance-marking uncalibrated caps (rec 2's first half, already landed via job `cybernetics-rec123-budget-loop`) plus implementing `designs/recurring-budget-calibration.md` (rec 2's second half, **not yet implemented** — no `weekly-capacity-calibration.sh` exists).
3. **`designs/recurring-budget-calibration.md`** (Status: Proposed) — a fully-specified *automatic*, dollar-cost-calibrated weekly capacity ledger (`budget/weekly-capacity/<host>.jsonl`, max-over-trailing-4-weeks statistic, a token bucket). It never asks a human for a percentage; it calibrates real-vs-notional cost from a configured monthly subscription price.

## The gap this design fills

The manual-checkpoint log's first day of data already surfaced something the automatic design can't see on its own: the three same-window paired points on `endolin-garden-ece02cb4` imply wildly different weekly caps (~192-204M at 17%, ~175-184M at 19%, ~596-617M at 28%) — a ~3x spread that's most likely the documented `input+output+cache_creation`-vs-`cache_read` base mismatch between the local token meter and Anthropic's own weighted dashboard percentage, worsened by a large workload-mix shift (a heavy PR-gauntlet backlog burn) between readings. A single-point calibration (which is all `config/budget-pools` has ever used, including the recalibration this session just did to 595M) cannot see or correct for that; only a growing set of checkpoints across varied workload mixes can.

## Scope

1. **Decide the fitting approach.** At minimum: is a simple linear ratio (tokens per percent point) ever going to be reliable given the demonstrated ~3x spread, or does closing this gap require modeling cache-read separately (the local meter already has the data — `usage-meter.sh` reads `usage/*.jsonl` CostRecords, which include `cache_read_tokens`)? Write the actual regression/fitting method (even a simple "weighted toward highest-confidence, most-recent same-window points" rule is fine to start) as a deterministic script, not an LLM judgment call each time.
2. **Decide how it feeds `config/budget-pools`.** Does a recalibration recompute and CAS-write the cap automatically past some confidence/data threshold, or does it stay a human-in-the-loop `set-*-cap.sh` setter that a person or a proxy-role invokes when the manual log has enough new points? Consider wiring through the SAME uncalibrated-disables-leveling guard `cybernetics-rec123-budget-loop` already landed (`budget_level_uncalibrated` in `common.sh`), so a cap this mechanism can't yet trust stays honestly marked as such rather than silently actuating on noise (cybernetics-audit.md § 2.3's exact concern).
3. **Decide the relationship to `designs/recurring-budget-calibration.md`.** Land as a section extending that document (it's currently a sibling axis on the same problem, not implemented yet), or as its own design that composes with it once both exist. Either is defensible; make the call and say why.
4. **A durable ingestion point for future checkpoints.** Right now a human states a percentage in chat and the liaison hand-writes a JSONL row. At minimum, write the small append helper (`append-quota-checkpoint.sh <host> <weekly_percent> [session_percent]`, CAS-race onto the journal, auto-fill `meter_spend_tokens`/`meter_sampled_at`/`meter_window_start_epoch`/`pairing_confidence` from the current `budget/live/<host>` the way the log's README already documents) so this isn't a bespoke hand-edit every time.

## References

- `journal/budget/manual-checkpoints/README.md` and the two seeded `.jsonl` files (read them — the README's "What the first four points already show" section is the concrete evidence this design responds to)
- `designs/cybernetics-audit.md` § 2.1, § 2.3, § 7 rec 2
- `designs/recurring-budget-calibration.md`
- `journal/config/budget-pools` (current state, including today's manual recalibration and its own history of ad hoc single-point calibrations in its header comments)
- `scripts/jobs/claim-job.sh` (`pool_admits` — the actual admission gate a bad cap silently starves, as happened today: 0 claims fleet-wide on `endolin-garden-ece02cb4` for 15+ minutes against a stale cap)

<!-- garden-transient-elapsed: kind=signature through=0 values=1 -->
<!-- garden-provider-quota-backoff: type=weekly reset-at=2026-09-05T03:00:00Z -->
---
claim:
  host: endolin-garden2-5bcdff64
  gardener: 1
  worker_kind: monk
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-09-03T21:07:22Z
