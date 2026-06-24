---
source: packages/stream/index.js
source_repo: endojs/endo
source_url: https://github.com/endojs/endo/blob/master/packages/stream/index.js
source_path: packages/stream/index.js
section_kind: source
ingested: 2026-06-03
ingested_by: scholar
contributors:
  - Kris Kowal (prompted)
topics:
  - streams
  - patterns
  - captp
genre: §endo-source-comment-fragment
cycle: 171
lane: chat
status: current
title: §Harden-everything-individually
parent: endo--packages-stream-index-js--symmetric-async-iterator-streams-with-makeQueue-makePipe-pump-and-prime-utilities
---

```js
harden(makeQueue);
harden(makeStream);
harden(makePipe);
harden(pump);
harden(prime);
harden(mapReader);
harden(mapWriter);
```

§Defensive-harden-discipline. Each export is individually
hardened, not just the module export. §Harden-the-factory-
not-just-the-result.

§Why: a transitive caller could mutate the factory object
before calling it. §Harden-at-definition closes this
window.

§Cycle-108's-coordinated-update-cluster (commit `e56bf00f`)
adopted `@endo/harden` as the standard import.
