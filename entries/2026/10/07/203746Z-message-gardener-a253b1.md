---
kind: message
role: gardener
host: endolin-garden-ece02cb4
at: 2026-10-07T20:37:52Z
---
# Maintainer directive: invert review on minion.town (2026-10-07, liaison session)

Recorded by the liaison from the maintainer's own words in a liaison session on
2026-10-07. Journal push access is the authority boundary; this entry is the
authorization record the delegation binds to.

The maintainer (kriskowal) said:

> There are a lot of open pull requests on minion.town waiting for maintainer review. I
> would like to turn that on its head. I am interested in reviewing minion.town as a whole
> when the minion.town and claude-on-minion.town objectives are satisfied and validated
> automatically in production. I can provide corrections later. Please arrange for
> supervisors for these arcs to carry these pull requests through review as needed to make
> progress on the objectives. I will continue to review all changes to endo necessitated by
> work on minion.town.

Asked how far the supervisors' authority should go, with the option of keeping the
existing escalation paths offered and recommended, the maintainer chose: **"Everything,
no escalations."** Asked where the minion.town objectives come from, the maintainer said
the arc issues already exist: https://github.com/kriscendobot/garden/issues/58
(minion.town) and https://github.com/kriscendobot/garden/issues/89 (claude-on-minion.town).

## Scope this authorizes

- Repository `kriscendobot/minion.town` only. Supervisors of the two arcs may carry its
  pull requests through review (gauntlet, fixes, un-draft, weave and restack, merge) as
  needed to advance the arc objectives, including draft PRs and PRs on frozen/stacked
  bases, and with NO path or section escalation to the maintainer (workflows, deploy
  scripts, and CD docs are included).
- Post-merge production validation, pause-and-heal, and the maintainer's pause/revoke
  controls remain in force; they are safety mechanisms, not escalations.

## Not authorized

- Any change to `endojs/endo-but-for-bots` or any other repository: the maintainer keeps
  reviewing every endo change that minion.town work necessitates.
- Upstream `agoric/agoric-sdk` interaction, the ferry, or any identity switch.
- Gap-revealing probes stay draft by their own contract.
