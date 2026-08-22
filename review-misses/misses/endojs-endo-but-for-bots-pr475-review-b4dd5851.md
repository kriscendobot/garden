---
kind: review-miss
primary_job: endojs-endo-but-for-bots-pr475-review-b4dd5851
verdict: miss
category: type-error
pr: 475
cluster: type-annotation-narrowing-sweep
cluster_pattern: A value-type narrowing tightens the runtime shape but leaves consuming functions' JSDoc type annotations at the pre-narrowing wider union (type-correct, so tsc and the typist pass), and the maintainer must ask why the wider arm remains.
review_at: 2026-08-18T19:44:45Z
repo: endojs/endo-but-for-bots
comment_url: https://github.com/endojs/endo-but-for-bots/pull/475#pullrequestreview-4965116773
identity: endojs/endo-but-for-bots#475:review:4965116773
producing_role: builder
missed_by: typist
severity: minor
---

On this byteArray-narrowing PR the maintainer questioned, in a single inline
comment on `packages/ocapn/src/client/util.js`, why `decodeSwissnum` still typed
its `@param` as the wide `ArrayBufferView | ArrayBufferLike` union, and hedged
that later commits might already moot it. This paraphrase omits the untrusted
review text; the verbatim comment is at `comment_url`.

Grounded in the world, not the primary's report: the current PR head confirms
the union was a pre-narrowing leftover, not a deliberate contract choice. The
handling job (`endojs-endo-but-for-bots-pr475-review-b4dd5851`) landed commit
`f83e8813d` ("refactor(ocapn): narrow decodeSwissnum param to SwissNum") — the
`@param` now reads `{SwissNum}` on the head — and posted an inline reply
(`discussion_r3809374811`) stating the union was over-broad: `decodeSwissnum`'s
only caller (`makeSturdyRefTracker.lookup` in `sturdyrefs.js`) always passes a
`SwissNum` (a branded `Uint8Array`, i.e. an `ArrayBufferView`), and no call site
ever needed the wider arm. So the deliverable exists and there is no
false-resolution discrepancy.

This is a review miss, not new direction, and it is the same shape as the sibling
member `endojs-endo-but-for-bots-pr475-review-662af34e` (a giftId helper left at
the identical union in the same review burst): the PR's whole purpose was
tightening a value type, and the typist lens should verify a narrowing propagated
to the JSDoc annotations of every consuming function. It is distinct from the
`concat.js`/`@endo/bytes` disjunctions dismissed as new-direction
(`pr475-review-605988a6`, `pr475-review-79645bf9`): those sat at genuine
contract edges (embedder-handshake / transport-edge) the producer deliberately
and transparently scoped out with a stated rationale — a defensible deferral.
This one had no such rationale; it was a leftover the producer itself confirmed
"no real call site needed" and narrowed on the spot. Severity is minor: the
surviving arm was over-broad but still type-correct (a `Uint8Array` satisfies
`ArrayBufferView`), so nothing was runtime-wrong — a precision gap the maintainer
had to catch. See `comment_url` to re-fetch the verbatim question.
