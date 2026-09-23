---
title: Import Attributes — the rename and stage history, and why `assert` became `with`
source_kind: web
source_url: https://raw.githubusercontent.com/tc39/proposal-import-attributes/master/README.md
source_content_sha256: f9ee63b07ed212445afc977b380df504aacd38fa0e6eb3066d725f7cbf73b32f
source_authors: [Sven Sauleau, Daniel Ehrenberg, Myles Borins, Dan Clark, Nicolò Ribaudo]
source_date: 2023-03-01
ingested: 2026-07-29
ingested_by: scholar
topics: [module-harmony]
status: current
---

Abstract: The proposal's own dated history, which is the reason this feature appears in the wild under three names and two keywords. It was *Module Attributes* at Stage 1 (2019-12) and Stage 2 (2020-06), renamed *Import Assertions* at Stage 3 (2020-09) when the semantics were agreed to be assert-only and the keyword changed from `with` to `assert`, shipped in that `assert { type: "json" }` form in Chrome, Node.js, and Deno between 2021-05 and 2022-02, was **demoted back to Stage 2** in 2023-01 because assert-only semantics were incompatible with what HTML needs for non-JavaScript modules (specifically around HTTP fetching and Content-Security-Policy), and returned to Stage 3 in 2023-03 as *Import Attributes* with the keyword back to `with`, the cache-key restriction removed, and `assert` retained for compatibility with the already-shipped implementations. The proposal now records Stage 4. The practical consequence for any module-loading implementation: `assert` is a legacy spelling that may or may not ever be removed, and the semantic difference between the two eras is real, not cosmetic.

## The dated history, from the proposal

- **2019-12**: The proposal, named *module attributes*, is approved for Stage 1 to explore metadata for module imports and to explore guarantees about modules with no code execution.
- **2020-06**: *Module attributes* advances to Stage 2, "with consensus based on the restriction that import attributes cannot be part of the cache key in the modules map". The proposed syntax at that point was `import { x } from "./mod" with type: "json", something: "else";`.
- **2020-09**: The proposal, renamed to *import assertions*, advances to Stage 3. "The rename better describes the agreed assert-only semantics, and the keyword changes from `with` to `assert`." The caching restriction is relaxed so HTML can still include the module type as part of the cache key, "while still respecting the 'spirit' of the proposal".
- **2021-05 through 2022-02**: The proposal, with `import { x } from "./mod" assert { type: "json" };`, is implemented and shipped in Chrome, Node.js, and Deno, all of which support the JSON modules proposal.
- **2023-01**: Due to [incompatibility](https://github.com/whatwg/html/issues/7233) with the semantics HTML needs for non-JavaScript modules, specifically regarding HTTP fetching and CSPs, the proposal is **demoted back to Stage 2** to investigate a solution to the web platform's needs.
- **2023-03**: The proposal is renamed to *Import attributes* and moves back to Stage 3. "The restriction on the cache key is completely removed, and the keyword changes back from `assert` to `with`". For compatibility with existing implementations, "the `assert` keyword will still be supported until it's safe to remove it, if it will ever be."

The README's status line now reads **Stage 4**.

## The syntax forms that were considered and dropped

From the (collapsed) pre-Stage-2 and pre-Stage-3 plan in the README, the alternatives that lost:

```mjs
// Not selected
import value from "module" as "json";

// Not selected
import value from "module" with type: "json";

// Approved from Stage 2 to Stage 3 the first time
import value from "module" assert { type: "json" };
```

Keyword alternatives to `with`/`assert` were also floated before Stage 3 (`when { type: 'json' }`, `given { type: 'json' }`). For dynamic import the nesting was debated: dropping the inner key to give `import("foo.wasm", { type: "webassembly" })` is not possible, because the `Worker` API already uses an object with a `type` key as its second parameter, which would make the two APIs inconsistent.

## What remained for Stage 4

The README's pre-Stage-4 list is host integration rather than language design: how import attributes are enabled when launching a worker, and how they are included in a `<script>` tag. That standardization requires consensus not only in TC39 but also in WHATWG HTML and the Node.js ESM effort, plus a general audit of semantic requirements across host environments.

Source: [proposal-import-attributes/README.md](https://github.com/tc39/proposal-import-attributes/blob/master/README.md) at content sha256 `f9ee63b0`. Stage 4; retrieved 2026-07-29.
