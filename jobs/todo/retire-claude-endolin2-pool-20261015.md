---
role: builder
tier: mentor
fallback-tier: minion
dispatch: automatic
priority: high
---
# Retire the claude-endolin2 pool and the endolin-garden2 host from fleet accounting

Garden repo (kriscendobot/garden); tracked changes land directly on `main2` (no PR); journal config changes go through the supported CAS scripts. Maintainer direction (liaison muster 2026-10-15, kriskowal): "endolin2 is retired. We will receive no further tokens from that pool and the accountant should dispense tokens accordingly, only from living accounts. I think, other than this hiccup, the accountant and foreman are functioning as designed." Do not touch the accountant's or foreman's design; remove only what makes them count a dead account.

## What is retired

- The Anthropic subscription `claude-endolin2` (cap 168,000,000 in journal `config/budget-pools`).
- The host `endolin-garden2-5bcdff64` (last fleet health report 2026-10-09; monks 1, clerics 1 in `hosts/`).
- Living accounts stay: `claude-endolin1`, `claude-oros`, `codex-endolin`. The Codex subscription `codex-endolin` is shared by hosts; remove only the retired host's mapping row, not the pool.

## Procedure

1. Inventory every reference before changing anything: `config/budget-pools`, `config/subscription-mapping`, `config/arc-budgets`, `config/foreman-mandate` or apportionment files, `hosts/endolin-garden2-5bcdff64`, `budget/live/claude-endolin2/`, `budget/reset-events/claude-endolin2.jsonl`, any worker-leveling rows, schedules or jobs pinned to the host, leader/follower markers, `fleet/health/endolin-garden2-5bcdff64`, tracked defaults such as `scripts/jobs/subscription-mapping.tsv` and `budget-pools-placeholder.tsv`, tests, and docs under `context/` and `skills/`. Report the list.
2. Check the fail-closed hazard first: `claim-job.sh` refuses claims for a configured pool with no trustworthy ceiling, and the leveling controller treats an uncalibrated pool as a halt. Confirm that removing the pool row together with its mapping rows leaves no host mapped to a missing pool, and that no living host loses its mapping.
3. Remove the retired pool and host from the live registries using the existing setters where they exist (`set-budget-pool.sh` and siblings); where no remover exists, add a small, tested one rather than hand-editing the journal. Tombstone the host the way unwatch-optout or retired hosts are tombstoned elsewhere, so a reconciler does not re-add it. Keep historical records (decisions, reset events, usage ledgers) intact as history; they are not live config.
4. Re-run the capacity math the accountant and foreman use and show that the total dispensable weekly tokens now excludes the 168M cap: living caps are 271M, 180M, plus the Codex percent pool, and the old 610M slate must be re-derived from them. Do NOT set a new slate yourself; that is the accountant's job at the 10-17 reset. Verify the accountant statement and foreman mandate computation run clean against the new registry (dry-run or test fixtures), and that `accountant-reslice-nudge.sh` and `accountant-statement.sh` do not mention endolin2 as capacity.
5. Add a short note to `context/operations/` (cybernetics or scaling) that the pool is retired, with the date and why, so the next gardener does not rediscover it as an outage.
6. Tests for the registry change; run the budget, claim-admission, accountant and foreman suites. Do not claim, drain or modify any other host. Report what changed, test results, and anything that still references endolin2 and why it was left.
