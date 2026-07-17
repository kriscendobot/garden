---
source_kind: web
source_url: https://parceljs.org/features/production/
source_content_sha256: 898c5ec725e710820c3be1085a524147253aa0146a511179e78ba3745f0ef6b0
source_fetched_via: direct
source_date: 2026-07-17
source_authors: [Parcel contributors]
ingested: 2026-07-17
ingested_by: scholar
section_count: 1
status: current
notes: "Parcel has no public docs git repository; canonical documentation is parceljs.org. Fetched direct via fetch-source.sh 2026-07-17; content sha256 898c5ec. Idempotency anchor is the content hash. Notable negative finding recorded in the section: this page does not document the `sideEffects` package.json field."
---

Abstract: Parcel's production documentation, the authoritative source for how Parcel tree-shakes and optimizes. It describes static import/export analysis (dead-code elimination across CommonJS and ES modules, static and dynamic `import()`, and CSS modules) and scope hoisting. Notably it does **not** document the `sideEffects` `package.json` field, correcting the earlier synthesis guess that grouped Parcel with webpack/esbuild as a documented `sideEffects` consumer. It backs the Parcel tree-shaking cell in the package-manifest consumer matrix.

| Section | Topics | Status |
|---------|--------|--------|
| [tree-shaking-and-scope-hoisting](../sections/web--parcel-production--tree-shaking-and-scope-hoisting.md) | package-manifest | current |

Source: [Parcel production](https://parceljs.org/features/production/) fetched 2026-07-17 (content sha256 `898c5ec`).
