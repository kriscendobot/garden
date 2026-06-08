---
title: "@endo/bundle-source — §format-dispatch-with-lazy-loading + §SHA-512-content-addressed-source-map-cache + §readPowers-pattern + §two-parser-defaults + §mutual-exclusion-noTransforms-and-elideComments"
source-slug: endo--packages-bundle-source
section-id: format-dispatch-with-lazy-loading-and-sha-512-content-addressed-source-map-cache-and-readPowers-pattern
url: https://github.com/endojs/endo/tree/master/packages/bundle-source
authors: [Endo contributors]
repo: endojs/endo
path: packages/bundle-source/src/{bundle-source.js,zip-base64.js,script.js,endo.js,fs.js,main.js,is-entrypoint.js,tool.js,index.js}
status: shipping
ingest-cycle: 221
ingest-date: 2026-06-08
lane: chat
---

# @endo/bundle-source — the canonical Endo bundler

`@endo/bundle-source` produces a hardened bundle (one of four named module formats) from a Node.js entry-point file. 913 source lines across 10 files plus types.ts. The library's central bundler — every Endo agent, weblet, and worker is bundled through this package. Imports from `@endo/compartment-mapper` (the heavy machinery) and is the §thin-dispatch-layer over that machinery.

## §Four-named-output-module-formats

```js
export const DEFAULT_MODULE_FORMAT = 'endoZipBase64';
export const SUPPORTED_FORMATS = [
  'getExport',        // legacy script form
  'nestedEvaluate',   // legacy script form with nested compartments
  'endoZipBase64',    // canonical archive form (zip + base64)
  'endoScript',       // single-script form
];
```

§Two-categories: §archive-form (endoZipBase64) + §three-script-forms (the rest). §The-default-is-endoZipBase64; §the-other-three-are-explicitly-named-as-legacy-or-script-shapes.

§Borrowable-pattern: §default-format-named-as-a-constant + §SUPPORTED_FORMATS-as-allow-list + §dispatch-switch-checks-SUPPORTED_FORMATS-in-the-default-case-to-distinguish-not-supported-from-not-implemented:

```js
default:
  if (!SUPPORTED_FORMATS.includes(moduleFormat)) {
    throw Error(`moduleFormat ${moduleFormat} is not supported`);
  }
  throw Error(
    `moduleFormat ${moduleFormat} is not implemented but is in ${SUPPORTED_FORMATS}`,
  );
```

§Two-distinct-error-messages-for-two-distinct-failure-modes:
1. §Not-supported (caller asked for something not in the list).
2. §Listed-but-not-implemented (caller asked for something promised but not delivered).

§Borrowable-pattern: §distinguish-not-supported-from-not-implemented-with-different-error-messages. §This-is-rare-and-honest: most libraries collapse both into one error; this design surfaces the §promised-but-missing case as a distinct bug.

## §Format-dispatch-with-lazy-loading

```js
switch (moduleFormat) {
  case 'endoZipBase64': {
    const { bundleZipBase64 } = await import('./zip-base64.js');
    return bundleZipBase64(startFilename, bundleOptions, powers);
  }
  case 'getExport':
  case 'nestedEvaluate':
  case 'endoScript': {
    const { bundleScript } = await import('./script.js');
    return bundleScript(startFilename, moduleFormat, bundleOptions, powers);
  }
  // ...
}
```

§Dynamic-import-per-format — the implementation modules are not loaded until the format is requested. §Two-named-implementation-modules ({./zip-base64.js, ./script.js}). §Three-formats-collapse-to-one-module (the three script forms all dispatch to bundleScript with the format passed through).

§Borrowable-pattern: §lazy-load-the-format-specific-implementation. §A-caller-that-only-uses-endoZipBase64-doesn't-pay-the-cost-of-loading-script.js (which would transitively load Babel via parsers). §Cost-paid-only-when-the-format-is-used.

§Sibling to cycle 200 worker-rust-xs (different mechanism, same §pay-only-for-what-you-use principle) and cycle 211 @endo/common (§tree-shaking-friendly via one-file-per-export).

## §The-shared-options-shape across formats

Both `bundleZipBase64` and `bundleScript` accept §the-same-six-named-options:

```js
const {
  dev = false,
  cacheSourceMaps = false,
  noTransforms = false,
  elideComments = false,
  conditions = [],
  commonDependencies,
} = options;
```

§Six-named-defaults — §dev (allow devDependencies) + §cacheSourceMaps (write source maps to cache) + §noTransforms (skip code transforms) + §elideComments (strip comments) + §conditions (package.json export conditions) + §commonDependencies (deduplicate shared dependencies).

§Borrowable-pattern: §shared-options-shape-across-multiple-public-entry-points (zipBase64 + script). §The-options-typedef-is-the-bridge-between-callers-and-the-six-feature-knobs.

## §Mutual-exclusion-noTransforms-and-elideComments

```js
if (noTransforms && elideComments) {
  throw new Error(
    'bundleSource endoZipBase64 cannot elideComments with noTransforms',
  );
}
```

§Two-options-are-incompatible — §named-explicitly-at-the-validation-gate. §The-error-message-names-both-options-and-the-format.

§Borrowable-pattern: §when-two-options-are-mutually-exclusive, §reject-at-the-validation-gate-with-an-error-message-naming-both-options. §Don't-silently-prefer-one — §fail-loud + §tell-the-user-which-two-they-set + §let-them-decide-which-one-they-meant.

## §readPowers-pattern via @endo/compartment-mapper

```js
const readPowers = makeReadPowers({ fs, url, crypto });
```

§Three-named-host-modules-bundled-as-powers (fs + url + crypto). §The-powers-shape-is-the-cross-cutting-API-surface: every function that needs to read files takes powers as a parameter.

```js
const powers = /** @type {typeof readPowers & SharedPowers} */ ({
  ...readPowers,
  ...grantedPowers,
});
```

§Spread-default-powers-then-spread-granted-powers — §later-spread-wins-on-collision. §The-caller-can-override-individual-powers (e.g., a custom fs implementation for testing or a sandboxed fs).

§Borrowable-pattern: §read-powers-as-a-bundled-capability-shape + §caller-can-override-individual-powers. §Sibling to cycles 196 endoclaw, 200 worker-rust-xs, 218 familiar-chat-weblet-hosting — all designs use §capability-shapes-as-the-parameter-passing-discipline.

## §SHA-512-content-addressed-source-map-cache

The most structurally novel move in this package. Source maps are §cached-by-SHA-512-of-content + §tracked-by-SHA-512-of-location. Two parallel directories:

- `<cache>/source-map/<sha512Head>/<sha512Tail>.map.json` — the source map content, addressed by content sha-512.
- `<cache>/source-map-track/<locationSha512Head>/<locationSha512Tail>` — the tracker file at location-sha-512 contains the current content-sha-512 for that location.

§Two-letter-prefix-sharding (using the first two chars of the sha-512) avoids one giant directory.

§The-cache-update-protocol:
1. Read the tracker file (if any) → §old-content-sha-512.
2. If old equals new, no-op (§the-content-already-cached).
3. Otherwise, §delete-the-old-source-map (and rmdir the directory if empty), then §write-the-new-source-map + §update-the-tracker.

§Borrowable-pattern: §content-addressed-cache-with-a-location-to-content-tracker. §The-tracker-IS-the-mutation-point + §the-cache-IS-the-immutable-store. §Sibling to cycle 200's §retention-path-notation (content-addressed file references) and cycle 203 cache-map (different shape — in-memory ring-buffer cache, but same §don't-establish-entry-until-prior-steps-succeed discipline).

§The-trickiest-part: §rmdir-the-old-source-map-directory-if-it-becomes-empty-after-deletion. §The-directory-sharding-means-old-files-leak-without-this-cleanup-step. §Borrowable-pattern: §directory-sharding-needs-an-empty-directory-cleanup-step (otherwise the cache leaks empty directories).

§The-tolerate-ENOENT pattern: `.catch(error => { if (error.code !== 'ENOENT') throw error; })`. §Borrowable-pattern: §the-first-time-the-cache-is-populated, §the-tracker-file-doesn't-exist-yet — §ignore-the-ENOENT + §don't-conflate-it-with-other-errors.

## §Two-parser-defaults from @endo/compartment-mapper

```js
import { defaultParserForLanguage as transformingParserForLanguage }
  from '@endo/compartment-mapper/archive-parsers.js';
import { defaultParserForLanguage as transparentParserForLanguage }
  from '@endo/compartment-mapper/import-parsers.js';
```

§Two-different-default-parser-tables-with-the-same-name-imported-with-aliases. §Borrowable-pattern: §the-import-aliases-encode-the-semantics:
- `transformingParserForLanguage` — for archive-mode bundling (parses + transforms).
- `transparentParserForLanguage` — for import-mode (parses without transforming).

§Two-different-parsers-for-two-different-use-cases. §The-archive-bundle-needs-static-analysis + §the-import-bundle-needs-direct-evaluation.

## §evadeCensor + §tsBlankSpace integration

```js
import { evadeCensor } from '@endo/evasive-transform';
import tsBlankSpace from 'ts-blank-space';
```

§Two-named-transforms loaded at module level — §cycle 205's @endo/evasive-transform (the SES-censorship-evasion) + §ts-blank-space (TypeScript stripping).

§Borrowable-pattern: §two-third-party-transform-libraries-bundled-into-the-default-transform-pipeline. §The-bundler-is-the-place-where-static-transforms-are-applied. §Sibling to cycle 205 evasive-transform's §SES-censorship-evasion (now consumed here).

## §Source-map-job-tracking via Set

```js
const sourceMapJobs = new Set();
// ... writeSourceMap pushes promises into sourceMapJobs ...
await Promise.all(sourceMapJobs);
```

§Async-fan-out-with-Set-tracking. §Each-source-map-write-is-a-promise-pushed-into-the-Set + §Promise.all-at-the-end-waits-for-all-writes-to-complete.

§Borrowable-pattern: §the-fire-and-collect-async-pattern — §don't-await-each-write-individually (would serialize); §collect-promises-into-a-set + §await-them-all-at-the-end.

§Sibling to cycle 199 trampoline (the §async-trampoline-as-a-cooperative-scheduler) and cycle 132 local.js (§Set-to-deduplicate). §Same Set-data-structure for two-different-purposes: deduplication vs fan-out-tracking.

## §endoZipBase64-output-shape

```js
return harden({
  moduleFormat: 'endoZipBase64',
  endoZipBase64,
  endoZipBase64Sha512: sha512,
});
```

§Three-named-fields:
1. §moduleFormat as the §discriminator-tag (the consumer dispatches on this).
2. §endoZipBase64 as the §content-string (base64-encoded zip).
3. §endoZipBase64Sha512 as the §integrity-hash for the unencoded bytes.

§Borrowable-pattern: §discriminator-tag + §content + §integrity-hash as the canonical bundle-output shape. §Sibling to cycle 200's §root-hash-printed-to-stderr (different layer, same §integrity-anchor discipline).

§Harden-the-output discipline.

## §workspaceLanguageForExtension three-flavor language detection

```js
const {
  parserForLanguage,
  workspaceLanguageForExtension,
  workspaceCommonjsLanguageForExtension,
  workspaceModuleLanguageForExtension,
} = makeBundlingKit(...);
```

§Three-named-language-detection-functions (workspace + workspace-commonjs + workspace-module). §Three-different-flavors-of-package-context affect how a file's extension maps to a language. §Borrowable-pattern: §the-extension-to-language-mapping-depends-on-the-package-type (CommonJS vs ESM vs workspace-default).

## §Implicit-thin-dispatch-layer pattern

@endo/bundle-source is mostly §dispatch-shape — §the-heavy-lifting-is-in-@endo/compartment-mapper. §The-public-API-surface (bundleSource(startFilename, options)) is §a-thin-dispatch-layer-over-the-machinery.

§Borrowable-pattern: §when-a-package-needs-a-friendly-public-surface-over-heavy-machinery, §the-package-is-a-thin-dispatch-layer-not-a-reimplementation. §The-thin-layer-knows-the-format-defaults + §the-feature-flags + §the-error-messages; §the-machinery-knows-the-substrate.

§Sibling to cycle 217 @endo/errors (§public-API-for-SES-assert — a thin layer over the SES substrate). §Two-different-packages-as-thin-dispatch-layers-over-heavier-substrate.

## Related material in the library

- **cycle 205 @endo/evasive-transform**: §SES-censorship-evasion sibling — directly consumed by this package.
- **cycle 7 @endo/base64**: §encodeBase64 sibling — directly consumed by this package for endoZipBase64.
- **cycle 217 @endo/errors**: §thin-dispatch-layer sibling.
- **cycle 200 worker-rust-xs**: §retention-path-notation sibling (content-addressed file references).
- **cycle 203 @endo/cache-map**: §don't-establish-entry-until-prior-steps-succeed sibling.
- **cycle 199 @endo/trampoline/memoize/nat**: §Set-data-structure-for-tracking-async-jobs sibling.
- **cycle 132 @endo/eventual-send local.js**: §Set-to-deduplicate sibling.
- **cycle 196 endoclaw + cycle 200 worker-rust-xs + cycle 218 familiar-chat-weblet-hosting**: §capability-shape-as-parameter-passing-discipline siblings.
- **cycle 220 familiar-localhttp-protocol**: §dispatch-via-protocol-handler sibling (cycle 220 is at the network layer; cycle 221 is at the module-format layer).
- **cycle 211 @endo/common**: §tree-shaking-friendly sibling (this package uses dynamic import for the same purpose).
- **cycle 215 @endo/hex**: §SHA-512-content-addressing sibling (different application — hex encodes bytes; bundle-source uses sha-512 for cache keys).

## §Library-reaches-727-sections at cycle 221 (chat-lane @endo/bundle-source).

## §Fifty-fifth consecutive designs-chat alternation cycles 166-221.

## §Twenty-ninth-member of §small-files-with-large-knowledge-density family (this is the dispatcher; the heavy machinery is elsewhere).
