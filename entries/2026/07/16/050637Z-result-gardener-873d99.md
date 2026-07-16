---
kind: result
role: gardener
host: endolin-garden2-5bcdff64
at: 2026-07-16T05:06:39Z
---
---
role: prosecutor
refs:
  - endojs-endo-but-for-bots-pr721-review-56349e18-retro
  - endojs/endo-but-for-bots#721:review:4690781908:retro
---

# Retrospective: endojs/endo-but-for-bots #721 review 4690781908 — review-miss (style-convention), improvement dispatched

Second loop for the #721 MEMBER review ("rerun the gauntlet, emphasis on style" +
four inline `store.js` comments). Idempotency pre-check clean (no prior
misses/dismissed record for the primary base).

**Discrimination.** Of the four inline items, three are **new direction** (a
Node/POSIX-coupling `maybeRead` VFS refactor; calling `json` directly, explicitly
"if out of scope post a job"; and `readJSON`→`readJson` "note in style guide", an
initialism-casing convention no seat/skill/gate encodes yet — the stylist even
leaves `URL` as-is). The fourth — "Favor `@import` jsdocs" — is a **miss**:
`store.js` used inline `import('./types.js').X` in four `@param`/`@returns` tags,
violating a codified Endo house rule (builder directive + `no-inline-import-jsdoc`
row in `skills/pre-push-gates/SKILL.md`, provenance #75 `r3223741240`). The rule did
not bind for two concrete reasons: the `no-inline-import-jsdoc` gate is documented
but has **no implementing probe script** (only three probes exist), and the typist
backstop's written check covers typedef *location*, not inline `import()` in a tag.
Grounded in the #721 gauntlet report, which ran a correctness/security/packaging
panel and produced no style findings.

**Recorded.** `review-misses/misses/endojs-endo-but-for-bots-pr721-review-56349e18.md`
→ new cluster `inline-import-jsdoc` (category `style-convention`, count=1, prs={721}).

**Threshold.** Below the numeric floor but dispatched via the **severity bypass**
(`severity: major`, a standing rule that existed and did not bind, #75 → #721),
mirroring the `typedef-location-dts` precedent — and stronger, since here the gate is
documented as if implemented yet has no script.

**Dispatched** `review-improve-inline-import-jsdoc` (identity
`review-cluster:inline-import-jsdoc`) with the two-part contract: (a) implement the
missing `no-inline-import-jsdoc` probe covering inline `import()` in any JSDoc tag +
wire it in and reconcile the docs; (b) sharpen the typist seat to own the
inline-`import()`-in-any-tag shape plus a panel-hints probe firing the typist on that
signal — with the per-member re-litigation test on #721 `store.js`. Cluster marked
`improvement-dispatched`.

Self-improvement: the sharpest lesson here is that a *documented* gate is not an
*implemented* one — `no-inline-import-jsdoc` read as enforced in the SKILL table and
builder enumeration while no probe script backed it, so both the deterministic tier
and the panel backstop silently failed. A cheap future guard would be a meta-probe
asserting every `no-*`/probe row in `skills/pre-push-gates/SKILL.md` has a matching
script under `pre-push-gates/probes/`; I noted this to the improvement builder as
adjacent context rather than widening this job's scope.
