---
title: §workspaceLanguageForExtension three-flavor language detection
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
parent: endo--packages-bundle-source--format-dispatch-with-lazy-loading-and-sha-512-content-addressed-source-map-cache-and-readPowers-pattern
---

```js
const {
  parserForLanguage,
  workspaceLanguageForExtension,
  workspaceCommonjsLanguageForExtension,
  workspaceModuleLanguageForExtension,
} = makeBundlingKit(...);
```

§Three-named-language-detection-functions (workspace + workspace-commonjs + workspace-module). §Three-different-flavors-of-package-context affect how a file's extension maps to a language. §Borrowable-pattern: §the-extension-to-language-mapping-depends-on-the-package-type (CommonJS vs ESM vs workspace-default).
