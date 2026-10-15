---
role: builder
tier: mentor
arc: minion-town-ui
---
<!-- garden-promoted-from-plan: gate=deferred priority=normal at=2026-10-15T06:06:47Z cleared=none -->

---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
# Gutter: drag and keyboard reorder, persisted per owner (minion-town-ui increment)

Repo: kriscendobot/minion.town (base `main`). Arc `minion-town-ui`. Plan: https://github.com/kriscendobot/garden/blob/main2/designs/minion-town-clip-gutter-plan.md (job plan-minion-town-clip-gutter-20261010). Design of record: minion.town `designs/clip-shell-framework.md`. Code: `deploy/aws/www/{index.html,shell.js}`, `src/auth/guest-self-endpoint.ts`, `test/shell-clip.test.ts`.

Add drag-reorder plus a keyboard reorder (Alt+ArrowUp/Down, or Left/Right in portrait) to `createClipGutter`. Persist the order server-side, owner-scoped by `iss`+`sub`, beside `/account/clips` (for example a gated `PUT /account/clips/order` that accepts only hashes the owner already holds). Never persist it in localStorage, per the design's resolved question #3. Order the listing by the saved order, and put unknown clips last. Open a draft PR with tests.
