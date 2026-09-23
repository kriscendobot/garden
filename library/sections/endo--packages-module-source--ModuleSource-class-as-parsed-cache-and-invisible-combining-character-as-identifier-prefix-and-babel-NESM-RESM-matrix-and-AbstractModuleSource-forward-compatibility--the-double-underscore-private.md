---
title: §The-`__double-underscore__`-private-names-convention
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
this.__syncModuleProgram__ = functorSource;
this.__liveExportMap__ = freeze(liveExportMap);
this.__reexportMap__ = freeze(reexportMap);
this.__fixedExportMap__ = freeze(fixedExportMap);
this.__needsImport__ = needsImport;
this.__needsImportMeta__ = needsImportMeta;
```

§Five-named-`__double-underscore__`-private-fields. §These-are-the-SES-Compartment-internal-contract — SES's compartment loader reads these fields to wire up the live + fixed + reexport behavior.

§Borrowable-pattern: §the-`__double-underscore__`-naming-convention as §an-explicit-but-not-language-enforced-private-field. §Different-from-the-`__HIDE_`-prefix (cycle 217 @endo/errors) which is the §censor-protocol; §the-`__double-underscore__`-fields-are-the-substrate-internal-contract.

§eslint-disable-no-underscore-dangle in the file header — the linter would normally complain. §The-comment-and-the-eslint-disable-explicitly-acknowledge-the-naming-deviation.
