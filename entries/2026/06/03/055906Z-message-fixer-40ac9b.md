---
ts: 2026-06-03T05:59:06Z
kind: message
role: fixer
host: endolinbot
project: endo
to: gardener
refs:
  - entries/2026/06/03/054900Z-dispatch-liaison-f83065.md
  - https://github.com/endojs/endo-but-for-bots/pull/379
prs:
  - repo: endojs/endo-but-for-bots
    pr: 379
    role: source
---

# message: fixer → gardener — document the parity-test concept

kriskowal asked on endojs/endo-but-for-bots#379 (inline comment
`3338685696` on `packages/ses/test/import-cjs.test.js`):

> Parity claims should be substantiated with parity tests. Please
> inform the gardener that it should document the concept of a parity
> test for future reference.

This is the gardener-meta follow-up. The audit on PR #379 confirmed
that every parity claim in the issue-59 work is now substantiated by
a parity-test pair landed in this PR, so the maintainer's ask is met
on the code side and what remains is the documentation work in the
garden.

## The parity-test concept, as exercised on PR #379

A **parity test** is a paired-tests-plus-shared-fixture pattern that
verifies a claim of behavioral parity between two layers (typically
the in-tree implementation and a reference implementation, in our
case the SES / compartment-mapper module linker versus Node.js's
own module linker) by construction rather than narratively.

Three artifacts cooperate:

1. **A fixture** under `test/fixtures-<slug>/node_modules/app/` that
   exercises the topology in question. The fixture is a tiny package
   that both layers can load. Its `package.json` is real (so Node's
   resolver works) and includes a `preinstall` script that aborts
   installation so the fixture is never accidentally hoisted into
   the workspace.

2. **A shared assertion module** at `test/_<slug>-assertions.js`
   that exports the expected projections and an assertion function
   `assert<Slug>(t, namespace)`. The expected values live in exactly
   one place; both parity tests import this module.

3. **Two test files** that import the shared assertion:
   - `<slug>.test.js` exercises the in-tree implementation (typically
     through the compartment-mapper scaffold, which runs the fixture
     through every load / archive / parse path).
   - `<slug>-node-parity.test.js` exercises the same fixture under
     plain Node.js (via `import(new URL('.../main.js', import.meta.url))`
     for ESM, or `spawnSync(process.execPath, ...)` when the parity
     claim is about a specific error code on rejection).

When both files pass, parity is verified by construction: any
divergence between the in-tree implementation and Node.js's reference
behavior on this fixture would make one of the two tests fail.

The pattern also covers **divergence claims**. When SES and Node.js
disagree (as with the ESM-in-CJS cycle that Node rejects with
`ERR_REQUIRE_CYCLE_MODULE` and SES allows), the shared structure is:
the SES side test pins the SES behavior on the fixture; the Node side
test asserts the rejection on the same fixture; together they verify
the disparity programmatically.

## Canonical examples in the tree on PR #379's head (`f1a7dfb60`)

Four parity trios are now present in
`packages/compartment-mapper/test/`:

- `_cycle-rename-assertions.js` + `cycle-rename.test.js` +
  `cycle-rename-node-parity.test.js`: the populated-binding shape of
  endojs/endo#59 (parity case).
- `_cycle-rename-unused-assertions.js` + `cycle-rename-unused.test.js`
  + `cycle-rename-unused-node-parity.test.js`: the unused-live-binding
  shape (parity case; landed on the audit dispatch as the closing gap).
- `_cycle-cjs-reexporter-assertions.js` + `cycle-cjs-reexporter.test.js`
  + `cycle-cjs-reexporter-node-parity.test.js`: the all-CommonJS
  three-module reexporter cycle (parity case).
- `cycle-esm-in-cjs.test.js` + `cycle-esm-in-cjs-node-parity.test.js`:
  the ESM-in-CJS cycle (divergence case; Node rejects, SES allows).
  No shared assertion module is needed because the two sides verify
  opposite outcomes on the same fixture.

These four are the working reference for what a parity test looks
like in the endo tree. A garden-side documentation entry can point
at them by file path.

## Suggested garden artifacts

The shape this points at is a `skills/node-parity-test/SKILL.md` (or
similar slug) that captures:

- Purpose: verify or refute behavioral parity between an in-tree
  implementation and a reference implementation, by construction.
- When to reach for this pattern: any time the in-tree behavior pins
  itself to "what Node.js does" (or another reference implementation's
  behavior) and the claim is currently expressed only in prose.
- The three-artifact shape (fixture, shared assertion module, two
  test files) with one paragraph per artifact.
- The divergence variant (no shared assertion module; the two sides
  assert opposite outcomes).
- File-naming conventions seen in the endo tree:
  `fixtures-<slug>/`, `_<slug>-assertions.js`, `<slug>.test.js`,
  `<slug>-node-parity.test.js`.
- One worked example with file links into the endo tree on
  `f1a7dfb60`.

The current garden inventory already mentions a `node-parity-test`
skill in `CLAUDE.md` § Current inventory, so the slot exists; this
message reports that the concept is now exercised four times in one
PR and that the documentation work is ripe.

## Suggested handling

The next gardener dispatch picks this up; the relevant context lives
in this message plus the four trios cited above. The dispatch can
read PR #379 directly for the prose around each fixture and the
cross-references that already cite the parity pairs.

Self-improvement: nothing this time.
