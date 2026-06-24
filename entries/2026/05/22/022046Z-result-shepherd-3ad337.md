---
ts: 2026-05-22T02:20:46Z
kind: result
role: shepherd
project: endo-but-for-bots
repo: endojs/endo-but-for-bots
pr: 67
worktree: dispatches/shepherd--8b3897
---

# Result: shepherd drove PR #67 lint to green (#2390 destructuring branch)

Dispatch context: kriskowal directive 2026-05-22T02:06Z — "When finished shepherding, please squash." Pre-fix CI: 18 pass, 1 fail (`lint`).

## Root cause

Prettier 3 line-length wrap on a test file. `packages/eslint-plugin/test/harden-exports.test.js` had three `message:` keys whose string literal (`"Named export(s) 'X' should be followed by a call to 'harden'."`) sat just over Prettier's 80-col line limit; Prettier wanted the key/value onto two lines. `yarn lint`'s `Checking formatting...` stage failed; `[warn] Code style issues found in the above file. Run Prettier with --write to fix.` No ESLint errors, no test failures, no source-side regression — pure formatting drift introduced when the destructuring-test cases were added (likely under a Prettier 2 author tool).

## Fix

One commit, `style(eslint-plugin): prettier-wrap long error messages in harden-exports tests (#2390)` at `56dac92cb`:
- `packages/eslint-plugin/test/harden-exports.test.js` — three sites where the long `Named export(s) ...` message string moved onto its own line after the `message:` key (8 insertions, 4 deletions).

Pushed to `endojs/endo-but-for-bots:design/issue-2390-harden-exports-patterns` (HEAD now `56dac92cb`, was `792f00279`).

## Local validation

- `npx prettier --write packages/eslint-plugin/test/harden-exports.test.js` → file rewritten (3 sites).
- `yarn lint` → `All matched files use Prettier code style!` + 2 pre-existing JSDoc warnings (`evasive-transform/src/index.js:25` alignment, `ses/src/compartment.js:340` `args` JSDoc) untouched by this PR; both warnings present on master.
- `cd packages/eslint-plugin && yarn test` → 96 passing (no regression).

## Post-fix CI snapshot

- All 18 checks SUCCESS on `56dac92cb` (run [26264395390](https://github.com/endojs/endo-but-for-bots/actions/runs/26264395390)).
- `mergeStateStatus: CLEAN`, `isDraft: false`, `reviewDecision: ""` (no pending review).

## Handoff

Per the dispatch brief and the kriskowal 2026-05-22T02:06Z directive: ready for conductor `--squash`. The 6-commit history on the branch (`76055f2d` builder + `34442339` review-fixer + `27d8be9f` docs + `7b8199b2` suppress + `792f0027` declension refactor + `56dac92c` prettier wrap) collapses cleanly under squash; the PR title `fix(eslint-plugin): harden-exports handles destructuring patterns (#2390)` is the appropriate squash subject.

## Self-improvement

A `yarn lint`'s `Checking formatting...` stage is short-circuited before ESLint (`yarn format:check && yarn lint:eslint` pattern); a Prettier-only failure in a single test file therefore presents as "lint failed" with no further detail in the CI summary. Future shepherd dispatches on a "lint failure, no other CI red" report should `npx prettier --check` the diff'd files before assuming an ESLint error. Already encoded as `roles/shepherd/AGENT.md` § Operating norms ("Prefer the smallest fix"); nothing new to add. `Self-improvement: nothing this time.`
