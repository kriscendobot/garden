---
section: PASS_STYLE-symbol-typed-as-string-literal-and-confirmTagRecord-factory-for-object-vs-function-tag-records
source: endo--packages-pass-style-src-passStyle-helpers-js
topics: [pass-style]
status: current
title: PASS_STYLE symbol typed as string literal and confirmTagRecord factory for object-vs-function tag records
parent: endo--packages-pass-style-src-passStyle-helpers-js--PASS_STYLE-symbol-typed-as-string-literal-and-confirmTagRecord-factory-for-object-vs-function-tag-records
---

> *Typed as the string literal `'Symbol(passStyle)'` rather than
> as `unique symbol`, to keep the type nameable across module
> boundaries. The runtime value is still `Symbol.for('passStyle')`
> — JS computed property keys accept any value, so `obj[PASS_STYLE]`
> indexing is unchanged.*
>
> — `packages/pass-style/src/passStyle-helpers.js` §PASS_STYLE JSDoc

`passStyle-helpers.js` (212 lines, Turadg Aleahmad-last-touched
2026-04-15 in commit `c05c9a88` — newer than the
coordinated-update `e56bf00f` cluster) is the *foundational
helpers* file that other pass-style files import from. The
`PASS_STYLE` symbol export, the `confirmTagRecord` /
`confirmFunctionTagRecord` predicates, and the typedArray-brand-
check helper all originate here.
