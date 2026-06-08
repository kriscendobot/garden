---
title: "@endo/exo/src/get-interface.js — GET_INTERFACE_GUARD protocol name + double-underscore-wrap + typedef with computed property key + cache staleness caveat"
source-slug: endo--packages-exo-src-get-interface
source-url: https://github.com/endojs/endo/blob/master/packages/exo/src/get-interface.js
authors: [Endo Project Contributors]
repo: endojs/endo
path: packages/exo/src/get-interface.js
total-lines: 28
ingest-cycle: 239
ingest-date: 2026-06-08
lane: chat
---

# GET_INTERFACE_GUARD protocol name + double-underscore-wrap + typedef with computed property key + cache staleness caveat

[`@endo/exo/src/get-interface.js`](../sources/endo--packages-exo-src-get-interface.md) is a §28-line-file containing exactly two things: a §named-protocol-constant (`GET_INTERFACE_GUARD = '__getInterfaceGuard__'`) and a §typedef-with-computed-property-key (`GetInterfaceGuard<M>` typedef). This is the smallest file ingested in the library so far that still earns its keep — every line is structural.

## §The named protocol constant

```js
export const GET_INTERFACE_GUARD = '__getInterfaceGuard__';
```

§The-string-value-IS-the-protocol-name. §The-constant-name-is-the-developer-facing-handle + §the-string-value-is-the-wire-form-name. §When-a-meta-method-needs-a-well-known-name, §define-it-as-a-named-constant-not-a-string-literal-scattered-throughout-the-codebase.

§Double-underscore-wrap (`__getInterfaceGuard__`): §wrapped-with-double-underscores-on-both-sides + §the-convention-marks-the-name-as-meta-not-domain. §Sibling-pattern-to-`__getMethodNames__` (cited by name in the JSDoc comment: *Intended to be similar to `GET_METHOD_NAMES` from `@endo/pass-style`*). §The-CapTP-introspection-protocol-uses-double-underscore-wrap-for-meta-method-names. §Two-named-meta-methods-in-CapTP-introspection: §getMethodNames + §getInterfaceGuard.

§Four-different-underscore-or-hash-conventions in library now (cycle 217 `__HIDE_<name>` SES stack-trace single-prefix marker + cycle 223 `__name__` SES Compartment internal contract + cycle 235 `#name` JavaScript class-private + cycle 239 `__getInterfaceGuard__` CapTP introspection protocol). §Each-convention-has-a-different-substrate + §each-convention-has-a-different-purpose. §When-naming-conventions-overlap-in-syntax, §the-substrate-IS-the-disambiguator.

## §The PR-discussion link as named provenance

The JSDoc cites a specific PR discussion as the provenance of the design choice:

```text
See https://github.com/endojs/endo/pull/1809#discussion_r1388052454
```

§The-PR-discussion-link-IS-the-design-record-of-the-constant + §the-link-anchors-to-a-specific-discussion-id. §When-a-named-constant-resulted-from-a-PR-discussion, §link-to-the-discussion-by-id-not-just-the-PR-number. §Sibling-to-cycle-238's-Source-field-cites-the-PR-review-id (cycle 238 cited a PR review id in the design doc's metadata; cycle 239 cites a PR discussion id in the source code's JSDoc); §two-cycles-with-PR-discussion-link-as-named-provenance (cycles 238 + 239).

## §The cache staleness caveat as explicit warning

```text
Beware that an exo's interface can change across an upgrade,
so remotes that cache it can become stale.
```

§The-warning-IS-the-protocol-contract — §when-a-protocol-permits-caching, §the-protocol-MUST-name-the-staleness-condition-that-invalidates-the-cache. §The-`Beware`-prefix-marks-the-comment-as-an-actionable-warning-not-a-passive-note. §When-an-interface-can-change-across-upgrades, §the-cache-can-become-stale + §remotes-that-cache-it-must-handle-staleness; §the-protocol-doesn't-promise-stability + §the-protocol-names-the-instability-as-known.

§Sibling-to-cycle-235's-cache-the-traversal-context-by-source (cycle 235 was a single-source-shortest-path cache that's always fresh because the algorithm is deterministic; cycle 239 is a protocol cache that can become stale because the underlying state can change). §Two-different-cache-shapes: §deterministic-algorithm-cache (always fresh given inputs) + §protocol-state-cache (can become stale across upgrades).

## §The typedef with computed property key

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

## §Twenty-eight lines as a complete protocol artifact

This file does one thing exhaustively: it defines a meta-method name and its TypeScript shape. §Twenty-eight-lines-with-just-a-constant-and-a-typedef is §the-protocol-artifact-shape-not-the-implementation-shape; §the-implementation lives elsewhere (in `exo-makers.js` and `exo-tools.js`, both already ingested in earlier cycles).

§When-a-protocol-defines-a-named-meta-method, §the-meta-method's-name-and-shape-deserve-their-own-file + §separated-from-the-implementation. §Sibling-pattern-to-cycle-209's-pathCompare-as-edge-weight at the type level: §pathCompare-as-edge-weight is a usage convention; §GET_INTERFACE_GUARD-as-meta-method-name is a naming convention; both §carve-out-a-single-named-decision-from-the-rest-of-the-package.

## §Borrowable patterns

**Tier-1 (highest borrowing value):**

- §The-named-constant-string-IS-the-protocol-name (developer-facing handle + wire-form name).
- §Double-underscore-wrap (`__getInterfaceGuard__`) as CapTP introspection meta-method naming convention.
- §The-warning-IS-the-protocol-contract — when a protocol permits caching, the protocol MUST name the staleness condition.
- §The-`Beware`-prefix-marks-the-comment-as-an-actionable-warning-not-a-passive-note.
- §The-computed-property-key-uses-the-constant — the typedef uses the named constant as the property key, not a duplicate string literal.
- §Defense-by-construction-via-computed-property-key — the name and the type stay aligned by construction.
- §The-optional-property-marker on the meta-method (some exos have it, some do not).
- §The-PR-discussion-link-IS-the-design-record-of-the-constant — link to the discussion id, not just the PR.

**Tier-2 (TypeScript shape patterns):**

- §Template-with-constraint (`@template {Record<RemotableMethodName, CallableFunction>} M`).
- §Two-named-shapes-of-not-having-an-interface (method absent vs method present returning undefined).
- §Mapped-type-from-method-record-to-method-guard-record.
- §Inline-import-expressions-as-fallback-when-`@import`-isn't-set-up.

**Tier-3 (file-shape patterns):**

- §Twenty-eight-lines-as-a-complete-protocol-artifact — the protocol artifact shape, not the implementation shape.
- §Carve-out-a-single-named-decision-from-the-rest-of-the-package.

## §Synthesis target — slot machine library

For a slot machine library:

- §The-named-constant-string-IS-the-game-protocol-name (e.g., `GET_GAME_RULES_GUARD = '__getGameRulesGuard__'`).
- §Double-underscore-wrap for §game-engine-meta-method-naming-convention.
- §The-warning-IS-the-game-protocol-contract — when game rules can be updated across versions, name the staleness condition.
- §The-`Beware`-prefix-marks-actionable-warnings-in-game-rule-docs (not passive notes).
- §The-computed-property-key-uses-the-constant for §game-engine-meta-method-typedefs.
- §Defense-by-construction-via-computed-property-key — game-rule names and game-rule types stay aligned by construction.
- §The-optional-property-marker on meta-methods — some game engines expose introspection, some do not.
- §Template-with-constraint for §game-engine-method-record-types.
- §The-PR-discussion-link as named provenance for §game-engine-naming-decisions.
- §Twenty-eight-lines-as-a-complete-protocol-artifact for §game-engine-meta-method-name-files.

## §Library meta-counters

- §Library-reaches-745-sections at cycle 239 (chat-lane @endo/exo/src/get-interface).
- §Seventy-third-consecutive designs-chat alternation cycle (cycles 166-239).
- §Third-direct-ingest from `@endo/exo`'s `src/` (after `exo-makers.js` and `exo-tools.js`).
- §Thirty-seventh-member of §small-files-with-large-knowledge-density family.
- §Four-different-underscore-or-hash-conventions in library (cycles 217 + 223 + 235 + 239).
- §Two-named-meta-methods-in-CapTP-introspection (getMethodNames + getInterfaceGuard).
- §Two-cycles-with-PR-discussion-link-as-named-provenance (cycles 238 + 239) — first crossing of the source-code and design-doc shapes of this discipline.
- §Two-different-cache-shapes (deterministic-algorithm-cache cycle 235 + protocol-state-cache cycle 239).
- §First-explicit-observation of §double-underscore-wrap as CapTP introspection meta-method naming convention.
- §First-explicit-observation of §the-named-constant-string-IS-the-protocol-name.
- §First-explicit-observation of §defense-by-construction-via-computed-property-key.
- §First-explicit-observation of §the-warning-IS-the-protocol-contract (Beware-prefix as actionable-warning marker).

(Endo Project Contributors authored)
