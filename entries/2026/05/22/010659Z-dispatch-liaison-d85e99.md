---
ts: 2026-05-22T01:06:59Z
kind: dispatch
role: liaison
project: endo-but-for-bots
to: builder
issues:
  - repo: endojs/endo
    issue: 2981
---

# Dispatch: builder addresses endojs/endo#2981 (bundleSource fails on aliased exports) on master

Dispatch root: `dispatches/builder--d85e99/`. Project worktree on `endojs/endo-but-for-bots@master` (head `0ec70c6dd`).

Maintainer directive (2026-05-22): *"Please dispatch a builder to address https://github.com/endojs/endo/issues/2981 based on master."*

## Upstream issue #2981

- Title: "`bundleSource` doesn't correctly handle aliased exports"
- Labels: `bug`, `next-release`
- Repro test: `marshal-failure.test.js` in `packages/bundle-source/test/` — merged via endojs/endo#2980 (`mhofman/add-bundle-failing-tests`).
- Error trace (per issue body):

```
TypeError: X is not a function
    at encodeErrorCommon (marshal/src/marshal.js:127:29)
    at encodeErrorToSmallcaps (marshal/src/marshal.js:210:25)
    at encodeToSmallcaps (marshal/src/encodeToSmallcaps.js:288:9)
    at toCapData (marshal/src/marshal.js:221:23)
    at eval (endo/marshal.js:9:13)
    ...
    at packages/bundle-source/test/marshal-failure.test.js:21:15
```

The bug is in `bundleSource`'s `nestedEvaluate` format: aliased exports (e.g., `export { foo as X }`) fail to bind correctly. The repro test exercises a marshal error message that calls `X(...)` where `X` is an aliased import from a bundled module; bundleSource's import binding for the alias is wrong, so `X` is not the expected function at the call site.

## Task

1. Read `garden/roles/COMMON.md`, then `garden/roles/builder/AGENT.md`.
2. Read `garden/skills/library-lookup/SKILL.md`, `garden/skills/pre-push-gates/SKILL.md`, `garden/skills/regression-evidence/SKILL.md`, `garden/skills/pr-formation/SKILL.md`.
3. Read `project/CLAUDE.md` and `packages/bundle-source/` source. The relevant code paths: the `nestedEvaluate` bundle format (likely `packages/bundle-source/src/bundle-nested-evaluate.js` or similar — verify on master HEAD) and the marshal call site at `packages/marshal/src/marshal.js:127` (`encodeErrorCommon`) which provides the repro trigger.
4. Run the failing test to confirm reproduction: `cd packages/bundle-source && npx ava test/marshal-failure.test.js --timeout=60s`. If the test is wrapped in `.failing` (because it's a known-failing test that landed via #2980), unwrap or invert as the fix demands; if the bundleSource fix makes the test pass, switch `.failing` → `.serial` (or whatever the project convention is) in the same commit.
5. **Diagnose the bug.** Aliased exports in `nestedEvaluate` bundles likely fail because the rewriter binds the *alias* name in the local scope but the consumer of the bundle reaches for the *original* name (or vice versa). Inspect `bundle-nested-evaluate.js`'s import-binding generator. Cross-reference with the `endoZipBase64` format's binding to see how the working path handles aliases — `endoZipBase64` is the reference for what `nestedEvaluate` should do.
6. **Fix.** The smallest change that satisfies the repro. Probably a binding-name fix in the rewriter (one or two lines) plus a wider test sweep to verify the fix doesn't regress non-aliased exports. Per `garden/skills/regression-evidence/SKILL.md`, prove the new test (or the un-`.failing`-ed test) is load-bearing by demonstrating it fails when the target code path is broken (revert the fix locally and confirm the test fails).
7. **Local validation.**
   - `cd packages/bundle-source && npx ava` (full test suite).
   - `cd packages/marshal && npx ava` (the marshal layer that surfaces the symptom).
   - Any other test that uses `nestedEvaluate` (`packages/cli`, `packages/daemon` use it for some workflows — verify).
   - `yarn lint`, `yarn docs`, pre-push-gates.
8. **Commit shape.**
   - One `fix(bundle-source): bind aliased exports correctly in nestedEvaluate format (#2981)`.
   - One changeset entry per project convention.
   - One `chore: Update yarn.lock` if dependencies changed (unlikely).
9. Push to `endojs/endo-but-for-bots:fix/bundle-source-aliased-exports-2981`.
10. Open **DRAFT** PR on `endojs/endo-but-for-bots` against `master`. Title: `fix(bundle-source): bind aliased exports correctly in nestedEvaluate format (fixes endojs/endo#2981)`. Body: cite issue #2981, describe the bug, the fix, the test evidence, and the cross-format comparison to `endoZipBase64`.

## Per-action authorization

- Push to `endojs/endo-but-for-bots:fix/bundle-source-aliased-exports-2981`.
- Open draft PR on `endojs/endo-but-for-bots` against `master`.
- READ-ONLY on `endojs/endo`.

## Out of scope

- No cross-post on `endojs/endo#2981`.
- No un-draft.
- No upstream ferry.

## Report

≤ 400 words. PR URL + head SHA. Diagnosis (root cause in one sentence). The fix (file:line). Regression evidence (test exists before fix, fails; after fix, passes). Local test status per command. One-line `Self-improvement: ...`. Write the result as `journal/entries/2026/05/22/<HHMMSSZ>-result-builder-d85e99.md` and push journal (rebase if non-fast-forward).
