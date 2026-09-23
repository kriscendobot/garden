---
source_kind: web
source_url: https://raw.githubusercontent.com/tc39/proposal-module-declarations/main/README.md
source_content_sha256: 78c1d1724d4270f12a1d7ba9f80d6b2dd87067de6dfe84368c4ad3cb0dcd0410
source_authors: [Daniel Ehrenberg, Nicolò Ribaudo]
source_date: 2024-01-01
retrieved: 2026-07-21
ingested: 2026-07-21
ingested_by: scholar
section_count: 1
status: current
notes: "TC39 module declarations (previously 'module fragments'; Stage 2). Repo is proposal-module-declarations; the older proposal-module-fragments URL redirects here. Fetched direct via scripts/jobs/fetch-source.sh; idempotency anchor is source_content_sha256. source_date is an era approximation (Stage 2). Canonical human page: https://github.com/tc39/proposal-module-declarations. Part of the tc39-module-harmony cluster (job scholar-research-module-harmony-intersection). Single overview section — the README's resource-bundles comparison is summarized in-section as a shape rather than transcribed."
---

The **module declarations** proposal makes `module Identifier { … }` a top-level declaration for a named inline JS module that can be imported *statically* (`import { count } from countModule`), unlike an anonymous module expression. Declarations are singletons with their own top-level lexical scope, visible outside their file only if `export`ed, intended as a low-overhead JS-only bundling format that engines and tools can see through (ideally nested inside general-purpose resource bundles). It inherits the no-shared-scope and `import.meta.url`-of-the-outer-module design from module expressions, and its advancement depends on module expressions evolving.

| Section | Topics | Status |
|---------|--------|--------|
| [named-inline-modules-for-bundling](../sections/tc39-module-harmony--module-declarations--named-inline-modules-for-bundling.md) | module-harmony | current |
