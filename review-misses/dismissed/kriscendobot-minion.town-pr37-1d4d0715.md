---
kind: review-miss-dismissed
primary_job: kriscendobot-minion.town-pr37-1d4d0715
verdict: not-a-miss
category: new-direction
review_at: 2026-08-18T04:06:25Z
repo: kriscendobot/minion.town
comment_url: https://github.com/kriscendobot/minion.town/pull/37#issuecomment-5323465130
identity: kriscendobot/minion.town#37:comment:5323465130
---

Maintainer directive on the ocap-mailboxes design PR (#37, a DRAFT design doc):
the maintainer accepts the formula-identifier local-part for the synthetic email
address, conditioned on a new requirement — that email addresses in general be
obscured by replacement with opaque references when they materialize in the
guest's pet mailbox, tying the mailbox to the broader Endo daemon
distributed-confinement effort (guests see only their own petnames and passable
objects, never identifiers or locators).

Grounds: this is a design decision / new direction, not an indictment of the
review process. PR #37 is a design document with an explicit `## 10 Open
questions` section; the comment resolves an open design axis (accept the
formula-id local-part) and simultaneously introduces a fresh confinement
requirement first stated in the comment itself. Neither half is a bug, spec
violation, style/convention breach, or missed edge case that a seat brief, skill,
or standing instruction demonstrably knows — it is the maintainer's taste and
architectural direction, exactly what a design PR review surface exists to elicit.
No panel juror could have anticipated that the maintainer would require
address-obscuring-on-materialization; that requirement flows from the maintainer's
private Endo distributed-confinement roadmap, not a written garden rule that
failed to bind.

No evaluator-gaming/avoidance shape: the design PR did NOT route around the
evaluator. A full design gauntlet ran on it — gauntlet-clean, five panel rounds,
and five fix rounds are all present in journal/jobs/tada/
(kriscendobot-minion.town-pr37-gauntlet-{clean,panel-1..5,fix-1..5}), plus a
conduct job — so the evaluator was exercised, not skipped; the DRAFT flag is the
honest "design-stage, maintainer un-drafts after review" marker per the designer
norm, not a dodge.

World-grounded, not trusting the primary report: the primary
(kriscendobot-minion.town-pr37-1d4d0715) did real work and its deliverables
genuinely exist — the obscuring requirement was folded into
`designs/ocap-mailboxes.md` (commit `c52a31bfa`, "design(mail): obscure email
addresses on materialization in the guest mailbox", on branch
`design/ocap-mailboxes`; the primary reported the pre-rebase sha `d548588`, which
the subsequent gauntlet rebase advanced to `c52a31bfa` — same content, new §8
subsection + §9 acceptance criterion), and the mapping reply exists (issue comment
5323498844 by kriscendobot). No discrepancy to report. Mints no cluster.
