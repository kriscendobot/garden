---
ts: 2026-05-13T21:38:22Z
kind: result
role: weaver
project: endo-but-for-bots
prs:
  - repo: endojs/endo-but-for-bots
    pr: 239
    role: mirror
  - repo: endojs/endo
    pr: 1967
    role: source
refs:
  - entries/2026/05/13/213320Z-dispatch-liaison-4c7051.md
  - entries/2026/05/13/212427Z-result-builder-f4b50a.md
---

# Result: weaver rebased endo#1967 mirror onto endo-but-for-bots master

Verdict: **rebased and opened draft.** PR `endojs/endo-but-for-bots#239` (https://github.com/endojs/endo-but-for-bots/pull/239). Head SHA `16d6ce92c40a000ec6bc6bf5ee02f13f80a2ffa4`. Branch `mirror/endo-1967` pushed to `origin` (endo-but-for-bots). Identity kriscendobot, draft per pr-creation-flow. Next stage is the shepherd.

## Per-file resolution

- **Six fixture files** (`packages/compartment-mapper/test/fixtures-policy/node_modules/app/attack-name.js`, `eve/getalice.js`, `eve/index.js`, `eve/node_modules/alice/{index.js,package.json}`, `eve/package.json`): applied unchanged via `git apply --index` (excluding the three drifted paths). Trailing-whitespace warning on `alice/index.js` autofixed by `git apply`.
- **`packages/compartment-mapper/test/scaffold.js`** (drifted): the upstream PR converts an always-on `t.log(sha512, sourceMap)` in `sourceMapHook` into a deferred `sourceMapLog.push(['+', ...])` that only flushes on size mismatch, and similarly adds a `['-', ...]` record in `computeSourceMapLocation`, and expands the throw to include the count. The fork had previously commented out the always-on `t.log` (just `// t.log(sha512, sourceMap);`), partially anticipating the upstream's intent. I made a targeted edit that introduces the `sourceMapLog` array, the two `push` calls, and the expanded mismatch message + flush-on-error block. Equivalent substance to the upstream patch.
- **`packages/compartment-mapper/test/test-policy.js` → `policy.test.js`** (drifted via rename): the fork renamed the file as part of a `test-<feature>.js` → `<feature>.test.js` migration. Applied the four upstream additions into the renamed file: the `nameConfusionAttack` URL constant (after `fixtureAttack`), the `evePolicy` object (after `anyPolicy`), the `nameConfusionExpectations` object (after `anyExpectations`), and the new `scaffold('policy - attack - duplicated name via bundled dep', ...)` registration (between the existing `policy - attack - scoped module alias` scaffold and the `recursiveEdit` helper). `nameConfusionExpectations.namespace` is wrapped in `moduleify(...)` to match the fork's existing convention for the other expectation objects in the same file. All anchors verified in place. `makeResultAssertions` (used by the new scaffold call) is a local helper at line 173 of `policy.test.js`.
- **`packages/compartment-mapper/test/snapshots/test-policy.js.snap`** (drifted via snapshot-scheme change): the fork emits snapshots as `snapshots/policy.test.js.{md,snap}` via ava's serializer; upstream's bare `.snap` is a different binary format. Per dispatch option (a), the snapshot is **omitted** and the PR body notes it must be regenerated locally. The new test does not call `t.snapshot()`, so absence of a snapshot does not cause a test failure (option b would have meant guessing the binary format; option a is honest).

## Regression-equivalence verdict

The rebased test exercises the **same regression** as upstream #1967. Mechanics line up directly: the same `attack-name.js` fixture (importing both top-level `alice/alice.js` and `eve/getalice.js`), the same `evePolicy` (entry packages: 'any', eve packages: 'any'), the same expectations matrix (`evilAlice` resolves to all-`undefined` because the bundled alice was not policied; canonical `alice` resolves to its policied results; `bob`, `carol`, `scopedBob` to their expected shapes), and the same `scaffold(...)` registration shape. The `moduleify(...)` wrap is a serialization-only difference (string-keyed export name normalization for the fork's snapshot scheme); it does not change the assertion semantics. The attack the test surfaces, that a `bundledDependencies` collision could silently substitute a bundled nested package for a policied top-level package, is the assertion the rebased test still makes.

One caveat: the fork's commented-out `t.log` in `scaffold.js`'s sourceMapHook means the fork was already running with sourceMap logging disabled in steady state, whereas upstream PR #1967 was running with it enabled (and converting it to deferred). My rebase implements the deferred form, which is strictly an improvement over either prior state. This does not affect the regression's behavior; it only affects diagnostic output on test failure.

## Self-improvement

Self-improvement: nothing role-level this time. One small craft note for future weavers handling a rename-plus-snapshot-scheme conflict: option (a) ("omit the snapshot, document it in the PR body") is the right default unless the upstream `.snap` is text and the fork's `.{md,snap}` pair is also text and the translation is mechanical. In this PR, the upstream `.snap` was binary (a single line `Binary files ... differ` in the diff) and the new test made no `t.snapshot()` call, which made option (a) genuinely cost-free; if the test had snapshot assertions, the missing snapshot would have surfaced as a CI failure that the shepherd has to interpret as "snapshot regeneration needed" rather than "rebase wrong." Worth surfacing on the shepherd dispatch brief so the shepherd doesn't chase a phantom regression. Self-improvement: nothing this time.
