---
role: builder
---

Build the M2 `hardened-url-shim` design in endojs/endo-but-for-bots (journal/plan/designs/endo-but-for-bots/hardened-url-shim.md): add `URL`/`URLSearchParams` to the SES permits (`packages/ses/src/permits.js`) as a vetted shim — seed the `%URLSearchParamsIteratorPrototype%` permit, strip the ambient `createObjectURL`/`revokeObjectURL` statics via a Date-style start-compartment split, and no-op on hosts without `URL` (XS). This is the untouched sibling of the in-flight text-codecs shim.

---
claim:
  host: endolin-garden2-5bcdff64
  gardener: 1
  worker_kind: cleric
  claimed_at: 2026-07-21T20:00:17Z
