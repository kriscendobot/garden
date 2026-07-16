---
kind: review-miss
primary_job: endojs-endo-but-for-bots-pr721-review-56349e18
verdict: miss
category: style-convention
pr: 721
cluster: inline-import-jsdoc
cluster_pattern: Type references written as inline import() inside a JSDoc tag (@param/@returns/@type {import('./x.js').Y}) instead of a top-of-file @import { Y } from './x.js' tag plus a bare reference — a standing Endo house rule whose no-inline-import-jsdoc pre-push gate is documented but has no implementing probe script, so it never binds, and the typist backstop did not fire.
repo: endojs/endo-but-for-bots
comment_url: https://github.com/endojs/endo-but-for-bots/pull/721#pullrequestreview-4690781908
identity: endojs/endo-but-for-bots#721:review:4690781908
producing_role: builder
producing_job: gauntlet-endo-but-for-bots-pull-request-721-endo-reminder-message-scheduler-plugin
missed_by: typist seat (@import-over-inline-import() backstop) + the no-inline-import-jsdoc pre-push gate (documented, never implemented)
severity: major
---

# Review-miss: inline import() JSDoc where an @import tag was wanted (Endo house style)

On the `@endo/reminder` plugin PR (#721), a MEMBER (kriskowal) submitted a
CHANGES_REQUESTED review whose body — in paraphrase (see `comment_url` for the
verbatim text) — asks to rerun the gauntlet **with emphasis on style**, plus four
inline comments on `packages/reminder/src/store.js`. This record concerns the one
inline item that indicts a **standing rule**: "Favor `@import` jsdocs." The file
authors its type references as inline `import('./types.js').ReminderStore*` inside
`@param` and `@returns` tags (four sites: lines 37, 40, 53, 67 at review commit
`bee451e`) instead of a top-of-file `/** @import { ReminderStore } from
'./types.js' */` tag with bare references thereafter.

The review's other three inline items are **not** part of this miss and are
recorded here as grounds context only (they are new direction, addressed by the
primary loop, not the review process): (a) eliminate the Node/POSIX coupling via a
`maybeRead` virtual-filesystem method — an architecture proposal; (b) call `json`
directly on the file, explicitly "if out of scope, post a job" — a scope
suggestion; (c) `readJSON` should be spelled `readJson` and "note in style guide"
— a first-codification request for an initialism-casing convention that **no seat
brief, skill, or gate currently encodes** (the stylist brief even leaves platform
names like `URL` as-is), so the panel could not have anticipated it.

## Grounds

**Why the `@import` item is a miss, not new direction.** The
`@import`-over-inline-`import()` preference is a pre-existing, mechanizable,
one-correct-answer Endo house rule, not fresh taste. It is written into the
builder directive (`roles/builder/AGENT.md` — "Mirrors the
`@import`-over-inline-`import()` rule") and catalogued as the `no-inline-import-jsdoc`
row in `skills/pre-push-gates/SKILL.md`, whose provenance is an earlier maintainer
request on `endojs/endo-but-for-bots#75` (`r3223741240`, "we prefer `@import`
jsdoc"). By the discriminator's test — *should the review have caught this?* — yes:
the rule already existed and this is a repeat, so it is a sense-and-correct failure,
not an encode-the-rule-first situation.

**Why it did not bind — two concrete gaps.** (1) The `no-inline-import-jsdoc`
pre-push gate is a **phantom**: it is documented in the SKILL table and named in the
builder directive's gate enumeration, but there is **no implementing probe script**
under `scripts/jobs/gardening/pre-push-gates/probes/` — only `spell-out-identifiers`,
`typedefs-belong-in-dts`, and `typist-friendly-code-points` exist. A gate that is
prose-only cannot catch anything. (2) The typist seat is the always-on backstop for
`@import` discipline, but its brief's written check is scoped to *typedef location*
(typedef-only `.js` modules and inline `@typedef` blocks), naming the
`@import`-over-inline-`import()` rule only as a "sibling" — it does not explicitly
instruct flagging an inline `import()` inside a `@param`/`@returns`/`@type` tag, and
it did not fire on #721.

**Panel history.** The #721 gauntlet
(`jobs/tada/gauntlet-endo-but-for-bots-pull-request-721-endo-reminder-message-scheduler-plugin.md`)
ran a correctness/concurrency + ocap-security/hardening + packaging/types/tests
panel and found and fixed several real must-fix items (recovery deadline clobber,
unbounded recovery allocation, `normaliseEntry` under-validation). It did **not**
weight style: none of its findings touch import-JSDoc shape, and the maintainer had
to explicitly ask for a style-emphasis rerun. That the panel produced a strong
correctness pass yet missed a codified style convention is the shape of this miss.

**Severity: major (dispatch via the severity bypass).** This mirrors the
`typedef-location-dts` precedent exactly: a single count=1 miss dispatched below the
numeric floor because its grounds cite a standing rule that already existed and did
not bind, spanning two distinct PRs (#75 → #721). It is arguably a stronger case
than that precedent — there the enforcement gap was "only prose"; here the gate is
documented *as if implemented* yet has no script at all, so both the deterministic
tier and the panel backstop failed. Waiting for a third maintainer complaint about a
convention he already asked to prevent is the wrong trade.
