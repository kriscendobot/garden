---
source_kind: web
source_url: https://esbuild.github.io/api/
source_content_sha256: 2c986ac415f99cc403a5af6de4962ef94d76daba20f7b560dec3edfd6b563dfc
source_fetched_via: direct
source_date: 2026-07-17
source_authors: [Evan Wallace]
ingested: 2026-07-17
ingested_by: scholar
section_count: 2
status: current
notes: "esbuild has no separate public docs repository; the canonical documentation is the single-page https://esbuild.github.io/api/. Fetched direct via fetch-source.sh 2026-07-17; content sha256 2c986ac. Idempotency anchor is the content hash, not a git commit; re-fetch and compare the hash to refresh."
---

Abstract: esbuild's single-page API documentation, the authoritative source for how esbuild consumes `package.json`: platform-derived `exports` conditions (including the bundler `module` condition), platform-dependent `mainFields`, the `--packages=external` dependency-externalization flag, and its tree-shaking plus `sideEffects`/`@__PURE__` annotation handling. It backs the esbuild row in the package-manifest consumer matrix.

| Section | Topics | Status |
|---------|--------|--------|
| [conditions-main-fields-and-packages](../sections/web--esbuild-api--conditions-main-fields-and-packages.md) | package-manifest | current |
| [tree-shaking-and-sideeffects](../sections/web--esbuild-api--tree-shaking-and-sideeffects.md) | package-manifest | current |

Source: [esbuild API documentation](https://esbuild.github.io/api/) fetched 2026-07-17 (content sha256 `2c986ac`).
