---
title: harden() as a native C recursive deep-freeze (JS_DeepFreeze)
source: quickjs.c
source_repo: danfinlay/quickjs
source_branch: native-ses
source_commit: 49dc75ede0d511ddea07236622378df7f652b65e
source_date: 2026-03-28
source_authors: [Dan Finlay]
ingested: 2026-07-03
ingested_by: scholar
topics: [engine-implementation, hardened-javascript]
status: current
notes: Sibling-implementation ingest; read for comparison/synthesis, not import.
---

> Abstract: `harden(value)` is implemented as `JS_DeepFreeze`
> (`quickjs.c:59981-60125`), a recursive C traversal that deep-freezes an
> object and everything transitively reachable — own string+symbol
> properties, their values, getters and setters, and the prototype chain —
> guarded by an explicit visited set so cycles terminate. Each object is
> frozen by C-native `Object.freeze` semantics (set `extensible=false`, then
> redefine every own property non-configurable and non-writable). It skips
> Proxies (freezing would fire traps) and module namespaces, re-reads the
> object pointer after each recursion because the heap shape can move, and
> returns the input unchanged for primitives and identically for objects.
> The one wart worth *not* copying is the visited set: a linear-scan array
> (O(n²) membership), fine for small graphs but pathological for a whole
> intrinsic graph.

## The freeze-one-object core

`js_freeze_object_internal` (`quickjs.c:59981`) is `Object.freeze` in C:

```c
p->extensible = false;                        // prevent extensions
// enumerate own string + symbol props, then for each:
//   redefine non-configurable (JS_PROP_HAS_CONFIGURABLE, no CONFIGURABLE bit)
//   and, if it was writable, non-writable (JS_PROP_HAS_WRITABLE, no WRITABLE)
```

It early-returns for `JS_CLASS_PROXY` (a Proxy's `defineProperty`/
`preventExtensions` traps would run on freeze) and `JS_CLASS_MODULE_NS`
(module namespace exotics are already non-configurable and can't be
meaningfully frozen). It uses the public property API
(`JS_GetOwnPropertyNamesInternal`, `JS_DefineProperty`) rather than
poking slots directly, which is what lets it handle accessor properties,
typed arrays, and other exotics correctly.

## The recursive walk

`js_deep_freeze_recursive` (`quickjs.c:60029`):

1. Non-objects return immediately.
2. If the object is already in the visited set, return (cycle/DAG cutoff).
   The circular-reference test (`obj.self = obj`) exercises this.
3. Add to visited, freeze this object.
4. Enumerate own props and recurse into each **value, getter, and setter**.
5. Recurse into the **prototype** (`JS_GetPrototype`).

Between steps it **re-reads `p = JS_VALUE_GET_OBJ(val)`** after a recursive
call (`quickjs.c:60060-60061`) with the comment *"Re-read p since shape may
have changed during recursion"* — a correctness detail that matters more on
an engine with a moving/compacting collector.

The public entry `JS_DeepFreeze` (`quickjs.c:60111`) wraps the walk with
visited-set init/free; the JS-callable `js_harden` (`quickjs.c:60265`)
returns primitives via `js_dup(val)` unchanged and otherwise deep-freezes
and returns the same object (identity preserved), matching
`harden(obj1) === obj1` in the test.

## The visited-set wart

`DeepFreezeSet` (`quickjs.c:59938`) is a plain `JSObject**` array with
capacity-doubling from 512 and **linear-scan membership**
(`deep_freeze_set_has`, `quickjs.c:59957`, a `for` loop over all entries).
Membership is O(n) per object, so freezing a graph of *n* objects is
O(n²). Acceptable for `harden`-ing a small application value; a poor choice
for `lockdown`-ing the entire intrinsic graph (thousands of objects), which
reuses the same set. Anyone porting the *idea* should carry a proper hash
set — or, on an engine whose GC already walks the whole object graph, an
inline "frozen" bit set during a mark-style pass — not this array.

## Why this is the fast, safe-to-move half

Deep-freeze is the single most expensive part of SES `lockdown()`/`harden()`
startup in the JS shim, because the shim does the traversal reflectively
through `Reflect.ownKeys` / `getOwnPropertyDescriptor` / `defineProperty`
megamorphically from JS. Moving the identical traversal into C removes the
interpreter dispatch overhead entirely while changing **nothing** about the
security semantics of freezing — a frozen object is a frozen object. That
is why, of all the pieces here, the deep-freeze is the one most clearly
worth translating to XS (see
[xs-transferable-strategies](danfinlay-quickjs--native-ses--xs-transferable-strategies.md)).

Source: [quickjs.c](https://github.com/danfinlay/quickjs/blob/49dc75ede0d511ddea07236622378df7f652b65e/quickjs.c#L59981) at commit `49dc75e`.
