---
source: packages/base64/src/{encode,decode,common}.js + index.js
source_repo: endojs/endo
source_url: https://github.com/endojs/endo/tree/master/packages/base64
source_path: packages/base64/src/encode.js, packages/base64/src/decode.js, packages/base64/src/common.js, packages/base64/index.js
section_kind: source
ingested: 2026-06-03
ingested_by: scholar
contributors:
  - Kris Kowal (prompted)
topics:
  - hardened-javascript
  - tooling
genre: §endo-source-comment-fragment §canonical-leaf-package-pattern
cycle: 181
lane: chat
status: current
title: §Three-class-padding-switch (end of encode)
parent: endo--packages-base64-src-encode-decode-js--the-canonical-leaf-package-skeleton-with-three-tier-dispatch-and-Reflect-apply-defensive-binding
---

```js
switch (quantum) {
  case 0:
    break;
  case 8:
    string +=
      alphabet64[(register >>> 2) & 0x3f] +
      alphabet64[(register << 4) & 0x3f] +
      padding +
      padding;
    break;
  case 16:
    string +=
      alphabet64[(register >>> 10) & 0x3f] +
      alphabet64[(register >>> 4) & 0x3f] +
      alphabet64[(register << 2) & 0x3f] +
      padding;
    break;
  default:
    throw Error(`internal: bad quantum ${quantum}`);
}
```

§Three-cases corresponding to the three possible remainders
(0, 1, 2 bytes = 0, 8, 16 bits remaining).

- **§Quantum-0** — no remainder, no padding.
- **§Quantum-8** — 1 byte left; emit 2 base64 chars + 2 `=`
  padding chars.
- **§Quantum-16** — 2 bytes left; emit 3 base64 chars + 1 `=`
  padding char.
- **§Default-internal-bad-quantum** — defensive throw; should be
  unreachable because `quantum` only takes values 0/8/16/24
  through the loop.

§The-§internal-bad-quantum-throw is §sanity-check-for-invariant-
holds. §Compare-to-cycle-178-daemon-xs-worker-snapshot's
§sanity-check-for-the-invariant pattern.
