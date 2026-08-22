---
kind: review-miss-dismissed
primary_job: endojs-endo-but-for-bots-pr475-review-538450f1
verdict: not-a-miss
category: new-direction
review_at: 2026-08-19T19:54:28Z
repo: endojs/endo-but-for-bots
comment_url: https://github.com/endojs/endo-but-for-bots/pull/475#pullrequestreview-4976183942
identity: endojs/endo-but-for-bots#475:review:4976183942
---

Review-body (COMMENTED, no inline comments) from a senior maintainer on the
narrow-bytearray PR. It asks a set of Socratic design-rationale questions about the
surviving getter-based `isTypedArray` helper (`apply(getTypedArrayToStringTag, obj, [])`):
what its purpose is, why it still uses the `%TypedArray%.prototype[Symbol.toStringTag]`
getter rather than `ArrayBuffer.isView`, whether the remaining `getTypedArrayToStringTag`
occurrences should all become `isView`, and why the earlier "commit to the isView
non-fidelity" cleanup passes did not touch these — explicitly inviting agreement ("Do you
agree it should have?") and understanding ("Do you understand why it did not?").

Grounds: this is a design-rationale inquiry, not an indictment of the review process, and
the answer confirmed the existing code was already correct. Grounded in the world (the PR
review, the designer deliverable, and the pushed diff — not the primary's report): the
directive was routed to a designer (design-endo475-istypedarray-isview, in
journal/jobs/tada/) who investigated empirically and decided to KEEP the getter at all
three surviving sites and swap none — `ArrayBuffer.isView` would be strictly *less*
precise (it is true for DataView, which the getter correctly excludes), so isView would
misroute a DataView through harden's `freezeTypedArray` special-case and mislabel it as a
"mutable typed array" in passStyleOf. The earlier isView-commit passes correctly left
these alone; they were not an oversight, because these sites answer a different question
(exotic-slot brand precision) than byteArray.js's isView commitment (emulated-wrapper vs
native on an already-Uint8Array-narrowed candidate where DataView is already excluded).
So there was no bug, spec violation, missed edge case, or violated convention for the
panel to catch — the code the reviewer questioned is right as written. The reviewer's
"should these all become isView?" premise was answered "no." The only artifacts the
designer added were in-code rationale COMMENTS explaining the non-obvious-but-correct
getter choice and a DataView divergence test — clarity/documentation of a subtle correct
decision, first requested in this comment itself, not the closing of a demonstrable
defect. "Explain why a correct-but-subtle discriminator was chosen" is taste/clarification
no seat brief or standing rule enforces; nobody could have anticipated this Socratic probe
in the gauntlet. (The designer incidentally also fixed two pre-existing stale duplicate-path
comment references, but the reviewer did not flag those and they were not this comment's
subject.) New direction / clarification, not a review miss.
