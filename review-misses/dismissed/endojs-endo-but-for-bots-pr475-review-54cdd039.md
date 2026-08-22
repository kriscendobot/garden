---
kind: review-miss-dismissed
primary_job: endojs-endo-but-for-bots-pr475-review-54cdd039
verdict: not-a-miss
category: new-direction
review_at: 2026-08-17T22:03:43Z
repo: endojs/endo-but-for-bots
comment_url: https://github.com/endojs/endo-but-for-bots/pull/475#discussion_r3799144725
identity: endojs/endo-but-for-bots#475:review:4954964912:retro
producing_role: none (inter-maintainer naming-taste thread)
missed_by: none
severity: minor
---

Single inline reply in the `thawn`→`thawed` naming thread on
`packages/pass-style/src/from-bytes.js` (review body empty, state COMMENTED). The
maintainer flags a second maintainer that the earlier spelling correction is
correct and overrides the originally requested name — a one-line endorsement, not
a code ask. The primary review job posted a threaded reply closing the loop, and
that reply genuinely exists in the world (kriscendobot comment `3799163214`,
2026-08-17T22:07:30Z), so there is no false-resolution discrepancy.

Grounds: not an indictment of the garden's review process. The full thread is a
naming-taste exchange: (1) one maintainer originally requested the function be
named `thawnBytes` (2026-06-23), which the garden delivered; (2) a second
maintainer later observed that "thawn" is non-standard English and the past
participle should be "thawed" (2026-08-12, explicitly quoting an LLM), which the
garden also delivered by renaming to `thawedBytes`; (3) this review comment is
that second maintainer merely affirming the correction to the first maintainer.
Three independent reasons converge on a dismissal. **(a) First-stated taste the
panel could not anticipate.** The preference "thawed over thawn" is an obscure
English-morphology judgment first introduced in the thread itself — the original
maintainer had specified the very spelling now being corrected, so no reviewer
could have foreseen which way the taste would land. This is the canonical
new-direction shape (taste, first-stated in the comment), not a violated
convention. **(b) No seat, skill, or standing instruction encodes it.** No garden
seat brief or skill demands "thawed" over "thawn"; a copyeditor/pedant lens covers
prose grammar, not a maintainer-specified identifier that the maintainer himself
chose. There is no written rule that failed to bind. **(c) Nothing to build or
sense.** The substance was already resolved days earlier; this comment is a
declarative confirmation between humans with no residual code obligation. A
recurring-pattern check would fire on nothing mechanizable — every future instance
is a distinct one-off taste call. Mints no cluster.
