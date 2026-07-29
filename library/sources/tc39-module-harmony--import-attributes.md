---
source_kind: web
source_url: https://raw.githubusercontent.com/tc39/proposal-import-attributes/master/README.md
source_content_sha256: f9ee63b07ed212445afc977b380df504aacd38fa0e6eb3066d725f7cbf73b32f
source_authors: [Sven Sauleau, Daniel Ehrenberg, Myles Borins, Dan Clark, Nicolò Ribaudo]
source_date: 2023-03-01
retrieved: 2026-07-29
ingested: 2026-07-29
ingested_by: scholar
section_count: 4
status: current
notes: "TC39 Import Attributes (Stage 4; formerly Import Assertions, before that Module Attributes). Repo is proposal-import-attributes, default branch `master`. Fetched direct via scripts/jobs/fetch-source.sh (source_fetched_via=direct); idempotency anchor is source_content_sha256. source_date is the last dated history entry (2023-03, the return to Stage 3); the README's status line reads Stage 4, so the date is an era approximation for the document, not for the stage. The README itself warns that its spec text may lag tc39/ecma262#3057. Canonical human page: https://github.com/tc39/proposal-import-attributes. Ingested as one of the three module-harmony NEIGHBOR proposals flagged but deferred by the layer-4 cycle (job scholar-research-module-harmony-compartment-layer4); part of the tc39-module-harmony cluster."
---

**Import Attributes** adds inline key-value syntax after a module specifier: `import json from "./foo.json" with { type: "json" }`, and `import("foo.json", { with: { type: "json" } })` for the dynamic form. Its motivation is a security one rather than an ergonomic one. Importing a module type that cannot execute code (JSON, and later CSS and possibly HTML) needs a syntactic marker so a server answering with an unexpected Content-Type cannot get code executed where data was expected, and the file extension cannot serve as that marker because a URL's suffix does not determine its interpretation on the web. The proposal specifies no meaning for any particular key or value (`type: "json"` is defined by the separate JSON modules proposal) and makes exactly one registry-visible commitment: the module cache key extends from `(referrer, specifier)` to `(referrer, specifier, attributes)`. The dynamic-import second argument is an **options bag** whose `with` entry sits beside the `phase` entry the Module Source Imports proposal adds, which is the structural reason attributes and phases stay orthogonal in module harmony. The proposal's three-name, two-keyword history (module attributes → import assertions → import attributes; `with` → `assert` → `with`; Stage 3 → Stage 2 → Stage 3 → Stage 4) is why `assert { type: "json" }` still appears in shipped code.

| Section | Topics | Status |
|---------|--------|--------|
| [synopsis-and-motivation](../sections/tc39-module-harmony--import-attributes--synopsis-and-motivation.md) | module-harmony | current |
| [rationale-and-proposed-syntax](../sections/tc39-module-harmony--import-attributes--rationale-and-proposed-syntax.md) | module-harmony | current |
| [semantics-interoperability-and-the-cache-key](../sections/tc39-module-harmony--import-attributes--semantics-interoperability-and-the-cache-key.md) | module-harmony, module-loader | current |
| [history-from-module-attributes-to-import-attributes](../sections/tc39-module-harmony--import-attributes--history-from-module-attributes-to-import-attributes.md) | module-harmony | current |
