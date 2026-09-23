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
title: §prime captures first-returned-promise
parent: endo--packages-stream-index-js--symmetric-async-iterator-streams-with-makeQueue-makePipe-pump-and-prime-utilities
---

```js
export const prime = (generator, primer) => {
  const first = generator.next(primer);     // captured
  let result;
  return harden({
    async next(value) {
      if (result === undefined) {
        result = await first;
        if (result.done) return result;
      }
      return generator.next(value);
    },
    async return(value) { ... },
    async throw(error) { ... },
  });
};
```

§Async-generator-needs-priming because the first value is
sent at generator-creation, not via .next(). §The-first-
.next(value)-is-actually-the-second-value.

§Capture-first-then-forward: the wrapper holds the §first-
promise; the first call to any method awaits it before
proceeding.

§Three-methods-all-wait-for-first: §uniform-discipline-
across-the-iterator-protocol.

§Why-this-matters: async-generators have a §timing-
asymmetry between creation and first iteration. §Prime-
makes-the-timing-uniform.
