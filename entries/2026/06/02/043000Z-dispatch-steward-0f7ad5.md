---
ts: 2026-06-02T04:30:00Z
kind: dispatch
role: steward
host: endolinbot
repo: endojs/endo-but-for-bots
project: endo-but-for-bots
to: builder
dispatch_root: /home/kris/dispatches/builder--0f7ad5
prs:
  - repo: endojs/endo-but-for-bots
    pr: 379
    role: target
refs:
  - https://github.com/endojs/endo-but-for-bots/pull/379
  - https://github.com/endojs/endo-but-for-bots/pull/379#discussion_r3338677487
  - https://github.com/endojs/endo-but-for-bots/pull/379#discussion_r3338682426
  - https://github.com/endojs/endo-but-for-bots/pull/379#discussion_r3338685696
---

# dispatch: builder — #379 CommonJS reexporter parity test rework

kriskowal CHANGES_REQUESTED on #379 at 2026-06-02T04:28:37Z, three inline
comments converging on: the CommonJS reexporter test we just added needs
(a) reframed prose focused on what the test verifies, not why it was
written, and (b) a shared-fixture parity infrastructure that programmatically
substantiates the claim of Node.js parity (where parity exists) and the
claim of divergence (where SES does not have Node.js parity).

## Three inline comments (paraphrased)

1. **Line 295 (test prose)**: Reframe as primarily an explanation of the
   test rather than emphasizing the procedural impetus for making the test.
   Also, commit and refer to a test that substantiates the claim that the
   Node.js parity behavior was verified, ideally with a shared fixture, as
   with cycle-rename parity.
2. **Line 676 (divergence claim)**: SES does not have Node.js parity in the
   ESM-in-CJS-cycle case (Node throws `ERR_REQUIRE_CYCLE_MODULE`; SES does
   not). State and verify this claim plainly and programmatically.
3. **Line 682 (verification standard)**: Parity claims should be
   substantiated with parity tests. (Plus a separate ask: inform the
   gardener to document the concept of a parity test for future reference —
   the steward handles that via a separate message-to-gardener.)

## Model to follow

`packages/compartment-mapper/test/cycle-rename-node-parity.test.js`
together with `cycle-rename.test.js`, `fixtures-cycle-rename/`, and
`_cycle-rename-assertions.js` is the established parity-test pattern in
this codebase. Read those four files first — they are exactly the shape
kriskowal references with "ideally with a shared fixture, as with
cycle-rename parity."

## Task

Restructure the new CommonJS reexporter test into a parallel parity-test
suite under `packages/compartment-mapper/test/` and reframe the existing
SES-side test as a focused regression test. Specifically:

### Part A — shared parity infrastructure under compartment-mapper

Create (parallel to the existing cycle-rename layout):

- `packages/compartment-mapper/test/fixtures-cycle-cjs-reexporter/node_modules/app/`
  with the fixture files for the pure-CJS reexporter cycle (the one where
  Node and SES agree). The pattern from the existing CJS reexporter
  scenario in `packages/ses/test/import-cjs.test.js` (the test
  `'cyclic star-export with CommonJS reexporter'`) is the source — but
  re-expressed as actual on-disk `.cjs` / `.mjs` modules under the fixture
  tree, not inline ModuleSources.
- `packages/compartment-mapper/test/_cycle-cjs-reexporter-assertions.js`
  with the shared assertions module (mirror `_cycle-rename-assertions.js`).
- `packages/compartment-mapper/test/cycle-cjs-reexporter.test.js` — the
  compartment-mapper / SES test that runs the fixture via the compartment
  mapper and asserts via the shared assertions module.
- `packages/compartment-mapper/test/cycle-cjs-reexporter-node-parity.test.js`
  — the Node.js parity test that runs the same fixture via a plain
  `import()` (or `require()` for the pure-CJS case) and asserts the same
  expectations via the shared assertions module. Use the
  `cycle-rename-node-parity.test.js` style.

### Part B — divergence test (ESM-in-CJS-cycle)

For the case where Node throws `ERR_REQUIRE_CYCLE_MODULE` but SES does
not, add a parallel pair under
`packages/compartment-mapper/test/fixtures-cycle-esm-in-cjs/` (or similar
name) with:

- The fixture files exercising the ESM-in-CJS-cycle topology.
- A SES test that asserts SES's actual behavior (whatever it is — verify
  empirically, document plainly).
- A Node-parity test that asserts Node throws `ERR_REQUIRE_CYCLE_MODULE`
  (try/catch around `import()` and assert the error code), making the
  divergence programmatic rather than narrative.
- An assertions module if the divergence shape is reusable across the
  two; otherwise inline.

This makes the "SES does not have Node parity here" claim a verified
property, not prose.

### Part C — reframe and slim down the existing import-cjs.test.js section

Refactor `packages/ses/test/import-cjs.test.js`'s
`'cyclic star-export with CommonJS reexporter'` test (lines ~670-792):

- The JSDoc preceding the test should be reframed as primarily an
  explanation of what the test verifies. Drop the procedural prose
  ("Naugtur asked", "verified directly with Node"). Reference the
  shared-fixture parity tests in compartment-mapper for the parity
  substantiation.
- The test body itself can remain (as an in-process SES regression for
  the ModuleSource-based path) OR be replaced by a pointer to the
  compartment-mapper test if the compartment-mapper version subsumes it.
  The builder decides based on whether the in-process SES form covers
  meaningfully different ground (e.g., it directly exercises the
  module-instance linker without compartment-mapper indirection). Document
  the choice in the result entry.

## Verification

Before pushing:

- `cd packages/compartment-mapper && yarn test` passes (new tests
  included).
- `cd packages/ses && yarn test` passes (existing tests still pass; the
  reframed cjs reexporter test passes or is correctly relocated).
- `yarn build:types:check` exits 0.
- `git grep -n 'Naugtur asked\|builder verified directly\|verified directly with .node.'`
  returns no matches in the test prose (the procedural-impetus prose is
  gone).

## Commit structure

Suggested split (builder's judgment on exact grouping):

1. `test(compartment-mapper): cyclic CommonJS reexporter parity fixture +
   tests (#59 follow-up)`
2. `test(compartment-mapper): ESM-in-CJS-cycle divergence parity test
   (#59 follow-up)` (or fold into 1 if natural)
3. `test(ses): reframe cyclic CJS reexporter test prose; reference
   compartment-mapper parity` (or `refactor(ses): relocate cyclic CJS
   reexporter test to compartment-mapper parity suite` if Part C
   replaces rather than reframes)

Commits under endolinbot identity.

## Per-action authorizations

- Create files under `packages/compartment-mapper/test/`. Authorized.
- Edit `packages/ses/test/import-cjs.test.js`. Authorized.
- Regular append push to
  `endojs/endo-but-for-bots:fix/issue-59-star-export-cycle`. Authorized.

## Not authorized

- Force-pushing.
- Resolving the new review threads (steward does that after builder
  reports).
- Un-drafting.
- Modifying files outside `packages/ses/test/` and
  `packages/compartment-mapper/test/`.

## Dispatch protocol

Read in order:

1. `/home/kris/dispatches/builder--0f7ad5/garden/roles/COMMON.md`
2. `/home/kris/dispatches/builder--0f7ad5/garden/roles/builder/AGENT.md`
3. Skills referenced by the builder just-in-time. Relevant:
   `coverage-driven-testing`, `adversarial-tests`, `regression-evidence`.

Project worktree at `project/` on `fix/issue-59-star-export-cycle`
(head `8a608ce86`).

## Report

A `result` journal entry. Include: new head SHA after push, list of files
added/modified per commit, test command outcomes, the builder's choice on
Part C (reframe vs relocate) with rationale, and any PR comment IDs (if
the builder needs to surface a design choice on the thread).
