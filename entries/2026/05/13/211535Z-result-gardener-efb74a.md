---
ts: 2026-05-13T21:15:35Z
kind: result
role: gardener
to: liaison
refs:
  - entries/2026/05/13/210114Z-dispatch-liaison-e8bc8c.md
---

# Result: gardener — PR-creation flow rework (draft discipline + assayer + jury loop)

Engagement complete. All six task groups (A1, A2, B, C, D, E, F) landed.

## Files written

### Task A1: builder + cleaner ports

- `roles/builder/AGENT.md` (new)
- `roles/cleaner/AGENT.md` (new)
- Commit: `00f6d4b`

### Task A2: juror + saboteur ports + cited skills

- `roles/juror/AGENT.md` (new)
- `roles/saboteur/AGENT.md` (new; the review variant is the default for PR-creation flow, the test-writing variant lives in the same file as a sub-mode)
- `skills/adversarial-tests/SKILL.md` (new; the brainstorming list)
- `skills/saboteur-adversarial-review/SKILL.md` (new; the reusable pattern catalog)
- `skills/panel-review/SKILL.md` (new; reshaped from the reference's 12-perspectives skill for the 2-member default panel, with the larger-panel form preserved as an option)
- Commit: `10bd8ff`

### Task B: assayer + cited coverage skill

- `roles/assayer/AGENT.md` (new; designed from scratch since there is no reference file)
- `skills/coverage-driven-testing/SKILL.md` (new; ported from the reference, generalized in tool names so per-project specialization can land as journal `message` entries)
- Commit: `a51a51f`

### Task C: pr-creation-flow skill

- `skills/pr-creation-flow/SKILL.md` (new; the canonical orchestration map for the flow)
- Commit: `dab0de5`

### Task D: existing role norms updated

- `roles/fixer/AGENT.md` (new "jury-fixer loop is multi-round" and "out-of-scope is not the fixer's lane" norms; pr-creation-flow skill added to skill list)
- The builder and cleaner already carry their draft-on-open and un-draft-authority norms as part of the A1 port (the dispatch entry's note "(after port in task A)" routes those into A1).
- Commit: `d63d75f`

### Task E: inventory + steward subordinates

- `CLAUDE.md` (Current inventory: roles list gains builder, assayer, juror, saboteur, cleaner; skills list gains pr-creation-flow, coverage-driven-testing, adversarial-tests, saboteur-adversarial-review, panel-review)
- `roles/steward/AGENT.md` (Subordinate roles dispatched: new bullets for builder, assayer, fixer-loop addendum, cleaner; standalone Jury bullet for the juror+saboteur pair; standalone Jury-fixer loop bullet)
- Commit: `b890551`

### Task F: bulletin note

- `journal/README.md` § Awaits maintainer decision: one-line note "PR-creation flow reworked; first builder/assayer/jury/cleaner dispatches will land when the maintainer next asks for work on a specific PR." Self-clearing on the first such dispatch.
- Commit on journal: `8c3577a`

## Design choices

- **Assayer/builder ordering default: in concert.** Both roles share the branch; concurrent pushes work cleanly because production and tests touch disjoint files. TDD-style is supported (blocks the builder on the assayer's first push, stretches time-to-first-CI-green). Regression-after is also supported (the assayer's test is written against passing code, less load-bearing per `skills/regression-evidence/SKILL.md`). Documented in `skills/pr-creation-flow/SKILL.md` § Assayer placement with trade-offs; orchestrator names the placement in the dispatch brief.
- **Jury composition: juror + saboteur as a fixed pair.** The two roles operate as a 2-member panel, dispatched as a single jury round; the orchestrator's discretion is sequential vs concurrent (the working default is concurrent; sequential lets the saboteur's findings be informed by the juror's reading). Larger panels (the reference's 12-perspective form) are preserved as an option in the panel-review skill; the orchestrator names the composition in the dispatch brief.
- **Labels vs draft-state: draft-state only is load-bearing.** Per the maintainer's directive. Labels (`state:building`, etc.) are documented as advisory annotation a future bulletin or dashboard view might consume, but the flow does not use them today; the orchestrator never makes a flow-decision based on a label alone. Adding labels later is non-breaking.
- **Cleaner is the only role that un-drafts.** `gh pr ready <N>` is the cleaner's privilege; no other role moves a PR out of draft. Documented in `roles/cleaner/AGENT.md` and re-stated in `skills/pr-creation-flow/SKILL.md`.

## Out of scope (per dispatch entry)

- Did not run the new roles for any first engagement; this was meta-evolution only.
- Did not touch the groom Gateway dispatch (concurrent gardener dispatch on a different file; the groom result landed on the journal and was rebased onto cleanly).
- Did not touch the journalist base-branch dispatch (concurrent gardener dispatch on a different file).

## Self-improvement

The reference's `saboteur.md` is framed as "test-writing variant" because the adversarial review slot was folded into the reference's 12-perspective panel as perspective 13. In this garden's 2-member default panel the saboteur is again a standalone role (one of two seats). The port reflects both shapes by carrying the review variant as the default and the test-writing variant as a sub-mode. If the 2-member default settles, a future gardener may want to revisit whether the test-writing variant warrants its own role; the current shape keeps the two close so dispatch can pick either without an extra file.
