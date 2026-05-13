---
ts: 2026-05-13T21:31:20Z
kind: result
role: builder
worktree: dispatches/builder--rps-demo-distributed-game--20260513-211957--bbc4a4/project
repo: endojs/endo-but-for-bots
project: endo-but-for-bots
refs:
  - entries/2026/05/13/211936Z-dispatch-liaison-bbc4a4.md
---

Opened draft PR endojs/endo-but-for-bots#238 (https://github.com/endojs/endo-but-for-bots/pull/238) on topic branch `feat/rps-demo` against base `llm`, adapting the two-player Rock Paper Scissors game from endojs/playground#14 into a proper Endo daemon plugin package at `packages/rps-demo/`.

Package layout:

- `packages/rps-demo/index.js` (re-exports)
- `packages/rps-demo/src/rock-paper-scissors.js` (daemon plugin: `make()` returns an `Attacker` exo; one-shot `attack(choice)` returns a fresh `Defender` exo, whose `defend(choice)` resolves the round via the scoring function; both methods are guarded with `M.interface(...)` patterns)
- `packages/rps-demo/src/score.js` (pure scoring function with a hardened `defeats` table; no SES dependency)
- `packages/rps-demo/test/score.test.js` (6 tests; exhaustive over every pair of choices and every outcome shape)
- `packages/rps-demo/test/rock-paper-scissors.test.js` (8 tests; single-round verdicts, draws, pattern-guard rejections, one-shot attack discipline, late-bound `getResult`, parallel games)
- `packages/rps-demo/README.md` (the teaching narrative: package purpose, capability sketch, two ways to run it, why this shape)
- Standard skel boilerplate (`package.json`, `tsconfig*.json`, `CHANGELOG.md`, `LICENSE`, `SECURITY.md`)

Local pre-PR checks: `yarn lint` clean, `yarn lint:types` clean, `yarn ava` 14/14 passing. Regression evidence: inverted the `defeats` table to confirm 7 of 14 tests went red on the relevant assertions, then restored.

Adapted vs preserved: preserved the `Attacker`/`Defender` exo split and the scoring table from the playground PR; rewrote the scoring as a pure function in its own module (`src/score.js`) so it can be unit-tested without SES, and moved validation to the exo boundary rather than calling `mustMatch` inside `score`. Dropped the playground PR's incidental material (`chat-page.js`, `message-format.js`, `message-parse.js`, and the vendored `endo-daemon.d.ts`) as out of scope for a teaching demo focused on the plugin shape itself. The README walks the reader through `score.js` to `rock-paper-scissors.js` and explains why the capability discipline (one-shot attack, daemon as trusted third party) makes the demo interesting beyond the game itself.

Two commits on the branch:

- `feat(rps-demo): Rock Paper Scissors as an Endo daemon plugin` (12 files, 811 insertions)
- `chore: Update yarn.lock` (20 insertions)

Identity: kriscendobot.

Self-improvement: nothing this time. The pr-creation-flow draft discipline, the project's `*.test.js` naming, the `@endo/ses-ava/prepare-endo.js` test prelude, and the separate-yarn-lock-commit rule are all already documented in their canonical homes and were applied without surprise.
