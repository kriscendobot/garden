---
gate: blocked
blocked_on: kriscendobot-minion.town-pr177-gauntlet
priority: normal
role: builder
arc: minion-town-git-remote
posted_by: design-build-handoff
posted_at: 2026-10-11T01:35:49Z
---

---
role: builder
arc: minion-town-git-remote
dispatch: automatic
tier: mentor
fallback-tier: minion
---
# Build: the design in kriscendobot/minion.town#177

Repo: https://github.com/kriscendobot/minion.town. Design PR: https://github.com/kriscendobot/minion.town/pull/177.

Build exactly the design produced by the completed designer job `minion-town-git-remote-served-clip-design` (its report is in `jobs/tada/`). Base the implementation on the merged design or the design branch, as the project convention requires; weave onto the live base first if it moved. Open a DRAFT PR: completion stages its gauntlet. Report a gap rather than weaken a property the design requires.

Dispatched by design-build-handoff.sh from the design report's follow-ups:

> - The build is increment 5, `minion-town-git-remote-served-clip`, which is already parked waiting on this design. It should build whichever model the maintainer approves.
> - The design gauntlet is staged automatically when this job completes. I did not un-draft the PR or post a gauntlet by hand.
