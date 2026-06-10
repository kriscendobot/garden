---
title: "@endo/import-bundle/src/{source-map-node,source-map-node-powers}.js — the platform-bound bootstrap + powers-injected factory pair"
source-slug: endo--packages-import-bundle-src-source-map-node-pair
url: https://github.com/endojs/endo/blob/master/packages/import-bundle/src/source-map-node.js
authors: [Endo project (collective)]
repo: endojs/endo
path: packages/import-bundle/src/source-map-node.js + source-map-node-powers.js
total-lines: 45 (10 + 35)
ingest-cycle: 276
ingest-date: 2026-06-10
lane: chat
---

# `@endo/import-bundle/src/{source-map-node,source-map-node-powers}.js`

**45 lines total** across two files: an 11-line **platform-bound bootstrap** + a 35-line **powers-injected factory**. The pair instantiates a named platform-binding pattern.

## Key moves

- **§The platform-bound bootstrap plus powers-injected factory pair as named discipline** — when a module needs Node-platform bindings, a thin Node bootstrap imports the platform modules and passes them as powers to a platform-agnostic factory.
- **§The thin Node bootstrap IS only three things** — named platform imports + global process via eslint comment + single call to factory.
- **§The `node:` URL scheme import as named Node built-in discipline** — `node:url` and `node:os` not `url` and `os`; the `node:` prefix IS the explicit marker.
- **§Three cycles with named eslint directive as acknowledged platform binding** (245 + 254 + 276) — `/* global process */`.
- **§The powers-injection pattern with typed typedef for each power** — `@param {object} powers` with three typed properties.
- **§Minimal platform typedef with only the fields the module needs** — `Process` typedef has only `env` and `platform`, not the full Node Process type; §principle-of-least-authority-applied-to-types.
- **§The `Record<string, string | undefined>` type acknowledges that env vars can be undefined**.
- **§sha512-sharded cache with two-character prefix and remaining tail** — the first two characters of the hash IS the directory shard; the remaining characters IS the filename; sibling-pattern to git's loose-object storage.
- **§The cluster uses named different hash sizes for different content-addressed storage uses** — SHA-256 cycle 275 (blob storage) + SHA-512 cycle 276 (source-map cache).
- **§Nested powers injection as named discipline** — `whereEndoCache(platform, env, {home})` is the cluster helper that takes its own powers; the authority flows through each layer with no implicit access.
- **§The `url.pathToFileURL` conversion IS named cross-platform discipline** — convert platform-specific path to platform-agnostic file URL at the boundary; URL form thereafter.
- **§The make-X-locator pattern** — `makeEndoSourceMapLocator(powers)` returns a `whereSourceMap(details)` closure; the `make-` and `where-` prefixes are the cluster's canonical naming.

## Section files

- [§Platform-bound bootstrap plus powers-injected factory pair + §sha512-sharded cache with two-character prefix + §minimal platform typedef](../sections/endo--packages-import-bundle-src-source-map-node-pair--platform-bound-bootstrap-plus-powers-injected-factory-pair-and-sha512-sharded-cache-with-two-character-prefix-and-minimal-platform-typedef.md) — full 45-line pair in scope.

## Ingest scope

Cycle 276 (chat-lane after cycle 275's designs-lane daemon-weblet-application). Full 45-line pair ingested. **First-explicit-observations (eleven)**: the-platform-bound-bootstrap-plus-powers-injected-factory-pair-as-named-discipline + the-thin-Node-bootstrap-IS-only-three-things + the-`node:`-URL-scheme-import-as-named-Node-built-in-discipline + the-powers-injection-pattern-with-typed-typedef-for-each-power + minimal-platform-typedef-with-only-the-fields-the-module-needs + sha512-sharded-cache-with-two-character-prefix-and-remaining-tail + the-cluster-uses-named-different-hash-sizes-for-different-content-addressed-storage-uses + nested-powers-injection-as-named-discipline + the-url.pathToFileURL-conversion-IS-named-cross-platform-discipline + the-make-X-locator-pattern + three-cycles-with-named-eslint-directive-as-acknowledged-platform-binding (245 + 254 + 276).
