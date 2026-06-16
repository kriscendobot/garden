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
title: §The-§WebletFormula-typedef (researcher's gap 2)
parent: endo-but-for-bots--llm-designs-gateway-package--ten-feature-decomposition-of-one-package-with-one-factory-many-configurations
---

```ts
interface WebletFormula {
  type: 'weblet';
  contentRoot: FormulaIdentifier;       // readable-tree
  mimeTypes?: Record<string, string>;
  ssrHandler?: FormulaIdentifier;
  virtualHosts?: ReadonlyArray<string>;
}
```

§The-load-bearing-typedef-for-Phase-11b (which the
researcher's 895d06 dispatch refined a builder prompt
for). §Daemon-side-formula-type-the-gateway-consumes.

§Three-optional-fields encode §progressive-customization:
mimeTypes (per-extension MIME overrides), ssrHandler
(SSR-route handler called via CapTP), virtualHosts
(explicit bind names).

§§Researcher-gap-2-addressed: ingesting this section makes
the WebletFormula typedef discoverable in the library;
the Phase 7 builder result remains the canonical
implementation source, but the design's typedef is now
indexed.
