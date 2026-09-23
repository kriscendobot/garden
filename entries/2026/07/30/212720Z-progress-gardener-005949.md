---
kind: progress
role: gardener
host: endolin-garden2-5bcdff64
at: 2026-07-30T21:27:22Z
---
Opened draft design PR #896 against `llm`:
`designs/cbor-encode-decode.md` proposes splitting `@endo/cbor` into
`@endo/cbor/encode` and `@endo/cbor/decode` subpath exports over an
internal `internals.js` (shared `canonicalInfo`, `CANONICAL_NAN`,
`UINT64_BOUND`, `UINT32_BOUND`), so decoding consumers retain no
encoding machinery and encoding consumers retain no decoding machinery.
Root `.` re-export preserved; no signature/canonicality/number-domain
change. Follow-up to kriskowal's approving review of #885. Does not
modify #885.
