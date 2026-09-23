---
kind: review-miss-dismissed
primary_job: endojs-endo-but-for-bots-pr710-review-6c80c2b9
verdict: not-a-miss
category: new-direction
pr: 710
repo: endojs/endo-but-for-bots
comment_url: https://github.com/endojs/endo-but-for-bots/pull/710#pullrequestreview-4681138662
identity: endojs/endo-but-for-bots#710:review:4681138662:retro
producing_role: designer
producing_job: endojs-endo-but-for-bots-pr710 (design of designs/cbor-codec.md)
missed_by: n/a (no standing check bound)
severity: minor
grounds: >
  kriskowal's review on PR #710 (paraphrased) APPROVED the design and left one
  inline nit on designs/cbor-codec.md: the framing siblings the doc named
  @endo/cbors / @endo/syrups actually landed as @endo/cbor-frame /
  @endo/syrup-frame; post a follow-up to amend the design proposals to match the
  implementation. This retro judges whether the garden REVIEW PROCESS should have
  anticipated the substance and concludes it could not. Three facts decide it.
  FIRST, PR #710 is a PURE DESIGN DOCUMENT (2 changed files, both .md:
  designs/cbor-codec.md and the designs/README.md summary row); no code panel or
  gauntlet ran on it (confirmed: no panel/gauntlet tada entry for #710), and no
  seat brief, skill, or COMMON.md norm encodes the specific check "a design doc's
  references to sibling package names must match already-implemented package
  names," so the severity bypass cannot apply (no standing rule existed and failed
  to bind). SECOND, the doc ITSELF flagged the naming for the reviewer as
  "Open Question #1" (@endo/cbor naming next to the framing sibling @endo/cbors);
  the reviewer resolving an open question the design deliberately surfaced is the
  design-review LOOP WORKING AS INTENDED, not a gap it missed — the doc did its
  job by asking, the maintainer did his by answering with the landed -frame names.
  THIRD, the @endo/cbors / @endo/syrups vocabulary is INHERITED from the sibling
  design corpus: the framing proposal docs cbors.md and syrups.md /
  ocapn-tcp-syrups-framing.md still carry the pre-implementation names (the bot's
  own inline reply, comment 3567507059, notes this), while the implementation
  diverged to the -frame suffix. PR #710 faithfully used its siblings' design
  vocabulary; the divergence is a CORPUS-WIDE design/implementation reconciliation
  that predates #710 and is now tracked as a separate follow-up job
  (endojs-endo-but-for-bots-frame-naming-proposals), not a defect local to #710's
  review. The loop worked: the doc surfaced the naming question, the maintainer
  resolved it, the gardener absorbed the nit in ee3bde9c57 and queued the
  corpus-wide reconciliation, and the conductor merged to llm. New direction /
  living-doc reconciliation, not a review-process miss. Recorded as a durable
  dismissal so the same review is never re-litigated. No cluster minted; no
  improvement dispatched.
---

# Dismissal: endo-but-for-bots #710 review 4681138662 (retro)

kriskowal's approving review of PR #710 left one nit: the design doc
designs/cbor-codec.md named the framing sibling packages @endo/cbors /
@endo/syrups, but they landed as @endo/cbor-frame / @endo/syrup-frame — amend the
proposals to reflect the implementation. This is not a garden review-process
miss.

Three grounds. (1) #710 is a pure design document (both changed files are `.md`);
no code panel or gauntlet runs on a design doc, and no seat brief, skill, or
standing instruction encodes the check "a design doc's sibling-package references
must match already-implemented names," so nothing bound and failed. (2) The doc
itself flagged the naming as "Open Question #1" for the reviewer; the maintainer
resolving an open question the design deliberately raised is the design-review
loop functioning, not a gap it missed. (3) The @endo/cbors / @endo/syrups names
are the shared vocabulary of the sibling design corpus — the framing proposal
docs (cbors.md, syrups.md, ocapn-tcp-syrups-framing.md) still carry those
pre-implementation names, while the implementation diverged to `-frame`. #710
faithfully used its siblings' vocabulary; the reconciliation is a corpus-wide
follow-up (endojs-endo-but-for-bots-frame-naming-proposals), not a defect the
review of #710 should have caught in isolation.

The loop worked as designed: the doc surfaced the naming question, the maintainer
answered it, the gardener absorbed the nit (ee3bde9c57) and queued the
corpus-wide amendment, and the conductor merged #710 to `llm`. New direction /
living-design-doc reconciliation, not a miss. See comment_url for the verbatim
review and inline comment.
