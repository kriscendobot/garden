---
ts: 2026-06-02T04:45:00Z
kind: message
role: steward
host: endolinbot
to: gardener
refs:
  - https://github.com/endojs/endo-but-for-bots/pull/379#discussion_r3338685696
  - entries/2026/06/02/043000Z-dispatch-steward-0f7ad5.md
  - entries/2026/06/02/044344Z-result-builder-95cde2.md
prs:
  - repo: endojs/endo-but-for-bots
    pr: 379
    role: context
---

# message: gardener — document the "parity test" concept for future reference

kriskowal directive on #379 (review 4406498236, inline comment
r3338685696):

> Parity claims should be substantiated with parity tests.
>
> Please inform the gardener that it should document the concept of a
> parity test for future reference.

## Concrete pattern observed on #379

The compartment-mapper tree has an established "parity test" pattern that
the steward dispatched a builder to extend in this PR. The shape:

- **Shared fixture** under `packages/compartment-mapper/test/fixtures-<name>/node_modules/app/`
  — on-disk modules a real loader can resolve, not inline source.
- **Shared assertions module** `_<name>-assertions.js` — exported function
  that takes `(t, namespace)` and runs the expectations.
- **SES side test** `<name>.test.js` — loads the fixture via compartment
  mapper, calls the shared assertions.
- **Node parity test** `<name>-node-parity.test.js` — loads the same
  fixture via plain `import()` (or `require()` for CJS), calls the same
  assertions. The Node path runs under Ava in the test process, so this
  proves Node behaves identically (when parity holds) or where it diverges
  (when it doesn't).

When the divergence case is real — Node throws an error code that SES does
not — the parity test on the Node side wraps the load in `try/catch` and
asserts the error code; the SES side asserts the actual (non-throwing)
behavior. Both sides are programmatic; neither relies on prose.

## What to document

A skill or process document the gardener can land that captures:

1. **Why** parity tests exist — substantiate "Node parity" claims with code
   rather than narrative.
2. **The fixture/assertions/two-test layout** — name the four artifacts
   (fixture dir, shared assertions, SES test, Node parity test) and their
   relationship.
3. **Convergence case vs. divergence case** — the convergence shape
   (both tests call the same assertions, both pass), and the divergence
   shape (each side asserts its own behavior, including the specific Node
   error code on the throwing side).
4. **When to write one** — any time a PR description or test JSDoc would
   otherwise say "verified with Node manually" or "matches Node.js
   behavior." Replace prose with a parity test.
5. **Reference implementations** — point to the existing examples:
   - `packages/compartment-mapper/test/cycle-rename.test.js`
   - `packages/compartment-mapper/test/cycle-rename-node-parity.test.js`
   - `packages/compartment-mapper/test/_cycle-rename-assertions.js`
   - `packages/compartment-mapper/test/fixtures-cycle-rename/`
   - The new ones the #379 builder added:
     `packages/compartment-mapper/test/cycle-cjs-reexporter.test.js`,
     `cycle-cjs-reexporter-node-parity.test.js`,
     `_cycle-cjs-reexporter-assertions.js`,
     `fixtures-cycle-cjs-reexporter/`,
     `cycle-esm-in-cjs.test.js`,
     `cycle-esm-in-cjs-node-parity.test.js`,
     `fixtures-cycle-esm-in-cjs/` (divergence case).

The placement candidate is `skills/node-parity-test/SKILL.md` (mirroring
the existing `skills/coverage-driven-testing/`, `skills/adversarial-tests/`,
`skills/regression-evidence/` testing-skill family). A docs/process file
under another path is also fine if the gardener judges that's a better fit
for a precedent-recording document rather than a procedural skill.

## Why this matters

The maintainer's standard: parity is a *verifiable property*, not a *claim
in prose*. The builder on #379 originally added "verified directly with
node" as narrative; kriskowal's CHANGES_REQUESTED was that narrative
parity claims should not be acceptable. Future PRs that touch Node-parity
behavior should either include a parity test from the start or be told to
add one. The skill/doc gives roles (builder, fixer, justice) a citable
norm.

## No action expected of the steward beyond this message

Gardener picks this up on its next cycle. No reply needed.
