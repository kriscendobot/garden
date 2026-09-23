---
kind: result
role: gardener
host: endolin-garden-ece02cb4
at: 2026-08-06T22:43:58Z
---
### purist (ocap purity and conceptual integrity)

PR endojs/endo-but-for-bots#910, diff base `origin/llm-a3064e1`.

**Verdict:** request-changes

**Findings:**

- **must-fix.** `packages/daemon/src/manager.js:1869` — the derived-range label leaks the *parent* blob's content address to the holder of the attenuation. `makeAttenuatedBlob` passes `label` as the exo tag (`blob-range.js:283`), `makeExo` reaches `Far(tag, ...)`, and `marshal.js:161`/`:212` encode `getInterfaceOf(val)` into every CapTP slot. So a range minted here ships `Readable file with SHA-256 <8 hex>... range` over the wire. The design is otherwise careful here (a derived `getInfo` deliberately hashes only the selection); 32 bits of the whole-blob address is enough to confirm a guessed parent. Only the minting side should pierce the opacity. Use a source-independent tag (`'EndoBlob range'`, matching `'BlobRef range'` / `'GitBlob range'`). [rule: roles/jurors/purist/AGENT.md § Operating norms, side-channel closure]

- **should-fix.** `packages/daemon/src/types.d.ts:1217,1272,1316` declare `range(start: bigint, end: bigint)` with `end` **required**, contradicting the guard (`interfaces.js:121`, `.optional(M.bigint())`) and `RichReadableBlob`. That optionality is the affordance `interfaces.js` argues for by name ("a caller need not synthesize a sentinel upper bound"); daemon-typed callers can't use it. The same three also return `Promise<EndoReadable>`, re-asserting daemon identity on a value that has none, where `extended/types.ts:228` explicitly reasoned the opposite way for `BlobRef.range`. One question, two answers. [rule: roles/jurors/purist/AGENT.md § Operating norms, family-consistency]

- **should-fix.** Three byte-identical `readWindow`s over already-materialized bytes (`extended/shared/blob-ref.js:77`, `manager.js:2279`, `native-git-backend.js:1899`) plus three `sha256` `hashBytes` closures. The PR extracts the shared attenuator, then hand-rolls its commonest source five times. Export `makeBytesRangeSource(bytes, label)` from `blob-range.js`. [rule: roles/jurors/purist/AGENT.md § Operating norms, minimum viable abstraction]

- **should-fix.** `extended/cached-fs.js:118` recomputes `stringLengthLimit`, its comment conceding "exactly as `cas.js`'s `drainBlobBytes` does". Export `drainBlobBytes` rather than copy the cap and the 4/3 factor. [rule: roles/jurors/purist/AGENT.md § Operating norms, reuse over re-implementation]

- **comment-only.** `blob-range.js:267` — `intersectInterval`'s comment claims the clamp makes an inverted interval impossible, but the clamp sits inside `if (absoluteEnd !== undefined)`. On an open-ended receiver `composedStart = absoluteStart + start` is unbounded, so `range(MAX, undefined).range(MAX, undefined)` mints a blob whose reads throw `EINVAL` from `toSafeNumber` — the exact failure the comment says is prevented. Saturate at mint time, or narrow the claim. [rule: roles/jurors/purist/AGENT.md § Secondary surface, invariant-claim integrity]

- **comment-only.** `range` gained an optional `end`; its sibling `textRange(startLine, endLine)` keeps both required, so "line N to the last line" still needs a synthesized sentinel. Answer the affordance question once for the family. [rule: roles/jurors/purist/AGENT.md § Operating norms, family-consistency]

**Notes (out of scope but worth flagging):**

- `extended/type-guards.js:308` claims "the method set matches `RichReadableBlobInterface`", but `BlobRefInterface.getInfo` is `M.call().returns(Pass)` against the shared `M.call().returns(M.any())` (sync vs async). The claim outruns the guards. [proposed-rule: a comment asserting one interface guard's method set matches another's must hold per method *guard*, not merely per method name]

- Excluding `SnapshotBlobInterface` from the attenuation, with the "a range silently strips `sha256`" rationale recorded in `interfaces.js`, is the right call in the right place. [rule: roles/jurors/purist/AGENT.md § Operating norms, family-consistency]

Self-improvement: the purist role file's side-channel axis names identity, timing, and float bit-patterns, but not the **exo tag**, which `Far(tag, ...)` puts on the wire via `getInterfaceOf` in every marshaled slot. An attenuated cap whose label is interpolated from its parent is a recurring shape worth naming there.
