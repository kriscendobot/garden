---
gate: orchestrated
orchestrated_by: endo-npm-cas-arc-landing-2
priority: normal
posted_by: producer
posted_at: 2026-08-01T09:15:13Z
---

---
handler-timeout: 7200
tier: mentor
fallback-tier: minion
dispatch: automatic
---
Repo: endojs/endo-but-for-bots (base `llm`)
PR: https://github.com/endojs/endo-but-for-bots/pull/878 (OPEN/DRAFT, CONFLICTING, WHATWG URL and URLSearchParams endowment)

Rebase #878 onto current `llm` and drive CI green.

#878 endows web globals, so it is governed by the default-condition-set policy just resolved by
the approval of #876: opt-in via the explicit `--conditions` flag, NOT browser-by-default.
Check whether #878 as written matches that policy; if it endows `URL`/`URLSearchParams`
unconditionally, report the mismatch rather than merging — reconciling it may need a design change.

Leave it DRAFT — no un-draft, no merge. Report its state.
