---
section: app-UI-manifest-with-three-sandbox-tiers-and-exo-binding-rule
source: endo-but-for-bots--llm-designs-familiar-app-ui-hosting
topics: [agent-conventions, capability-security]
status: current
title: The §three sandbox tiers
parent: endo-but-for-bots--llm-designs-familiar-app-ui-hosting--app-UI-manifest-with-three-sandbox-tiers-and-exo-binding-rule
---

The §Sandbox tiers table is the design's *load-bearing
mechanism*:

| Tier | Origin | CSP `connect-src` | CapTP to app exo | Use |
|------|--------|--------------------|--------------------|-----|
| `isolated` | unique `localhttp://<id>` | `'none'` | no | Pure presentational UI; no back-channel |
| `connected` (default) | unique `localhttp://<id>` | `'self'` | yes, **only** to its own exo | The normal case |
| `trusted` | unique `localhttp://<id>` | `'self'` + author-declared origins | yes | Author opts into extra reach |

The §tiers-widen-reach-never-relax-origin-isolation invariant
(Design Decision 2):

> *Every tier keeps the per-app unique origin and the
> `object-src 'none'` / `form-action 'self'` baseline from the
> existing protocol handler. Tiers only widen `connect-src` and
> whether a CapTP bootstrap is granted — they never relax origin
> isolation.*

The §two-axes-the-tiers-vary-along discipline: tiers differ in
*connect-src* (network reach) and *CapTP bootstrap* (back-
channel to exo); they don't differ in *origin isolation*
(unique localhttp per app), *plugin lockdown* (no plugins),
or *form posting* (only to self).
