# Fix round 5 for endojs/endo-but-for-bots#1417: fixes pushed, CI green

I pushed two follow-up commits to the PR head `llm-confined-application-makers-p1`, moving it from `e354acc765` to `7e0be5e1a2` (via `safe-push-pr-head.sh --mode advance`). `ci-wait-merge` returned rc=0: all 33 checks passed. Locally, all 57 tests in `tree-read-powers.test.js` pass, and eslint (0 errors), tsc and prettier are clean.

## The must-fix item: hardening `segments`
- `toSegments` and `pathToFileURL` now `harden` their segment arrays.
- I added a test that reads through a `makeLoopback` CapTP tree, covering `read` and `maybeRead` for a file, a missing file, a path through a file, and a directory. I also added a test that every array passed to `lookup` is frozen.
- **The warden's failure scenario does not happen in practice.** `E()` already hardens its arguments (`eventual-send/src/handled-promise.js:491`). With the explicit `harden` removed, both new tests still pass, so they cover the behavior but would not catch that change. The explicit `harden` is defensive, and the docstring says so.

## Should-fix items applied
- **Lone surrogates:** `decodeSegment` now refuses a segment that cannot be encoded. `read`, `maybeRead`, `fileURLToPath`, `canonical` and `pathToFileURL` all give the same "Unencodable path segment" error, and there is a test for it.
- **Raw tab, LF, CR and other control characters:** refused with "Unsupported characters". They are also added to the confinement test list and the `pathFragment` property, and `isSafeSegment` rejects them.
- **Separator checks:** I removed the two redundant pre-checks (the escaped-separator check on a segment and the raw-backslash check on the rest). The check on the decoded segment is now the one guard, and a comment says so. The escaped-separator pattern is still used for the root only.
- **Empty segments:** they now collapse in every power, the way Node's `fs` reads `lib//index.js`. `maybeRead` no longer aborts on them, and a test covers the change. A `canonicalSegments` hook result with an empty segment is refused; a hook result of `[]` (the root) is tested.
- **Type depending on a devDependency:** `TreeReadPowers` is now defined locally in `src/fs/types.ts`. A test checks that it is assignable to `MaybeReadPowers`.
- **File or directory:** `isFile` now uses `kind()` when the entry has one, as `checkinTree` does, with the byte-reader check as the fallback. A test covers it.
- **Option name:** the `canonical` option is renamed to `canonicalSegments`. Tests, the changeset and the design doc are updated.
- **Smaller items:** the header notes that a host `URL` global is required. The Node-escaping note now says it was confirmed on Node 22 and 24. `fileURLToPath` checks for a string instead of using `instanceof URL`. There is a test that `a%252fb` looks up the literal name `a%2fb`.

## Items declined, with the reason
- **Reusing `isPathWithin`:** it compares paths with no trailing `/`, so it would count `file:///app` as inside `file:///app/`. A comment at `isUnderRoot` explains this, and `toSegments` now calls `isUnderRoot` instead of repeating the check.
- **Trying `has(...segments)` before the walk:** not safe. `makeLocalTree`'s `has` only checks the first name, so a whole-path `has` cannot decide whether the path is absent. This is documented on `isAbsent`.

## Left for later
- **Regrouping into about four commits** (integrator): not done. This stage's instructions say to add follow-up commits, not rewrite history, so the regrouping is left for the clean or retcon step before un-draft.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/build-confined-application-makers-p1-20261002-gauntlet-fix-5.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 80 tokens (3329816 cached reads)
- Output: 25018 tokens
- Cost: $1.9579232
- Wall-clock: 2416s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
