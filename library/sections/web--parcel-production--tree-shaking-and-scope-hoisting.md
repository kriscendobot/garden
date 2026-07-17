---
title: Parcel tree shaking and scope hoisting
source_kind: web
source_url: https://parceljs.org/features/production/
source_content_sha256: 898c5ec725e710820c3be1085a524147253aa0146a511179e78ba3745f0ef6b0
source_fetched_via: direct
source_date: 2026-07-17
source_authors: [Parcel contributors]
ingested: 2026-07-17
ingested_by: scholar
topics: [package-manifest]
status: current
---

> Abstract: Parcel's documented production optimization is static import/export analysis (tree shaking / dead-code elimination) plus scope hoisting, applied to both CommonJS and ES modules and across static and dynamic `import()`. Unlike webpack and esbuild, **Parcel's production documentation does not mention the `sideEffects` `package.json` field** — neither the `false` whole-module form nor the array-of-globs form. This is a faithful negative finding: the earlier matrix synthesis that listed Parcel under `sideEffects` alongside webpack/esbuild is not backed by this authoritative page.

**Tree shaking.** "Parcel statically analyzes the imports and exports of each module, and removes everything that isn't used. This is called 'tree shaking' or 'dead code elimination'." It is "supported for both static and dynamic `import()`, CommonJS and ES modules, and even across languages with CSS modules."

**Scope hoisting.** "Parcel also concatenates modules into a single scope when possible, rather than wrapping each module in a separate function. This is called 'scope hoisting'. This helps make minification more effective, and also improves runtime performance by making references between modules static rather than dynamic object lookups."

**The `sideEffects` field — not documented here.** This production page does not describe reading the `package.json` `sideEffects` field. Parcel's tree shaking is presented as whole-program static analysis rather than a `sideEffects`-annotation-driven prune. (Parcel's source may honor `sideEffects` in practice, but the authoritative public docs ingested here do not document it, so the consumer matrix marks Parcel's `sideEffects` cell as *not documented* rather than a grounded yes.)

Source: [Parcel production](https://parceljs.org/features/production/) fetched 2026-07-17 (content sha256 `898c5ec`), sections *Tree shaking* and *Scope hoisting*.
