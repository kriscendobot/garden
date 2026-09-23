---
kind: review-miss-dismissed
primary_job: kriscendobot-minion.town-pr37-review-41d400bb
verdict: not-a-miss
category: new-direction
pr: 37
review_at: 2026-08-21T00:36:08Z
repo: kriscendobot/minion.town
comment_url: https://github.com/kriscendobot/minion.town/pull/37#discussion_r3826407958
identity: kriscendobot/minion.town#37:review:4988726963:retro
surface: pr-review-comment
author: kriskowal
producing_role: designer
producing_job: minion-town-ocap-mailboxes-design
grounds: |
  The maintainer comment (paraphrased; untrusted, re-fetch at comment_url for
  verbatim) reframes the design's primary purpose as enabling real email for the
  wider population of Endo bots, apps, and people, while preserving confinement
  by replacing materialized addresses with opaque capabilities. This is new
  product direction, not a defect the review process should have inferred.

  The original mandate quoted in the design was narrower: mail accounts for
  minion.town bots, with address restrictions, metering, breaking, logging, and
  opaque recipient handles. At the reviewed commit, the design faithfully made
  that scope explicit. Section 1 described a literal-email adapter for confined
  bots, its anti-spray purpose, the external email bridge, and opaque petnames;
  sections 8 and 9 already required address obscuring before messages materialize
  in a guest mailbox. Expanding the beneficiaries from minion.town bots to apps
  and people using Endo, and elevating genuine-email enablement over anti-spray as
  the lead purpose, first appears in this comment.

  The actual review history confirms that the gauntlet ran rather than being
  bypassed. Five design-panel rounds were posted between 2026-08-18 and
  2026-08-19, each followed by a fix round. Their critic, skeptic, decomplector,
  ergonomist, copyeditor, pedant, and novice seats repeatedly tested the stated
  bot-focused purpose, email-address opacity, confinement, and threat model. The
  final panel even referred expressly to the document's stated spray/spoof
  purpose. No standing rule or source requirement supplied the broader
  bots/apps/people objective that the maintainer later chose. No cluster is
  minted.
---

The review supplies a broader audience and a new lead framing for an otherwise
already-real-email, address-obscuring design. Those choices were not derivable
from the original bot-account mandate or the five-round panel record.
