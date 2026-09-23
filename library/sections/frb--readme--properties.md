---
title: FRB design properties (functional, generic, reactive, synchronous, incremental, unwrapped)
source: README.md
source_repo: kriskowal/frb
source_commit: 131db347355789cf2dbb79e49b10881d9716b449
source_date: 2013-09-15
source_authors: [Kris Kowal]
ingested: 2026-06-24
ingested_by: scholar
topics: [reactive-bindings]
status: current
---

> Abstract: The six adjectives FRB uses to describe itself, from the Reference section, and what each means operationally: **functional** (observers/binders composed from functional building blocks), **generic** (generic collection methods so any object can participate), **reactive** (values react to changes in their dependencies), **synchronous** (consistency restored in the same statement that caused the change, not a later event), **incremental** (a content change carries the added/removed values and location, so a sum updates by the delta rather than recomputing), and **unwrapped** (FRB modifies existing arrays and objects to dispatch change events instead of wrapping them in observable containers).

FRB is an implementation of synchronous, incremental object-property and collection-content bindings for JavaScript. It was extracted from the heart of the Montage web-application framework. The implementation is described by six properties:

- **functional**: the implementation uses functional building blocks to compose observers and binders.
- **generic**: it uses generic methods on collections, like `addContentChangeListener`, so any object can implement the same interface and be used in a binding. (This is the contract the [collections](https://github.com/kriskowal/collections) library satisfies.)
- **reactive**: the values of properties and contents of collections react to changes in the objects and collections on which they depend.
- **synchronous**: all bindings are made consistent in the statement that causes the change. The alternative is asynchronous, where changes are queued and consistency is restored in a later event.
- **incremental**: updating an array produces a content change that contains the values added, the values removed, and the location of the change. Most bindings can be updated using only these values: a sum decreases by the sum of the removed values and increases by the sum of the added ones. FRB can incrementally update `map`, `reversed`, `flatten`, `sum`, and `average` observers, and `has` bindings.
- **unwrapped**: rather than wrap objects and arrays in observable containers, FRB modifies existing arrays and objects to dispatch property and content changes. For objects this installs getters and setters via `Object.defineProperty`. For arrays it replaces the mutation methods (`push`, `pop`, ...) with change-dispatching variants, either by swapping `__proto__` or by adding instance methods with `Object.defineProperties`.

Source: [README.md](https://github.com/kriskowal/frb/blob/131db347355789cf2dbb79e49b10881d9716b449/README.md) at commit `131db347`.
