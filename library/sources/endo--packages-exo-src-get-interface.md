---
title: "@endo/exo/src/get-interface.js — GET_INTERFACE_GUARD meta-method name + typedef"
source-slug: endo--packages-exo-src-get-interface
url: https://github.com/endojs/endo/blob/master/packages/exo/src/get-interface.js
authors: [Endo Project Contributors]
repo: endojs/endo
path: packages/exo/src/get-interface.js
total-lines: 28
status: published
ingest-cycle: 239
ingest-date: 2026-06-08
lane: chat
---

# @endo/exo/src/get-interface.js

A §28-line-file containing exactly two structural artifacts: the named protocol constant `GET_INTERFACE_GUARD = '__getInterfaceGuard__'` and the `GetInterfaceGuard<M>` typedef that uses it as a computed property key.

§Third-direct-ingest from `@endo/exo`'s `src/` (after `exo-makers.js` and `exo-tools.js`).

## Key design moves

- **§The named protocol constant** — the string value IS the wire-form name; the constant name is the developer-facing handle.
- **§Double-underscore-wrap** as CapTP introspection meta-method naming convention.
- **§Two named meta-methods in CapTP introspection** — `getMethodNames` (cited by reference) + `getInterfaceGuard`.
- **§The PR-discussion link as named provenance** — `pull/1809#discussion_r1388052454`.
- **§The cache staleness caveat as explicit warning** — `Beware that an exo's interface can change across an upgrade, so remotes that cache it can become stale`.
- **§The typedef with computed property key** — uses the named constant as the property key, not a duplicate string literal.
- **§Defense by construction via computed property key** — name and type stay aligned by construction.
- **§Template with constraint** — `@template {Record<RemotableMethodName, CallableFunction>} M`.
- **§Two named shapes of not having an interface** — method absent vs method present returning undefined.
- **§Twenty-eight lines as a complete protocol artifact** — the protocol artifact shape, not the implementation shape.

## Section files

- [§GET_INTERFACE_GUARD-protocol-name + §double-underscore-wrap + §typedef-with-computed-property-key + §cache-staleness-caveat](../sections/endo--packages-exo-src-get-interface--GET_INTERFACE_GUARD-protocol-name-and-double-underscore-wrap-and-typedef-with-computed-property-key-and-cache-staleness-caveat.md) — full 28-line module ingest.

## Ingest scope

Cycle 239 (chat-lane): full 28-line module ingest. §First-explicit-observation of four new patterns: §double-underscore-wrap as CapTP introspection meta-method naming convention + §the-named-constant-string-IS-the-protocol-name + §defense-by-construction-via-computed-property-key + §the-warning-IS-the-protocol-contract.
