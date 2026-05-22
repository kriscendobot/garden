---
ts: 2026-05-22T01:50:24Z
kind: result
role: fixer
project: endo-but-for-bots
prs:
  - repo: endojs/endo
    pr: 3274
    role: source
  - repo: endojs/endo-but-for-bots
    pr: 67
    role: mirror
refs:
  - entries/2026/05/22/013728Z-dispatch-liaison-8253c6.md
---

# Result: fixer carried endojs/endo#3274 feedback onto endo-but-for-bots#67

Branch `design/issue-2390-harden-exports-patterns` rebased onto `origin/master` (clean, two-commit replay), then three follow-up commits landed on top. Final head SHA `792f00279`. Push was `--force-with-lease` (rebase required it); the lease held.

## In-scope items (3, all addressed)

1. Copilot inline (https://github.com/endojs/endo/pull/3274#discussion_r3283071342) — `pushDeclaredNames` docstring said `export const ...` but the visitor accepts any `VariableDeclaration` (`let` / `var` too). Widened the docstring to name all three kinds; did not tighten the rule's behavior (out of scope; the pre-PR rule already accepted `let` / `var`). Commit `27d8be9f5`.
2. Copilot inline (https://github.com/endojs/endo/pull/3274#discussion_r3283071402) — when `pushDeclaredNames` returns false the rule was emitting both `unknownBindingPattern` AND a missing-harden report drawn from the possibly incomplete name list, with an autofix that could insert wrong `harden(...)` calls. Added `allRecognized` flag per export; missing-harden check + autofix are skipped when it goes false. No test fixture: the default branch is structurally unreachable through standard JS / TS ESLint parsers in `VariableDeclarator.id` position. Commit `7b8199b2d`.
3. turadg inline (https://github.com/endojs/endo/pull/3274#discussion_r3283008803) — "I'm not sure the plurality declension is worth the code logic. Consider simplifying." Collapsed `missingHardenCallSingle` / `missingHardenCallMultiple` plus the per-report length-1 branch into one `missingHardenCall` message ("Named export(s) '...' should be followed by a call to 'harden'."). Updated 17 invalid-fixture message strings in the test file. Behavior and autofix unchanged. Commit `792f00279`.

## Out-of-scope items

None. Both reviews (Copilot `COMMENTED` and turadg `APPROVED`) carry no items the fixer skipped.

## Test status

- `packages/eslint-plugin/`: `yarn test` 96 passing (same count as baseline; unchanged behavior in all known shapes).
- `yarn lint` in the eslint-plugin package: clean (exit 0).
- `yarn docs` at repo root: built; 67 warnings (all pre-existing, none from changed files).
- `pre-push-gates --no-auto-fix`: only `security-md-hash-uniform` fails, on `packages/{immutable-arraybuffer,bytes,hex,panic}/SECURITY.md`. Repo-wide pre-existing divergence; unrelated to this PR. The gate's `--auto-fix` mode also wanted to touch `packages/evasive-transform/src/index.js` (whitespace) and `packages/ses/src/compartment.js` (JSDoc); both reverted before each commit so the PR's diff stays scoped to `packages/eslint-plugin/`.

## Citations not made

Per the dispatch authorization, no comments on either the upstream PR or the bot mirror PR, no reply on any upstream review thread. Boatman handles the upstream-side replies when authorized.

Self-improvement: when a defensive code branch is structurally unreachable through the available parsers, the fixer's "no test fixture" note belongs in the commit message itself (not only the journal result), so a future reviewer who grep-finds the commit reads the rationale without round-tripping to the dispatch entry. Applied this turn in commit `7b8199b2d`; worth a one-liner in `skills/review-feedback-followup-commits/SKILL.md` under *Patterns that trigger a deeper read* if it recurs.
