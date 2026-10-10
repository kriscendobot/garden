---
gate: blocked
blocked_on: minion-town-ui-iframe-embed-design
priority: normal
role: builder
arc: minion-town-ui
posted_by: designer
posted_at: 2026-10-10T16:41:23Z
---

---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
# Iframe: implement the approved embedding headers (minion-town-ui increment)

Repo: kriscendobot/minion.town (base `main`). Arc `minion-town-ui`. Plan: https://github.com/kriscendobot/garden/blob/main2/designs/minion-town-clip-gutter-plan.md (job plan-minion-town-clip-gutter-20261010). Design of record: minion.town `designs/clip-shell-framework.md`. Code: `deploy/aws/www/{index.html,shell.js}`, `src/auth/guest-self-endpoint.ts`, `test/shell-clip.test.ts`.

Implement in `src/endo/gateway/isolation-headers.ts` the clip-embedding relaxation that the design PR from job minion-town-ui-iframe-embed-design names. Add tests proving that only the approved ancestor may frame a clip and that the floor still holds for every other embedder and route. FIRST check that the design PR was approved or merged by the maintainer. If it was not, stop and report rather than building.
