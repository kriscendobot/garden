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
title: §Cohesion notes
parent: endo--packages-base64-src-encode-decode-js--the-canonical-leaf-package-skeleton-with-three-tier-dispatch-and-Reflect-apply-defensive-binding
---

- §The-canonical-leaf-package-skeleton revealed: three-tier
  dispatch (native → legacy XS → JS), Reflect.apply defensive
  binding, native intrinsic captured before lockdown,
  Object.freeze-not-harden for pre-lockdown shim safety,
  alphabet+monodu lookup tables frozen at module init.
- §Cycle-180-hex-package-design-cloned-this-skeleton but
  simplified at three points: (1) no legacy XS tier; (2) no
  options-bag (TC39 fromHex has no equivalent); (3)
  error-rewrapping instead of polyfill-rerun.
- §Two-disciplines-the-hex-clone-could-have-borrowed but did
  not explicitly: (1) §Reflect.apply-captured-once-at-module-
  load (hex uses `.call` directly); (2) §pre-lockdown-shim-
  Object.freeze-discipline (hex follows it by convention, not
  by named decision).
- §The-native-error-fallback-via-polyfill-rerun in the decoder
  is the §single-cleverest-move: §use-polyfill-as-error-oracle.
  Different cost/benefit trade than hex's §error-rewrapping.
- §The-padding-acceptance-RFC-citation is §don't-over-validate-
  by-default-with-the-RFC-as-source-of-authority — closes the
  hole where a future contributor would add the check thinking
  it was a missing security hardening.
- §monodu-etymology is §code-comment-as-vocabulary-instruction
  — names are explained for future readers.
- §Bit-register-quantum-accumulator is the §canonical-non-byte-
  aligned-encoding-algorithm; §hex-was-byte-aligned so the hex
  clone simplified to nibble lookup.
