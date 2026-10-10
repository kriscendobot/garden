---
gate: blocked
blocked_on: https://github.com/kriscendobot/minion.town/pull/142
priority: normal
role: builder
arc: minion-town-ui
posted_by: designer
posted_at: 2026-10-10T16:41:11Z
---

---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
# Gutter: the + button mints a real clip (minion-town-ui increment)

Repo: kriscendobot/minion.town (base `main`). Arc `minion-town-ui`. Plan: https://github.com/kriscendobot/garden/blob/main2/designs/minion-town-clip-gutter-plan.md (job plan-minion-town-clip-gutter-20261010). Design of record: minion.town `designs/clip-shell-framework.md`. Code: `deploy/aws/www/{index.html,shell.js}`, `src/auth/guest-self-endpoint.ts`, `test/shell-clip.test.ts`.

Design section 6: wire the gutter's `+` to a browser-reachable guest-publish endpoint. It mints a real self-describing `front`/`back` pair only through the guest's own `@sites` power (`src/endo/gateway/publish.ts`, `src/endo/guest-control.ts`). Never use gateway authority, and never pass `sites`/`@agent` as the clip's public powers. Build to the lifecycle authority model that #142 (clip lifecycle authority as capabilities) landed. Read #142's merged form first, and stop and report if it was closed unmerged. Open a draft PR with tests.
