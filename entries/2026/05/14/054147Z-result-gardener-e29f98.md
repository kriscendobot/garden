---
ts: 2026-05-14T05:41:47Z
kind: result
role: gardener
project: garden
refs:
  - entries/2026/05/14/053103Z-dispatch-liaison-e29f98.md
  - entries/2026/05/14/052721Z-result-gardener-76d07a.md
---

# Result: twelve-seat jury panel landed

Sixteen commits on `main` (088b04d..81e9ef3, after rebase onto origin/main's scholar commit). The maintainer's directive to halve each seat's responsibilities is encoded; the next judge dispatch reads a twelve-seat panel composition with concurrent dispatch as the explicit default.

## Twelve-seat list (one-line rationale per seat)

1. **assessor** (kept narrower): correctness logic, control flow, error handling. The deliberate-overlap secondary is invariant claims against the breaker.
2. **typist** (new): type accuracy (TS, JSDoc types, narrowings). Distinct from logic correctness; the typist's pass keeps the type story honest.
3. **stylist** (kept narrower): naming and identifier choice. Diff hygiene moved out.
4. **packager** (new): diff hygiene, commit splitting, changeset content (prose and bump-level). The "shape of the PR" axis distinct from naming.
5. **archivist** (kept narrower): docs and comment / JSDoc prose accuracy. Regression evidence moved out; type lines moved to typist.
6. **prover** (new): regression evidence (would each new test fail if reverted, coverage claims). Procedural and dedicated.
7. **curator** (kept narrower): public API surface and exported identifier shape. The inventory axis.
8. **migrator** (new): backwards compatibility, peer-dep cascade, bump-level. The "what depends on the changed surface" audit, distinct from the curator's inventory.
9. **locksmith** (kept narrower): capability flow and attenuation inside the module.
10. **warden** (new): SES / hardened-JS boundary, harden discipline, unguarded globals, prototype pollution. The boundary discipline distinct from intra-module capability flow.
11. **saboteur** (kept narrower): adversarial inputs (boundary, type confusion, adversarial values, reentrancy, timing). The input-shape attacks.
12. **breaker** (new): invariant attacks against claimed contracts (`M.interface()`, attenuator promises, vat-boundary contracts). The contract-attack axis distinct from input-shape attacks.

## Prior-seat fates (one line each)

- **assessor** → keep-with-narrower-remit. The successor `typist` takes types; assessor keeps correctness logic and control flow.
- **stylist** → keep-with-narrower-remit. The successor `packager` takes diff hygiene and changeset; stylist keeps naming.
- **archivist** → keep-with-narrower-remit. The successor `prover` takes regression evidence; archivist keeps doc and comment prose.
- **curator** → keep-with-narrower-remit. The successor `migrator` takes backwards compat and cascade; curator keeps public-surface inventory.
- **locksmith** → keep-with-narrower-remit. The successor `warden` takes the SES boundary; locksmith keeps capability flow.
- **saboteur** → keep-with-narrower-remit. The successor `breaker` takes invariant attacks; saboteur keeps adversarial inputs.

No removals.

## New flow ASCII diagram

Updated in `skills/pr-creation-flow/SKILL.md`:

```
...
   v
judge (foreperson; dispatches the jury panel)
   |
   |  judge runs twelve juror dispatches (concurrent) + gh pr edit --add-reviewer @copilot
   v
jury panel verdict (judge aggregates, submits formal gh pr review)
...
```

(Rest of the flow diagram is unchanged from the 2026-05-14 redesign.)

## Concurrent dispatch confirmation

The judge's dispatch loop now dispatches twelve seats concurrently by default per `roles/judge/AGENT.md` § Operating norms ("Concurrent dispatch is the default at twelve seats") and `skills/pr-creation-flow/SKILL.md` § Concurrency.

## Files changed

- `roles/typist/AGENT.md`, `roles/packager/AGENT.md`, `roles/prover/AGENT.md`, `roles/migrator/AGENT.md`, `roles/warden/AGENT.md`, `roles/breaker/AGENT.md` (new): six new jury-seat roles.
- `roles/assessor/AGENT.md`, `roles/stylist/AGENT.md`, `roles/archivist/AGENT.md`, `roles/curator/AGENT.md`, `roles/locksmith/AGENT.md`, `roles/saboteur/AGENT.md` (revised): six prior seats with narrower remits.
- `roles/judge/AGENT.md` (revised): default panel composition lists twelve seats; concurrent dispatch is the explicit default; aggregated-body word budget bumped to 1200-2000.
- `roles/liaison/AGENT.md` (revised): active-set list and PR-creation-flow chaining note updated for twelve-seat jury.
- `roles/steward/AGENT.md` (revised): judge subordinate row updated to twelve-seat composition.
- `skills/pr-creation-flow/SKILL.md` (revised): Jury composition section rewritten for twelve seats with halved-responsibilities rationale; ASCII diagram updated; Notes-from-the-field entry added.
- `skills/panel-review/SKILL.md` (revised): default composition is twelve seats; word budget bumped; Notes-from-the-field entry added.
- `skills/garden-ab-evaluation/SKILL.md` (revised): historical-arm vs current-flow distinction extended for the second 2026-05-14 redesign; cost framing updated.
- `CLAUDE.md` (revised): Current inventory lists the twelve jury-seat roles.

## Out of scope (untouched)

- PR edits on external repos.
- Retroactive re-dispatch of existing in-flight panels.
- Edits to `skills/merged-pr-feedback-watch/SKILL.md` and the gardener's standing duty.

Self-improvement: `nothing this time.` The twelve-seat redesign extends the six-seat structure the prior gardener dispatch shipped; the role-authoring procedure (one commit per new role file, narrower revisions of kept seats, one commit for the flow skill, one for judge/panel-review, one for the inventory sweep) worked cleanly and does not warrant a procedural change yet.
