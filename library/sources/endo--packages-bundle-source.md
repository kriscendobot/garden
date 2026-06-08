---
title: "@endo/bundle-source — Canonical Endo bundler: format-dispatch with lazy-loading + SHA-512 content-addressed source-map cache + readPowers pattern"
source-slug: endo--packages-bundle-source
url: https://github.com/endojs/endo/tree/master/packages/bundle-source
authors: [Endo contributors]
repo: endojs/endo
path: packages/bundle-source
total-lines: 913 source (across 10 files) + types.ts
status: shipping
ingest-cycle: 221
ingest-date: 2026-06-08
lane: chat
---

# @endo/bundle-source

Produces a hardened bundle (one of four named module formats) from a Node.js entry-point file. The library's central bundler — every Endo agent, weblet, and worker is bundled through this package. The §thin-dispatch-layer over the heavy machinery of @endo/compartment-mapper.

## Key design moves

- **§Four-named-output-module-formats** (endoZipBase64 default + getExport + nestedEvaluate + endoScript) with §two-categories (archive-form vs three-script-forms).
- **§Format-dispatch-with-lazy-loading** via dynamic import per format; §pay-only-for-what-you-use.
- **§Two-distinct-error-messages-for-two-distinct-failure-modes** — §distinguish-not-supported-from-not-implemented (rare and honest).
- **§Mutual-exclusion-noTransforms-and-elideComments** rejected at the validation gate with an error naming both.
- **§readPowers-pattern** via @endo/compartment-mapper with §three-named-host-modules (fs + url + crypto); §spread-default-powers-then-spread-granted-powers — §later-spread-wins-on-collision.
- **§Six-named-options-shared-across-formats**: dev + cacheSourceMaps + noTransforms + elideComments + conditions + commonDependencies.
- **§SHA-512-content-addressed-source-map-cache** with §two-directory-structure (source-map content addressed by content-sha + source-map-track tracker addressed by location-sha) + §two-letter-prefix-sharding + §empty-directory-cleanup-step + §tolerate-ENOENT-on-first-write.
- **§Two-parser-defaults** with named-aliases (transformingParserForLanguage vs transparentParserForLanguage) — §the-import-aliases-encode-the-semantics.
- **§evadeCensor + tsBlankSpace integration** as the default transform pipeline.
- **§Async-fan-out-with-Set-tracking** (sourceMapJobs Set + Promise.all at the end).
- **§endoZipBase64-output-shape** = §discriminator-tag + §content + §integrity-hash as canonical bundle output.
- **§Three-flavor language detection** (workspace + workspace-commonjs + workspace-module).
- **§Thin-dispatch-layer over heavy machinery** — sibling to cycle 217 @endo/errors as a thin layer over SES.

## Section files

- [§format-dispatch-with-lazy-loading + §SHA-512-content-addressed-source-map-cache + §readPowers-pattern + §two-parser-defaults + §mutual-exclusion-noTransforms-and-elideComments](../sections/endo--packages-bundle-source--format-dispatch-with-lazy-loading-and-sha-512-content-addressed-source-map-cache-and-readPowers-pattern.md) — full source ingest covering bundle-source.js + zip-base64.js + script.js + endo.js + README.

## Ingest scope

Cycle 221 (chat-lane): ingest of the dispatcher + zipBase64-implementation + script-implementation + bundling-kit-factory as one section. §The-thin-dispatch-layer is well-named here; heavy machinery in @endo/compartment-mapper is referenced but not duplicated.
