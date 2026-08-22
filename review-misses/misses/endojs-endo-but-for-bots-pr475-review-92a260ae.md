---
kind: review-miss
primary_job: endojs-endo-but-for-bots-pr475-review-92a260ae
verdict: miss
category: type-error
pr: 475
cluster: type-annotation-narrowing-sweep
review_at: 2026-08-18T20:09:52Z
repo: endojs/endo-but-for-bots
comment_url: https://github.com/endojs/endo-but-for-bots/pull/475#pullrequestreview-4965315618
identity: endojs/endo-but-for-bots#475:review:4965315618:retro
producing_role: builder
producing_job: endo-byte-array-press (byteArray-narrowing campaign)
missed_by: typist
severity: minor
grounds: |
  PR #475's stated purpose was to narrow the byteArray runtime shape to a plain
  frozen Uint8Array, but the reviewed commit still carried the pre-narrowing
  `ArrayBufferView | ArrayBufferLike` disjunction throughout the changed byte
  APIs and their consumers. A direct scan of review commit ce8d0578 found the
  union in bytes, hex, ocapn, pass-style, and utf8 source annotations. The
  maintainer therefore had to request a head-wide enumeration rather than
  receiving one from the review process.

  This was anticipatable from the diff and the PR's narrowing contract. The
  typist seat's standing primary surface explicitly asks whether JSDoc parameter
  types reflect the runtime shape callers pass and whether type narrowings hold
  at function boundaries. The branch history later confirmed that this was not
  deliberate generality: commits including 8cb54f46d, f37c11e50, f0a05a165,
  3f2247766, and the ocapn narrowing commits removed the disjunctions, and the
  eventual sweep reported zero remaining byteArray-surface buffer-vs-view
  unions. This is an ordinary review miss, not evaluator gaming: the producer
  left stale, type-correctly broad contracts rather than altering or routing
  around the type reviewer.

  The review landed before the only recorded incremental gauntlet for this
  head, `endojs-endo-but-for-bots-pr475-gauntlet-20260819`; that later panel's
  types/style/docs lens did not retroactively supply the missing pre-maintainer
  sweep. This joins `type-annotation-narrowing-sweep`, whose first member is the
  same failure at one internal ocapn helper. This review exposed the systemic
  head-wide form. Severity is minor because the unions were over-broad but
  type-correct and the maintainer caught them before merge.
---

The maintainer requested an inventory of every remaining type union that still
admitted a bare buffer-like value after the PR had narrowed byteArray to a
Uint8Array. The review miss is that the typist did not sweep the changed byte
surfaces and their consumers for stale pre-narrowing annotations. See
`comment_url` for the untrusted original text.
