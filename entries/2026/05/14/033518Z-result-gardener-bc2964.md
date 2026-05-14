---
ts: 2026-05-14T03:35:18Z
kind: result
role: gardener
project: garden
refs:
  - entries/2026/05/14/032940Z-dispatch-liaison-bc2964.md
---

Repair landed on garden `main` for the systemic chaining failure: builder-only dispatches that left draft PRs orphaned because no role advanced them after the builder returned. Tasks (A) "make chaining load-bearing in the skill" and (B) "make the steward's per-cycle scan enforce it" both shipped. Task (C) (label-based state) skipped: the next-stage-owed heuristic reads GitHub state directly (PR draft flag, jury-shaped reviews, fixer pushes, CI rollup, `mergeable_state`) which is more robust than labels the bot writes and reads.

## Files edited

- `skills/pr-creation-flow/SKILL.md`: new *Orchestrator chaining is load-bearing* section after *Orchestrator's dispatch responsibilities*; new *The next-stage owed heuristic* subsection enumerating the seven-step read-from-GitHub procedure; new *Discipline* subsection naming the violation; notes-from-the-field row dated 2026-05-14 citing the backlog.
- `roles/steward/AGENT.md`: new top-level *PR-creation-flow scan* section between *Standing monitors* and *Per-cycle procedure*; per-cycle step 3 now explicitly invokes the scan after the standing-monitor dispatches. Concurrency caps: one stage per PR per cycle, one cleaner across the estate.
- `roles/liaison/AGENT.md`: new operating norm "*PR-creation-flow chaining is the orchestrator's job*" naming the two correct discharges (continue in-session, or hand to steward's scan) and the discipline violation (forget).

## Detection heuristic chosen

GitHub-state-driven (not label-driven). For each `gh pr list --author kriscendobot --draft --state open` row, walk the seven-step ladder: CONFLICTING -> weaver; no jury review -> jury; must-fix without addressing fixer push -> fixer; fixer push newer than latest jury review -> jury re-review; approve/no-must-fix verdict with no later builder/fixer push -> cleaner; cleaner push with green CI but still draft -> un-draft directly. Jury review identified by `kriscendobot`-authored formal review with panel-shape body (plain comments do not count).

## Out of scope (not acted on)

Existing orphaned PRs #243, #242, #241, #240, #239, #238, #237, #236. The in-session liaison handles those after this repair lands; #243 specifically is being remediated by the parallel jury dispatch.

## Verdict

Yes: a future builder dispatch triggers the full flow without the in-session liaison remembering. The steward's per-cycle scan reads GitHub state for every garden-authored draft PR on monitored repos and dispatches the next-owed stage. The liaison norm makes the alternative explicit (continue in-session or delegate to steward); forgetting is the named violation. The repair is doctrinal (the skill expresses the rule), procedural (the steward's per-cycle muscle enforces it), and bounded (the steward cannot meta-evolve, only chain the existing roles).

Self-improvement: nothing this time.
