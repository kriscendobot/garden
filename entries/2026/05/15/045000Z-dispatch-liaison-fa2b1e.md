---
ts: 2026-05-15T04:50:00Z
kind: dispatch
role: liaison
project: garden
to: "*"
---

# Dispatch: gardener carves two new juror seats — a Hickey-modeled critic + an interface-design critic

Dispatch root: `dispatches/gardener--fa2b1e/`. Garden-only (no project worktree).

Maintainer directive (2026-05-15): *"Please dispatch the gardener to design more jurors. One should be modeled on Rich Hickey. Another as an interface design critic."*

## The two seats

### 1. Hickey-modeled juror

Modeled on **Rich Hickey**, the designer of Clojure and author of the *Simple Made Easy* (2011) talk and several others (*Hammock Driven Development*, *The Value of Values*, *The Language of the System*, *Maybe Not*, *Are We There Yet?*). His distinctive lenses, drawn from those talks:

- **Simple vs easy.** "Simple" = one-fold, one role, no interleaving (de-*complected*). "Easy" = near at hand, familiar, fast to start. The two are orthogonal; conflating them is the load-bearing failure mode the seat watches for.
- **Complecting vs decomplecting.** Has this design braided two concerns that should remain separate? State + identity, time + value, behavior + interface, what + how.
- **Essential vs accidental complexity.** Of the complexity in the proposed approach, how much is essential to the problem vs accidental to the tooling/framework/legacy choice?
- **Data > functions > macros.** Is the design treating data as inert and accessible, or has it wrapped data in behavior that obscures it?
- **Place-oriented vs value-oriented.** Is the proposal preserving immutable values across time (history-preserving, queryable) or mutating in place (lossy, race-prone)?
- **"What's the minimum viable abstraction?"** Has the design proposed three when one would suffice?

Surface this lens primarily; the seat is NOT a substantive-critique seat (the existing `critic` covers that). The seat's value-add is the specific Hickey-style framing: it would call out a design as *simple-but-not-easy* (a hard win worth fighting for) or as *easy-but-not-simple* (a trap that will cost downstream).

The gardener picks the slug. Candidates: `essentialist`, `architect`, `clojurist`, `hickey`, `decomplector`, `simplicist`. Pick whichever is most evocative and least overloaded. (`architect` collides with general-software-architecture usage; `clojurist` is too eponymous; `hickey` is fine but "name a seat after a person" sets a precedent that may not generalize — flag in the gardener's design notes.)

### 2. Interface-design critic

A seat whose lens is **interface ergonomics** — for both APIs and UIs:

- **API surface coherence.** Does the proposed surface compose with sibling APIs? Are similar operations spelled similarly? Are parameter orderings consistent?
- **Discoverability.** Can a new caller (or new user) find the right entry point from the top of the surface? Is the most common operation the easiest to invoke?
- **Principle of least surprise.** Does the surface behave the way an experienced user would predict, based on its naming and shape?
- **Naming.** Are identifiers chosen for the *user's* mental model or the *implementer's*? Are noun/verb conventions consistent?
- **Affordance and error visibility.** What happens at the failure surface? Are errors actionable? Is recovery a path the design names?
- **For UI proposals.** Layout signal-to-noise, accessibility, the user's path through the feature, where state lives in the user's head.
- **For API proposals.** Parameter ordering, return shape, default behaviors, optional vs required arguments, the failure boundary's shape.

This seat overlaps with the existing `critic` (substantive critique of approach) and `curator` (code-panel: package surface inventory). The gardener disambiguates: the interface-design critic's primary surface is **ergonomics of the proposed surface**, where `critic` asks "is this the right approach?" and `curator` asks "what does this PR add to/remove from the package's public surface?".

The gardener picks the slug. Candidates: `ergonomist`, `usability`, `interface`, `surface-critic`, `interaction-designer`. Pick whichever reads cleanly in a panel composition list.

## Task

Read `garden/roles/COMMON.md` and pick a few existing juror role files as the model:

- `garden/roles/critic/AGENT.md` (design panel)
- `garden/roles/skeptic/AGENT.md` (design panel — note its overlap with `critic` and how it's articulated)
- `garden/roles/saboteur/AGENT.md` (code panel — note primary/secondary surface pattern)
- `garden/roles/pedant/AGENT.md`, `garden/roles/novice/AGENT.md`, `garden/roles/copyeditor/AGENT.md` (design panel seats — for tone)
- `garden/roles/breaker/AGENT.md` (code panel, contract-oriented — close cousin of the Hickey seat's invariant lens)

For each new seat:

1. **Author `garden/roles/<slug>/AGENT.md`** with the standard juror shape:
   - Frontmatter (created today, author=gardener).
   - One-paragraph purpose stating primary surface and secondary overlap (with the seat it brushes against).
   - "When to enter this role" section.
   - Skills section (COMMON, worktree-per-pr, panel-review, pr-creation-flow, em-dash-style/relative-paths, self-improvement).
   - Operating norms (primary surface, secondary surface, verdict criteria, terseness ≤400 words, "submit per-juror block as a `result` journal entry, judge aggregates").
   - External-repo etiquette (does not post directly).
   - Definition of done.

2. **Decide panel assignment.** Both seats are most naturally design-panel seats (lens applies to design docs); the Hickey seat's lens also touches code where state/identity choices are made. The gardener picks; surface the reasoning. If a seat joins the code panel, that's a 13-seat panel; if design panel, that's a 7-seat panel; if both, that's both.

3. **Update `garden/skills/pr-creation-flow/SKILL.md`** § Jury composition (the section that names the 12 + 5 seats). Add the new seat(s) with one-line each. Update the panel-size in any cross-references.

4. **Update `garden/CLAUDE.md`** § Current inventory:
   - Add the new seats to the role list.
   - Update the jury-seat tally line ("seventeen jury-seat roles split across two default panels" → new total).
   - Add a one-line history bullet if the gardener wants to preserve the 2026-05-15 expansion (parallel to the existing 2026-05-14 redesign mention).

5. **Update `garden/roles/judge/AGENT.md`** § Panel-kind discrimination if the panel composition note lives there too.

6. **Write the result entry** at `journal/entries/2026/05/15/<ts>-result-gardener-fa2b1e.md` with file list, slug choices, panel assignments, reasoning.

7. **Commit + push both branches** (main for encoded changes, journal for result entry).

## Per-action authorization

Standing on garden's main + journal branches per CLAUDE.md § Conventions.

## Out of scope

- No code on any project repo.
- No comment on any PR.
- No probe of design #138 or any other live engagement.

## Report

≤ 350 words: two slug choices + panel assignments, reasoning for each (especially the disambiguation from `critic` for the interface-design seat, and from `breaker` for the Hickey seat's invariant/state overlap), file list edited (the two new AGENT.md files + pr-creation-flow + CLAUDE.md + judge if touched), one-line `Self-improvement: ...`. The liaison surfaces the new seats on the bulletin if the maintainer finds them ready for use.
