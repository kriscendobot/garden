---
source_kind: web
source_url: https://raw.githubusercontent.com/tc39/proposal-asset-references/master/README.md
source_content_sha256: d40d635e77e9c8b21f811167e89e0339f06b7da6db76fc758d50e8173091f843
source_authors: [Sebastian Markbåge]
source_date: 2021-01-01
retrieved: 2026-07-29
ingested: 2026-07-29
ingested_by: scholar
section_count: 4
status: current
notes: "TC39 Asset References (Stage 1 since 2018-11; champion Sebastian Markbåge per the TC39 stage-1 proposals table). Repo is proposal-asset-references, default branch `master`; the README carries no author line, so authorship is taken from the TC39 proposals list rather than from the document. Fetched direct via scripts/jobs/fetch-source.sh (source_fetched_via=direct); idempotency anchor is source_content_sha256. source_date is an era approximation: the document is undated, and its Deno section references deno.land manual material from roughly 2020-2021. Canonical human page: https://github.com/tc39/proposal-asset-references. Ingested as one of the three module-harmony NEIGHBOR proposals flagged but deferred by the layer-4 cycle (job scholar-research-module-harmony-compartment-layer4); part of the tc39-module-harmony cluster."
---

**Asset References** adds `asset Foo from "foo";`: a statically declared, first-class reference to a module's *identity* that does not load or initialize it. The binding is a const holding a fresh object whose prototype is `AssetReference.prototype`, with internal slots `[ReferencingModule]` and `[AssetSpecifier]`; passing it to dynamic `import()` runs `HostImportModuleDynamically` with those two, and passing it to a host loader can resolve it to an image, CSS, font, or any other resource. A new object per statement is required specifically "to avoid creating an implicit back channel", and canonical resolution may be deferred because canonicalizing is expensive on some hosts. The motivation is that an asset specifier is relative to the *executing* module, so the capability cannot be built at library level; the proposal wants an external resource manager to own retry, fallback, scheduling, and cache interaction while the module keeps the static declaration a bundler can see. It names the `require.resolve` / `require.resolveWeak` situation "a missing piece crying for standardization", and, in the paragraph that matters most to Hardened JavaScript, frames asset references as the way to lock down asset access "in small sandboxed environments like SES": a reference owned by one module until explicitly passed along, so one loading library can serve two modules without granting either access to the other's assets. Strings, Symbols, and `import.meta.resolve` are all rejected as alternatives, strings partly because manual path manipulation "risks a number of security related bugs that can give access to arbitrary paths".

| Section | Topics | Status |
|---------|--------|--------|
| [asset-declaration-syntax-and-semantics](../sections/tc39-module-harmony--asset-references--asset-declaration-syntax-and-semantics.md) | module-harmony, module-loader | current |
| [motivation-library-mediated-loading-and-per-module-authority](../sections/tc39-module-harmony--asset-references--motivation-library-mediated-loading-and-per-module-authority.md) | module-harmony, capability-security | current |
| [alternatives-and-possible-additions](../sections/tc39-module-harmony--asset-references--alternatives-and-possible-additions.md) | module-harmony | current |
| [use-cases-node-react-and-deno](../sections/tc39-module-harmony--asset-references--use-cases-node-react-and-deno.md) | module-harmony, node-packaging | current |
