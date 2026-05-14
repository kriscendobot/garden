---
title: API Overview: lockdown, repairIntrinsics, hardenIntrinsics, harden
source: docs/guide.md
source_repo: endojs/endo
source_commit: fe81477bf88b00775bf135ce6cb3a7123a296e3e
source_date: 2025-09-25
source_authors: [Kris Kowal]
ingested: 2026-05-14
ingested_by: scholar
topics: [hardened-javascript]
status: current
notes: Canonical for the four main API verbs (lockdown, repairIntrinsics, hardenIntrinsics, harden). As of cycle 30 supersedes endo--docs-reference--lockdown-api, endo--docs-reference--repair-intrinsics-api, endo--docs-reference--harden-intrinsics-api, endo--docs-reference--lockdown-and-harden. For exhaustive per-option detail on lockdown() see endo--docs-lockdown--*.
---

> Abstract: Consolidated coverage of the four main API verbs: lockdown() one-time setup, the lower-level repairIntrinsics() + hardenIntrinsics() pair that lockdown() composes, and harden() for per-value transitive freezing. Includes a short section on how lockdown() and harden() relate. Overlaps with docs/reference.md's separate API sections; this version is guide-shaped with more context.

## `lockdown()`

`lockdown()` freezes all JavaScript defined objects accessible to any
program in the execution environment. Calling `lockdown()` turns a JavaScript
system into a hardened system, with enforced OCap (object-capability) security. It
alters the surrounding execution environment (realm) such that no two
programs running in the same realm can observe or interfere with each other
until they have been introduced.

To do this, `lockdown()` tamper-proofs all of the JavaScript intrinsics to prevent
prototype pollution. After that, no program can subvert the methods of these objects
(preventing some man in the middle attacks). Also, no program can use these mutable
objects to pass notes to parties that haven't been expressly introduced (preventing
some covert communication channels).

For a full explanation of `lockdown()` and its options, please click
[here](./lockdown.md).

## `repairIntrinsics()`

Performs the first part of Lockdown: adding, removing, and replacing certain
JavaScript intrinsics so that some intrinsics can be safely shared between
confined programs.
Running `repairIntrinsics()` introduces `hardenIntrinsics()`.

## `hardenIntrinsics()`

Performs the last part of Lockdown: hardening the shared intrinsics so they can
be safely shared between confined programs.
Running `hardenIntrinsics()` reveals the `harden()` function.
(Harden is not useful until after `hardenIntrinsics()` and could interfere with
the execution of repairs or shims if it were revealed earlier.)

## `harden()`

`harden()` is automatically provided by `lockdown()`. Any code that will run inside a vat or a
contract can use harden as a global, without importing anything. The Agoric programming
environment defines objects (`mint`, `issuer`, `zcf`, etc.) that shouldn't need hardening
as their constructors do that work. You mainly need to harden records, callbacks, and ephemeral objects.

`harden()` must be called on all objects that will be transferred across a trust boundary
The general rule is if you make a new object and give it to someone else (and don't
immediately forget it yourself), you should give them `harden(obj)` instead of the raw object.
This ensures other objects can only interact with them through their defined method interface,
i.e. the functions in the object's API. *CapTP*, our communications layer for passing
references to distributed objects, enforces this at vat boundaries.

Hardening an instance also hardens its class.

You can send a message to a hardened object. If it's a record, you can access
its properties and their values. Being hardened doesn't preclude an object from having
access to mutable state (`harden(new Map())` still behaves like a normal mutable `Map`),
but it means their methods stay the same and can't be surprisingly changed by someone else.

> Tip: If your text editor/IDE complains about `harden()` not being defined or imported,
> try adding `/* global harden */` to the top of the file.
>
> You use `harden()` like this:
> ```js
> const o = {a: 2};
> o.a  = 12;
> console.log(o.a); // 12 because o is still mutable
> harden(o);
> o.a  = 37; // throws a TypeError because o is now hardened
> ```
## `lockdown()` and `harden()`

`lockdown()` and `harden()` essentially do the same thing; freeze objects so their
properties cannot be changed. The only way to interact with frozen objects is through
their methods. Their differences are what objects you use them on, and when you use them.

`lockdown()` **must** be called first. It hardens JavaScript's built-in *primordials*
(implicitly shared global objects) and enables `harden()`. If you call `harden()`
before `lockdown()` executes, it throws an error.

`lockdown()` works on objects created by the JavaScript language itself as part of
its definition. Use `harden()` to freeze objects created after `lockdown()`was called;
i.e. objects created by programs written in JavaScript.


Source: [docs/guide.md](https://github.com/endojs/endo/blob/fe81477bf88b00775bf135ce6cb3a7123a296e3e/docs/guide.md) at commit `fe81477b`.
