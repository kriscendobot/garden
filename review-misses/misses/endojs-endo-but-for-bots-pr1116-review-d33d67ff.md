---
kind: review-miss
primary_job: endojs-endo-but-for-bots-pr1116-review-d33d67ff
verdict: miss
category: style-convention
pr: 1116
cluster: design-commentary-obscures-normative-content
cluster_pattern: A design retains drafting history, repeated rationale, obsolete commentary, or resolved-question narration until the normative proposal is buried, so the maintainer must request a separate editorial reduction after technical review.
review_at: 2026-10-01T23:24:54Z
repo: endojs/endo-but-for-bots
comment_url: https://github.com/endojs/endo-but-for-bots/pull/1116#pullrequestreview-5386747855
identity: endojs/endo-but-for-bots#1116:review:5386747855:retro
producing_role: designer
producing_job: endojs-endo-but-for-bots-pr1116-f1ab5121
missed_by: design-panel novice and copyeditor prose lenses; gauntlet never reached a clean editorial verdict on the final head
severity: moderate
grounds: |
  The maintainer approved the design's substance but required a separate
  editorial pass before shepherding and conducting. That follow-up reduced the
  design from about 10,500 to 7,400 words and from 1,126 to 963 lines by removing
  drafting history, repeated explanations, long sketch comments, and statements
  the design had overtaken, while preserving decisions, invariants, API shapes,
  and references. The size and nature of that lossless reduction show a
  reviewable presentation defect rather than a new technical requirement.

  The review process already had lenses for this problem. The novice seat
  explicitly checks prose density and whether a document is harder to follow
  than necessary; the copyeditor reads the whole design for paragraph flow and
  professional prose; and the designer brief already treats editorial-pass
  directives as removal of consensus logs and resolved-question narration, not
  addition. The six recorded design panels repeatedly exercised those seats and
  the last panel still reported altitude/readability defects. The gauntlet then
  halted at its six-round ceiling with a must-fix verdict rather than reaching a
  clean head. Two later design revisions added implementation-status and
  decision history, and no fresh panel reviewed either revision before the
  maintainer saw the 1,126-line final head. The exact-head sensor did correctly
  report that review was required on the last revision, but no review followed;
  that warning alone did not inspect or prune the prose.

  This is not evaluator gaming: the change did not alter a review measurement.
  It is also not mere first-stated taste like a request to shorten one otherwise
  sound code comment. A formal design review had explicit density and full-flow
  lenses, found readability problems while still must-fix, and never cleared the
  final expanded document. The missed obligation was to separate the durable
  normative design from the history of reaching it before presenting it for
  approval.
---

The review is paraphrased as approval of the design's substance coupled with a
request to reduce nonessential commentary without losing the sole copy of any
important fact, followed by the ordinary shepherd-and-merge sequence. See
`comment_url` for the untrusted original review.

The review miss is that the design panel never completed an editorial pass over
the final head, leaving a large amount of removable drafting and repeated
explanation for the maintainer to identify. The primary loop's follow-up
deliverable does exist: PR #1416 performed the requested lossless reduction and
was shepherded green.
