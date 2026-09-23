---
ts: 2026-05-20T21:55:39Z
kind: dispatch
role: builder
project: endo
to: builder
---

# Dispatch: builder 7add08 — verify endojs/endo#2981 (bundleSource aliased-exports), recommend next steps

Dispatch root: `dispatches/builder--7add08/`. Project worktree on `kriscendobot/endo` with local ref `refs/heads/upstream-master` set to `endojs/endo@master` head `ec3dcbc0`.

Maintainer directive (2026-05-20T21:50Z): *"Please dispatch a builder to verify that this issue has been addressed, or not, and post a recommendation for next steps. [https://github.com/endojs/endo/issues/2981](https://github.com/endojs/endo/issues/2981)"*

## The defect (2025-10-07, mhofman, OPEN, labels: bug, next-release)

**Symptom**: `bundleSource` in the `nestedEvaluate` format fails to correctly bind aliased exports (e.g. `export { X as Y }` or `import { X as Y }`). Encountered while syncing endo in agoric-sdk (Agoric/agoric-sdk#12065).

**Reproducer**: lives at [`marshal-failure.test.js` in endojs/endo#2980](https://github.com/endojs/endo/pull/2980) (linked from the issue). That PR is the test-only reproducer; the *fix* (if any) likely lives elsewhere. Pull the test from PR #2980's branch into your worktree to exercise it locally.

**Error shape**: `TypeError: X is not a function` deep in `marshal/src/marshal.js` after import — the alias resolves to `undefined` (because the binding wasn't established) and the call to the missing function throws.

## Task

Three steps:

### Step 1: pull the reproducer

Find PR #2980's head branch and check out `packages/bundle-source/test/marshal-failure.test.js` from it as a local file (don't merge the branch — just copy the one test). Verify the test fails on `refs/heads/upstream-master` head `ec3dcbc0`. If it doesn't fail (or doesn't exist on PR #2980), use `gh pr view 2980 --json files,headRefOid` to find the file/branch and surface what you found in the report.

### Step 2: bisect or grep for fix

If the test fails on current master:
- `git log --oneline --all -S "nestedEvaluate" packages/bundle-source/src/` to find recent touches to the nestedEvaluate format.
- `git log --since=2025-10-07 -- packages/bundle-source/` to see what's landed since the issue was filed.
- Look for any merged PR that touched aliased-export handling in `bundle-source` or `module-source`.

If the test passes on current master, the defect was fixed in some merged PR since 2025-10-07; surface which one (by `git log -S` for the relevant code, or by reading the bundle-source CHANGELOG.md).

### Step 3: recommendation

Write a one-paragraph recommendation, structured around three cases:

- **A**: Test passes on current master → fix already landed. Name the PR/commit. Recommend closing #2981 with a comment citing the fix.
- **B**: Test fails on current master, and a partial fix exists (open PR, draft, abandoned) → name it. Recommend either: a fixer to complete it, OR maintainer to triage further.
- **C**: Test fails, no prior work found → recommend a builder dispatch to write the fix from scratch. Identify the most likely site (`packages/bundle-source/src/nestedEvaluate/` or `import-bundle/` etc) and the kind of fix needed.

Do **not** attempt the fix in this dispatch — verification + recommendation only.

## Per-action authorization

- READ-ONLY everywhere. No pushes, no PR-create, no comments.

## Out of scope

- No code changes.
- No PR-create.
- No upstream comments.

## Report

≤ 300 words, structured:
1. **Test status**: pass/fail/missing on `upstream-master@ec3dcbc0`, with the exact assertion message.
2. **Provenance of PR #2980**: head branch, state, whether the test file exists there.
3. **Bisect / grep findings**: any PR or commit touching the relevant code path since 2025-10-07.
4. **Recommendation**: one of A/B/C above with specifics (PR numbers, file paths).
5. One-line `Self-improvement: ...`.
