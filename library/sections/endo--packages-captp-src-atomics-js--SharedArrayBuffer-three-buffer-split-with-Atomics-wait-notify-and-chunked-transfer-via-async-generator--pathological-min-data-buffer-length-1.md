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
title: §Pathological-MIN_DATA_BUFFER_LENGTH=1
parent: endo--packages-captp-src-atomics-js--SharedArrayBuffer-three-buffer-split-with-Atomics-wait-notify-and-chunked-transfer-via-async-generator
---

```js
// This is a pathological minimum, but exercised by the
// unit test.
export const MIN_DATA_BUFFER_LENGTH = 1;
```

§Test-the-boundary-not-just-the-happy-path. §Pathological-
minimum-still-works: a 1-byte data buffer means the
implementation must handle arbitrarily-many chunks. §The-
unit-test-exercises-this-edge to prove the chunking logic
is correct.

§Discipline-named: §pathological-test-case-anchors-the-
design. Cycle 152's memo-race.js had a similar shape (the
race conditions were explicitly tested). §Don't-just-test-
the-typical-input.

§Minimum-transfer-buffer = data + overhead = 1 + 12 = 13
bytes. §A-13-byte-SharedArrayBuffer-can-transfer-any-size-
message via enough chunking iterations.
