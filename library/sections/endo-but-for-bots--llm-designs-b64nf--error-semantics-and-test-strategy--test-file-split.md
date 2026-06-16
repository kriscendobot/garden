---
title: Test file split
source: designs/base64-native-fallthrough.md
source_repo: endojs/endo-but-for-bots
source_branch: llm
source_commit: 102a94bc9a36cac4d98ca24bc7c6e3dd9820d2a3
source_date: 2026-04-23
source_authors: [Kris Kowal]
topics: [tooling, testing]
status: current
parent: endo-but-for-bots--llm-designs-b64nf--error-semantics-and-test-strategy
---

The existing `test/main.test.js` is split:

```
test/
  main.test.js              # Unchanged: round-trip tests (native or polyfill)
  invalid-polyfill.test.js  # Polyfill-specific error-message regexes
  invalid-native.test.js    # Native-path error-type assertions only
  _runtime-gate.js          # MIN_NODE_WITH_BASE64_INTRINSIC constant
```

```json
"test": "yarn test:native && yarn test:polyfill",
"test:native":   "ENDO_BASE64_FORCE=native   ava",
"test:polyfill": "ENDO_BASE64_FORCE=polyfill ava"
```

CI matrix runs *both* invocations on every supported Node version.
On Node versions that pre-date the native intrinsics, `test:native`
is skipped via a `process.version` guard. On XS-based runners, both
paths are exercised if XS ships the intrinsics; otherwise only the
polyfill path runs.
