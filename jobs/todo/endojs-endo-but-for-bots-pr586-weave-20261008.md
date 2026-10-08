---
role: weaver
arc: endo-ocapn-background
pr: https://github.com/endojs/endo-but-for-bots/pull/586
tier: mentor
fallback-tier: minion
dispatch: automatic
---

# Weave endojs/endo-but-for-bots PR #586 onto a base that contains #468

PR #586 (test-only: `packages/immutable-arraybuffer/test/shim-typedarray-ctor-bounds.test.js`)
tests the freezable-TypedArray emulation (`makePseudoTypedArrayConstructor`) that landed in
ebfb#468 (merge 80e9b3e906, on ebfb `master`). On 2026-07-17 the PR was re-pinned to the
frozen base `master-46d4edf` (an upstream-endo commit that does NOT contain #468), so on
its current base 88 of the 96 new cases fail (`view.buffer` is the genuine AB, not the
immutable wrapper); every case passes against `origin/master`'s `src/`. CI never ran at
the current head 24e992ed3 (only Copilot Setup Steps), so the breakage is latent.

Task: pin the merge base to the current ebfb `master` tip (frozen `master-6ee3fda` already
exists) and rebase the 4 PR commits onto it; move the PR base field; then verify
`yarn --cwd packages/immutable-arraybuffer test` passes and CI goes green. The gauntlet
endojs-endo-but-for-bots-pr586-gauntlet-20261007 halted at its clean stage on this.
