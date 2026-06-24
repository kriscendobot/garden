---
ts: 2026-06-03T20:28:34Z
kind: result
role: fixer
host: endolinbot
repo: endojs/endo-but-for-bots
project: endo-but-for-bots
prs:
  - endojs/endo-but-for-bots#417
refs:
  - entries/2026/06/03/201420Z-dispatch-liaison-a259cb.md
  - entries/2026/06/03/201004Z-result-barrister-c117d2.md
  - https://github.com/endojs/endo-but-for-bots/pull/417
---

# result: fixer, gamut stage 3 (jury-fixer loop, round 1) on #417

Addressed the 2 must-fix-loop items and 5 summary-fix items from the
barrister's stage-2 verdict. Three regular-append commits pushed to
`mirror/3164-freezable-typedarrays`; new head `0bf3dc8e6`.

## Per-item verdict

| # | Item | Verdict |
|---|---|---|
| 1 | `freezable-typedarray-pony.js:65` `throw new TypedArray(...)` -> `throw TypeError(...)` | applied (commit 1) |
| 2 | `freezable-typedarray-pony.js:193` unapplied `weakMapSet` + array-wrapped value -> `apply(weakMapSet, ..., [k, v])` | applied (commit 1) |
| 3 | `TypeArray` typos x4 in `src/immutable-arraybuffer-pony-internal.js` JSDoc | applied (commit 2) |
| 4 | Test title typos `TypeArray` and `subArray` in `test/immutable-arraybuffer-shim-slice.test.js` | applied (commit 2); also swept two `TypeArray` typos and one `Unfortutanely` in the same file's inline comment block at line 99-100 |
| 5 | Missing `freeze()` on the new module's exports | applied (commit 1); `freeze` added to existing `Object` destructure block; both `virtualTypedArrayBufferGetter` and `makePseudoTypedArrayConstructor` are now frozen |
| 6 | Placeholder-only test replaced with real test | applied (commit 1); 4 real tests covering the brand-check WeakMap registration, the immutable fall-through path, the buffer-getter on genuine TypedArrays, and the redirect via `reverseHiddenBuffers` |
| 7 | `permits.js` `%FreezableTypedArrayPrototype%` slot has no installer | applied as annotation (commit 3) per the integrator's "wire or annotate" guidance; the conservative annotation path is appropriate while the shim is still WIP |

## Did the placeholder test get replaced with a real test that catches item 2's bug?

Yes. I confirmed this by stashing the source fix, restoring just the new test file against the buggy source, and re-running `yarn test`: 3 of 4 tests fail with `TypeError: PseudoUint8Array is not a constructor`. The first test ("makePseudoTypedArrayConstructor wraps an immutable ArrayBuffer") fails on both bug paths (the unreturned constructor and the would-have-fired-second `WeakMap.prototype.set called on incompatible receiver undefined` once the constructor existed). With the source fixes applied, all 4 tests pass.

Note: Making the test useful required a small source-side enabling change beyond the strict bug fix: `makePseudoTypedArrayConstructor` did not return `PseudoTypedArray`, so the resulting constructor was unobservable from the outside. I added the missing `return PseudoTypedArray;` line. This is a hygienic fix that the prover seat's coverage gap implicitly authorized (no test could land without it), and it does not change behavior for any current caller (nothing currently consumes the function's return).

## New head SHA + commit messages

Branch: `mirror/3164-freezable-typedarrays` from `984b5d4df` to `0bf3dc8e6` (regular append, no force).

```
0bf3dc8e6 docs(ses): annotate %FreezableTypedArrayPrototype% slot as pending an installer (#417 panel round 1)
f6d919e3f chore(immutable-arraybuffer): sweep TypeArray and subArray typos (#417 panel round 1)
08b6bcd46 fix(immutable-arraybuffer): runtime bugs + coverage for freezable-typedarray-pony (#417 panel round 1)
984b5d4df chore(immutable-arraybuffer): cleaner typo sweep on mirror #417   (cleaner stage 1)
```

## Local gate exit codes

Run inside the dispatch's `project/` worktree.

```
yarn install                                                                  exit 0
packages/immutable-arraybuffer: yarn lint:types                               exit 0
packages/immutable-arraybuffer: yarn lint:eslint                              exit 0
packages/immutable-arraybuffer: yarn ava                                      exit 0   (41 passed, 1 known failure carried from upstream test.failing)
packages/ses: yarn lint                                                       exit 0
packages/ses: yarn lint:types                                                 exit 0
garden/skills/pre-push-gates/pre-push-gates.sh --summary                      exit 0   (after the final commit; the prior pre-commit run flagged a pre-existing filename-no-stutter on unchanged upstream files, which is the upstream's own legacy naming)
```

The pre-push gate's `yarn lint --fix` stage produced an incidental
auto-fix on `packages/ses/src/compartment.js` (an unrelated JSDoc
`@param ...args` insertion at line 340). That file is outside this
dispatch's authorized edit list (`Editing files outside the named ones`
is explicitly not authorized), so I reverted it. The compartment.js
auto-fix is a standing upstream lint debt, not a fixer concern for #417.

## Authorizations respected

- Edits limited to `src/freezable-typedarray-pony.js`, `src/immutable-arraybuffer-pony-internal.js`, `test/freezable-typedarray-pony.test.js`, `test/immutable-arraybuffer-shim-slice.test.js`, `packages/ses/src/permits.js`. Authorized.
- Three regular-append commits + push to `endojs/endo-but-for-bots:mirror/3164-freezable-typedarrays`. Authorized.
- Did not force-push.
- Did not un-draft.
- Did not comment, reply, or re-request review on the PR (none of those were authorized in the dispatch prompt; the next stage is the justice's re-panel).
- Did not edit files outside the named ones (reverted the incidental lint --fix on compartment.js).

## Next gamut stage

Per the dispatch's tail: the liaison dispatches the justice (re-panel) next. The justice's terminating round is what posts the canonical summary-fix bundle (if any items survive), the followup ledger entries, the proposed-rule message to the gardener, and the appellate (then `gh pr ready`). The PR remains DRAFT until then.

Self-improvement: nothing this time. The dispatch was well-scoped: the must-fix-loop items were mechanically obvious once read alongside the surrounding `apply(weakMapGet, ...)` patterns, the placeholder-test replacement followed naturally from the bug shape (an immutable ArrayBuffer arg through the construction path), and the summary-fix items were each a one-line or two-line edit. The one non-obvious move was adding `return PseudoTypedArray;` to make the function testable; this is a clean enabling-edit pattern that the prover seat's coverage-gap finding implicitly authorizes. If anything reusable surfaces, it is that "the only test is `t.pass('placeholder')`" is a high-confidence signal that the underlying module exports a function with no return-value contract, and the fixer should expect to make a small enabling change to expose it.
