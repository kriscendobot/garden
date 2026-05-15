---
ts: 2026-05-15T05:08:21Z
kind: result
role: gardener
refs:
  - entries/2026/05/15/045000Z-dispatch-liaison-fa2b1e.md
---

# Gardener result: design panel grows from 5 seats to 7

Two new juror seats carved per the dispatch brief. Both join the **design panel** (now seven seats). The code panel is unchanged at twelve seats.

## Slug choices

- **Seat 1 (Rich-Hickey-lens):** `decomplector`. Reasons: the verb (`decomplect`, to unbraid) names the seat's primary action; the alternatives `essentialist` / `simplicist` were too abstract for a panel-composition list, `architect` is overloaded across the broader software-engineering vocabulary, `clojurist` is too eponymous-to-language, and `hickey` would have set the precedent of naming seats after people (the rest of the seat list is non-eponymous). The role file calls out the eponym precedent explicitly so future role-authors weigh it before adding another person-named seat.
- **Seat 2 (interface-design):** `ergonomist`. Reasons: tracks the maintainer's framing word "ergonomics" directly; the alternatives `interface` (overloaded with JS / TS / SES interface vocabulary), `usability` (only one slice of the proposed lens), `surface-critic` (compound clunky), and `interaction-designer` (UI-field-specific, narrower than the API+UI scope the brief asked for) all read worse in a seven-seat list.

## Panel assignments

Both seats are **design-panel** additions. Reasoning:

- The **decomplector**'s lens (simple-vs-easy, complecting, value-vs-place, minimum viable abstraction) applies to design choices about state, identity, value, and time. Those choices are decided at design time; once code commits to them, the code panel's `breaker` (invariant attacks on shipped contracts) and `assessor` (control-flow correctness) already cover the after-the-fact slice. The decomplector is the mirror seat across the design / code boundary to the `breaker`: the breaker attacks invariants on shipped code, the decomplector reads the modeling decisions that determine whether those invariants can survive their own implementation. Adding it to the code panel would have duplicated the breaker's surface.
- The **ergonomist** reads the *proposed* surface as a design artifact. The code panel's `curator` already inventories the *shipped* public surface against the changeset, and the `stylist` reads naming on code-side identifiers; neither carries the design-time "is this the right shape for the user?" lens. Reading ergonomics at design time (before code commits to the surface) is load-bearing; reading them again at implementation time would duplicate work.

Seven-seat design panel; twelve-seat code panel; nineteen total jury seats.

## Disambiguation called out in the role files

- `decomplector` vs `critic`: the critic asks "is the chosen approach correct?"; the decomplector asks "regardless of approach, did the design braid concerns that should stay orthogonal?". A design can be critic-clean and decomplector-must-fix.
- `decomplector` vs `breaker`: the breaker attacks invariants on shipped code (`M.interface()` guards, attenuator promises, vat-boundary contracts); the decomplector reads design choices about state, identity, value, and time that determine whether claimed invariants can survive. The secondary overlap is the "this invariant cannot survive its own design's modeling choices" slice; the decomplector flags it on the design PR, the breaker attacks it on the implementation PR.
- `ergonomist` vs `critic`: the critic owns approach correctness; the ergonomist owns surface shape. The two seats hit different layers (right-approach vs right-shape).
- `ergonomist` vs `curator` (code panel): the curator catalogs the shipped public surface; the ergonomist reads the proposed surface at design time. Different artifacts at different times.
- `ergonomist` vs `stylist` (code panel): the stylist reads naming on code-side identifiers in isolation; the ergonomist reads the *set* of names across the surface for spelling-consistency.

## Files edited

Garden (committed and pushed on `main`, single commit `56b4cc6`):

- `roles/decomplector/AGENT.md` (new)
- `roles/ergonomist/AGENT.md` (new)
- `roles/judge/AGENT.md` (panel-size 5 -> 7 in opening paragraph, panel-kind discrimination block, seat list, and operating-norms reference; new Notes-from-the-field bullet for 2026-05-15)
- `skills/pr-creation-flow/SKILL.md` (ASCII flow diagram, two prose mentions of design-only panel size, Jury composition section opening, design-panel seat list, *Why X seats for the design panel* heading and rationale, new Notes-from-the-field bullet for 2026-05-15)
- `skills/panel-review/SKILL.md` (opening adoption note, Panel composition design-panel bullet, aggregated-body word range, new Notes-from-the-field bullet for 2026-05-15)
- `roles/liaison/AGENT.md` (the-gamut vocabulary phrase 5 -> 7)
- `roles/steward/AGENT.md` (the-gamut vocabulary phrase 5 -> 7)
- `CLAUDE.md` § Current inventory (roles list adds two slugs; jury-seat tally 17 -> 19; design panel listed at 7 seats; new clause records the 2026-05-15 expansion alongside the existing 2026-05-14 lineage)

Rebase conflict on `CLAUDE.md` (remote landed `pr-handoff` skill between dispatch start and push); resolved by combining the new role slugs with the new skill, kept both.

Judge `Panel-kind discrimination` block needed no shape change beyond the size update; the detection rule (every path under `<project>/designs/`) is panel-kind orthogonal to seat count.

## Out of scope

- No code on any project repo.
- No comment on any PR.
- No probe of design #138 or other live engagements.
- Did not consult or modify monitoring-related files; monitoring safety constraint untouched.

Self-improvement: When growing a default panel size (here, design panel 5 -> 7), the load-bearing sweep is grep-walking every cross-reference to the old size and verifying each is either updated to the new size *or* explicitly historical (a Notes-from-the-field entry that records the prior state). The conflict on CLAUDE.md during push (remote landed `pr-handoff`) was a reminder that the garden's main branch can move under a long-running gardener dispatch and the conflict resolution is the gardener's job, not the orchestrator's; gardeners should fetch and rebase before push as a matter of course rather than discovering the conflict at push time. Notes from the field, not a rule yet (one observation).
