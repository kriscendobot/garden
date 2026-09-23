---
ts: 2026-06-07T06:47:08Z
kind: result
role: builder
host: endolinbot
project: endo-but-for-bots
repo: endojs/endo-but-for-bots
prs:
  - repo: endojs/endo-but-for-bots
    pr: 430
    role: output
  - repo: endojs/endo-but-for-bots
    pr: 417
    role: source
refs:
  - entries/2026/06/07/062500Z-dispatch-builder-490c42.md
  - https://github.com/endojs/endo-but-for-bots/pull/430
  - https://github.com/endojs/endo-but-for-bots/pull/417#pullrequestreview-4424101026
  - https://github.com/endojs/endo-but-for-bots/pull/417#issuecomment-4628329171
---

# result: no-spackle experiment PR #430 opened from #417's freezable-virtual-typedarrays per erights's six premises

PR #430 is open as DRAFT on `endojs/endo-but-for-bots` with base
`master-4a04d07` and head `experiment/no-spackle-immutable-arraybuffer-417`.
Eight commits in commit-by-commit reviewable order with no
overwrite-by-later-commits.

## Commits

| order | sha (local) | author | message |
|---|---|---|---|
| 1 | `721c68a` | Mark S. Miller | feat(immutable-arraybuffer): freezable virtual typedarrays |
| 2 | `2097641` | Mark S. Miller | fixup: everything after the simple move |
| 3 | `cfe99f7` | Mark S. Miller | fixup: partial progress |
| 4 | `bf8d934` | endolinbot | chore(immutable-arraybuffer): cleaner typo sweep on mirror #417 |
| 5 | `543b4cb` | endolinbot | fix(immutable-arraybuffer): runtime bugs + coverage for freezable-typedarray-pony (#417 panel round 1) |
| 6 | `7954a38` | endolinbot | chore(immutable-arraybuffer): sweep TypeArray and subArray typos (#417 panel round 1) |
| 7 | `e02ec0d` | endolinbot | feat(immutable-arraybuffer): shim installs freezable TypedArray pseudo-constructors with race-to-install |
| 8 | `1ef6c17` | endolinbot | test(immutable-arraybuffer): shim-level tests mirroring freezable-typedarray-pony tests |

Commits 1-3 are erights's original three commits from #417,
cherry-picked verbatim. Commits 4-6 are cleaner-and-fixup commits
from #417 that do not conflict with the no-spackle premise.
Commits 7-8 are the new substantive work that implements premise
3 (shim builds the pseudo-constructors) and premise 5
(race-to-install detect-then-skip).

## Decisions on the four #417 candidate fixups

- `08b6bcd4` (runtime bugs + coverage for freezable-typedarray-pony) — **kept**. Bug fixes that were uncovered by the pony's placeholder-only test; no spackle dependency.
- `f6d919e3` (TypeArray and subArray typo sweep) — **kept**. Pure typo fixes; no spackle dependency.
- `0bf3dc8e` (permits.js annotation that `%FreezableTypedArrayPrototype%` slot is *pending* an installer) — **dropped**. Under this experiment the shim IS the installer; the annotation would read backwards.
- `2071b71e` (README expansion documenting @endo/bytes spackle ramifications) — **dropped**. Spackle-specific documentation that no longer applies.

## Premise 2 partial deferral

Erights's premise 2 ("the immutable-arraybuffer package exports
only the shim") would require modifying
`packages/bytes/src/to-immutable.js`, which imports
`sliceBufferToImmutable` from `@endo/immutable-arraybuffer`. The
dispatch brief was explicit that packages outside
`immutable-arraybuffer` are out of scope, so I left
`packages/immutable-arraybuffer/index.js` re-exporting the pony.
Documented in the PR body and via a review comment to erights
(`issuecomment-4641694062`).

Premise 3 (shim install) and premise 5 (race-to-install) land in
full. Premises 1 (no spackle) and 6 (no new symbols) are honored
by the commits dropped from #417's sequence. Premise 4 (do not
export anything that should remain encapsulated) is honored
within the package boundary; the deferred premise 2 is what would
make the pony exports themselves package-internal.

## Test posture

- All 49 immutable-arraybuffer package tests pass (one pre-existing
  `test.failing` on the `Buffer.prototype.subarray` path is still
  expected-fail; the slice path now passes).
- The two existing shim tests that documented the prior shim's
  "treats immutable buffer as unrecognized" limitation are
  updated in commit 7 to assert the new wraps-as-emulated-freezable
  behavior.
- New file `test/freezable-typedarray-shim.test.js` (commit 8)
  with 8 tests mirroring the pony tests at the shim-install level:
  global Uint8Array on immutable / regular ArrayBuffer, the buffer
  getter both ways, byteLength + at via amplify, mutator
  complaints, subarray buffer redirect, race-to-install
  idempotence.
- `yarn lint` and `yarn lint:types` clean.
- Pre-push gate's `filename-no-stutter` probe flags inherited
  stutter on five `packages/immutable-arraybuffer/src/immutable-arraybuffer-*.js`
  files; these names exist on master and are not introduced by
  this experiment. Documented in PR body's *Notes for reviewers*.

## Review comment

Posted at `issuecomment-4641694062`. Two open questions for erights:

1. Premise 2 resolution: migrate `@endo/bytes` to use the
   installed `sliceToImmutable` method, OR add a private subpath?
2. The `getHiddenTypedArray` -> `amplifyTypedArray` rename + fall-
   through change: confirm the shape is what was intended.

## PR shape

- Base: `master-4a04d07` (frozen-base branch, pushed at dispatch
  start; sha matches `git rev-parse --short=7 origin/master`).
- Head: `experiment/no-spackle-immutable-arraybuffer-417`.
- State: DRAFT (stays DRAFT per the dispatch brief; no cleaner /
  judge / fixer / un-draft chain follows).
- Title:
  `feat(immutable-arraybuffer): no-spackle experiment from #417's freezable-virtual-typedarrays`.
- URL: <https://github.com/endojs/endo-but-for-bots/pull/430>.

## What was NOT touched

Per the dispatch brief's out-of-scope clause:

- No CI shepherding.
- No panel / judge / fixer / un-draft chain.
- No packages outside `immutable-arraybuffer` (which is why
  premise 2 is partially deferred — `@endo/bytes` would need to
  change to import the installed method or a private subpath).
- The eslint-plugin rule `7e98befed` is "dropped" by simply not
  cherry-picking it; the rule did not exist on master, so there
  is nothing to remove.
- No yarn.lock regen needed (no `package.json` dependency
  changes).

Self-improvement: nothing this time. The shape of the dispatch
(library-grounded brief, six premises with a precedent diff vs.
#417, explicit DRAFT-stays-DRAFT discipline) was clean enough that
the experiment shape fell out of the constraints. The one moment
of friction (premise 2 in tension with the out-of-scope clause on
`@endo/bytes`) was the right kind of friction: it surfaces a
maintainer decision rather than a procedural gap.
