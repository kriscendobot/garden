---
kind: review-miss-dismissed
primary_job: endojs-endo-but-for-bots-pr165-d00cbc0d
verdict: not-a-miss
category: new-direction
pr: 165
repo: endojs/endo-but-for-bots
comment_url: https://github.com/endojs/endo-but-for-bots/pull/165#issuecomment-4951893435
identity: endojs/endo-but-for-bots#165:comment:4951893435:retro
producing_role: designer
producing_job: endojs-endo-but-for-bots-pr165 (design of cli-scheduled-send.md)
severity: minor
grounds: >
  kriskowal's comment on PR #165 (paraphrased): close this PR, and post a review
  on #682 assessing how well it conforms to this design, where they differ, and
  how it can be improved. This retro judges whether the garden REVIEW PROCESS
  should have anticipated the comment, and concludes it could not have. PR #165
  was a designer's DESIGN document (`designs/cli-scheduled-send.md`), a PR #145
  design revision proposing a reactor + schedule + `endo scheduled-send`
  composition. The comment is a pure maintainer DISPOSITION decision: it elects
  to proceed with the sibling redraft #682 (`endo-reminder.md`, a plugin rather
  than a daemon formula) instead of #165, closes #165 as superseded, and assigns
  a cross-review of #682 against #165's design. Nothing in this is a bug, a spec
  or style violation, a missed edge case, or a violated convention that a seat
  brief, skill, or standing instruction demonstrably knew and failed to bind on.
  The PR's own body already flagged, in its "What is intentionally out of scope"
  and five "Open Questions" sections, that the fate of the design and the choice
  among competing formulations were the maintainer's to make — precisely the
  decision the comment exercises. Choosing formula-vs-plugin between two designs
  the maintainer commissioned (#145 line vs #609 line) is taste and product
  direction, unanticipatable by any review surface by definition; a design panel
  cannot "catch" which of two sibling redrafts the maintainer will keep. The
  primary job already discharged the directive correctly (posted the #682 review
  and closed #165, per journal/jobs/tada/endojs-endo-but-for-bots-pr165-d00cbc0d.md).
  This is new direction, not a garden review-process miss. Recorded as a durable
  dismissal so the same comment is never re-litigated. No cluster minted; no
  improvement dispatched.
---

# Dismissal: endo-but-for-bots #165 comment 4951893435 (retro)

PR #165 was a designer's design document (a PR #145 revision proposing a
reactor + schedule scheduled-send composition). The maintainer comment asked to
close #165 and post a cross-review on the sibling redraft #682. Not a garden
review-process miss: the comment is a maintainer disposition decision electing
to proceed with #682 (plugin) over #165 (daemon formula) and to close the
superseded design — taste and product direction between two competing designs
the maintainer himself commissioned. The PR body already recorded that the fate
of the design and the choice among formulations were the maintainer's to decide.
No seat, skill, or standing instruction demonstrably knew a convention and
failed to bind; a design panel cannot anticipate which sibling redraft a
maintainer will keep. New direction, not a miss. See comment_url for the
verbatim comment.
