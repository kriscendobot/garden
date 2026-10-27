## Completion report: `design-budget-road`

I read the tower page in full and turned it into a garden design: **`designs/budget-road.md`**, status Proposed. It is on `main2` as 658a378768e. The design has three questions only the maintainer can answer, so I also opened the review PR the CLAUDE.md carve-out requires: **https://github.com/kriscendobot/garden/pull/127**. It is a draft, carries the `<!-- garden-design-open-questions -->` marker, and is based on the frozen snapshot `main2-79377c2`. Its diff is just the design and three index/status lines. Nothing was implemented, as the job asked.

### How the design fits the garden
- **Per-subscription values.** The design calls the week elapsed `t` and seven-day utilization `u`. `t` comes from `subscription_pacing_window`, the same window the token-backoff ramp uses. `u` comes from `subscription_used_percent`, which already reads `rate_limit.seven_day.utilization` from usage rows. The token-to-cap ratio is the fallback.
- **Maintainer's share.** It is set to 0.50, taken from `config/token-backoff-initial`. With no maintainer spend, the fleet's ceiling (`1 − R_k`) is exactly today's 0.50 → 1.00 ramp, so the road replaces the ramp rather than running beside it. The manual brake `config/token-backoff-fraction` stays as it is.
- **Converting tokens to utilization.** Tokens are weighted at list-price ratios (input 1, output 5, cache creation 1.25, cache read 0.1) and calibrated per subscription. Maintainer spend is counted from the Claude session logs minus job sessions, reading token counts only, never content. The figures are published in the existing `budget/live/` snapshots so every host reads the same numbers.
- **Codex.** `codex-endolin` (percent-capped, manual resets) and any dollar-capped pool stay flat at their ceiling. They get no reserves.
- **Claim gate and foreman.** The new verdict keeps the existing `ok`/`backoff`/`unknown` words, so `pool_admits` and `claim-job.sh` need no logic change. Deferred promotion becomes: lane groups first, then road rank, then the existing omega rank, priority and age. `plan_deferred_status` loses its per-arc cap half, and held plans are logged as `arc-held:`. The foreman's two backoff notices become one "Budget spent" notice, sent only on full exhaustion and at most once a day.
- **Gap the build must close first.** The foreman's own `claude -p` calls write no usage rows today. Under the road that unmetered spend would be counted as the maintainer's, shrinking their reserve and raising the fleet's ceiling at their expense. The design makes the build add those rows before the lanes go live.
- **Smaller changes.**
  - Jobs have no `posted_at:` field, so the design adds one. Until then, file mtime is the fallback.
  - The garden has no tool that marks roadmap items ready, so that source of "planned work" is left out.
  - The `unallocated` reserve arc is retired.
  - Schema-1 rolling arcs (the Ironhorse press) are kept.
- **Migration.** `set-road.sh init` builds the road from the live slate. In the same commit it removes `config/apportionment`, `config/foreman-mandate` and the schema-2 arc-budget files. Rolling back is a revert of that commit. The weekly accountant schedule is rewritten to produce a statement, and the re-slice nudge is retired.
- **Also in the doc:** the list of every script, role, skill and operator page it touches, an ownership map, and the alternatives considered. `accountant-arc-apportionment.md` and `foreman-discretion-budget-pool.md` now say they are superseded by this design, and `designs/README.md` has an index row for it.

### Open questions on PR #127
1. **Which arc holds the library lane?** None of the current arcs fits. I recommend a new `garden-library` arc.
2. **Does the 90% ceiling survive?** The 2026-10-02 directive says "never 100%", but the 2026-09-28 directive and the road both reach 100% at reset. I recommend an optional `ceiling` field in `road.json`, defaulting to 0.90.
3. **How many old slate arcs does `init` pin?** I recommend the three minion.town arcs.

## Follow-ups
- `build-budget-road`, after the maintainer answers the open questions on #127 (design § Migration, step 1).
- Have `budget-level.sh` use the road's ceiling for worker leveling (to be filed after the build).
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/design-budget-road.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 64 tokens (3115363 cached reads)
- Output: 30042 tokens
- Cost: $2.2337206000000003
- Wall-clock: 350s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
