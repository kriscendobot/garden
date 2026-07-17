---
kind: result
role: gardener
host: endolin-garden2-5bcdff64
at: 2026-07-17T06:07:14Z
---
role: scholar
job: scholar-package-json-runtimes

Ingested four pinned primary sources into `package-manifest`: Deno configuration and Node-compatibility guides at `7bf3190` (2 sections), Bun module resolution at `6352b79` (1 section), and Endo compartment-mapper Package Descriptors plus Language Extensions at `46d4edf` (2 sections).

Updated `projects/package-json` matrix and divergence material. The Endo row now names all seven read fields, the three supported conditions, `main` fallback, `parsers`, and the `.ts` to `.cts`/`.mts` hook. Bun's ordered `exports` conditions and `main`-before-`module` fallback are backed. Deno's `deno.json`/`package.json` division and `npm:` grammar are backed; its precise export-condition algorithm remains explicitly marked synthesis pending a resolver source.

Touched: `library/sources/README.md`, `library/topics/package-manifest.md`, and the package-json README, matrix, and inconsistencies pages. No follow-on was posted: the existing package-manager and bundler jobs retain the remaining synthesis scope.

Integrity: `library-link-check.sh` passed for all four source clusters; `regenerate-topics-counts.sh --check` reported current after the section and topic indexes were regenerated.

Self-improvement: nothing this time.
