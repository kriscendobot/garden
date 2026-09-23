---
kind: review-miss-dismissed
primary_job: endojs-endo-but-for-bots-pr133-review-48633764
verdict: not-a-miss
category: new-direction
pr: 133
repo: endojs/endo-but-for-bots
comment_url: https://github.com/endojs/endo-but-for-bots/pull/133#discussion_r3566737107
identity: endojs/endo-but-for-bots#133:review:4680431129:retro
producing_role: builder
severity: minor
grounds: >
  kriskowal (the repo owner and maintainer) left a one-line inline review
  comment on packages/chat/test/component/chat-bar.test.js line 76, on the
  newly-added #pending-commands-region div inside the #chat-bar template,
  paraphrased as: should this region be at the bottom instead? PR #133
  ("feat(chat): pending-commands region with non-blocking command bar")
  implements designs/chat-pending-commands.md, which specifies the pending
  region be "anchored to the bottom of the transcript, above the command bar
  and below the message list." A read of the design doc on the PR head branch
  confirms the implementation's placement — inside #chat-bar, above the command
  row — MATCHES the approved design exactly; the region is not misplaced
  relative to any written spec. The comment is therefore not an indictment of a
  defect the review should have caught but a maintainer reconsidering the
  design's OWN approved placement decision at review time — a subjective UI
  layout preference (region above vs. below the command bar). This is textbook
  new-direction/taste: (1) no code panel seat judges subjective UI element
  positioning — spec-keeper/pedant check conformance to the spec, and here the
  code CONFORMS to the spec, so those seats would (correctly) have found nothing
  to flag; (2) the preference is first stated in the comment itself and even
  runs against the design doc it would revise, so nothing a panel, gate, or
  standing instruction encodes could have anticipated it. Same class as prior
  aesthetic/direction dismissals: a maintainer expressing a placement/taste
  preference on conforming work is unanticipatable by the review process by
  construction. The feedback itself is being addressed on the primary job
  (pr133-review-48633764); this retro concludes only that the review process
  had nothing to catch. Recorded as a durable dismissal so the same comment is
  never re-litigated. No cluster minted; no improvement dispatched.
---

Maintainer asked, on the newly-added pending-commands-region div in the chat-bar
test template, whether it should be positioned at the bottom instead. The
implementation's placement (above the command row, below the message list)
matches designs/chat-pending-commands.md verbatim, so this is the maintainer
reconsidering the approved design's own UI-placement decision — a subjective
layout preference, not a spec/convention/correctness miss. Dismissed as
new-direction; nothing the panel could have caught. See comment_url to re-fetch.
