---
ts: 2026-05-14T19:39:40Z
kind: dispatch
role: liaison
project: endo-but-for-bots
to: "*"
prs:
  - repo: endojs/endo-but-for-bots
    pr: 240
    role: reference
---

# Dispatch: builder lands Cut 5 of devDep-cycle factoring (@endo/eventual-send-test)

Dispatch root: `dispatches/builder--90af84/`. Project worktree on `endojs/endo-but-for-bots@llm`.

Maintainer directive at [endojs/endo-but-for-bots#240#issuecomment-4447912611](https://github.com/endojs/endo-but-for-bots/pull/240#issuecomment-4447912611) (2026-05-14T05:34Z): "Please rebase on llm and dispatch a builder to finish the last cut of devDep cycle fixing with dedicated test packages." This dispatch covers the builder half; the rebase is a sibling dispatch (`weaver--91d238` on #240).

## Design reference

`designs/break-dev-dependency-cycles.md` on `llm` § Per-cycle cuts § Cut 5: pure devDep deletes (mop-up). After Cuts 1-4 landed (#210 closed Cut 4 / `@endo/harden-test`), two cycle-creating devDeps remain:

- `@endo/eventual-send --devDep--> @endo/lockdown` (used by `lockdown/commit-debug.js` imports across `e.test.js`, `eventual-send.test.js`, `proxy.test.js`, etc.)
- `@endo/eventual-send --devDep--> ses` (transitively pulled by `@endo/lockdown`; same fix)

Resolution per the design: create `@endo/eventual-send-test` package whose `dependencies` are `@endo/eventual-send`, `@endo/lockdown`, `ava`. Move the `lockdown/commit-debug.js`-using tests into the new package. Remove the two cycle-creating devDeps from `packages/eventual-send/package.json`.

## Per-action authorization

Standing on endo-but-for-bots. Branch name: `feat/eventual-send-test` (parallels prior cuts' branch naming: `harden-test`, `hex-test`, etc.).

## Task

1. **Read the design's Cut 5 section in full** before authoring (`designs/break-dev-dependency-cycles.md` § Per-cycle cuts § Cut 5). Then look at how Cut 4 was implemented (PR #210, merge commit on llm) for the file shape and the per-package conventions.
2. **Create `packages/eventual-send-test/`** with the standard shape: `package.json`, `tsconfig.json`, `SECURITY.md` (use the canonical body; the lint check now requires it), and `test/` directory.
3. **Move the `lockdown/commit-debug.js`-using tests** from `packages/eventual-send/test/` into `packages/eventual-send-test/test/`. The design says "e.test.js, eventual-send.test.js, proxy.test.js" — verify by grep before moving.
4. **Update `packages/eventual-send/package.json`** to remove the two cycle-creating devDeps (`@endo/lockdown`, `ses`) — keep them only if a non-moved test still imports them.
5. **Local validation**: `yarn install && yarn workspace @endo/eventual-send-test test && yarn workspace @endo/eventual-send test`. Both packages' tests must pass.
6. **Verify the cycle is gone**: `bash scripts/check-dependency-cycles.sh` (or equivalent) — the SCC reported in the design should now decompose.
7. **Open the PR as DRAFT** per `skills/pr-creation-flow/SKILL.md` § Draft discipline. Title: `feat(eventual-send,eventual-send-test): break devDep cycle via @endo/eventual-send-test (Cut 5 of #206 design)`. Body cites the design and references prior cuts.
8. **Yarn lock**: a separate commit `chore: Update yarn.lock` per `skills/yarn-lock-separate-commit/SKILL.md`.

## Out of scope

- No upstream ferry. The boatman re-ferries when the maintainer asks.
- No edit to #240; the sibling weaver handles that.
- No un-draft. The cleaner + judge run via the steward's per-cycle scan after the builder's `result` lands.

## Report

≤ 300 words: PR URL, head SHA, files touched (count by directory), local test results, whether the cycle is verifiably gone, one-line `Self-improvement: ...`.
