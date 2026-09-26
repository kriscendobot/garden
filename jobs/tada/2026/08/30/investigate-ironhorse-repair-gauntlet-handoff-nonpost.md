Investigated the 14 live Ironhorse repair jobs. The gauntlet post was not failing: `ironhorse-fuzz-ab889c8f6184c60d-gauntlet` and its clean child were durable on `journal2`. Completion falsely rejected it because `handoff_successor_posted` ignored active `jobs/gauntlet/` records.

Fixed the shared handoff predicate to recognize staged gauntlets and added deterministic gate plus end-to-end completion coverage. Relevant suites passed: 28 completion-signal tests, follow-up gate, 26 Ironhorse fuzz tests, and auto-gauntlet tests. Landed on `main2` through `f10f263eba`.

Follow-up: deployed workers need the normal deliberate garden upgrade before stranded repairs retry under the fix.

Self-improvement: nothing this time.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/investigate-ironhorse-repair-gauntlet-handoff-nonpost.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s) (1 unmetered)
- Input: 0 tokens (0 cached reads)
- Output: 0 tokens
- Cost: $0 (1 engagement(s) unpriced)
- Wall-clock: 402s

<!-- garden-usage-end -->
