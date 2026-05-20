---
ts: 2026-05-20T05:58:43Z
kind: result
role: boatman
repo: endojs/endo
project: endo
refs:
  - entries/2026/05/20/055402Z-dispatch-liaison-456f58.md
---

Recomputed endojs/endo#3256 from upstream master and force-pushed with
lease to replace the prior 9-commit fast-forward-append shape with the
new 4-commit reshape from endojs/endo-but-for-bots#109.

## Upstream head after force-push

`f5182df17` on `feat/syrups-package`.

Four new commit SHAs, in order:

1. `3d4d265fe` feat(syrup-frame): add @endo/syrup-frame package
2. `eaa96182c` feat(ocapn): add opt-in syrup framing to TCP-testing netlayer
3. `f9ea9accd` chore: Update yarn.lock
4. `f5182df17` chore: regenerate composite tsconfig files

## Attribution

All four commits carry `Kris Kowal <kriskowal@kriskowal.com>` for both
author and committer. Verified via `git log origin/master..HEAD
--pretty=fuller`. `git interpret-trailers --parse` reports no trailers
on any of the four commit messages (no `Co-authored-by`, no bot
attribution).

## Pre-flight ancestor/lease check

`git fetch origin feat/syrups-package` reported the lease tip at
`e691e86d8fc7f64d23854a1e3f3fddb29af3b1be`, matching the dispatch's
lease value. No concurrent push had landed.

## Push mode

`git push origin HEAD:feat/syrups-package
--force-with-lease=feat/syrups-package:e691e86d8fc7f64d23854a1e3f3fddb29af3b1be`.
Lease honored; the push reported `+ e691e86d8...f5182df17 HEAD ->
feat/syrups-package (forced update)`. Not unsafe `--force`.

## Cherry-pick conflicts

None. All four source commits applied cleanly onto current
`origin/master` (`c063631fed3957b3627855642185de7a4e3b965e`). The
`yarn.lock` commit applied without conflict, so no regeneration was
needed. The composite-tsconfig regeneration commit applied cleanly.

## kumavis approval persistence

`gh pr view 3256 -R endojs/endo --json reviewDecision,reviews`
reports `reviewDecision: APPROVED`, with kumavis's APPROVED review
anchored at `ed80869d4fe2b325a13e8bf2639f0422f3fae57c` still present.
The reviewDecision did not revert.

## Naming finding

The upstream PR title carries plural `syrups` (`opt-in syrups
framing for OCapN TCP-for-testing`) and the branch is
`feat/syrups-package` (plural), but the code paths and identifiers
throughout are singular `syrup`:

- Package name: `@endo/syrup-frame`.
- Import paths: `import { makeSyrupReader } from
  '@endo/syrup-frame/reader.js'`.
- Function names: `makeSyrupReader`, `makeSyrupWriter`,
  `makeSyrupDeframer`, `makeSyrupWritingSocketOperations`.
- Framing option value: `'syrup'`.
- Test file: `packages/ocapn/test/netlayer-tcp-syrup.test.js`.
- Changesets: `.changeset/syrup-initial.md` (package `@endo/syrup-frame`)
  and `.changeset/ocapn-tcp-syrup-framing.md` (singular).

The title/branch (plural) are the outliers; the code is consistent
singular. Per dispatch instructions, this is reported, not edited.

## Source-side cross-link

Comment posted on `endojs/endo-but-for-bots#109` under kriskowal:
https://github.com/endojs/endo-but-for-bots/pull/109#issuecomment-4494988553

Names the new upstream head, the four-commit reshape, the
force-with-lease push, the approval persistence, and the
title-vs-code naming mismatch.

## Upstream PR

- URL: https://github.com/endojs/endo/pull/3256
- State: OPEN, MERGEABLE, APPROVED (kumavis).
- Title and body untouched per dispatch scope.

Self-improvement: nothing this time; the recompute-from-master shape
applied cleanly and the trailer-strip / reset-author per cherry-pick
pattern is already well-rehearsed.
