---
source_kind: web
source_url: https://raw.githubusercontent.com/tc39/proposal-module-expressions/main/README.md
source_content_sha256: 4b29381601d31c9ddb3eab19f8298b5d52b77c1ef934df18196ef41d0ece3697
source_authors: [Surma, Daniel Ehrenberg, Nicolò Ribaudo]
source_date: 2025-01-01
retrieved: 2026-07-21
ingested: 2026-07-21
ingested_by: scholar
section_count: 2
status: current
notes: "TC39 module expressions (previously 'module blocks' / 'js-module-blocks'). Repo is proposal-module-expressions; the older proposal-js-module-blocks URL redirects here. Stage-3 reviewers are listed in the README (Harband, Balter, Bedford, Kowal, Works). Fetched direct via scripts/jobs/fetch-source.sh; idempotency anchor is source_content_sha256. source_date is an era approximation. Canonical human page: https://github.com/tc39/proposal-module-expressions. Part of the tc39-module-harmony cluster (job scholar-research-module-harmony-intersection)."
---

The **module expressions** proposal makes `module { … }` a primary expression evaluating to a `Module` object — importable only via dynamic `import()`, cached in the module map, capturing its declaring realm but unable to close over outer lexical variables (which makes it structured-cloneable and re-attachable to a ShadowRealm). The `Module` class it introduces is deliberately minimal; the Compartments proposal is expanding it. It cannot solve inter-module-reference bundling (that is the module-declarations proposal). Its `module {}`-is-a-`Module`-instance surface is a direct intersection edge with the Compartments `Module`/`ModuleSource` model, motivating off-main-thread schedulers (greenlet-style), worklets, and cross-realm code transfer.

| Section | Topics | Status |
|---------|--------|--------|
| [module-expression-syntax-and-semantics](../sections/tc39-module-harmony--module-expressions--module-expression-syntax-and-semantics.md) | module-harmony | current |
| [relationship-to-module-class-and-bundling](../sections/tc39-module-harmony--module-expressions--relationship-to-module-class-and-bundling.md) | module-harmony | current |
