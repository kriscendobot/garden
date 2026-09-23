---
kind: result
role: gardener
host: endolin-garden2-5bcdff64
at: 2026-08-22T06:03:07Z
---
---
kind: result
role: prosecutor
project: endo-but-for-bots
refs:
  - jobs/tada/endojs-endo-but-for-bots-pr388-review-04154a91.md
  - review-misses/dismissed/endojs-endo-but-for-bots-pr388-review-04154a91.md
---
# Review retrospective — endo-but-for-bots #388 (review 4945543700)

Second loop for the #388 review directive (primary `endojs-endo-but-for-bots-pr388-review-04154a91`).
Verdict: **not-a-miss / new-direction**. kriskowal's inline comment on
`node-crypto-powers.js` (paraphrase: "can we use a typed array instead of the
ArrayBuffer here?") is maintainer taste/direction, not a garden review-process miss.

Grounds: the builder deliberately chose immutable `ArrayBuffer` as the cross-realm
byte shape citing the in-tree `packages/ocapn` / `@endo/bytes` precedent (typed
arrays cannot be frozen, so are non-passable through `@endo/marshal`/`@endo/patterns`)
and **explicitly surfaced the fork for maintainer confirmation** in the PR body. The
maintainer's `Uint8Array`-as-lingua-franca preference contradicts that precedent, is
encoded in no seat brief / skill / standing instruction, and its clearest statements
are the review itself (2026-06-02 comments on this same PR), so it postdates the
choice. No review check could have anticipated it; the producer correctly elevated
the ambiguity rather than guessing. Not the `prefer-endo-primitives` family (a
type-choice between two competing endo idioms, not a reuse-vs-reimplement miss).

Ground-truth checks (not from the primary's report): the directive deliverable is
real — commit `c709a4d7` ("refactor(gateway): pass Uint8Array DER key without a
Buffer view", 2026-08-16, verified present on the fork) plus in-thread reply
`r3791101756`. Not a false no-op. No gauntlet/panel job exists for #388 in
`jobs/tada/`, but a panel could not have enforced a maintainer taste contradicting
in-tree precedent, so no `process`/avoidance shape either.

Durable dismissal recorded; no cluster minted, no improvement dispatched (a cheap
dismissal per the skill's cost discipline).

Self-improvement: nothing this time.
