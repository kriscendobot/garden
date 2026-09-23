---
title: §The-deep-freeze-of-everything
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
this.imports = freeze([...keys(imports)]);
this.exports = freeze([...].sort());
this.reexports = freeze([...exportAlls].sort());
// ...
for (const entry of values(liveExportMap)) {
  freeze(entry);
}
for (const entry of values(fixedExportMap)) {
  freeze(entry);
}
for (const reexports of values(reexportMap)) {
  for (const pair of reexports) {
    freeze(pair);
  }
  freeze(reexports);
}
this.__liveExportMap__ = freeze(liveExportMap);
this.__reexportMap__ = freeze(reexportMap);
this.__fixedExportMap__ = freeze(fixedExportMap);
// ...
freeze(this);
```

§Three-levels-of-freezing: §inner-entries + §map-values + §the-instance-itself. §Borrowable-pattern: §when-an-object-graph-must-be-immutable, §traverse-it-and-freeze-each-level-explicitly. §Object.freeze-is-shallow + §the-class-explicitly-traverses-the-Map-values-to-freeze-them.

§Sibling to cycle 217 @endo/errors' §harden-every-export (cycle 217 uses harden; cycle 223 uses Object.freeze because §it-must-load-before-SES-lockdown-allows-harden). §The-difference: §harden-is-deep-but-requires-SES-lockdown; §Object.freeze-is-shallow-but-works-pre-lockdown.

§Why-Object.freeze-and-not-harden — §honest-disclosure-of-load-order-constraint at the top of the file: `const freeze = Object.freeze;` with a cast comment `// Disable readonly markings.` §No-explicit-pre-lockdown-correctness-argument-in-this-file but §the-pattern-matches-the-sixth-member of the §freeze-not-harden-with-named-correctness-argument family (cycles 132 + 146 + 154 + 199 + 219 + 223).
