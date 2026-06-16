---
source: packages/base64/src/{encode,decode,common}.js + index.js
source_repo: endojs/endo
source_url: https://github.com/endojs/endo/tree/master/packages/base64
source_path: packages/base64/src/encode.js, packages/base64/src/decode.js, packages/base64/src/common.js, packages/base64/index.js
section_kind: source
ingested: 2026-06-03
ingested_by: scholar
contributors:
  - Kris Kowal (prompted)
topics:
  - hardened-javascript
  - tooling
genre: §endo-source-comment-fragment §canonical-leaf-package-pattern
cycle: 181
lane: chat
status: current
title: The canonical leaf-package skeleton with three-tier dispatch, Reflect.apply defensive binding, and native-error fallback via polyfill rerun
parent: endo--packages-base64-src-encode-decode-js--the-canonical-leaf-package-skeleton-with-three-tier-dispatch-and-Reflect-apply-defensive-binding
---

> §Chat-lane after cycle 180's designs-lane. §Endo-source-
> comment-fragment genre. §The-fifteenth-consecutive designs/
> chat alternation cycle (166-181). §Cycle-180's hex-package
> design named `@endo/base64` as the §canonical-leaf-package-
> skeleton; §this-cycle-reads-the-actual-source to see what
> *makes* it canonical.

`packages/base64/src/encode.js` (126 lines) + `decode.js` (165
lines) + `common.js` (22 lines) + `index.js` (14 lines) =
327 lines. §The-package-that-`@endo/hex`-cloned-file-for-file.
§This-cycle's-ingest-reveals-which-disciplines-the-clone-
preserved and which it §simplified-because-hex-doesn't-need-
them.

§The-single-most-structurally-interesting-move is §three-tier-
dispatch-with-Reflect.apply-defensive-binding combined with
§native-error-fallback-via-polyfill-rerun (decoder side). §The-
hex-package-clone-omits-the-middle-tier (no legacy XS hex
binding exists) and §uses-error-rewrapping-instead-of-polyfill-
rerun for stable diagnostics.
