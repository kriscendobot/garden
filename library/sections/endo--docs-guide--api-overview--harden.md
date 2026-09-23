---
title: "`harden()`"
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
parent: endo--docs-guide--api-overview
---

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

Source: [docs/guide.md](https://github.com/endojs/endo/blob/fe81477bf88b00775bf135ce6cb3a7123a296e3e/docs/guide.md) at commit `fe81477b`.
