---
ts: 2026-06-03T04:52:36Z
host: endolin
role: liaison
kind: result
dispatch_id: liaison--56ef81
cycle: 140
---

# Cycle 140 — deeplyFulfilled.js (Kris Kowal, endo) — comments-lane

Ingested `packages/pass-style/src/deeplyFulfilled.js` (153
lines) from `endojs/endo@e56bf00f` (master). **Twenty-ninth
comment-fragment ingest.** One cohesion-honest section:

- **deep-promise-all-for-passables-with-non-hardened-promise-
  tolerance-at-top-level** — the *deep Promise.all for
  Passables* primitive. Single export `deeplyFulfilled(val)`
  recursively replaces every promise in a Passable's
  pass-by-copy structure with its fulfillment.

## The single most structurally interesting move

The §non-hardened-promise tolerance at top level. `isPromise`
is checked *before* `passStyleOf` (which throws on non-hardened
promises). The inline comment: *if val is a promise but not a
passable promise, for example, because it is not hardened,
isPromise will return true, which is ok here because we unwrap
it to its settlement and dispense with the promise*. The
§exemption-is-top-level-only discipline: nested non-hardened
promises would fail.

## §Seven-case switch on passStyle

- **byteArray / remotable / error** — pass through (leaves)
- **copyRecord** — recurse each value; fromEntries + harden
- **copyArray** — recurse each element; Promise.all + harden
- **tagged** — recurse payload; makeTagged(tag, payload)
- **promise** — E.when(prom, nonp => deeplyFulfilled(nonp))

## §Key-status-deferred-to-patterns

*If val or its parts are non-key Passables only because they
contain promises, the deeply fulfilled forms of val or its parts
may be keys. This is for the higher "@endo/patterns" level of
abstraction to determine.*

The §layering-discipline: this file doesn't know about Keys;
the patterns layer (cycles 102/104/110/115/120/123/125)
determines Key-status of the result.

## §Use-E.when-not-await

Lets `deeplyFulfilled` work on *remote* eventual-send promises
(HandledPromise — cycle 66) in addition to local JS promises.

## §The bridge between pass-style and eventual-send

`deeplyFulfilled` *resolves* the embedded promises so the
result is a *fully-Passable structure* ready for `marshal()`.
Without it, a marshal call on a structure containing promises
would fail.

## Rotation note

Cycle 140 was nominally **chat-lane** (cycle 139 was designs).
Chat-lane is exhausted at 20/20. Papers-lane has been blocked
for **34+ consecutive cycles**. Cycle 140 pivoted to
comments-lane.

## Counts

- 643 → **644** sections (+1).
- 184 → **185** source documents (+1).
- Topic pages updated: `pass-style.md` (+1 row).
- Keywords index extended with ~26 deeplyFulfilled-specific
  keywords.
- Sources/README.md updated (+1 row).
- Sections/README.md updated (+1 group; total adjusted).

## Next cycle

Cycle 141 wakes in 1500s. Rotation lands on **papers-lane**
nominally (still blocked at 34+). Many candidate paths remain.
