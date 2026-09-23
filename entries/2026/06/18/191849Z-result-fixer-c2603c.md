---
ts: 2026-06-18T19:18:49Z
kind: result
role: fixer
repo: endojs/endo-but-for-bots
project: endo
refs:
  - https://github.com/endojs/endo-but-for-bots/pull/468#discussion_r3438331480
---

Addressed erights' inline comment 3438331480 on PR #468 shim.js line 81.

The comment was made at commit 41dae21cd on code that used `Reflect.ownKeys`
with a comment mentioning only the Symbol-keys reason. erights noted the
additional reason: `Object.entries` also skips non-enumerable properties.

However, the very next commit (0731350c6, "refactor: stop freezing lib
descriptors per erights review") removed the `Reflect.ownKeys` loop entirely.
By stopping the freeze of the lib descriptor record in lib.js, the descriptors
are already configurable and writable, making the descriptor-reopening loop
unnecessary. shim.js now calls `getOwnPropertyDescriptors` + `defineProperties`
directly, making the `Object.entries` vs `Reflect.ownKeys` question moot.

No code change was needed. Replied on the thread (comment 3438354316)
explaining the supersession and acknowledging both of erights' stated reasons
(Symbol keys and non-enumerable properties) for future reference.

Self-improvement: nothing this time.
