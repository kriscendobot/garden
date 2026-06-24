---
ts: 2026-05-14T06:13:47Z
kind: dispatch
role: liaison
project: endo-but-for-bots
to: "*"
prs:
  - repo: endojs/endo-but-for-bots
    pr: 244
    role: target
---

# Dispatch: fixer prettier-formats the 7 files failing lint on #244

Dispatch root: `dispatches/fixer--prettier-fix-244--20260514-061346--7675d7/`. Project worktree at `endojs/endo-but-for-bots@chore/eslint-numeric-separators-style-master`.

#244 is the DRAFT PR that adds the `numeric-separators-style` ESLint rule and applies its autofix across 83 files. The CI `lint` job failed with exit 1; the error is **Prettier formatting drift** in 7 files (per the workflow log at https://github.com/endojs/endo-but-for-bots/actions/runs/25840821811/job/75925562518):

```
[warn] packages/cjs-module-analyzer/index.js
[warn] packages/hex/test/_xorshift.js
[warn] packages/hex/test/decode.bench.js
[warn] packages/hex/test/encode.bench.js
[warn] packages/ocapn/test/_xorshift.js
[warn] packages/ocapn/test/codecs/passable-fuzz.test.js
[warn] packages/ocapn/test/syrup/fuzz.test.js
[warn] Code style issues found in 7 files. Run Prettier with --write to fix.
```

These look like files the underscore-thousands autofix touched, leaving them prettier-non-conformant. The maintainer flagged this as "trigger failed" and the steward's per-cycle PR-creation-flow scan should have picked it up; this dispatch handles it directly.

## Per-action authorization

Standing on endo-but-for-bots (push to the branch). No upstream surface.

## Task

1. **Confirm the diagnosis.** `cd project && yarn install && yarn format:check` (or whatever the `pre-pr-checklist` skill names for prettier-check on this repo) on the 7 named files. Read each file's diff against `yarn format` once to be sure the prettier autofix is benign (no behavior change, just whitespace and quote-style).

2. **Apply prettier.** `yarn format` on the affected files (scope to the 7 if `yarn format` is repo-wide and would touch unrelated files). If `yarn format` is repo-wide and the diff is local to the 7 files, that is fine; just commit only the 7 prettier-fix lines.

3. **Verify locally.** `yarn lint` must pass (the original failure was the `lint` job which runs `yarn lint`; that is the same locally). Note any other pre-existing red signals; do not silence them.

4. **Commit.** One commit with message `chore: prettier --write on autofix-touched files (fix lint job on #244)`. The body cites the failing CI run.

5. **Push.** Fast-forward push to `chore/eslint-numeric-separators-style-master`. The branch is garden-authored on a draft PR; force-with-lease only if a force-push is needed.

6. **Watch CI converge.** `gh pr checks 244 -R endojs/endo-but-for-bots --watch` until either green or only the same pre-existing red signals as before. Do not un-draft.

## Out of scope

- **Do not un-draft #244.** Per the new PR-creation flow (`skills/pr-creation-flow/SKILL.md`), only the judge un-drafts; this fixer just makes CI green so the chain can continue.
- No PR title or body edits.
- No comment on the PR (the standing authorization permits it, but a no-content fix needs no narration).

## Report

≤ 300 words: the prettier diff shape (one-line per file or one summary line; the maintainer does not need the bytes), CI status after the push (lint job conclusion), one-line `Self-improvement: ...` per `skills/self-improvement/SKILL.md`. If the lint failure has a non-prettier component the fix missed, surface it for follow-up.
