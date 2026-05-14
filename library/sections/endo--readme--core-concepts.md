---
title: Core Concepts
source: README.md
source_repo: endojs/endo
source_commit: 30d556b73acf8e12d52f5d6efc1960223e98ec17
source_date: 2025-12-19
source_authors: [Kris Kowal]
ingested: 2026-05-14
ingested_by: scholar
topics: [hardened-javascript, capability-security, compartments, eventual-send]
status: current
---

> Abstract: The umbrella-level core concepts the Endo family realizes: HardenedJS substrate, Compartment isolation, capability discipline (Far, Exo), pass-style classification, eventual-send messaging, OCapN-family protocols. Each concept is one paragraph; the section is the landing page for someone new to the model.

## Core Concepts

[HardenedJS][] introduces three components to the base JavaScript:

- Lockdown
- Harden
- Compartment

The _Shared Intrinsics_ are a subset of the JavaScript intrinsics like the
`Array` and `Object` prototypes that, after _locking down_, are safe to share
between programs running in _compartments_.
After _lockdown_, programs can use _harden_ to make other objects safe
to share between compartments.

With these three components, we can begin to rely on certain guarantees:

- Hardened objects can represent _capabilities_.
  That is, holding a reference to an object means you can use that object.
- JavaScript itself guarantees that _capabilities_ cannot be forged.
  That is, a useful reference cannot be obtained by guessing its address.
- JavaScript also enforces certain structures like closures and `WeakMap`
  can guard capabilities. 
- The only way to obtain a _capability_ is to have received it as an argument,
  return, global, or module of the surrounding compartmnet.
- Once hardened, an object and its methods cannot be altered.

This gives us the foundation of the _Object-capability_ security paradigm,
or simply "OCaps".
From this point forward, any interesting policy can be created with code.

We can then use Endo to stretch references to Object-capabliities between
processes and over networks.
Instead of relying on the memory-safety of JavaScript, we then rely on
cryptography to preserve confidentiality and unforgeability of references.  A
suitably large, signed, cryptographically random number, reachable over a
network over an encrypted connection, may safely designate a capability.

Then, Endo puts ocaps directly into the hands of users with an example [Petname
system][] called the _Pet Dæmon_, so user's can send, receive, and use
_Object-capabilities_ with human-meaningful names.


Source: [README.md](https://github.com/endojs/endo/blob/30d556b73acf8e12d52f5d6efc1960223e98ec17/README.md) at commit `30d556b7`.
