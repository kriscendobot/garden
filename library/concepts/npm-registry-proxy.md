---
id: npm-registry-proxy
aliases: [npm registry, registry capability, EndoRegistry, minimum version selection, MVS]
topics: [daemon, content-addressed-storage]
status: draft
---

# npm-registry-proxy

Endo's npm-registry proxy combines an on-demand registry metadata and tarball fetcher, Go-like Minimum Version Selection, a registry table, and content-addressed package trees so Node and XS-hosted runtimes can resolve and execute npm packages without `npm install` or a `node_modules` directory.

## Sections that touch this concept

| Section | One-line summary |
|---|---|
| [NPM Registry Proxy via CAS and Registry Table](../sections/endo-but-for-bots--llm-designs-endor-npm-registry-proxy--Go-style-MVS-and-CAS-plus-registry-table-replaces-node_modules-and-five-Implementation-Phases-and-five-Design-decisions-and-three-cycles-wi-12ec4a7c--endor-npm-registry-proxy-npm-r.md) | Frames the CAS plus registry-table substitution for `node_modules`. |
| [Go-style Minimum Version Selection](../sections/endo-but-for-bots--llm-designs-endor-npm-registry-proxy--Go-style-MVS-and-CAS-plus-registry-table-replaces-node_modules-and-five-Implementation-Phases-and-five-Design-decisions-and-three-cycles-wi-12ec4a7c--go-style-minimal-version-selec.md) | Defines the greatest-mentioned-version-per-major selection rule. |
| [CAS tree structure](../sections/endo-but-for-bots--llm-designs-endor-npm-registry-proxy--Go-style-MVS-and-CAS-plus-registry-table-replaces-node_modules-and-five-Implementation-Phases-and-five-Design-decisions-and-three-cycles-with-Prompt-section--cas-tree-structure.md) | Shows packages as immutable recursive CAS trees. |
| [Reuse the platform interface](../sections/endo-but-for-bots--llm-designs-exo-zip-package--in-memory-zip-as-exo-readable-tree-with-asymmetric-by-design-read-API-and-resolved-questions-trail--the-reuse-platform-interface-not-daemon-interface-discipline.md) | Establishes the precedent for presenting a new source through the shared readable-tree interface. |

## See also

- [[formula-graph]] — durable capabilities retain the package trees selected by a resolution.
- [[gc-quarantine-store]] — related content-addressed retention and collection mechanics.
