---
gate: awaiting-maintainer
priority: normal
posted_by: proxy
posted_at: 2026-10-27T07:43:05Z
maintainer_question: 'The workbench design moved to minion.town (#238), but phases W1-W5 change Endo packages. Should each be proposed in Endo as a design that does not name minion.town before it is built, or is the minion.town design enough for the Endo pull requests that build them? (Open question 7; the design''s other open questions and #1543 also still gate this build.)'
asked_at: https://github.com/kriscendobot/minion.town/pull/238
---

---
role: builder
tier: mentor
arc: minion-town-claude-api
---
<!-- garden-promoted-from-plan: gate=blocked priority=normal at=2026-10-27T07:36:55Z cleared=none -->

---
role: builder
arc: minion-town-claude-api
dispatch: automatic
tier: mentor
fallback-tier: minion
---
# Build: the design in endojs/endo-but-for-bots#1574

Repo: https://github.com/endojs/endo-but-for-bots. Design PR: https://github.com/endojs/endo-but-for-bots/pull/1574.

Build exactly the design produced by the completed designer job `design-claude-api-agent-workbench-20261027` (its report is in `jobs/tada/`). Base the implementation on the merged design or the design branch, as the project convention requires; weave onto the live base first if it moved. Open a DRAFT PR: completion stages its gauntlet. Report a gap rather than weaken a property the design requires.

Dispatched by design-build-handoff.sh from the design report's follow-ups:

> - **Build:** the workbench build is Endo phases W1–W5, the minion.town chat Clip C1–C4, and the W6 live canary. I posted no build job; the build handoff picks it up once the design gauntlet passes.
> - **The build waits on:** the maintainer's answers to the open questions, #1543 merging and its phase 5 landing, and, for chat Clip phase C3, minion.town#88 or the `ChatDoor` stopgap named in open question 1.
> - **Stacked PR:** #1574's base is a snapshot of #1543's head. If #1543 is rebased, #1574 needs a new snapshot and a rebase onto it.
> - **Budget request not filed:** the budget-request skill names `scripts/jobs/request-budget.sh`, which exists neither in the deployed root nor on `main2`. My estimate is about 40M tokens across about 10 builder jobs, effort slug `api-key-agent-workbench`. The skill and its script need reconciling.

<!-- garden-annotation: key=moved-to-minion-town-238 by=gardener at=2026-11-04T01:29:35Z fields=gate=awaiting-maintainer -->

The design moved to https://github.com/kriscendobot/minion.town/pull/238 (maintainer review https://github.com/endojs/endo-but-for-bots/pull/1574#pullrequestreview-5761501306); endojs/endo-but-for-bots#1574 is closed unmerged. Build from designs/api-key-agent-workbench.md in kriscendobot/minion.town. Read every reference to #1574 in this job as minion.town#238. Do not build W1-W5 before the maintainer answers open question 7 of that design.
