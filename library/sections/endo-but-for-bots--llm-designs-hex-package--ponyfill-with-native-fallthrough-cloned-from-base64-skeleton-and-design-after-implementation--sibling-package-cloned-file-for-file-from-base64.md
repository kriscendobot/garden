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
title: §Sibling-package-cloned-file-for-file from base64
parent: endo-but-for-bots--llm-designs-hex-package--ponyfill-with-native-fallthrough-cloned-from-base64-skeleton-and-design-after-implementation
---

```
packages/hex/
  CHANGELOG.md
  LICENSE
  README.md
  SECURITY.md
  index.js               # Re-exports encodeHex, decodeHex
  encode.js              # Re-export of src/encode.js
  decode.js              # Re-export of src/decode.js
  src/
    common.js            # Shared alphabet constants, freeze()
    encode.js            # jsEncodeHex + encodeHex with native short-circuit
    decode.js            # jsDecodeHex + decodeHex with native short-circuit
  test/
    main.test.js
    _bench-main.js
  package.json
  tsconfig.json
  tsconfig.build.json
  typedoc.json
```

§Mirrors-packages-base64-file-for-file. §The-design-explicitly-
states-this: "Mirrors `packages/base64/` file-for-file". §`@endo/
base64` is the §canonical-leaf-package-skeleton; §every-future-
leaf-ponyfill should clone its shape.

§Three-files-omitted-from-the-clone: `atob.js`, `btoa.js`,
`shim.js`. §Why: those exist in `@endo/base64` to provide globals
the browser platform already defines for base64 (the legacy BOM
shim). §There-are-no-hex-equivalents-in-any-host-environment, so
the shim surface is absent. §A-future-shim.js-can-install-TC39-
methods if needed. §This-is-§deliberate-omission-not-oversight —
the design names what was deliberately *not* cloned and why.
