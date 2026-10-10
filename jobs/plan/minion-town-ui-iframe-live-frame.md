---
gate: blocked
blocked_on: minion-town-ui-iframe-embed-headers
priority: normal
role: builder
arc: minion-town-ui
posted_by: designer
posted_at: 2026-10-10T16:41:36Z
---

---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
# Iframe: frame the live clip in the main pane (minion-town-ui increment)

Repo: kriscendobot/minion.town (base `main`). Arc `minion-town-ui`. Plan: https://github.com/kriscendobot/garden/blob/main2/designs/minion-town-clip-gutter-plan.md (job plan-minion-town-clip-gutter-20261010). Design of record: minion.town `designs/clip-shell-framework.md`. Code: `deploy/aws/www/{index.html,shell.js}`, `src/auth/guest-self-endpoint.ts`, `test/shell-clip.test.ts`.

Once clips are frameable by the shell (job minion-town-ui-iframe-embed-headers), add the live `src` branch at the `showClip` sink in `shell.js`. Set the origin re-derived from the validated id via `clipOrigin` and never a stored string. Use the approved sandbox flags. Fall back to the inert card when the clip fails to load or refuses framing. Keep the chrome unforgeable (design section 4). If #88 (fresh-id-on-upgrade) has landed, reconcile the frame key with its id model first. Open a draft PR with tests.
