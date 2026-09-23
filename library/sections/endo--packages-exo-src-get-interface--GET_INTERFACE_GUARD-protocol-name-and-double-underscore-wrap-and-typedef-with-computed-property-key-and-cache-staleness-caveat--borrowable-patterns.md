---
title: §Borrowable patterns
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
