---
kind: result
role: gardener
host: endolin-garden2-5bcdff64
at: 2026-08-23T07:52:40Z
---
---
ts: 2026-08-23T00:00:00Z
kind: result
role: purist
repo: endojs/endo-but-for-bots
project: endo-but-for-bots
---

Panel seat `purist`, PR #796 (`feat/hashline-core`), diff base `origin/llm`.

### purist

**Verdict:** request-changes

**Findings:**

- `packages/crc32/src/crc32.js:88-101` — the `ArrayBuffer.isView` fast path accepts *any* view, not just a byte view, and reads it by index with no validation. `crc32(new DataView(buf), 8)` returns `1696784233` — byte-identical to `crc32(new Uint8Array(8))`, the CRC of eight zero bytes — because `dv[offset]` is `undefined` and `checksum ^ undefined` folds to `checksum ^ 0`. `Uint16Array`/`Float64Array` likewise fold out-of-range elements through `& 0xff`. This is precisely the "folding to a plausible-but-wrong checksum" the `.at` branch at :103-121 exists to refuse, and the README promises "any genuine `ArrayBuffer` view ... is accepted". A checksum that silently returns a wrong integrity value is worse than one that throws. Gate the fast path on `bytes.BYTES_PER_ELEMENT === 1` (absent on `DataView`, so it falls through to the validating branch). No test covers a non-`Uint8Array` view; `test/crc32.test.js:66` only exercises the proxy case. must-fix [proposed-rule: a fast path taken on a brand check must be narrowed to the brand whose element type the loop actually assumes, never to a supertype that reads as `undefined` or a non-byte]

- `packages/daemon/src/types.d.ts:3182` — `EditResult` is one record with `success: boolean` and all-optional `newText` / `failure` / `relocations`, so `if (result.success)` narrows nothing and every consumer must non-null-assert. The runtime already produces a disjoint union: `failureResult` never sets `newText`, the success return never sets `failure`. Type it as `{ success: true; newText: string; fileHashAfter: string; relocations?: … } | { success: false; fileHashAfter: string; failure: EditFailure }`. should-fix [proposed-rule: a result whose runtime shape is disjoint on a discriminant is typed as a discriminated union, not an all-optional record]

- `packages/daemon/types.d.ts:33,76` — the public type surface of `@endo/daemon` gains bare `Anchor`, `EditOp`, `EditPatch`, `EditResult`, `EditFailure`, `Sha256Hex`. `Anchor` is a very general word claimed for a hashline-specific concept, and the family it joins is domain-prefixed (`RemoteControlState`, `StampedMessage`, `SpecialName`). Prefix them `Hashline*` at the re-export. should-fix [rule: roles/jurors/purist/AGENT.md — type-vs-value namespace separation / rename-collisions discipline]

- `packages/daemon/src/hashline.js:135` — `lineAnchorHash` is exported and hardened but never validates `hexWidth`: any value but `4` masks to `0x100` while `padStart(hexWidth)` pads to the *requested* width, so `lineAnchorHash(l, n, 3)` yields a 3-char string no `validateAnchor` regex can accept and `hexWidth = 1` truncates a 2-hex value. Internal callers pass `anchor.hash.length`, so this is a public-surface edge rather than a live bug; reject anything but 2 or 4. should-fix [proposed-rule: an exported hardened function validates its own width/format parameters rather than relying on every internal call site]

**Notes (out of scope but worth flagging):**

- `packages/daemon/src/hashline.js:727-802` — a `replace-range`'s `anchor` and `anchorEnd` relocate independently; only inversion is checked (:795-803). With the default window a 3-line authored range can land consuming 43 lines. `relocations` reports each endpoint's move but nothing marks that the *span* changed. Consider reporting the post-relocation span, or requiring a relocated range to preserve its length. comment-only [proposed-rule: when a bounded search relocates both ends of a range independently, the report names the resulting span, not just the per-endpoint moves]

- `packages/crc32/package.json:49` — `"prettier": "^3.9.6"` is a hand-pinned devDependency duplicating the root `package.json:39` version; the sibling `@endo/zip` uses `catalog:dev` for every dev dep, and crc32 declares no prettier script. Drop it. comment-only [proposed-rule: a new workspace package takes dev dependency versions from the catalog, never a hand-copied pin]

- Positive: extracting `@endo/crc32` out of `@endo/zip` rather than re-implementing is the reuse-over-re-implementation discipline done right, and the blank-line `\n${lineNumber}` sentinel (`hashline.js:110-133`) closes a real deterministic-collision hole with a genuinely disjoint input space. [rule: roles/jurors/purist/AGENT.md — reuse over re-implementation of `@endo/*` primitives]

Self-improvement: the `ArrayBuffer.isView`-as-brand-check trap generalizes past this PR — `isView` is a supertype check, and any hot loop that indexes the result is silently assuming `BYTES_PER_ELEMENT === 1`. Worth a line in `skills/adversarial-tests/SKILL.md` under the passability/brand-check category, since the purist, breaker, and engine-realist seats would each reach it from a different direction.
