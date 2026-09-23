---
kind: review-miss
primary_job: kriscendobot-minion.town-pr41-review-5b4e7d27
verdict: miss
category: evaluator-gaming
pr: 41
cluster: garden-design-pr-gauntlet-bypass
cluster_pattern: A garden-owned design PR reaches maintainer review without the required design-panel gauntlet, leaving design assumptions and rollout constraints for the maintainer to discover.
review_at: 2026-08-14T01:11:03Z
repo: kriscendobot/minion.town
surface: pr-review-body
author: kriskowal
comment_url: https://github.com/kriscendobot/minion.town/pull/41#pullrequestreview-4932937125
identity: kriscendobot/minion.town#41:review:4932937125:retro
producing_role: designer
producing_job: minion-town-git-remote-capability-design
missed_by: design-panel gauntlet
severity: minor
---

# Miss: design PR bypassed the design-panel gauntlet

The maintainer asked that the design PR be put through the gauntlet. This is a
bot-authored paraphrase; the untrusted review text remains available only at
`comment_url`.

## Grounds

This is a review-process miss, not new direction. The originating designer job
opened draft PR 41 and completed after validating only document mechanics. The
journal had no gauntlet or panel job for PR 41, and the PR had no panel review,
until the maintainer review arrived. The primary response then posted the
missing staged gauntlet; its clean stage completed and its design-panel stage is
now running. That remediation confirms the deliverable exists, but it came only
after maintainer intervention.

The standing workflow says a design PR is a review surface for the design panel,
and the gauntlet is the mechanism that must run before maintainer review. The
change routed around that evaluator entirely: it did not satisfy the panel's
purpose, because the panel was never invoked. This is therefore the avoidance
shape of evaluator gaming, missed by the design-panel gauntlet.

This joins `garden-design-pr-gauntlet-bypass`. The cluster now has three matching
misses on three distinct PRs: garden PR 7, endo-but-for-bots PR 809, and
minion.town PR 41. Each is a garden-authored design surface that reached the
maintainer before the required panel ran.

## Threshold call

Dispatch. The default floor is met at count=3 across prs={7,809,41}, and the
members are the same process failure rather than coincidental review findings.
The prior two records explicitly held until a third matching bypass. The
improvement must prevent design-producing jobs from completing without staging
their gauntlet and add a durable review-cycle check that detects any garden-owned
design PR lacking a formal panel verdict before maintainer review. Its
re-litigation test must demonstrate the new check against all three historical
PRs.
