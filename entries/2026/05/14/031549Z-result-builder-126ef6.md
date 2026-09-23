---
ts: 2026-05-14T03:15:49Z
kind: result
role: builder
project: endo-but-for-bots
worktree: dispatches/builder--prettier-underscore-thousands--20260514-025935--9d6a2e/project
repo: endojs/endo-but-for-bots
---

Opened draft PR endojs/endo-but-for-bots#243 ("chore(eslint-plugin): require underscore-delimited groups in numeric literals").
Three commits on `chore/eslint-numeric-separators-style`: a config commit adding the rule to `@endo/internal`, a standalone `yarn.lock` update, and the `eslint --fix` migration across 83 files.

Tool: `eslint-plugin-unicorn`'s `numeric-separators-style` rule (version `^56.0.1`, the last line compatible with ESLint 8.57.1 which this repo pins).
The Prettier route is unavailable: Prettier ships no numeric-grouping option, the `eslint-plugin-use-numeric-separator` package is deprecated, and `prettier-plugin-numeric-separator` does not exist on npm.

Config: rule added to `packages/eslint-plugin/lib/configs/internal.js` with the unicorn defaults (`number: { minimumDigits: 5, groupLength: 3 }`, `hexadecimal: { groupLength: 2 }`, `binary`/`octal: { groupLength: 4 }`, `onlyIfContainsSeparator: false`).
`eslint-plugin-unicorn` is declared a `peerDependency` of `@endo/eslint-plugin` (the package is published, so a hard `dependency` would be too aggressive) and a `devDependency` at the monorepo root so the pnpm-linker resolves it from every workspace package.
Changeset added for `@endo/eslint-plugin@minor`.

Autofix migrated 83 files; `yarn lint:eslint` is clean (0 errors), `yarn lint:prettier` is clean.
Five files received unrelated auto-fixes during the `eslint --fix` run (a jsdoc-prefer-tags row, a prettier-style array reflow); those were reverted before staging so the migration commit stays scoped to numeric literals.
One side-effect of `minimumDigits: 5`: pre-existing `1_000` and `5_000` literals get stripped to `1000` / `5000`, which is the rule's correct behavior (separators communicate magnitude only when the number is long enough).

Gotchas surfaced:
- Setting `eslint-plugin-unicorn` only as a dep of `@endo/eslint-plugin` produces "ESLint couldn't find the plugin" at the consumer packages under pnpm linking; the plugin must be reachable from every workspace package, which requires either root-level installation or a peerDependency relationship.
- String literals containing digit sequences (URL fragments, color codes, default-value strings) are untouched because the rule operates on AST numeric literals.

Verdict: cleanly enforceable. The rule has `--fix` support, the migration completed without false-positive autofixes, and the lint check converges to zero errors on every package.

Self-improvement: nothing this time.
