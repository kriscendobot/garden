---
kind: review-miss-dismissed
primary_job: endojs-endo-but-for-bots-pr475-review-79645bf9
verdict: not-a-miss
category: new-direction
review_at: 2026-08-19T19:37:01Z
repo: endojs/endo-but-for-bots
surface: pr-review-body
author: erights
comment_url: https://github.com/endojs/endo-but-for-bots/pull/475#pullrequestreview-4976041518
identity: endojs/endo-but-for-bots#475:review:4976041518:retro
producing_role: none (maintainer opening a Socratic scope-expansion inquiry)
missed_by: none
severity: minor
---

# Dismissal: the opening question of the already-resolved concat.js disjunction thread

erights' COMMENTED review on #475 (empty review body; substance in one inline
comment on `packages/bytes/src/concat.js`, verbatim untrusted text at
`comment_url` / discussion comment `r3816135565`). Paraphrase: he asks why the
`ArrayBufferView | ArrayBufferLike` type disjunction still occurs, and — as a
Socratic design-rationale challenge — why any functions should accept both, or be
typed to accept both.

## Grounds (not-a-miss — new-direction)

This is the **opening move of a thread whose resolution is already recorded and
already dismissed as new-direction**, grounded in the world, not in the primary's
report:

- The inline comment (`r3816135565`, 2026-08-19T19:35) is the head of one thread.
  The producer replied that narrowing the two surviving disjunctions would ripple
  through the embedder-handshake / transport-edge contracts — a separate
  contract-level decision from the byteArray narrowing — and offered to fold them
  in "just say the word." erights then replied (`r3816791313`, 2026-08-19T21:18)
  "Yes, please do that in a separately reviewable commit." That closing reply was
  minted as retro `endojs-endo-but-for-bots-pr475-review-605988a6`, which was
  **already recorded as `not-a-miss` / new-direction** and verified the deliverable
  landed on the head (`cbe716bd42` narrow hub handshake-identity bytes; `200cb152ad`
  narrow decodeFrame). I independently re-confirmed both commits exist and that the
  `ArrayBufferView | ArrayBufferLike` disjunction no longer appears anywhere under
  `packages/bytes/src/` on the current head.

- The producer **deliberately and transparently scoped these disjunctions out** in
  a prior sweep, framing them as a separate contract-level decision and leaving the
  call to the maintainer. A reviewer cannot "miss" failing to narrow work the
  producer intentionally deferred with a stated rationale and surfaced for the
  maintainer's decision — the deferral was a defensible judgment call, not an
  oversight the panel should have flagged. The comment is a design-rationale inquiry
  that crystallized a scope expansion, the canonical new-direction shape.

- **No seat, skill, or standing instruction demands the wider scope.** No brief
  says "narrow every buffer-vs-view disjunction across every package in a byteArray
  PR"; the PR's own stated contract narrows the *byteArray passable form*, and these
  two disjunctions live at distinct contract edges the producer explicitly excluded.
  So no standing rule existed and failed to bind.

This is the same disposition, on the same thread, as the already-recorded sibling
dismissal `pr475-review-605988a6`; recording it keeps the opening question from
being re-litigated and keeps the discriminator's calibration auditable. See
`comment_url` to re-fetch the untrusted review text.
