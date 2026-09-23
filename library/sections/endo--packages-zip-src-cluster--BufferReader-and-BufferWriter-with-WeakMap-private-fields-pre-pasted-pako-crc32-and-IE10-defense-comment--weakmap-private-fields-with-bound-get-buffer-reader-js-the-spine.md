---
source: packages/zip/src/{buffer-reader,buffer-writer,crc32,signature,compression,reader,writer}.js + index.js
source_repo: endojs/endo
source_url: https://github.com/endojs/endo/tree/master/packages/zip/src
source_path: packages/zip/index.js, packages/zip/src/buffer-reader.js, packages/zip/src/buffer-writer.js, packages/zip/src/crc32.js, packages/zip/src/signature.js, packages/zip/src/compression.js, packages/zip/src/reader.js, packages/zip/src/writer.js
section_kind: source
ingested: 2026-06-04
ingested_by: scholar
contributors:
  - Kris Kowal (prompted)
topics:
  - bundles
  - tooling
genre: §endo-source-comment-fragment §canonical-byte-format-package
cycle: 191
lane: chat
status: current
title: §WeakMap-private-fields-with-bound-get (buffer-reader.js, the spine)
parent: endo--packages-zip-src-cluster--BufferReader-and-BufferWriter-with-WeakMap-private-fields-pre-pasted-pako-crc32-and-IE10-defense-comment
---

```js
/** @type {WeakMap<BufferReader, BufferReaderState>} */
const privateFields = new WeakMap();

const privateFieldsGet =
  /** @type {(bufferReader: BufferReader) => BufferReaderState} */ (
    privateFields.get.bind(privateFields)
  );

export class BufferReader {
  constructor(buffer) {
    const bytes = new Uint8Array(buffer);
    const data = new DataView(bytes.buffer);
    privateFields.set(this, {
      bytes,
      data,
      length: bytes.length,
      index: 0,
      offset: 0,
    });
  }
  // ... uses privateFieldsGet(this) throughout
}
```

§The-pattern: module-private WeakMap + pre-bound `.get`
method captured as `privateFieldsGet`. §Every-method-does
`const fields = privateFieldsGet(this)` to access private
state.

§Why-not-`#privateField`-class-syntax: SES-locks-down. §JS-
private-fields use a per-class WeakMap internally; under SES
that mechanism is fine but the §explicit-WeakMap-pattern
predates wide JS-private-field availability and is §still-
the-canonical-Endo-discipline. §Compare-to-cycle-187-shim-
cluster's §postponedHandler-with-interlockP — both are
§module-private-state-with-explicit-mechanism.

§The-§bind-once-at-module-load optimization: `privateFields
.get.bind(privateFields)` produces a function that doesn't
need to look up `.get` on the WeakMap each call. §Compare-to-
cycle-181-base64's §Reflect.apply-captured-at-module-load and
cycle 183-init's §native-bound-at-module-load. §All-three-
are-§module-load-capture-of-primitive-method patterns.

§The-buffer-writer.js variant uses a slightly different shape:

```js
const getPrivateFields = self => {
  const fields = privateFields.get(self);
  if (!fields) {
    throw Error('BufferWriter fields are not initialized');
  }
  return fields;
};
```

§Adds-runtime-check for `undefined` (the writer can be
constructed before private fields are set in some
flows). §The-reader-doesn't-bother because constructor-
order-guarantees fields exist by the time methods run.
§Asymmetric-defense-based-on-construction-invariant.
