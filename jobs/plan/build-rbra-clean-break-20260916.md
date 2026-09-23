---
gate: deferred
priority: normal
tier: mentor
handler-timeout: 10800
token-budget: 100000
doomed: true
doom_signature: deadline-overrun
doom_count: 1
failure_classification: deterministic
requeue_cycles: 1
deadline_overruns: 1
elapsed_constancy_confirmations: 0
doomed_at: 2026-09-17T05:43:37Z
doomed_on: endolin-garden-ece02cb4
posted_by: reaper:endolin-garden-ece02cb4
posted_at: 2026-09-17T05:43:37Z
---

---
tier: mentor
handler-timeout: 10800
---
<!-- garden-promoted-from-plan: gate=orchestrated priority=normal at=2026-09-17T02:34:51Z cleared=none -->

---
tier: mentor
fallback-tier: minion
dispatch: automatic
handler-timeout: 10800
---
Step 2 (the CLEAN BREAK) of ReadableBlob range attenuation on
endojs/endo-but-for-bots, per `designs/readableblob-range-attenuation.md`.
Prerequisite: step 1 (range/textRange adopted additively on ALL producers) is
merged into draft PR endojs/endo-but-for-bots#1301's branch
`kriscendobot:build/readableblob-range-attenuation`. STACK ON IT (resume via
`ensure-project-worktree.sh` + `git reset --hard
kriscendobot/build/readableblob-range-attenuation`; re-adopt #1301 with
`ensure-pr.sh` by the job marker — never open a new PR).

Replace `fetch`, `rangeRead`, and `rangeReadText` with `range`/`textRange` on
EVERY producer in one clean break — NO deprecated aliases (resolved decision 2).
`fetch` is NOT an alias of `range`: `fetch` returned a one-use
`PassableBytesReader`; `range` returns a same-interface `ReadableBlob`. Separate
the range-specific `fetch` from the unrelated HTTP / git-transport /
content-store `fetch` methods (design's inventory table is authoritative — read
it on the branch).

Producers to strip of `fetch`/`rangeRead`/`rangeReadText`:
`packages/platform/src/fs-node/local-blob.js`,
`packages/platform/src/fs/extended/shared/blob-ref.js`,
`packages/daemon/src/manager.js` (`makeReadableBlob`, `makeBytesBlob`),
`packages/daemon/src/mount.js` (`makeMountFileExo`, `makeReadableBlobView`),
`packages/git/src/native-git-backend.js` (`makeGitBlob`).

Guards: drop `fetch` from `rangeReadMethodGuards`/`BlobRefInterface`/daemon
`BlobInterface`, and drop `rangeReadConvenienceMethodGuards`
(`rangeRead`/`rangeReadText`) from `ReadableBlobRangeReadInterface`.

Consumers — update to the new cap shape, decoding/streaming through the normal
blob surface where they formerly drained a bytes reader:
- `packages/platform/src/fs/extended/cas.js` (`cacheBackedRead`: was
  `E(blobRef).fetch(0n, info.size)` → drainBytesReader). Read the whole blob via
  the surviving surface (e.g. `streamBase64` decoded, or the design's chosen
  path) — there is NO `fetch` anymore.
- `packages/platform/src/fs/extended/cached-fs.js` (`populateInBackground`: same
  `fetch(0n,size)` pattern).
- any daemon consumers that drained a range `fetch`.

Tests: update `packages/platform/test/{local-blob,blobref,node-fs,optimal-querying}.test.js`
and `packages/daemon/test/{endo,mount,git}.test.js` + mount conformance — remove
`fetch`/`rangeRead`/`rangeReadText` assertions, keep/extend the range/textRange
matrix and the method-set surface tests (which now must NOT list the removed
methods). Update `packages/platform/test/fs-types-source.test-d.ts` key-set
assertions. Update `packages/platform/src/fs/types.ts` +
`packages/platform/src/fs/extended/types.ts` (remove fetch/rangeRead*, keep
range/textRange) and `packages/exo-git/src/types.ts`.

Verify: full `packages/{platform,daemon,git,exo-git}` lint + lint:types +
test:types + ava. Push, keep #1301 draft. Report the consumer-rewrite approach
taken and whether the rename child can proceed.

<!-- garden-annotation: key=rbra-naming-5252703859 by=endojs-endo-but-for-bots-pr1301-review-34598631 at=2026-09-18T21:37:49Z -->

## Build-review naming directives (PR #1301 review #5252703859, kriskowal, 2026-09-18)

Recorded authoritatively in `designs/readableblob-range-attenuation.md`
(Resolved decisions 4 & 5; commit 5a42d0bff8 on the PR branch). Implement the
final ReadableBlob surface with THESE names, not the older spellings this job
body may still reference:

1. Read methods follow the {byte,text} x {all,range} cross product:
   `bytes` (all bytes) / `byteRange` (a byte range) / `text` (all text) /
   `textRange` (a text range). Concretely rename `fetch` -> `bytes` and the
   byte-range attenuator `range` -> `byteRange` (symmetric with `textRange`).
   `text`/`textRange` unchanged.
2. Replace the single `getInfo() => {algorithm,hash,size}` bundle with one
   accessor method per hashing algorithm (`sha256()`, `sha512()`, ...) plus a
   separate `size()` method. A blob may provide more than one algorithm and
   favor one internally; the surface migrates gradually (an added algorithm is
   a new method, not a reshaped bundle). Update guards, types, generated
   declarations (agent-tools code-mode-globals), help text, conformance tests,
   and design/API prose accordingly.
