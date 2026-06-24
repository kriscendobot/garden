---
source: packages/captp/src/atomics.js
source_repo: endojs/endo
source_url: https://github.com/endojs/endo/blob/master/packages/captp/src/atomics.js
source_path: packages/captp/src/atomics.js
section_kind: source
ingested: 2026-06-03
ingested_by: scholar
contributors:
  - Kris Kowal (prompted)
topics:
  - captp
  - patterns
  - tooling
genre: §endo-source-comment-fragment
cycle: 169
lane: chat
status: current
title: §JSON-encoding-not-marshal-direct
parent: endo--packages-captp-src-atomics-js--SharedArrayBuffer-three-buffer-split-with-Atomics-wait-notify-and-chunked-transfer-via-async-generator
---

```js
const json = JSON.stringify(serialized);
const encoded = te.encode(json);
```

§Encode-to-JSON-then-UTF-8-bytes. §Two-step-encoding: §JSON-
for-structure + §UTF-8-for-bytes.

§Why-not-marshal-direct: marshal produces structured output
with slot references; this transport carries §already-
serialized-by-captp data. §The-marshalling-happened-
upstream; this layer is §pure-bytes-transport.

§Cycle-67-69's-marshal handles the §pass-style-aware
serialization; cycle 65's @endo/captp wires marshal to the
network; this file is the §inner-transport-for-the-trap-
mode.

§Layering-discipline named.
