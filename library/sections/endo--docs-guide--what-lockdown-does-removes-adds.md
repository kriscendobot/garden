---
title: What Lockdown does, removes, and adds
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
---

> Abstract: Consolidates three H2 sections (What Lockdown does to JavaScript, What Lockdown removes from standard JavaScript, What HardenedJS adds to standard Javascript) covering the modifications lockdown() makes to the JS environment. Overlaps with docs/reference.md's removed-by-hardened-js and added-changed-by-hardened-js sections; this version is guide-shaped with more background.

## What Lockdown does to JavaScript

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

## What Lockdown removes from standard JavaScript

Almost all existing JavaScript code runs under Node.js or inside a browser, so
it's easy to conflate environment features with JavaScript. For example, you may
be surprised that `Buffer` and `require` are Node.js additions. Also `setTimeout()`,
`setInterval()`, `URL`, `atob()`, `btoa()`, `TextEncoder`, and `TextDecoder` are additions
to the programming environment standardized by the web, and are not intrinsic
to JavaScript.

Most Node.js-specific [global objects](https://nodejs.org/dist/latest-v14.x/docs/api/globals.html) are
**unavailable** including:

* `queueMicrotask`
* `URL` and `URLSearchParams`
* `WebAssembly`
* `TextEncoder` and `TextDecoder`
* `global`
  * Use `globalThis` instead.
* `process`
  * No `process.env` to access the process's environment variables.
  * No `process.argv` for the argument array.
* `Buffer` (consider using `TypedArray` instead, but see below)
* `setImmediate`/`clearImmediate`
  * You can generally replace `setImmediate(fn)`
    with `Promise.resolve().then(_ => fn())` to defer execution of `fn` until after the current event/callback
    finishes processing. But it won't run until after all *other* ready Promise callbacks execute.

    There are two queues: the *IO queue* (accessed by `setImmediate`), and the *Promise queue* (accessed by
    Promise resolution). HardenedJS code can add to the Promise queue, but needs to be given a
    capability to be able to add to the I/O queue. Note that the Promise queue is
    higher-priority than the IO queue, so the Promise queue must be empty for any IO or timers to be handled.
* `setInterval` and `setTimeout` (and `clearInterval`/`clearTimeout`)
  * Any notion of time must come from
    exchanging messages with external timer services (the SwingSet environment provides a `TimerService` object
    to the bootstrap vat, which can share it with other vats)

None of the huge list of [other Browser environment features](https://developer.mozilla.org/en-US/docs/Web/API)
presented as names in the global scope (some also added to Node.js) are available in a
hardened environment. The most surprising removals include `atob`, `TextEncoder`, and `URL`.

`debugger` is a first-class JavaScript statement, and behaves as expected.

## What HardenedJS adds to standard Javascript

The following anticipate additional proposed standard-track features. If they become standards,
future JavaScript environments will include them as global objects. So the current Agoric SES shim
makes those global objects available.

- `console` is available for debugging. While not in the official spec, since all implementations
  add it, leaving it out would cause confusion. Note that `console.log`’s exact
  behavior is up to the host program; display to the operator is not guaranteed. Use the
  console for debug information only. The console is not obliged to write to the POSIX standard output.

- `assert` is also a debugging tool that allows programs to express assertions
  and defer the construction of error objects and computed messages until an
  assertion fails.

- `repairIntrinsics` adds, removes, and replaces various properties of the
  global environment and shared intrinsics.
  Introduces `hardenIntrinsics`.

- `hardenIntrinsics` freezes the transitive own properties and prototypes of
  the shared intrinsics.
  Introduces `harden`.

- [`harden()`](#harden) provides a shorthand for reliably freezing the
  transitive properties and prototypes of other objects, such that the API
  surface of these objects are tamper-proof when shared between otherwise
  isolated programs.

- [`lockdown()`](#lockdown) is a shorthand for `repairIntrinsics` and `hardenIntrinsics`.

- [`Compartment`](https://github.com/endojs/endo/tree/SES-v0.8.0/packages/ses#compartment)
  Code runs inside a `Compartment` and can create sub-compartments to host
  other code (with different globals or code transforms).
  The globals in a child compartment include the shared intrinsics including
  `harden` and a batch of evaluators that run programs that will also be
  confined to the compartment including `eval`, `Function`, and `Compartment`
  itself.
  Compartments can be created with support for loading modules.
  Comaprtments constructed after `repairIntrinsics()` and `hardenIntrinsics()`
  also confine the evaluation of modules.


Source: [docs/guide.md](https://github.com/endojs/endo/blob/fe81477bf88b00775bf135ce6cb3a7123a296e3e/docs/guide.md) at commit `fe81477b`.
