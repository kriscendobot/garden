---
source_kind: repo-doc
source_repo: vitejs/vite
source_path: docs/config/dep-optimization-options.md
source_commit: 9beae37d7221b25463a011feb40b0303ca328d87
source_date: 2026-07-17
ingested: 2026-07-17
ingested_by: scholar
section_count: 1
status: current
---

Abstract: Vite's dependency-optimization configuration reference, the authoritative source for `optimizeDeps` (the dev-only dependency pre-bundler deferred from cycle 1): how Vite discovers bare dependencies (crawling `.html` entries or `optimizeDeps.entries`), the `include`/`exclude`/`noDiscovery` controls, the CommonJS-to-ESM interop the pre-bundle performs (and the `esm-dep > cjs-dep` nested-CJS form), and the `holdUntilCrawlEnd`/`needsInterop`/`force` tuning knobs. It backs the Vite `optimizeDeps` detail in the package-manifest consumer matrix, complementing the client/SSR resolution sections from cycle 1.

| Section | Topics | Status |
|---------|--------|--------|
| [optimizedeps-dependency-prebundling](../sections/vite--config-dep-optimization-options--optimizedeps-dependency-prebundling.md) | package-manifest | current |

Source: [docs/config/dep-optimization-options.md](https://github.com/vitejs/vite/blob/9beae37d7221b25463a011feb40b0303ca328d87/docs/config/dep-optimization-options.md) at commit `9beae37`.
