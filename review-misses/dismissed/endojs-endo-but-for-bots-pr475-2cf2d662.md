---
kind: review-miss-dismissed
primary_job: endojs-endo-but-for-bots-pr475-2cf2d662
verdict: not-a-miss
category: new-direction
review_at: 2026-08-21T00:03:28Z
repo: endojs/endo-but-for-bots
comment_url: https://github.com/endojs/endo-but-for-bots/pull/475#issuecomment-5363532145
identity: endojs/endo-but-for-bots#475:comment:5363532145:retro
---

Directive comment on PR #475 (narrow byteArray to a plain frozen Uint8Array): the
maintainer, having discussed the design with a co-maintainer, asks to roll back the
`isEmulatedView` predicate and instead differentiate views with a conjunction that
includes `ArrayBuffer.isView`, and to finish shimming `DataView` (and the whole gamut
of array-buffer views) on immutable ArrayBuffer so the DataView-versus-Array-view axis
is shown not to be a useful differentiator.

Grounds: this is a genuine design reversal reached by human discussion, not an
indictment of #475's review. The `isEmulatedView` predicate was not a garden invention
the panel should have questioned — it was maintainer-solicited work: the garden proposed
it, the co-maintainer explicitly replied "Yes, please spec that" (comment 5348069925),
and the garden then posted a full contract spec (job
endojs-endo-but-for-bots-pr475-spec-genuine-predicate-20260819,
https://github.com/endojs/endo-but-for-bots/pull/475#issuecomment-5349227927) that the
maintainer reposted "as requested... for you to read and decide on," stating nothing was
implemented yet. That spec itself surfaced the very tradeoff the reversal turns on — it
documented the committed equivalence isEmulatedView(v) === !ArrayBuffer.isView(v) over
byteArray inputs and the "brand is stronger/total vs isView is the memorable basis"
choice. The maintainers weighed that documented tradeoff and, after discussion, chose the
conjunction-plus-finish-DataView direction. No standing rule, seat brief, or convention
said "never introduce a predicate redundant with a conjunction of existing predicates,"
and even if one had, it could not bind here: the predicate was an explicitly requested,
not-yet-merged spec deliverable awaiting a human decision, which is the review process
working as designed (post a spec, let the maintainer decide) rather than a gate that
should have rejected merged code. This is a first-stated requirement in the comment
itself, hinging on the maintainers' judgment about whether DataView-vs-Array-views is a
useful axis — nobody in the #475 gauntlet could have anticipated it. No evaluator-gaming
shape applies: the predicate was not routed around any gate, and no seat's measurable
check was met while its purpose went unmet.

Verified against the world, not the primary report: the primary (2cf2d662) was a routing
job that dispatched the rollback to fixer job
endojs-endo-but-for-bots-pr475-fix-dataview-20260821, which genuinely executed it —
`isEmulatedView` no longer appears in packages/immutable-arraybuffer/src/lib.js at the
fixer commit (46187246867), DataView emulation was completed, and the PR head has since
advanced past it (4dbe5ffff6). So the directive was actually carried out, not falsely
claimed as resolved.
