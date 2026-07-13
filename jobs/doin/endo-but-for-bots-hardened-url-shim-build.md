---
role: builder
---

Build the Hardened `URL` / `URLSearchParams` vetted shim in endojs/endo-but-for-bots (`llm` branch) per design record `hardened-url-shim` (M2): seed the `%URLSearchParamsIteratorPrototype%` and related iterator prototypes into the SES intrinsic graph so `harden(URL)` is safe, add `permits.js` entries, and cover with tests — mirroring the sibling `hardened-text-codecs-shim` approach.

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 17
  claimed_at: 2026-07-13T08:55:10Z
