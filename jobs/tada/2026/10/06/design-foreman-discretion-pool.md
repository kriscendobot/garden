I wrote the design for the foreman-discretion pool, `designs/foreman-discretion-budget-pool.md`. It is pushed to `main2` (commit `de4f2eece5`) and up for review as draft PR kriscendobot/garden#119, because it carries two open questions for the maintainer. The PR is against a frozen base, `main2-61b77cc9a9`, and carries the `<!-- garden-design-open-questions -->` marker.

**What the design settles**
- **Closed form.** Each pool interpolates linearly over the quota week, using the same reset window the backoff ramp uses (`subscription_pacing_window`). Maintainer discretion runs 0.50 → 0.05, the accountant's arc slate 0.50 → 0, and foreman discretion is whatever remains, 0 → 0.95. Because foreman discretion is the remainder, the three always add to 100%, not only at the two endpoints. All three are computed when read; there is no ticking writer.
- **`planning_ceiling`.** The maintainer's "90% → 95%" is this ceiling. The design retires the fixed 0.9 and replaces it with the foreman's total share, which grows from 50% to 95% across the week.
- **Backoff ramp (#116).** That design is still only proposed and not built. The live `config/token-backoff-fraction = 1.00` is left over from the 2026-09-28 hand ramp: its last schedule fired on 2026-09-30 and was never cleaned up. The ramp was not abandoned. The new split folds into it rather than running alongside: #116 keeps its mechanism, its end value changes from 1.00 to 0.95, and its starting value is derived from `config/apportionment`. So `config/token-backoff-initial` is never created, and only one curve is ever live.
- **How the accountant's share shrinks.** Budget figures here are caps on spend so far this week, and spend can't be undone, so a shrinking arc share can't be a shrinking cap. Instead it is an earmark that discretionary work may not touch. It decays to zero by reset, so unspent arc tokens pass to foreman discretion. Discretion work is admitted only when no arc work is ready and the earmark still leaves room.
- **Stamping.** The `unallocated` pseudo-arc is renamed `foreman-discretion`, and old `unallocated` stamps still count toward it. Its headroom comes from the formula rather than a fixed cap. The foreman now skips running only when neither the arcs nor the discretion pool have room.
- **Where it lives.** `config/apportionment` moves to schema 3 with the three endpoint values, and schema-2 records are still read sensibly. One new helper in `common.sh` computes all the fractions. The design also says what changes in `set-apportionment.sh`, `accountant-statement.sh`, the deferred selector, the foreman digest and the mandate.
- **Diagram.** It includes an ownership map and a mid-week pie chart in the maintainer's palette: light grey for maintainer discretion, dark grey for foreman discretion, and a rainbow of arc slices. I did not run the Mermaid validator on the chart.

**Open questions in #119**
1. Should maintainer discretion be enforced as a reservation? As designed, it only stops foreman-drawn work, and I recommend keeping it that way. The stricter version would also count watcher and schedule spend against the foreman's limit.
2. Is reading the accountant column as a weekly cap right? It makes the arc slate total 50% of capacity, down from about 86% today.

**Follow-ups**
- #116 needs to merge with the 0.95 change.
- Then a build job, `build-foreman-discretion-pool`, does the implementation. It can also be combined with the #116 build. The design says that build's deploy commit removes the leftover `1.00` file and the old hand-ramp schedules.
- After that, the accountant re-slices the current week to schema 3.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/design-foreman-discretion-pool.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 18 tokens (514243 cached reads)
- Output: 15276 tokens
- Cost: $0.9599126
- Wall-clock: 185s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
