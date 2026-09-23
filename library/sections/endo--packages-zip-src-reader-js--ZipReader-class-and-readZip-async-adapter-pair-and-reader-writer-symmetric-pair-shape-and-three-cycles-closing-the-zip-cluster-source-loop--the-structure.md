---
title: The structure
section-slug: endo--packages-zip-src-reader-js--ZipReader-class-and-readZip-async-adapter-pair-and-reader-writer-symmetric-pair-shape-and-three-cycles-closing-the-zip-cluster-source-loop
source-slug: endo--packages-zip-src-reader-js
url: https://github.com/endojs/endo/blob/master/packages/zip/src/reader.js
authors: [Endo project (collective)]
repo: endojs/endo
path: packages/zip/src/reader.js
total-lines: 60
ingest-cycle: 284
ingest-date: 2026-06-10
lane: chat
scope: full
parent: endo--packages-zip-src-reader-js--ZipReader-class-and-readZip-async-adapter-pair-and-reader-writer-symmetric-pair-shape-and-three-cycles-closing-the-zip-cluster-source-loop
---

```
import { BufferReader } from './buffer-reader.js';
import { readZip as readZipFormat } from './format-reader.js';

export class ZipReader {
  constructor(data, options = {}) {
    const { name = '<unknown>' } = options;
    // @ts-expect-error missing properties from ArrayBuffer
    const reader = new BufferReader(data);
    this.files = readZipFormat(reader);
    this.name = name;
  }
  read(name) {  // throws on missing
    const file = this.files.get(name);
    if (file === undefined) {
      throw Error(`Cannot find file ${name} in Zip file ${this.name}`);
    }
    return file.content;
  }
  stat(name) {  // returns undefined on missing
    const file = this.files.get(name);
    if (file === undefined) {
      return undefined;
    }
    return { type: file.type, mode: file.mode, date: file.date, comment: file.comment };
  }
}

export const readZip = async (data, location) => {
  const reader = new ZipReader(data, { name: location });
  /** @type {import('./types.js').ReadFn} */
  const read = async path => reader.read(path);
  return { read };
};
```

**Two named modes of access**, exactly paralleling writer.js:

| Aspect | writer.js (cycle 280) | reader.js (cycle 284) |
|---|---|---|
| Class | `ZipWriter` (sync mutable) | `ZipReader` (sync) |
| Async adapter | `writeZip(files): Promise<Uint8Array>` | `readZip(data, location): Promise<ArchiveReader>` |
| Class surface | `write` + `snapshot` | `read` + `stat` |
| Adapter surface | snapshot bytes | `{ read }` (narrowed; no stat) |
| Imports | `@import` at file top | inline `import('./types.js').X` |
| `// @ts-check` | yes | yes |
| Lines | 264 | 60 |
| `import-rename-to-avoid-collision-with-export` | yes (`writeZip as writeZipFormat`) | yes (`readZip as readZipFormat`) |
