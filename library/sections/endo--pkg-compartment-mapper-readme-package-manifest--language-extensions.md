---
title: Endo language extensions and package parsers
source: packages/compartment-mapper/README.md#language-extensions
source_repo: endojs/endo
source_commit: 46d4edf31714c1488ec1d95492cc1ae9643c1f9f
ingested: 2026-07-17
ingested_by: scholar
topics: [package-manifest, bundles, compartments]
status: current
---

> Abstract: Compartment-mapper's language mechanism maps extensions to built-in or supplied parsers, and lets a package's `parsers` manifest property override that map. Module-type-specific hooks can route `.ts` to `.mts` or `.cts` semantics.

The default language identifiers are `mjs`, `cjs`, `json`, `text`, `bytes`, `pre-mjs-json`, and `pre-cjs-json`. `parserForLanguage` extends that set; the identifiers key transform maps and are the values selected by `languageForExtension`, `moduleLanguageForExtension`, and `commonjsLanguageForExtension`.

For a package whose `type` is `module`, `moduleLanguageForExtension` precedes the generic hook. For `commonjs` or an unset type, `commonjsLanguageForExtension` precedes it. This is the documented hook for mapping TypeScript `.ts` to either `.mts` or `.cts`. Workspace-specific variants apply outside `node_modules`. Finally, the package-local `parsers` property overrides extension-to-language mapping, such as `{ "parsers": { "png": "bytes" } }`.

Source: [packages/compartment-mapper/README.md](https://github.com/endojs/endo/blob/46d4edf31714c1488ec1d95492cc1ae9643c1f9f/packages/compartment-mapper/README.md) at commit `46d4edf`.
