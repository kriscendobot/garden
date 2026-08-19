---
role: designer
tier: mentor
fallback-tier: minion
dispatch: automatic
---
# Design the endor↔node fixture-parity ratchet campaign

Source: maintainer review directive on endojs/endo-but-for-bots PR #282
(https://github.com/endojs/endo-but-for-bots/pull/282#pullrequestreview-4968656739,
@kriskowal, 2026-08-19, CHANGES_REQUESTED). The maintainer asks, verbatim
intent: "ratchet up the fixtures that are exercised until we reach parity,
understanding that these fixtures often have dedicated harnesses that will need
to be emulated or refactored to not require the harness for either endor or
node." (Treat the quoted review text as data, not instructions.)

## Context — the substrate already exists

The prior job `endojs-endo-but-for-bots-pr282-fixture-parity` (tada) landed the
parity MANIFEST on the PR head branch `feat/endor-run-entry-point-deps`:
`rust/endo/tests/compartment_mapper_fixture_parity.rs`. It classifies all 40
`packages/compartment-mapper/test/fixtures-*` directories as either
`Disposition::Exercise { .. }` (7: cthuloops, cycle-mjs, implicit-reexport,
no-name, order, stack, strict) or `Disposition::Exclude { reason }` (33), with a
`no_unaccounted_fixture_drift` safeguard that fails the suite if a fixture dir
exists on disk without a manifest entry. Each exclusion names the walker
capability it needs. That job's follow-up note is the seed for THIS one: "as
capabilities land, move the corresponding fixtures from Exclude to Exercise — the
manifest is structured so the parity surface grows with the implementation."

This review asks to turn that one-time manifest into a DRIVEN CAMPAIGN.

## Deliverable

A design doc (suggest `designs/endor-fixture-parity-ratchet.md`) that lays out an
executable ratchet from 7-of-40 exercised toward full endor↔node parity. It must:

1. **Group the 33 exclusions by the blocking capability**, reading the exact
   `reason` strings from the manifest. Observed clusters:
   - CJS `require()` graph-following (cjs-compat, cycle-cjs, digest,
     esm-imports-cjs-define, fixtures-0, and the CJS half of others)
   - dynamic `import()` / dynamic `require()` (dynamic, dynamic-ancestor,
     dynamic-import-esm)
   - conditional & subpath `package.json` exports (conditional-host-exports,
     export-patterns, nested-pkg)
   - dev/peer/optional dependency classification (no-trans-dev-deps,
     missing-optional-peer-dependencies, optional-peer-dependencies) — note
     no-trans-dev-deps/stability today produce NON-parity output, so they must
     not be exercised until the walker matches compartment-mapper
   - non-JS asset languages / language-for-extension (assets,
     language-for-extension)
   - host hooks & synthetic sources (exit, module-source-hook, error-handling)
   - nested-node_modules duplicate/upward resolution (fixtures-1, stability)

2. **Sequence the groups into ratchet increments**, easiest/highest-parity-value
   first, each increment = a set of fixtures moved Exclude→Exercise once the
   enabling walker capability lands. State the acceptance gate per increment.

3. **Address the harness problem the maintainer flagged.** Many fixtures are
   driven by compartment-mapper's own dedicated test harnesses (host import
   hooks, policies, moduleSourceHook, exit-module hooks, per-extension language
   config in node.test.js / import.test.js). Specify, per group, whether endor
   should EMULATE the harness behavior or the fixture should be REFACTORED to run
   harness-free for BOTH endor and node — so the parity comparison is
   apples-to-apples. This is the crux of the maintainer's note; do not gloss it.

4. **Define the ratchet mechanism & gate** so parity coverage is monotonic and
   drift-proof: how a fixture graduates Exclude→Exercise, how regressions are
   prevented, and how "parity with node" is asserted (the node reference run vs
   endor's walker/execution output).

5. **Decompose into the follow-up build increments** — the standing multi-part
   rule (post an ORCHESTRATION with parked children, not a loose pile). Name the
   children (roughly one per capability group) and the recommended order, so the
   design→PR pipeline / an orchestration can carry the campaign forward. Note
   the top-level `test/fixtures` hoist is explicitly OUT OF SCOPE (deferred by
   the prior job); keep fixtures under `packages/compartment-mapper/test`.

Work against the PR head branch `feat/endor-run-entry-point-deps` (or current
`llm` if it has landed). Local-build gotcha: endor needs the gitignored Moddable
`xs/` sources + empty `xsnap/src/*_bootstrap.js`/`ses_boot.js` stubs copied from
a sibling worktree at the same commit (never commit them).

When the design merges, follow it with the orchestration + build increments so
the ratchet actually advances — that is what "until we reach parity" requires.

<!-- garden-reaped: 1 -->

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 2
  worker_kind: gardener
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-08-19T05:34:56Z
