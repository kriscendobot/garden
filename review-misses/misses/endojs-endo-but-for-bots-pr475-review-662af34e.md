---
kind: review-miss
primary_job: endojs-endo-but-for-bots-pr475-review-662af34e
verdict: miss
category: type-error
pr: 475
cluster: type-annotation-narrowing-sweep
cluster_pattern: A value-type narrowing tightens the runtime shape but leaves consuming functions' JSDoc type annotations at the pre-narrowing wider union (type-correct, so tsc and the typist pass), and the maintainer must ask why the wider arm remains.
review_at: 2026-08-18T19:43:58Z
repo: endojs/endo-but-for-bots
comment_url: https://github.com/endojs/endo-but-for-bots/pull/475#discussion_r3807376129
identity: endojs/endo-but-for-bots#475:review:4965110297
producing_role: builder
missed_by: typist
severity: minor
---

On this byteArray-narrowing PR the maintainer questioned, in a single inline
comment, why an internal `@endo/ocapn` helper still accepted a wide
`ArrayBufferView | ArrayBufferLike` union for a parameter that, after the
narrowing, always receives a plain frozen `Uint8Array`. He hedged that later
commits might already moot it.

Grounded in the world, not the phrasing: the handed-off fixer
(`endojs-endo-but-for-bots-pr475-util-bytearray-view-type`, completed) confirmed
the union was a **pre-narrowing leftover** and landed commit `267e98f1d`
narrowing the annotation to `Uint8Array`. Narrowing it made `tsc` fail on two
downstream giftId call sites, so the fixer traced the chain and tightened four
more annotations plus two stale runtime-type comments — evidence the over-broad
arm was masking imprecision across a family of consuming sites, not a deliberate
backward-compat choice (contrast the genuinely external `@endo/bytes`
`ArrayBufferLike` arm the fixer left untouched).

This is a review miss, not new direction: the PR's whole purpose was tightening
a value type, and the typist lens should verify a narrowing propagated to the
JSDoc type annotations of every consuming function. It is the type-annotation
facet of a recurring PR-475 narrowing-remnant family already recorded as name,
comment, and sibling-call-site misses. Severity is minor: the surviving arm was
over-broad but still type-correct (a `Uint8Array` satisfies `ArrayBufferView`),
so nothing was runtime-wrong; it was a precision/tidiness gap the maintainer had
to catch. See comment_url to re-fetch the verbatim question.
