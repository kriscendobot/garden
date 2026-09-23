---
title: "`ENDO_BASE64_FORCE` — test-only env-variable gate"
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

```js
// src/select.js
const force = typeof process !== 'undefined' && process.env
  ? process.env.ENDO_BASE64_FORCE
  : undefined;

export const forcedPath =
  force === 'native' || force === 'polyfill' ? force : undefined;
```

- `ENDO_BASE64_FORCE=polyfill` — always use `jsEncodeBase64` /
  `jsDecodeBase64`, even when the native intrinsics are present.
- `ENDO_BASE64_FORCE=native` — always use the native path; throw at
  module load if the intrinsics are absent.
- Unset — use native if present, else polyfill.

**The gating is a test-only affordance.** In production the env var
is unset and detection is automatic.

The design rules out a `globalThis` flag explicitly: *"that would
create a footgun: any tenant in a multi-tenant realm could flip the
switch at module load."* An import-time flag would force every
consumer into deciding the path. An environment variable keeps the
affordance out of the code path that ships to production.
