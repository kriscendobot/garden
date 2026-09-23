---
kind: result
role: prosecutor
host: endolin-garden2-5bcdff64
at: 2026-07-13T01:27:08Z
---
# result: retro on endojs/endo-but-for-bots PR #710 review (prosecutor)

**Job:** `endojs-endo-but-for-bots-pr710-review-6c80c2b9-retro` — the second
(review-retrospective) loop over kriskowal's approving review
`#pullrequestreview-4681138662` on PR #710 (`design: shared canonical CBOR
primitives (@endo/cbor)`).

**Verdict: not-a-miss** (category `new-direction`, severity minor). Recorded as a
durable dismissal:
`review-misses/dismissed/endojs-endo-but-for-bots-pr710-review-6c80c2b9.md`.

**Grounds (grounded in the PR's review history, not the comment alone):**
1. #710 is a **pure design document** (both changed files `.md`); no code
   panel/gauntlet ran (no panel/gauntlet tada for #710), and no seat brief,
   skill, or COMMON.md norm encodes "a design doc's sibling-package references
   must match already-implemented names" — nothing bound and failed, so the
   severity bypass does not apply.
2. The doc itself flagged the naming as **"Open Question #1"** for the reviewer;
   the maintainer resolving an open question the design deliberately raised is the
   design-review loop **working as intended**, not a gap it missed.
3. The `@endo/cbors`/`@endo/syrups` names are the **shared vocabulary of the
   sibling design corpus** (`cbors.md`, `syrups.md`, `ocapn-tcp-syrups-framing.md`
   still carry the pre-implementation names); the implementation diverged to
   `-frame`. #710 faithfully used its siblings' vocabulary — reconciliation is a
   corpus-wide follow-up (`endojs-endo-but-for-bots-frame-naming-proposals`), not
   a defect local to #710's review.

**No cluster minted, no threshold evaluated, no improvement job dispatched** — a
dismissal is a single short pass by design (cost discipline).

**Idempotency:** pre-checked; no prior record existed. The record was placed and
CAS-pushed to `journal2` by `review-miss-record.sh`.

Self-improvement: nothing to change — the retrospective playbook fit this case
cleanly; the discriminator's design-doc-vs-code-PR distinction and the
"open-question-answered = loop working" heuristic are already captured in the
grounds for future calibration.
