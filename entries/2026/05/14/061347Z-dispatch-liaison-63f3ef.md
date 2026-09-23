---
ts: 2026-05-14T06:13:47Z
kind: dispatch
role: liaison
project: endo-but-for-bots
to: "*"
prs:
  - repo: endojs/endo-but-for-bots
    pr: 226
    role: target
  - repo: endojs/endo
    pr: 3255
    role: source-of-feedback
---

# Dispatch: fixer carries turadg's endo#3255 feedback to endo-but-for-bots#226

Dispatch root: `dispatches/fixer--carry-turadg-feedback-to-226--20260514-061345--63f3ef/`. Project worktree at `endojs/endo-but-for-bots@feat/migrate-eslint-plugin-import-x`.

#226 is the bot-side mirror of upstream PR endojs/endo#3255 (`feat(eslint-plugin): migrate to eslint-plugin-import-x`). turadg left a CHANGES_REQUESTED review on #3255 with one substantive inline comment.

## turadg's feedback (verbatim)

[endojs/endo#3255 comment `3229246963`](https://github.com/endojs/endo/pull/3255#discussion_r3229246963) on `.changeset/migrate-eslint-plugin-import-x.md` line 8:

> Fortunately, this isn't true. The new can be aliased to the old.
>
> ```js
> // eslint.config.js
> import importX from 'eslint-plugin-import-x';
>
> export default [
>   {
>     plugins: {
>       import: importX,
>     },
>
>     rules: {
>       'import/no-cycle': 'error',
>       'import/no-unresolved': 'error',
>     },
>   },
> ];
> ```
>
> That's with flat config. I think that's prevalent now but for older configs the package name could be mapped:
>
> ```json
> {
>   "devDependencies": {
>     "eslint-plugin-import": "npm:eslint-plugin-import-x@^4"
>   }
> }
> ```
>
> Please try the aliasing and confirm it works by reverting the suppression edits in this PR.

## Per-action authorization

Standing on endo-but-for-bots (push to the branch, post the summary comment). READ-ONLY on endojs/endo.

## Task

1. **Read the PR.** `gh pr view 226 -R endojs/endo-but-for-bots --json body,title,files`. Skim the diff to understand what "suppression edits" means in this PR's context (likely per-file or per-rule `eslint-disable` comments added because the migration broke `import/no-cycle`-style references that targeted the old plugin's rule names).

2. **Apply the aliasing.** Try turadg's flat-config approach first: in the relevant `eslint.config.js` (or wherever the plugins-map is configured for this project), alias `eslint-plugin-import-x` to the name `import` so existing `import/*` rule references continue to resolve. The garden's host is the bots repo, so the relevant config files live in `packages/eslint-plugin/*` or root `eslint.config.js`. Inspect first; do not assume.

3. **Revert the suppression edits.** Once the aliasing is in place, any inline `eslint-disable` or `eslint-disable-next-line` comments that this PR added *specifically* to silence rules that broke under the rename should come out. Distinguish PR-introduced suppressions from pre-existing ones (the PR's own diff is the boundary; do not revert suppressions outside the PR's diff).

4. **Local validation.** `cd project && yarn install && yarn lint && yarn lint:types`. Note pre-existing failures in the report (do not silence them). If the aliasing works, lint should be clean for the rules that were previously suppressed.

5. **Push.** Force-push or fast-forward push to `feat/migrate-eslint-plugin-import-x` per the branch's history; `--force-with-lease` if a force-push is needed.

6. **Post summary comment on #226.** Use the standing comment authorization on endo-but-for-bots. Title-line the comment with what was carried (e.g., `Carrying upstream turadg feedback (#3255 r3229246963): aliasing instead of suppression`); body cites turadg's comment id and the change applied. **No comment on endojs/endo#3255** (no auth, and the user has not requested cross-repo cross-linking on the upstream side).

## Out of scope

- No PR title or body edits beyond what is needed to match the new shape (if the changeset body needs updating because the migration story changed, that is in scope; but pure title rewording is not).
- No upstream ferry update. The boatman re-ferries later if and when the user asks.
- No re-request review on #226; that is the kriskowal-review-queue's natural flow.

## Report

≤ 300 words: what was changed (file paths), whether the aliasing approach worked or hit a constraint (e.g., a sub-rule that genuinely cannot be aliased), CI status after push, summary-comment URL, one-line `Self-improvement: ...` per `skills/self-improvement/SKILL.md`. If the aliasing does *not* work for some specific rule, surface that as an open question for the maintainer rather than picking a workaround.
