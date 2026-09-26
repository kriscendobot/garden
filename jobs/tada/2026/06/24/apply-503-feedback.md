Worktree cleaned (the stray `/tmp/pr503-wt` at the old SHA belongs to another agent — not mine to remove). Job complete.

---

## Completion report — `apply-503-feedback`

**Head SHA:** `daaf8ffe1a5d20b5951b87d9bc5184b69126b60f` (pushed to `feat/passable-byte-arrays`, bot identity `endolinbot`, no identity switch).

### How each feedback point was applied

**Point 1 — Uint8Array packages should function identically regardless of mutability; copy emulated frozen views to mutable before platform calls; use `at`.** Applied to `@endo/bytes`, the consumer package the maintainer pointed at ("as with TextEncoder or TextDecoder"). I empirically confirmed the bug first: a `Uint8Array` built over an emulated immutable `ArrayBuffer` (this PR's freezable wrapper) has `ArrayBuffer.isView === false`, `wrapper[i] === undefined`, `TextDecoder.decode(wrapper)` **throws**, and `out.set(wrapper)` **silently reads zeros** — so `bytesToText`, `bytesEqual`, and `concatBytes` were all broken on emulated wrappers. Fix: a new internal `src/to-genuine.js` exporting `toGenuineBytes(view)` — returns genuine views unchanged (no copy on the common path; `ArrayBuffer.isView` is the discriminator) and copies an emulated wrapper to a fresh mutable `Uint8Array`, reading bytes through `at` since the wrapper has no integer-indexed own properties. The three operators route through it. The pass-style `byteArray` validation already read via the captured `%TypedArrayPrototype%.at`, so it was already aligned. Added 6 AVA cases; package suite **38/38 green**, `eslint` + `tsc` clean. Changeset added (`@endo/bytes`: patch).

**Point 2 — immutable-ArrayBuffer first-initializer-wins shim, no changes.** Untouched.

**Point 3 — possibly drop per-operator ByteArray wrappers at pass-style.** **Judgment call, reported rather than guessed.** There are no per-operator "ByteArray operator wrappers" to remove: pass-style has a single `ByteArrayHelper`, and marshal's byteArray encode/decode paths are still `not yet implemented` (throw). The only structure this could target is the `byteArray` brand check's Uint8Array-on-immutable-buffer arm (`d4b87d12a`) — but that's the load-bearing security validation that makes a frozen `Uint8Array` *passable* at all and is the entire second half of #503. Removing it is a design reversal (passable byteArrays would narrow to immutable-`ArrayBuffer`-only), not a simplification, so I left it intact and flagged it on the PR for an explicit maintainer call.

### CI / verification
`build`, `cover` (full workspace suite + coverage — includes my new `@endo/bytes` tests), and `lint` (full workspace) all **pass**; remaining cross-engine matrix jobs were pending but `cover` already exercised the bytes tests on Node. CI impact is trivial and green — **no `shepherd-ebfb-pr503` job posted** (reserved for non-trivial impact).

### Summary comment
Posted on PR #503: https://github.com/endojs/endo-but-for-bots/pull/503#issuecomment-4794345033

### Follow-ups (out of #503 scope)
- The same indexing/platform-call intolerance likely affects other Uint8Array-consuming packages (`@endo/base64`, `@endo/hex`, `@endo/marshal` once byteArray encoding lands). `toGenuineBytes` is currently internal to `@endo/bytes`; exporting it as a shared ponyfill primitive would serve the maintainer's "ponyfills that tolerate every variant" vision — small follow-up if wanted.
- Point 3 awaits a maintainer decision on whether to keep accepting Uint8Array views as passable byteArrays or narrow to immutable-`ArrayBuffer`-only.
