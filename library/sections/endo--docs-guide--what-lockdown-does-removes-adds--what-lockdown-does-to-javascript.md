---
title: What Lockdown does to JavaScript
source: docs/guide.md
source_repo: endojs/endo
source_commit: fe81477bf88b00775bf135ce6cb3a7123a296e3e
source_date: 2025-09-25
source_authors: [Kris Kowal]
ingested: 2026-05-14
ingested_by: scholar
topics: [hardened-javascript]
status: current
notes: Overlaps with endo--docs-reference--removed-by-hardened-js and endo--docs-reference--added-changed-by-hardened-js. Guide-shaped vs reference-shaped; kept both.
parent: endo--docs-guide--what-lockdown-does-removes-adds
---

HardenedJS does not include any I/O objects providing "unsafe" [*ambient authority*](https://en.wikipedia.org/wiki/Ambient_authority).
It also doesn't allow non-determinism from built-in JavaScript objects.

As of SES-0.8.0/Fall 2020, [Agoric's SES source code](https://github.com/endojs/endo/blob/SES-v0.8.0/packages/ses/src/permits.js)
defines a subset of the globals defined by the baseline JavaScript language specification. SES includes these globals:

- `Object`
- `Array`
- `Number`
- `Map`
- `WeakMap`
- `Number`
- `BigInt`
- `Intl`
- `Math` all features except
  - `Math.random()` throws a `TypeError` rather than provide a random number, which would be a source of non-determinism.
- `Date` all features except
  - `Date.now()` throws a `TypeError` rather than returning the millisecods
    representing the current time.
  - `new Date()`, calling it as a constructor (with `new`) with no arguments,
    throws a `TypeError` rather than returning a date instance
    representing the current time.
  - `Date(...)`, calling it as a function (without `new`) no matter what
    the arguments, throws a `TypeError` rather than a string presenting
    the current time.

Much of the `Intl` package, and some other objects' locale-specific aspects (e.g. `Number.prototype.toLocaleString`)
have results that depend upon which locale is configured. This varies from one process to another.
See [`lockdown()`](./lockdown.md) for how those are handled.

Lockdown freezes *primordials*; built-in JavaScript objects such as `Object`, `Array`, and `RegExp`,
and their prototype chains. `globalThis` is also frozen. This prevents malicious code from changing their behavior
(imagine `Array.prototype.push` delivering a copy of its argument to an attacker, or ignoring
certain values). It also prevents using, for example, `Object.heyBuddy` or `globalThis.heyBuddy`
as an ambient communication channel via setting a property and another program periodically reading it.
This would violate object-capability discipline; objects may only communicate through references.

Both frozen primordials and a frozen `globalThis` have problems with a few JavaScript
libraries that add new features to built-in objects (shims/polyfills). These
libraries stretch best practices' boundaries by adding new features to built-in
objects in a way Compartments don't allow.

Source: [docs/guide.md](https://github.com/endojs/endo/blob/fe81477bf88b00775bf135ce6cb3a7123a296e3e/docs/guide.md) at commit `fe81477b`.
