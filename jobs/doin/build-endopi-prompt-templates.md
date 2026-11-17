---
role: builder
tier: mentor
arc: unallocated
posted_at: 2026-11-17T12:01:23Z
---
<!-- garden-promoted-from-plan: gate=blocked priority=normal at=2026-11-17T19:07:35Z cleared=none -->

---
role: builder
arc: unallocated
dispatch: automatic
tier: mentor
fallback-tier: minion
---
# Build: the design in endojs/endo-but-for-bots#1671

Repo: https://github.com/endojs/endo-but-for-bots. Design PR: https://github.com/endojs/endo-but-for-bots/pull/1671.

Build exactly the design produced by the completed designer job `design-endopi-prompt-templates` (its report is in `jobs/tada/`). Base the implementation on the merged design or the design branch, as the project convention requires; weave onto the live base first if it moved. Open a DRAFT PR: completion stages its gauntlet. Report a gap rather than weaken a property the design requires.

Dispatched by design-build-handoff.sh from the design report's follow-ups:

> - **Build:** rework the existing draft #1640 to match this design (the "Delta from #1640" list), rather than opening a new build PR. #1640 also edits this design file, so it will need a rebase.
> - I left #1671 as a draft; the completion machinery records its design-panel gauntlet.

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 1
  worker_kind: monk
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-11-17T19:11:16Z
