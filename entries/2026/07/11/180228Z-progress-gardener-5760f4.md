---
kind: progress
role: gardener
host: endolin-garden2-5bcdff64
at: 2026-07-11T18:02:30Z
---
# endo-sturdyref-press tick 1 (2026-07-11T17:50 dispatch) — assessment + two presses

Standing hourly press-driver for SturdyRefs (OCapN + Endo agents, `endojs/endo-but-for-bots`, base `llm`). First tick of the schedule.

## Assessment (state as found)

- **#539** (settled design: on-demand enlivenment via the closely-held OCapN network capability) — all five maintainer inline directives addressed at `aa104684c` on 6/26; no movement since. Base still stale `llm-65b0abe`.
- **#521** (pass-style category, base `llm-27f53e6`, single commit `0ad8d1b02`) — predates the redirect and CONTRADICTS the settled design: pass-style exports a `makeSturdyRef` maker + module-private locator WeakMap, where the maintainer directed shape-only pass-style with session-manager construction; also carries the `getStudyRefLocator` typo.
- **#541** — on hold since 6/26 (built the abandoned endor-syscall retention edges); read-side threading awaits re-scope to enliven-at-the-boundary. Last commit 7/2 was a tsconfig regen only.
- No live peer sturdyref workers (inbox-list / jobs/doin checked). Effort stalled since 7/2.

## Pressed this tick

1. **#539 design refinement (inline):** encoded the binding Distributed Confinement invariants — commit `4537e4a5c` on `design/sturdy-refs-endor-syscall-followup`, comment `4948199929`. The doc said a confined guest holds "an opaque SturdyRef" while giving SturdyRef a readable `location` accessor; resolved with the two-tier split (location-bearing SturdyRef = trusted/wire tier; fresh unlinkable opaque guest-scoped token = confined tier, mediator-resolved), three binding invariants (no location / no identification / opaque & unforgeable), four confinement tests in the test plan, a confinement acceptance criterion, and one scoped open question (token representation). Confinement property preserved: this artifact *strengthens* both no-location and no-identification; nothing widened.
2. **Posted builder sub-job** `ebfb-realign-521-passstyle-shape-only` (identity `endojs/endo-but-for-bots#521:realign-shape-only`): realign #521 to design cuts 1–2 (shape-only pass-style with `location`+`type` accessors, no maker, typo'd `getStudyRefLocator` dropped; ocapn session manager constructs, tagged-shim dropped), additive commits, PR stays DRAFT, confinement test that the swiss number is never readable.

## Verification status

Design-only edits this tick — no test suite applies (not verified ≠ regression; no behavior landed). The realign sub-job carries the real-execution bar (yarn install + affected suites, observed output required).

## Next unblocked artifacts (for the next tick)

1. Watch/verify `ebfb-realign-521-passstyle-shape-only` (don't race its branch).
2. After realign lands: re-scope #541 to design cuts 3–4 (facet guards + `revealSturdyRef` boundary resolution, retention edges stripped).
3. Then: guest-scoped opaque token representation (the new open question) → agent provide/accept surface (Lal/Fae/Genie, `@endo/agent-tools`) — still unbuilt.
4. Base hygiene at landing time: #539/#511 still on stale `llm-65b0abe`.
