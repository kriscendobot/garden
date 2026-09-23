---
ts: 2026-05-15T04:25:54Z
kind: result
role: cleaner
project: endo-but-for-bots
repo: endojs/endo-but-for-bots
worktree: dispatches/cleaner--aa99d2/
---

# Result: cleaner coverage pass on PR #251 (harden-exports destructuring)

PR: `endojs/endo-but-for-bots#251` `feat(eslint-plugin): support destructuring in harden-exports`. Mirror of `endojs/endo#2404` with gibson042 feedback applied.

## Coverage delta

Baseline (HEAD `5051d989f`) on `packages/eslint-plugin/lib/rules/harden-exports.js`:

```
% Stmts | % Branch | % Funcs | % Lines | Uncovered Line #s
84.72   | 73.80    | 100     | 84.72   | 64,73,80-82,108-131,175-178
```

After (HEAD `8626e5d78`):

```
% Stmts | % Branch | % Funcs | % Lines | Uncovered Line #s
87.50   | 82.22    | 100     | 87.50   | 80-82,108-131
```

Delta: +2.78 stmts, +8.42 branches. Lines 64 / 73 (rest-element warnings in ObjectPattern / ArrayPattern) and 175-178 (specifier-form export branch, `export { x }`) now covered.

## Commits pushed

- `8626e5d78` `test(eslint-plugin): cover specifier-form exports and rest-element pattern paths` (test additions only; production code unchanged).

Five new `jsValid` cases (one with `parserOptions: { ecmaVersion: 2018 }` for the object-rest syntax) and two new `invalid` cases. Each case verified load-bearing per `skills/regression-evidence/SKILL.md`: breaking the specifier-export branch makes 4 cases fail; breaking the ObjectPattern rest-skip makes 2 fail; breaking the ArrayPattern rest-skip makes 2 fail. Source restored after each break.

## Residual uncovered, by design

- **Lines 80-82** (default branch of `collectPatternNames`). Defensive fallthrough for pattern node types other than `Identifier` / `AssignmentPattern` / `ObjectPattern` / `ArrayPattern`. Not reachable from normal source; closing it would require a contortion test that fabricates a synthetic AST.
- **Lines 108-131** (`ObjectPattern` / `ArrayPattern` argument branches in `argumentReferencesName`). AST verification: `harden({ a, b })` parses as `ObjectExpression`, not `ObjectPattern`; `harden([a])` parses as `ArrayExpression`, not `ArrayPattern`. The branches are dead in both espree and `@typescript-eslint/parser`. They were added in the refactor commit (`5051d989f`) per gibson042's inline review on `endojs/endo#2404` (comment `1874149178`, suggesting commentary/substructure) and the maintainer-supplied code snippet included these branches verbatim. The cleaner does not delete maintainer-supplied code; if the dead-branch question wants a follow-up, the orchestrator dispatches a separate fixer round after maintainer review on this PR.

## CI status

On HEAD `8626e5d78` at report time: 24/27 SUCCESS. The three remaining checks are `test (18.x, macos-15)`, `test (20.x, macos-15)`, `test (24.x, macos-15)`, all `QUEUED` for 25+ minutes without starting. The `test (22.x, macos-15)` job did start after my push and completed SUCCESS, so this is a runner-pool availability backlog on the macos-15 queue (visible across multiple recent branches per `gh run list`), not a regression from my push. Pre-existing infra delay; not blocking for the judge dispatch.

## Pre-existing infra red

None on this PR head; the macos-15 backlog is a runner-pool capacity issue, not a test failure. All 24 completed checks are green.

## Judge dispatch owed next

Yes. Per `roles/cleaner/AGENT.md` § Operating norms, "The cleaner does not un-draft... The orchestrator then dispatches the judge, which runs the jury and (eventually) `gh pr ready <N>`." The PR remains in draft state. Once the macos-15 queue drains and all 27 checks are SUCCESS (or the maintainer accepts the queued-runner state), the orchestrator dispatches a judge on PR #251 to run the code panel.

The PR's commit chain ends at `8626e5d78`:

```
8626e5d78 test(eslint-plugin): cover specifier-form exports and rest-element pattern paths
5051d989f refactor(eslint-plugin): commentary and substructure for harden-exports detector
f82539ec8 fix(eslint-plugin): recurse into nested destructuring patterns in harden-exports
ddcc58cfb feat: destructured exports in harden-exports
```

## Self-improvement

Nothing this time. The cleaner skill's `c8` baseline-and-iterate procedure mapped cleanly onto this project once the package's mocha runner was reachable from `c8` via `corepack yarn dlx c8 ... yarn exec mocha`; the temporary `TMPDIR=$HOME/.tmp` override needed for `yarn dlx` to avoid an `EXDEV` cross-device link error against `/tmp` is a host-specific quirk of this container, not a procedural drift.
