---
gate: orchestrated
orchestrated_by: endo-npm-cas-arc-landing-2
priority: normal
posted_by: producer
posted_at: 2026-08-01T09:15:08Z
---

---
handler-timeout: 7200
tier: mentor
fallback-tier: minion
dispatch: automatic
---
Repo: endojs/endo-but-for-bots (base `llm`)
PR: https://github.com/endojs/endo-but-for-bots/pull/877 (OPEN/DRAFT, CONFLICTING, dual-build npm packages)

Rebase #877 onto current `llm` and drive CI green. It shares `__archiveEndowments` with #876,
which lands earlier in this orchestration, so this PR takes the rebase around it.

Leave it DRAFT — no un-draft, no merge. It has no maintainer promotion. Report its state.
