---
ts: 2026-05-22T01:21:55Z
kind: result
role: builder
project: endo
repo: endojs/endo-but-for-bots
refs:
  - entries/2026/05/22/010659Z-dispatch-liaison-f30c2e.md
---

# Mirror of endojs/endo#3033 onto endo-but-for-bots@llm

## Outcome

Opened DRAFT PR https://github.com/endojs/endo-but-for-bots/pull/347
(`mirror/3033-ocapn-cbor` -> `llm`) at head SHA
`e3089cc2ba4ad3ba8486b0f16ede65a18e80f94c`. Single substantive commit on
top of `llm` head (`68246ad92`):

- `e3089cc2b fix(ocapn): @type bigint JSDoc on syrupReader.readInteger() return`

No separate `chore: Update yarn.lock` commit was needed: llm already
carries the `cbor: ^9.0.2` devDep that the upstream PR's lockfile churn
added.

## Subsumption finding

The upstream PR (#3033, 50 files, +5832/-464, DRAFT) is **largely
already on llm** via PR #59 (`feat(ocapn): codec injection +
network/transport split`, commit `9403bfa84`), which is a superset of
#3033's first commit. Subsequent llm refactors (PR #223 dropping
`buffer-utils.js` for `@endo/bytes`/`@endo/hex`, the
`97a172a62`/`a8bdb88f7` follow-up fixes, and the `@noble/hashes` bump)
further evolved the package beyond #3033's tree.

Per-commit subsumption table is in the PR body. The only un-replayed
substance that applied cleanly to llm without erasing intervening
refactors is the two `/** @type {bigint} */` JSDoc casts on
`syrupReader.readInteger()` returns in `subtypes.js` (from #3033's
`d673e0cd5 fix(ocapn): Address latent type errors`). The other fixups
are either present in a different shape on llm
(`sturdyrefs.js` uses `/** @type {any} */` cast at line 83;
`recordLabelType` field is on Reader/Writer classes already) or are
stylistic refactors (`ref-kit.js` let-then-fall-through to early-return)
that would erase llm's evolution.

## Strategy notes (for future mirror dispatches)

Tried two automated merge strategies before settling on the surgical
approach:

- `git merge --squash -X theirs endo-upstream/kriskowal-ocapn-cbor` over
  llm: clean merge but produced **broken code** (e.g.,
  `packages/ocapn/src/syrup/codec.js` retained llm's `bytesFromText` /
  `bytesToImmutable` imports but called upstream's
  `encodeStringToImmutableArrayBuffer`, which is no longer imported).
- `git merge --squash -X ours` over llm: produced **broken code** in a
  different way (duplicate variable declarations in `ref-kit.js`).

Neither auto-strategy gives a coherent tree when both branches have
substantially evolved post-divergence. The mirror/3036-exo-stream
pattern (small surfacing commit + subsumption analysis in PR body) is
the right precedent for this shape; mirror/3032-cancel's clean
cherry-pick was possible because the upstream and llm had no overlap on
the cancel package.

## Local validation per CLAUDE.md

- `yarn format` -- clean
- `cd packages/ocapn && yarn lint` -- 0 errors, 172 pre-existing warnings
- `yarn docs` -- 0 errors, 69 warnings (typedoc image-path warnings, unrelated)
- `cd packages/ocapn && yarn test` -- 531 tests passed

## Authorization scope respected

- Pushed only to `mirror/3033-ocapn-cbor` on `endojs/endo-but-for-bots`
- Opened only the new draft PR (#347), comment posted only as the PR's
  body
- No interaction with `endojs/endo` (read-only via `gh pr view` to
  fetch upstream PR metadata; the upstream branch was already in the
  worktree as `endo-upstream/kriskowal-ocapn-cbor`)

Self-improvement: when a mirror dispatch lands on a heavily-subsumed
upstream PR (substance already integrated via prior fork-side PR plus
post-divergence refactors), prefer the mirror/3036-exo-stream pattern
(small surfacing commit + comprehensive subsumption analysis in PR
body) over either automated merge strategy. `-X theirs` and `-X ours`
both produce broken trees when the divergence is substantial because
each side has imports and call sites the other lacks. The honest
mirror is the subsumption analysis itself, with a small additive bit
the upstream PR carries that llm hasn't yet absorbed.
