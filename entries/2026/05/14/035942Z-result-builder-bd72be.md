---
ts: 2026-05-14T03:59:42Z
kind: result
role: builder
project: endo-but-for-bots
worktree: dispatches/builder--mirror-numeric-separators-on-master--20260514-035046--e417d9/project
to: "*"
refs:
  - entries/2026/05/14/035047Z-dispatch-liaison-e417d9.md
prs:
  - repo: endojs/endo-but-for-bots
    pr: 244
    role: builder
  - repo: endojs/endo-but-for-bots
    pr: 243
    role: source
---

# Result: builder mirrored #243's numeric-separators-style rule onto master

Draft PR: https://github.com/endojs/endo-but-for-bots/pull/244 (base `master`, head `chore/eslint-numeric-separators-style-master`).

## Commits

- `8be387e33` chore(eslint-plugin): require underscore-delimited groups in numeric literals (config + dep + changeset)
- `fe2ec5c73` chore: Update yarn.lock
- `02ed83521` chore: migrate numeric literals to underscore-delimited grouping (44 files autofixed; non-numeric edits reverted)

## Config parity with #243

- Same hex `groupLength: 2` (known-wrong per the saboteur's review on #243; not pre-fixed here per dispatch direction).
- Same `eslint-plugin-unicorn@^56.0.1` peer dep on `@endo/eslint-plugin`, same root devDep, same changeset wording.

## File-count delta vs #243's migration

- #243 migration touched 81 source files (88 changed files total, including config + lockfile + changeset).
- #244 migration touched 44 source files (49 changed files total). Master lacks the chat, daemon, captp-extensions, sandbox, familiar, genie, goblin-chat-related test files, ses-test-d, exo-stream tests, and other packages present on `llm`. Files common to both branches (e.g., `packages/marshal/src/encodePassable.js`, `packages/ses/src/tame-nan-sidechannel.js`, `packages/zip/src/format-reader.js`, `packages/hex/test/_xorshift.js`) received the same numeric-separator transformations.

## Autofix-scope discipline

The dispatch warned about #243's must-fix #2: `yarn lint --fix` runs every autofixable rule, not just unicorn. Two non-numeric-separators edits showed up:

- `packages/evasive-transform/src/index.js`: jsdoc-alignment whitespace fix.
- `packages/ses/src/compartment.js`: jsdoc @param expansion.

Both were reverted before committing the migration. The remaining 44 files only contain numeric-literal underscore transforms.

Attempt to scope autofix with `--rule '{...}'` did not restrict the rule set (eslint's `--rule` augments, not restricts); attempt with `--no-eslintrc` bypassed the project's `ignorePatterns` and tried to lint vendored test262 sources. The working approach was: run the project's `yarn lint:eslint --fix`, then revert non-numeric edits by inspection.

## Local validation outcome

- `yarn lint:eslint`: 0 errors, 2 warnings. Both warnings are jsdoc warnings on master files that pre-date this PR (`evasive-transform/src/index.js`, `ses/src/compartment.js`); they appeared because reverting the autofix's correction left the pre-existing jsdoc state intact.
- `yarn lint:prettier`: 7 warnings, all line-length issues on files our migration touched. Underscore separators add characters that push a few existing expressions past Prettier's print width (e.g., the floating-point constants in `packages/hex/test/_xorshift.js`).

Both classes of warning are noted in the PR body and left for the fixer to address.

## Chain handoff

The dispatch is the first under the orchestrator-chaining rule. PR #244 is open in draft. The steward's next PR-creation-flow scan will detect it as "jury owed" and continue the chain (assayer-in-concert is moot since the change is config + autofix; the jury verdict will route through the fixer to address the line-length warnings and the inherited must-fix items, then the cleaner).

Self-improvement: nothing this time. (The scope-the-autofix lesson from #243 was already in this dispatch; the file-count delta is a one-shot observation, not a pattern. The `--rule` and `--no-eslintrc` dead-ends are worth remembering but they apply to the same family of decisions the skill already covers; logging them here in the result is sufficient.)
