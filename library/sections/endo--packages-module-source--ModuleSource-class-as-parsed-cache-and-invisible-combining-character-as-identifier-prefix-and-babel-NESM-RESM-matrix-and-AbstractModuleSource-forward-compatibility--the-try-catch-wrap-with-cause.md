---
title: §The-try-catch-wrap-with-cause pattern (transform-analyze.js)
source-slug: endo--packages-module-source
section-id: ModuleSource-class-as-parsed-cache-and-invisible-combining-character-as-identifier-prefix-and-babel-NESM-RESM-matrix-and-AbstractModuleSource-forward-compatibility
url: https://github.com/endojs/endo/tree/master/packages/module-source
authors: [Endo contributors]
repo: endojs/endo
path: packages/module-source/src/{module-source.js, transform-analyze.js, transform-source.js, babel-plugin.js, parse-babel.js, hidden.js}
status: shipping
ingest-cycle: 223
ingest-date: 2026-06-08
lane: chat
parent: endo--packages-module-source--ModuleSource-class-as-parsed-cache-and-invisible-combining-character-as-identifier-prefix-and-babel-NESM-RESM-matrix-and-AbstractModuleSource-forward-compatibility
---

```js
let scriptSource;
try {
  scriptSource = transformSource(moduleSource, sourceOptions);
} catch (err) {
  const moduleLocation = sourceUrl
    ? JSON.stringify(sourceUrl)
    : '<unknown>';
  throw SyntaxError(
    `Error transforming source in ${moduleLocation}: ${err.message}`,
    { cause: err },
  );
}
```

§The-Error-`cause`-option (ES2022) preserves the original error while adding context. §Borrowable-pattern: §wrap-the-error-with-location-context + §preserve-the-original-via-`cause`. §The-caller-can-still-walk-the-cause-chain to inspect the underlying Babel parse error.

§Sibling to cycle 215 @endo/hex's §native-error-rerun-polyfill-for-better-diagnostic — both designs §add-context-to-an-error-from-a-deeper-layer; cycle 215 reruns the polyfill; cycle 223 wraps with cause.

§JSON.stringify(sourceUrl)-or-`<unknown>` — §safe-quoting-with-fallback (the URL is JSON-escaped to avoid breaking the error message).
