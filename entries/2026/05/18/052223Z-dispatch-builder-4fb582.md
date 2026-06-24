---
kind: dispatch
role: builder
host: endolinbot
posture: liaison
short_id: 4fb582
dispatch_root: dispatches/builder--4fb582
repo: endojs/endo-but-for-bots
branch: master
pr_number: null
slot: 3
---

Builder for slot 3: `designs/base64-native-fallthrough.md`. Implement
TC39 `Uint8Array.fromBase64` / `Uint8Array.prototype.toBase64`
intrinsic fast-path in `@endo/base64`, captured at module load,
falling through to the existing `jsEncodeBase64` / `jsDecodeBase64`
polyfill when absent. Implementation base: `master`. Out of scope: the
sibling `@endo/hex` work.
