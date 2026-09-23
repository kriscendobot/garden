---
title: lockdown() as two-phase freeze-all-intrinsics (JS_FreezeIntrinsics)
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

> Abstract: `lockdown()` is `JS_FreezeIntrinsics` (`quickjs.c:60134-60247`),
> a two-phase pass. **Phase 1** force-resolves every lazily-initialized
> (AUTOINIT) global property by `JS_GetProperty`-ing it, because quickjs-ng
> materializes many intrinsics on first access and a lazy property that
> initialized *after* the freeze would escape sealing. **Phase 2**
> deep-freezes the reachable intrinsic graph — all class prototypes, all
> global own properties, a handful of context-held intrinsics not on the
> global (`function_proto`, `throw_type_error`, `iterator_proto`,
> `async_iterator_proto`, `array_proto_values`, `error_ctor`), and the
> native error prototypes — but **pre-marks the global object and the
> lexical `global_var_obj` as visited** so they stay extensible and user
> code can keep declaring globals. Crucially, it *only freezes*: no permits
> whitelist, no removal, no taming, no determinism scrub. The
> force-resolve-before-seal invariant is the transferable correctness
> lesson; the freeze-without-tame gap is the transferable safety warning.

## Phase 1 — force-resolve lazy intrinsics

```c
// quickjs.c:60141-60155
// Access every own global property so AUTOINIT (lazy) init fires now.
for each own prop of ctx->global_obj:
    JSValue v = JS_GetProperty(ctx, ctx->global_obj, prop); JS_FreeValue(...);
```

The comment names the hazard directly: *"First force-resolve all AUTOINIT
(lazy) global properties, then deep-freeze."* If a constructor like
`Map` or `WeakRef` were still an unresolved AUTOINIT stub at freeze time,
freezing the global would not freeze the not-yet-materialized object, and
the first later access would install a fresh, **mutable** intrinsic —
a lockdown escape. Enumerating and touching everything first closes that.

## Phase 2 — deep-freeze the reachable set, keep the global extensible

The pass reuses `js_deep_freeze_recursive` with one seeded visited set, and
the seeding is the interesting part:

```c
// quickjs.c:60161-60174 — pre-mark so they are NOT frozen:
deep_freeze_set_add(&visited, global_obj);       // keep global extensible
deep_freeze_set_add(&visited, global_var_obj);   // keep let/const scope open
```

Then it freezes, in order (`quickjs.c:60176-60242`):

- **2a.** every registered class prototype (`ctx->class_proto[1..]`);
- **2b.** every own property of the global (constructors, `Math`, `JSON`,
  `Reflect`, …) — now all NORMAL because phase 1 resolved them;
- **2c.** context-held intrinsics not reachable as global own properties:
  `function_proto`, `throw_type_error`, `iterator_proto`,
  `async_iterator_proto`, `array_proto_values`, `error_ctor`;
- **2d.** the native error prototypes (`native_error_proto[]`).

The net effect matches `tests/test_lockdown.js`: after `lockdown()` a long
list of prototypes and constructors report `Object.isFrozen`, writing
`Object.prototype.evil = 1` throws, but `Object.isExtensible(globalThis)` is
still true and `globalThis._test = 42` still works. The JS-callable
`js_lockdown` (`quickjs.c:60250`) is a thin wrapper that just calls
`JS_FreezeIntrinsics` and takes **no options** — there is no
`lockdown({dateTaming, errorTaming, …})` surface because there is nothing
to tame.

## What it does NOT do — the security-incomplete half

Compared with SES `lockdown()`, `JS_FreezeIntrinsics` omits every taming
step:

- **No permits whitelist.** Nothing is removed. SES deletes non-permitted
  intrinsic properties; this keeps all of them, merely frozen.
- **No non-determinism scrub.** `Date.now`, `Date`, `Math.random` are frozen
  but present and live. SES replaces them (or makes them throw) under
  `dateTaming`/`mathTaming` so confined code is deterministic.
- **No `eval`/`Function`-constructor taming.** The `Function` constructor
  remains a channel to the (frozen but reachable) intrinsics.
- **No `Error` taming.** Stack-trace access and `Error.captureStackTrace`
  are untouched — SES tames these to close a same-realm capability channel
  (cf. the library's `tame-v8-error-constructor` and pass-style `error.js`
  material).
- **No prototype-poison repair** beyond freezing.

Freezing prevents *mutation* of shared intrinsics — real, and the reason
prototype-pollution attacks fail here — but it does not prevent *use* of
authority-bearing or non-deterministic intrinsics. That is the line the
XS-evolution reading has to hold: the freeze is safe to accelerate; the
taming is not safe to drop (see
[xs-transferable-strategies](danfinlay-quickjs--native-ses--xs-transferable-strategies.md)).

Source: [quickjs.c](https://github.com/danfinlay/quickjs/blob/49dc75ede0d511ddea07236622378df7f652b65e/quickjs.c#L60134) at commit `49dc75e`.
