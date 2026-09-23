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
title: §makeStream pairs acks-and-data
parent: endo--packages-stream-index-js--symmetric-async-iterator-streams-with-makeQueue-makePipe-pump-and-prime-utilities
---

```js
export const makeStream = (acks, data) => {
  return harden({
    next(value) {
      data.put(freeze({ value, done: false }));
      return acks.get();
    },
    return(value) { data.put(freeze({ value, done: true })); return acks.get(); },
    throw(error) { data.put(harden(Promise.reject(error))); return acks.get(); },
    [Symbol.asyncIterator]() { return stream; },
  });
};
```

§Stream-is-just-a-cross-wired-pair-of-queues. `next(value)`
puts to data, gets from acks. §The-caller-sends-by-putting-
and-waits-for-acknowledgment-by-getting.

§Three-symmetric-methods (next / return / throw). §All-put-
to-data, all-get-from-acks. §Symmetry-across-the-three-
states-of-iteration.

§throw-puts-a-rejected-promise (not the error directly).
§Errors-flow-through-the-data-queue-as-rejections. §Receiver-
sees-it-as-an-iterator-result-rejection.

§Done-flag-on-return: `{value, done: true}`. §Reader-sees-
done-and-can-stop-iterating.

§Shallow-freeze-because-typed-arrays-are-not-freezable: the
wrapper `{value, done}` is frozen but `value` itself isn't.
§Defensive-against-typed-array-edge-case.
