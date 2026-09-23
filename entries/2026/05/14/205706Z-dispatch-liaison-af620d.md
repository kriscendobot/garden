---
ts: 2026-05-14T20:57:06Z
kind: dispatch
role: liaison
project: endo-but-for-bots
to: "*"
prs:
  - repo: endojs/endo
    pr: 2404
    role: source
---

# Dispatch: fixer mirrors endo#2404 (harden-exports destructuring) onto bots fork + applies gibson042 feedback

Dispatch root: `dispatches/fixer--af620d/`. Project worktree on `endojs/endo-but-for-bots@master` (detached). Per the implementation-on-master rule (mirror lives on master, ferries upstream from there).

## The original

[endojs/endo#2404](https://github.com/endojs/endo/pull/2404) by @turadg, open and DRAFT, on branch `2390-destructuring` at upstream head `70e4e559`. Title: `support destructuring in harden-exports`. Two commits (chore: ignore Aider files; feat: destructured exports in harden-exports). Four files: `.gitignore`, `packages/eslint-plugin/lib/index.js`, `packages/eslint-plugin/lib/rules/harden-exports.js`, `packages/eslint-plugin/test/harden-exports.test.js`.

The upstream branch was fetched into the bots-fork bare clone as `upstream-2390-destructuring` so the dispatch worktree can access it.

## gibson042's review feedback (two inline comments to address)

1. **`packages/eslint-plugin/lib/rules/harden-exports.js` line 64**:
   > This is missing the recursive case in which `prop.value.type` is itself an ObjectPattern or ArrayPattern (e.g., `export const { wrapper: { propName } } = objWithWrapper;` and `export const [{ wrapper: { propName: exportName } }] = [objWithWrapper];`). That was true before as well, but if we're making...

   Action: extend the destructuring-aware export-name extractor to recurse through nested `ObjectPattern` / `ArrayPattern` cases. Add test cases covering both nested-object and nested-array shapes.

2. **`packages/eslint-plugin/lib/rules/harden-exports.js` line 117**:
   > This whole block could really use some commentary/substructure/etc.

   Action: refactor the block at line 117 with clear sectioning + JSDoc comments explaining each pass. If the block's substantive logic warrants a helper function, extract one.

## Per-action authorization

Standing on endo-but-for-bots: push, open the draft PR. READ-ONLY on endojs/endo (no comment on #2404; the boatman ferries the addressed-feedback comment later).

## Task

1. **Branch the mirror.** Fetch `upstream-2390-destructuring` into the dispatch worktree. Create a fork-side branch `feat/harden-exports-destructuring` off it (or, alternatively, off `master` with the diff replayed — pick whichever produces a cleaner history; cherry-pick of the two commits is the natural shape).

2. **Apply gibson042's feedback.** Two issues:
   - **Recursive nested patterns**: extend the extractor in `harden-exports.js` to handle `ObjectPattern` / `ArrayPattern` recursively. Add test cases in `harden-exports.test.js` matching gibson042's examples (`export const { wrapper: { propName } } = ...` and `export const [{ wrapper: { propName: exportName } }] = ...`) and any additional shape combinations the rule should handle.
   - **Commentary + substructure** at line 117: refactor with sectioning + JSDoc. The refactor must not change behavior; verify by running existing tests before and after.

3. **Run the test suite.** `yarn workspace @endo/eslint-plugin test`. All passing per the rebased branch (including the new test cases).

4. **Commit shape**: prefer two commits — one for the recursive-case fix + tests, one for the commentary/substructure refactor. Or fold per a `pr-formation` judgment if a single commit reads cleaner.

5. **Open as DRAFT PR** on `endo-but-for-bots@master`. Branch: `feat/harden-exports-destructuring`. Title: `feat(eslint-plugin): support destructuring in harden-exports (mirror of endojs/endo#2404 + gibson042 feedback)`. Body cites the upstream PR + gibson042's two comments + describes the recursive-case extension and the refactor.

6. **Do NOT un-draft.** The judge un-drafts after the panel loop.

## Out of scope

- No comment on upstream #2404. The boatman routes a summary comment later when the fork-side approves.
- No upstream ferry from this dispatch.
- No re-author of the original turadg commits (preserve them as the base; address the feedback as follow-up commits).

## Report

≤ 300 words: PR URL, head SHA, commits added (one line per), test results, one-line `Self-improvement: ...`.
