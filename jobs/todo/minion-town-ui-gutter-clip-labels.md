---
role: builder
tier: mentor
arc: minion-town-ui
---
<!-- garden-promoted-from-plan: gate=deferred priority=normal at=2026-10-11T01:39:08Z cleared=none -->

---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
# Gutter: real clip names and icons (minion-town-ui increment)

Repo: kriscendobot/minion.town (base `main`). Arc `minion-town-ui`. Plan: https://github.com/kriscendobot/garden/blob/main2/designs/minion-town-clip-gutter-plan.md (job plan-minion-town-clip-gutter-20261010). Design of record: minion.town `designs/clip-shell-framework.md`. Code: `deploy/aws/www/{index.html,shell.js}`, `src/auth/guest-self-endpoint.ts`, `test/shell-clip.test.ts`.

Today every gutter clip is "Clip N" with a rotating emoji, because `clipRecordsFromListing` sees only `{hash, serving}`. Source a display name from what the publish/`listSites` path already knows (the guest's name for the site, or the front's `<title>`). Carry it as an optional, validated, length-capped field on `GET /account/clips`, and fall back to "Clip N". Render `serving: false` as a dimmed or disabled state. Treat the name as untrusted text, so render it with textContent only and never as HTML. Open a draft PR with tests.
