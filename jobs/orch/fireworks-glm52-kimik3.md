---
order: serial
children: fireworks-glm52-kimik3-survey fireworks-glm52-kimik3-build fireworks-glm52-kimik3-canary
on-child-failure: halt
state: running
created_by: liaison
created_at: 2026-07-28T07:17:28Z
---

# Take advantage of FIREWORKS_API_KEY for GLM 5.2 and Kimi K3

Maintainer directive (kriskowal, 2026-07-28, via the liaison on
`endolin-garden-ece02cb4`): *"build out what's needed to take advantage of the new
FIREWORKS_API_KEY for GLM 5.2 and Kimi K3."*

Serial, halt-on-child-failure, in three steps:

1. **`fireworks-glm52-kimik3-survey`** — establish the current Fireworks wire model
   ids for both models (the garden bakes no catalog default by design), resolve how
   a Fireworks-served Kimi K3 should relate to the existing Moonshot-CLI `mystic`
   lane, and write an executable build proposal.
2. **`fireworks-glm52-kimik3-build`** — wire the routes, tests, and docs. Pool stays
   at zero; no canary; the Moonshot K3 lane stays intact.
3. **`fireworks-glm52-kimik3-canary`** — bounded activation under a key-bearing
   container, one canary per model, then back to zero.

## The standing blocker the maintainer must clear

`FIREWORKS_API_KEY` is **not present** on `endolin-garden-ece02cb4`: the tmpfs
handoff `/run/environment.d/60-garden-api-keys.conf` carried only
`MOONSHOT_API_KEY` when this was posted (2026-07-28T07:1xZ). The runbook
([context/operations/fireworks.md](../../context/operations/fireworks.md)) supplies
the key **only at container creation** — `./garden reset` then
`FIREWORKS_API_KEY=... ./garden create` — so **no agent can self-provision it**.

Children 1 and 2 are deliberately scoped to need no key, so the build-out proceeds
regardless. Child 3 **halts** if it cannot find a key-bearing host, which under the
halt policy surfaces to the maintainer rather than stalling silently. Child 1 is
asked to record whether any host in the fleet (notably the leader,
`endolin-garden2-5bcdff64`) does carry the key.

Standing constraint across all three: never print, log, or commit a key value, an
`Authorization` header, or an API response body. Status codes only.
