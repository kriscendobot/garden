---
source: packages/lp32/{reader,writer}.js
source_repo: endojs/endo
source_url: https://github.com/endojs/endo/tree/master/packages/lp32
source_path: packages/lp32/reader.js, packages/lp32/writer.js, packages/lp32/src/host-endian.js
section_kind: source
ingested: 2026-06-03
ingested_by: scholar
contributors:
  - Kris Kowal (prompted)
topics:
  - streams
  - captp
genre: §endo-source-comment-fragment
cycle: 179
lane: chat
status: current
title: §Hardened-throughout
parent: endo--packages-lp32-reader-writer-js--host-endian-length-prefix-framing-as-same-host-IPC-discipline
---

```js
const writer = harden({
  /** @param {Uint8Array} message */
  async next(message) { ... },
  async return() { ... },
  async throw(error) { ... },
  [Symbol.asyncIterator]() { return writer; },
});
return writer;
};
harden(makeLp32Writer);
```

§Writer-object-hardened-after-construction. §`makeLp32Writer`-
factory-also-hardened. §`makeLp32Reader`-similarly:

```js
export const makeLp32Reader = (reader, options) => {
  return harden(makeLp32Iterator(reader, options));
};
harden(makeLp32Reader);
```

§Cycle-175-make-selector.js named §race-to-install-harden;
§lp32-is-a-consumer-of-that-discipline. §Both-the-factory-and-
the-resulting-iterator-are-hardened-so-callers-cannot-tamper-
with-the-message-handling-machinery-mid-stream.

§The-iterator-itself-is-hardened-via-`harden(makeLp32Iterator(reader, options))` —
the returned async generator object is frozen. §Generators-
have-mutable-state-by-construction (their internal pause/
resume bookkeeping); §harden-cannot-stop-the-generator-from-
advancing, but it can stop callers from monkey-patching the
generator's methods.
