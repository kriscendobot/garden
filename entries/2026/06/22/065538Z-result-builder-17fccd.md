---
ts: 2026-06-22T06:55:38Z
kind: result
role: builder
worktree: dispatches/builder--17fccd/project
repo: endojs/endo-but-for-bots
project: endo-but-for-bots
---

Rebased PR #440 (`feat/formula-inspector`) onto current `origin/llm` (`0458d1fbd`, which migrated chat to confined Preact). 22 commits retained; one commit (`5507a3402 chore(chat): replace gear character literal with String.fromCodePoint`) was skipped because its only target was the imperative `packages/chat/inventory-component.js`, which the Preact rewrite deleted on llm and `f44cf51f5` (gear-removal) already finished retiring.

The architectural shift on llm replaced `packages/chat/inventory-component.js` with a confined-Preact tree under `packages/chat/inventory/` and rewrote `packages/chat/value-component.js` to use `renderConfined` + hooks. The PR's substantive formula-inspector affordances live on `value-component.js` (modal-header gear, F key, Shift+P, Backspace back-stack, back-face render, focusRemote placeholder), and the host-DOM nodes for the back face (`#value-back-face`, `#value-flip-to-formula`, `#value-flip-to-value`, `#value-aria-live`) sit on the imperative host-controller boundary that the new architecture already documents. The port therefore composes cleanly: front-face content stays in the confined `$valueMount` / `$actionsMount` (with `unmount()` in place of `.innerHTML = ''`), and the back-face controller is imperative against host nodes.

The PR's `f44cf51f5` had already removed the per-row gear icon and the `showValueFormula` / `focusValueFormula` plumbing, so no inventory-row gear porting was needed. The conflict in `chat.js` (PR-era single `inventoryComponent({showValueFormula,...})` call vs llm's `if (isChannelMode) channelListComponent else inventoryComponent` split) was resolved by taking llm's structure and dropping the obsolete `showValueFormula` parameter.

Test results: `corepack yarn workspace @endo/chat test` — 668 passed, 0 failed. Flip-specific tests (`value-component-flip.test.js`) including aria-live, Remote-Type placeholder, ephemeral-value back face all green. Pre-existing typecheck noise in `value-component.js`(163) `copy does not exist on props` and `space-inventory-graph` / `space-whylip` errors inherited from origin/llm and not regressions.

`pre-push-gates --summary`: yarn format and yarn lint pass; no new probe findings against changed files (the sentence-per-line and no-non-ascii flags are on pre-existing repo files, mostly under `TADA/`, `designs/`, `9p-server`, etc.).

Force-pushed with lease anchor `065893043` -> `403217826`. PR is `MERGEABLE` per `gh pr view 440 --json mergeable`. Posted top-level summary comment at-mentioning @kriskowal.

Self-improvement: nothing this time.
