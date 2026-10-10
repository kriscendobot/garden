---
gate: deferred
priority: normal
role: designer
arc: minion-town-ui
posted_by: designer
posted_at: 2026-10-10T16:41:00Z
---

---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
# Iframe: design the clip embedding relaxation (minion-town-ui increment)

Repo: kriscendobot/minion.town (base `main`). Arc `minion-town-ui`. Plan: https://github.com/kriscendobot/garden/blob/main2/designs/minion-town-clip-gutter-plan.md (job plan-minion-town-clip-gutter-20261010). Design of record: minion.town `designs/clip-shell-framework.md`. Code: `deploy/aws/www/{index.html,shell.js}`, `src/auth/guest-self-endpoint.ts`, `test/shell-clip.test.ts`.

Answer open question #1 of `designs/clip-shell-framework.md` concretely. `src/endo/gateway/isolation-headers.ts` denies framing of every `*.ocap.site` response (`frame-ancestors 'none'`, `X-Frame-Options: DENY`, `COEP: require-corp`), so the shell's main pane can only show inert cards. Propose the narrowest relaxation that lets `https://minion.town`'s gated shell frame a clip and keeps the floor for every other embedder: header set, CORP/COEP story, iframe sandbox flags, and how it interacts with #88's nonce locator. Cost at least one alternative, for example a top-level-only clip or a different embedding primitive. Deliver it as a design PR on kriscendobot/minion.town with an Open questions section. That PR is the maintainer's decision surface. Do not build anything.
