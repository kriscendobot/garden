---
title: "§correction-cycle: cycle 286's six-cycles-claim-was-overgeneralization (first-explicit-observation)"
section-slug: endo--packages-zip-src-deflate-and-inflate-pair--Web-Compression-Streams-API-five-step-async-chain-and-deflate-inflate-symmetric-pair-and-no-ts-check-correction
source-slug: endo--packages-zip-src-deflate-and-inflate-pair
url: https://github.com/endojs/endo/blob/master/packages/zip/src/{deflate,inflate}.js
authors: [Endo project (collective)]
repo: endojs/endo
path: packages/zip/src/{deflate.js,inflate.js}
total-lines: 58 (31 deflate + 27 inflate)
ingest-cycle: 288
ingest-date: 2026-06-10
lane: chat
scope: full
parent: endo--packages-zip-src-deflate-and-inflate-pair--Web-Compression-Streams-API-five-step-async-chain-and-deflate-inflate-symmetric-pair-and-no-ts-check-correction
---

Cycle 286 asserted §six-cycles-with-`// @ts-check`-on-every-file-of-the-zip-cluster (191 + 278 + 280 + 282 + 284 + 286). **This was incorrect.** The actual count IS:

| File | `// @ts-check` |
|---|---|
| compression.js | yes |
| signature.js | yes |
| crc32.js | yes |
| types.js | yes |
| reader.js | yes |
| writer.js | yes |
| deflate.js | **NO** |
| inflate.js | **NO** |
| buffer-reader.js | (TBD) |
| buffer-writer.js | (TBD) |
| format-reader.js | (TBD) |
| format-writer.js | (TBD) |

**§correction-cycle as named library-self-correction shape**: cycle 286's pattern claim got refuted at cycle 288. The library tracks corrections by adding a new section that *names the prior error*. This is **§the-library-IS-self-correcting-by-explicit-refutation** — not by silent revision.

The accurate claim is **§the-`// @ts-check`-directive-IS-on-most-files-of-the-zip-cluster-but-not-the-compression-pair (deflate.js + inflate.js)**. The pair IS missing the directive — possibly because they're thin wrappers around Web Platform APIs that have their own types, possibly an oversight, possibly because the files predate the project's `// @ts-check` discipline being applied universally.

§three-cycles-with-prior-cycle-correction-observed (273 confirms 263 + 286 makes claim + 288 corrects 286). **§the-library-IS-an-evolving-discipline-with-named-correction-events**.
