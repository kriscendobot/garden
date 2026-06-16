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
title: §The-`readDosDateTime` (the §legacy-format-quirk)
parent: endo--packages-zip-src-cluster--BufferReader-and-BufferWriter-with-WeakMap-private-fields-pre-pasted-pako-crc32-and-IE10-defense-comment
---

```js
function readDosDateTime(reader) {
  const dosTime = reader.readUint32(true);
  return new Date(
    Date.UTC(
      ((dosTime >> 25) & 0x7f) + 1980, // year
      ((dosTime >> 21) & 0x0f) - 1, // month
      (dosTime >> 16) & 0x1f, // day
      (dosTime >> 11) & 0x1f, // hour
      (dosTime >> 5) & 0x3f, // minute
      (dosTime & 0x1f) << 1, // second
    ),
  );
}
```

§Six-named-bit-fields extracted from a uint32. §Each-line-
has-a-comment naming what it is. §The-§DOS-date-time-format
is from MS-DOS 1980 ("year offset 1980" + "month 1-12" +
"day 1-31" + "hour 0-23" + "minute 0-59" + "second
×2-second"). §The-`<< 1` on seconds is because §DOS-stored-
seconds-at-2-second-precision (so 30 ticks instead of 60).

§The-`@see` URLs:

```js
 * @see http://www.delorie.com/djgpp/doc/rbinter/it/65/16.html
 * @see http://www.delorie.com/djgpp/doc/rbinter/it/66/16.html
```

§Two-attribution-URLs to the Ralph-Brown-Interrupt-List
documentation. §A-1980s-DOS-spec preserved as `@see`-
references. §Compare-to-cycle-181-base64's §RFC-4648-§3.5-
citation. §Both-attribute-format-specs-via-URL.

§Tier-1-borrowing: §legacy-format-quirk-with-bit-fields-and-
attribution-URL. §When-implementing-a-historical-format,
name-the-bit-fields-inline + cite-the-spec.
