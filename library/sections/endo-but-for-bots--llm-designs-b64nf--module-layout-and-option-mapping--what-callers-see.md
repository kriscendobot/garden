---
title: What callers see
source: designs/base64-native-fallthrough.md
source_repo: endojs/endo-but-for-bots
source_branch: llm
source_commit: 102a94bc9a36cac4d98ca24bc7c6e3dd9820d2a3
source_date: 2026-04-23
source_authors: [Kris Kowal]
topics: [tooling, hardened-javascript]
status: current
parent: endo-but-for-bots--llm-designs-b64nf--module-layout-and-option-mapping
---

All existing import and call sites stay unchanged:

```js
// @endo/platform/fs/reader-ref.js, @endo/daemon/src/reader-ref.js
import { encodeBase64 } from '@endo/base64';

// @endo/import-bundle/src/index.js, @endo/check-bundle/lite.js
import { decodeBase64 } from '@endo/base64';

// @endo/bundle-source/src/zip-base64.js
const endoZipBase64 = encodeBase64(bytes);
```

`btoa` and `atob` continue to be thin wrappers over the dispatched
`encodeBase64` / `decodeBase64`, so they inherit native-path
performance automatically. No consumer passes a second argument to
`encodeBase64`; `decodeBase64` is occasionally called with a `name`
for error-context purposes — that argument is silently ignored on
the native path (see the next section).
