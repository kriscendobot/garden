---
ts: 2026-05-14T20:55:58Z
kind: dispatch
role: liaison
project: endo-but-for-bots
to: "*"
prs:
  - repo: endojs/endo
    pr: 1967
    role: source
  - repo: endojs/endo
    issue: 629
    role: source
---

# Dispatch: builder mirrors endo#1967 (compartment-mapper policy-bypass test) — investigate next-steps, then act

Dispatch root: `dispatches/builder--693645/`. Project worktree on `endojs/endo-but-for-bots@master` (detached).

## The original

[endojs/endo#1967](https://github.com/endojs/endo/pull/1967) opened 2 years ago by @naugtur (a senior contributor on compartment-mapper). 9 files; adds a test that demonstrates a Lavamoat policy bypass per the security issue [#629](https://github.com/endojs/endo/issues/629).

Issue #629 (open): a dependency can declare another via a URL (instead of a version range), which lets the URL-named package pose as the *named* package to the rest of the application. The fix is to derive policy-applicable names from the dependee's `package.json` entry rather than from the dependency package's own name.

PR #1967's author description:

> test for #629
> passing locally with one error from sourcemap count mismatch in archive that should not be related to this. keeping it in draft for that reason.

So: the test demonstrates the bypass; naugtur held it in draft because of an unrelated-looking sourcemap-count-mismatch in `test-policy.js.snap`. 2 years on, the underlying #629 issue is still open (per the issue's current state); naugtur's PR is still draft.

## Per-action authorization

Standing on endo-but-for-bots: push, open PR, run tests locally. READ-ONLY on endojs/endo (no comment on #1967 or #629; the upstream interaction routes via boatman later if applicable).

## Task

Two phases.

### Phase 1: investigate

1. **Mirror the PR's branch into the project worktree.** Fetch `naugtur/test-policy-identifier-bypass` from `endojs/endo` (the dispatch worktree's `origin` is `endo-but-for-bots`, so add `endojs/endo` as a remote temporarily or fetch by URL). Apply the 9-file diff onto a fresh branch off master. The branch name on the fork side: `test/policy-identifier-bypass` (matches naugtur's slug).

2. **Run the test against current master**. `yarn workspace @endo/compartment-mapper test` or the equivalent. Three possible outcomes:
   - **The new test passes** (i.e., the bypass is fixed; the test is now defensive). Cite which commit on master fixed it (`git log -p packages/compartment-mapper/src/policy.js` and similar). The test becomes a regression-coverage assertion.
   - **The new test fails** (the bypass still works). The test correctly demonstrates the security bug. Production fix still needed.
   - **The sourcemap-count-mismatch error still fires**. Read the failure; determine if it's still "unrelated" (per naugtur's note) or now relevant.

3. **Read recent changes** to `packages/compartment-mapper/src/policy.js`, `packages/compartment-mapper/src/compartment-map.js`, `packages/compartment-mapper/src/node-modules.js`. Look for any commit since 2024 that addresses policy-name derivation. If found, cite.

### Phase 2: act per the finding

**Phase 2a — bypass still works**: the test demonstrates a live security bug. Author the production fix for #629 (derive policy-applicable names from the dependee's `package.json` entry rather than from the dependency's own name). This may be a substantial change touching `compartment-map.js`'s `policy` machinery. Open a draft PR on `endo-but-for-bots@master` titled `fix(compartment-mapper): derive policy names from dependee package.json (closes #629, mirrors endo#1967)`. Include both naugtur's test (so it now passes) and the production fix. Address the sourcemap-count-mismatch as part of the fix if it surfaces.

**Phase 2b — bypass is fixed; test passes**: the test is defensive regression-coverage. Open a draft PR on `endo-but-for-bots@master` titled `test(compartment-mapper): defensive coverage for policy identifier bypass (mirrors endo#1967, closes #629)` containing naugtur's test as-is (or rebased onto current master). The test ensures future regressions are caught.

**Phase 2c — bypass status unclear** (the test is malformed, or the fixture node_modules layout doesn't reflect modern compartment-map invariants): write a result entry surfacing the ambiguity and recommend the upstream PR's author (naugtur) refresh the test. No fork-side PR. Bulletin row routes the question back to the maintainer.

## Out of scope

- No comment on upstream #1967 or #629.
- No production fix for #629 absent confidence the test demonstrates the live bug (Phase 2c is the right disposition when uncertain).
- No upstream ferry from this dispatch (boatman runs later when fork-side review approves).

## Report

≤ 400 words: Phase 1 finding (test pass / fail / sourcemap-mismatch / ambiguous), Phase 2 disposition (2a / 2b / 2c), files added/modified, PR URL (if Phase 2a or 2b), one-line `Self-improvement: ...` per `skills/self-improvement/SKILL.md`.
