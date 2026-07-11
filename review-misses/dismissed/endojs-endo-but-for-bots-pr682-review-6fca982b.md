---
kind: review-miss-dismissed
primary_job: endojs-endo-but-for-bots-pr682-review-6fca982b
verdict: not-a-miss
category: new-direction
pr: 682
repo: endojs/endo-but-for-bots
comment_url: https://github.com/endojs/endo-but-for-bots/pull/682#pullrequestreview-4678306114
identity: endojs/endo-but-for-bots#682:review:4678306114:retro
producing_role: designer
severity: minor
grounds: >
  PR #682 ("design(endo-reminder): @endo/reminder message-scheduler plugin,
  supersedes endoclaw-timer") is a DESIGN-DOC PR authored by kriscendobot — it
  adds/edits designs/endo-reminder.md, no application code. kriskowal (the repo
  owner and architect) submitted review 4678306114 with state CHANGES_REQUESTED,
  an EMPTY review body (confirmed body_len=0 by a read-only gh re-check in this
  retro), and three inline comments on designs/endo-reminder.md, each a
  declarative maintainer ANSWER to one of the four Open Questions the design
  document itself posed: (Q1) how atomic durable-tracking writes should work,
  (Q2) the retention / @pins placement recipe, and (Q3) the delivery verb and
  one-shot-response semantics. This retro judges whether the garden REVIEW
  PROCESS should have anticipated this feedback and concludes it could not have,
  for a dispositive structural reason: the review indicts no work product — it
  is the architect resolving open design questions that the doc EXPLICITLY
  surfaced for exactly that resolution. Answering a design's Open Questions is
  the intended workflow of a design-doc PR, not a defect a review surface could
  catch: no panel seat, pre-push gate, or standing instruction encodes (or could
  encode) the maintainer's design preferences on write-then-move atomicity,
  @pins ownership, or send-vs-deliver semantics — those are first-stated
  requirements, the architect's calls to make. Same class as the #631 dismissal
  (a maintainer ANSWERING a surfaced question) and the #123 dismissal (a
  maintainer PROCESS directive): the review is direction, not a critique of the
  garden's output. The PR's own history confirms the garden handled it correctly
  — the primary job (pr682-review-6fca982b) treated the three answers as data,
  folded each into the doc as numbered design decisions (9/10/11), trimmed the
  Open Questions, added the requested SturdyRef survey with a gap analysis, and
  replied in-thread on all three comments, exactly as the review asked. A design
  PR's Open Questions being answered by the architect is unanticipatable by any
  review surface — new direction, not a garden review-process miss. Recorded as a
  durable dismissal so the same review is never re-litigated. No cluster minted;
  no improvement dispatched.
---

# Dismissal: endo-but-for-bots #682 review 4678306114 (retro)

PR #682 is a DESIGN-DOC PR (`design(endo-reminder)`, edits designs/endo-reminder.md
only). kriskowal (the repo owner and architect) submitted a CHANGES_REQUESTED
review with an empty body and three inline comments, each answering one of the
four Open Questions the design document itself posed (atomic-write approach,
@pins/retention recipe, delivery verb and one-shot-response semantics).

Not a garden review-process miss. The review indicts no work product — it is the
architect RESOLVING open questions the doc explicitly surfaced for resolution,
which is the intended workflow of a design PR. No panel seat, gate, or standing
instruction encodes (or could encode) the maintainer's design preferences on
write-then-move atomicity, service ownership, or send-vs-deliver semantics; these
are first-stated requirements, the architect's calls. Same class as the #631
(maintainer answering a surfaced question) and #123 (maintainer process
directive) dismissals. The PR history confirms the garden acted correctly: the
primary job folded the three answers into the doc as numbered design decisions,
trimmed the Open Questions, added the requested SturdyRef survey + gap analysis,
and replied in-thread on all three comments. A design PR's Open Questions being
answered by the architect is unanticipatable by any review surface — new
direction. See comment_url for the verbatim review.
