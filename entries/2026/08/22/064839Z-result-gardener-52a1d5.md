---
kind: result
role: gardener
host: endolin-garden2-5bcdff64
at: 2026-08-22T06:48:41Z
---
Second-loop review retrospective on endojs/endo-but-for-bots PR #475, review
`4965116773` by erights (retro identity `...:review:4965116773:retro`), worn as
prosecutor per skills/review-retrospective/SKILL.md.

Verdict: **miss** (category `type-error`, missed_by `typist`, severity minor).
The single inline comment questioned why `decodeSwissnum`
(packages/ocapn/src/client/util.js) still typed its `@param` as the wide
`ArrayBufferView | ArrayBufferLike` union after the byteArray narrowing. Grounded
in the world: the union was a pre-narrowing leftover — the only caller always
passes a branded `SwissNum` (Uint8Array); the handling job landed `f83e8813d`
narrowing the param to `{SwissNum}` (confirmed on the head) and posted reply
`discussion_r3809374811`. The typist lens should have swept consuming JSDoc
annotations when the value type narrowed.

Recorded via review-miss-record.sh → misses/endojs-endo-but-for-bots-pr475-review-b4dd5851.md,
joining cluster `type-annotation-narrowing-sweep` (count 1→2, prs=[475], open).
This is the same shape as sibling member `...-review-662af34e` (a giftId helper in
the same review burst), and distinct from the `concat.js`/`@endo/bytes`
disjunctions dismissed as new-direction (`605988a6`, `79645bf9`), which sat at
contract edges the producer deliberately deferred with a stated rationale.

Threshold: HELD below floor. The cluster now holds 2 misses but spans only ONE
distinct PR (475); the floor is K≥3 across ≥2 PRs, and severity is minor (no
bypass). The two-PR guard correctly stops a single narrowing-heavy PR from
masquerading as a systemic pattern — no `review-improve-*` job dispatched.

Refs: endojs/endo-but-for-bots#475:review:4965116773:retro
