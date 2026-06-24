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
title: §Cohesion notes
parent: endo--packages-zip-src-cluster--BufferReader-and-BufferWriter-with-WeakMap-private-fields-pre-pasted-pako-crc32-and-IE10-defense-comment
---

- §WeakMap-private-fields-with-bound-get is the §Endo-
  canonical-discipline for module-private state. The bound
  `.get` is §captured-at-module-load (cycle 181/183 sibling).
- §Asymmetric-defense: buffer-reader trusts the constructor
  to initialize fields; buffer-writer checks for `undefined`
  and throws. §Different-construction-invariants justify
  different defenses.
- §Pre-pasted-pako-crc32-with-attribution-comment names the
  source-file + license + URL. §Audit-trail-in-source.
- §IE10-defense-comment-for-historical-ghost names a dead-
  platform's bug + the defensive fix. §Don't-silently-remove-
  defenses-for-dead-platforms; name them and let the next
  reader decide.
- §STORE-only-zip is the §scope-limitation-named-in-tiny-file
  (4 lines: `export const STORE = 0;`).
- §u-helper compresses 4-line Uint8Array-from-string into one
  call. §Six-canonical-zip-signatures use it. §`& 0xff`
  defensive-against-non-ASCII.
- §Math.max-Math.min-clamp-idiom for `[0, max]` bounding.
- §Five-state-BufferReader (bytes + data + length + index +
  offset) with §offset+index-pair for sub-window-without-
  copying.
- §Doubling-capacity-with-ensureCanSeek in BufferWriter;
  §DataView-rebuild after capacity-change.
- §assertNatNumber for §Number.isSafeInteger + non-negative
  check.
- §DOS-date-time-six-bit-fields with §`@see`-URLs to Ralph-
  Brown-Interrupt-List.
- §`isEncrypted` bit-flag detection without decryption
  support (encrypted-entry refused).
- §MAX_VALUE_16BITS + §MAX_VALUE_32BITS for ZIP64 awareness;
  §read-tolerant-write-strict (read ZIP64, write classic).
- §`@ts-expect-error` for ArrayBuffer-vs-Uint8Array type-
  surface mismatch.
- §Fourteenth-member-of-§small-files-with-large-knowledge-
  density family if measured by §discipline-density-per-line.
- §Cycle-186-Cut-3-target (vestigial @endo/zip devDeps were
  deleted). The zip package is the §simplest-leaf in cycle
  186's SCC-break analysis.
