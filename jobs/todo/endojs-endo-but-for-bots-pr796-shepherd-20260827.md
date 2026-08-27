---
tier: mentor
---
<!-- garden-promoted-from-plan: gate=orchestrated priority=normal at=2026-08-27T06:07:03Z cleared=none -->

---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
Second step of the PR #796 unpin/rebase/shepherd/merge chain
(https://github.com/endojs/endo-but-for-bots/pull/796). The base has just
been unpinned back to `llm` and rebased by the preceding orchestrated
child. Drive CI to green on the rebased head. Do not touch the base again;
that step is already done.
