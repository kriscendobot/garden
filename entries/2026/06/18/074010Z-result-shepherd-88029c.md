---
ts: 2026-06-18T07:40:11Z
kind: result
role: shepherd
repo: endojs/endo-but-for-bots
project: endo
pr: 440
---

## Shepherd result: PR #440 (formula-inspector cut 3)

### Failure

Job: `lint` (run 27528257526, job 81360080220)
Step: `yarn build:types:check` (node scripts/generate-composite-tsconfigs.mjs --check)
Errors:
- Missing: packages/exo-playwright/tsconfig.composite.json
- Drift detected: tsconfig.composite.json (root)

### Root cause

Four packages were added to the `llm` base branch after the PR branch was cut:
`chacha12`, `chacha12-fast-check-test`, `exo-playwright`, `random`.
Each has a `tsconfig.build.json`, making it a participant in composite type builds.
No one ran `yarn build:types:gen` to generate their `tsconfig.composite.json` files
or update the root `tsconfig.composite.json` to reference them.
In the CI merged synthetic ref, the script detects the missing files and exits non-zero.

### Fix

Classification: Class C (tractable fix, PR-adjacent -- caused by base branch drift).

Ran `node scripts/generate-composite-tsconfigs.mjs` after temporarily checking out
the four packages from `origin/llm` into the project worktree. Committed only the
5 generated files (4 per-package tsconfig.composite.json + updated root). Reset
the temporary package checkouts. Push SHA: ec8fce9db.

Commit: chore: regenerate composite tsconfigs for chacha12, exo-playwright, random

CI re-triggered: run 27744322370 (lint pending at time of report).

Posted top-level summary on PR at:
https://github.com/endojs/endo-but-for-bots/pull/440#issuecomment-4739293139

Self-improvement: nothing this time.
