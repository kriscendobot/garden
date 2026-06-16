---
title: §The named protocol constant
source-slug: endo--packages-exo-src-get-interface
source-url: https://github.com/endojs/endo/blob/master/packages/exo/src/get-interface.js
authors: [Endo Project Contributors]
repo: endojs/endo
path: packages/exo/src/get-interface.js
total-lines: 28
ingest-cycle: 239
ingest-date: 2026-06-08
lane: chat
parent: endo--packages-exo-src-get-interface--GET_INTERFACE_GUARD-protocol-name-and-double-underscore-wrap-and-typedef-with-computed-property-key-and-cache-staleness-caveat
---

```js
export const GET_INTERFACE_GUARD = '__getInterfaceGuard__';
```

§The-string-value-IS-the-protocol-name. §The-constant-name-is-the-developer-facing-handle + §the-string-value-is-the-wire-form-name. §When-a-meta-method-needs-a-well-known-name, §define-it-as-a-named-constant-not-a-string-literal-scattered-throughout-the-codebase.

§Double-underscore-wrap (`__getInterfaceGuard__`): §wrapped-with-double-underscores-on-both-sides + §the-convention-marks-the-name-as-meta-not-domain. §Sibling-pattern-to-`__getMethodNames__` (cited by name in the JSDoc comment: *Intended to be similar to `GET_METHOD_NAMES` from `@endo/pass-style`*). §The-CapTP-introspection-protocol-uses-double-underscore-wrap-for-meta-method-names. §Two-named-meta-methods-in-CapTP-introspection: §getMethodNames + §getInterfaceGuard.

§Four-different-underscore-or-hash-conventions in library now (cycle 217 `__HIDE_<name>` SES stack-trace single-prefix marker + cycle 223 `__name__` SES Compartment internal contract + cycle 235 `#name` JavaScript class-private + cycle 239 `__getInterfaceGuard__` CapTP introspection protocol). §Each-convention-has-a-different-substrate + §each-convention-has-a-different-purpose. §When-naming-conventions-overlap-in-syntax, §the-substrate-IS-the-disambiguator.
