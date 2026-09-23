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
title: §Tier-1 borrowing
parent: endo--packages-base64-src-encode-decode-js--the-canonical-leaf-package-skeleton-with-three-tier-dispatch-and-Reflect-apply-defensive-binding
---

- §three-tier-dispatch-with-IIFE-bound-at-module-load (native →
  legacy → fallback)
- §Reflect.apply-captured-at-module-load (defensive against
  Function.prototype.call tampering)
- §native-intrinsic-captured-before-lockdown
- §strict-options-pinning-via-frozen-bag (lastChunkHandling +
  alphabet)
- §native-error-fallback-via-polyfill-rerun (use polyfill as
  error oracle)
- §adapter-for-legacy-platform-shape-normalization (legacy XS
  ArrayBuffer → Uint8Array)
- §bit-register-quantum-accumulator (non-byte-aligned codec
  algorithm)
- §three-class-padding-switch with §internal-bad-quantum
  sanity-throw
- §padding-acceptance-RFC-citation (§don't-over-validate-by-
  default-with-named-authority)
- §three-class-decode-error-shapes (invalid char / missing
  padding / trailing garbage; all embed `name`)
- §Object.freeze-not-harden-for-pre-lockdown-shim-safety
- §monodu-etymology-as-comment (§code-comment-as-vocabulary-
  instruction)
