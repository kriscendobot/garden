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
title: §pump with tick/tock mutual recursion
parent: endo--packages-stream-index-js--symmetric-async-iterator-streams-with-makeQueue-makePipe-pump-and-prime-utilities
---

```js
export const pump = async (writer, reader, primer) => {
  const tick = promise =>
    E.when(promise, result => {
      if (result.done) return writer.return(result.value);
      return tock(writer.next(result.value));     // mutual recursion
    }, error => writer.throw(error));
  const tock = promise =>
    E.when(promise, result => {
      if (result.done) return reader.return(result.value);
      return tick(reader.next(result.value));
    }, error => reader.throw(error));
  await tick(reader.next(primer));
};
```

§Behold-mutual-recursion (literal comment in the code).

§tick processes a reader-result; calls writer.next; passes
the writer's ack-promise to tock.
§tock processes a writer-result; calls reader.next; passes
the reader's ack-promise to tick.

§Two-functions-name-the-two-roles in the handshake. §The-
cycle-of-promises-walks-the-pump.

§E.when-not-await: §let-this-work-on-remote-eventual-send-
values. The pump can drive a stream where one end is across
a CapTP connection (cycle 137's daemon-message-streaming
relies on this).

§Done-propagates: when either side returns done, the other
side is closed via .return(). §Symmetric-shutdown.

§Errors-propagate-via-.throw: §errors-on-one-side-close-
the-other-with-throw.

§Primer-is-the-first-value-the-reader-receives: §the-
reader-needs-to-be-told-something-to-start.
