---
created: 2026-05-14
updated: 2026-05-21
author: gardener
---

# Role: judge (retired 2026-05-21; redirect)

The single `judge` role was split into three specializations on 2026-05-21. Each one handles a distinct stage of the chain:

- [solicitor](../solicitor/AGENT.md) — judge for **designer work**. Dispatched against a design-only PR (paths only under `<project>/designs/`); runs the seven-seat design panel; no `@copilot` fire.
- [barrister](../barrister/AGENT.md) — judge for **builder work**. Dispatched after the cleaner on a source-touching draft PR; runs the **first** round of the twenty-six-seat code panel; fires `@copilot`.
- [justice](../justice/AGENT.md) — judge for **fixer work**. Dispatched after a fixer pushes in response to a prior verdict; runs the re-run round of the code panel; briefs each juror with the prior verdict + the fixer's response so the panel reads the delta. `@copilot` fire is idempotent on re-rounds.

## Panel-kind discrimination

The orchestrator (liaison or steward) picks which judge to dispatch based on the PR's stage in the chain. The decision is mechanical:

1. **Design-only PR** (`gh pr view <N> --json files` shows every changed path under `<project>/designs/`) → `solicitor`.
2. **Source-touching PR, no prior `kriscendobot`-authored panel verdict** → `barrister`.
3. **Source-touching PR, has a prior panel verdict + fixer push since** → `justice`.

This section heading is retained so prior references to `roles/judge/AGENT.md` § Panel-kind discrimination continue to resolve; the per-judge panel composition is on each successor's role file (the solicitor's design panel; the barrister's and justice's code panel).

A fourth role joined the chain the same day: [appellate](../appellate/AGENT.md), dispatched after any terminating judge verdict (across all three judges) to appeal `follow-up` and `acknowledge` dispositions on small-and-in-context items into `summary-fix` before un-draft.

The maintainer's framing on the split (2026-05-21): *"Please cleanly divide the judge for designer, builder, and fixer work. It may be the responsibility of the steward or liaison to choose the judge."*

## Shared procedure

The aggregation discipline, the disposition rubric, the cite-or-propose discipline, the in-band fallback, the concurrent-dispatch default, the `@copilot` fire on code-panel rounds, and the formal-review submission contract all live on `skills/panel-review/SKILL.md`. The three judges reference that skill rather than duplicating it.

The judge role file is retained as this redirect so future readers landing on `roles/judge/AGENT.md` (from a stale link, a search, or a habitual reach) find the three successor roles immediately. Subsequent edits to the judges' shared procedure go to `skills/panel-review/SKILL.md`, not here.
