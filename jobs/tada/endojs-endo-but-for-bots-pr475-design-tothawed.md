The design note is posted with the reply marker and provenance footer. The job is complete.

## Completion report

**Job:** Design the shared `toThawed` byte-thawing helper + benchmark decision for endojs/endo-but-for-bots PR #475 (design-only; sibling job `9885f3d8` owned the fix branch).

**Re-derived state on clean start:** The sibling implementation already landed the read-path fixes at head `c33a5845c` (equals/base64/ocapn). Only the auto-reply "On it" comment existed for the directive (`5334566218`) — no design note had been posted yet. So the deliverable was unfinished.

**What I did:**
1. **Inspected the current helpers** in an isolated project checkout: `toIndexableUint8` (compare/equals/base64), `toMutableChunk` (concat), `toDecodable` (to-string), `asUint8View` (hex), `bytesFromImmutable` — all containing the same thaw primitive.
2. **Probed the emulated wrapper** under the shim: confirmed `isView === false`, integer-index reads `undefined`, but `view.at(i)` delegates correctly to the hidden TypedArray, and on Node *every* passable byteArray is an emulated wrapper (native immutable exists only on XS).
3. **Wrote and ran a Node micro-benchmark** (exponential-probe timer, mirroring `packages/base64/test/_bench-main.js`) comparing in-place `view.at(i)` vs `toThawed` copy + indexed reads across 1 B–1 MiB, plus a partial-read scenario. Key results (Node v22.23.2): full-scan crossover ≈ **16–32 bytes** (thaw wins beyond, up to ~46× by 64 KiB); but for **partial/early-exit reads `.at()` wins at every buffer size** because thaw's cost is O(buffer) while `.at()` is O(reads).
4. **Settled the home-package question** via the dependency graph: `@endo/immutable-arraybuffer` is the only dependency-leaf, so it's the right home (homing in `@endo/bytes` would force hex/base64 to take a heavier new dep).
5. **Posted the design note** to PR #475 addressed to @kriskowal, under the directive comment: [`#issuecomment-5336280364`](https://github.com/endojs/endo-but-for-bots/pull/475#issuecomment-5336280364). It specifies the `toThawed` API/home/signature/contract, the `isView`+`toThawed` composition, a per-site recommendation (thaw for to-string/concat/hex/base64; `.at()` in place for equals/compare), the honest caveat, that XS needs no shim path, and names a single follow-up build for the dedup rather than leaving it loose.

**Follow-up (named, not loose):** a single build to (1) add `toThawed` to `@endo/immutable-arraybuffer` and re-export `bytesFromImmutable`, (2) point hex/base64 encode at it to reach the native codec, (3) optionally switch equals/compare to `.at()` — proposed to the maintainer, pending his word (or hand-off to `9885f3d8`).

No garden repo changes; benchmark run as scratch (not committed, to avoid racing the sibling's PR-head branch), full source and numbers included in the posted note.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr475-design-tothawed.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 4 on 2 host(s) (2 unmetered)
- Input: 51 tokens (2006190 cached reads)
- Output: 30916 tokens
- Cost: $2.667499 (2 engagement(s) unpriced)
- Wall-clock: 516s
- Model(s): claude-opus-4-8 ×2

<!-- garden-usage-end -->
