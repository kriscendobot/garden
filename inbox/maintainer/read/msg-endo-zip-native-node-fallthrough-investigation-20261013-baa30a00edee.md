from_host: oros-studio-garden-ce242c49
from: gardener:endo-zip-native-node-fallthrough-investigation-20261013
reply_to: endo-zip-native-node-fallthrough-investigation-20261013
msg_key: msg-endo-zip-native-node-fallthrough-investigation-20261013-baa30a00edee
notice_count: 1
first_seen: 2026-10-18T19:39:58Z
last_seen: 2026-10-18T19:40:03Z
sent_at: 2026-10-18T19:40:03Z
---
Finding: @endo/zip native-Node ZIP fall-through (endojs/endo-but-for-bots @ llm). Recommendation: DO NOT proceed.

- Node 20, 22, and 24 have no native ZIP archive API. Node 26.8.0+ (2026-08-26) adds `zlib.ZipBuffer`/`ZipFile`/`ZipEntry`/`createZipArchive*`. It is at "Stability 1.0 Early development", prints an ExperimentalWarning, and has received hardening fixes in each of 26.9–26.12.
- @endo/zip's deflate layer already uses native code on Node: CompressionStream is backed by zlib, and its output is byte-identical to `deflateRawSync` on 22, 24, and 26.
- Parity harness, measured on Node 26.12.0:
  - Write: 0/9 cases byte-identical. Every case differs at the version-needed field. Node also adds a UT extra field for odd-second timestamps, falls back to store automatically, and defaults the timestamp to "now", so its output is non-deterministic.
  - Read: native accepts 5 hostile or malformed inputs that Endo deliberately rejects: an archive comment, trailing data, a local/central name mismatch, and the encrypted flag at open. 7 inputs succeed on both but give different results (timestamps, CP437 names, symlinks, directories, zstd, size cap). Error shapes always differ (ERR_ZIP_* codes vs prose messages).
- Engine recognition:
  - An `engines`-gated optionalDependency is not enforced by Yarn 4.13 (measured: the lockfile gets no `conditions`, unlike `cpu`). It also describes the install-time Node, not the runtime one.
  - The only reliable selector is the `node` export condition plus a runtime feature/version check, which falls back safely to pure JS.
  - The native API works under SES lockdown.
- Revisit only when the API is Stable and the oldest supported Node ships it, and then only as an opt-in.
- Possible small follow-up (not posted): an opt-in `@endo/zip/node.js` exporting `inflateNow`/`deflateNow` via `zlib.*RawSync`.

Full report, harness, and results: journal2 `projects/endo-but-for-bots/research/zip-native-fallthrough-20261013/` (README.md, parity.mjs, results-node26.jsonl).
