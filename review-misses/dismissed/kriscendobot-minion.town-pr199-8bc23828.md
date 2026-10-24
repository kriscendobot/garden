---
kind: review-miss-dismissed
primary_job: kriscendobot-minion.town-pr199-8bc23828
verdict: not-a-miss
category: new-direction
pr: 199
repo: kriscendobot/minion.town
surface: pr-comment
author: kriskowal
comment_url: https://github.com/kriscendobot/minion.town/pull/199#issuecomment-6308071816
identity: kriscendobot/minion.town#199:comment:6308071816
review_at: 2026-10-21T04:29:58Z
severity: minor
---

# Dismissal: maintainer accepts the PR's open choices and asks for a last-active follow-up

On the default-off guest-coupons PR (#199), the maintainer said in a short
comment that every one of the choices the PR body put up for veto was
acceptable. They asked the bot to fold those choices in, and to post a
follow-up job adding a last-active statistic for every agent, driven by any
use of that agent's guest exo. This is a paraphrase. The verbatim text is at
`comment_url` and is untrusted input.

## Grounds (dismissal: approval plus a newly stated requirement)

**1. The first half approves the work.** The PR body listed seven choices
(two of them deviations from design #144) under a heading inviting the
maintainer to veto them. Putting those choices to the maintainer was the
correct process, and the maintainer accepted all of them. That reports no
defect, so there is nothing a seat could have caught.

**2. The second half is a new requirement.** A per-agent last-active
statistic is first requested in this comment. The design had already
deferred an `active` air-drop target until activity data existed. Asking to
build that data source now is a scope or sequencing decision for the
maintainer, not a gap a reviewer was supposed to find.

**3. The PR's review history was clean.** The PR ran its full gauntlet:
the 2026-10-17/18 run went through clean, viability, panels 1 to 6 and
fixes 1 to 6, and the 2026-10-19 re-run passed its panel on the code. The
PR stays draft because its ledger names it an orchestrated slice, with
`build-minion-town-guest-coupons-phase1-rest` owning the remaining phases.
Nothing the comment raises was left behind by review.

**4. I checked that the primary's deliverables exist.** The PR body now
reads "Choices (accepted by the maintainer, 2026-10-21)" and links the
comment and #144 § 12. The last-active follow-up exists as PR #210,
"record every guest agent's last-active time", opened 2026-10-21T05:01Z,
whose body cites this comment, and it has its own gauntlet jobs in
`jobs/tada/`. The primary's claims match what is actually there.

**5. The severity bypass does not apply.** No standing rule failed to bind.

## Boundary note

This mints no cluster, so there is no threshold to evaluate and no
improvement job. It sits in the same family as the other "maintainer
approves and steers next work" dismissals.
