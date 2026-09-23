---
slug: inline-import-jsdoc
category: style-convention
status: open
count: 2
members:
  - endojs-endo-but-for-bots-pr721-review-56349e18
  - endojs-endo-but-for-bots-pr792-review-91808a86
prs: [721, 792]
improvement_job: review-improve-inline-import-jsdoc
improved_by: 0c569a64e4 gate: enforce no inline import JSDoc types; d0da42892a review: backstop inline import JSDoc in typist panel; scripts/jobs/gardening/pre-push-gates/probes/no-inline-import-jsdoc.sh; roles/{builder,fixer,jurors/typist}/AGENT.md; skills/{pre-push-gates,panel-hints}/
---




Type references written as inline import() inside a JSDoc tag (@param/@returns/@type {import('./x.js').Y}) instead of a top-of-file @import { Y } from './x.js' tag plus a bare reference — a standing Endo house rule whose no-inline-import-jsdoc pre-push gate is documented but has no implementing probe script, so it never binds, and the typist backstop did not fire.

**Threshold rationale:** Dispatched below the numeric floor (count=1, prs={721}) via the **severity bypass**:
a single `severity: major` miss whose grounds cite a standing rule that already
existed and did not bind. The `@import`-over-inline-`import()` convention is written
in the builder directive (`roles/builder/AGENT.md`) and catalogued as the
`no-inline-import-jsdoc` row in `skills/pre-push-gates/SKILL.md` (provenance:
maintainer request on `endojs/endo-but-for-bots#75`, `r3223741240`, "we prefer
`@import` jsdoc"), and it recurred on #721 — two distinct PRs (#75 → #721).

This is arguably a stronger bypass case than the `typedef-location-dts` precedent it
mirrors: there the enforcement gap was "prose only"; here the gate is documented **as
if it were implemented** yet has **no probe script** under
`scripts/jobs/gardening/pre-push-gates/probes/` (only `spell-out-identifiers`,
`typedefs-belong-in-dts`, `typist-friendly-code-points` exist), and the typist
backstop's written check is scoped to typedef *location* rather than inline-`import()`
in a `@param`/`@returns`/`@type` tag — so both the deterministic tier and the panel
backstop failed simultaneously. Waiting for a third maintainer complaint about a
convention he already asked to prevent is the wrong trade.

Dispatched `review-improve-inline-import-jsdoc` (identity
`review-cluster:inline-import-jsdoc`) with the two-part contract: (a) implement the
missing `no-inline-import-jsdoc` probe covering inline `import()` in any JSDoc tag,
and (b) sharpen the typist seat brief to own the inline-`import()`-in-any-tag shape
plus a panel-hints probe firing the typist on that diff signal.
