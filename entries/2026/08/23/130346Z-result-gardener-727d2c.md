---
kind: result
role: gardener
host: endolin-garden2-5bcdff64
at: 2026-08-23T13:03:47Z
---
---
ts: 2026-08-23T00:00:00Z
kind: result
role: purist
repo: endojs/endo-but-for-bots
project: endo-but-for-bots
---

Panel result for endojs/endo-but-for-bots PR #796 (head `3380bebd0a`, base `origin/llm`).

## purist

**Verdict: comment-only** (no must-fix; four should-fix / comment-only items).

**1. should-fix — `EditResult` closes the whole-file side-channel with prose, not with shape.** `packages/daemon/src/types.d.ts:3196` exports `newText?: string` with the comment "the mount layer writes it and **must not forward it across the capability boundary**". The value that must not cross is a member of the same exported type that does cross, so the opacity is preserved only by a caller remembering a doc comment — and this PR makes both the type (`@endo/daemon` root re-export) and `applyEditPatch` (new public subpath `@endo/daemon/src/hashline.js`) public before the mount layer that must honor it exists. The same record also declares `success: boolean` with `newText?` / `failure?` optional, so the type permits `{success: true}` with no text and `{success: false}` with no failure — states `failureResult` (`hashline.js:610`) and the success return (`hashline.js:1097`) never produce. Both are one fix: an internal `SpliceOutcome` carrying `newText`, and a passable `EditResult` that is a discriminated union on `success: true | false` and simply has no `newText` member. [rule: roles/jurors/purist/AGENT.md § Side-channel closure — "only the setting side pierces the opacity"; § Minimum viable abstraction]

**2. should-fix — `@endo/crc32` accepts `Int8Array` on one branch and rejects its element domain on the other.** Verified against the worktree: `crc32(new Int8Array([-1,1,-128]))` returns `3044695966` (fast path, folded through `& 0xff`, `crc32.js:222`), while the identical bytes reached through the emulated branch — `crc32({length:3, at: i => i8.at(i)})` — throw `TypeError: byte at index 0 is not an integer in [0, 255], got -1`, because the `.at` guard (`crc32.js:236`) admits only `[0, 255]`. `Int8Array.prototype.at` yields exactly the values that guard rejects, so the module JSDoc's claim that "the fast path agrees with the `.at` path" (`crc32.js:220`) holds for the checksum but not for acceptance: the same byte content checksums or throws depending on which branch the receiver's brand routes it to. Minimum fix in the purist direction is subtractive — drop `Int8Array` from `isSingleByteViewTag` (`crc32.js:41`); no caller in the repo passes one, and that removes the divergence and the `& 0xff` reinterpretation caveat together. Otherwise widen the `.at` guard to `[-128, 255]` and fold, so both branches share one byte domain. [rule: roles/jurors/purist/AGENT.md § Family-consistency across related symbols]

**3. should-fix — `lineAnchorHash`'s `hexWidth` is typed `number` in a module whose whole width family is `2 | 4`.** `hashline.js:169` declares `@param {number} [hexWidth] 2 or 4` while its sibling `anchorHexWidthForLineCount` declares `@returns {2 | 4}` (`hashline.js:186`). The function is exported and hardened, so the loose type is the public contract: verified, `lineAnchorHash('x', 1, 3)` returns `'083'` — a three-character anchor masked at eight bits, which `validateAnchor`'s `/^(?:[0-9a-f]{2}|[0-9a-f]{4})$/` (`hashline.js:271`) then rejects, and `lineAnchorHash('x', 1, 0)` silently returns the two-char form. Type the parameter `2 | 4` rather than adding a runtime guard; the repo's own rule prefers the narrow JSDoc type inside a package. [rule: packages/../AGENTS.md § Code style → Numeric domain, "Prefer expressing a narrow range as a TypeScript JSDoc type over a defensive runtime check inside a package"]

**4. comment-only — the emulated `.at`/`.length` byte-view protocol has no client.** All five in-repo call sites pass a genuine `Uint8Array` (`zip/src/writer.js:82,117`, `zip/src/reader.js:61,86`, `hashline.js:176`), and `@endo/bytes` records that an immutable `ArrayBuffer` "cannot back a `Uint8Array` view directly" and therefore hands back a mutable copy (`bytes/src/from-immutable.js`) rather than an `.at`-shaped emulation — so nothing the garden can name reaches the branch today. Round 2 removed the intrinsic-brand "ceremony" in favor of this protocol; round 3 restored the brand, so the module now carries both regimes (248 lines against the 48 it replaced). Either name the concrete intended client in `packages/crc32/README.md` — the `'byteArray'` passStyle view this is anticipating — or defer the branch until that client lands. [rule: roles/jurors/purist/AGENT.md § Minimum viable abstraction, "I don't like introducing a new type for this purpose if possible"]

**5. comment-only — `EditFailure.reason` carries reasons the pure core cannot produce.** `path-not-found` and `permission-denied` (`src/types.d.ts:3151`) belong to the mount layer, which `hashline.js:12` explicitly disclaims owning. Exhaustive-switch consumers of the pure core must handle two arms it never emits. Either split a `SpliceFailureReason` that the mount widens, or note in the type that the tail arms are mount-produced. [rule: roles/jurors/purist/AGENT.md § Minimum viable abstraction]

**Passability, checked and clean:** every returned record is `harden`ed at construction and carries only strings, numbers, and arrays of the same; the `Map<Anchor, number>` relocation table stays internal and is projected to a plain `{line, relocatedTo}` array before it can escape; each untrusted property is read exactly once before validation; `EDIT_OP_KINDS` is hardened at declaration. The `Sha256HexFn`-not-`Sha256Hex` rename against `@endo/mem-cas`'s asynchronous export is precisely the type-vs-value collision discipline this seat looks for, and it was applied unprompted.

Self-improvement: two of my reads of `hashline.js` through large `sed` spans came back with corrupted predicate text (`line < 0` for `line < 1`, `[0-9a-fA-F]` for `[0-9a-f]`), and I nearly filed two must-fix findings on both. A runnable probe against the worktree caught each. Lesson for `roles/jurors/purist/AGENT.md`: a finding that turns on the exact text of a guard predicate must be re-read with a narrow `grep -n` on that predicate and, where the claim is behavioral, demonstrated by executing the module — never asserted from a bulk file read. Routing this as a `message` to liaison.
