---
ts: 2026-05-14T05:31:03Z
kind: dispatch
role: liaison
project: garden
to: "*"
refs:
  - entries/2026/05/14/052721Z-result-gardener-76d07a.md
---

# Dispatch: gardener doubles the jury panel and halves each juror's responsibilities

Dispatch root: `dispatches/gardener--double-jury-panel--20260514-053103--e29f98/`.

Maintainer's directive (2026-05-14, immediately after the jury/judge redesign landed): "Please ask the gardener to double the size of the jury panel and halve each juror's responsibilities."

The prior gardener engagement landed a 6-seat panel: **assessor, stylist, archivist, curator, locksmith, saboteur**. Each seat's inquiry area is broad enough that this redesign splits each into two more-focused seats. Net: **12 seats**.

## Why split

The maintainer's prior framing (recorded in `skills/pr-creation-flow/SKILL.md` § Jury composition by the previous gardener) was: "each kind of review is conducted more than once, but a wide variety of concerns are evaluated. The size of the jury is negotiable as it has already grown to include a saboteur." Doubling the panel is the maintainer pushing further in the same direction: more seats, narrower inquiry per seat, more overlap so the same concern is reliably hit by at least two seats.

This is a refinement, not a reversal. The flow stays builder → cleaner → judge → fixer-loop → un-draft.

## Suggested splits (the gardener picks the final cut)

Each current seat names two-to-three inquiry areas. The split should land one inquiry area (or a closely-related pair) per new seat. Sketch:

- **assessor** (correctness, types, control flow, performance) → split, e.g., one seat for correctness + control flow, one seat for types + performance. Or correctness alone vs control flow + types + performance. The gardener picks.
- **stylist** (naming, diff hygiene, changeset content) → split, e.g., naming + diff hygiene vs changeset content. Or three-way: naming, diff hygiene, changeset content (if a seat collapse is wrong; the directive says "halve", so two-way is the default).
- **archivist** (docs, regression evidence, comment/JSDoc accuracy) → split.
- **curator** (API stability, public surface, backwards compatibility) → split.
- **locksmith** (security, capabilities, attenuation, SES boundary) → split.
- **saboteur** (adversarial inputs, invariant attacks) → split.

The split is the gardener's call; pick names that match the surrounding voice (one-word, evocative, distinct from each other and from the prior six). Note that "halve" is a goal not a constraint: if a seat already has one focused inquiry area, splitting it produces two near-duplicates and the gardener should call that out and either keep it as one seat (panel ends at 11) or carve out a related area that was hiding inside one of the bigger seats and migrate it to the new seat. Document the call in `skills/pr-creation-flow/SKILL.md` § Jury composition.

## Skill and orchestrator updates

- `skills/pr-creation-flow/SKILL.md` § Jury composition: rewrite the seat list, the rationale, and the panel-size discussion. Update the ASCII flow diagram if the seat count is named in it.
- `roles/judge/AGENT.md`: the judge dispatches the panel — the operating norms reference the seat count. Update.
- `skills/panel-review/SKILL.md`: aggregation rules likely don't need to change, but verify.
- `CLAUDE.md` § Current inventory: add the new juror seats; drop the names that are replaced (i.e., the six current names go away if they all split; some may survive if one keeps its narrower remit).
- `roles/liaison/AGENT.md` and `roles/steward/AGENT.md`: if either names the seats in its PR-creation-flow scan, update; if they just reference "the judge dispatches the panel", no edit needed.

## Per-action authorization

Standing on the garden repo (commit + push to `main`, edit `roles/`, `skills/`, top-level docs). No project-side actions.

## Task

1. **Read first.** `roles/COMMON.md`, `roles/gardener/AGENT.md`, then each of the six current juror role files (`roles/assessor/AGENT.md`, `roles/stylist/AGENT.md`, `roles/archivist/AGENT.md`, `roles/curator/AGENT.md`, `roles/locksmith/AGENT.md`, `roles/saboteur/AGENT.md`). Then `roles/judge/AGENT.md`, `skills/pr-creation-flow/SKILL.md` § Jury composition, `skills/panel-review/SKILL.md`. Read the prior gardener's result entry (referenced in this dispatch's `refs:`) for the rationale of the six-seat split — your twelve-seat split inherits that reasoning.

2. **Decide the twelve-seat split.** For each of the six current seats, name two successor seats and the inquiry areas each one carries. State the rationale per split in one line (why this cut, why not a different one). The split should preserve the overlap discipline: the named inquiry areas across all twelve seats should still cover the full review surface, with each area touched by at least two seats.

3. **Author each new role file.** Copy the structure of the current juror role files; adapt the role's section text to its narrower remit. Each role file: purpose (one line), skills list, operating norms (the seat-specific lens), external-repo etiquette, definition of done. Match the surrounding voice.

4. **Decide each prior seat's fate.** Three options per prior seat:
   - **Remove.** The two successor seats cover the area cleanly; the prior file is deleted.
   - **Keep with narrower remit.** One successor seat is essentially the prior seat; the gardener narrows its inquiry-area list. Then only one new seat is authored for the other half.
   - **Migrate.** The prior seat's name is reused for one of the successors (the more natural fit) and the other successor gets a new name.
   
   The gardener picks per seat; document in one line per prior seat.

5. **Update `skills/pr-creation-flow/SKILL.md`.** § Jury composition — rewrite the seat enumeration, the rationale block (now: "twelve seats with halved inquiry areas; each concern is touched by at least two seats; the panel-size rationale is the maintainer's direction toward narrower seats with more overlap"), and any seat-count references elsewhere in the file. Verify the flow ASCII diagram does not name the count; if it does, update.

6. **Update `roles/judge/AGENT.md`.** The judge dispatches each seat as its own `Agent` invocation; with twelve seats the orchestration cost is higher, so the judge's operating norms should call out concurrent dispatch as the default (twelve sequential `Agent` invocations would burn wall-clock). The aggregation discipline is unchanged (panel-review's rules apply).

7. **Verify `skills/panel-review/SKILL.md`.** Likely no edit needed, but read it. If it names the panel size anywhere, update; if it has implicit assumptions about a small panel, surface them.

8. **Update `CLAUDE.md` § Current inventory.** Add the new seat names; remove the prior names that are replaced. Keep the inventory list alphabetized within the roles bullet (or follow whatever ordering the file uses).

9. **Update orchestrator role files** if they name seats. Most likely `roles/liaison/AGENT.md` and `roles/steward/AGENT.md` reference the judge by name, not the seats; verify and edit only if needed.

## Out of scope

- No PR edits on any external repo.
- No retroactive re-dispatch of existing in-flight panels. Future judge dispatches pick up the twelve-seat panel; in-flight panels (if any) continue with whatever seat list they started.
- No edit to the merged-pr-feedback-watch skill or the gardener's standing duty (those are stable from the prior engagement).

## Commits

- One commit per new role file (each of the new seats).
- One commit per removed role file (if any prior seat is removed entirely).
- One commit for the substantively-revised pr-creation-flow.
- One commit for the judge update (and any panel-review edit if needed).
- One commit for the CLAUDE.md inventory.

Push at end. Journal result entry.

## Report

≤ 500 words:
- Final twelve-seat list with one-line rationale per seat and one-line per prior-seat fate (remove / keep narrower / migrate).
- New ASCII for the jury composition (if the diagram changed).
- One-line confirmation the judge's dispatch loop now dispatches twelve seats concurrently.
- One-line `Self-improvement: ...` per `skills/self-improvement/SKILL.md`.
