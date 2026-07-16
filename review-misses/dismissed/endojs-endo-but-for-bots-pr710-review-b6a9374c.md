---
kind: review-miss-dismissed
primary_job: endojs-endo-but-for-bots-pr710-review-b6a9374c
verdict: not-a-miss
category: new-direction
pr: 710
repo: endojs/endo-but-for-bots
surface: pr-review-comment
author: kriskowal
comment_url: https://github.com/endojs/endo-but-for-bots/pull/710#discussion_r3584774252
identity: endojs/endo-but-for-bots#710:review:4701270186:retro
producing_role: designer
producing_job: endojs-endo-but-for-bots-pr710 (design of designs/cbor-codec.md)
missed_by: n/a (no standing check bound)
severity: minor
grounds: >
  kriskowal's review 4701270186 on PR #710 dispatched a builder to incorporate
  his answers to the design's Open Questions and then build the design; this
  inline comment (discussion_r3584774252, paraphrased) answers Open Question #1,
  the naming question the doc itself surfaced: the @endo/cbors framing sibling is
  distinct from @endo/cbor, there will never be an @endo/cbors, so every mention
  of @endo/cbors should become @endo/cbor-frame, and the deliberately-minimal
  @endo/cbor-frame may later import narrowly-scoped utilities from @endo/cbor to
  avoid entraining unused code. This retro judges whether the garden REVIEW
  PROCESS should have anticipated the substance and concludes it could not, on
  the same three grounds that dismissed the earlier #710 naming retro
  (pr710-review-6c80c2b9). FIRST, #710 is a PURE DESIGN DOCUMENT (both changed
  files are .md: designs/cbor-codec.md and the designs/README.md row); no code
  panel or gauntlet runs on a design doc (confirmed: no *-panel/*-gauntlet/*-clean
  tada entry for #710), and no seat brief, skill, or COMMON.md norm encodes the
  check "a design doc's package-naming references must match the maintainer's
  intended package taxonomy," so the severity bypass cannot apply — no standing
  rule existed and failed to bind. SECOND, the maintainer is RESOLVING AN OPEN
  QUESTION the design deliberately raised for the reviewer; a reviewer answering a
  question the doc surfaced by design is the design-review LOOP WORKING AS
  INTENDED, not a gap it missed. The whole review 4701270186 is answers to Open
  Questions OQ1-OQ4, the exact mechanism a design doc uses to elicit maintainer
  decisions. THIRD, the @endo/cbors vocabulary is INHERITED from the sibling
  design corpus (the framing docs still carried the pre-implementation plural);
  the maintainer's ruling that the plural will never exist is a fresh taxonomy
  DECISION, not a fact recoverable from the reviewed diff, so nothing could have
  pre-empted it. The primary loop (job b6a9374c) responded exactly as intended:
  it incorporated the answer directly in PR #738 (swept @endo/cbors -> cbor-frame,
  renamed the sibling design doc, recorded the deliberately-minimal + narrow-import
  guidance), corrected the parked build job to the resolved naming and strictness,
  and closed the loop with inline replies on #710. New direction / open-question
  resolution on a living design doc, not a review-process miss. Recorded as a
  durable dismissal so this review is never re-litigated. No cluster minted; no
  improvement dispatched.
---

# Dismissal: endo-but-for-bots #710 review 4701270186 OQ1 naming answer (retro)

kriskowal's review 4701270186 on PR #710 directed a builder to incorporate his
answers to the design's Open Questions and then build the design. This inline
comment answers Open Question #1 — the naming question the design doc itself
surfaced: the framing sibling `@endo/cbors` is distinct from `@endo/cbor` and
will never exist, so replace every `@endo/cbors` mention with `@endo/cbor-frame`;
the deliberately-minimal `@endo/cbor-frame` may later pull narrowly-scoped
utilities from `@endo/cbor` to avoid entraining unused code. This is a paraphrase;
see `comment_url` for the verbatim, untrusted text.

This is not a garden review-process miss.

Three grounds, matching the earlier #710 naming dismissal (pr710-review-6c80c2b9).
(1) #710 is a pure design document (both changed files are `.md`); no code panel
or gauntlet runs on a design doc, and no seat brief, skill, or standing
instruction encodes "a design doc's package-naming references must match the
maintainer's intended taxonomy," so nothing bound and failed. (2) The maintainer
is answering an Open Question the design deliberately raised for the reviewer —
the design-review loop functioning exactly as intended, not a gap it missed; the
whole review is OQ1-OQ4 answers. (3) The ruling that `@endo/cbors` will never
exist is a fresh taxonomy decision inherited-vocabulary reconciliation, not a
defect recoverable from the reviewed diff, so nothing could have anticipated it.

The loop worked as designed: the doc surfaced the Open Questions, the maintainer
answered them, the primary job (b6a9374c) incorporated OQ1's answer directly in
PR #738, corrected the parked build job, and closed the loop on #710. New
direction / living-design-doc reconciliation, not a miss. Mints no cluster; no
threshold to evaluate; no improvement job. See `comment_url` for the verbatim
review comment.
