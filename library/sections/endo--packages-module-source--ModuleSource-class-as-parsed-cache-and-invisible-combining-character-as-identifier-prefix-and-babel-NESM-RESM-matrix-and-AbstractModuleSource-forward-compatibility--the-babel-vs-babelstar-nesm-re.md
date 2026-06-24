---
title: §The-babel-vs-babelStar-NESM-RESM matrix as opening comment
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
// If all ESM implementations were correct, it would be sufficient to
// `import babel` instead of `import * as babel`.
// However, the `node -r esm` emulation of ESM produces a linker error,
// claiming there is no export named default.
// Also, the behavior of `import * as babel` changes from Node.js 14 to 16.
// Node.js 14 produces an extraneous { default } wrapper around the exports
// namespace and 16 introduces lexical static analysis of exported names, so
// comes closer to correct, and at least consistent with `node -r esm`.
//
// Node.js 14:
//   NESM:
//     babel:     exports
//     babelStar: { default: exports }
//   RESM:
//     babel:     linker error: no export named default
//     babelStar: exports
// Node.js 16:
//   NESM:
//     babel:     exports
//     babelStar: exports + trash
//   RESM:
//     babel:     linker error: no export named default
//     babelStar: exports
```

§Four-by-two-matrix-encoded-as-comment: §two-Node-versions × §two-ESM-emulators × §two-import-forms. §The-comment-maps-each-cell-to-its-observed-behavior. §Honest-acknowledgment-of-platform-quirks.

§Five-different-runtime-version-or-environment-compat-hacks-and-disclosures family now (cycles 199 + 205 + 213 + 217 + 223):

| Cycle | Source | Compat hack or disclosure |
| --- | --- | --- |
| 199 | @endo/nat | Apps-Script bigint-literal-workaround |
| 205 | @endo/evasive-transform | Babel-traverse default-import-workaround |
| 213 | @endo/stream-node | Node-14 unhandled-error-race-defense |
| 217 | @endo/errors | Pre-1.13.0 SES Agoric-bootstrap-vat tolerance |
| 223 | @endo/module-source | Node 14 vs 16 vs `node -r esm` babel-default-export matrix |

§Five-named-runtime-environment-issues. §The-pattern-evolves: cycle 199's nat says "this trick"; cycle 205 explains the workaround; cycle 213 names the race; cycle 217 names the bootstrap vat; cycle 223 gives a 4-cell matrix. §The-honest-disclosure-discipline-deepens-cycle-by-cycle.
