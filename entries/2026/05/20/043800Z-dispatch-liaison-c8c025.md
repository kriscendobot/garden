---
ts: 2026-05-20T04:38:00Z
kind: dispatch
role: liaison
project: endo-but-for-bots
to: fixer
prs:
  - repo: endojs/endo-but-for-bots
    pr: 74
    role: target
  - repo: endojs/endo
    pr: 3241
    role: source
---

# Dispatch: fixer carries boneskull feedback from upstream endojs/endo#3241 to our mirror #74

Dispatch root: `dispatches/fixer--c8c025/`. Project worktree on `endojs/endo-but-for-bots@design/audit-module-source-visitors` (head `e9631f575`).

Maintainer directive (2026-05-20): *"Please apply feedback on https://github.com/endojs/endo/pull/3241 to our mirror of that PR in endo-but-for-bots."*

Our mirror = [endojs/endo-but-for-bots#74](https://github.com/endojs/endo-but-for-bots/pull/74), `fix(module-source): make analyzer robust to export-namespace and Hub-less paths (#1596)`.

## Upstream feedback (boneskull on #3241)

Upstream PR is APPROVED by boneskull; two non-blocking inline review-comments remain:

1. **`packages/module-source/src/transform-source.js:33`** — suggestion block (apply verbatim per `skills/pr-review-thread-replies/SKILL.md` shape):
   ```jsdoc
    * @param {File} ast - the parsed Babel `File` node.
    * @returns {NodePath} a `NodePath` whose child paths inherit a `Hub`.
   ```
   This rewords the existing `@param` / `@returns` JSDoc for the helper that wraps an AST in a `NodePath` with a `Hub`.

2. **`packages/module-source/test/module-source.test.js:463`** — *"might be better expressed as a custom assertion message to `t.notRegex`"*.
   Read the test at line 463 in context. The existing pattern is likely a manual conditional + `t.fail()` / explicit throw with a custom message. AVA's `t.notRegex(value, regex, message?)` accepts a custom third-argument message that surfaces on failure. Replace the manual shape with `t.notRegex(value, regex, 'custom message about what we expected')`.

## Task

Read `garden/roles/COMMON.md` + `garden/roles/fixer/AGENT.md` + `garden/skills/review-feedback-followup-commits/SKILL.md` + `garden/skills/pr-review-thread-replies/SKILL.md` first.

1. **Verify** the two files are at the same locations on our mirror branch `e9631f575` as on upstream `3241`. Read both files first.

2. **Apply** the JSDoc suggestion verbatim (single-line replace at line 33 of `transform-source.js`).

3. **Refactor** the test at `module-source.test.js:463` to use `t.notRegex(value, regex, customMessage)`. The `customMessage` should capture what the prior manual error message said — preserve the intent.

4. **Local validation**:
   - `yarn workspace @endo/module-source lint:types` — types still pass (the JSDoc edit may shift inference).
   - `yarn workspace @endo/module-source test` — confirm the refactored test still asserts the same thing.
   - `yarn lint:prettier --check packages/module-source/src/transform-source.js packages/module-source/test/module-source.test.js`.

5. **Commit shape** (per `skills/review-feedback-followup-commits/SKILL.md` — author-only/message-only amend carve-out does NOT apply here; these are real edits):
   - Separate commits per concern, OR a single commit with a multi-bullet body. Single commit is fine for two related boneskull asks.
   - Subject: `fix(module-source): apply boneskull review feedback from upstream #3241`.
   - Body cites the two review-thread anchors (the upstream PR URLs/IDs from the review comments above).

6. **Push** via `git push origin HEAD:design/audit-module-source-visitors`. Force-with-lease=`e9631f575`. Per today's recurring self-improvement: commit + push BEFORE extended local validation.

7. **Reply to the two upstream review threads** per `skills/pr-review-thread-replies/SKILL.md` — confirm the change landed on our mirror and reference the new head SHA. **Per-action authorization**: comment on `endojs/endo` is READ-ONLY by default, but per the directive of *applying feedback to the mirror*, the reply landing on **our mirror PR #74** is the expected surface. So: post the reply threads on `endo-but-for-bots#74`, not upstream. Do NOT post on upstream `endojs/endo#3241`.

## Per-action authorization

Standing on endo-but-for-bots: force-push to `design/audit-module-source-visitors` with lease. Reply to review threads on **endo-but-for-bots#74** only. READ-ONLY on `endojs/endo` upstream (no comment posting there).

## Out of scope

- No upstream ferry — boatman handles when authorized.
- No edits beyond the two boneskull asks.
- No PR body / title edits.
- No comment on upstream `endojs/endo#3241`.

## Report

≤ 300 words: files edited, commit SHA, new head SHA after force-push, the two thread-reply URLs (on #74), local-validation outcome, one-line `Self-improvement: ...`.
