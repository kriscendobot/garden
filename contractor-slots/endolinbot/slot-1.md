---
slot: 1
status: in-flight
design_path: designs/cbors.md
pr_number: null
current_stage: builder
in_flight_dispatch: 73e7c9
last_update: 2026-05-18T13:43:00Z
started_at: 2026-05-18T13:43:00Z
host: endolinbot
---

Slot 1 refilled with `cbors` (`@endo/cbors`) Phase 1 after
contractor-side substrate audit:
- No `packages/cbors/` exists on llm.
- No `@endo/cbors`/`cbor-frame`/`CBOR.head`/`cborHead` references in
  packages/.
- Design is fresh (2026-05-04, ~2 weeks old).

Scope: new `@endo/cbors` package modeled on `@endo/netstring`. Framing
primitive only (CBOR byte-string head wraps payload). Reader: async
iterable of Uint8Array bytes. Writer: `.next(bytes)` API. Out of scope:
CBOR integer/array/map/tag understanding. Base: llm.

Dispatch root: `dispatches/builder--73e7c9`.
