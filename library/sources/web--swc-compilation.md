---
source_kind: web
source_url: https://swc.rs/docs/configuration/compilation
source_content_sha256: 2981937c068e445230973ab42dc0a22a92b824c68ef2531165d2207636d5a045
source_fetched_via: direct
source_date: 2026-07-17
source_authors: [swc contributors]
ingested: 2026-07-17
ingested_by: scholar
section_count: 1
status: current
notes: "swc's canonical configuration documentation is the swc.rs site. Fetched direct via fetch-source.sh 2026-07-17; content sha256 2981937c. Idempotency anchor is the content hash. Ingested to confirm swc is a compiler/transformer, not a package.json resolver."
---

Abstract: swc's compilation-configuration reference, ingested to establish that swc is a compiler/transformer, not a module resolver: it reads its own `.swcrc` (`jsc`, `env`, `module`, `isModule`), does not resolve `package.json` `exports`/`main`/`module`/`browser`, and its `env.targets` accepts browserslist-style queries and browser-version maps without (per this page) reading the `package.json` `browserslist` field. It backs the swc row in the package-manifest consumer matrix (the compiler, not resolver, distinction).

| Section | Topics | Status |
|---------|--------|--------|
| [compiler-not-resolver-env-targets-and-module](../sections/web--swc-compilation--compiler-not-resolver-env-targets-and-module.md) | package-manifest | current |

Source: [swc compilation configuration](https://swc.rs/docs/configuration/compilation) fetched 2026-07-17 (content sha256 `2981937c`).
