---
gate: deferred
priority: normal
role: builder
arc: minion-town-ui
posted_by: designer
posted_at: 2026-10-10T16:40:35Z
---

---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
# Gutter: refresh the clip list without a reload (minion-town-ui increment)

Repo: kriscendobot/minion.town (base `main`). Arc `minion-town-ui`. Plan: https://github.com/kriscendobot/garden/blob/main2/designs/minion-town-clip-gutter-plan.md (job plan-minion-town-clip-gutter-20261010). Design of record: minion.town `designs/clip-shell-framework.md`. Code: `deploy/aws/www/{index.html,shell.js}`, `src/auth/guest-self-endpoint.ts`, `test/shell-clip.test.ts`.

The gutter loads `/account/clips` once per page load. Re-read it on `visibilitychange`/focus, plus a small manual refresh control, so a clip published over MCP appears without a reload. Keep the active selection if the clip still exists, and fall back to the empty state if it is gone. Debounce the reads, and make a failure keep the current list. Open a draft PR with tests.
