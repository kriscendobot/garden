---
role: designer
arc: minion-town-ui
tier: mentor
fallback-tier: minion
dispatch: automatic
---
# Design: detect a crawler on an ocap.site page as a link-leak signal, and rotate

Repo: https://github.com/kriscendobot/minion.town. Budget: the `minion-town-ui` arc.

## Maintainer's idea (2026-10-08)

A clip is served at `<hash>.ocap.site` and the URL is a bearer capability. If a crawler bot
fetches a clip page, that is evidence the link reached the open internet (pasted somewhere
public, indexed, scraped). That should be detected and the clip's link **rotated
automatically**. There is not yet a mechanism for rotating a formula identifier; a sibling
design job on `endojs/endo-but-for-bots`, `design-endo-formula-identifier-indirection`,
designs that layer. This design must not assume it exists; it must state the interface it
needs from it and what to do until it lands.

Read first: `designs/ocap-site-clip-isolation.md`, `designs/clip-formula-id-origin-and-content-gc.md`,
the gateway request path, and the live edge (Caddy) configuration and logs.

## Sift: direction versus speculation

Open the design with a short section that separates (a) what is established direction from
(b) what is speculation or unknown. In particular:

- **Direction:** a crawler hit is a leak signal; leak response is automatic rotation of the
  link; detection must be deterministic code, not an LLM.
- **Speculation to treat as a question, with evidence before any claim:** that a crawler can
  be told reliably from a legitimate visitor at all. A user-agent string is forgeable and many
  scrapers send browser UAs; link previews (chat apps, mail scanners, unfurlers) fetch URLs
  for legitimate recipients and would cause false rotations; a malicious actor can trigger
  rotation on purpose (a denial of service on a clip owner). Measure what real traffic to
  the live edge looks like before proposing thresholds. Do not invent a crawler
  taxonomy from memory.

## What the design must settle

1. **Signals**, ranked by reliability and cost: declared bot user agents against published
   lists, `robots.txt` fetches (a clip origin's own `robots.txt` as a tripwire), reverse-DNS
   verified search-engine ranges, request-shape heuristics, first-fetch-from-unexpected
   geography, honeypot paths. Say which are cheap, which false-positive on link unfurlers,
   and which an attacker can spoof.
2. **Where it lives:** at the Caddy edge, in the gateway, or from log analysis after the fact;
   what is logged, retention, and privacy (no raw IP retention beyond what the decision
   needs).
3. **Response ladder**, not a single trigger: observe, alert the clip owner, rotate. Define
   thresholds, a grace window for known unfurlers, per-clip rate limits so a hostile actor
   cannot force churn, and the owner's ability to pin a clip as public so it is never rotated.
4. **Rotation semantics for a user:** what the old link does after rotation (gone, or a
   tombstone page that says it was rotated), how the owner learns the new link, and what
   happens to anything that embedded the old link.
5. **Dependency on formula-identifier rotation:** state the minimal interface required
   (`rotate(clip) -> newLocator`, old locator revoked) and a degraded mode for before it
   exists (for example, republish the clip under a fresh content hash and retire the old
   origin) with its costs.
6. **Acceptance and production check:** tests an automatic production canary can run,
   including a synthetic crawler hitting a canary clip and the rotation being observed.

Include mermaid flows (no ASCII art) and an `## Ownership map` (edge, gateway, daemon, owner).
Open the design as a DRAFT PR on `kriscendobot/minion.town`. Under the maintainer's
2026-10-07 standing order (journal `entries/2026/10/07/203746Z-message-gardener-a253b1.md`),
the arc supervisors carry it; do not wait on the maintainer. Genuine forks go in the
design's `## Open questions`.

<!-- garden-reaped: 1 -->
<!-- garden-plain-retry-not-before: 2026-10-08T20:23:54Z -->

<!-- garden-terminal-handler-failure -->
---
claim:
  host: endolin-garden2-5bcdff64
  gardener: 2
  worker_kind: cleric
  tier: 
  provider: openai
  model: 
  claimed_at: 2026-10-08T20:40:07Z
