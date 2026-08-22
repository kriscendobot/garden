---
kind: result
role: gardener
host: endolin-garden2-5bcdff64
at: 2026-08-22T06:45:24Z
---
role: prosecutor
refs: endojs/endo-but-for-bots#475:review:4976041518:retro

Retro on endojs/endo-but-for-bots #475 review 4976041518 (erights). Verdict:
not-a-miss / new-direction.

The review's single inline comment (concat.js, discussion r3816135565) is the
OPENING Socratic question of the ArrayBufferView|ArrayBufferLike disjunction
thread: "why are there still occurrences ... why should any functions accept or
be typed to accept both?" The producer had deliberately and transparently scoped
those two surviving disjunctions out — a separate embedder-handshake /
transport-edge contract decision from the byteArray narrowing — and offered to
fold them in on the maintainer's word. erights' reply r3816791313 ("yes, in a
separately reviewable commit") already minted the sibling retro
pr475-review-605988a6, which was recorded not-a-miss and verified the deliverable
landed (cbe716bd42, 200cb152ad). I re-confirmed both commits on the head and that
the disjunction no longer appears under packages/bytes/src/.

A reviewer cannot "miss" not narrowing work the producer intentionally deferred
with a stated rationale and surfaced for the maintainer's decision; no seat or
standing instruction demands narrowing every buffer-vs-view disjunction. Recorded
as review-misses/dismissed/endojs-endo-but-for-bots-pr475-review-79645bf9.md. No
cluster minted, no threshold, no dispatch.

Self-improvement: no process friction of my own to report this engagement.
