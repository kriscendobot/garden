---
source: packages/marshal/src/marshal-justin.js + packages/marshal/src/marshal-stringify.js
source_repo: endojs/endo
source_url: https://github.com/endojs/endo/tree/master/packages/marshal/src
source_path: packages/marshal/src/marshal-justin.js, packages/marshal/src/marshal-stringify.js
section_kind: source
ingested: 2026-06-04
ingested_by: scholar
contributors:
  - Kris Kowal (prompted)
  - Mark S. Miller (prompted)
topics:
  - marshal
  - pass-style
  - errors
genre: §endo-source-comment-fragment §canonical-passable-rendering-pair
cycle: 189
lane: chat
status: current
title: §doNotConvertValToSlot + doNotConvertSlotToVal (the rejector pair)
parent: endo--packages-marshal-src-marshal-justin-and-marshal-stringify-js--two-pass-decoder-with-mirror-control-flow-and-indenter-trait-and-SGML-comment-injection-defense
---

```js
const doNotConvertValToSlot = val =>
  Fail`Marshal's stringify rejects presences and promises ${val}`;

const doNotConvertSlotToVal = (slot, _iface) =>
  Fail`Marshal's parse must not encode any slots ${slot}`;
```

§Two-rejector-functions used by `makeMarshal` when constructing
the §no-slot-marshal. §Together-they-ensure that:

- §Serialize-rejects any passable containing presences (remotables)
  or promises.
- §Parse-rejects any body containing slot encodings.

§Combined-with-the-§badArray-proxy, the no-slot path is §three-
layer-defended:

1. §Serializer rejects presences/promises before they become
   slots.
2. §Parser rejects slot-encodings in the body.
3. §badArray proxy rejects any slot-index-lookup attempt.

§Defense-in-depth for "this path never has slots." §Compare-
to-cycle-184-metering's §three-mechanisms-eliminated by
admission control (embargo + rollback + outbound-buffering).
§Both-are-§invariant-enforced-at-multiple-layers patterns.
