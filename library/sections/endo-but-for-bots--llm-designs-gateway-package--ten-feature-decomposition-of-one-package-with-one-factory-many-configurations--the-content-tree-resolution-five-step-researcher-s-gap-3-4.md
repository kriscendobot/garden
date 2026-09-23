---
source: designs/gateway-package.md
source_repo: endojs/endo-but-for-bots
source_url: https://github.com/endojs/endo-but-for-bots/blob/design/gateway-package/designs/gateway-package.md
source_path: designs/gateway-package.md
source_branch: design/gateway-package
section_kind: design
ingested: 2026-06-03
ingested_by: scholar
contributors:
  - Kris Kowal (prompted)
topics:
  - daemon
  - tooling
  - capability-security
genre: §endo-but-for-bots-design
cycle: 174
lane: designs
status: current
title: §The-§content-tree-resolution-five-step (researcher's gap 3+4)
parent: endo-but-for-bots--llm-designs-gateway-package--ten-feature-decomposition-of-one-package-with-one-factory-many-configurations
---

```mermaid
Client → GW: GET /index.html, Host: chat.example.com
GW: lookup virtual host → webletFormulaId
GW → CAS: read contentRoot/index.html
  on miss: GW → UD: fetchContentTree(root)
GW → Client: 200 OK, bytes
```

§The-five-step-path:

1. Gateway receives request with Host header.
2. Gateway looks up Host in virtual-host table →
   webletFormulaId.
3. Gateway fetches weblet formula from user daemon (or
   cache).
4. Gateway resolves path-suffix against
   webletFormula.contentRoot (a `readable-tree`).
5. Gateway serves bytes directly from CAS with mimeTypes
   overrides.

§Researcher-gap-3-addressed: `fetchContentTree` named as
the daemon-side capability the gateway invokes on cache
miss. §The-exo-the-Phase-11a-result-entry-named-as-
contract-surface.

§Researcher-gap-4-addressed: the §content-tree-walk maps
path-suffix → flat-entries-map of the `readable-tree`.
§Cycle-141-daemon-cas-management section already pins the
mechanism; this design names the consumer-side shape.
