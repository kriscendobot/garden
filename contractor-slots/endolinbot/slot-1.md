---
slot: 1
status: in-flight
design_path: designs/formula-inspector.md
pr_number: null
current_stage: builder
in_flight_dispatch: cc02aa
last_update: 2026-05-18T14:30:00Z
started_at: 2026-05-18T14:30:00Z
host: endolinbot
---

Slot 1 refilled with `formula-inspector` Phase 1 after contractor-side
substrate audit:
- No `FormulaInspector`/`inspectFormula`/`formulaInspector` references
  on llm.
- No `packages/cli/src/commands/inspect*.js` on llm.
- Existing `InspectorHub.lookup` API already shipped — that's the
  substrate the new CLI verb wraps.
- The retention-path sub-feature mentioned in this design is the just-
  shipped PR #284, so deliberately deferred.

Scope: `endo inspect <name>` CLI verb that prints formula JSON via
existing InspectorHub.lookup. Defer Chat UI panel, edit functionality,
and retention-path facility (latter shipped in #284) to follow-up phases.
Base: llm.

Dispatch root: `dispatches/builder--cc02aa`.
