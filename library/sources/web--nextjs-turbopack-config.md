---
source_kind: web
source_url: https://nextjs.org/docs/app/api-reference/config/next-config-js/turbopack
source_content_sha256: 871ded2b10f23cf96ecb9c22e7579818f2c9811593ccf3c4b3594bca6c4ec49d
source_fetched_via: direct
source_date: 2026-02-13
source_authors: [Vercel]
ingested: 2026-07-17
ingested_by: scholar
section_count: 1
status: current
notes: "Turbopack's user-facing configuration is documented as the Next.js `turbopack` option; this is the authoritative reference (Next.js 16.2.10, lastUpdated 2026-02-13). Fetched direct via fetch-source.sh 2026-07-17; content sha256 871ded2b. Idempotency anchor is the content hash. The public reference documents resolution *aliases/extensions/loader-conditions* but does not enumerate a package.json `exports` condition set or `mainFields` (recorded as a negative finding in the section)."
---

Abstract: The Next.js `turbopack` configuration reference, the authoritative user-facing source for how Turbopack resolves modules: `resolveAlias` (which supports Node-style conditional aliasing, but only the `browser` condition today), `resolveExtensions` (with its default extension list), and the loader-rule `condition` built-ins (`browser`, `foreign`, `development`, `production`, `node`, `edge-light`). It backs the Turbopack row in the package-manifest consumer matrix, including the honest limit that the public reference does not spell out Turbopack's `exports` condition precedence or `mainFields`.

| Section | Topics | Status |
|---------|--------|--------|
| [module-resolution-aliases-and-extensions](../sections/web--nextjs-turbopack-config--module-resolution-aliases-and-extensions.md) | package-manifest | current |

Source: [Next.js `turbopack` configuration](https://nextjs.org/docs/app/api-reference/config/next-config-js/turbopack) fetched 2026-07-17 (content sha256 `871ded2b`).
