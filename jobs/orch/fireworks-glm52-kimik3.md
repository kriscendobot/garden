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

## The key: blocker CLEARED on this host (amended 2026-07-28T07:3xZ)

**Superseded.** This orchestration was posted at 07:15-07:17Z stating that
`FIREWORKS_API_KEY` was **not present** on `endolin-garden-ece02cb4`. That was true
when posted and is **no longer true**. The container was recreated with the key at
07:20Z. Verified on `endolin-garden-ece02cb4` by the liaison at 07:3xZ, presence
only, no value read or logged:

- the tmpfs handoff `/run/environment.d/60-garden-api-keys.conf` carries **both**
  `MOONSHOT_API_KEY` and `FIREWORKS_API_KEY`;
- `systemctl --user show-environment` carries both, so the user manager has them;
- every running worker inherited both (`/proc/<pid>/environ` checked for
  `garden-gardener@1`, `garden-cleric@1`, `garden-mystic@1`);
- `GARDEN_FIREWORKS_BASE_URL` resolves to `https://api.fireworks.ai/inference/v1`.

So the systemd handoff is **working as designed**. There was never a threading
defect: the jobs were simply posted about three minutes before the key landed.

The runbook ([context/operations/fireworks.md](../../context/operations/fireworks.md))
still supplies the key **only at container creation**
(`./garden reset` then `FIREWORKS_API_KEY=... ./garden create`), so **no agent can
self-provision it**. That constraint stands.

**Still open: which host the canary runs on.** Key presence is confirmed on
`endolin-garden-ece02cb4` only. The leader, `endolin-garden2-5bcdff64`, is
**unverified** (the survey child could not check it from this container). Child 3
must verify presence on whatever host actually claims it, and still halts if the
key is absent there. Do not assume the leader carries it.

Standing constraint across all three: never print, log, or commit a key value, an
`Authorization` header, or an API response body. Status codes only.
