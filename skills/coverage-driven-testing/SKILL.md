---
created: 2026-05-13
updated: 2026-06-24
author: gardener
---

# Skill: coverage-driven-testing

The cleaner's baseline-and-iterate loop for raising coverage on a target
package, and the four-criterion "dead code" threshold for safe deletion.
Project-specific tooling names (`c8`, `ava`, `yarn`) are kept generic; a
consuming project specializes them in a journal `message` tagged with the
project slug if they drift. Consumed by the cleaner step of the gardening state
machine.

## When to use

- The cleaner stage of the gardening gauntlet runs this between the build stage
  and the [panel](../panel/SKILL.md) stage. The cleaner does not un-draft; the
  panel un-drafts after
  its fixer loop terminates.
- A maintainer directive asks for "a coverage pass on `<package>`", routed as a
  job a gardener claims.
- A jury panel flagged thin coverage on a PR's affected package as a follow-up
  (uncommon, since the cleaner runs before the panel); the gardener queues a
  cleaner step.

## Procedure

1. **Establish a baseline.** From the package directory:

    ```sh
    cd packages/<name>
    npx c8 --reporter=text --reporter=html-spa npx ava
    ```

    Note the per-file branch and line percentages. The `html-spa` reporter at
    `coverage/index.html` lets you click into specific files and see which lines
    are uncovered.

2. **Pick one source file at a time.** Do not sweep the whole package at once;
   focus produces sharper tests and cleaner diffs.

3. **For each uncovered line or branch, decide one of four:**

    - **Reachable from a public-API entry point but not yet exercised.** Write
      an integration test that drives the entry point with a realistic input and
      lets the uncovered branch fall out of the exercise. The new test must catch
      a real failure mode; see
      [regression-evidence](../regression-evidence/SKILL.md).
    - **Reachable only through a host hook, platform-conditional, or other
      configuration the public API cannot trigger.** A targeted unit test is
      acceptable; document why the branch is not reachable from the public
      surface.
    - **Reachable but only by adversarial inputs.** Hand off to the saboteur
      (queue an [adversarial-tests](../adversarial-tests/SKILL.md) step);
      coverage is not the right driver for gotcha tests.
    - **Unreachable.** Delete the dead code. Run `grep -rn <symbol>` first to
      confirm no other package, no test fixture, and no `// @ts-` directive
      mentions it. See *Threshold for dead* below.

4. **Re-run coverage** after each change. The percentage should increase; if a
   new test does not move it, the test is not exercising what you intended.

5. **Iterate per file**, not per percentage point. A package that goes from 78%
   to 92% by adding three meaningful tests is better than one that hits 95% with
   twelve contortion-tests that mock half the dependencies.

## Prefer integration tests

A public-API exercise covers more of the package per test, breaks honestly when
internals refactor, and forces the same path a real consumer would take. Reach
for a unit test only when the branch is genuinely public-API-unreachable per the
second bullet above.

## Test additions

- Tests live next to the code they cover: `packages/<name>/test/<file>.test.js`.
- A test that requires an elaborate mock or a dependency-injection rewrite is a
  signal that the code under test has the wrong shape, not that you need a more
  elaborate test. Surface it for a build step; do not paper over.

## Deletions

- Dead-code deletion is a separate commit from any test addition, and is
  straightforwardly reviewable: each deleted block cited with the grep evidence
  that nothing references it.
- Conventional-commit message: `chore(<pkg>): remove unreachable <thing>`. Do
  not use `refactor` for pure deletion.
- If a deletion crosses a public-API line, do not delete; ask the maintainer via
  the message bus. The coverage report does not know whether external consumers
  reach a function.

## Threshold for "dead"

A function or branch is dead when **all four** of these hold:

- No call site in the package's own non-test source (`src/` or equivalent).
  Test-only call sites do *not* count as live callers; a function whose only
  caller is a unit test in the same package is dead, and the unit test exists to
  keep it alive.
- No call site in any other package in the monorepo
  (`grep -rn <name> packages/ --exclude-dir=test`).
- No `@import` JSDoc reference in any `.js` or `.ts` file.
- The package's exported surface (`index.js`, `package.json` `exports`) does not
  include it.

Anything less than all four is a "covered later" candidate, not dead.

The grep pattern that distinguishes "live caller" from "test-only caller":

```sh
grep -rn '<symbol>' packages/<name>/src/            # live callers
grep -rn '<symbol>' packages/<name>/test/           # test-only
grep -rn '<symbol>' packages/ --exclude-dir=test --exclude-dir=node_modules
```

If the first and third are empty and only the second hits, the symbol is dead;
the test is its only reason for existence; both should be deleted in the same
commit.

## Pitfalls

- **Coverage reports over-state "uncovered" for unimported files.** A file in
  `src/` that no test imports shows 0% coverage even if it works fine. Either add
  an import-only test or accept the gap with a one-line note in the cleaner's
  report.
- **Coverage drops after refactoring.** A refactor that combines two
  near-duplicate paths can lower the line count, even when the percentage went
  up. Report percentages, not absolutes.
- **Unit tests as life-support for dead code.** A unit test that imports an
  internal helper and asserts trivial behavior on it is often the signal that the
  helper has no real callers. Resist; check the caller graph first.
- **Forked packages inherit dead branches.** When a package is derived from a
  sibling, a small grammar tweak in the derived package can render a branch
  logically unreachable that was live in the parent. The right fix in the derived
  package is to delete the dead branch in its own commit, not to keep it on
  life-support with a contortion test. A grep against the parent package will
  tell you which originally-shared code was preserved unchanged.
- **Test runner intercepts unhandled rejections.** Code paths whose observable
  behavior is "schedule a microtask that throws" can be intrinsically hard to
  test under AVA-class runners; an escaping rejection inside a test file fails
  the file. Two paths that work but the cleaner should reject as contortion:
  monkey-patching `Promise.resolve` for the test's duration, or installing a
  `process.prependOnceListener` that mutates the rejection state before the
  runner observes it. Neither belongs in a coverage-driven test. The honest move
  is to leave the path uncovered with a one-line note in the source and surface
  the gap in the cleaner's report as "out of scope: contortion required."

## Notes from the field

- _2026-05-13_: adopted from a reference garden. Project-specific tooling names
  (`c8`, `ava`, the test command) kept generic; specialize per project as a
  journal `message` if a particular project's procedure drifts.
- _2026-06-24_: migrated into v2. Rewired the cleaner from a steward/driver-
  dispatched role to a step in the gardening state machine; saboteur and builder
  hand-offs are queued steps/jobs rather than orchestrator `Agent` dispatches.
