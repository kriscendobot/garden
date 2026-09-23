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
title: §mapReader and mapWriter — asymmetric shapes
parent: endo--packages-stream-index-js--symmetric-async-iterator-streams-with-makeQueue-makePipe-pump-and-prime-utilities
---

```js
export const mapReader = (reader, transform) => {
  async function* transformGenerator() {
    for await (const value of reader) {
      yield transform(value);
    }
  }
  return harden(transformGenerator());
};

export const mapWriter = (writer, transform) => {
  return harden({
    async next(value) { return writer.next(transform(value)); },
    async throw(error) { return writer.throw(error); },
    async return(value) { return writer.return(value); },
    [Symbol.asyncIterator]() { return transformedWriter; },
  });
};
```

§Two-different-shapes-for-the-same-pattern. §Reader-side-
uses-async-generator (consume + yield transformed);
§writer-side-uses-method-wrapping (intercept next, leave
throw/return as pass-through).

§Why-the-asymmetry: §the-iteration-direction-is-different.
- Reader: data flows *out* — for-await-of consumes; yield
  produces. §Easy-to-express-as-async-generator.
- Writer: data flows *in* — next(value) is called by the
  consumer. §Method-wrapping-is-natural.

§The-symmetry-of-the-stream-interface (Reader and Writer
are structurally identical) doesn't translate to the
§implementation-of-transformers: §the-direction-of-
iteration-matters-for-implementation-shape.

§Throw-and-return-pass-through-unchanged: §only-data-is-
transformed, not control signals.
