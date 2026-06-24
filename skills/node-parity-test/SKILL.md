---
created: 2026-06-02
updated: 2026-06-24
author: gardener
---

# Skill: node-parity-test

Substantiate a Node.js parity claim with code, not prose. When a PR description, JSDoc, or commit message would otherwise say *"matches Node.js behavior"* or *"verified directly with node"*, replace the narrative with a parity test pair: one test exercises the artifact under inspection (SES, compartment-mapper, the daemon's loader, etc.); a companion test exercises the same fixture under plain Node.js; both call the same shared assertions. If both pass, parity is verified by construction.

This skill names the four artifacts in the layout, the convergence and divergence cases, and the rule for choosing this shape over a prose claim. It is **consumed by the builder and assayer steps of the gardening state machine** (`scripts/jobs/gardening/garden-pr.sh`): when a `build` job touches a Node-adjacent code path, the builder step writes the parity pair and the assayer step runs the evaluation suite (which the state machine never sense-gates — it errs toward running all evals) to confirm both sides pass before the PR submits to CI.

## When to use

- A `build` job introduces or changes behavior on a Node.js-adjacent code path (module linker, loader, resolver, require/import edge case).
- A test or commit message reaches for a phrase like *"matches Node"*, *"same as Node.js"*, *"verified manually under node"*, *"per Node v22"*, etc.
- A panel seat or a maintainer asks *"does Node do the same thing?"* or *"how do we know this matches Node?"*.

If the claim is already covered by an existing parity test in the same package, cite it rather than adding another. If no parity test exists for the claim, add one.

## The four-artifact layout

A parity test is a pair, plus the shared fixture and assertions module they both use:

1. **Shared fixture**, a directory under `packages/<pkg>/test/fixtures-<name>/node_modules/app/`. Real on-disk modules a real loader can resolve, not inline source. The fixture is the single source of truth for the topology under test; both sides of the parity pair load it. The fixture's `package.json` carries a `preinstall` script that aborts installation (`"preinstall": "echo DO NOT INSTALL TEST FIXTURES; exit -1"`) so a stray workspace `yarn install` cannot accidentally hoist the fixture into the monorepo's node_modules tree.

2. **Shared assertions module**, `packages/<pkg>/test/_<name>-assertions.js`. Exports a function `assert<Name>(t, namespace)` (or similar shape) that takes an Ava test context and the loaded namespace and runs the expectations. Imported by both tests, so the expected values live in exactly one place.

3. **System-under-test test**, `packages/<pkg>/test/<name>.test.js`. Loads the fixture via the artifact under inspection (the SES `Compartment`, the compartment-mapper scaffold, the daemon's loader, etc.), passes the resulting namespace to the shared assertions, and asserts the artifact's actual behavior.

4. **Node parity test**, `packages/<pkg>/test/<name>-node-parity.test.js`. Loads the same fixture under plain Node.js (no SES, no compartment mapper) and calls the same shared assertions. The Node parity test typically uses dynamic `import()` (or `require()` for CJS) directly; on divergence cases, it may spawn a fresh Node process to capture the error code.

The leading underscore on the assertions module (`_<name>-assertions.js`) is conventional: it marks the file as a test helper rather than an Ava test file the runner should pick up.

## The convergence case (parity holds)

Both tests call the same `assert<Name>(t, namespace)` and both pass. The artifact's namespace and Node's namespace are observably identical for the topology in the fixture. The convergence case is the common shape:

```js
// packages/compartment-mapper/test/cycle-rename.test.js
import { scaffold } from './scaffold.js';
import { assertCycleRename } from './_cycle-rename-assertions.js';

const fixture = new URL(
  'fixtures-cycle-rename/node_modules/app/main.js',
  import.meta.url,
).toString();

scaffold(
  'cyclic star export with renaming reexport (issue #59)',
  test,
  fixture,
  (t, { namespace }) => assertCycleRename(t, namespace),
  3,
);
```

```js
// packages/compartment-mapper/test/cycle-rename-node-parity.test.js
import test from 'ava';
import { assertCycleRename } from './_cycle-rename-assertions.js';

test('cyclic star export with renaming reexport (issue #59) - node parity', async t => {
  t.plan(3);
  const namespace = await import(
    new URL('fixtures-cycle-rename/node_modules/app/main.js', import.meta.url)
      .href
  );
  assertCycleRename(t, namespace);
});
```

Both tests load the same fixture, both call the same `assertCycleRename`. If either side regresses, the assertion in the shared module fails on that side; the other side's pass localizes the divergence.

## The divergence case (parity does not hold)

Sometimes the artifact under inspection deliberately differs from Node. The parity pair still uses a shared fixture, but each side asserts its own behavior:

- The system-under-test test asserts the artifact's actual (non-throwing or different) behavior on its namespace.
- The Node parity test asserts what Node does — typically a specific error code, captured by spawning a fresh Node process and grepping `stderr`:

```js
// packages/compartment-mapper/test/cycle-esm-in-cjs-node-parity.test.js
test('ESM-in-CJS-cycle - node parity (rejects with ERR_REQUIRE_CYCLE_MODULE)', t => {
  t.plan(2);
  const fixture = new URL(
    'fixtures-cycle-esm-in-cjs/node_modules/app/main.mjs',
    import.meta.url,
  );
  const result = spawnSync(process.execPath, [fileURLToPath(fixture)], {
    encoding: 'utf8',
  });
  t.not(result.status, 0, 'Expected Node to reject');
  t.regex(result.stderr, /ERR_REQUIRE_CYCLE_MODULE/);
});
```

The divergence pair still pins both behaviors programmatically. A future change that accidentally re-aligns the artifact to Node's behavior will fail the system-under-test test; a future Node release that changes its error code will fail the parity test. Either failure points the reader at the change.

The divergence's *reason* belongs in a JSDoc comment on both files (and in the assertions module if it carries the topology summary), explaining what differs and why. The reason is prose; the behavior is code.

## When to write one

- **Any PR description or test JSDoc that would otherwise narrate Node parity.** Replace the prose with a parity test. *"Matches Node.js"* / *"verified under node v22"* / *"behavior agrees with Node"* / *"Node does X here too"* are all signals.
- **Any code change to a Node-adjacent loader, linker, resolver, or module-cache.** If the change can plausibly drift from Node, the parity test is the regression guard. The change's commit message can then cite the parity test by name rather than asserting parity in prose.
- **Any maintainer comment asking for parity evidence.** The 2026-06-02 review on `endojs/endo-but-for-bots#379` is the precipitating example: kriskowal asked for parity tests in place of *"verified directly with node"* narrative.

If the topology is small enough that the parity test would only assert one value, prefer adding the case to an existing parity pair rather than creating a new four-artifact set. Cross-link the new case in the existing assertions module's topology summary.

## Reference implementations

In `endojs/endo-but-for-bots:llm` (and ferried to `endojs/endo:master`), four parity pairs landed during the endojs/endo#59 work:

- **Convergence shape (populated live binding)**:
  - `packages/compartment-mapper/test/cycle-rename.test.js`
  - `packages/compartment-mapper/test/cycle-rename-node-parity.test.js`
  - `packages/compartment-mapper/test/_cycle-rename-assertions.js`
  - `packages/compartment-mapper/test/fixtures-cycle-rename/`
- **Convergence shape (unused live binding)**:
  - `packages/compartment-mapper/test/cycle-rename-unused.test.js`
  - `packages/compartment-mapper/test/cycle-rename-unused-node-parity.test.js`
  - `packages/compartment-mapper/test/_cycle-rename-unused-assertions.js`
  - `packages/compartment-mapper/test/fixtures-cycle-rename-unused/`
- **Convergence shape (CommonJS reexporter)**:
  - `packages/compartment-mapper/test/cycle-cjs-reexporter.test.js`
  - `packages/compartment-mapper/test/cycle-cjs-reexporter-node-parity.test.js`
  - `packages/compartment-mapper/test/_cycle-cjs-reexporter-assertions.js`
  - `packages/compartment-mapper/test/fixtures-cycle-cjs-reexporter/`
- **Divergence shape (ESM-in-CJS cycle)**:
  - `packages/compartment-mapper/test/cycle-esm-in-cjs.test.js`
  - `packages/compartment-mapper/test/cycle-esm-in-cjs-node-parity.test.js`
  - `packages/compartment-mapper/test/fixtures-cycle-esm-in-cjs/`
  - No shared assertion module: the two sides verify opposite outcomes on the same fixture, so the expected-values-in-one-place property does not apply.

The cycle-esm-in-cjs divergence pair shows the `spawnSync` + `stderr` regex shape; the other three show the in-process `import()` + shared assertions shape.

## Composition with neighbouring testing skills

- **`../regression-evidence/SKILL.md`** — a regression test demonstrates the bug existed before the fix. A parity test demonstrates the post-fix behavior agrees with Node. The two compose: the same fixture often serves as both the regression case and the parity case, with the SES side as the regression evidence and the Node side as the parity claim.
- **`[coverage-driven-testing]`** — parity tests are a coverage signal for Node-adjacent code paths the artifact under inspection re-implements. If a panel seat asks *"how is this Node-adjacent path tested?"*, point at the parity pair.
- **`[adversarial-tests]`** — adversarial tests look for failure modes a passing test would miss. A parity test is structurally adversarial against the artifact's own implementation: if the artifact and Node diverge on a case the test exercises, the divergence surfaces immediately rather than waiting for a downstream bug report.

## Notes

- **The leading underscore on the assertions module** is the project's existing convention for "test-helper, not a test file." Ava's test discovery skips files whose basename starts with `_` so the helper does not produce a duplicate test run.
- **Plan your assertions count.** Both sides of the parity pair call `t.plan(N)` with the same N as `assert<Name>`'s assertion count. The plan catches "an assertion silently early-exited" failures on both sides.
- **Spawn a fresh Node process for divergence error codes.** Calling `import()` on a divergence fixture under the test runner risks corrupting the runner's module graph (and in extreme cases, V8 itself: the 2026-06-02 #379 builder hit a `Check failed: module_status == ...` V8 hard-crash on a complex divergence topology). The `spawnSync(process.execPath, [fileURLToPath(fixture)])` shape isolates the failure.
- **Cross-link to the parity test from PR descriptions and commit messages.** When a commit changes a Node-adjacent code path, cite the parity test by name in the commit body. The reviewer sees the citation, reads the parity test, and the parity claim is grounded.

## Notes from the field

- _2026-06-02_: skill landed by gardener after a node-parity-test skill was requested by kriskowal. Precipitating evidence: review on `endojs/endo-but-for-bots#379` (`pullrequestreview-4406498236`, inline `r3338685696`) asking that parity claims be substantiated with parity tests rather than left as narrative. The four-artifact convention codified here predates the request (the `cycle-rename` pair on the same PR is the prototype); the skill names it explicitly so future builder, fixer, and panel passes have a citable norm.

- _2026-06-03_: a fixer audit on PR #379 (head `f1a7dfb60`) confirmed the convention end-to-end and added a fourth parity pair (`cycle-rename-unused`) for the unused-live-binding shape, alongside the cycle-rename, cycle-cjs-reexporter convergence pairs and the cycle-esm-in-cjs divergence pair. The fixer's message back to the gardener reinforces the convention against a second-pass audit and is the precipitating evidence for the *Reference implementations* expansion to four entries here. Also added: the fixture-`package.json` `preinstall` script that aborts installation so a stray workspace `yarn install` cannot accidentally hoist the fixture into the monorepo's node_modules tree.

- _2026-06-24_: migrated into v2. The four-artifact convention is unchanged; the consumer changed from dispatched builder/fixer/justice roles to the builder and assayer steps of the gardening state machine (`scripts/jobs/gardening/garden-pr.sh`) and the panel seats that read its output.
