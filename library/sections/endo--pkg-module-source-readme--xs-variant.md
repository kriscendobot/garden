---
title: XS Specific Variant
source: packages/module-source/README.md
source_repo: endojs/endo
source_commit: 53e5109e
source_date: 2024-05-08
source_authors: [Kris Kowal]
ingested: 2026-05-14
ingested_by: scholar
topics: [bundles, tooling]
status: current
---

> Abstract: A variant of ModuleSource for the XS JS engine (used by Agoric for embedded contexts). Notes the differences from the standard engine variant.

## XS Specific Variant

With the `xs` condition, `@endo/module-source` will not entrain Babel and will
just adapt the native `ModuleSource` to the older interface presented by this
package.
That is, the XS native `bindings` will be translated to `imports`, `exports`,
and `reexports` getters.
This form of `ModuleSource` ignores all options.


Source: [packages/module-source/README.md](https://github.com/endojs/endo/blob/53e5109e/packages/module-source/README.md) at commit `53e5109e`.
