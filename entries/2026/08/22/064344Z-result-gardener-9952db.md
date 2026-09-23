---
kind: result
role: gardener
host: endolin-garden2-5bcdff64
at: 2026-08-22T06:43:48Z
---
# Retrospective: endojs/endo-but-for-bots PR #475 review 4965110297 (erights)

**Verdict: review-miss (minor).** Recorded as
`review-misses/misses/endojs-endo-but-for-bots-pr475-review-662af34e.md`.

erights asked, in one inline comment on `packages/ocapn/src/client/util.js`, why
an internal `@endo/ocapn` helper still accepted `ArrayBufferView | ArrayBufferLike`
for a parameter that after the byteArray→Uint8Array narrowing always receives a
plain frozen `Uint8Array`.

Grounded in the world: the handed-off fixer
(`endojs-endo-but-for-bots-pr475-util-bytearray-view-type`, completed) confirmed
the union was a pre-narrowing leftover and landed `267e98f1d` narrowing `toHex`
and the giftId chain to `Uint8Array` — tsc even flagged two downstream giftId
sites, showing the over-broad arm masked imprecision across a family of consuming
sites (contrast the genuinely external `@endo/bytes` `ArrayBufferLike` arm, left
untouched). This is the type-annotation facet of the recurring PR-475
narrowing-remnant family; the typist lens should verify a value-type narrowing
propagated to consuming functions' JSDoc annotations.

**Cluster:** minted `type-annotation-narrowing-sweep` (category `type-error`,
missed_by `typist`), count=1, prs={475}, status=open.

**Threshold: HOLD, no dispatch.** Below the floor (K≥3 across ≥2 distinct PRs):
count=1 on a single PR. Severity minor (annotation over-broad but still
type-correct — a `Uint8Array` satisfies `ArrayBufferView` — so nothing was
runtime-wrong), so the single-major standing-rule bypass does not apply; no
pre-existing seat brief required narrowing-propagation-to-annotations.

**Meta-observation (not itself a dispatch trigger).** PR #475 now carries FIVE
single-PR narrowing-remnant clusters — `incomplete-sibling-transformation`,
`name-contradicts-value-type`, `semantic-name-matches-value-kind`,
`stale-identifier-reference-sweep`, and now `type-annotation-narrowing-sweep` —
each count=1, all prs={475}. Collectively they hint at a missing panel lens: a
"narrowing blast-radius sweep" that enumerates names, comments, JSDoc types, and
sibling call sites of a value-type narrowing and verifies each was converted. The
floor's ≥2-PR requirement deliberately withholds dispatch until a second
narrowing PR reproduces one of these facets — at which point the touched facet's
cluster (or a merged super-cluster) should trip. Flagged here so the next
narrowing PR's retro escalates rather than re-discovers.

refs: jobs/tada/endojs-endo-but-for-bots-pr475-review-662af34e.md,
jobs/tada/endojs-endo-but-for-bots-pr475-util-bytearray-view-type.md

Self-improvement: none — the discriminator, store writer, and threshold rules
carried this cleanly; the only friction was locating the store on journal2 vs the
main2 root, already documented in the skill.
