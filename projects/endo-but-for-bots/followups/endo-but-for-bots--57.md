---
project: endo-but-for-bots
pr_repo: endojs/endo-but-for-bots
pr_number: 57
upstream_mirror_repo: null
upstream_mirror_pr: null
created_at: 2026-05-21T06:57:00Z
last_appended_at: 2026-05-21T06:57:00Z
status: parked
---

# Follow-ups for endojs/endo-but-for-bots#57

Created from the code-panel verdict (23 seats, in-band fallback) on `feat(marshal,pass-style): admit immutable ArrayBuffer through codecs`. The panel surfaced seven items the judge dispositioned as `follow-up` because they are useful but out of scope for this PR's un-draft. Revisit when the PR merges (or when the upstream mirror merges, once the boatman opens it).

## Items

- [ ] **Tighten `EncodingClass<'byteArray'>` data-field type.**
  **Source juror(s)**: typist.
  **Round**: 1.
  **Recommended action**: amend `packages/marshal/src/types.js:51` to brand the `data` field with a `Hex` string alias or JSDoc-link to `byteArrayToHex` so the reader knows the format. Out of scope here because the type is consumed by a layer that does not type-check the hex content.

- [ ] **Agoric-SDK release-notes mention of `@endo/hex` transitive add.**
  **Source juror(s)**: migrator.
  **Round**: 1.
  **Recommended action**: when `@endo/pass-style` and `@endo/marshal` are next released downstream of this PR, surface in the Agoric-SDK upgrade notes that `@endo/hex` is now a transitive runtime dep of `@endo/pass-style`. No code change needed; a release-notes line.

- [ ] **Uppercase-hex pinned-rejection test on encode-passable.**
  **Source juror(s)**: saboteur.
  **Round**: 1.
  **Recommended action**: add one test in `packages/marshal/test/byteArray.test.js` that confirms `decodePassable` rejects an `a`-body whose hex contains uppercase characters (since the regex `[0-9a-f]*` excludes uppercase but `@endo/hex`'s `decodeHex` accepts both cases). Pins the case-sensitivity invariant on the wire format so a future regex relaxation does not silently change shortlex semantics.

- [ ] **Rank-order cover constants test for byteArray.**
  **Source juror(s)**: breaker.
  **Round**: 1.
  **Recommended action**: add a brief test in `packages/marshal/test/rankOrder.test.js` (or wherever rank covers are pinned) that confirms the byteArray cover lives between the promise cover and the boolean cover by reference to the named constants in `passStylePrefixes`, not by computed example encodings. Resilient to encoder refactor.

- [ ] **`passStylePrefixes` single-character-default comment.**
  **Source juror(s)**: purist.
  **Round**: 1.
  **Recommended action**: amend the prefix-table comment in `packages/marshal/src/encodePassable.js:910-928` to document that single-character prefixes are the default and multi-character lists (`'np'`, `'[^'`) are the documented-variant case. Helps future readers adding a new pass-style.

- [ ] **Drop `@ts-expect-error` annotations on `sliceToImmutable` after TC39 stage-4 lands.**
  **Source juror(s)**: spec-keeper.
  **Round**: 1.
  **Recommended action**: when the immutable-ArrayBuffer TC39 proposal advances to stage 4 and the lib.es types include `sliceToImmutable` and `.immutable`, revisit `packages/pass-style/src/byteArray.js:39, 116` and drop the `@ts-expect-error` shim annotations.

- [ ] **Shim-allocation cost JSDoc note on `byteArrayToUint8Array`.**
  **Source juror(s)**: engine-realist.
  **Round**: 1.
  **Recommended action**: amend the JSDoc at `packages/pass-style/src/byteArray.js:73-92` for `byteArrayToUint8Array` to note explicitly that on the `@endo/immutable-arraybuffer` shim path (XS today), each call allocates a fresh mutable copy of the source bytes. The native (V8) path is zero-copy. Helps XS-side callers budget for the cost.

- [ ] **`packages/pass-style` README enumeration of new helpers.**
  **Source juror(s)**: surfacer.
  **Round**: 1.
  **Recommended action**: if `packages/pass-style/README.md` enumerates its exported helpers, add `byteArrayToHex`, `hexToByteArray`, `byteArrayToUint8Array`, `uint8ArrayToByteArray` to the list. If the README does not enumerate (verify first), no action.

- [ ] **PR-body "Documentation Considerations" mild padding.**
  **Source juror(s)**: pruner.
  **Round**: 1.
  **Recommended action**: trim the "Documentation Considerations" section in PR #57's body since it largely paraphrases the cheatsheet diff. Optional; touches PR body only. Low priority.

- [ ] **#2871 sibling-PR tracking for `compareRankRemotablesTied`.**
  **Source juror(s)**: integrator.
  **Round**: 1.
  **Recommended action**: when the sibling PR for the `rankOrder.js` `compareRankRemotablesTied` refactor lands (cited in the PR body as deferred), confirm the `unsortedSample` / `sortedSample` byteArray entries from #2871 are restored in that PR's diff. No action on this PR's surface.
