---
title: Import Attributes — attribute-agnostic semantics, cross-host interoperability, and the extended module cache key
source_kind: web
source_url: https://raw.githubusercontent.com/tc39/proposal-import-attributes/master/README.md
source_content_sha256: f9ee63b07ed212445afc977b380df504aacd38fa0e6eb3066d725f7cbf73b32f
source_authors: [Sven Sauleau, Daniel Ehrenberg, Myles Borins, Dan Clark, Nicolò Ribaudo]
source_date: 2023-03-01
ingested: 2026-07-29
ingested_by: scholar
topics: [module-harmony, module-loader]
status: current
---

Abstract: What the proposal does and does not specify about attribute *meaning*, and the one semantic commitment that reaches into every module registry: **the module cache key is extended from `(referrer, specifier)` to `(referrer, specifier, attributes)`**. The core proposal assigns no behavior to any particular key or value: `type: "json"` gets its meaning from the separate JSON modules proposal, and future types (CSS, HTML) are expected to reuse the `type` key. Implementations are encouraged to **reject** attributes and type values they do not implement rather than ignore them, so that a future attribute can change a module's interpretation without breaking backward compatibility. The FAQ also settles the in-band versus out-of-band question as "why not both": import maps and Node.js policy files are welcome out-of-band metadata, and integrity hashes are named as metadata that *cannot* work in-band, because module cycles make them impossible to calculate and a deep-dependency change requires a cascading update. Attribute values are restricted to strings in the initial proposal, with richer values explicitly deferred to a follow-on.

## Proposed semantics and interoperability

This proposal does not specify behavior for any particular attribute key or value. The [JSON modules proposal](https://github.com/tc39/proposal-json-modules) specifies that `type: "json"` must be interpreted as a JSON module and specifies common semantics for doing so. The `type` attribute is expected to be leveraged for additional module types in future TC39 proposals as well as by hosts; HTML and CSS modules are under consideration and may use similar explicit `type` syntax when imported. Attributes other than `type` may also be introduced for purposes not yet foreseen.

> JavaScript implementations are encouraged to reject attributes and type values which are not implemented in their environment (rather than ignoring them). This is to allow for maximal flexibility in the design space in the future — in particular, it enables new import attributes to be defined which change the interpretation of a module, without breaking backwards-compatibility.

## The cache key

The FAQ answer is short and load-bearing for anyone implementing a module registry:

> Attributes are part of the module cache key and can affect how a module is loaded: the cache key is extended from *(referrer, specifier)* to *(referrer, specifier, attributes)*.

This was not always so. The Stage 2 consensus in June 2020 rested on the opposite restriction, that import attributes could **not** be part of the cache key in the module map; the restriction was relaxed in September 2020 so HTML could include module type in the cache key, and removed completely in the March 2023 return to Stage 3 (see the history section).

## In-band versus out-of-band metadata

The FAQ answer to "why not out of band?" is "why not both". The champions prefer in-band metadata for module *types* while welcoming out-of-band manifests for other purposes, naming [import maps](https://github.com/WICG/import-maps) (mapping module specifiers to URLs or paths) and [Node.js policy files](https://nodejs.org/api/policy.html) (integrity checks on modules) as good out-of-band mechanisms. The proposal does not argue that all metadata should be in band. Its worked counterexample:

> integrity hashes simply don't work in-band, both because module circularities make them impossible to calculate, and because of the need for a "cascading" update when a deep dependency changes.

Named downsides of out-of-band solutions, offered as tradeoffs rather than as fatal objections:

- **By-hand authoring experience.** An in-band solution is somewhat verbose but more straightforward to adopt without much tooling; small projects need no extra file.
- **Tooling complexity for large projects.** Developers do not have to compile a large manifest from the metadata of all their dependencies, and module authors do not have to ship a manifest for consumers to run their modules.
- **Performance tradeoffs.** Node.js experience with out-of-band policy files is that they can carry significant startup cost from loading and parsing.

## Cross-environment consistency

A central goal is to share as much syntax and behavior across JavaScript environments as possible, which is also why JSON modules are standardized to the extent possible (omitting only the contents of the redundant type check, which necessarily differs between environments, alongside the pre-existing host-defined parts such as specifier interpretation and fetching). At the same time the proposal expects the set of module types to differ across environments: WebAssembly, HTML, and CSS modules may not make sense in minimal embedded JavaScript environments. Compatibility management is held to be similar whether metadata is in band or out of band, since an out-of-band solution would face the same risk of inconsistent host support without coordination.

## Values are strings, for now

Two rejected or deferred generalizations:

- **A single terse string** (`import json from "./foo.json" as "json"`) was considered and not selected, because it implies that one particular attribute is special; even though this proposal only specifies `type`, the intention is to stay open to more attributes.
- **Richer values** (`with { attr: { key1: "value1", key2: [1, 2, 3] } }`) are omitted from the initial proposal, since a key/value list of strings already affords significant flexibility. The champions state they are open to a follow-on proposal providing that generalization.

Source: [proposal-import-attributes/README.md](https://github.com/tc39/proposal-import-attributes/blob/master/README.md) at content sha256 `f9ee63b0`. Stage 4; retrieved 2026-07-29.
