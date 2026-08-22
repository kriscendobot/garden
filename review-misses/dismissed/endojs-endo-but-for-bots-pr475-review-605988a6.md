---
kind: review-miss-dismissed
primary_job: endojs-endo-but-for-bots-pr475-review-605988a6
verdict: not-a-miss
category: new-direction
review_at: 2026-08-19T21:18:01Z
repo: endojs/endo-but-for-bots
comment_url: https://github.com/endojs/endo-but-for-bots/pull/475#pullrequestreview-4976837493
identity: endojs/endo-but-for-bots#475:review:4976837493:retro
producing_role: none (maintainer accepting a bot-offered scope expansion)
missed_by: none
severity: minor
---

Single inline reply (review body empty, state COMMENTED) by erights on
`packages/bytes/src/concat.js`, threaded under a prior bot comment
(`in_reply_to` 3816135565; the reply itself is comment 3816791313). Paraphrase:
the bot had written that narrowing the two remaining `ArrayBufferLike | Uint8Array`
disjunctions would ripple through the embedder-handshake and transport-edge
contracts, called that a separate decision from the byteArray narrowing, and
offered to fold them into this PR too if the maintainer wanted. The maintainer
replied to accept the offer and asked for it in a separately reviewable commit.

Deliverable-exists check (this retro grounds in the world, not the primary's
report): the primary did NOT close as a no-op. Its two folded-in narrowings are
present on the PR head after the intervening retcon/rebase — `cbe716bd4`
(refactor(ocapn): narrow hub handshake-identity bytes to Uint8Array) and
`200cb152a` (refactor(relay-server): narrow decodeFrame to Uint8Array). So there
is no false-resolution discrepancy; the accepted scope expansion actually landed.

Grounds: not an indictment of the garden's review process. This is the canonical
new-direction shape (scope expansion first-crystallized in the comment thread),
not a violated convention, on three converging reasons. **(a) The bot itself
deliberately and transparently scoped these two disjunctions OUT** in a prior
sweep, framing them as a separate contract-level decision and explicitly leaving
the call to the maintainer ("just say the word"). A reviewer cannot "miss"
failing to narrow work the producer intentionally deferred with a stated
rationale; the deferral was a defensible judgment call, not an oversight the panel
should have flagged. **(b) No seat, skill, or standing instruction demands the
wider scope.** No brief says "always narrow every buffer-vs-view disjunction in a
byteArray sweep regardless of the contract ripple"; the ripple through the
embedder handshake and transport edge is exactly the kind of blast-radius the
producer was right to surface for a maintainer decision rather than assume. There
is no written rule that failed to bind. **(c) Nothing mechanizable to sense.**
The trigger here is a maintainer accepting an offer — a taste/scope call decided
in the thread — with no diff signal a probe could fire on ahead of time. A
recurring-pattern check would fire on nothing. Mints no cluster.

Distinguish from evaluator-gaming: the bot did not route around a gate or move a
measurement. It surfaced the deferred scope openly and offered to expand; the
measurement (the byteArray-narrowing rubric) and its target stood still, and the
producer's transparency is the opposite of gaming.
