---
role: designer
tier: mentor
---
<!-- garden-promoted-from-plan: gate=go-ahead priority=normal at=2026-08-16T05:56:30Z cleared=none -->

---
role: designer
tier: mentor
fallback-tier: minion
dispatch: automatic
---
---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
Redesign weblet publishing in kriscendobot/minion.town along object-capability
lines, per @kriskowal's review closing
https://github.com/kriscendobot/minion.town/pull/44#pullrequestreview-4941714274
(PR #44 closed unmerged 2026-08-14).

Directive from the review (maintainer intent, paraphrased): the entire premise of
this system is object capabilities. A guest empowers a weblet ONLY with powers it
already holds or synthesizes from powers it holds. Publishing a weblet should be a
**synthesis of content and powers**, mirroring how weblets were designed in the
daemon — NOT a gateway-side guard that resolves a caller-supplied powers name in
the gateway's own authority and then blocklists host-shaped results (the closed
PR #44 approach). Under the correct model there is no caller-supplied-name-in-
gateway-authority seam to defend, because the guest supplies the actual power
object by introduction, not a string the gateway resolves.

Design ask: produce a design doc for weblet publish as a content+powers synthesis
that follows the daemon's weblet model. Include a **lookup-formula indirection**
over the named readable content tree so static content can be upgraded in place
(the named readable tree can be replaced without republishing / re-minting the
weblet identity). Show how a guest passes powers by introduction rather than by a
gateway-resolved name, and how this removes the host-escape class the closed PR
was patching. Reference the daemon's weblet publish design as the model to mimic.
Report the design doc / PR and how it satisfies the ocap premise above.

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 2
  worker_kind: gardener
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-08-16T05:56:36Z
