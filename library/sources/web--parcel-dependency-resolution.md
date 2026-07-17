---
source_kind: web
source_url: https://parceljs.org/features/dependency-resolution/
source_content_sha256: ce144ef07d01dec77197f513b11f469647f61d07f3d903dc2c859b73dae526a4
source_fetched_via: direct
source_date: 2026-07-17
source_authors: [Parcel contributors]
ingested: 2026-07-17
ingested_by: scholar
section_count: 2
status: current
notes: "Parcel has no public docs git repository; the canonical documentation is the parceljs.org site. Fetched direct via fetch-source.sh 2026-07-17; content sha256 ce144ef. Idempotency anchor is the content hash, not a git commit; re-fetch and compare the hash to refresh."
---

Abstract: Parcel's dependency-resolution documentation, the authoritative source for how Parcel reads `package.json` to resolve a dependency: the package-entry precedence chain (`source` → `exports` → `browser` → `module` → `main`), the opt-in `exports` field with its condition set (enabled via the `packageExports` resolver flag), the `#`-prefixed `imports` field, the `browser` substitution field, and Parcel's own `alias` and `source` manifest fields plus its specifier grammar. It backs the Parcel resolution half of the Parcel row in the package-manifest consumer matrix.

| Section | Topics | Status |
|---------|--------|--------|
| [entries-order-exports-and-conditions](../sections/web--parcel-dependency-resolution--entries-order-exports-and-conditions.md) | package-manifest | current |
| [aliases-source-field-and-specifiers](../sections/web--parcel-dependency-resolution--aliases-source-field-and-specifiers.md) | package-manifest | current |

Source: [Parcel dependency resolution](https://parceljs.org/features/dependency-resolution/) fetched 2026-07-17 (content sha256 `ce144ef`).
