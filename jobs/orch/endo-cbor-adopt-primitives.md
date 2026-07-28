---
order: serial
children: endo-cbor-adopt-ocapn endo-cbor-adopt-daemon-envelope
on-child-failure: halt
state: pending
created_by: orchestrator
created_at: 2026-07-28T21:10:02Z
---

# Adopt `@endo/cbor` at the existing CBOR call sites

Executes phases 2 and 4 of `designs/cbor-codec.md` (endojs/endo-but-for-bots, `llm`),
now that phase 1 — `@endo/cbor` at `packages/cbor/` — merged as
https://github.com/endojs/endo-but-for-bots/pull/755 (merge commit `3b21299`,
2026-07-28T21:04:42Z).

Maintainer directive, kriskowal, 2026-07-28, in the approving review of #755:
*"Please conduct and post a follow-up job to refactor existing use of CBOR in ocapn
and elsewhere to use these foundational primitives."*

Children, serial, halt on failure:

1. **`endo-cbor-adopt-ocapn`** — phase 2, the headline ask. Replace the module-level
   primitive helpers in `packages/ocapn/src/cbor/{encode,decode}.js` with `@endo/cbor`
   imports; the `CborWriter` / `CborReader` classes and the diagnostic codec stay.
2. **`endo-cbor-adopt-daemon-envelope`** — phase 4, the "and elsewhere". Point the
   third copy of the head grammar in `packages/daemon/src/envelope.js` at
   `@endo/cbor`; the envelope framing and `[handle, verb, payload, nonce]` shape stay.

Serial on purpose: child 2 follows child 1's bridging precedent (writer/reader state
shape, the bigint-heads / number-counts boundary) instead of re-litigating it.

Both are **pure refactors** with a **byte-identity** acceptance criterion — capture
encoder output before and after and diff it; a green suite alone is not the evidence.
Each opens its own PR off a fresh frozen base with a `.changeset/` entry, and each
draft PR auto-runs the gauntlet under its supervising gardener.

**Not a child here:** phase 3, the slots migration, is parked separately as
`endo-cbor-adopt-slots`, blocked on
https://github.com/endojs/endo-but-for-bots/pull/124 — `packages/slots` does not
exist on `llm` yet, so a serial child would stall.
