---
posted_at: 2026-11-03T21:22:38Z
tier: mentor
fallback-tier: minion
dispatch: automatic
---
repo: https://github.com/kriscendobot/minion.town
upstream: https://github.com/endojs/endo-but-for-bots (branch llm)
tracker: https://github.com/kriscendobot/minion.town/issues/227
task: Maintainer goal (2026-11-03): remote invitations minted by minion.town must carry connection hints so a daemon elsewhere can dial and accept them. Today POST /api/guest/invitations kind=remote returns an endo:// locator with a single path component and only type/from/fromNode query keys, because the account daemon advertises only the `loop` network (proved by job prove-minion-town-invitations-20261103; see context/operations/minion-town-mcp.md "Remote invitations").

Do, in order:
1. Trace how EndoGuest.invite fills a locator's hints (packages/daemon/src/guest.js and the locator code on endo-but-for-bots llm): which networks and advertised addresses feed it, and what the account daemon would need to advertise.
2. Determine the cheapest real network to advertise. Known facts: the OCapN-CBOR-Noise bootstrap over wss://minion.town/.well-known/ocapn-cbor-np was proven dialable from the garden host on 2026-08-28 with the containment route opened by the maintainer (garden issue 58); the Noise TCP netlayer landed in llm (endo-but-for-bots#340); WS+Noise netlayer #684 is still a draft. Verify what is live and merged now, not these dated claims.
3. Implement it as a DRAFT PR on kriscendobot/minion.town (plus an Endo change as a separate draft PR if one is required, stacked per the usual rules): the account daemon advertises that address, and a remote invitation locator carries it.
4. Prove it locally first with a scratch daemon (see memory recipes: real-daemon harness), then state exactly what a production deploy would change.

Constraints: do NOT deploy and do NOT change production routing, Caddy, ports, or firewalls; any such change is the maintainer's decision and goes in the PR description as an explicit request. No secrets in logs. Pending invitations are process-memory-only, so note the deploy-voids-links caveat. Output: draft PR(s), and a report with the locator before and after, the hint format, and open questions.

<!-- garden-productive-cycle -->
<!-- garden-deadline-overrun: 1 -->
<!-- garden-reap-now -->
---
claim:
  host: oros-studio-garden-ce242c49
  gardener: 4
  worker_kind: monk
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-11-03T21:25:36Z
