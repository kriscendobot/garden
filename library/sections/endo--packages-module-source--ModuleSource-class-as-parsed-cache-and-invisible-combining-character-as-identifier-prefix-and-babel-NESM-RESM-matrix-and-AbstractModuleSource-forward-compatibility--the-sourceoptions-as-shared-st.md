---
title: §The-`sourceOptions`-as-shared-state-bag pattern (transform-analyze.js)
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
const sourceOptions = {
  sourceUrl, sourceMap, sourceMapUrl, sourceMapHook,
  sourceType: 'module',
  fixedExportMap: Object.create(null),
  imports: Object.create(null),
  exportAlls: [],
  reexportMap: Object.create(null),
  liveExportMap: Object.create(null),
  hoistedDecls: [],
  importSources: Object.create(null),
  importDecls: [],
  dynamicImport: { present: false },
  importMeta: { present: false },
};
```

§The-collection-bag-pattern: §a-single-object-passed-to-the-babel-plugin holds §every-collection-the-plugin-populates. §The-Babel-plugin-mutates-this-object-during-traversal + §the-caller-reads-it-after.

§§Object.create(null)-for-prototype-free-maps — §the-imports-and-export-maps-have-no-prototype-chain-so-they-can't-have-collisions-with-Object.prototype-methods (e.g., a module exporting `'toString'` would otherwise collide).

§Borrowable-pattern: §Object.create(null)-for-string-keyed-maps where the keys come from untrusted source. §Sibling to cycle 217 @endo/errors' §destructure-with-underscore-prefix-to-deliberately-discard — both designs §defensive-shape-against-prototype-pollution.

§Ten-named-fields collected during traversal. §Each-field-is-a-different-shape (sets / objects / arrays / single-value-with-`present`-flag).

### §The-`{ present: false }` pattern

```js
dynamicImport: { present: false },
importMeta: { present: false },
```

§A-mutable-boolean-flag-wrapped-in-an-object. §Borrowable-pattern: §when-a-callee-needs-to-mutate-a-boolean-from-deep-inside-a-traversal, §wrap-it-in-an-object-so-the-mutation-is-visible-at-the-caller. §JavaScript-doesn't-have-out-parameters; §an-object-with-a-mutable-field-IS-the-out-parameter.

§The-pattern-is-explicit: not `dynamicImport: false` (which can't be mutated through the reference) but `dynamicImport: { present: false }` (where `dynamicImport.present = true` is visible).
