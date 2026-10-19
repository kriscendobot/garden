---
kind: review-miss-dismissed
primary_job: kriscendobot-minion.town-pr191-9f800189
verdict: not-a-miss
category: new-direction
pr: 191
repo: kriscendobot/minion.town
surface: pr-comment
author: kriskowal
identity: kriscendobot/minion.town#191:comment:6201208707:retro
comment_url: https://github.com/kriscendobot/minion.town/pull/191#issuecomment-6201208707
review_at: 2026-10-15T20:05:59Z
producing_role: designer
severity: minor
grounds: |
  PR #191 is a draft design PR. The head the comment responded to (2f0fe4f9bb,
  19:58Z) already framed OCapN authority as possession of a guest formula
  identifier, and its section 6 "Open questions" explicitly asked which secret
  the root principal's formula identifier designates and noted that the
  accepted design still identifies the root by a Cognito sub. The comment
  answers those open questions: it restates the maintainer's account model
  (accounts keyed by formula identifier with associated OAuth identities), and
  it states first-time choices of direction (start canary validation with
  OCapN, stand up several guests including a Claude-operated one, and consider
  a dedicated mailbox for unattended Claude reauthentication). Sequencing and
  the mailbox idea appear first in this comment, so no panel seat, skill, or
  standing instruction could have anticipated them. The draft did not
  contradict the earlier pivot; it surfaced the gap between that pivot and the
  code as a question, which is the intended behavior for a design carrying
  open questions. This is not evaluator-gaming: nothing was changed to alter
  what a reviewer measures.

  Review history: the only gauntlet job (kriscendobot-minion.town-pr191-gauntlet,
  tada 2026-10-15) halted before any panel because the PR targets the floating
  base `main` rather than a pinned snapshot, so no panel ran. That is a
  separate process question about design PRs on minion.town. This comment
  does not identify a defect a panel would have caught, so the gauntlet halt
  does not make this comment a miss.

  World check of the primary: PR commit 90db939ce7 (2026-10-15T21:40Z) on
  design/root-canary-reader-identity revises the design (formula-id-keyed
  accounts, OCapN canary first, reauthentication section, new open questions),
  and the primary replied on the PR. The directive's deliverable exists, so
  there is no false-peer no-op discrepancy.
---

The maintainer answered the draft design's open questions and set direction:
accounts keyed by formula identifier, OCapN canary validation first, multiple
guests including a Claude-operated one, and a possible dedicated mailbox for
reauthentication. The draft had asked these questions; it had not got them
wrong. Dismissed as new direction. No cluster is minted. Re-fetch the verbatim
comment at comment_url.
