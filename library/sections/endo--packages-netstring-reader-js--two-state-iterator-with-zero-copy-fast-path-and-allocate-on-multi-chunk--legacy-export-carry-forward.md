---
source: packages/netstring/reader.js
source_repo: endojs/endo
source_url: https://github.com/endojs/endo/blob/master/packages/netstring/reader.js
source_path: packages/netstring/reader.js
section_kind: source
ingested: 2026-06-03
ingested_by: scholar
contributors:
  - Mathieu Hofman (prompted)
topics:
  - streams
  - patterns
  - captp
genre: §endo-source-comment-fragment
cycle: 177
lane: chat
status: current
title: §Legacy export carry-forward
parent: endo--packages-netstring-reader-js--two-state-iterator-with-zero-copy-fast-path-and-allocate-on-multi-chunk
---

```js
// Legacy
export const netstringReader = (input, name, _capacity) => {
  return harden(makeNetstringIterator(input, { name }));
};
```

§Old-API kept as alias. §Three-positional-args mapped to
new opts shape.

§_capacity-prefix-with-underscore: §ESLint convention for
§intentionally-unused-parameter. §Honest-comment about
API drift.

§Migration-discipline: §don't-break-existing-callers;
§new-API-via-makeNetstringReader.

§Cycle-176's-renames-from-kind-to-platform follows a
similar shape: §old-name-aliased; §new-name-canonical.
