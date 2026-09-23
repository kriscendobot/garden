---
title: §The typedef with computed property key
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
/**
 * @template {Record<RemotableMethodName, CallableFunction>} M
 * @typedef {{
 *   [GET_INTERFACE_GUARD]?: () =>
 *     import('@endo/patterns').InterfaceGuard<{
 *       [K in keyof M]: import('@endo/patterns').MethodGuard
 *     }> | undefined
 * }} GetInterfaceGuard
 */
```

Multiple structural moves in nine lines:

1. **§Template-with-constraint**: `@template {Record<RemotableMethodName, CallableFunction>} M` — `M` is constrained to be a record of remotable methods. §The-constraint-names-the-shape-of-the-input + §the-constraint-IS-the-precondition-on-the-typedef. §Sibling-to-cycle-237's `@template T The type of the values to compare` (both are template-with-constraint).
2. **§The-computed-property-key-uses-the-constant**: `[GET_INTERFACE_GUARD]?:` — §the-named-constant-becomes-the-property-key-in-the-typedef + §the-source-of-truth-for-the-name-IS-the-constant-not-a-second-string-literal. §When-the-protocol-defines-a-meta-method-name, §the-typedef-MUST-use-the-constant-as-the-computed-property-key-not-duplicate-the-string + §this-keeps-the-name-and-the-type-aligned-by-construction. §Defense-by-construction-via-computed-property-key (sibling to cycle 237's defense-by-construction-via-step-ordering).
3. **§The-optional-property-marker `?`**: §the-meta-method-is-optional-on-the-exo + §some-exos-have-an-interface-guard-some-do-not. §When-a-meta-method-is-optional-per-instance, §the-typedef-MUST-mark-the-property-optional.
4. **§The-return-type-is-a-function**: `() => InterfaceGuard<...> | undefined` — §the-meta-method-is-callable-not-a-data-field + §the-return-can-be-undefined. §Two-named-shapes-of-not-having-an-interface: §the-method-itself-is-absent (the optional property) + §the-method-is-present-but-returns-undefined. §The-two-shapes-are-semantically-distinct.
5. **§The-InterfaceGuard-is-itself-parameterized**: `InterfaceGuard<{ [K in keyof M]: MethodGuard }>` — §a-mapped-type-from-each-method-to-its-guard + §the-type-derives-from-the-method-record. §Mapped-type-as-named-shape: §from-method-record-to-method-guard-record.
6. **§@import-via-inline-import-expressions**: `import('@endo/patterns').InterfaceGuard` is inline rather than via `@import` at the top. §Inline-import-expressions-are-the-fallback-when-the-typedef-references-multiple-types-from-the-same-module-but-the-top-of-file-`@import`-tag-isn't-set-up. §The-CLAUDE.md-prefers-`@import`-at-the-top — this file's choice of inline-import suggests §the-typedef-was-authored-before-the-`@import`-convention-was-established + §retrofit-pending.
