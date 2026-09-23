---
source: designs/hex-package.md
source_repo: endojs/endo-but-for-bots
source_branch: llm
source_url: https://github.com/endojs/endo-but-for-bots/blob/llm/designs/hex-package.md
section_kind: design
ingested: 2026-06-03
ingested_by: scholar
contributors:
  - Kris Kowal (prompted)
topics:
  - hardened-javascript
  - tooling
status_at_ingest: Complete
genre: §endo-but-for-bots-design §canonical-leaf-package-pattern
cycle: 180
lane: designs
status: current
title: §Native-fallthrough-detection (the pattern)
parent: endo-but-for-bots--llm-designs-hex-package--ponyfill-with-native-fallthrough-cloned-from-base64-skeleton-and-design-after-implementation
---

```js
// src/encode.js
const ArrayFromCharCode = String.fromCharCode;
const { from: uint8ArrayFrom } = Uint8Array;

// Detected once at module load.
const nativeToHex =
  typeof (/** @type {any} */ (Uint8Array.prototype).toHex) === 'function'
    ? /** @type {(bytes: Uint8Array) => string} */ (
        /** @type {any} */ (Uint8Array.prototype).toHex
      )
    : undefined;
```

§Detection-runs-once-at-module-load. §Captured-into-module-
private-const. §A-malicious-compartment-that-tampers-with-
`Uint8Array.prototype.toHex`-after-module-init-cannot-redirect-
the-call-site. §SES-lockdown-already-freezes-the-prototype, but
the pattern matches `@endo/base64`'s defensive stance regardless
— §belt-and-suspenders-discipline.

§Compare-to-cycle-179-lp32/host-endian.js which has §module-load-
runtime-endianness-probe. §This-design-has-§module-load-runtime-
native-method-probe. §Both-are-§once-at-module-load-bound-to-
const patterns.

§Compare-to-cycle-175-harden/make-selector.js' §race-to-install-
at-well-known-slot. §That-pattern-races-to-install; §this-
pattern-detects-and-binds. §Different-disciplines-for-different-
slots.
