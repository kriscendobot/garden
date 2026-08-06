---
kind: panel-findings-checklist
repo: endojs/endo-but-for-bots
pr: 910
title: "feat(platform): ReadableBlob range attenuation (range / textRange)"
head: 44d53c7c
base_ref: llm-3ec5585
panel_verdict: must-fix
reconciled_by: pr910-panel-response-01-recover-findings
sources:
  - posted-review: 4835919006 (submitted 2026-08-01T22:22:16Z, 63457 chars; 13 seats full, 15 marked "_(condensed for length)_", remainder headline-only)
  - panel-run: 2e79b55d55ef (disposition must-fix — TERMINAL/authoritative; 28 seats; matches posted verdict)
  - panel-run: 16f2fe86ac20 (disposition seat-error; 28 seats; recovers fuller archivist + benchmarker text; contains ONE contamination — see reconciliation note C1)
  - panel-run: dafebe8fe9cb (disposition error; 24 seats; recovers fuller purist / changeset-auditor / integrator / locksmith text)
tally:
  must-fix: 21
  should-fix: 25
  comment-only: 4
  total: 50
tally_by_slice:
  platform:   { must-fix: 13, should-fix: 17, comment-only: 3, total: 33 }
  daemon:     { must-fix: 3,  should-fix: 3,  comment-only: 0, total: 6 }
  git-and-docs: { must-fix: 5, should-fix: 5, comment-only: 1, total: 11 }
---

# PR #910 panel finding checklist (normalized, unabridged)

**This file is the authoritative finding set for the PR #910 panel response**, not the
posted GitHub review (which truncated 15 of 41 seat sections with `_(condensed for
length)_`). Downstream children (`platform` / `daemon` / `git-and-docs`) work from
**this** checklist.

## How to read this

- Findings are **normalized by distinct issue**: the same defect raised by many seats is
  ONE row, with every corroborating seat listed under **Seats**. Where seats added a
  distinct sub-claim to the same issue, it is preserved in the claim.
- **Severity** = the highest any seat assigned (must-fix > should-fix > comment-only),
  because downstream must clear every must-fix before any should-fix. Seat disposition
  vocabulary is normalized: `must-fix-loop` → must-fix; `summary-fix` → should-fix;
  `follow-up` → comment-only. Genuine cross-seat severity disagreements are flagged
  **DISPUTED**.
- **Slice** = the package the code change principally touches. Spanning findings note the
  other slices with **xref**.
- **Order of work is descending severity** (maintainer directive, kriskowal 2026-08-06:
  "Respond to all feedback in order of descending severity"). Within a slice: every
  must-fix before any should-fix, every should-fix before any comment-only.
- The **Disposition** field on each finding starts empty. The child that handles a
  finding fills it in place: `commit <sha>` or `reply: <reason not fixed>`. A finding is
  answered by a commit or a reasoned reply; a silent skip is not an answer
  (per skills/review-feedback-followup-commits, skills/pr-review-thread-replies).

## Reconciliation notes

- **C1 — one contamination excluded.** Artifact `16f2fe86ac20` (the seat-error run)
  records archivist flagging `blob-range.js:183` reading
  `const newHi = lo + end; // PROVER-BREAK: author...`. That `// PROVER-BREAK` is a
  *prover seat's deliberate break* leaking into archivist's worktree view during a
  concurrent run — a run-contamination artifact, **not a finding in the PR head**. It is
  excluded. All other seat findings in the two failed runs are genuine juror output (the
  panels failed to render a terminal verdict for orchestration reasons, not because seats
  produced garbage) and are used to recover the text the posted review condensed.
- **C2 — authority order.** Posted review + terminal `must-fix` artifact (`2e79b55d55ef`)
  are primary; the two failed-run artifacts (`seat-error`, `error`) are supplements that
  recover condensed-seat text. All four ran against the SAME head `44d53c7c` / base
  `llm-3ec5585`, so file:line citations are directly comparable.
- **C3 — reconstruction confidence.** Fully-rendered seats (assessor, typist, stylist,
  packager, archivist, prover, curator, migrator, locksmith, warden, saboteur, breaker,
  purist) are high-fidelity. Deeply-condensed seats (spec-keeper, wire-watcher,
  engine-realist, integrator, changeset-auditor, surfacer, fast-checker, releaser,
  transplanter) were reconstructed from their headlines + the panel-run artifacts +
  cross-seat corroboration; their file:line specifics are inherited from the seats that
  rendered the same issue in full. Where a condensed seat raised something no full seat
  did, it is recorded and attributed (e.g. spec-keeper's BOM divergence PLAT-13).
- **C4 — severity disagreements flagged inline:** PLAT-09 (M.promise), PLAT-11 (chunk
  loop), GD-08 (arrow churn).

---

# Slice: platform (packages/platform) — 33 findings

## must-fix

### PLAT-01 — streamBase64's eager window read leaves an unobserved rejection that can kill the daemon
- **Severity:** must-fix
- **Seats:** assessor (must-fix), engine-realist#1 (must-fix), breaker (should-fix)
- **File:** `packages/platform/src/fs/blob-range.js:191` (167, 190-194)
- **Claim:** `streamBase64` calls `selected()` *eagerly* and passes the resulting promise into `base64Chunks`; the comment claims the read is "deferred into the generator" but only the `await` is deferred — the promise exists before the pump pulls. `makeReaderPump` does not advance until the consumer resolves the syn head, so a consumer that calls `streamBase64` and abandons the stream leaves that rejection unobserved. Confirmed (assessor): range a mount file, delete the file, `streamBase64` without iterating → `SES_UNHANDLED_REJECTION: ENOENT ... at readWindow (mount.js:1549)`; fatal under `--unhandled-rejections=strict`.
- **Proposed fix:** pass a thunk and call `selected()` inside the generator body; a promise created eagerly for later consumption must be attached to a handler at creation.
- **Disposition:** **fixed** (`commit 2ef332079`). `base64Chunks` now takes the `selected` *thunk* and calls it on first advance; the window read (and any rejection it carries) is created only when a consumer pumps the stream, so obtaining `streamBase64` without iterating leaves no unobserved rejection.
### PLAT-02 — range read derives length from `stat().size`, producing a false content address on /proc, sysfs, and FIFOs
- **Severity:** must-fix
- **Seats:** breaker (must-fix)
- **File:** `packages/platform/src/fs-node/local-blob.js:43-52` — **xref daemon** `packages/daemon/src/mount.js:1551-1559` (same shape via `filePowers.statPath`)
- **Claim:** `readFileWindow` derives its window from `handle.stat().size` and issues one unlooped `handle.read`. `makeLocalBlob('/proc/self/status')`: `text()` returns 1535 chars, but `range(0n,1535n).text()` returns `''` because `size` is 0 so `clamped <= 0`. On a FIFO, `read` returns short (6/12) and the window is silently truncated with no error. `getInfo()` on that range then reports `size: 0n` and the SHA-256 of the empty string — **a false content address a verifying caller will accept**. `manager.js` and the Git backend are unaffected (authoritative size / full materialization).
- **Proposed fix:** loop the read until short-or-EOF; stop treating `stat.size` as the authoritative upper bound. [proposed-rule: a range read must not derive its length from `stat().size`; read-until-EOF and loop, as `readFile` does.]
- **Disposition:** **fixed** (`commit 2ef332079`). `readFileWindow` (`fs-node/local-blob.js`) no longer derives the window length from `stat().size`; it reads in a loop from the requested position until the byte count is satisfied or the source signals EOF (`bytesRead === 0`), so a range over `/proc`, `sysfs`, or a short-reading FIFO can no longer mint a false content address (SHA-256 of `''`). The daemon `mount.js` mirror is xref-daemon (sibling slice).
### PLAT-03 — `range`'s guard makes `end` mandatory, so "offset to EOF" is inexpressible and forces a whole-window allocation (OOM vector)
- **Severity:** must-fix
- **Seats:** breaker (must-fix); purist#2, integrator#6, saboteur#3 (should-fix)
- **File:** `packages/platform/src/fs/interfaces.js:116-117`; `packages/platform/src/fs/blob-range.js:169,183`
- **Claim:** the guard is `range: M.call(M.bigint(), M.bigint())` (both required), yet the internals already model `hi === undefined` as "to end-of-content" (the base blob uses it). "Read from offset N to EOF" therefore forces `range(N, 9007199254740991n)`, making `readWindow` allocate one `Uint8Array` of `min(MAX_SAFE, filesize)`; every derived `streamBase64`/`getInfo`/`textRange` then materializes the whole window. A remote CapTP caller can send `range(0n, 9007199254740991n).streamBase64()` against a multi-GB mount file and drive the daemon OOM — the retired `fetch` returned an incremental reader and could not.
- **Proposed fix:** make `end` optional (`M.call(M.bigint()).optional(M.bigint())`; the implementation already supports it) **and** chunk the window read (see PLAT-16). [proposed-rule: an interface guard exposes the full domain its implementation models, or the unreachable case is deleted.]
- **Disposition:** **fixed** (`commit 2ef332079`). `range`'s guard is now `M.call(M.bigint()).optional(M.bigint())`; the implementation composes `end === undefined` as "to end-of-content", and the `RichReadableBlob`/`BlobRef` types + the daemon `EndoMountReadableBlob.range` signature were updated to the optional-`end` shape. "Offset to EOF" no longer needs a sentinel upper bound. (The incremental/chunked window read that removes the residual whole-window allocation is PLAT-16, should-fix — sibling.)
### PLAT-04 — `textRange` reads the entire content to locate LFs; the added "without streaming the whole file" claim is false
- **Severity:** must-fix
- **Seats:** benchmarker Finding 1 (must-fix-loop); saboteur#4 (should-fix); assessor (comment-only); engine-realist#5
- **File:** `packages/platform/src/fs/blob-range.js:262` (seeds base at `(0n, undefined)`); doc `packages/platform/src/fs-node/local-blob.js:11-16` and `blob-range.js:12`
- **Claim:** `makeBlobRangeMethods` builds `base` at `(0n, undefined)`, so `textRange(a,b)` does `await selected()` → `readWindow(0n, undefined)` → the whole file, every call, plus an O(n) LF scan in `lineByteSpan` — asking for one line of a multi-GB file reads all of it. The added comment asserts the blob can "attenuate to **byte / line** windows without streaming the whole file"; true for `range`, false for `textRange` (the pre-existing comment said "byte ranges", true of `fetch`; the PR widened it into a falsehood).
- **Proposed fix:** qualify the claim to `range` (or note the `textRange` cost); an efficiency claim closes with a measurement or an explicit decline. Not a behavioral regression (`rangeReadText` also read whole).
- **Disposition:** **fixed** (`commit 2ef332079`). The "attenuate to byte/line windows **without streaming the whole file**" claim is qualified to `range` at both sites (`blob-range.js` module doc, `local-blob.js` header): a `textRange` line window still scans the current content to locate LFs. Not a behavioral regression.
### PLAT-05 — `textRange` costs strictly more than the retired `rangeReadText`, unmeasured; the second read is memoizable for immutable producers
- **Severity:** must-fix
- **Seats:** benchmarker Finding 2 (must-fix-loop)
- **File:** `packages/platform/src/fs/blob-range.js` (`textRange` path)
- **Claim:** retired `LocalBlob.rangeReadText` was one `readFile`. Shipped `textRange(a,b).text()` is `readFileWindow(0, undefined)` (open+stat+whole-file read) → LF scan → new exo → `readFileWindow(lo, hi)` (second open+stat+read). The PR body's "matches the retired `rangeReadText(a,b)` **exactly**" is a fine *semantic* claim; the *cost delta* beside it is neither measured nor declined. Split: for immutable producers (`BlobRef`, snapshot `EndoBlob`, Git blob) the second read is provably redundant and memoizable; for the live mount it is semantically required.
- **Proposed fix:** memoize the located byte-span / first read for immutable producers, or post a measurement / explicit decline. (Distinct from PLAT-04: this is the cost/measurement obligation, not the doc claim.)
- **Disposition:** **reasoned reply / declined memoization in the shared maker; cost documented** (`commit 2ef332079`). The shared `makeBlobRangeMethods` is source-agnostic and *cannot* memoize the located span or first read without breaking live sources — for a live mount the second read is semantically required (memoizing there is exactly the PLAT-06 freeze hazard). Per-immutable-producer memoization is a distinct optimization that belongs in each immutable producer, not the shared path, and is deferred to a follow-up. The extra whole-selection read `textRange` performs (locate-LFs read, then windowed read) is now stated in the `blob-range.js` module doc — the measurement/decline the finding asks for.
### PLAT-06 — `textRange` on a *live* source freezes byte offsets: a line grant silently decays into a byte grant and leaks unrelated lines
- **Severity:** must-fix
- **Seats:** wire-watcher#1 (must-fix), locksmith (must-fix); saboteur#5 (should-fix)
- **File:** `packages/platform/src/fs/blob-range.js:238-241` — **xref daemon** `packages/daemon/src/mount.js:1543-1560`; **xref docs** `packages/daemon/src/help.md:865-871`, `packages/platform/src/fs/types.d.ts:44-49`
- **Claim:** `textRange` resolves lines to `[from,to)` once, then `compose()`s a frozen *byte* interval; on `EndoMountFile` each later read re-reads the file at those offsets. Verified (locksmith): `file.textRange(0,1)` over `public\nSECRET-TOKEN-abc\n` reads `"public"` at grant time, then `"SECRET"` after the owner rewrites the file — **the holder gained a different line without any new grant**. `range`'s help text carries the live-semantics warning; `textRange`'s (help.md) and `RichReadableBlob.textRange` (types.d.ts) omit it, and the design's §Text ranges never examines the live case.
- **Proposed fix:** minimum — state the divergence at both doc sites and the mount call site; better — re-resolve lines per read, or reject `textRange` on live faces. [proposed-rule: an attenuator named in one coordinate system (lines) but enforced in another (bytes) documents the divergence at every mutable-source implementation site.]
- **Disposition:** **fixed (documentation, the stated must-fix minimum)** (`commit 2ef332079`). The live-source line->byte decay is documented on `RichReadableBlob.textRange`'s type doc (`platform/src/fs/types.ts`) and at the maker's `textRange` call site (`blob-range.js`): on a live face the located byte offsets are frozen at call time, so a later read may reflect different lines — a line grant can decay into a byte grant; prefer `textRange` on immutable snapshots for stable line semantics. The daemon `help.md:865-871` / mount call-site prose is xref-daemon (sibling slice). The deeper options (re-resolve lines per read, or reject `textRange` on live faces) are architectural and left as a follow-up.
### PLAT-07 — CAS is populated with bytes never checked against the hash they are keyed by, and this PR removed the last bound
- **Severity:** must-fix
- **Seats:** wire-watcher#2 (must-fix); assessor note (`cached-fs.js:112` no `stringLengthLimit`)
- **File:** `packages/platform/src/fs/extended/cached-fs.js:112` (cf. `cas.js:158` which documents the limit as necessary for one-shot frames)
- **Claim:** `cached-fs.js:112` drains via `iterateBytesReader(blobP)` with no `stringLengthLimit`, while `cas.js:158` documents that limit as necessary; the retired `fetch` path is what made the asymmetry moot. wire-watcher frames it as CAS bytes entering the store unchecked against the hash they are keyed by, with the last bound removed by this PR.
- **Proposed fix:** re-establish the `stringLengthLimit` bound on the drain path (or otherwise verify bytes against the key before caching).
- **Disposition:** **fixed** (`commit 2ef332079`). `cached-fs.js` `populateInBackground` now raises the per-frame `stringLengthLimit` above the worst-case 4/3 base64 expansion of `info.size` (the same formula `cas.js`'s `drainBytesReader` uses), re-establishing the bound the retired ranged `fetch` path made moot — without it any blob larger than ~75 KB silently failed to populate.
### PLAT-08 — interface-tag collision: `RichReadableBlobInterface` is tagged `'ReadableBlob'`, identical to `ReadableBlobInterface`, while its own comment claims the tag is distinct
- **Severity:** must-fix
- **Seats:** stylist, curator, archivist#1, breaker, surfacer#1 (must-fix); typist#4, warden#4, purist#1, spec-keeper#3, locksmith, wire-watcher#4 (should-fix)
- **File:** `packages/platform/src/fs/interfaces.js:159-162` (collides with `:146`)
- **Claim:** `:162` mints `RichReadableBlobInterface` with `M.interface('ReadableBlob', …)` — byte-identical to `ReadableBlobInterface` at `:146` — while the comment at `:159-161` asserts "The tag is distinct from the whole-value `ReadableBlobInterface` so the two shapes don't collide in diagnostics." Two different method sets now marshal under one interface name; the pre-PR tag was `'ReadableBlobRange'`, so the rename *dropped* a genuine distinction (a regression). A diagnostic or interface-name-keyed dispatch can no longer tell a whole-value blob from a rich one.
- **Proposed fix:** retag `'RichReadableBlob'` (matching the exported identifier), or delete the sentence. [proposed-rule: two `M.interface` declarations with different method sets never share a tag; no comment may claim a distinction the code does not make.]
- **Disposition:** **fixed** (`commit 2ef332079`). `RichReadableBlobInterface` is retagged `M.interface('RichReadableBlob', ...)`, distinct from the whole-value `'ReadableBlob'`; the comment is corrected. No snapshot or dispatch keys on the tag (feature detection is by method name), and the daemon/git exos that reuse the interface retag consistently; all packages' `lint:types` + the mount conformance suite pass.
### PLAT-09 — the `M.promise()` guard claims a "same-interface guarantee at the CapTP boundary" it does not enforce
- **Severity:** must-fix — **DISPUTED** (breaker: must-fix; warden#4, spec-keeper#4, purist: should-fix)
- **Seats:** breaker (must-fix); warden#4, spec-keeper#4, purist (should-fix)
- **File:** `packages/platform/src/fs/interfaces.js:112-117` (113)
- **Claim:** the comment says "The runtime guards require the returned value be a promise (of a `ReadableBlob`) … so the same-interface guarantee holds at the CapTP boundary," but `.returns(M.promise())` constrains nothing about the fulfillment value. A third-party producer whose `range` fulfills with a plain record passes the guard, and a caller relying on the stated guarantee to compose ranges gets a non-blob.
- **Proposed fix:** weaken the comment to state only what is enforced (promiseness), or use `M.callWhen(…).returns(M.remotable('ReadableBlob'))` and detect by method names, not tag.
- **Disposition:** **fixed** (`commit 2ef332079`). The `M.promise()` comment in `interfaces.js` is weakened to state only what the guard enforces (promiseness); it no longer claims a same-interface guarantee at the CapTP boundary and notes callers detect the rich surface by method names.
### PLAT-10 — the PR's only new public export is typed `any`, erasing the `RichReadableBlob` contract at its single source
- **Severity:** must-fix
- **Seats:** typist#2 (must-fix), surfacer#4 (must-fix-loop); curator (should-fix); purist#? 
- **File:** `packages/platform/src/fs/blob-range.js:167,259`
- **Claim:** `makeAttenuatedBlob` is `@returns {any}` and `makeBlobRangeMethods` returns `Promise<any>` for both `range` and `textRange`, while `types.d.ts` declares `Promise<RichReadableBlob>`. Every consumer that spreads these (`local-blob.js:71`, `manager.js:1844`, `mount.js`, `native-git-backend.js`) carries `/** @satisfies {RichReadableBlob} */`, which now passes **vacuously** for the two methods it most needs to check — a swapped `range`/`textRange` or wrong arity would typecheck.
- **Proposed fix:** `@import { RichReadableBlob } from './types.js'` and return `Promise<RichReadableBlob>`.
- **Disposition:** **fixed** (`commit 2ef332079`). `makeAttenuatedBlob` / `makeBlobRangeMethods` are typed `Promise<RichReadableBlob>` (with a top-of-file `@import`), not `any`. This immediately surfaced a masked lie the vacuous `any` hid: `BlobRef.range`/`textRange` were declared `Promise<BlobRef>`, but a derived range is a generic `RichReadableBlob` (async `getInfo`, no snapshot identity) — corrected in `extended/types.ts`. `lint:types` passes across platform, daemon, git, exo-git, agent-tools.
### PLAT-11 — the `base64Chunks` multi-chunk loop is an untested code path
- **Severity:** must-fix — **DISPUTED** (fast-checker: must-fix-loop, "an untested code path, not a preference"; prover: coverage-gap-not-defect — drove a 130 KB range through it, correct incl. non-multiple-of-3 chunk size)
- **Seats:** fast-checker (must-fix-loop); prover note (coverage)
- **File:** `packages/platform/src/fs/blob-range.js:96-106`
- **Claim:** the multi-chunk loop is unreachable in the whole suite (largest fixture 12 bytes vs a 49152-byte chunk). prover verified it correct under a 130 KB probe; fast-checker holds that an untested path over a chunk boundary must be pinned by a test before merge.
- **Proposed fix:** add a >1-chunk round-trip test (drive ≥130 KB through `streamBase64`, assert byte-exact decode), or record prover's evidence and decline.
- **Disposition:** **fixed — dispute resolved by adding the test fast-checker asked for** (`commit 2ef332079`). Added a >1-chunk (~130 KB, non-multiple of the 48 KiB chunk size and of 3) `streamBase64` round-trip test asserting byte-exact decode, including a sub-window crossing several chunk boundaries. prover's correctness evidence stands; the loop is now pinned.
### PLAT-12 — abbreviated freshly-authored identifiers throughout `blob-range.js`
- **Severity:** must-fix (stylist only)
- **Seats:** stylist (must-fix)
- **File:** `packages/platform/src/fs/blob-range.js` — **xref daemon** `manager.js:1831`, `mount.js:1555`
- **Claim:** `MAX_SAFE` (`:36`) → `MAX_SAFE_INTEGER`; `minBig` (`:91`) → `minBigInt`; `lfAt` (`:128`) → `lineFeedOffsets`; `lo`/`hi`/`newLo`/`newHi` (`:165,169,182-184`) → the surface's own `start`/`end` vocabulary (`absoluteStart`/`absoluteEnd`) so the internals don't drift from the `range(start,end)` API; `s`/`e` (`:218-219,231-232`) → `start`/`end`, `startLine`/`endLine`. Also `len` at daemon `manager.js:1831` and `mount.js:1555` → `length`.
- **Proposed fix:** rename per stylist brief § Abbreviated identifiers.
- **Disposition:** **fixed (platform)** (`commit 2ef332079`). Renamed in `blob-range.js`: `MAX_SAFE`->`MAX_SAFE_INTEGER`, `minBig`->`minBigInt`, `lfAt`->`lineFeedOffsets`, `lo`/`hi`->`absoluteStart`/`absoluteEnd`, `newLo`/`newHi`->`composedStart`/`composedEnd`, and the `s`/`e` locals removed in favor of the surface's own `start`/`end`/`startLine`/`endLine`. `selected`->`readSelectedBytes` is PLAT-23 (should-fix, sibling) and left for it. The daemon `manager.js:1831` / `mount.js:1555` `len`->`length` renames are xref-daemon (sibling slice).
### PLAT-13 — whole-value `text()` and a full-interval `range().text()` disagree on a BOM'd file; the attenuation identity the design rests on does not hold
- **Severity:** must-fix
- **Seats:** spec-keeper#2 (must-fix)
- **File:** `packages/platform/src/fs/blob-range.js` (attenuation / decode path); reproduced via a BOM'd fixture
- **Claim:** spec-keeper probed a BOM'd file: whole-value `text()` and a full-interval `range().text()` return different strings — "the attenuation identity the design rests on does not hold." Root is likely two different decoders crossing the same bytes (BOM stripped on one path, not the other).
- **Proposed fix:** make the full-interval range decode byte-identically to the whole-value read (single decode path), and add a BOM fixture to the equivalence corpus. **Verify against source** — this is the one must-fix from a deeply-condensed seat with no full-seat corroboration; the child should reproduce before fixing.
- **Disposition:** **fixed** (`commit 2ef332079`). Reproduced: a UTF-8 BOM made LocalBlob's whole-value `text()` (Node `readFile('utf-8')`, BOM retained) disagree with `range(0,size).text()` (the range path's `TextDecoder`, BOM stripped). LocalBlob's whole-value `text`/`json` now decode through the same `bytesToText` path the range surface uses, restoring the identity; a BOM equivalence test was added. BlobRef already decoded via `TextDecoder` on both paths (identity held). NOTE (cross-slice): the daemon `EndoMountFile` whole-value `text()` uses `readFileText` (BOM retained) while its range path strips — a pre-existing divergence for the daemon slice to reconcile; native-git already strips on both.
## should-fix

### PLAT-14 — `compose` clamps `newHi` but never `newLo`, so it can mint `lo > hi` (inverted interval / late `EINVAL` overflow)
- **Severity:** should-fix
- **Seats:** assessor, purist#? , locksmith, saboteur#2, wire-watcher#5, prover note
- **File:** `packages/platform/src/fs/blob-range.js:157` (181-185)
- **Claim:** `compose` clamps `newHi` against `hi` but never clamps `newLo`, so a nested range can produce `lo > hi`. Safety currently rests on all five `readWindow` implementations independently returning empty for an inverted interval; the invariant lives in the callers, not the maker. saboteur confirmed the concrete symptom: `range(MAX,MAX)` → `''`, but `range(MAX,MAX).range(MAX,MAX)` → `EINVAL: "start" 18014398509481982n exceeds Number.MAX_SAFE_INTEGER` on *every* read incl. `getInfo`. (assessor also notes `compose` sums two `MAX_SAFE`-bounded bigints without re-checking the sum, surfacing the overflow later at `toSafeNumber` naming `start`.)
- **Proposed fix:** clamp at the single construction site: `const newLo = hi === undefined ? lo + start : minBig(lo + start, hi)`. [proposed-rule: enforce an interval invariant where the interval is constructed, not at each consumer.]
- **Disposition:**

### PLAT-15 — `lineByteSpan` returns `[min,max]`, silently reversing the span if `from > to`
- **Severity:** should-fix
- **Seats:** assessor (should-fix); prover (delete as unreachable); purist#? (comment)
- **File:** `packages/platform/src/fs/blob-range.js:128` (148)
- **Claim:** `lineByteSpan` returns `[min(from,to), max(from,to)]`; if `from > to` were reachable this silently *reverses* the span into a non-empty wrong slice rather than yielding empty. prover: unreachable from the two preceding branches — no test can pin it; prefer deleting the swap over leaving untestable defense.
- **Proposed fix:** `to <= from ? [from, from] : [from, to]`, **or** delete the swap if provably unreachable (prover's recommendation). One of the two — do not leave the reversing form.
- **Disposition:**

### PLAT-16 — attenuated `streamBase64` buffers the whole selection, widening the memory bound of a *narrowed* authority
- **Severity:** should-fix
- **Seats:** saboteur#3, engine-realist#2, integrator#6
- **File:** `packages/platform/src/fs/blob-range.js:171,192`
- **Claim:** a derived `streamBase64` awaits the whole window into one `Uint8Array` (`local-blob.js readFileWindow` allocates `new Uint8Array(size - from)`), so `range(0n, 9007199254740991n).streamBase64()` replaces `LocalBlob`'s bounded `fs.createReadStream` with a whole-file allocation. A narrowing of authority should not widen the resource bound. (Couples with PLAT-03 — chunk the window read.)
- **Proposed fix:** stream/chunk the window read incrementally. [proposed-rule: an attenuated read must not exceed the resource bound of the unattenuated read it derives from.]
- **Disposition:**

### PLAT-17 — bare `JSON.parse` with a known origin yields unlocated errors
- **Severity:** should-fix
- **Seats:** saboteur#6
- **File:** `packages/platform/src/fs/blob-range.js:200`
- **Claim:** `JSON.parse` here throws `Unexpected end of JSON input` / `Expected ':' after property name … position 4`, neither naming the blob `label` nor the `[lo, hi)` interval — and an empty selection (what a mis-ordered `range` yields) is exactly the case an agent hits most.
- **Proposed fix:** wrap with a located `@endo/errors` message naming the label and interval.
- **Disposition:**

### PLAT-18 — the `RangeSource` typedef lives inline in an implementation file though it is reused cross-package
- **Severity:** should-fix
- **Seats:** typist#3
- **File:** `packages/platform/src/fs/blob-range.js:152`
- **Claim:** `RangeSource` is multi-field and reused across packages (`daemon/src/manager.js` ×2, `daemon/src/mount.js`, `git/src/native-git-backend.js`, + two in-package sites) as the parameter type of an exported function; it belongs in `src/fs/types.d.ts` and `@import`ed so cross-package producers can name it. Not covered by the module-private single-use escape hatch.
- **Proposed fix:** move to `src/fs/types.d.ts`, `@import` it.
- **Disposition:**

### PLAT-19 — `assertOffset` bakes one backend's int53/`fs.read` limit into the deliberately source-agnostic portable surface
- **Severity:** should-fix
- **Seats:** purist#3
- **File:** `packages/platform/src/fs/blob-range.js:36,61`
- **Claim:** `assertOffset` rejects any `bigint` above `Number.MAX_SAFE_INTEGER`; `bigint` was chosen for these offsets *precisely because* a blob may exceed int53. The shared attenuator now bakes one backend's `fs.read` limit into the portable surface a Rust/Go/browser producer would also implement.
- **Proposed fix:** push the safe-number narrowing to each producer's `readWindow` (where `toSafeNumber` already lives).
- **Disposition:**

### PLAT-20 — the attenuator's `source` record is never hardened and is re-read per derived range, so a producer can swap `readWindow` after handing out an attenuated blob
- **Severity:** should-fix
- **Seats:** warden#2
- **File:** `packages/platform/src/fs/blob-range.js:170,224,241,261`
- **Claim:** `makeBlobRangeMethods` is public API (`fs/index.js:25`), and `makeAttenuatedBlob` re-destructures `source.readWindow` on each `range`/`textRange`. A producer that retains the record it passed can swap `readWindow` *after* handing an attenuated blob to a less-trusted holder; every range that holder subsequently derives then reads outside the interval it was granted.
- **Proposed fix:** destructure once in `makeBlobRangeMethods` and thread a `harden`ed internal record. [rule: AGENTS.md § Hardened JavaScript.]
- **Disposition:**

### PLAT-21 — `SnapshotBlobInterface` / `snapshotBlobMethods` get no `range`/`textRange` (family gap)
- **Severity:** should-fix
- **Seats:** purist (from artifact dafebe8fe9cb)
- **File:** `packages/platform/src/fs/interfaces.js:151`
- **Claim:** the snapshot blob family gains no `range`/`textRange`, yet `interfaces.js:151` claims family parity. Either extend the family or state the exclusion.
- **Proposed fix:** add the methods to the snapshot family, or document the deliberate exclusion at `:151`.
- **Disposition:**

### PLAT-22 — `BASE64_CHUNK_RAW_BYTES` and `base64Chunks` are duplicated verbatim across two modules in this PR
- **Severity:** should-fix
- **Seats:** purist#5; assessor note, stylist note, benchmarker artifact, pruner (cut)
- **File:** `packages/platform/src/fs/blob-range.js:38,96` and `packages/platform/src/fs/extended/shared/blob-ref.js:24,26,31`
- **Claim:** a chunking constant + its consumer are copied verbatim into a second module in the same PR; two copies drift.
- **Proposed fix:** export one. [proposed-rule: a chunking constant shared by two producers lives in one module.]
- **Disposition:**

### PLAT-23 — `selected` names an asynchronous I/O thunk with a past participle
- **Severity:** should-fix
- **Seats:** stylist
- **File:** `packages/platform/src/fs/blob-range.js:171`
- **Claim:** `const selected = () => readWindow(lo, hi)` names an async I/O thunk with a past participle; every call site reads `await selected()`. A niladic function that performs I/O is named with a verb.
- **Proposed fix:** rename `readSelectedBytes`.
- **Disposition:**

### PLAT-24 — `drainBytesReader` no longer takes a reader
- **Severity:** should-fix
- **Seats:** stylist
- **File:** `packages/platform/src/fs/extended/cas.js:144,149` (call site `:198`)
- **Claim:** `drainBytesReader(readerRef, …)` no longer takes a reader — the new JSDoc says "a remotable exposing `streamBase64`" and the sole call site passes `blobRef`.
- **Proposed fix:** rename `drainBlobBytes(blobRef, …)`.
- **Disposition:**

### PLAT-25 — `getInfo` on a range is an O(n) read plus a digest per call
- **Severity:** should-fix (perf)
- **Seats:** benchmarker (artifact 16f2fe86ac20)
- **File:** `packages/platform/src/fs/blob-range.js:205`
- **Claim:** `getInfo` on a range performs an O(n) read plus a digest on every call, where every parent's `getInfo` recomputes; unmemoized.
- **Proposed fix:** memoize the digest for immutable producers, or post a measurement / decline.
- **Disposition:**

### PLAT-26 — `lineByteSpan` materializes every LF offset when two boundaries suffice
- **Severity:** should-fix (perf)
- **Seats:** benchmarker (artifact), engine-realist#4
- **File:** `packages/platform/src/fs/blob-range.js:128`
- **Claim:** `lineByteSpan` materializes every LF offset in the selection when only the two bounding LF offsets are needed.
- **Proposed fix:** scan for only the two needed boundaries, or record it as an acceptable cost with a measurement.
- **Disposition:**

### PLAT-27 — the `textRange` equivalence claim has no backing test (the method it was equivalent to is deleted)
- **Severity:** should-fix
- **Seats:** prover#2
- **File:** `packages/platform/src/fs/blob-range.js:110-116`
- **Claim:** the module claims `textRange(a,b).text()` equals `text.split('\n').slice(a,b).join('\n')` and "never disagrees" with the retired `rangeReadText`, and the PR body repeats it; `rangeReadText` is deleted, so nothing pins the drift. prover verified the claim holds (296 `(a,b)` pairs over a 14-string corpus incl. empty, bare-LF, CRLF, unterminated-final-line: 0 mismatches).
- **Proposed fix:** add prover's corpus loop verbatim as the backing test. [rule: skills/regression-evidence § Equivalence claims need a backing test.]
- **Disposition:**

### PLAT-28 — duplicate / subsumed tests in `local-blob.test.js`
- **Severity:** should-fix
- **Seats:** prover
- **File:** `packages/platform/test/local-blob.test.js:67,126` (byte-identical); `:56` subsumed by `:115`
- **Claim:** `:67` and `:126` are byte-identical (same three `range()` EINVAL assertions); `:56` is strictly subsumed by `:115`. Pre-migration each pinned a distinct method (`fetch` vs `rangeRead`); post-migration one of each pair exerts zero regression pressure.
- **Proposed fix:** delete the duplicates.
- **Disposition:**

### PLAT-29 — a test assertion pins the test helper, not production
- **Severity:** should-fix
- **Seats:** prover
- **File:** `packages/platform/test/local-blob.test.js:118`
- **Claim:** `t.true(whole instanceof Uint8Array)` where `whole = await collectBytes(...)`, and `collectBytes` itself constructs `new Uint8Array(total)` (`:30`) — the assertion pins the helper, passing whatever `range` returns.
- **Proposed fix:** assert against production output directly.
- **Disposition:**

### PLAT-30 — stale in-tree comments naming the retired `fetch`
- **Severity:** should-fix
- **Seats:** archivist#5, purist#6, curator
- **File:** `packages/platform/src/fs/interfaces.js:80`; `packages/platform/src/fs/extended/shared/helpers.js:17`; `packages/platform/src/fs/extended/cas.js:10` — **xref daemon** `packages/daemon/src/bus-manager-rust-xs-powers.js:157`
- **Claim:** `interfaces.js:80` — "(live blobs add `fetch` for windowed reads)"; `helpers.js:17` — "Used by `shared/blob-ref.js` for `BlobRef.fetch`" (and `blob-ref.js` no longer imports it, so the file-header claim at `:6` that every export is actively used is now wrong); `cas.js:10` — "skip `BlobRef.fetch()`"; daemon `bus-manager-rust-xs-powers.js:157` — "Mirrors the `BlobRef.fetch` clamp".
- **Proposed fix:** update each comment to the `range`/`textRange` surface.
- **Disposition:**

## comment-only

### PLAT-31 — validator params declared as the type they validate
- **Severity:** comment-only
- **Seats:** typist#7
- **File:** `packages/platform/src/fs/blob-range.js:46,73`
- **Claim:** `assertOffset` is `@param {bigint} value` yet branches on `typeof value !== 'bigint'`; `assertLineIndex` mirrors it. Declaring `{unknown}` and narrowing on return states the boundary contract honestly and keeps the guard from reading as dead code.
- **Disposition:**

### PLAT-32 — `compose` is a generic verb for "intersect the child interval with mine"
- **Severity:** comment-only
- **Seats:** stylist
- **File:** `packages/platform/src/fs/blob-range.js:181`
- **Claim:** `intersectInterval` states the operation; `compose` is generic.
- **Disposition:**

### PLAT-33 — `Rich` is a taste qualifier on a public TS type; wants maintainer confirmation
- **Severity:** comment-only
- **Seats:** stylist note, curator note
- **File:** `packages/platform/src/fs/types.d.ts` (`RichReadableBlob` / `RichReadableBlobInterface`)
- **Claim:** the design uses "rich" only as prose and names no identifier; `Rich` ranks the type rather than naming the added capability, but it does avoid a collision with the whole-value `ReadableBlobInterface`. Lands on the public TS type — worth a maintainer confirmation. [proposed-rule: a type-name qualifier names the added capability, not ranks the type.]
- **Disposition:**

---

# Slice: daemon (packages/daemon) — 6 findings

## must-fix

### DMN-01 — `makeSha256` is an optional parameter but is called unconditionally; `range().getInfo()` throws a raw `TypeError` on every mount not built by `manager.js`
- **Severity:** must-fix
- **Seats:** assessor, typist#1, prover, migrator, locksmith, warden#1, saboteur#1, spec-keeper#1, corner-prober#1 (must-fix); purist#4, breaker, wire-watcher#3, engine-realist#3, transplanter#1 (should-fix) — **the single most-corroborated finding in the panel (14 seats)**
- **File:** `packages/daemon/src/mount.js:1524` (default `undefined`), `:1562` (`/** @type {() => Sha256} */ (makeSha256)()`); also declared optional at `:518`, `:1512`, `:1783`, `:1796`
- **Claim:** `makeSha256` defaults to `undefined` and `hashBytes` launders it past tsc with the cast. `manager.js:3159,3189` threads it; **no other call site does** — including ~25 committed `makeMount(...)`/`makeRevocableMount(...)` sites in `packages/daemon/test/` and `mount-platform-fs-conformance.test.js:163`, plus `packages/agent-tools` and `packages/agentry`. Verified by probe (many seats): `makeMount({rootPath, readOnly, filePowers})` then `range(0n,5n).getInfo()` → `TypeError: makeSha256 is not a function`, while `.text()` on the same range succeeds (method-selective, late). The interface guard promises `getInfo` on *every* derived range; the implementation honors it only when the optional arg was supplied. No test calls `getInfo()` on a derived range.
- **Proposed fix:** make `makeSha256` required (or default it from `filePowers`), or `makeSha256 || Fail\`…\`` / `assertXxx` at `makeMountFileExo` construction so the failure names the missing power; **and** add a mount test supplying `makeSha256` that asserts the derived range's `{algorithm,hash,size}`. [rule: AGENTS.md § Type-assertion discipline; § Error handling.]
- **Disposition:**

### DMN-02 — a generated file was hand-Prettier'd; the generator will revert it and re-break lint
- **Severity:** must-fix
- **Seats:** packager#2
- **File:** `packages/daemon/src/help-text-data.js:2` (`AUTO-GENERATED … do not edit`); generator `packages/daemon/scripts/generate-help-text-data.mjs:36-46`
- **Claim:** commit `33bcdcf35` regenerated `help-text-data.js` (427 lines of unformatted `JSON.stringify`, tripping CI Prettier), and `034976bc4` then hand-Prettier'd the *artifact* (+275/−152). But the generator still builds lines with `JSON.stringify` and `fs.writeFileSync`s them with no Prettier pass, so the next regeneration re-breaks lint.
- **Proposed fix:** fix the generator (format before write), then regenerate — which also collapses 854 lines of round-trip churn to the ~28-line net diff. [proposed-rule: a commit that Prettier-formats an `AUTO-GENERATED` artifact fixes the generator, not the artifact.]
- **Disposition:**

### DMN-03 — daemon help lost three documented mount methods (`glob`, `grep`, `glorp`)
- **Severity:** must-fix
- **Seats:** archivist#2
- **File:** `packages/daemon/src/help-text-data.js` (regenerated); guards live at `packages/daemon/src/interfaces.js:664,673,684`; source `packages/daemon/src/help.md`
- **Claim:** the regeneration dropped the `glob`, `grep`, and `glorp` entries, yet all three remain live guards; `help.md` never carried them, so regeneration silently deleted the only copy — `E(mount).help('glob')` now returns nothing. Collateral of the regeneration, unrelated to range attenuation.
- **Proposed fix:** add the three `## …` sections to `packages/daemon/src/help.md` and regenerate.
- **Disposition:**

## should-fix

### DMN-04 — exo-label inconsistency across range adopters
- **Severity:** should-fix
- **Seats:** stylist
- **File:** `packages/daemon/src/manager.js:2269` (`'Transient blob range'`, tag `TransientBlob`), `:1842` (sentence label `` `Readable file range of SHA-256 ${…}...` ``, tag `EndoBlob`)
- **Claim:** four adopters are `<exo tag> range` (`LocalBlob range`, `BlobRef range`, `GitBlob range`, `EndoMountFile range`), but these two diverge.
- **Proposed fix:** make them `TransientBlob range` and `EndoBlob range`. [proposed-rule: a derived cap's exo label is `<parent exo tag> <derivation>`.]
- **Disposition:**

### DMN-05 — live-file `textRange` has no behavioral test
- **Severity:** should-fix
- **Seats:** prover
- **File:** `packages/daemon/test/mount-platform-fs-conformance.test.js:226`
- **Claim:** `mount-platform-fs-conformance.test.js:226` lists `'textRange'` in `ENDOMOUNTFILE_EXTENSIONS`, pinning only that the name exists. The live path differs materially from `BlobRef`'s (stat + `readFileRange` per read, byte offsets frozen at call time). prover probed it and it works (`'a\nb\nc\n'` → `textRange(1,3).text() === 'b\nc'`).
- **Proposed fix:** make prover's probe a test.
- **Disposition:**

### DMN-06 — every `readWindow` adds a `size()`/`statPath()` before the read that `fetch(offset,length)` did not
- **Severity:** should-fix (perf)
- **Seats:** benchmarker (artifact 16f2fe86ac20)
- **File:** `packages/daemon/src/manager.js:1828`, `packages/daemon/src/mount.js:1551`
- **Claim:** each `readWindow` adds a `size()`/`statPath()` before the read that the retired `fetch(offset,length)` path did not — an extra stat per windowed read. (benchmarker also notes `manager.js:1821`'s assertion that "only the requested `[start,end)` window leaves disk" is in tension with `textRange`'s whole-file read — see PLAT-04/05.)
- **Proposed fix:** avoid the redundant stat where the size is already known, or record the cost with a measurement.
- **Disposition:**

---

# Slice: git-and-docs (packages/git, packages/daemon-cas, READMEs, designs/) — 11 findings

## must-fix

### GD-01 — no changeset for a breaking, five-package public-surface removal
- **Severity:** must-fix
- **Seats:** packager#1, curator, migrator, changeset-auditor#1, integrator#2 (must-fix); releaser (must-fix-loop, gives the bump spec)
- **File:** `.changeset/` (empty; `git diff --name-status 3ec55851d..HEAD -- .changeset/` is empty)
- **Claim:** `.changeset/config.json` sets `privatePackages: {tag, version}`, so `private: true` is *not* an exemption — siblings already write changesets for these packages. This PR removes public exports (`rangeReadMethodGuards`, `rangeReadConvenienceMethodGuards`, `ReadableBlobRangeInterface`, `ReadableBlobRangeReadInterface`, types `ReadableBlobRange`/`ReadableBlobRangeRead`) and cap methods (`fetch`, `rangeRead`, `rangeReadText`) from `LocalBlob`, `BlobRef`, daemon `EndoBlob`/`EndoMountFile`, and the Git blob; and *adds* `streamBase64` to `BlobRefInterface` (reversing the "streamBase64 stays daemon-only" contract). Per-package deltas (changeset-auditor, artifact dafebe8fe9cb): `@endo/platform` drops the guards/interfaces; `@endo/daemon` `EndoBlob`/`EndoMountFile` lose `fetch`; `@endo/git` `GitBlob` drops `fetch`, gains `range`/`textRange`; `@endo/exo-git` re-aliases `ReadableBlob` → `RichReadableBlob`; `@endo/agent-tools` drops generated `GitReadableBlobRange`.
- **Proposed fix (releaser's recommendation):** one changeset covering `@endo/platform`, `@endo/daemon`, `@endo/git`, `@endo/exo-git`, `@endo/agent-tools` (+ `@endo/daemon-cas` per curator/migrator). Bump: `@endo/platform` **minor** (0.1.0 surface retirement), `@endo/daemon` **major** (`fetch` removed from `EndoBlob`), the rest **patch**. Include the `fetch`→`range(start,end)` / `rangeReadText`→`textRange` migration note (`length` → `end` is a semantics change, not just a rename).
- **Disposition:**

### GD-02 — the pending `.changeset/readable-blob-declarations.md` now describes a surface this PR retires
- **Severity:** must-fix
- **Seats:** curator, migrator, changeset-auditor#2
- **File:** `.changeset/readable-blob-declarations.md:10-13`
- **Claim:** that unreleased entry advertises "expose their actual `getInfo` and streaming `fetch` surface, while `rangeRead` and `rangeReadText` remain on the richer platform LocalBlob contract" — all three methods are gone before they ever shipped. "A description of the interface from an earlier draft is worse than no description; it actively misleads."
- **Proposed fix:** revise it in this PR, or fold it into the new entry.
- **Disposition:**

### GD-03 — `packages/daemon-cas/README.md:40` still documents the retired `ReadableBlobRange.fetch(bigint, bigint)`
- **Severity:** must-fix
- **Seats:** archivist#4, surfacer#2 (must-fix-loop), integrator#1; typist#5, curator, locksmith note, migrator, purist#6 (should-fix)
- **File:** `packages/daemon-cas/README.md:40`
- **Claim:** states `readRange` "is an internal safe-number helper used to implement public `ReadableBlobRange.fetch(bigint, bigint)`." Both the type and the method are retired. The identical sentence *was* fixed at `packages/platform/src/fs/types.d.ts:133` (→ `RichReadableBlob.range()`); the README mirror was missed.
- **Proposed fix:** rewrite to the `range` surface.
- **Disposition:**

### GD-04 — `packages/platform/src/fs/extended/DESIGN.md` still specifies `BlobRef.fetch(offset, length)` as normative
- **Severity:** must-fix
- **Seats:** surfacer#3 (must-fix-loop); archivist, curator (should-fix), migrator, integrator#2, purist#6
- **File:** `packages/platform/src/fs/extended/DESIGN.md:555,559,618,652` — *(doc lives under packages/platform; grouped here for the docs child — xref platform)*
- **Claim:** the extended layer's normative doc still specifies `BlobRef.fetch(offset, length)` (and `E(blob).fetch(0n, expectedSize)`) in the doc for the very surface this PR deletes. purist: the PR cites DESIGN.md §6/§C4 as the contract; leaving it describing a removed method makes the citation false.
- **Proposed fix:** update `fetch(offset,length)` → `range(start,end)` throughout, with the "since replaced per readableblob-range-attenuation.md" note.
- **Disposition:**

### GD-05 — the rename sweep stops short of the `designs/` catalog + roadmap that *specify* against retired names
- **Severity:** must-fix
- **Seats:** archivist#3 (must-fix), integrator#1/#3; migrator, purist#6 (should-fix), archivist#6/#7 (should-fix / comment)
- **File:** `designs/fs-interface-reconciliation.md:1209,1211,1241,1245,1279` (catalog); `designs/fs-interface-consolidation.md:428`; `designs/README.md:80,732`; `designs/agentry-git-eval-scenarios.md:117,127,133,158,160,171,431`
- **Claim:** `fs-interface-reconciliation.md` still names `rangeReadMethodGuards`, `ReadableBlobRangeInterface`, and `fetch` as the *shipped* shapes (the catalog `fs-interface-consolidation.md` itself calls "the prose vocabulary (C5)"). `fs-interface-consolidation.md:428` still reads "`EndoMountFile` + the `EndoMountReadableBlob` view gain `getInfo`/`fetch`" in a checklist whose neighbours this PR rewrote. `agentry-git-eval-scenarios.md` is a Not-Started spec that *instructs a future builder* to use `rangeRead`/`rangeReadText` (and "must not pass those values to `fetch`"). `designs/README.md` describes the agentry eval path in terms of `fetch`/`rangeRead`/`rangeReadText`. [integrator: a PR that retires a public method sweeps `designs/` for roadmap docs that *specify* against it, not merely mention it.]
- **Proposed fix:** apply the same "since replaced per readableblob-range-attenuation.md" note this PR gave `fs-interface-consolidation.md`'s neighbouring entries, across all four docs.
- **Disposition:**

## should-fix

### GD-06 — git `readWindow` returns a widenable view, not a copy
- **Severity:** should-fix
- **Seats:** warden#3
- **File:** `packages/git/src/native-git-backend.js:1910`
- **Claim:** returns `bytes.subarray(from, to)` over the whole materialized object; the other four producers copy (`blob-ref.js captured.slice`, `manager.js bytes.slice`, fresh buffers in `local-blob.js`/`readFileRange`). The selection carries the full object's `ArrayBuffer`, so the first method that hands bytes out leaks past the attenuation. Not exploitable today (nothing returns raw bytes across the exo).
- **Proposed fix:** use `.slice()` for consistency. [proposed-rule: a `readWindow` primitive backing an attenuation returns a copy, never a view onto a wider buffer.]
- **Disposition:**

### GD-07 — commit hygiene: a lint autofix is bundled with substance and docs; commits don't read as a merge history
- **Severity:** should-fix
- **Seats:** packager#3, integrator#5; fast-checker note (a devDependency line bundled in)
- **File:** commit `336c4bd37` (+ history shape)
- **Claim:** `336c4bd37`'s semicolon-joined title names three concerns: a `no-inline-import-jsdoc` autofix (`blob-range.js`, `mount.js`), a substantive TS surface change (`daemon/src/types.d.ts`, `fetch`→`range`/`textRange`), and 129 lines of `designs/*.md` prose. fast-checker additionally flags a stray devDependency line bundled with the round-trip changes.
- **Proposed fix:** split into the autofix, the type change (squashed into `33bcdcf35`), and a `docs:` commit. [rule: skills/pr-formation, roles/jurors/packager § conflated autofix.]
- **Disposition:**

### GD-08 — unrelated ASCII-arrow / character-set churn across the design docs
- **Severity:** should-fix — **DISPUTED** (integrator#4: should-fix; archivist: explicitly *not* flagged — "style churn, not accuracy")
- **Seats:** integrator#4 (flag); archivist (decline)
- **File:** `designs/*.md` (the design-doc diffs convert `→ ↔ ← …` to ASCII throughout)
- **Claim:** integrator — the diffs convert arrows/typography to ASCII throughout, unrelated to range attenuation, inflating the diff. archivist declined it as style churn not affecting accuracy. Resolve the split before acting: if kept, it is a `docs:`/formatting concern; if declined, reply saying why.
- **Proposed fix:** either revert the unrelated character-set churn (integrator), or reply declining per archivist's reasoning. Downstream decides and answers.
- **Disposition:**

### GD-09 — `readableblob-range-attenuation.md` flipped to *Accepted — implemented* but its "Current surface" section is stale, and two path citations are wrong
- **Severity:** should-fix
- **Seats:** archivist (artifact 16f2fe86ac20)
- **File:** `designs/readableblob-range-attenuation.md` (§"Current surface and…", `:43`, `:155`); `packages/platform/src/fs/extended/shared/blob-ref.js:1-11`
- **Claim:** the doc flipped to *Status: Accepted — implemented* but its "Current surface" section is stale; `:43` and `:155` cite `shared/blobref.js` when the file is `packages/platform/src/fs/extended/shared/blob-ref.js`; and `blob-ref.js:1-11`'s header lists the exo's surface but omits `streamBase64`.
- **Proposed fix:** refresh the "Current surface" section, fix the two path citations, add `streamBase64` to the `blob-ref.js` header.
- **Disposition:**

### GD-10 — no regression-test note in the PR body
- **Severity:** should-fix
- **Seats:** prover#6
- **File:** PR #910 body (Verification section)
- **Claim:** the Verification section lists tsc/eslint results and test counts, which is not the break/observe/revert experiment the regression-evidence note names.
- **Proposed fix:** add a regression-test note describing the break/observe/revert experiment. [rule: skills/regression-evidence § Output shape.]
- **Disposition:**

## comment-only

### GD-11 — note-this asks are all closed; the `crypto`-free `hashBytes` rationale is durably captured (no action)
- **Severity:** comment-only
- **Seats:** scribe (both findings summary-fix; neither blocks)
- **File:** — (surface walk: `pulls/910/comments` 0, `issues/910/comments` 0; originating design PR #826 asks closed in `256e2a9b1` / by this PR / by PR #832)
- **Claim:** #910 carries no maintainer note-this ask; the `crypto`-free `hashBytes` injection rationale **is** durably captured (module docstring, `packages/platform/src/fs/blob-range.js:14-23`). Recorded for completeness; no fix required.
- **Disposition:** no action (scribe — durably captured).

---

## Appendix — cross-seat corroboration map (top recurring issues)

| Issue | Seats | Severity |
| --- | --- | --- |
| DMN-01 makeSha256 optional-but-called | assessor, typist, prover, migrator, locksmith, warden, saboteur, spec-keeper, corner-prober, purist, breaker, wire-watcher, engine-realist, transplanter (14) | must-fix |
| PLAT-08 interface-tag collision | stylist, curator, archivist, breaker, surfacer, typist, warden, purist, spec-keeper, locksmith, wire-watcher (11) | must-fix |
| GD-01 no changeset | packager, curator, migrator, changeset-auditor, integrator, releaser (6) | must-fix |
| GD-03/04/05 rename sweep incomplete (docs) | archivist, surfacer, integrator, typist, curator, migrator, purist, locksmith (8) | must-fix |
| PLAT-14 compose newLo unclamped | assessor, purist, locksmith, saboteur, wire-watcher, prover (6) | should-fix |
| PLAT-03/16 range end mandatory / whole-window | breaker, purist, integrator, saboteur, engine-realist (5) | must-fix / should-fix |
| PLAT-04/05 textRange reads whole file | benchmarker, saboteur, assessor, engine-realist (4) | must-fix |
| PLAT-06 textRange live-source line→byte decay | wire-watcher, locksmith, saboteur (3) | must-fix |
| PLAT-09 M.promise guarantee not enforced | breaker, warden, spec-keeper, purist (4) | must-fix (DISPUTED) |
