---
ts: 2026-06-03T01:43:53Z
host: endolin
role: liaison
kind: result
dispatch_id: liaison--85ea56
cycle: 134
---

# Cycle 134 — remotable.js (Kris Kowal, endo) — comments-lane

Ingested `packages/pass-style/src/remotable.js` (305 lines) from
`endojs/endo@e56bf00f` (master). **Twenty-sixth comment-fragment
ingest.** One cohesion-honest section:

- **what-a-remotable-is-with-tag-record-inheritance-and-distinct-
  object-vs-function-remotable-shapes** — the
  *what-counts-as-a-remotable* predicate layer. Connects three
  previously-ingested layers: cycle 71's passStyleOf.js
  (dispatches to this file's RemotableHelper for `pass-style ===
  'remotable'`); cycle 132's local.js (provides getMethodNames,
  re-exported here as getRemotableMethodNames); cycle 130's
  message-breakpoints.js (strips the `'Alleged: '`/`'DebugName:
  '` prefixes this file *requires*).

## The single most structurally interesting move

The §two-distinct-shapes discipline. Object remotables are *bags
of methods + @@toStringTag* (methods don't carry PASS_STYLE);
function remotables (Far functions) are *single callables +
metadata* (.name, .length, optional @@toStringTag; *Far functions
cannot be methods, and cannot have methods*). The two shapes are
*mutually exclusive* — an object remotable is *not* a callable; a
Far function is *not* a bag of properties.

## Layered integration

The file is *the connector between three prior layers*:

| Layer | Cycle | Role |
|-------|-------|------|
| Dispatch | 71 | passStyleOf.js dispatches to this file's RemotableHelper |
| Method introspection | 132 | local.js provides getMethodNames |
| Tag-prefix convention | 130 | message-breakpoints.js strips `Alleged: ` / `DebugName: ` |

This file *requires* the tag-prefix conventions (cycle 130) and
*re-exports* the method-introspection helper (cycle 132); cycle
71's dispatcher *calls into* this file's RemotableHelper.

## The §confirmedRemotables WeakSet cache discipline

The §cache-positive-not-negative discipline: *we don't remember
rejections because they are possible to correct with e.g.
harden*. The cache is *forward-only* — once true, always true
(frozen-ness + structure are permanent); rejections are about
*the value at this moment*. WeakSet lets GC reclaim entries.

## The §two recursive cases for confirmRemotableProtoOf

The proto walk handles two cases:

1. **Direct tag-record parent**: proto is the tag record with
   `PASS_STYLE='remotable'` + `@@toStringTag`.
2. **Inherited remotable parent**: proto is itself a remotable;
   recursively confirm it.

The §never-direct-inheritance-from-Object.prototype invariant
forces *intentional remotability* — accidentally-passable objects
are caught.

## Rotation note

Cycle 134 was nominally **chat-lane** (cycle 133 was designs).
Chat-lane is exhausted at 20/20. Papers-lane has been blocked
for **28+ consecutive cycles** due to lack of PDF-fetching
infrastructure. Cycle 134 pivoted to comments-lane.

## Counts

- 637 → **638** sections (+1).
- 178 → **179** source documents (+1).
- Topic pages updated: `pass-style.md` (+1 row — third
  pass-style source-comment ingest after cycle 71's passStyleOf
  and cycle 87's error.js trio).
- Keywords index extended with ~37 remotable-predicate-specific
  keywords.
- Sources/README.md updated (+1 row).
- Sections/README.md updated (+1 group; total adjusted).

## Next cycle

Cycle 135 wakes in 1500s. Rotation lands on **papers-lane**
nominally (still blocked at 28+). Many candidate paths: continue
@endo/pass-style (deeplyFulfilled.js, make-far.js, safe-promise.js,
symbol.js, typeGuards.js), or @endo/eventual-send/E.js (501
lines), or daemon-* family (24+ unexplored designs).
